import 'package:flutter/material.dart';
import '../documents/upload_document_screen.dart' as upload;
import '../documents/document_list_screen.dart' as list;

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0F4F8), Color(0xFFD6EAF8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'e-Notary',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2E3192),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Platform Notarisasi Digital Terpercaya',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF34495E),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + _animation.value * 0.05,
                        child: Image.asset(
                          'assets/combined_assets.png',
                          width: 250,
                          height: 250,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildFeatureCard(
                      context,
                      icon: Icons.cloud_upload,
                      title: 'Unggah Dokumen',
                      color: Colors.blue,
                      onTap: () => _navigateTo(upload.UploadDocumentScreen.routeName),
                    ),
                    _buildFeatureCard(
                      context,
                      icon: Icons.search,
                      title: 'Cari Dokumen',
                      color: Colors.green,
                      onTap: () => _navigateTo(list.DocumentListScreen.routeName),
                    ),
                    _buildFeatureCard(
                      context,
                      icon: Icons.book,
                      title: 'Repertorium',
                      color: Colors.orange,
                      onTap: () => _navigateToWithArg(list.DocumentListScreen.routeName, 'Repertorium'),
                    ),
                    _buildFeatureCard(
                      context,
                      icon: Icons.description,
                      title: 'Akta',
                      color: Colors.purple,
                      onTap: () => _navigateToWithArg(list.DocumentListScreen.routeName, 'Akta'),
                    ),
                    _buildFeatureCard(
                      context,
                      icon: Icons.verified,
                      title: 'Legalisasi',
                      color: Colors.teal,
                      onTap: () => _navigateToWithArg(list.DocumentListScreen.routeName, 'Legalisasi'),
                    ),
                    _buildFeatureCard(
                      context,
                      icon: Icons.assignment_turned_in,
                      title: 'Waarmeking',
                      color: Colors.red,
                      onTap: () => _navigateToWithArg(list.DocumentListScreen.routeName, 'Waarmeking'),
                    ),
                    _buildFeatureCard(
                      context,
                      icon: Icons.note_add,
                      title: 'Wasiat',
                      color: Colors.indigo,
                      onTap: () => _navigateToWithArg(list.DocumentListScreen.routeName, 'Wasiat'),
                    ),
                    _buildFeatureCard(
                      context,
                      icon: Icons.family_restroom,
                      title: 'Waris',
                      color: Colors.deepOrange,
                      onTap: () => _navigateToWithArg(list.DocumentListScreen.routeName, 'Waris'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateTo(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  void _navigateToWithArg(String routeName, String argument) {
    Navigator.pushNamed(context, routeName, arguments: argument);
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6,
      shadowColor: color.withAlpha(76), // 0.3*255 ≈ 76
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, color.withAlpha(25)], // 0.1*255 ≈ 25
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 45, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color.withAlpha(204), // 0.8*255 ≈ 204
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}