import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/providers/auth_provider.dart';
import 'package:Hitch/services/document_service.dart';
import 'package:image_picker/image_picker.dart';

class SelfieWithLicencePage extends StatefulWidget {
  const SelfieWithLicencePage({super.key});

  @override
  State<SelfieWithLicencePage> createState() => _SelfieWithLicencePageState();
}

class _SelfieWithLicencePageState extends State<SelfieWithLicencePage> {
  File? _selfieImageFile;
  final ImagePicker _picker = ImagePicker();
  final DocumentService _documentService = DocumentService();

  Future<void> _uploadSelfie(File file) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final accountId = authProvider.user?.accountId;

    if (accountId == null) return;

    try {
      await _documentService.uploadDocument(
        filePath: file.path,
        documentName: "Selfie with License",
        accountId: accountId,
        fileType: "SELFIE_WITH_LICENSE",
        issueDate: DateTime.now(),
      );
      print('Selfie uploaded successfully');
    } catch (e) {
      print('Failed to upload selfie: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    }
  }

  Future<void> _openCamera() async {
    try {
      final XFile? capturedImage = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.front,
      );

      if (capturedImage != null) {
        final file = File(capturedImage.path);
        setState(() {
          _selfieImageFile = file;
        });
        _uploadSelfie(file);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to access camera: $e')),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        setState(() {
          _selfieImageFile = file;
        });
        _uploadSelfie(file);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to access photos: $e')),
        );
      }
    }
  }

  void _deleteImage() {
    setState(() {
      _selfieImageFile = null;
    });
  }

  void _uploadSelfieAction() {
    _showImageSourceModal();
  }

  void _showImageSourceModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose an option',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _ImageSourceOption(
                    iconPath: 'assets/images/camera-icon.png',
                    label: 'Camera',
                    onTap: () {
                      Navigator.of(modalContext).pop();
                      _openCamera();
                    },
                  ),
                  const SizedBox(width: 24),
                  _ImageSourceOption(
                    iconPath: 'assets/images/gallery-icon.png',
                    label: 'Library',
                    onTap: () {
                      Navigator.of(modalContext).pop();
                      _pickFromGallery();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitVerification() {
    final homeContext = context;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (dialogContext) => _VerificationInProgressModal(
        onReturnHome: () {
          Navigator.of(dialogContext).pop();
          Navigator.of(homeContext).popUntil((route) => route.isFirst);
        },
      ),
    );

    Timer(const Duration(seconds: 4), () {
      if (Navigator.of(homeContext).canPop()) {
        Navigator.of(homeContext, rootNavigator: true).pop();
      }

      showModalBottomSheet(
        context: homeContext,
        builder: (_) => const _VerificationSuccessModal(),
      );

      Timer(const Duration(seconds: 3), () {
        if (Navigator.of(homeContext).canPop()) {
          Navigator.of(homeContext, rootNavigator: true).pop();
        }
        Navigator.of(homeContext).popUntil((route) => route.isFirst);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool canSubmit = _selfieImageFile != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 24),
              const Text(
                'Upload a picture of yourself holding your licence',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'We will compare your selfie with your document',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Please ensure:',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              const _RequirementItem(text: 'To take the picture in good light'),
              const _RequirementItem(text: 'There is no glare on the licence'),
              const _RequirementItem(text: 'The details are in focus'),
              const _RequirementItem(text: 'The licence isn’t covering your face'),
              const SizedBox(height: 32),
              _UploadBox(
                iconPath: 'assets/images/upload-icon.png',
                text: 'Upload an image',
                onTap: _uploadSelfieAction,
                imageFile: _selfieImageFile,
                onDelete: _deleteImage,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: Button(
                  text: 'Submit verification',
                  onPressed: canSubmit ? _submitVerification : null,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerificationInProgressModal extends StatelessWidget {
  final VoidCallback onReturnHome;

  const _VerificationInProgressModal({required this.onReturnHome});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFA6EB2E)),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Verifying your identity',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Jokker',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'These may take a about 24 to 48 hours. We’d send you a notification when your documents have been checked.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Jokker',
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: Button(
              text: 'Return Home',
              onPressed: onReturnHome,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerificationSuccessModal extends StatelessWidget {
  const _VerificationSuccessModal();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/verification.png',
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 24),
          const Text(
            'You’ve earned a badge',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Jokker',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your accounts has been verified, you can now offer and join rides',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Jokker',
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final String text;
  const _RequirementItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Jokker',
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final File? imageFile;

  const _UploadBox({
    required this.iconPath,
    required this.text,
    required this.onTap,
    required this.onDelete,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: imageFile == null
              ? onTap
              : null,
          child: Container(
            height: 170,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.5),
              child: imageFile != null
                  ? Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(iconPath, width: 40, height: 40),
                          const SizedBox(height: 12),
                          Text(
                            text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Jokker',
                              color: Color(0xFFA6EB2E),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
        if (imageFile != null)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/trash-icon.png',
                  width: 16,
                  height: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ImageSourceOption extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const _ImageSourceOption({
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(iconPath),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Jokker',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
