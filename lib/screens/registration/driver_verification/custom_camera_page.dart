import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomCameraPage extends StatefulWidget {
  final bool isFront;

  const CustomCameraPage({super.key, required this.isFront});

  @override
  State<CustomCameraPage> createState() => _CustomCameraPageState();
}

class _CustomCameraPageState extends State<CustomCameraPage> {
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  final GlobalKey _frameKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No cameras found');
      }

      _controller = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller.initialize();

    } catch(e) {
      print("Error initializing camera: $e");
      if(mounted) {
        // CORRECTION : Utilisation du Post-Frame Callback pour une navigation sûre
        SchedulerBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error initializing camera: $e')),
          );
          Navigator.pop(context);
        });
      }
      rethrow;
    }
  }

  @override
  void dispose() {
    // Il est important de s'assurer que le contrôleur a été initialisé
    // en vérifiant si la méthode `value` est accessible sans erreur.
    // Un simple `_controller != null` n'est pas suffisant.
    try {
      if (_controller.value.isInitialized) {
        _controller.dispose();
      }
    } catch (_) {
      // Le contrôleur n'a probablement jamais été initialisé, donc rien à faire.
    }
    super.dispose();
  }

  Future<void> _takePicture() async {
    // S'assurer que le contrôleur est initialisé avant de prendre une photo
    if (!_controller.value.isInitialized) {
      print("Controller is not initialized");
      return;
    }

    try {
      // La ligne `await _initializeControllerFuture;` est redondante si on vérifie au-dessus.
      final XFile image = await _controller.takePicture();

      if (!mounted) return;
      // CORRECTION : Utilisation du Post-Frame Callback ici aussi pour la navigation retour
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context, image);
      });

    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // Empêcher la reconstruction inutile de CameraPreview
                Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: CameraPreview(_controller),
                  ),
                ),
                _buildBlurOverlay(),
                _buildUI(),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
        },
      ),
    );
  }

  // ... le reste du code est identique ...

  Widget _buildBlurOverlay() {
    return ClipPath(
      clipper: _InvertedRRectClipper(key: _frameKey),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildUI() {
    String title = widget.isFront
        ? 'Take a picture of the front of your document'
        : 'Take a picture of the back of your document';
    String subtitle = 'Please make sure the driver licence fits into the box above.';

    return Column(
      children: [
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: const Icon(Icons.close, color: Color(0xFFA6EB2E), size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
        const Spacer(),
        Center(
          child: Container(
            key: _frameKey,
            height: 220,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Jokker',
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontFamily: 'Jokker',
            ),
          ),
        ),
        const Spacer(),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: GestureDetector(
              onTap: _takePicture,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InvertedRRectClipper extends CustomClipper<Path> {
  final GlobalKey key;
  _InvertedRRectClipper({required this.key});

  @override
  Path getClip(Size size) {
    if (key.currentContext == null) return Path();

    final RenderBox frameBox = key.currentContext!.findRenderObject() as RenderBox;
    final Offset framePosition = frameBox.localToGlobal(Offset.zero);
    final Size frameSize = frameBox.size;
    final Rect rect = Rect.fromLTWH(framePosition.dx, framePosition.dy, frameSize.width, frameSize.height);
    final RRect rrect = RRect.fromRectAndRadius(rect, const Radius.circular(16));

    return Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
