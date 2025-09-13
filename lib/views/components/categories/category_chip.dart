import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class ShoeSizeChip extends StatelessWidget {
  final String sizeLabel;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const ShoeSizeChip({
    super.key,
    required this.sizeLabel,
    this.isSelected = false,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,  // <-- handle selection
      child: Container(
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.sm),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade600 : Colors.grey[200],
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sizeLabel,
              style: GoogleFonts.poppins(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            if (onRemove != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onRemove,
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
