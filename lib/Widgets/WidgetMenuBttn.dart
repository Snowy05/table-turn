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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: imageAsset != null
                        ? Image.asset(imageAsset!, fit: BoxFit.contain)
                        : icon != null
                        ? Icon(icon, size: 40)
                        : SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
