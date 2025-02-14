import 'package:carousel_slider/carousel_slider.dart';
import 'package:countries_app/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.countryDetails});

  final Map countryDetails;

  @override
  Widget build(BuildContext context) {
    print(countryDetails);
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
    String mapUrl = countryDetails["maps"]["googleMaps"];
    String? mapUrl2 = countryDetails["maps"]["openStreetMaps"];
    String? coatOfArmsUrl = countryDetails["coatOfArms"]["png"];
    // List states = countryDetails[""];
    int population = countryDetails["population"];
    String capitalCity = countryDetails["capital"][0];
    // String currentPresident = countryDetails[""];
    String continent = countryDetails["continents"][0];
    String timezones = countryDetails["timezones"][0];
    String drivingSide = countryDetails["car"]["side"];
    String startOfWeek = countryDetails["startOfWeek"];
    String countryCode =
        countryDetails["idd"]["root"] + countryDetails["idd"]["suffixes"][0];
    List spokenLanguage = (countryDetails["languages"] as Map).values.toList();
    Map currency = countryDetails["currencies"];

    return Scaffold(
      appBar: AppBar(title: Text(countryName)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: [
                Image.network(
                  flagUrl,
                  fit: BoxFit.cover,
                ),
                if (coatOfArmsUrl != null)
                  Image.network(
                    coatOfArmsUrl,
                    fit: BoxFit.cover,
                  ),
                Image.network(
                  mapUrl,
                  fit: BoxFit.cover,
                ),
                // if (mapUrl2 != null)
                //   Image.network(
                //     mapUrl2,
                //     fit: BoxFit.cover,
                //   ),
              ],
              options: CarouselOptions(
                viewportFraction: 1,
                padEnds: false,
                height: MediaQuery.sizeOf(context).width / 2,
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
                    Icon(Icons.access_time),
                    SizedBox(width: 10),
                    Text(timezones)
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
                  Row(
                    children: [
                      Text(
                        "Capital: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        capitalCity,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  SizedBox(height: gap),
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
                  Row(
                    children: [
                      Text(
                        "Offical Language: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        spokenLanguage.join(", "),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  SizedBox(height: breakSpace),
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
