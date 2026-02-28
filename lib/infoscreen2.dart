import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  final String appTitle = 'UK DCD Risk Score';
  final String about =
      'This app is designed to complement the publication of the UK DCD Risk Score as described in the reference below. It is not intended to be a definitive '
      'means of prognostication. There may be other factors beyond those included in this tool that impact transplant outcomes.';
  final String disclaimer =
      'The calculations performed by this app are based on the work of the authors in the reference.';
  final String reference =
      'Schlegel A, Kalisvaart M, Scalera I, Laing RW, Mergental H, Mirza DF, Perera T, Isaac J, Dutkowski P, Muiesan P. J Hepatol. 2018 Mar;68(3):456-464. doi: 10.1016/j.jhep.2017.10.034. Epub 2017 Nov 15.';
  final String developer =
      "App developed by Marc L. Melcher, MD, PhD, Assoc. Prof. of Surgery, Stanford Univ.";

  Widget _buildSection(String title, String content, {bool isSmall = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: isSmall ? 13 : 15,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text("App Information", style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'images/logo2-200px.jpg',
                        height: 64,
                        width: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.medical_services, size: 64, color: Colors.blueGrey),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        appTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildSection("ABOUT", about),
              _buildSection("REFERENCE", reference),
              _buildSection("DISCLAIMER", disclaimer),
              _buildSection("DEVELOPER", developer, isSmall: true),
            ],
          ),
        ),
      ),
    );
  }
}
