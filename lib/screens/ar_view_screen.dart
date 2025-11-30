import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ARViewScreen extends StatelessWidget {
  final String topicName;
  final String topicDescription;

  const ARViewScreen({
    super.key,
    required this.topicName,
    required this.topicDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('AR View', style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // AR View Placeholder
          Expanded(
            child: Container(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.view_in_ar, size: 100, color: Colors.white),
                  SizedBox(height: 20),
                  Text(
                    'AR View for:',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    topicName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      topicDescription,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    '📍 Move your device to place the 3D model',
                    style: TextStyle(color: Colors.white54),
                  ),
                  Text(
                    '👆 Tap and drag to rotate',
                    style: TextStyle(color: Colors.white54),
                  ),
                  Text(
                    '🤏 Pinch to zoom',
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),

          // Controls Bar
          Container(
            color: Colors.grey[900],
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildControlButton(Icons.rotate_left, 'Rotate', context),
                _buildControlButton(Icons.zoom_in, 'Zoom', context),
                _buildControlButton(Icons.center_focus_strong, 'Reset', context),
                _buildControlButton(Icons.info_outline, 'Info', context),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('3D model placed in your space! 🎯')),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String label, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$label control activated')),
            );
          },
        ),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}