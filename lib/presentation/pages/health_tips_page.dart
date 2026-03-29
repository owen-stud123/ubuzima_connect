import 'package:flutter/material.dart';
import 'package:ubuzima_connect/core/theme.dart';
import 'package:ubuzima_connect/core/language_service.dart';

class HealthTipsPage extends StatefulWidget {
  const HealthTipsPage({Key? key}) : super(key: key);

  @override
  State<HealthTipsPage> createState() => _HealthTipsPageState();
}

class _HealthTipsPageState extends State<HealthTipsPage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LanguageService.currentLanguage,
      builder: (context, language, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              language == AppLanguage.kinyarwanda ? 'Ubwenge Ku Nzira' : 'Health Tips',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.primaryBlue,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildHealthTipCard(
                        icon: Icons.medical_services_outlined,
                        title: language == AppLanguage.kinyarwanda ? 'Ubwiya Bwa Mbere' : 'First Aid',
                        description: language == AppLanguage.kinyarwanda
                            ? 'Ufashye m\'ubwiya'
                            : 'Emergency care',
                        onTap: () {
                          _showHealthTipDetails(
                            context,
                            language == AppLanguage.kinyarwanda ? 'Ubwiya Bwa Mbere' : 'First Aid',
                            language == AppLanguage.kinyarwanda
                                ? 'Reba amakuru y\'ubwiya bwa mbere'
                                : 'Learn essential first aid techniques and emergency response',
                            _getFirstAidTips(language),
                          );
                        },
                      ),
                      _buildHealthTipCard(
                        icon: Icons.favorite_border,
                        title: language == AppLanguage.kinyarwanda ? 'Isuku N\'Ibisabire' : 'Hygiene/Isuku',
                        description: language == AppLanguage.kinyarwanda
                            ? 'Kwitima neza'
                            : 'Stay clean',
                        onTap: () {
                          _showHealthTipDetails(
                            context,
                            language == AppLanguage.kinyarwanda ? 'Isuku N\'Ibisabire' : 'Hygiene',
                            language == AppLanguage.kinyarwanda
                                ? 'Reba amakuru y\'ubwiyunge'
                                : 'Important hygiene practices for health',
                            _getHygieneTips(language),
                          );
                        },
                      ),
                      _buildHealthTipCard(
                        icon: Icons.restaurant_outlined,
                        title: language == AppLanguage.kinyarwanda ? 'Ibiryo N\'Imirire' : 'Nutrition/Imirire',
                        description: language == AppLanguage.kinyarwanda
                            ? 'Kurya neza'
                            : 'Eat well',
                        onTap: () {
                          _showHealthTipDetails(
                            context,
                            language == AppLanguage.kinyarwanda ? 'Ibiryo N\'Imirire' : 'Nutrition',
                            language == AppLanguage.kinyarwanda
                                ? 'Reba amakuru y\'imirire myiza'
                                : 'Balanced diet and nutrition guidelines',
                            _getNutritionTips(language),
                          );
                        },
                      ),
                      _buildHealthTipCard(
                        icon: Icons.pregnant_woman_outlined,
                        title: language == AppLanguage.kinyarwanda ? 'Mama n\'Abakobwa' : 'Maternal/Ababyeyi',
                        description: language == AppLanguage.kinyarwanda
                            ? 'Ubwiyunge bw\'abakobwa'
                            : 'Women\'s health',
                        onTap: () {
                          _showHealthTipDetails(
                            context,
                            language == AppLanguage.kinyarwanda ? 'Mama n\'Abakobwa' : 'Maternal Health',
                            language == AppLanguage.kinyarwanda
                                ? 'Reba amakuru y\'ubwiyunge bw\'abakobwa'
                                : 'Maternal and women\'s health information',
                            _getMaternalHealthTips(language),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHealthTipCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryGreen,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHealthTipDetails(
    BuildContext context,
    String title,
    String description,
    List<String> tips,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Key Points:',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...tips.map((tip) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(top: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tip,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<String> _getFirstAidTips(AppLanguage language) {
    if (language == AppLanguage.kinyarwanda) {
      return [
        'Reka umuntu akire neza mu mahoro',
        'Ushake sangira ibiri neza',
        'Kanda inzira zigira imvura y\'amaraso',
        'Hamagara abaganga vuba',
        'Kwitanga ubwiyunge bugira ubwenge',
      ];
    } else {
      return [
        'Keep the person calm and comfortable',
        'Call emergency services immediately',
        'Apply pressure to stop bleeding',
        'Do not move the injured person',
        'Provide reassurance while waiting for help',
      ];
    }
  }

  List<String> _getHygieneTips(AppLanguage language) {
    if (language == AppLanguage.kinyarwanda) {
      return [
        'Koza amakuru buri gitondo n\'ijoro',
        'Gukubita amaboko munzira nzira',
        'Kwitanda buri ku gitondo n\'ijoro',
        'Kugakuza ibikoresho byo kunywa',
        'Kurya ibiryo byakozwe neza',
      ];
    } else {
      return [
        'Shower daily with clean water and soap',
        'Wash hands before eating and after using the toilet',
        'Keep your living space clean',
        'Change clothes regularly',
        'Brush teeth twice daily',
      ];
    }
  }

  List<String> _getNutritionTips(AppLanguage language) {
    if (language == AppLanguage.kinyarwanda) {
      return [
        'Kurya umusanyo wa vegetable buri ku munsi',
        'Kunywa amazi menshi (liters 8 buri ku munsi)',
        'Kurya ibiryo byafite proteini',
        'Kubura sukali minshi',
        'Kurya amasukali y\'amatunda',
      ];
    } else {
      return [
        'Eat vegetables daily for vitamins and minerals',
        'Drink at least 8 glasses of water daily',
        'Include protein in every meal',
        'Limit sugar and processed foods',
        'Eat fruits for natural energy',
      ];
    }
  }

  List<String> _getMaternalHealthTips(AppLanguage language) {
    if (language == AppLanguage.kinyarwanda) {
      return [
        'Kugenda ku muganga imyaka y\'abakobwa',
        'Kurya neza mu gihe cya cyifuzo',
        'Kunywa multivitamin',
        'Kwiyambaza mu gihe cyifuzo',
        'Kwiciranya umuntu w\'ubwiyunge',
      ];
    } else {
      return [
        'Visit healthcare provider regularly during pregnancy',
        'Eat nutritious food for mother and baby',
        'Take prenatal vitamins as recommended',
        'Avoid stress and get adequate rest',
        'Breastfeed for optimal nutrition',
      ];
    }
  }
}
