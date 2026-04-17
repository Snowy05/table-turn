import 'package:flutter/material.dart';
import 'BoardGameCardOpen.dart';
import '../../Controller/app_localizations.dart';

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

  // helper to map tag display names to localization keys
  String _tagKey(String tag) {
    switch (tag.toLowerCase()) {
      case 'new':
        return 'new';
      case 'classic':
        return 'classic';
      case 'family favorite':
        return 'familyFavorite';
      case 'strategy game':
        return 'strategyGame';
      case 'party game':
        return 'partyGame';
      case 'cooperative game':
        return 'cooperativeGame';
      case 'card game':
        return 'cardGameTag';
      case 'dice game':
        return 'diceGameTag';
      case 'word game':
        return 'wordGameTag';
      case 'drawing game':
        return 'drawingGame';
      case 'for kids':
        return 'forKids';
      case 'long-haul':
        return 'longHaul';
      case 'roleplaying game':
        return 'roleplayingGame';
      default:
        return tag;
    }
  }

  @override
  //custom button that opens a modal bottom sheet with filter options
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
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
                                localizations?.get(_tagKey(tag)) ?? tag,
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
                      child: Text(
                        AppLocalizations.of(context)?.get('apply') ?? 'Apply',
                      ),
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
      child: Text(AppLocalizations.of(context)?.get('filter') ?? label),
    );
  }
}
