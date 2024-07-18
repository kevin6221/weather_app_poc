import 'package:demobloc/utils/shimmer_utils.dart';
import 'package:demobloc/utils/dialoge_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';
import '../repo/weather_repo.dart';
import '../model/model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();
  WeatherData? currentLocationWeather;
  bool hasLocationPermission = false;
  final formKey = GlobalKey<FormState>();
  List<String> cityList = []; // List to store city names from Firestore

  @override
  void initState() {
    super.initState();
    checkLocationPermission();
    fetchCityList(); // Fetch initial city list
  }

  Future<void> checkLocationPermission() async {
    loc.Location location = loc.Location();
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.granted) {
      setState(() {
        hasLocationPermission = true;
      });
      fetchCurrentLocationWeather();
    } else {
      permissionGranted = await location.requestPermission();
      if (permissionGranted == loc.PermissionStatus.granted) {
        setState(() {
          hasLocationPermission = true;
        });
        fetchCurrentLocationWeather();
      } else if (permissionGranted == loc.PermissionStatus.denied) {
        showPermissionDeniedDialog(context);
      }
    }
  }

  Future<void> fetchCurrentLocationWeather() async {
    try {
      loc.Location location = loc.Location();
      loc.LocationData locationData = await location.getLocation();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          locationData.latitude!, locationData.longitude!);
      Placemark placemark = placemarks[0];
      String city = placemark.locality!;
      WeatherData weatherData = await WeatherRepository.fetchWeatherData(city);
      setState(() {
        currentLocationWeather = weatherData;
      });
    } catch (e) {
      debugPrint('Error fetching location and weather: $e');
      showLocationFetchErrorDialog(context); // Show dialog on error
    }
  }

  Future<void> fetchCityList() async {
    QuerySnapshot citySnapshot =
        await FirebaseFirestore.instance.collection('weatherData').get();
    setState(() {
      cityList =
          citySnapshot.docs.map((doc) => doc['cityName'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!hasLocationPermission) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Location Permission Required'),
          backgroundColor: Colors.green[100],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Please grant location permission to use this app.',
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: () {
                  checkLocationPermission();
                },
                child: const Text('Grant Permission'),
              ),
            ],
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => WeatherBloc(),
      child: WeatherPageContent(
        formKey: formKey,
        cityController: _cityController,
        currentLocationWeather: currentLocationWeather,
        cityList: cityList,
      ),
    );
  }
}

class WeatherPageContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController cityController;
  final WeatherData? currentLocationWeather;
  final List<String> cityList;

  const WeatherPageContent({
    Key? key,
    required this.formKey,
    required this.cityController,
    required this.currentLocationWeather,
    required this.cityList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.green[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CitySearchDelegate(cityList),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherInitial || state is WeatherLoaded) {
              return Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 15,),
                    currentLocationWeather != null
                        ? Card(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 50, right: 50, top: 5, bottom: 5),
                              child: Column(
                                children: [
                                  Text(
                                    "Current Weather in ${currentLocationWeather!.cityName ?? ""}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'Temperature: ${currentLocationWeather!.temperature}°C',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    'Humidity: ${currentLocationWeather!.humidity}%',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const currentWeather_shimmer(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: cityController,
                        decoration: const InputDecoration(
                          labelText: 'Enter city name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter City Name';
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Only fetch weather if the form is valid
                          context.read<WeatherBloc>().add(
                                WeatherFetchEvent(cityController.text.trim()),
                              );
                          cityController.clear();
                        }
                      },
                      child: const Text('Fetch Weather'),
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('weatherData')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: listWeather_shimmer(),
                            );
                          }
                          final List<DocumentSnapshot> documents =
                              snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot doc = documents[index];
                              return Dismissible(
                                key: Key(doc.id),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  FirebaseFirestore.instance
                                      .collection('weatherData')
                                      .doc(doc.id)
                                      .delete();
                                },
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                child: Card(
                                  margin: const EdgeInsets.all(6),
                                  child: ListTile(
                                    title: Text(doc['cityName'] ?? ''),
                                    subtitle: Text(
                                      'Temperature: ${doc['temperature']}°C, Humidity: ${doc['humidity']}%',
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is WeatherLoading) {
              return const CircularProgressIndicator();
            } else if (state is WeatherError) {
              // Show dialog for error state
              return AlertDialog(
                title: const Text('Error'),
                content: Text(state.message),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const WeatherPage(),
                      )); // Close dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

class CitySearchDelegate extends SearchDelegate<String> {
  final List<String> cityList;

  CitySearchDelegate(this.cityList);

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for search bar (e.g., clear query button)
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the search bar
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show search results based on query
    final List<String> filteredCities = cityList.where((city) {
      return city.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredCities.length,
      itemBuilder: (context, index) {
        final String city = filteredCities[index];
        return ListTile(
          title: Text(city),
          onTap: () {
            close(context, city);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions based on query
    final List<String> filteredCities = cityList.where((city) {
      return city.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredCities.length,
      itemBuilder: (context, index) {
        final String city = filteredCities[index];
        return ListTile(
          title: Text(city),
          onTap: () {
            close(context, city);
          },
        );
      },
    );
  }
}
