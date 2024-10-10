import 'dart:ffi';
import 'package:mahingo/screens/newEvent_screen.dart';
import 'package:mahingo/services/call_api/animal_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahingo/screens/newAnimal_screen.dart';
import 'package:mahingo/screens/update_animal_screen.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mahingo/services/call_api/animal_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mahingo/services/call_api/event_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void showInfoDialog(BuildContext context) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.info,
    customHeader: const Icon(
      Icons.info,
      color: AppColors.vert,
      size: 70,
    ),
    animType: AnimType.bottomSlide,
    title: 'Succès',
    desc: 'Suppression effectuée avec succès',
    btnOkOnPress: () {
      Navigator.of(context).pop();
    },
    btnOkColor: AppColors.vert,
  ).show();
}

void showSuccessDialog(BuildContext context) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.success,
    customHeader: const Icon(
      Icons.check_circle,
      color: AppColors.vert,
      size: 70,
    ),
    animType: AnimType.bottomSlide,
    title: 'Succès',
    desc: 'Suppression effectuée avec succès',
    btnOkOnPress: () {
      Navigator.of(context).pop();
    },
    btnOkColor: AppColors.vert,
  ).show();
}

void showConfirmationDialog(BuildContext context, int id) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.question,
    animType: AnimType.scale,
    title: 'Confirmation',
    desc: 'Êtes-vous sûr de vouloir supprimer cet animal ?',
    btnCancelOnPress: () {},
    btnOkOnPress: () async {
      try {
        await ApiService().deleteAnimal(id);
        showSuccessDialog(context);
      } catch (e) {
        print('Erreur lors de la suppression : $e');
      }
    },
  ).show();
}

