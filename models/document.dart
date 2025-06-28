class Document {
  final String id;
  final String title;
  final String type; // Repertorium, Akta, Legalisasi, Waarmeking, Wasiat, Waris
  final DateTime? uploadDate;
  final String? filePath;
  final String? status;
  final String? description; // Tambahan field untuk deskripsi dokumen
  final int? fileSize; // Tambahan field untuk ukuran file (dalam bytes)

  Document({
    required this.id,
    required this.title,
    required this.type,
    this.uploadDate,
    this.filePath,
    this.status = 'Pending', // Nilai default
    this.description,
    this.fileSize,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] ?? '', // Handle null safety
      title: json['title'] ?? 'Untitled Document',
      type: json['type'] ?? 'Akta', // Default ke 'Akta' jika null
      uploadDate: json['uploadDate'] != null ? DateTime.tryParse(json['uploadDate']) : null,
      filePath: json['filePath'],
      status: json['status'] ?? 'Pending',
      description: json['description'],
      fileSize: json['fileSize'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'uploadDate': uploadDate?.toIso8601String(),
      'filePath': filePath,
      'status': status,
      if (description != null) 'description': description,
      if (fileSize != null) 'fileSize': fileSize,
    };
  }

  // Helper method untuk menampilkan ukuran file yang lebih readable
  String get fileSizeFormatted {
    if (fileSize == null) return 'Unknown size';
    if (fileSize! < 1024) return '$fileSize B';
    if (fileSize! < 1048576) return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize! / 1048576).toStringAsFixed(1)} MB';
  }

  // Helper method untuk menampilkan tanggal upload yang diformat
  String get formattedUploadDate {
    return uploadDate?.toLocal().toString().split(' ')[0] ?? 'No date';
  }

  // Method untuk memeriksa apakah dokumen termasuk dalam kategori tertentu
  bool isCategory(String category) {
    return type.toLowerCase() == category.toLowerCase();
  }
}