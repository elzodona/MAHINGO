import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mahingo/utils/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mahingo/widgets/app_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AccueilScreen extends StatelessWidget {
   AccueilScreen({super.key});

  final List<Map<String, dynamic>> animaux = [
    {
      'id': 1,
      'libelle': "Mouton",
      'animaux': [
        {
          'id': 1,
          'nom': "MacGyver",
          'sexe': "Male",
          'dateNaiss': "28/03/2020",
          'photo': "image.jpeg",
          'race': "Ladoum",
          'poids': "150kg",
          'taille': "30Cm",
          'idCategorie': 1,
          'idCollier': 1
        },
        {
          'id': 2,
          'nom': "Bozer",
          'sexe': "Male",
          'dateNaiss': "28/03/2020",
          'photo': "image.jpeg",
          'race': "Ladoum",
          'poids': "130kg",
          'taille': "35cm",
          'idCategorie': 1,
          'idCollier': 2
        }
      ]
    },
    {
      'id': 2,
      'libelle': "Vache",
      'animaux': [
        {
          'id': 3,
          'nom': "Maty",
          'sexe': "Femelle",
          'dateNaiss': "28/03/2020",
          'photo': "image.jpeg",
          'race': "race 1",
          'poids': "150kg",
          'taille': "30m",
          'idCategorie': 2,
          'idCollier': 3
        },
        {
          'id': 4,
          'nom': "Riley",
          'sexe': "Femelle",
          'dateNaiss': "28/03/2020",
          'photo': "image.jpeg",
          'race': "race 2",
          'poids': "130kg",
          'taille': "33m",
          'idCategorie': 2,
          'idCollier': 4
        },
        {
          'id': 5,
          'nom': "Jack",
          'sexe': "Male",
          'dateNaiss': "28/03/2020",
          'photo': "image.jpeg",
          'race': "race 3",
          'poids': "110kg",
          'taille': "30m",
          'idCategorie': 2,
          'idCollier': 5
        }
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {

    int nombreMoutons = animaux
        .firstWhere((categorie) => categorie['libelle'] == 'Mouton')['animaux']
        .length;
    int nombreVaches = animaux
        .firstWhere((categorie) => categorie['libelle'] == 'Vache')['animaux']
        .length;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
       appBar: const CustomAppBar(),
        body: Padding(
        padding: const EdgeInsets.all(12),
        child: 
        Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Mon troupeau',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.noir,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins'
                ),
              ),
            ),
            
            SizedBox(height: screenHeight * 0.01),
            
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: screenHeight * 0.12,
                      width: screenWidth * 0.3,
                      decoration: BoxDecoration(
                        color: AppColors.blanc,
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                          color: AppColors.vert,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(MdiIcons.sheep, color: AppColors.vert, size: 26),
                          Text(
                            '$nombreMoutons',
                            style: TextStyle(
                              color: AppColors.vert,
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'Moutons',
                            style: TextStyle(
                              color: AppColors.vert,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Container(
                      alignment: Alignment.center,
                      height: screenHeight * 0.12,
                      width: screenWidth * 0.3,
                      decoration: BoxDecoration(
                        color: AppColors.blanc,
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                          color: AppColors.vert,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(MdiIcons.cow, color: AppColors.vert, size: 26),
                          Text(
                            '$nombreVaches',
                            style: TextStyle(
                              color: AppColors.vert,
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'Vaches',
                            style: TextStyle(
                              color: AppColors.vert,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: screenHeight * 0.12,
                      width: screenWidth * 0.3,
                      decoration: const BoxDecoration(
                        color: AppColors.vert,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/icon_good_health.png',
                            color: AppColors.blanc,
                            height: 26,
                            width: 26,
                          ),
                          Text(
                            '95%',
                            style: TextStyle(
                              color: AppColors.blanc,
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'Bon état',
                            style: TextStyle(
                              color: AppColors.blanc,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
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
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    height: screenHeight * 0.25,
                    width: screenWidth * 0.96,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 203, 222, 201),
                      // border: Border.all(
                      //   color: AppColors.vert,
                      //   width: 2.0,
                      // ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.5),
                        topRight: Radius.circular(12.5),
                      ),
                    ),
                    // child: const Text('Contenu du container'),
                  ),
                  // const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    height: screenHeight * 0.065,
                    width: screenWidth * 0.96,
                    decoration: BoxDecoration(
                      color: AppColors.vert,
                      border: Border.all(
                        color: AppColors.vert,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Localisation',
                      style: TextStyle(
                        color: AppColors.blanc,
                        fontSize: 18,
                        fontFamily: 'Poppins', 
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.01),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Prochains évènements',
                      style: TextStyle(
                          fontSize: 18,
                          color: AppColors.noir,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.007),
                  
                  Container(
                  // padding: const EdgeInsets.all(8.0),
                  height: screenHeight * 0.068,
                  width: screenWidth * 0.96,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF4EB),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        // padding: const EdgeInsets.all(8.0),
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: AppColors.vert,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Image.asset(
                          'assets/images/vaccination.png',
                          color: AppColors.blanc,
                          height: 26,
                          width: 26,
                        ),
                      ),
                      const SizedBox(
                          width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                  
                  SizedBox(height: screenHeight * 0.006),
                  
                  Container(
                    // padding: const EdgeInsets.all(8.0),
                    height: screenHeight * 0.068,
                    width: screenWidth * 0.96,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF4EB),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          // padding: const EdgeInsets.all(8.0),
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: AppColors.vert,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Image.asset(
                            'assets/images/visite_medicale.png',
                            color: AppColors.blanc,
                            height: 26,
                            width: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                  
                  SizedBox(height: screenHeight * 0.006),
                  
                  Container(
                  // padding: const EdgeInsets.all(8.0),
                  height: screenHeight * 0.068,
                  width: screenWidth * 0.96,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF4EB),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        // padding: const EdgeInsets.all(8.0),
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: AppColors.vert,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Image.asset(
                          'assets/images/traitement.png',
                          color: AppColors.blanc,
                          height: 26,
                          width: 26,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
            ),
          ],
          
        ),
        
        )
      // body: ListView.builder(
        //   scrollDirection: Axis.vertical,
        //   itemCount: animes.length,
        //   itemBuilder: (context, index) {
        //     // return Image.network(
        //     //   images[index], width: 250,
        //     // );
        //     return Container(
        //       margin: const EdgeInsets.all(16),
        //       // child: Image.network(images[index], width: 300),
        //       child: Text(animes[index])
        //     );
        //   },
        // )
    );
  }

}
