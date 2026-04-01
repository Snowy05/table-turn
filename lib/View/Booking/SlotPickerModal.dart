import 'package:flutter/material.dart';
import '../../Model/Options/constants.dart';

class SlotPickerModal extends StatelessWidget {
  final List<String> slots;
  const SlotPickerModal({required this.slots, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: slots.map((slot) {
        return ListTile(
          title: Text(slot),
          onTap: () => Navigator.pop(context, slot),
        );
      }).toList(),
    );
  }
}