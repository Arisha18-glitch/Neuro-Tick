import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ForceARScreen extends StatefulWidget {
  final String modelName;
  final String category;

  const ForceARScreen({
    Key? key,
    required this.modelName,
    required this.category,
  }) : super(key: key);

  @override
  _ForceARScreenState createState() => _ForceARScreenState();
}

class _ForceARScreenState extends State<ForceARScreen> {
  ArCoreController? _arController;
  String _status = 'Initializing...';
  bool _isLoading = true;
  bool _showModelViewer = false;
  bool _arSupported = false;

  // Your GLB files mapping with paths
  final Map<String, String> _modelPaths = {
    'Solar System': 'assets/models/solar_system_custom.glb',
    'Human Heart': 'assets/models/realistic_human_heart.glb',
    'Chemistry Lab': 'assets/models/chemistry.glb',
    'DNA Structure': 'assets/models/dna.glb',
    'Physics Lab': 'assets/models/pendulum.glb',
    'Math Shapes': 'assets/models/geometric_shapes.glb',
  };

  @override
  void initState() {
    super.initState();
    _checkARSupport();
  }

  Future<void> _checkARSupport() async {
    try {
      // Check AR availability
      bool arAvailable = await ArCoreController.checkArCoreAvailability();

      if (arAvailable) {
        setState(() {
          _arSupported = true;
          _isLoading = false;
          _status = 'AR is ready!';
        });
      } else {
        setState(() {
          _arSupported = false;
          _showModelViewer = true;
          _isLoading = false;
          _status = 'AR not available. Showing 3D viewer.';
        });
      }
    } catch (e) {
      // If AR check fails, show model viewer
      setState(() {
        _arSupported = false;
        _showModelViewer = true;
        _isLoading = false;
        _status = 'Showing 3D Model Viewer';
      });
    }
  }

  void _onARViewCreated(ArCoreController controller) {
    _arController = controller;

    // Setup tap to place
    _arController?.onPlaneTap = _onPlaneTap;

    setState(() {
      _status = 'AR Ready! Tap surfaces to place ${widget.modelName}';
    });

    // Auto-place model after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && _arController != null) {
        _placeARModel();
      }
    });
  }

  void _onPlaneTap(List<ArCoreHitTestResult> hits) {
    if (hits.isEmpty || _arController == null) return;

    final hit = hits.first;
    _placeARModelAtPosition(hit);
  }

  void _placeARModel() {
    try {
      String? modelPath = _modelPaths[widget.modelName];
      if (modelPath == null) {
        setState(() {
          _status = 'Model not found. Switching to 3D viewer...';
        });
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _showModelViewer = true;
            });
          }
        });
        return;
      }

      ArCoreReferenceNode modelNode = ArCoreReferenceNode(
        name: widget.modelName,
        objectUrl: modelPath,
        position: vector.Vector3(0, 0, -2.0),
        scale: vector.Vector3(0.4, 0.4, 0.4),
      );

      _arController!.addArCoreNode(modelNode);

      setState(() {
        _status = '✅ ${widget.modelName} loaded in AR!';
      });
    } catch (e) {
      setState(() {
        _status = 'AR failed: $e. Switching to 3D viewer...';
      });

      // Fallback to Model Viewer
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _showModelViewer = true;
          });
        }
      });
    }
  }

  void _placeARModelAtPosition(ArCoreHitTestResult hit) {
    try {
      String? modelPath = _modelPaths[widget.modelName];
      if (modelPath == null) return;

      ArCoreReferenceNode modelNode = ArCoreReferenceNode(
        name: '${widget.modelName}_${DateTime.now().millisecondsSinceEpoch}',
        objectUrl: modelPath,
        position: vector.Vector3(
          hit.pose.translation.x,
          hit.pose.translation.y,
          hit.pose.translation.z,
        ),
        scale: vector.Vector3(0.3, 0.3, 0.3),
      );

      _arController!.addArCoreNode(modelNode);

      setState(() {
        _status = '✅ ${widget.modelName} placed!';
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to place: $e';
      });
    }
  }

  void _switchToModelViewer() {
    setState(() {
      _showModelViewer = true;
    });
  }

  void _switchToARView() {
    setState(() {
      _showModelViewer = false;
    });
  }

  Color _getCategoryColor() {
    switch (widget.category) {
      case 'Astronomy': return Colors.orange;
      case 'Biology': return Colors.red;
      case 'Chemistry': return Colors.blue;
      case 'Physics': return Colors.purple;
      case 'Mathematics': return Colors.cyan;
      default: return Colors.green;
    }
  }

  IconData _getCategoryIcon() {
    switch (widget.modelName) {
      case 'Solar System': return Icons.public;
      case 'Human Heart': return Icons.favorite;
      case 'Chemistry Lab': return Icons.science;
      case 'DNA Structure': return Icons.psychology;
      case 'Physics Lab': return Icons.bolt;
      case 'Math Shapes': return Icons.shape_line;
      default: return Icons.view_in_ar;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = _getCategoryColor();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.modelName),
        backgroundColor: color,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_arSupported && !_showModelViewer)
            IconButton(
              icon: const Icon(Icons.switch_left),
              onPressed: _switchToModelViewer,
              tooltip: 'Switch to 3D Viewer',
            ),
          if (_arSupported && _showModelViewer)
            IconButton(
              icon: const Icon(Icons.view_in_ar),
              onPressed: _switchToARView,
              tooltip: 'Switch to AR',
            ),
        ],
      ),
      body: _buildBody(color),
    );
  }

  Widget _buildBody(Color color) {
    if (_isLoading) {
      return _buildLoading(color);
    }

    if (_showModelViewer || !_arSupported) {
      return _buildModelViewer(color);
    }

    return _buildARView(color);
  }

  Widget _buildLoading(Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: color),
          const SizedBox(height: 20),
          Text(
            _status,
            style: TextStyle(color: color, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildModelViewer(Color color) {
    String? modelPath = _modelPaths[widget.modelName];

    if (modelPath == null) {
      return _buildModelNotFound(color);
    }

    return Column(
      children: [
        // Model Viewer
        Expanded(
          child: ModelViewer(
            src: modelPath,
            alt: widget.modelName,
            ar: false,
            autoRotate: true,
            cameraControls: true,
            backgroundColor: Colors.black,
            loading: Loading.eager,
            iosSrc: modelPath,
          ),
        ),

        // Controls Panel
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.black87,
          child: Column(
            children: [
              // Model Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.modelName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: color),
                        ),
                        child: Text(
                          widget.category,
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    _getCategoryIcon(),
                    color: color,
                    size: 32,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Instructions
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.touch_app, color: color, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Drag to rotate • Pinch to zoom • Use controls for more options',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // AR Button if available
              if (_arSupported)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _switchToARView,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.view_in_ar, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'View in Augmented Reality',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModelNotFound(Color color) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              'Model Not Found',
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Could not find ${widget.modelName}.glb',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Please check if the file exists in assets/models/ folder',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Go Back',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildARView(Color color) {
    return Stack(
      children: [
        // AR Camera View
        ArCoreView(
          onArCoreViewCreated: _onARViewCreated,
          enableTapRecognizer: true,
          enablePlaneRenderer: true,
        ),

        // Status Bar
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Instructions
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  '🔄 ${widget.modelName}',
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Move phone to detect surfaces • Tap to place model',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Loading: ${_modelPaths[widget.modelName]?.split('/').last ?? 'Unknown'}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _arController?.dispose();
    super.dispose();
  }
}