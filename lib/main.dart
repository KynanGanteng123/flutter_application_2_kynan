import 'package:flutter/material.dart';

// ==========================================
// IDENTITAS MAHASISWA (Sesuai Aturan Bukti)
// ==========================================
const String studentName = 'Komang Kynan Tristan Amandio';
const String studentId = '215051040';

void main() {
  runApp(const EduPathApp());
}

class EduPathApp extends StatelessWidget {
  const EduPathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer - EduPath',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D9488),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
      home: const ResponsiveShell(),
    );
  }
}

// ==========================================
// DATA MODEL & DUMMY DATA
// ==========================================
class CourseItem {
  final String id;
  final String code;
  final String title;
  final String category;
  final String level;
  final String description;
  bool isBookmarked;

  CourseItem({
    required this.id,
    required this.code,
    required this.title,
    required this.category,
    required this.level,
    required this.description,
    this.isBookmarked = false,
  });
}

List<CourseItem> courseList = [
  CourseItem(
    id: '1',
    code: 'MOB04',
    title: 'Responsive Layout & Grid',
    category: 'Mobile Dev',
    level: 'Intermediate',
    description: 'Konsep dasar constraints, MediaQuery, LayoutBuilder, serta pembuatan tata letak adaptif untuk berbagai ukuran layar.',
  ),
  CourseItem(
    id: '2',
    code: 'MOB05',
    title: 'Multi-Screen Navigation',
    category: 'Architecture',
    level: 'Advanced',
    description: 'Penerapan Navigator stack, passing data antar screen, returning result, serta pola Adaptive Navigation (NavigationBar ↔ NavigationRail).',
  ),
  CourseItem(
    id: '3',
    code: 'MOB06',
    title: 'Interactions & Forms',
    category: 'User Experience',
    level: 'Beginner',
    description: 'Penanganan gestures, visual feedback (Ripple/InkWell), Form validation, dialog konfirmasi, dan SnackBar.',
  ),
  CourseItem(
    id: '4',
    code: 'MOB01',
    title: 'Dart Language Mastery',
    category: 'Fundamentals',
    level: 'Beginner',
    description: 'Sintaks dasar Dart, OOP, asynchronous programming, collection manipulation, dan null safety.',
  ),
  CourseItem(
    id: '5',
    code: 'MOB02',
    title: 'Flutter Widget Essentials',
    category: 'UI Design',
    level: 'Intermediate',
    description: 'Memahami Stateless vs Stateful widgets, lifecycle, composability, dan perancangan widget modular.',
  ),
];

// ==========================================
// TAHAP 10 & 11: ADAPTIVE SHELL
// ==========================================
class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    CatalogPage(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isLargeScreen = constraints.maxWidth >= 840;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Course Explorer Pro',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '$studentId - $studentName',
                  style: const TextStyle(fontSize: 12, color: Colors.teal),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: isLargeScreen
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _currentIndex,
                      onDestinationSelected: (index) => setState(() => _currentIndex = index),
                      labelType: NavigationRailLabelType.all,
                      selectedIconTheme: const IconThemeData(color: Color(0xFF0D9488)),
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.grid_view_outlined),
                          selectedIcon: Icon(Icons.grid_view_rounded),
                          label: Text('Dashboard'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.auto_stories_outlined),
                          selectedIcon: Icon(Icons.auto_stories_rounded),
                          label: Text('Katalog'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.badge_outlined),
                          selectedIcon: Icon(Icons.badge_rounded),
                          label: Text('Profil'),
                        ),
                      ],
                    ),
                    const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                    Expanded(child: _pages[_currentIndex]),
                  ],
                )
              : _pages[_currentIndex],
          bottomNavigationBar: isLargeScreen
              ? null
              : NavigationBar(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) => setState(() => _currentIndex = index),
                  indicatorColor: const Color(0xFFCCFBF1),
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.grid_view_outlined),
                      selectedIcon: Icon(Icons.grid_view_rounded),
                      label: 'Dashboard',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.auto_stories_outlined),
                      selectedIcon: Icon(Icons.auto_stories_rounded),
                      label: 'Katalog',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.badge_outlined),
                      selectedIcon: Icon(Icons.badge_rounded),
                      label: 'Profil',
                    ),
                  ],
                ),
        );
      },
    );
  }
}

