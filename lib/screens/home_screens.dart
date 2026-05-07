import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:focuslens_frontend/screens/results_screens.dart';
import 'dart:io';
import '../models/focus_models.dart';
import '../services/api_service.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? selectedFile;
  bool isLoading = false;
  bool indexAudio = false;
  String selectedLanguage = 'en';
  bool serverConnected = false;

  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'hi', 'name': 'Hindi'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'ja', 'name': 'Japanese'},
    {'code': 'de', 'name': 'German'},
  ];

  @override
  void initState() {
    super.initState();
    _checkServerConnection();
  }

  Future<void> _checkServerConnection() async {
    final connected = await ApiService.healthCheck();
    setState(() {
      serverConnected = connected;
    });
  }

  Future<void> _pickVideo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        allowCompression: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          selectedFile = File(result.files.first.path!);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Video selected: ${result.files.first.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _uploadSession() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a video file first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiService.uploadSession(
        videoFile: selectedFile!,
        indexAudio: indexAudio,
        languageCode: selectedLanguage,
      );

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ResultsScreen(response: response),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusLens'),
        elevation: 0,
        backgroundColor: const Color(0xFF6200EE),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Row(
                children: [
                  Icon(
                    serverConnected ? Icons.cloud_done : Icons.cloud_off,
                    color: serverConnected ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    serverConnected ? 'Connected' : 'Offline',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Analyze Your Study Session',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Upload a video to track focus and distraction patterns',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 32),

            // Server Connection Warning
            if (!serverConnected)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Server Not Connected',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Make sure the Flask backend is running at http://127.0.0.1:5000',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (!serverConnected) const SizedBox(height: 32),

            // Video Selection Card
            GestureDetector(
              onTap: _pickVideo,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF6200EE),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF6200EE).withOpacity(0.05),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.video_library,
                      size: 48,
                      color: const Color(0xFF6200EE),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select Video File',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap to choose a study session video\n(MP4, MOV, AVI, MKV, WebM - Max 500MB)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Selected File Info
            if (selectedFile != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'File Selected',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selectedFile!.path.split('/').last,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Audio Indexing Option
            Card(
              elevation: 0,
              color: const Color(0xFFF5F5F5),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Optional Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title: const Text('Index Audio'),
                      subtitle: const Text(
                          'Analyze spoken words in the video (slower)'),
                      value: indexAudio,
                      onChanged: (value) {
                        setState(() {
                          indexAudio = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    if (indexAudio) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Language:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: selectedLanguage,
                        items: languages
                            .map((lang) => DropdownMenuItem(
                          value: lang['code'],
                          child: Text(lang['name'] ?? ''),
                        ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedLanguage = value;
                            });
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Upload Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: serverConnected && !isLoading ? _uploadSession : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6200EE),
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  'Analyze Video',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}