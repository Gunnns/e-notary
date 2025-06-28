import 'package:flutter/material.dart';
import '../models/document.dart';

class DocumentProvider with ChangeNotifier {
  List<Document> _documents = [];
  String _searchQuery = '';
  
  List<Document> get documents {
    if (_searchQuery.isEmpty) {
      return _documents;
    }
    return _documents.where((doc) => 
      doc.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      doc.type.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void addDocument(Document document) {
    _documents.add(document);
    notifyListeners();
  }

  List<Document> getDocumentsByType(String type) {
    return _documents.where((doc) => doc.type == type).toList();
  }
}