// ==========================================
// SCREEN 1: DASHBOARD PAGE
// ==========================================
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Info Identitas & Layout State
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D9488), Color(0xFF115E59)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                  // KODE BARU:
const CircleAvatar(
  radius: 24,
  backgroundColor: Colors.white24,
  backgroundImage: AssetImage('assets/images/profile.jpg'),
),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            studentName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'NIM: $studentId',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _buildInfoBadge('Res: ${media.size.width.toInt()}x${media.size.height.toInt()}'),
                    _buildInfoBadge('Orientasi: ${media.orientation.name}'),
                    _buildInfoBadge(
                      'Layout: ${media.size.width < 600 ? "Compact" : media.size.width < 840 ? "Medium" : "Expanded"}',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Search Field
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari mata kuliah atau topik...',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search, color: Colors.teal),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Kategori Pembelajaran',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(label: const Text('Semua'), selected: true, onSelected: (_) {}),
              FilterChip(label: const Text('Mobile Dev'), selected: false, onSelected: (_) {}),
              FilterChip(label: const Text('Architecture'), selected: false, onSelected: (_) {}),
              FilterChip(label: const Text('UX Design'), selected: false, onSelected: (_) {}),
            ],
          ),
          const SizedBox(height: 24),

          const Text(
            'Mata Kuliah Utama',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: courseList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final course = courseList[index];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${course.code} • ${course.category}'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      course.level,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildInfoBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 11)),
    );
  }
}

// ==========================================
// SCREEN 2: CATALOG PAGE (RESPONSIVE GRID)
// ==========================================
class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  int _calculateColumns(double width) {
    if (width < 600) return 1;
    if (width < 840) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = _calculateColumns(constraints.maxWidth);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Katalog Materi ($studentId - $studentName)',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: cols == 1 ? 2.4 : 1.6,
                  ),
                  itemCount: courseList.length,
                  itemBuilder: (context, index) {
                    final item = courseList[index];
                    return CourseGridCard(course: item);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CourseGridCard extends StatefulWidget {
  final CourseItem course;
  const CourseGridCard({super.key, required this.course});

  @override
  State<CourseGridCard> createState() => _CourseGridCardState();
}

class _CourseGridCardState extends State<CourseGridCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => CourseDetailPage(course: widget.course),
            ),
          );

          if (result == true && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Status simpan ${widget.course.title} diperbarui!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
            setState(() {});
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCCFBF1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.course.code,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F766E),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      widget.course.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: widget.course.isBookmarked ? const Color(0xFF0D9488) : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.course.isBookmarked = !widget.course.isBookmarked;
                      });
                    },
                  ),
                ],
              ),
              Text(
                widget.course.title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                widget.course.category,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 3: DETAIL PAGE
// ==========================================
class CourseDetailPage extends StatefulWidget {
  final CourseItem course;
  const CourseDetailPage({super.key, required this.course});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Modul'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mahasiswa: $studentName', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('NIM: $studentId', style: const TextStyle(color: Colors.black87)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.course.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text('${widget.course.code} • ${widget.course.category}'),
              avatar: const Icon(Icons.label_important_outline, size: 16),
            ),
            const Divider(height: 32),
            const Text(
              'Deskripsi Materi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.course.description,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    widget.course.isBookmarked = !widget.course.isBookmarked;
                  });
                  Navigator.pop(context, true);
                },
                icon: Icon(widget.course.isBookmarked ? Icons.bookmark_remove : Icons.bookmark_add),
                label: Text(widget.course.isBookmarked ? 'Hapus Simpanan' : 'Simpan Modul Ini'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 4: USER PROFILE & FEEDBACK FORM
// ==========================================
class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: studentName);
  final _idCtrl = TextEditingController(text: studentId);
  final _commentCtrl = TextEditingController();
  bool _submitting = false;

  void _handleFormSubmit() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          title: const Text('Konfirmasi Pengiriman'),
          content: const Text('Apakah Anda yakin ingin mengirimkan umpan balik ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                setState(() => _submitting = true);

                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) {
                    setState(() => _submitting = false);
                    _commentCtrl.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Umpan balik berhasil terkirim!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                });
              },
              child: const Text('Ya, Kirim'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFFCCFBF1),
                    child: Icon(Icons.person, color: Color(0xFF0D9488), size: 32),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(studentName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('NIM: $studentId', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Formulir Umpan Balik Praktikum',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _idCtrl,
                  decoration: const InputDecoration(
                    labelText: 'NIM',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'NIM wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _commentCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Catatan / Feedback',
                    hintText: 'Tuliskan masukan minimal 5 karakter...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().length < 5) {
                      return 'Catatan minimal 5 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _submitting
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D9488),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _handleFormSubmit,
                          child: const Text('Kirim Umpan Balik'),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}