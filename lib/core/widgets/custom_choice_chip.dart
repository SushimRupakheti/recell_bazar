import 'package:flutter/material.dart';

class CustomChoiceChip extends StatefulWidget {
  final void Function(String deviceType)? onDeviceTypeSelected;
  final EdgeInsetsGeometry padding;

  const CustomChoiceChip({
    super.key,
    this.onDeviceTypeSelected,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  State<CustomChoiceChip> createState() => _CustomChoiceChipState();
}

class _CustomChoiceChipState extends State<CustomChoiceChip> {
  final List<String> deviceTypes = [
    "All",
    "New In",
    "iPhone",
    "Pixel",
    "Samsung",
    "Vivo",
    "Poco",
    "Huawei",
    "Oppo",
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: deviceTypes.asMap().entries.map((entry) {
          final index = entry.key;
          final type = entry.value;

          final bool isSelected = _selectedIndex == index;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

              label: Text(
                type,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                ),
              ),

              selected: isSelected,
                selectedColor: colorScheme.primary,

                backgroundColor:
                  isDark ? colorScheme.surface : Colors.grey.shade100,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected
                      ? colorScheme.primary
                      : (isDark
                          ? colorScheme.onSurface.withOpacity(0.18)
                          : Colors.grey.shade300),
                  width: 1,
                ),
              ),

              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedIndex = index);
                  widget.onDeviceTypeSelected?.call(type);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
