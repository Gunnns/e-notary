import 'package:flutter/material.dart';

class DocumentListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const DocumentListItem({super.key, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
