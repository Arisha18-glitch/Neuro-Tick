import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './clean_ar_screen.dart';

class ARHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arModels = [
      {
        'title': 'Solar System',
        'icon': Icons.rocket,
        'color': Colors.orange,
        'category': 'Astronomy',
        'description': 'Explore planets and stars',
      },
      {
        'title': 'Human Heart',
        'icon': Icons.favorite,
        'color': Colors.red,
        'category': 'Biology',
        'description': 'Anatomy and functions',
      },
      {
        'title': 'Chemistry Lab',
        'icon': Icons.science,
        'color': Colors.blue,
        'category': 'Chemistry',
        'description': 'Experiments and elements',
      },
      {
        'title': 'DNA Structure',
        'icon': Icons.psychology,
        'color': Colors.green,
        'category': 'Biology',
        'description': 'Genetic blueprint',
      },
      {
        'title': 'Physics Lab',
        'icon': Icons.bolt,
        'color': Colors.purple,
        'category': 'Physics',
        'description': 'Laws of motion',
      },
      {
        'title': 'Math Shapes',
        'icon': Icons.shape_line,
        'color': Colors.cyan,
        'category': 'Mathematics',
        'description': 'Geometric figures',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header - Fixed Height
              Container(
                height: 110,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.view_in_ar, size: 32, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AR Learning Lab',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Interactive 3D models for immersive learning',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Title Section
              Text(
                'Available Models',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap any model to explore in 3D/AR',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 16),

              // AR Models Grid - Takes remaining space
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75, // Better for mobile
                  ),
                  itemCount: arModels.length,
                  itemBuilder: (context, index) {
                    final model = arModels[index];
                    return _buildModelCard(context, model);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModelCard(BuildContext context, Map<String, dynamic> model) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: double.infinity,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: model['color'].withOpacity(0.08),
        border: Border.all(color: model['color'], width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>ForceARScreen(
                  modelName: model['title'],
                  category: model['category'],
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: model['color'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    model['icon'],
                    color: model['color'],
                    size: 22,
                  ),
                ),

                const SizedBox(height: 12),

                // Title
                Text(
                  model['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // Category Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: model['color'].withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    model['category'],
                    style: TextStyle(
                      color: model['color'],
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 8),

                // Description
                Text(
                  model['description'],
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const Spacer(),

                // AR Button
                Container(
                  height: 32,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: model['color'],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.view_in_ar, size: 14, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        'View in AR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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