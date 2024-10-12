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
import 'package:intl/intl.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  Map<DateTime, List<dynamic>> _events = {};
  List<dynamic> events = [];
  int id = 2;
  List<dynamic> _nextThreeEvents = [];


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

      _getUpcomingEvents();
    } catch (e) {
      print('Erreur : $e');
    }
  }

  void _getUpcomingEvents() {
    List<dynamic> upcomingEvents = [];
    DateTime now = DateTime.now();

    for (var key in _events.keys) {
      List<dynamic> dayEvents = _events[key]!;

      if (key.year == now.year &&
          key.month == now.month &&
          key.day == now.day) {
        for (var event in dayEvents) {
          TimeOfDay eventTime = TimeOfDay(
            hour: int.parse(event['heureDebut'].split(':')[0]),
            minute: int.parse(event['heureDebut'].split(':')[1]),
          );

          DateTime fullEventDateTime = DateTime(
            key.year,
            key.month,
            key.day,
            eventTime.hour,
            eventTime.minute,
          );

          if (fullEventDateTime.isAfter(now)) {
            upcomingEvents.add(event);
          }
        }
      }
      else if (key.isAfter(now)) {
        upcomingEvents.addAll(dayEvents);
      }
    }

    upcomingEvents.sort((a, b) {
      DateTime dateA = DateTime.parse(a['dateEvent']);
      TimeOfDay timeA = TimeOfDay(
        hour: int.parse(a['heureDebut'].split(':')[0]),
        minute: int.parse(a['heureDebut'].split(':')[1]),
      );
      DateTime fullDateTimeA = DateTime(
        dateA.year,
        dateA.month,
        dateA.day,
        timeA.hour,
        timeA.minute,
      );

      DateTime dateB = DateTime.parse(b['dateEvent']);
      TimeOfDay timeB = TimeOfDay(
        hour: int.parse(b['heureDebut'].split(':')[0]),
        minute: int.parse(b['heureDebut'].split(':')[1]),
      );
      DateTime fullDateTimeB = DateTime(
        dateB.year,
        dateB.month,
        dateB.day,
        timeB.hour,
        timeB.minute,
      );

      return fullDateTimeA.compareTo(fullDateTimeB);
    });

    setState(() {
      _nextThreeEvents = upcomingEvents.take(3).toList();
    });
  }


  void _onNewAnimal() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewEventsScreen()),
    );

    if (result == true) {
      _loadEvents(id);
    }
  }

  void showInfoDialog(BuildContext context, String message, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showInfoDialoga(
      BuildContext context, String message, String etat, VoidCallback onClose) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      customHeader: const Icon(
        Icons.info,
        color: AppColors.vert,
        size: 70,
      ),
      animType: AnimType.bottomSlide,
      title: etat,
      desc: message,
      btnOkOnPress: () {
        onClose();
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
      desc: 'Êtes-vous sûr de vouloir supprimer cet événement ?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        try {
          await Api2Service().deleteEvent(id);
          _loadUserInfo();
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
                  // padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      Container(
                        width: screenWidth * 0.82,
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
                                _onNewAnimal();
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
                      // SizedBox(height: screenHeight * 0.003),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              height: screenHeight * 0.505,
                              width: screenWidth * 0.8,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.5),
                                  topRight: Radius.circular(12.5),
                                ),
                              ),
                              child: Column(
                                children: [
                                  TableCalendar(
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
                                    calendarStyle: CalendarStyle(
                                      defaultDecoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 2,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      selectedDecoration: BoxDecoration(
                                        color: Colors.lightGreen,
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 2,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      todayDecoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 2,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      outsideDecoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 2,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      weekendDecoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 2,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                    headerStyle: const HeaderStyle(
                                      formatButtonVisible: false,
                                      titleCentered: true,
                                      titleTextStyle: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      leftChevronIcon: Icon(Icons.chevron_left,
                                          color: Colors.black),
                                      rightChevronIcon: Icon(
                                          Icons.chevron_right,
                                          color: Colors.black),
                                    ),
                                    availableCalendarFormats: const {
                                      CalendarFormat.month: '',
                                    },
                                    eventLoader: (day) {
                                      DateTime dayKey = DateTime(
                                          day.year, day.month, day.day);
                                      return _events[dayKey] ?? [];
                                    },
                                    calendarBuilders: CalendarBuilders(
                                      dowBuilder: (context, day) {
                                        return Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            DateFormat.E('fr_FR').format(day),
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // SizedBox(height: screenHeight * 0.02),
                            const Padding(
                              padding: EdgeInsets.only(left: 32),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Evènements à venir',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: AppColors.noir,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.007),
                            Column(
                              children: _nextThreeEvents.map((event) {
                                DateTime eventDate =
                                    DateTime.parse(event['dateEvent']);
                                String formattedDate =
                                    '${eventDate.day}.${eventDate.month}.${eventDate.year}';
                                String time = event['heureDebut'];

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 4),
                                  child: GestureDetector(
                                    onTap: () {
                                      showEventDetails(context, event);
                                    },
                                    child: Container(
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
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color: AppColors.blanc,
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: (event['titre'] == 'vaccination')
                                              ? Image.asset(
                                                  'assets/images/vaccination.png',
                                                  color: AppColors.vert,
                                                  width: 10,
                                                  height: 10,
                                                )
                                              : (event['titre'] == 'visite medicale')
                                                  ? Image.asset(
                                                      'assets/images/visite_medicale.png',
                                                      color: AppColors.vert,
                                                      width: 10,
                                                      height: 10,
                                                    )
                                                  : (event['titre'] == 'traitement')
                                                      ? Image.asset(
                                                          'assets/images/traitement.png',
                                                          color: AppColors.vert,
                                                          width: 10,
                                                          height: 10,
                                                        )
                                                      : const Icon(
                                                          Icons.event,
                                                          color: Colors.green,
                                                          size: 26,
                                                        ),
                                        ),
                                        const SizedBox(width: 16),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              event['titre'],
                                              style: const TextStyle(
                                                color: AppColors.noir,
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              '$formattedDate | $time',
                                              style: const TextStyle(
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
                                  )
                                );
                              }).toList(),
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
            color: _getEventColor(event),
          ),
        );
      }).toList(),
    );
  }

  Color _getEventColor(dynamic event) {
    if (event['titre'] == 'vaccination') {
      return Colors.blue;
    } else if (event['titre'] == 'visite medicale') {
      return Colors.red;
    } else if (event['titre'] == 'traitement') {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  void _showEventDetails(DateTime selectedDay) {
    double screenWidth = MediaQuery.of(context).size.width;

    DateTime dayKey =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    List<dynamic> events = _events[dayKey] ?? [];

    events.sort((a, b) {
      DateTime heureDebutA = DateTime.parse(
          '${selectedDay.year}-${selectedDay.month}-${selectedDay.day} ${a['heureDebut']}');
      DateTime heureDebutB = DateTime.parse(
          '${selectedDay.year}-${selectedDay.month}-${selectedDay.day} ${b['heureDebut']}');
      return heureDebutA.compareTo(heureDebutB);
    });

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
                      child: GestureDetector(
                        onTap: () {
                          showEventDetails(context, event);
                        },
                        child: Container(
                      width: screenWidth * 0.8,
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
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
                                const SizedBox(height: 4),
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
                                        Icons.event,
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
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showConfirmationDialog(context, event['id']);
                            },
                            child: const FaIcon(
                              FontAwesomeIcons.trash,
                              color: AppColors.vert,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
                }).toList()
              else
                const Text('Aucun événement trouvé.'),
            ],
          ),
        );
      },
    );
  }

  void closeAllDialogs(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void showEventDetails(BuildContext context, Map<String, dynamic> event) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    closeAllDialogs(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          builder: (_, controller) {
            return Container(
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
                  Container(
                    width: 80,
                    height: 5,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Détails de l’évènement",
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.vert,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 36),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            showEventEditModal(context, event);
                          },
                          child: const FaIcon(
                            FontAwesomeIcons.penToSquare,
                            color: AppColors.vert,
                            size: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: screenWidth * 0.85,
                    height: screenHeight * 0.28,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gris),
                      borderRadius: BorderRadius.circular(8.0),
                      color: AppColors.blanc,
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.gris,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        event['animal'] != null &&
                                event['animal']['name'] != null
                            ? _buildDetailRow(
                                screenWidth, 'Animal', event['animal']['name'])
                            : SizedBox.shrink(),
                        _buildDetailRow(screenWidth, 'Titre', event['titre']),
                        _buildDetailRow(
                            screenWidth, 'Date', event['dateEvent']),
                        _buildDetailRow(
                            screenWidth, 'Heure de debut', event['heureDebut']),
                        _buildDetailRow(
                            screenWidth, 'Heure de fin', event['heureFin']),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Column(
                    children: [
                      Container(
                        width: screenWidth * 0.85,
                        height: screenHeight * 0.06,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.gris),
                          borderRadius: BorderRadius.circular(8.0),
                          color: AppColors.blanc,
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.gris,
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Description',
                              style: TextStyle(
                                color: AppColors.noir,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    color: AppColors.noir,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: screenWidth * 0.85,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.gris),
                          borderRadius: BorderRadius.circular(8.0),
                          color: AppColors.blanc,
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.gris,
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: event['description'] ??
                                'Pas de description disponible',
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(double screenWidth, String label, String value) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: screenWidth * 0.35,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                label,
                style: const TextStyle(
                    color: AppColors.noir, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextField(
                  textAlign: TextAlign.right,
                  enabled: false,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(right: 12.0),
                    isDense: true,
                  ),
                  style: const TextStyle(color: Colors.black),
                  controller: TextEditingController(text: value),
                ),
              ),
            ),
          ],
        ),
        const Divider(color: AppColors.gris),
      ],
    );
  }

  void showEventEditModal(BuildContext context, Map<String, dynamic> event) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    closeAllDialogs(context);

    TextEditingController animalController = TextEditingController(
      text: event['animal'] != null && event['animal']['name'] != null
          ? event['animal']['name']
          : '',
    );
    TextEditingController titreController =
        TextEditingController(text: event['titre']);
    TextEditingController dateController =
        TextEditingController(text: event['dateEvent']);
    TextEditingController debutController =
        TextEditingController(text: event['heureDebut']);
    TextEditingController finController =
        TextEditingController(text: event['heureFin']);
    TextEditingController descriptionController =
        TextEditingController(text: event['description'] ?? '');

    DateTime? selectedDate = DateTime.tryParse(event['dateEvent']);
    TimeOfDay? selectedHeureDebut = TimeOfDay(
        hour: int.parse(event['heureDebut'].split(':')[0]),
        minute: int.parse(event['heureDebut'].split(':')[1]));
    TimeOfDay? selectedHeureFin = TimeOfDay(
        hour: int.parse(event['heureFin'].split(':')[0]),
        minute: int.parse(event['heureFin'].split(':')[1]));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return Container(
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
                  Container(
                    width: 80,
                    height: 5,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Modifier l’évènement",
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.vert,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: screenWidth * 0.85,
                    height: screenHeight * 0.33,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gris),
                      borderRadius: BorderRadius.circular(8.0),
                      color: AppColors.blanc,
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.gris,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        event['animal'] != null &&
                                event['animal']['name'] != null
                            ? _buildEditableDetailRow(
                                screenWidth, 'Animal', animalController)
                            : SizedBox.shrink(),
                        _buildEditableDetailRow(
                            screenWidth, 'Titre', titreController),
                        _buildEditableDetailRow1(
                            screenWidth, 'Date événement', dateController),
                        _buildEditableDetailRow2(
                            screenWidth, 'Heure de debut', debutController),
                        _buildEditableDetailRow2(
                            screenWidth, 'Heure de fin', finController),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Column(
                    children: [
                      Container(
                        width: screenWidth * 0.85,
                        height: screenHeight * 0.06,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.gris),
                          borderRadius: BorderRadius.circular(8.0),
                          color: AppColors.blanc,
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.gris,
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Description',
                              style: TextStyle(
                                color: AppColors.noir,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: screenWidth * 0.85,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.gris),
                          borderRadius: BorderRadius.circular(8.0),
                          color: AppColors.blanc,
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.gris,
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          maxLines: 5,
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12.0),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Expanded(
                    child: Center(
                      child: Container(
                        width: screenWidth * 0.4,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.vert,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.gris,
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () async {
                            try {
                              String newTitre = titreController.text;
                              String newDate = dateController.text;
                              String newDebut = debutController.text;
                              String newFin = finController.text;
                              String newDescription =
                                  descriptionController.text;
                              String newAnimal = animalController.text;

                              Map<String, dynamic> newEventData = {
                                'animal_id': newAnimal,
                                'user_id': id,
                                'titre': newTitre,
                                'dateEvent': newDate,
                                'heureDebut': newDebut,
                                'heureFin': newFin,
                                'description': newDescription,
                              };

                              dynamic response = await Api2Service()
                                  .updateEvent(event['id'], newEventData);
                              // print('Événement mis à jour : $response');
                              showInfoDialoga(
                                  context,
                                  'Événement mis à jour avec succès.',
                                  'Succès', () {
                                _loadUserInfo();
                              });
                            } catch (e) {
                              print('Erreur lors de la mise à jour : $e');
                              showInfoDialoga(
                                  context,
                                  'Erreur lors de la mise à jour : ${e.toString()}',
                                  'Erreur', () {
                                _loadUserInfo();
                              });
                            }
                          },
                          child: const Text(
                            'Modifier',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEditableDetailRow(
      double screenWidth, String label, TextEditingController controller) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: screenWidth * 0.35,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                '$label :',
                style: const TextStyle(
                    color: AppColors.noir, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextField(
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(right: 12.0),
                    isDense: true,
                  ),
                  style: const TextStyle(color: Colors.black),
                  controller: controller,
                ),
              ),
            ),
          ],
        ),
        const Divider(color: AppColors.gris),
      ],
    );
  }

  Widget _buildEditableDetailRow1(
      double screenWidth, String label, TextEditingController controller) {
    DateTime? _selectedDate;

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
          controller.text = '${picked.toLocal()}'.split(' ')[0];
        });
      }
    }

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: screenWidth * 0.4,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '$label :',
                style: const TextStyle(
                    color: AppColors.noir, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: TextField(
                  controller: controller,
                  readOnly: true,
                  textAlign: TextAlign.right,
                  onTap: () => _selectDate(context),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 14,
                    ),
                    isDense: true,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                      iconSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider(
            color: AppColors.gris, height: 1.0), // Réduit la hauteur du Divider
      ],
    );
  }

  Widget _buildEditableDetailRow2(
      double screenWidth, String label, TextEditingController controller) {
    TimeOfDay? _selectedTime;

    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _selectedTime ?? TimeOfDay.now(),
      );
      if (picked != null && picked != _selectedTime) {
        _selectedTime = picked;
        final now = DateTime.now();
        final selectedDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );
        controller.text =
            "${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}";
      }
    }

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: screenWidth * 0.4,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '$label :',
                style: const TextStyle(
                    color: AppColors.noir, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: TextField(
                  controller: controller,
                  readOnly: true,
                  textAlign: TextAlign.right,
                  onTap: () => _selectTime(context),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                    isDense: true,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () => _selectTime(context),
                      iconSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider(color: AppColors.gris, height: 1.0),
      ],
    );
  }

}
