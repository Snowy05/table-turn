import 'package:flutter/material.dart';
import 'BoardGameCardOpen.dart';

class Tagbttn extends StatelessWidget {
  final Set<String> selectedTags;
  final List<String> allTags;
  //set string used to store selected tags for filtering, list of all available tags and a callback to apply the filter
  final ValueChanged<Set<String>> onApply;
  final String label;

  const Tagbttn({
    super.key,
    required this.selectedTags,
    required this.allTags,
    required this.onApply,
    this.label = 'Filter by Tags',
  });

  @override
  //custom button that opens a modal bottom sheet with filter options
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
                      children: allTags
                          .map<Widget>(
                            (tag) => FilterChip(
                              label: Text(
                                tag,
                                style: const TextStyle(color: Colors.white),
                              ),
                              selected: tempSelected.contains(tag),
                              backgroundColor: BoardGameCardOpen.tagColor(
                                tag,
                                context,
                              ),
                              selectedColor: BoardGameCardOpen.tagColor(
                                tag,
                                context,
                              ).withOpacity(0.85),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                  bottomLeft: Radius.circular(24),
                                  bottomRight: Radius.circular(24),
                                ),
                              ),
                              onSelected: (isSelected) {
                                setModalState(() {
                                  if (isSelected) {
                                    tempSelected.add(tag);
                                  } else {
                                    tempSelected.remove(tag);
                                  }
                                });
                              },
                            ),
                          )
                          .toList(),
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
