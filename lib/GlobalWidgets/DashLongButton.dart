import 'package:flutter/material.dart';

/// A long card button with a picture on top and text below
class DashLongButton extends StatelessWidget {
  final String label;
  final String? imageAsset;
  final VoidCallback onTap;
  final double size;
  final double height;

  const DashLongButton({
    super.key,
    required this.label,
    this.imageAsset,
    required this.onTap,
    this.size = 120,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    final isHighContrast =
        Theme.of(context).colorScheme.primary == Colors.black;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          side: const BorderSide(color: Colors.transparent, width: 0),
        ),
        margin: EdgeInsets.zero,
        child: SizedBox(
          width: size,
          height: height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
                child: Image.asset(
                  imageAsset ?? '',
                  width: size,
                  height: height * 0.8,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: height * 0.2,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(),
                  border: Border(
                    right: BorderSide(color: Colors.black, width: 0.5),
                    left: BorderSide(color: Colors.black, width: 0.5),
                    bottom: BorderSide(color: Colors.black, width: 0.5),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
