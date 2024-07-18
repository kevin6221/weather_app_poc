import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


// ignore: camel_case_types
class currentWeather_shimmer extends StatelessWidget {
  const currentWeather_shimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Shimmer.fromColors(
            period: const Duration(seconds: 2),
            baseColor: Colors.black.withOpacity(0.1),
            highlightColor: Colors.black.withOpacity(0.2),
            child: Container(
              height: (MediaQuery.of(context).size.height * 0.025).floorToDouble(),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
            // highlightColor: Colors.yellow,
          ),
        );
      },
      itemCount: 3,
    );
  }
}

// ignore: camel_case_types
class listWeather_shimmer extends StatelessWidget {
  const listWeather_shimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Shimmer.fromColors(
            period: const Duration(seconds: 2),
            baseColor: Colors.black.withOpacity(0.1),
            highlightColor: Colors.black.withOpacity(0.2),
            child: Container(
              height: (MediaQuery.of(context).size.height * 0.04).floorToDouble(),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
            // highlightColor: Colors.yellow,
          ),
        );
      },
      itemCount: 10,
    );
  }
}