import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe0f7fa),
      appBar: AppBar(
        title: Text('Community', style: GoogleFonts.poppins()),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Community Post 1
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.pink[100],
                          child: Icon(Icons.person, color: Colors.pink),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Alex Johnson', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('2 hours ago', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text('Just explored the Solar System in AR! Mind-blowing experience! 🌟'),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.favorite_border, size: 18, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('24'),
                        SizedBox(width: 16),
                        Icon(Icons.comment, size: 18, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('8'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),

            // Community Post 2
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.pink[100],
                          child: Icon(Icons.person, color: Colors.pink),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sarah Chen', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('5 hours ago', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text('The heart anatomy model helped me understand blood flow so much better! ❤️'),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.favorite_border, size: 18, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('42'),
                        SizedBox(width: 16),
                        Icon(Icons.comment, size: 18, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('15'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Create new post feature coming soon!')),
          );
        },
        backgroundColor: Colors.pink,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}