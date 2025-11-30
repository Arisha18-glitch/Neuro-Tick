import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopicChip extends StatelessWidget {
  final String label;

  const TopicChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.blue.shade50,
      label: Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.blue.shade800,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}