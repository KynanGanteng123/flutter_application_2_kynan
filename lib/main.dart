import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning Dashboard - Tahap 15',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

// Fungsi pembaca file JSON secara asynchronous
Future<Map<String, dynamic>> loadStudentData() async {
  // CATATAN DEBUGGING KASUS C: 
  // Jika path diubah (misal: 'assets/data/wrong_path.json'), FutureBuilder akan menangkap error
  final jsonString = await rootBundle.loadString('assets/data/student_data.json');
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Deklarasi late Future agar diinisialisasi sekali di initState
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  // Reusable widget untuk Summary Card
  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          child: Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Learning Dashboard - Debugging',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: studentFuture,
          builder: (context, snapshot) {
            // 1. Loading State
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // 2. Error State (Manfaat error handling mencegah aplikasi crash)
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        'Gagal memuat data:\n${snapshot.error}',
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            // 3. Data Loaded Success
            final data = snapshot.data!;
            final student = data['student'] as Map<String, dynamic>;
            final courses = data['courses'] as List<dynamic>;

            final String nim = student['nim'] ?? '';
            final String name = student['name'] ?? '';

            // Hitung total SKS secara dinamis
            final int totalCredits = courses.fold(0, (sum, item) => sum + (item['credits'] as int));

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kartu Profil Mahasiswa & Pengujian Kasus A (Overflow Prevention dengan Expanded)
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.indigo,
                            backgroundImage: AssetImage('assets/images/profile.jpg'),
                          ),
                          const SizedBox(width: 16),
                          // Solusi Kasus A: Menggunakan Expanded agar teks panjang tidak RenderFlex Overflow
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'NIM: $nim - Selesai Tahap Debugging & Integrasi',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Summary Cards
                  Row(
                    children: [
                      _buildSummaryCard('Total Topik', '${courses.length} Modul', Icons.book, Colors.indigo),
                      const SizedBox(width: 8),
                      _buildSummaryCard('Total SKS', '$totalCredits SKS', Icons.military_tech, Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Header Daftar Materi
                  const Text(
                    'Daftar Materi Pembelajaran',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),

                  // Daftar List Materi dari JSON (ListView.builder dalam Expanded)
                  Expanded(
                    child: ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index] as Map<String, dynamic>;
                        final String title = course['title'] ?? '';
                        final String code = course['code'] ?? '';
                        final int credits = course['credits'] ?? 0;
                        final String status = course['status'] ?? 'planned';
                        final String category = course['category'] ?? 'General';

                        // Konfigurasi visual status
                        IconData statusIcon;
                        Color statusColor;
                        String statusText;
                        if (status == 'done') {
                          statusIcon = Icons.check_circle;
                          statusColor = Colors.green;
                          statusText = 'SELESAI';
                        } else if (status == 'active') {
                          statusIcon = Icons.sync;
                          statusColor = Colors.blue;
                          statusText = 'BERJALAN';
                        } else {
                          statusIcon = Icons.schedule;
                          statusColor = Colors.orange;
                          statusText = 'DIRENCANAKAN';
                        }

                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: Icon(statusIcon, color: statusColor),
                            title: Text(
                              title,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            subtitle: Text(
                              'Kode: $code • SKS: $credits\nKategori: $category',
                              style: const TextStyle(fontSize: 11),
                            ),
                            isThreeLine: true,
                            trailing: Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}