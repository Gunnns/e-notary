import 'package:flutter/material.dart';
import '../../models/document.dart';

class DocumentEditorScreen extends StatefulWidget {
  static const routeName = '/document-editor';

  const DocumentEditorScreen({super.key});

  @override
  _DocumentEditorScreenState createState() => _DocumentEditorScreenState();
}

class _DocumentEditorScreenState extends State<DocumentEditorScreen> {
  late Document _document;
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final args = ModalRoute.of(context)!.settings.arguments as Document;
    _document = args;
    // TODO: Load document content from API or file
    _contentController.text = 'Isi akta akan ditampilkan di sini...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editor Akta - ${_document.title}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDocument,
            tooltip: 'Simpan Perubahan',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Mulai mengetik isi akta di sini...',
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveDocument,
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveDocument() {
    // TODO: Implement save functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perubahan telah disimpan')),
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}