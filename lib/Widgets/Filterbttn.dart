import 'package:flutter/material.dart';

class Filterbttn extends StatelessWidget {
  final Set<String> selectedTags;
  final List<String> allTags;
  //set string used to store selected tags for filtering, list of all available tags, and a callback to apply the filter
  final ValueChanged<Set<String>> onApply;
  final String label;

  const Filterbttn({
    super.key,
    required this.selectedTags,
    required this.allTags,
    required this.onApply,
    this.label = 'Filter by Tags',
  });

  @override
  // Custom button that opens a modal bottom sheet with filter options
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final result = await showModalBottomSheet<Set<String>>(
          context: context,
          builder: (context) {
            Set<String> tempSelected = Set.from(selectedTags);
            return StatefulBuilder(
              builder: (context, setModalState) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      spacing: 8,
                      children: allTags.map<Widget>((tag) => FilterChip(
                        label: Text(tag),
                        selected: tempSelected.contains(tag),
                        onSelected: (isSelected) {
                          setModalState(() {
                            if (isSelected) {
                              tempSelected.add(tag);
                            } else {
                              tempSelected.remove(tag);
                            }
                          });
                        },
                      )).toList(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, tempSelected);
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        if (result != null) {
          onApply(result);
        }
      },
      child: Text(label),
    );
  }
}