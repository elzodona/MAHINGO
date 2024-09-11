import 'package:flutter/material.dart';
import 'package:mahingo/utils/colors.dart';

class NewAnimalsScreen extends StatefulWidget {
  const NewAnimalsScreen({super.key});

  @override
  _NewAnimalsScreenState createState() => _NewAnimalsScreenState();
}

class _NewAnimalsScreenState extends State<NewAnimalsScreen> {

  final TextEditingController _textController = 
      TextEditingController(text: 'M001');
  final TextEditingController _nomController =
      TextEditingController(text: 'Saloum Saloum');
  final TextEditingController _ageController = 
      TextEditingController(text: '6 ans');
  final TextEditingController _tailleController =
      TextEditingController(text: '1.70 m');
  final TextEditingController _poidsController =
      TextEditingController(text: '306 kg');
  final TextEditingController _genreController =
      TextEditingController(text: 'Femelle');
  final TextEditingController _raceController =
      TextEditingController(text: 'Ndama-grande');
  // final TextEditingController _birthController =
  //     TextEditingController(text: '6 ans');

  final TextEditingController _birthController = TextEditingController();
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
        _birthController.text =
            '${picked.toLocal()}'.split(' ')[0]; // Format date to YYYY-MM-DD
      });
    }
  }

  @override
    void dispose() {
      _textController.dispose();
      _nomController.dispose();
      _ageController.dispose();
      _tailleController.dispose();
      _poidsController.dispose();
      _genreController.dispose();
      _raceController.dispose();
      _birthController.dispose();
      super.dispose();
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
              height: screenHeight * 0.14,
              color: AppColors.vert,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.blanc),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Spacer(),
                  const Center(
                    child: Text(
                      'Ajouter un animal',
                      style: TextStyle(
                        color: AppColors.blanc,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: screenHeight * 0.9,
                  width: screenWidth,
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
                        height: screenHeight * 0.17,
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/me.jpeg'),
                                radius: 50,
                              ),
                              Positioned(
                                bottom: -3,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.vertClair,
                                    border: Border.all(
                                      color: AppColors.vert,
                                      width: 2,
                                    ),
                                  ),
                                  child: Image.asset(
                                    'assets/images/birth.png',
                                    height: 24,
                                    width: 24,
                                 ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      Container(
                        height: screenHeight * 0.38,
                        decoration: const BoxDecoration(
                          // color: AppColors.noir
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              height: screenHeight * 0.05,
                              width: screenWidth * 0.85,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.gris),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: screenWidth * 0.25,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: const Text(
                                          'Numéro',
                                          style:
                                              TextStyle(color: AppColors.noir, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: TextField(
                                            controller: _textController,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600
                                            ),
                                            textAlign: TextAlign.right,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.only(right: 12.0),
                                              isDense: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: screenHeight * 0.003),

                                  Container(
                                    height: 1.0,
                                    color: AppColors.gris,
                                    width: screenWidth * 0.75,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.015),
                            
                            Container(
                              padding: const EdgeInsets.all(5),
                              height: screenHeight * 0.3,
                              width: screenWidth * 0.85,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.gris),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: [

                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: screenWidth * 0.25,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: const Text(
                                                'Nom',
                                                style: TextStyle(
                                                    color: AppColors.noir, fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0),
                                                child: TextField(
                                                  controller: _nomController,
                                                  textAlign: TextAlign.right,
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            right: 12.0),
                                                    isDense: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: screenHeight * 0.003),
                                        Container(
                                          height: 1.0,
                                          color: AppColors.gris,
                                          width: screenWidth * 0.75,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: screenHeight * 0.015),

                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: screenWidth * 0.25,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: const Text(
                                                'Âge',
                                                style: TextStyle(
                                                    color: AppColors.noir, fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0),
                                                child: TextField(
                                                  controller: _ageController,
                                                  textAlign: TextAlign.right,
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            right: 12.0),
                                                    isDense: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: screenHeight * 0.003),
                                        Container(
                                          height: 1.0,
                                          color: AppColors.gris,
                                          width: screenWidth * 0.75,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: screenHeight * 0.015),

                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: screenWidth * 0.25,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: const Text(
                                                'Taille',
                                                style: TextStyle(
                                                    color: AppColors.noir, fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0),
                                                child: TextField(
                                                  controller: _tailleController,
                                                  textAlign: TextAlign.right,
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            right: 12.0),
                                                    isDense: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: screenHeight * 0.003),
                                        Container(
                                          height: 1.0,
                                          color: AppColors.gris,
                                          width: screenWidth * 0.75,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: screenHeight * 0.015),

                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: screenWidth * 0.25,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: const Text(
                                                'Poids',
                                                style: TextStyle(
                                                    color: AppColors.noir, fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0),
                                                child: TextField(
                                                  controller: _poidsController,
                                                  textAlign: TextAlign.right,
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            right: 12.0),
                                                    isDense: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: screenHeight * 0.003),
                                        Container(
                                          height: 1.0,
                                          color: AppColors.gris,
                                          width: screenWidth * 0.75,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: screenHeight * 0.015),

                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: screenWidth * 0.25,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: const Text(
                                                'Genre',
                                                style: TextStyle(
                                                    color: AppColors.noir, fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0),
                                                child: TextField(
                                                  controller: _genreController,
                                                  textAlign: TextAlign.right,
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            right: 12.0),
                                                    isDense: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: screenHeight * 0.003),
                                        Container(
                                          height: 1.0,
                                          color: AppColors.gris,
                                          width: screenWidth * 0.75,
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  SizedBox(height: screenHeight * 0.015),

                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: screenWidth * 0.25,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: const Text(
                                                'Race',
                                                style: TextStyle(
                                                    color: AppColors.noir, fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0),
                                                child: TextField(
                                                  controller: _raceController,
                                                  textAlign: TextAlign.right,
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            right: 12.0),
                                                    isDense: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: screenHeight * 0.003),
                                        Container(
                                          height: 1.0,
                                          color: AppColors.gris,
                                          width: screenWidth * 0.75,
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),

                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      Container(
                        height: screenHeight * 0.13,
                        width: screenWidth * 0.85,
                        decoration: const BoxDecoration(
                          // color: AppColors.vert
                        ),
                        
                        child: Column(
                          children: [

                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Dates importantes',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),

                            SizedBox(height: 10),

                            Container(
                              width: screenWidth * 0.85,
                              height: screenHeight * 0.07,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.gris),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/birth.png',
                                          height: 24,
                                          width: 24,
                                        ),
                                        SizedBox(width: 12),
                                        const Text(
                                          'Anniversaire',
                                          style: TextStyle(
                                            color: AppColors.noir,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: TextField(
                                        controller: _birthController,
                                        readOnly:
                                            true,
                                        textAlign: TextAlign.right,
                                        onTap: () => _selectDate(
                                            context),
                                        decoration: InputDecoration(
                                          border: InputBorder
                                              .none,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          isDense: true,
                                          suffixIcon: IconButton(
                                            icon: const Icon(
                                                Icons.calendar_today),
                                            onPressed: () => _selectDate(
                                                context),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )

                          ],
                        ),
                      
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      Expanded(
                        child: Center(
                          child: Container(
                            width: screenWidth * 0.4,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.vert,
                              borderRadius:
                                  BorderRadius.circular(8.0),
                            ),
                            child: TextButton(
                              onPressed: () {
                                
                              },
                              child: const Text(
                                'Ajouter',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
}
