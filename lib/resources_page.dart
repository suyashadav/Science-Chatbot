import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PDFResource {
  final String title;
  final String url;
  final String thumbnail;

  PDFResource({
    required this.title,
    required this.url,
    required this.thumbnail,
  });
}

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  List<PDFResource> pdfResources = [
    PDFResource(
      title: 'Science Chapter 1',
      url: 'assets/Science-chp1.pdf',
      thumbnail: 'assets/images/sci-chp1.png',
    ),
    PDFResource(
      title: 'Science Chapter 2',
      url: 'assets/Science-chp2.pdf',
      thumbnail: 'assets/images/sci-chp2.png',
    ),
  ];

  bool _isLoading = false;
  String? _currentPdfTitle;

  Future<String> _getLocalPdfPath(String assetPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${assetPath.split('/').last}');
    
    if (!await file.exists()) {
      final byteData = await DefaultAssetBundle.of(context).load(assetPath);
      await file.writeAsBytes(byteData.buffer.asUint8List());
    }
    
    return file.path;
  }

  void _viewPdf(BuildContext context, PDFResource resource) async {
    setState(() {
      _isLoading = true;
      _currentPdfTitle = resource.title;
    });

    try {
      final localPath = await _getLocalPdfPath(resource.url);

      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(
            filePath: localPath,
            title: resource.title,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load PDF: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
        backgroundColor: const Color(0xFFFBE4A7),
      ),
      backgroundColor: const Color(0xFFFBE4A7),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Loading $_currentPdfTitle...',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: pdfResources.length,
                itemBuilder: (context, index) {
                  final resource = pdfResources[index];
                  return _buildPdfCard(context, resource);
                },
              ),
            ),
    );
  }

  Widget _buildPdfCard(BuildContext context, PDFResource resource) {
    return GestureDetector(
      onTap: () => _viewPdf(context, resource),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.asset(
                  resource.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.picture_as_pdf, size: 50),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                resource.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String filePath;
  final String title;

  const PDFViewerScreen({
    super.key,
    required this.filePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFFBE4A7),
      ),
      body: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('PDF Error: $error')),
          );
        },
        onPageError: (page, error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error on page $page: $error')),
          );
        },
      ),
    );
  }
}