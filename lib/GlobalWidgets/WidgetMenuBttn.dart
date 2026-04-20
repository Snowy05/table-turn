import 'package:flutter/material.dart';

// custtom card button for the dashboard
class WidgetMenubttn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? imageAsset;
  final VoidCallback onTap;

  const WidgetMenubttn({
    super.key,
    required this.label,
    this.icon,
    this.imageAsset,
    required this.onTap,
  });
  //if image asset is provided use it else use icon
  @override
  Widget build(BuildContext context) {
    final isHighContrast =
        Theme.of(context).colorScheme.primary == Colors.black;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.black, width: 1),
          ),
          color: isHighContrast ? Colors.black : null,
          child: SizedBox(
            width: double.infinity,
            height: 120,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: imageAsset != null
                      ? SizedBox.expand(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              imageAsset!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      : icon != null
                      ? Center(child: Icon(icon, size: 40))
                      : SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
