import 'package:carousel_slider/carousel_slider.dart';
import 'package:countries_app/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "package:flutter_map/flutter_map.dart";

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.countryDetails});

  final Map countryDetails;

  @override
  Widget build(BuildContext context) {
    NumberFormat numberFormat = NumberFormat.decimalPatternDigits();
    double gap = 5;
    double breakSpace = 20;
    String countryName = language == "eng"
        ? countryDetails["name"]["common"]
        : countryDetails["translations"][language]["common"];
    String officialName = language == "eng"
        ? countryDetails["name"]["official"]
        : countryDetails["translations"][language]["official"];
    String flagUrl = countryDetails["flags"]["png"];
    // String? mapUrl = countryDetails["maps"]["openStreetMaps"];
    String? coatOfArmsUrl = countryDetails["coatOfArms"]["png"];
    // List states = countryDetails[""];
    int? population = countryDetails["population"];
    String? capitalCity = countryDetails["capital"]?[0];
    // String currentPresident = countryDetails[""];
    String? continent = countryDetails["continents"]?[0];
    List? timezones = countryDetails["timezones"];
    String? drivingSide = countryDetails["car"]?["side"];
    String? startOfWeek = countryDetails["startOfWeek"];
    String? countryCode = (countryDetails["idd"] as Map).isEmpty
        ? null
        : "${countryDetails["idd"]?["root"]}${countryDetails["idd"]?["suffixes"]?[0]}";
    List? spokenLanguage =
        (countryDetails["languages"] as Map?)?.values.toList();
    Map? currency = countryDetails["currencies"];

    return Scaffold(
      appBar: AppBar(title: Text(countryName)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: [
                Image.network(
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  width: double.infinity,
                  flagUrl,
                  fit: BoxFit.cover,
                ),
                if (coatOfArmsUrl != null)
                  Image.network(
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    coatOfArmsUrl,
                    fit: BoxFit.cover,
                  ),
                // FlutterMap(
                //   options: const MapOptions(),
                //   children: [
                //     TileLayer(
                //       urlTemplate: mapUrl,
                //       userAgentPackageName: "com.example",
                //     ),
                //   ],
                // )
              ],
              options: CarouselOptions(
                viewportFraction: 1,
                padEnds: false,
                height: MediaQuery.sizeOf(context).width / 1.6,
                autoPlay: false,
                enableInfiniteScroll: false,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(width: 10),
                    if (capitalCity != null) Text(capitalCity)
                  ],
                ),
                SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text(numberFormat.format(population)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Official name: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(
                          softWrap: true,
                          officialName,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: gap),
                  if (timezones != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Time-zones: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            softWrap: true,
                            timezones.join(", "),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: gap),
                  if (continent != null)
                    Row(
                      children: [
                        Text(
                          "Continent: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          continent,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  SizedBox(height: gap),
                  if (spokenLanguage != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Offical Language: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            softWrap: true,
                            spokenLanguage.join(", "),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: breakSpace),
                  if (currency != null)
                    Row(
                      children: [
                        Text(
                          "Currency: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${currency.values.toList()[0]["name"]} (${currency.keys.toList()[0]}), ${currency.values.toList()[0]["symbol"]}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  SizedBox(height: gap),
                  if (startOfWeek != null)
                    Row(
                      children: [
                        Text(
                          "Start of the week: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          startOfWeek,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  SizedBox(height: gap),
                  if (countryCode != null)
                    Row(
                      children: [
                        Text(
                          "Country code: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          countryCode,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  SizedBox(height: gap),
                  if (drivingSide != null)
                    Row(
                      children: [
                        Text(
                          "Driving Side: ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          drivingSide,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
