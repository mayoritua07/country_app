import 'dart:convert';

import 'package:countries_app/details_screen.dart';
import 'package:countries_app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.toggleTheme});

  final void Function() toggleTheme;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List countriesData = [];
  List activeCountriesData = [];
  Map<String, String> acceptedLanguages = {
    "Arabic ": "ara",
    "Deutschland": "deu",
    "Dutch": "nld",
    "English": "eng",
    "Finnish": "fin",
    "French": "fra",
    "Hungrarian": "hun",
    "Italian": "ita",
    "Japanese": "jpn",
    "Korean": "kor",
    "Portuguese": "por",
    "Russian": "rus",
    "Spanish": "spa",
    "Swedish": "swe",
    "Turkish": "tur",
  };
  List<String> continents = [
    "Africa",
    "Antarctica",
    "Asia",
    "Australia",
    "Europe",
    "North America",
    "South America",
  ];
  List<String> timeZones = [
    "UTC-06:00",
    "UTC-05:00",
    "UTC-04:00",
    "UTC-03:00",
    "UTC-02:00",
    "UTC-01:00",
    "UTC",
    "UTC+01:00",
    "UTC+02:00",
    "UTC+03:00",
    "UTC+04:00",
    "UTC+05:00",
    "UTC+06:00",
  ];
  List timezoneFilters = [];
  List continentFilters = [];

  void showDetalsScreen(Map countryDetails) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailsScreen(
          countryDetails: countryDetails,
        ),
      ),
    );
  }

  void changeLanguage(val) {
    setState(() {
      language = val;
      activeCountriesData = sortMyList(activeCountriesData, language);
    });
  }

  Future<void> getData() async {
    if (countriesData.isNotEmpty) {
      return;
    }
    final url = Uri.parse(countriesUrl);
    final response = await http.get(url);
    countriesData = jsonDecode(response.body);

    countriesData = sortMyList(countriesData, "eng");
    activeCountriesData = List.from(countriesData);
  }

  List sortMyList(List myList, String translation) {
    myList.sort(
      (a, b) {
        int answer = -1;
        List<int> firstLetterAscii;
        List<int> secondLetterAscii;
        if (translation == "eng") {
          firstLetterAscii = (a["name"]["common"] as String).codeUnits;
          secondLetterAscii = (b["name"]["common"] as String).codeUnits;
        } else {
          firstLetterAscii =
              (a["translations"][translation]["common"] as String).codeUnits;
          secondLetterAscii =
              (b["translations"][translation]["common"] as String).codeUnits;
        }

        for (int index = 0; index < firstLetterAscii.length; index++) {
          if (index == secondLetterAscii.length) {
            return 1;
          }
          int answer =
              firstLetterAscii[index].compareTo(secondLetterAscii[index]);

          if (answer != 0) {
            return answer;
          }
        }
        return answer;
      },
    );
    return myList;
  }

  void selectLanguage() {
    showModalBottomSheet(
        isScrollControlled: true,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (ctx) {
          return StatefulBuilder(builder: (BuildContext ctx, setState) {
            return Container(
              height: MediaQuery.sizeOf(context).height * 0.75,
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Languages",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(4)),
                          child: Icon(Icons.close, size: 18),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: ListView(
                      children: [
                        ...acceptedLanguages.keys.map((item) {
                          return ListTile(
                            title: Text(item),
                            trailing: Radio(
                                value: acceptedLanguages[item],
                                groupValue: language,
                                onChanged: (val) {
                                  setState(
                                    () {
                                      changeLanguage(val);
                                    },
                                  );
                                }),
                          );
                        })
                      ],
                    ),
                  )
                ],
              ),
            );
          });
        });
  }

  List filter() {
    List newList = List.from(countriesData);

    bool isInTimeZone(item) {
      for (final timeZone in timezoneFilters) {
        if ((item["timezones"] as List).contains(timeZone)) {
          return true;
        }
      }
      return false;
    }

    if (continentFilters.isNotEmpty || timezoneFilters.isNotEmpty) {
      newList = newList.where((item) {
        return continentFilters.contains(item["continents"][0]) ||
            (isInTimeZone(item));
      }).toList();
    }

    newList = sortMyList(newList, language);

    return newList;
  }

  void showResults() {
    setState(
      () {
        activeCountriesData = filter();
      },
    );
  }

  void resetFilters() {
    setState(
      () {
        continentFilters.clear();
        timezoneFilters.clear();
        showResults();
      },
    );
  }

  selectFilters() {
    showModalBottomSheet(
      constraints: BoxConstraints(minWidth: double.infinity, minHeight: 200),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, updateState) {
            return IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ExpansionTile(
                              title: Text("Continent"),
                              children: continents.map(
                                (item) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(item),
                                        Checkbox(
                                            value:
                                                continentFilters.contains(item),
                                            onChanged: (val) {
                                              updateState(
                                                () {
                                                  setState(
                                                    () {
                                                      if (val == true) {
                                                        continentFilters
                                                            .add(item);
                                                      } else {
                                                        continentFilters
                                                            .remove(item);
                                                      }
                                                    },
                                                  );
                                                },
                                              );
                                            })
                                      ],
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                            ExpansionTile(
                              title: Text("Time Zone"),
                              children: timeZones.map((item) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item),
                                    Checkbox(
                                        value: timezoneFilters.contains(item),
                                        onChanged: (val) {
                                          updateState(
                                            () {
                                              setState(() {
                                                if (val == true) {
                                                  timezoneFilters.add(item);
                                                } else {
                                                  timezoneFilters.remove(item);
                                                }
                                              });
                                            },
                                          );
                                        })
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          onPressed: () {
                            setState(() {
                              resetFilters();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 18),
                            child: Text("Reset"),
                          ),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            onPressed: () {
                              setState(() {
                                showResults();
                                Navigator.of(context).pop();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 30),
                              child: Text("Show Results"),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = theme.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Explore"),
        actions: [
          IconButton(
              onPressed: widget.toggleTheme,
              icon: Icon(isDarkMode
                  ? Icons.nights_stay_sharp
                  : Icons.wb_sunny_outlined))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(94, 185, 183, 183)),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  activeCountriesData = countriesData;
                  activeCountriesData = activeCountriesData.where((item) {
                    String name = language == "eng"
                        ? item["name"]["common"]
                        : item["translations"][language]["common"];
                    return name.toLowerCase().contains(value.toLowerCase());
                  }).toList();
                });
              },
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 6),
                border: InputBorder.none,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                label: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 6),
                    Text("Search for a country")
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primaryContainer),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextButton.icon(
                    onPressed: selectLanguage,
                    label: Text(
                      language.toUpperCase(),
                    ),
                    icon: Icon(Icons.language),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: continentFilters.isNotEmpty ||
                            timezoneFilters.isNotEmpty
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : null,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primaryContainer),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextButton.icon(
                    onPressed: selectFilters,
                    label: Text(
                      "Filters",
                    ),
                    icon: Icon(Icons.filter_alt_outlined),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: FutureBuilder(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (countriesData.isEmpty) {
                        return Center(
                          child: Text("Unable to load content at the moment"),
                        );
                      }
                      if (activeCountriesData.isEmpty) {
                        return Center(
                          child: Text(
                            "No results match your search!",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        );
                      }
                      return ListView.builder(
                          itemCount: activeCountriesData.length,
                          itemBuilder: (BuildContext context, int index) {
                            final capitalList =
                                activeCountriesData[index]["capital"];
                            String countryName = language == "eng"
                                ? activeCountriesData[index]["name"]["common"]
                                : activeCountriesData[index]["translations"]
                                    [language]["common"];
                            final previousFirstLetter = index == 0
                                ? ""
                                : language == "eng"
                                    ? activeCountriesData[index - 1]["name"]
                                        ["common"][0]
                                    : activeCountriesData[index - 1]
                                        ["translations"][language]["common"][0];
                            final currentFirstLetter = countryName[0];
                            List<Widget> childrenWidget = [
                              if (previousFirstLetter != currentFirstLetter)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 25),
                                  child: Text(
                                    currentFirstLetter,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ListTile(
                                // shape: Border(
                                //     bottom: BorderSide(
                                //         color: Theme.of(context)
                                //             .colorScheme
                                //             .onSurface)),
                                leading: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Image.network(
                                    width: 50,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    activeCountriesData[index]["flags"]["png"],
                                  ),
                                ),
                                title: Text(countryName),
                                subtitle: capitalList == null
                                    ? null
                                    : Text(capitalList[0]),
                                onTap: () {
                                  showDetalsScreen(activeCountriesData[index]);
                                },
                              ),
                            ];

                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: childrenWidget);
                          });
                    }
                    return Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  })),
        ],
      ),
    );
  }
}