void showErrorDialog(BuildContext context, String title, String message) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.error,
    animType: AnimType.bottomSlide,
    title: title,
    desc: message,
    btnOkOnPress: () {},
  ).show();
}

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  Map<DateTime, List<dynamic>> _events = {};
  List<dynamic> events = [];
  int id = 2;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final LayerLink layerLink = LayerLink();
  final GlobalKey _nameAnimalKey = GlobalKey();
  FocusNode _focusNode = FocusNode();
  final TextEditingController _nameEvent = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      String userString = prefs.getString('user')!;
      Map<String, dynamic> userData = json.decode(userString);
      setState(() {
        id = userData["id"];
      });
      // print("User ID: ${id}");

      await _loadEvents(id);
    } else {
      print('Aucun utilisateur trouvé dans les préférences partagées');
    }
  }

  Future<void> _loadEvents(int id) async {
    try {
      Api2Service apiService = Api2Service();
      List<dynamic> events = await apiService.fetchEvents(id);

      Map<DateTime, List<dynamic>> eventsMap = {};
      for (var event in events) {
        DateTime eventDate = DateTime.parse(event['dateEvent']);

        DateTime eventKey =
            DateTime(eventDate.year, eventDate.month, eventDate.day);

        if (eventsMap[eventKey] == null) {
          eventsMap[eventKey] = [];
        }
        eventsMap[eventKey]!.add(event);
      }

      setState(() {
        _events = eventsMap;
      });
      print(_events);
    } catch (e) {
      print('Erreur : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.vert,
              AppColors.vert,
            ],
            stops: [0.3, 0.3],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30),
              height: screenHeight * 0.15,
              color: AppColors.vert,
              child: const Center(
                child: Text(
                  'Agenda',
                  style: TextStyle(
                    color: AppColors.blanc,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: screenHeight * 0.9,
                  decoration: const BoxDecoration(
                    color: AppColors.blanc,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(23),
                      topLeft: Radius.circular(23),
                    ),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.01),
                      Container(
                        width: screenWidth * 0.87,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                // height: screenHeight * 0.05,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.gris,
                                      spreadRadius: 3,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    CompositedTransformTarget(
                                        link: layerLink,
                                        child: TextField(
                                          key: _nameAnimalKey,
                                          focusNode: _focusNode,
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                          controller: _nameEvent,
                                          decoration: InputDecoration(
                                            hintText: 'Search...',
                                            hintStyle: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 200, 199, 197)),
                                            prefixIcon: const Icon(Icons.search,
                                                color: AppColors.gris),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 15),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                  color: AppColors.gris,
                                                  width: 1),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                  color: AppColors.gris,
                                                  width: 1),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                  color: AppColors.vert,
                                                  width: 2),
                                            ),
                                            fillColor: AppColors.blanc,
                                            filled: true,
                                          ),
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NewEventsScreen()),
                                );
                              },
                              child: Container(
                                height: screenHeight * 0.043,
                                width: screenWidth * 0.11,
                                decoration: BoxDecoration(
                                  color: AppColors.vert,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.gris,
                                      spreadRadius: 5,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: AppColors.blanc,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              height: screenHeight * 0.44,
                              width: screenWidth * 0.8,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.5),
                                  topRight: Radius.circular(12.5),
                                ),
                              ),
                              child: TableCalendar(
                                firstDay: DateTime.utc(2020, 1, 1),
                                lastDay: DateTime.utc(2030, 12, 31),
                                focusedDay: _focusedDay,
                                locale: 'fr_FR',
                                selectedDayPredicate: (day) {
                                  return isSameDay(_selectedDay, day);
                                },
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                    _focusedDay = focusedDay;
                                  });
                                  _showEventDetails(selectedDay);
                                },
                                startingDayOfWeek: StartingDayOfWeek.monday,
                                calendarStyle: const CalendarStyle(
                                  selectedDecoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  todayDecoration: BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                headerStyle: const HeaderStyle(
                                  formatButtonVisible: false,
                                  titleCentered: true,
                                  titleTextStyle: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                availableCalendarFormats: const {
                                  CalendarFormat.month: '',
                                },
                                eventLoader: (day) {
                                  DateTime dayKey =
                                      DateTime(day.year, day.month, day.day);
                                  return _events[dayKey] ?? [];
                                },
                                calendarBuilders: CalendarBuilders(
                                  markerBuilder: (context, day, events) {
                                    if (events.isNotEmpty) {
                                      return Positioned(
                                        right: 1,
                                        bottom: 1,
                                        child: _buildEventMarker(events),
                                      );
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            const Padding(
                              padding: EdgeInsets.only(left: 18),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Evènements à venir',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.noir,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.007),
                            Container(
                              // padding: const EdgeInsets.all(8.0),
                              height: screenHeight * 0.085,
                              width: screenWidth * 0.8,
                              decoration: BoxDecoration(
                                // color: const Color(0xFFEBF4EB),
                                color: AppColors.blanc,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.gris,
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    // padding: const EdgeInsets.all(8.0),
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: AppColors.blanc,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Image.asset(
                                      'assets/images/vaccination.png',
                                      color: AppColors.vert,
                                      height: 16,
                                      width: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Vaccination',
                                        style: TextStyle(
                                          color: AppColors.noir,
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '11.06.2023 | 13:30',
                                        style: TextStyle(
                                          color: Color(0xFF808B9A),
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.008),
                            Container(
                              // padding: const EdgeInsets.all(8.0),
                              height: screenHeight * 0.085,
                              width: screenWidth * 0.8,
                              decoration: BoxDecoration(
                                color: AppColors.blanc,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.gris,
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    // padding: const EdgeInsets.all(8.0),
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: AppColors.blanc,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Image.asset(
                                      'assets/images/visite_medicale.png',
                                      color: AppColors.vert,
                                      height: 16,
                                      width: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Visite médicale',
                                        style: TextStyle(
                                          color: AppColors.noir,
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '11.06.2023 | 13:30',
                                        style: TextStyle(
                                          color: Color(0xFF808B9A),
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.008),
                            Container(
                              // padding: const EdgeInsets.all(8.0),
                              height: screenHeight * 0.085,
                              width: screenWidth * 0.8,
                              decoration: BoxDecoration(
                                color: AppColors.blanc,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.gris,
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    // padding: const EdgeInsets.all(8.0),
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: AppColors.blanc,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Image.asset(
                                      'assets/images/traitement.png',
                                      color: AppColors.vert,
                                      height: 16,
                                      width: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Traitement médical',
                                        style: TextStyle(
                                          color: AppColors.noir,
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '11.06.2023 | 13:30',
                                        style: TextStyle(
                                          color: Color(0xFF808B9A),
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventMarker(List<dynamic> events) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: events.take(3).map((event) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 0.5),
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getEventColor(
                event),
          ),
        );
      }).toList(),
    );
  }

  Color _getEventColor(dynamic event) {
    if (event['titre'] == 'repro') {
      return Colors.blue;
    } else if (event['titre'] == 'reproduction') {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  void _showEventDetails(DateTime selectedDay) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    DateTime dayKey =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    List<dynamic> events = _events[dayKey] ?? [];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 5,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              if (events.isNotEmpty)
                ...events.map((event) {
                  return Center(
                    child: Container(
                      width: screenWidth * 0.8,
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${event['heureDebut']} - ${event['heureFin']}',
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    if (event['titre'] == 'vaccination')
                                      Image.asset(
                                        'assets/images/vaccination.png',
                                        color: AppColors.vert,
                                        width: 20,
                                        height: 20,
                                      )
                                    else if (event['titre'] ==
                                        'visite medicale')
                                      Image.asset(
                                        'assets/images/visite_medicale.png',
                                        color: AppColors.vert,
                                        width: 20,
                                        height: 20,
                                      )
                                    else if (event['titre'] == 'traitement')
                                      Image.asset(
                                        'assets/images/traitement.png',
                                        color: AppColors.vert,
                                        width: 20,
                                        height: 20,
                                      )
                                    else
                                      const Icon(
                                        Icons
                                            .event,
                                        color: Colors.green,
                                        size: 20,
                                      ),

                                    const SizedBox(width: 8),
                                    Text(
                                      event['titre'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.green),
                            onPressed: () {
                              _deleteEvent(event['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList()
              else
                const Text('Aucun événement trouvé.'),
            ],
          ),
        );
      },
    );
  }

  void _deleteEvent(int eventId) {
    print('Suppression de l\'événement avec l\'ID: $eventId');
  }

}
