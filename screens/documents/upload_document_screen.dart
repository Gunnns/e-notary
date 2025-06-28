import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/document_provider.dart';
import '../../models/document.dart';
import '../documents/document_detail_screen.dart';

class DocumentListScreen extends StatefulWidget {
  static const routeName = '/document-list';

  const DocumentListScreen({super.key});

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  String? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    // Simulasi loading data
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Dokumen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final documentProvider = Provider.of<DocumentProvider>(context);
    final documents = documentProvider.documents;

    final filteredDocuments = _filterDocuments(documents);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 16),
          _buildCategoryChips(),
          const SizedBox(height: 16),
          _buildDateFilter(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildDocumentList(filteredDocuments),
          ),
        ],
      ),
    );
  }

  List<Document> _filterDocuments(List<Document> documents) {
    var filtered = documents;

    // Filter by category
    if (_selectedCategory != null) {
      filtered = filtered.where((doc) => doc.isCategory(_selectedCategory!)).toList();
    }

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((doc) =>
          doc.title.toLowerCase().contains(query) ||
          doc.type.toLowerCase().contains(query) ||
          (doc.description?.toLowerCase().contains(query) ?? false)).toList();
    }

    // Filter by date
    if (_selectedDate != null) {
      filtered = filtered.where((doc) =>
        doc.uploadDate != null &&
        doc.uploadDate!.year == _selectedDate!.year &&
        doc.uploadDate!.month == _selectedDate!.month &&
        doc.uploadDate!.day == _selectedDate!.day
      ).toList();
    }

    return filtered;
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Cari dokumen...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _searchController.clear();
            setState(() {});
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildCategoryChips() {
    const categories = ['Repertorium', 'Akta', 'Legalisasi', 'Waarmeking', 'Wasiat', 'Waris'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(category),
              selected: _selectedCategory == category,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? category : null;
                });
              },
              selectedColor: Colors.blue[100],
              checkmarkColor: Colors.blue,
              labelStyle: TextStyle(
                color: _selectedCategory == category ? Colors.blue : Colors.black,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateFilter() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.calendar_today),
            label: Text(
              _selectedDate == null 
                ? 'Filter Tanggal' 
                : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
            ),
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  _selectedDate = pickedDate;
                });
              }
            },
          ),
        ),
        if (_selectedDate != null) ...[
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _selectedDate = null;
              });
            },
          ),
        ],
      ],
    );
  }

  Widget _buildDocumentList(List<Document> documents) {
    if (documents.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada dokumen ditemukan',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: _getDocumentIcon(document.type),
            title: Text(document.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Jenis: ${document.type}'),
                if (document.description != null) 
                  Text('Deskripsi: ${document.description!}'),
                Text('Tanggal: ${document.formattedUploadDate}'),
                Text('Ukuran: ${document.fileSizeFormatted}'),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(
                context,
                DocumentDetailScreen.routeName,
                arguments: document,
              );
            },
          ),
        );
      },
    );
  }

  Widget _getDocumentIcon(String type) {
    switch (type) {
      case 'Akta':
        return const Icon(Icons.description, color: Colors.blue);
      case 'Legalisasi':
        return const Icon(Icons.verified, color: Colors.green);
      case 'Wasiat':
        return const Icon(Icons.note_add, color: Colors.orange);
      case 'Waris':
        return const Icon(Icons.family_restroom, color: Colors.purple);
      case 'Waarmeking':
        return const Icon(Icons.assignment_turned_in, color: Colors.red);
      default:
        return const Icon(Icons.description, color: Colors.grey);
    }
  }

  Future<void> _showFilterDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Dokumen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCategoryDropdown(),
              const SizedBox(height: 16),
              _buildDateFilterField(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedCategory = null;
                  _selectedDate = null;
                });
                Navigator.pop(context);
              },
              child: const Text('Reset'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Terapkan'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryDropdown() {
    const categories = ['Semua', 'Repertorium', 'Akta', 'Legalisasi', 'Waarmeking', 'Wasiat', 'Waris'];
    
    return DropdownButtonFormField<String>(
      value: _selectedCategory ?? 'Semua',
      items: categories.map((category) {
        return DropdownMenuItem(
          value: category == 'Semua' ? null : category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Kategori Dokumen',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDateFilterField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tanggal Upload'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                _selectedDate == null
                    ? 'Pilih tanggal'
                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              ),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
            ),
            if (_selectedDate != null)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _selectedDate = null;
                  });
                },
              ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
