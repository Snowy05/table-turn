import 'package:flutter/material.dart';

class GlobalDropdownField<T> extends StatelessWidget {
  final T? value;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final double maxWidth;
  final bool isExpanded;

  const GlobalDropdownField({
    super.key,
    required this.value,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.maxWidth = 400,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScaleFactorOf(context);
    final borderRadius = BorderRadius.circular(18);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        isExpanded: isExpanded,
        menuMaxHeight: 320,
        borderRadius: borderRadius,
        dropdownColor: Colors.white,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.brown.shade700,
        ),
        hint: Text(
          hintText,
          style: TextStyle(fontSize: 14 * scale, color: Colors.brown.shade600),
        ),
        style: TextStyle(fontSize: 15 * scale, color: Colors.black87),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(color: Colors.brown, width: 2),
          ),
        ),
      ),
    );
  }
}
