import 'package:flutter/material.dart';
import 'package:fraze_pocket/styles/app_theme.dart';

class ChooseFeelingBottomSheet extends StatefulWidget {
  const ChooseFeelingBottomSheet({super.key});

  @override
  State<ChooseFeelingBottomSheet> createState() =>
      _ChooseFeelingBottomSheetState();
}

class _ChooseFeelingBottomSheetState extends State<ChooseFeelingBottomSheet> {
  String? _selectedMood;

  final List<Map<String, String>> moods = [
    {
      'label': 'AMAZING',
      'image': 'assets/images/amazing.png',
    },
    {
      'label': 'GOOD',
      'image': 'assets/images/good.png',
    },
    {
      'label': 'NOT BAD',
      'image': 'assets/images/Not bad.png',
    },
    {
      'label': 'BAD',
      'image': 'assets/images/bad.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: AppTheme.popUp,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Заголовок и кнопка галочки
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "CHOOSE WHAT\nYOU FEEL",
                    style: AppTheme.displayMedium
                        .copyWith(color: AppTheme.onSurface),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.check_circle,
                      color: _selectedMood != null ? Colors.green : Colors.grey,
                      size: 48,
                    ),
                    onPressed: _selectedMood != null
                        ? () {
                            Navigator.pop(context, _selectedMood);
                          }
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Список настроений
              Expanded(
                child: ListView.builder(
                  itemCount: moods.length,
                  itemBuilder: (context, index) {
                    final mood = moods[index];
                    final isSelected = _selectedMood == mood['label'];
                    return FeelingOption(
                      label: mood['label']!,
                      image: mood['image']!,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedMood = mood['label'];
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeelingOption extends StatelessWidget {
  final String label;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;

  const FeelingOption({
    super.key,
    required this.label,
    required this.image,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isSelected ? 1.0 : 0.5, // Меняем прозрачность
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
