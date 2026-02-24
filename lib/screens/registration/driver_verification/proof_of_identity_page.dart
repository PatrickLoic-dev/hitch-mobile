import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/providers/auth_provider.dart';
import 'package:Hitch/services/document_service.dart';
import 'package:Hitch/screens/registration/driver_verification/custom_camera_page.dart';
import 'package:Hitch/screens/registration/driver_verification/selfie_with_licence_page.dart';
import 'package:image_picker/image_picker.dart';

class ProofOfIdentityPage extends StatefulWidget {
  const ProofOfIdentityPage({super.key});

  @override
  State<ProofOfIdentityPage> createState() => _ProofOfIdentityPageState();
}

class _ProofOfIdentityPageState extends State<ProofOfIdentityPage> {
  File? _frontImageFile;
  File? _backImageFile;
  final ImagePicker _picker = ImagePicker();
  final DocumentService _documentService = DocumentService();

  Future<void> _uploadFile(File file, String name, String type) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final accountId = authProvider.user?.accountId;

    if (accountId == null) return;

    try {
      await _documentService.uploadDocument(
        filePath: file.path,
        documentName: name,
        accountId: accountId,
        fileType: type,
        issueDate: DateTime.now(),
      );
      print('Document uploaded successfully: $name');
    } catch (e) {
      print('Failed to upload document: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    }
  }

  Future<void> _openCustomCamera({required bool isFront}) async {
    final XFile? capturedImage = await Navigator.of(context).push<XFile>(
      MaterialPageRoute(
        builder: (context) => CustomCameraPage(isFront: isFront),
      ),
    );

    if (capturedImage != null) {
      final file = File(capturedImage.path);
      setState(() {
        if (isFront) {
          _frontImageFile = file;
        } else {
          _backImageFile = file;
        }
      });
      _uploadFile(
        file, 
        isFront ? "Driver License Front" : "Driver License Back", 
        isFront ? "LICENSE_FRONT" : "LICENSE_BACK"
      );
    }
  }

  Future<void> _pickFromGallery({required bool isFront}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        setState(() {
          if (isFront) {
            _frontImageFile = file;
          } else {
            _backImageFile = file;
          }
        });
        _uploadFile(
          file, 
          isFront ? "Driver License Front" : "Driver License Back", 
          isFront ? "LICENSE_FRONT" : "LICENSE_BACK"
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to access photos: $e')),
        );
      }
    }
  }

  void _deleteImage({required bool isFront}) {
    setState(() {
      if (isFront) {
        _frontImageFile = null;
      } else {
        _backImageFile = null;
      }
    });
  }

  void _showImageSourceModal({required bool isFront}) {
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
                      _openCustomCamera(isFront: isFront);
                    },
                  ),
                  const SizedBox(width: 24),
                  _ImageSourceOption(
                    iconPath: 'assets/images/gallery-icon.png',
                    label: 'Library',
                    onTap: () {
                      Navigator.of(modalContext).pop();
                      _pickFromGallery(isFront: isFront);
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

  void _continue() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SelfieWithLicencePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canContinue = _frontImageFile != null && _backImageFile != null;

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
                'Upload a proof of your Identity',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please upload the pictures of your driver\'s licence as asked',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Upload a photo of your driver licence',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _UploadBox(
                      iconPath: 'assets/images/upload-icon.png',
                      text: 'Upload an image of the front of your document',
                      onTap: () => _showImageSourceModal(isFront: true),
                      imageFile: _frontImageFile,
                      onDelete: () => _deleteImage(isFront: true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _UploadBox(
                      iconPath: 'assets/images/upload-icon.png',
                      text: 'Upload an image of the back of your document',
                      onTap: () => _showImageSourceModal(isFront: false),
                      imageFile: _backImageFile,
                      onDelete: () => _deleteImage(isFront: false),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: Button(
                  text: 'Continue',
                  onPressed: canContinue ? _continue : null,
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
          onTap: imageFile == null ? onTap : null,
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
