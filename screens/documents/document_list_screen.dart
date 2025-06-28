import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/document_provider.dart';
import '../documents/document_detail_screen.dart';

class DocumentListScreen extends StatefulWidget {
  static const routeName = '/document-list';

  const DocumentListScreen({super.key});

  @override
  _DocumentListScreenState createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  String? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    // Tambahkan pengecekan provider agar error tidak terjadi
    try {
      final documents = Provider.of<DocumentProvider>(context, listen: true).documents;

      // Filter documents based on search, category, and date
      var filteredDocuments = documents;
      if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
        filteredDocuments =
            documents.where((doc) => doc.type == _selectedCategory).toList();
      }
      if (_searchController.text.isNotEmpty) {
        filteredDocuments = filteredDocuments
            .where((doc) =>
                doc.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                doc.type.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
      }
      if (_selectedDate != null) {
        filteredDocuments = filteredDocuments
            .where((doc) =>
                doc.uploadDate != null &&
                doc.uploadDate!.year == _selectedDate!.year &&
                doc.uploadDate!.month == _selectedDate!.month &&
                doc.uploadDate!.day == _selectedDate!.day)
            .toList();
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Dokumen'),
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Cari File',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3192),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: _selectedDate == null
                              ? ''
                              : "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
                        ),
                        decoration: InputDecoration(
                          hintText: 'Tanggal penyimpanan',
                          prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF2E3192)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF2E3192), width: 1),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        ),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedDate = picked;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Nama',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF2E3192), width: 1),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          ),
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryButton(Icons.description, 'Repertorium'),
                      const SizedBox(width: 12),
                      _buildCategoryButton(Icons.description, 'Akta'),
                      const SizedBox(width: 12),
                      _buildCategoryButton(Icons.verified, 'Legalisasi'),
                      const SizedBox(width: 12),
                      _buildCategoryButton(Icons.assignment_turned_in, 'Waarmeking'),
                      const SizedBox(width: 12),
                      _buildCategoryButton(Icons.note_add, 'Wasiat'),
                      const SizedBox(width: 12),
                      _buildCategoryButton(Icons.description, 'Waris'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: filteredDocuments.isEmpty
                      ? const Center(child: Text('Tidak ada dokumen ditemukan.'))
                      : ListView.builder(
                          itemCount: filteredDocuments.length,
                          itemBuilder: (ctx, index) {
                            final document = filteredDocuments[index];
                            return ListTile(
                              leading: const Icon(Icons.description),
                              title: Text(document.title),
                              subtitle: Text(
                                '${document.type} • ${document.uploadDate?.toLocal().toString().split(' ')[0] ?? ''}',
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  DocumentDetailScreen.routeName,
                                  arguments: document,
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Provider<DocumentProvider> belum diinisialisasi.\n'
            'Pastikan Provider<DocumentProvider> membungkus MaterialApp di main.dart.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }

  Widget _buildCategoryButton(IconData icon, String label) {
    final bool selected = _selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = selected ? null : label;
        });
      },
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEDF4FB) : const Color(0xFFF6FAFF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF2E3192) : const Color(0xFFBFD7ED),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(0xFF2E3192)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: const Color(0xFF2E3192),
                fontWeight: selected ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}