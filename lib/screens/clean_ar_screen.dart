import 'dart:async';
import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

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
  ArCoreController? _arCoreController;
  String _status = 'Initializing AR...';
  int _objectCount = 0;
  bool _arStarted = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkARSupport();
  }

  Future<void> _checkARSupport() async {
    try {
      bool isSupported = await ArCoreController.checkArCoreAvailability();

      if (isSupported) {
        setState(() {
          _arStarted = true;
          _status = 'ARCore is ready!';
        });
      } else {
        setState(() {
          _hasError = true;
          _status = 'ARCore not available';
          _errorMessage = 'Please install ARCore from Play Store';
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _status = 'AR Check failed';
        _errorMessage = e.toString();
      });
    }
  }

  void _onARViewCreated(ArCoreController controller) {
    try {
      _arCoreController = controller;

      // Setup tap detection
      _arCoreController?.onPlaneTap = _handlePlaneTap;

      _arCoreController?.onNodeTap = (nodeName) {
        _removeNode(nodeName);
      };

      setState(() {
        _status = 'AR Active! Move phone to detect surfaces';
      });

      // Add initial object
      Timer(const Duration(milliseconds: 1000), () {
        if (_arCoreController != null && mounted) {
          _addInitialObject();
        }
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _status = 'Failed to create AR view';
        _errorMessage = e.toString();
      });
    }
  }

  void _handlePlaneTap(List<ArCoreHitTestResult> hits) {
    try {
      if (hits.isEmpty || _arCoreController == null) return;

      final hit = hits.first;

      final newNode = ArCoreNode(
        shape: _create3DShape(),
        position: vector.Vector3(
          hit.pose.translation.x,
          hit.pose.translation.y + 0.05,
          hit.pose.translation.z,
        ),
      );

      _arCoreController!.addArCoreNode(newNode);

      setState(() {
        _objectCount++;
        _status = '${widget.modelName} placed! Total: $_objectCount';
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to place object: ${e.toString()}';
      });
    }
  }

  void _removeNode(String nodeName) {
    try {
      _arCoreController?.removeNode(nodeName: nodeName);
      setState(() {
        _objectCount--;
        _status = 'Object removed';
      });
    } catch (e) {
      // Ignore remove errors
    }
  }

  dynamic _create3DShape() {
    final color = _getCategoryColor();

    switch (widget.modelName) {
      case 'Solar System':
        return ArCoreSphere(
          materials: [ArCoreMaterial(color: Colors.yellow)],
          radius: 0.2,
        );

      case 'Human Heart':
        return ArCoreCube(
          materials: [ArCoreMaterial(color: Colors.red)],
          size: vector.Vector3(0.25, 0.25, 0.25),
        );

      case 'Chemistry Lab':
        return ArCoreCylinder(
          materials: [ArCoreMaterial(color: Colors.blue)],
          radius: 0.12,
          height: 0.3,
        );

      case 'DNA Structure':
        return ArCoreSphere(
          materials: [ArCoreMaterial(color: Colors.green)],
          radius: 0.15,
        );

      case 'Physics Lab':
        return ArCoreCube(
          materials: [ArCoreMaterial(color: Colors.purple)],
          size: vector.Vector3(0.22, 0.22, 0.22),
        );

      case 'Math Shapes':
        return ArCoreCylinder(
          materials: [ArCoreMaterial(color: Colors.cyan)],
          radius: 0.1,
          height: 0.25,
        );

      default:
        return ArCoreSphere(
          materials: [ArCoreMaterial(color: color)],
          radius: 0.15,
        );
    }
  }

  void _addInitialObject() {
    try {
      final node = ArCoreNode(
        shape: _create3DShape(),
        position: vector.Vector3(0, 0, -1.5),
      );

      _arCoreController?.addArCoreNode(node);
      setState(() {
        _objectCount = 1;
        _status = 'Tap surfaces to place more';
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to add object: ${e.toString()}';
      });
    }
  }

  void _clearAll() {
    try {
      // Properly dispose and reset
      _safeDisposeARController();

      setState(() {
        _objectCount = 0;
        _status = 'Restarting AR...';
        _arStarted = false;
        _arCoreController = null;
      });

      // Reinitialize after delay
      Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _arStarted = true;
            _status = 'AR restarting...';
          });
          _checkARSupport();
        }
      });
    } catch (e) {
      setState(() {
        _status = 'Reset failed: ${e.toString()}';
      });
    }
  }

  void _safeDisposeARController() {
    try {
      if (_arCoreController != null) {
        _arCoreController!.dispose();
      }
    } catch (e) {
      // Ignore disposal errors
      debugPrint('Safe dispose error: $e');
    } finally {
      _arCoreController = null;
    }
  }

  Color _getCategoryColor() {
    switch (widget.category) {
      case 'Astronomy': return Colors.orange;
      case 'Biology': return Colors.red;
      case 'Chemistry': return Colors.blue;
      case 'Physics': return Colors.purple;
      case 'Mathematics': return Colors.cyan;
      default: return Colors.deepPurple;
    }
  }

  @override
  void dispose() {
    _safeDisposeARController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('${widget.modelName} - AR'),
        backgroundColor: color,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clearAll,
            tooltip: 'Reset AR',
          ),
        ],
      ),
      body: _buildBody(color),
    );
  }

  Widget _buildBody(Color color) {
    if (_hasError) {
      return _buildErrorScreen(color);
    }

    if (!_arStarted) {
      return _buildLoading(color);
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
            style: TextStyle(color: color, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen(Color color) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              'AR Not Available',
              style: TextStyle(
                fontSize: 24,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _status,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
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
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green, width: 2),
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Controls
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  'AR ACTIVE',
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '• Move phone SLOWLY to detect surfaces\n• Tap on floor/table to place objects',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Objects: $_objectCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _clearAll,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text('CLEAR ALL'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}