import 'package:flutter/material.dart';
import '../../models/document.dart';
import 'document_editor_screen.dart';

class UploadSuccessScreen extends StatelessWidget {
  static const routeName = '/upload-success';

  const UploadSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Document document = args['document'];
    final bool isNew = args['isNew'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Berhasil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Dokumen Berhasil Diunggah!',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Jenis: ${document.type}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Nama: ${document.title}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            if (isNew && document.type == 'Akta')
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    DocumentEditorScreen.routeName,
                    arguments: document,
                  );
                },
                child: const Text('Lanjutkan Pengetikan Akta'),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300] ?? Colors.grey,
                foregroundColor: Colors.black,
              ),
              child: const Text('Kembali ke Beranda'),
            ),
          ],
        ),
      ),
    );
  }
}