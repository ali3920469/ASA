import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';

class AppDeveloper extends StatefulWidget {
  static const String screenRoute = '/app-developer';
  
  const AppDeveloper({super.key});

  @override
  State<AppDeveloper> createState() => _AppDeveloperState();
}

class _AppDeveloperState extends State<AppDeveloper> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentDeveloperTab = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  
  final Color _primaryColor = const Color.fromARGB(255, 46, 30, 169);
  final Color _secondaryColor = const Color(0xFFD4AF37);
  final Color _accentColor = const Color(0xFF8D6E63);
  final Color _successColor = const Color(0xFF2E7D32);
  final Color _warningColor = const Color(0xFFF57C00);
  final Color _errorColor = const Color(0xFFD32F2F);
  final Color _darkPrimaryColor = const Color(0xFF1B5E20);
  final Color _infoColor = const Color(0xFF1976D2);

  // بيانات المطورين
  final List<Map<String, dynamic>> developers = [
    {
      'id': 'DEV-001',
      'name': 'أحمد محمد',
      'role': 'Lead Developer',
      'email': 'ahmed@example.com',
      'phone': '07712345678',
      'joinDate': DateTime.now().subtract(const Duration(days: 365)),
      'projects': 12,
      'status': 'active',
      'avatar': Icons.code_rounded,
      'color': Colors.blue,
    },
    {
      'id': 'DEV-002',
      'name': 'فاطمة علي',
      'role': 'UI/UX Designer',
      'email': 'fatma@example.com',
      'phone': '07823456789',
      'joinDate': DateTime.now().subtract(const Duration(days: 240)),
      'projects': 8,
      'status': 'active',
      'avatar': Icons.design_services_rounded,
      'color': Colors.purple,
    },
    {
      'id': 'DEV-003',
      'name': 'خالد إبراهيم',
      'role': 'Backend Developer',
      'email': 'khalid@example.com',
      'phone': '07934567890',
      'joinDate': DateTime.now().subtract(const Duration(days: 180)),
      'projects': 6,
      'status': 'active',
      'avatar': Icons.storage_rounded,
      'color': Colors.green,
    },
  ];

  // بيانات المشاريع
  final List<Map<String, dynamic>> projects = [
    {
      'id': 'PRJ-001',
      'name': 'نظام إدارة الفواتير',
      'description': 'تطوير نظام شامل لإدارة فواتير الكهرباء',
      'status': 'قيد التطوير',
      'progress': 75,
      'startDate': DateTime.now().subtract(const Duration(days: 90)),
      'endDate': DateTime.now().add(const Duration(days: 30)),
      'developer': 'أحمد محمد',
      'priority': 'عالية',
      'tasks': 24,
      'completedTasks': 18,
    },
    {
      'id': 'PRJ-002',
      'name': 'تطبيق الهاتف المحمول',
      'description': 'تطوير تطبيق للمواطنين لمتابعة الفواتير',
      'status': 'مكتمل',
      'progress': 100,
      'startDate': DateTime.now().subtract(const Duration(days: 150)),
      'endDate': DateTime.now().subtract(const Duration(days: 10)),
      'developer': 'فاطمة علي',
      'priority': 'متوسطة',
      'tasks': 16,
      'completedTasks': 16,
    },
    {
      'id': 'PRJ-003',
      'name': 'لوحة التحكم',
      'description': 'تطوير لوحة تحكم للمحاسبين والمراقبين',
      'status': 'قيد التطوير',
      'progress': 45,
      'startDate': DateTime.now().subtract(const Duration(days: 45)),
      'endDate': DateTime.now().add(const Duration(days: 60)),
      'developer': 'خالد إبراهيم',
      'priority': 'عالية',
      'tasks': 20,
      'completedTasks': 9,
    },
    {
      'id': 'PRJ-004',
      'name': 'نظام التقارير',
      'description': 'تطوير نظام التقارير المالية والإحصائية',
      'status': 'معلق',
      'progress': 20,
      'startDate': DateTime.now().subtract(const Duration(days: 30)),
      'endDate': DateTime.now().add(const Duration(days: 45)),
      'developer': 'أحمد محمد',
      'priority': 'متوسطة',
      'tasks': 15,
      'completedTasks': 3,
    },
  ];

  // بيانات الميزات
  final List<Map<String, dynamic>> features = [
    {
      'id': 'FEAT-001',
      'name': 'نظام المصادقة',
      'description': 'تطوير نظام تسجيل الدخول والمصادقة',
      'status': 'مكتمل',
      'version': '1.0.0',
      'developer': 'أحمد محمد',
      'priority': 'عالية',
      'completionDate': DateTime.now().subtract(const Duration(days: 60)),
    },
    {
      'id': 'FEAT-002',
      'name': 'لوحة التحكم',
      'description': 'تطوير لوحة التحكم الرئيسية',
      'status': 'قيد التطوير',
      'version': '2.0.0',
      'developer': 'فاطمة علي',
      'priority': 'عالية',
      'progress': 60,
    },
    {
      'id': 'FEAT-003',
      'name': 'إدارة المواطنين',
      'description': 'نظام إدارة بيانات المواطنين',
      'status': 'مكتمل',
      'version': '1.2.0',
      'developer': 'خالد إبراهيم',
      'priority': 'عالية',
      'completionDate': DateTime.now().subtract(const Duration(days: 30)),
    },
    {
      'id': 'FEAT-004',
      'name': 'نظام الفواتير',
      'description': 'نظام إنشاء وإدارة الفواتير',
      'status': 'قيد التطوير',
      'version': '2.1.0',
      'developer': 'أحمد محمد',
      'priority': 'عالية',
      'progress': 80,
    },
    {
      'id': 'FEAT-005',
      'name': 'نظام الإشعارات',
      'description': 'نظام الإشعارات والتنبيهات',
      'status': 'مخطط',
      'version': '2.2.0',
      'developer': 'فاطمة علي',
      'priority': 'متوسطة',
    },
  ];

  // بيانات الأخطاء
  final List<Map<String, dynamic>> bugs = [
    {
      'id': 'BUG-001',
      'title': 'خطأ في عرض الفواتير',
      'description': 'عدم ظهور بعض الفواتير في قائمة الفواتير',
      'status': 'تم الإصلاح',
      'priority': 'عالية',
      'developer': 'أحمد محمد',
      'reportedDate': DateTime.now().subtract(const Duration(days: 7)),
      'fixedDate': DateTime.now().subtract(const Duration(days: 2)),
      'severity': 'حرج',
    },
    {
      'id': 'BUG-002',
      'title': 'بطء في تحميل البيانات',
      'description': 'تأخر في تحميل بيانات المواطنين',
      'status': 'قيد المعالجة',
      'priority': 'متوسطة',
      'developer': 'خالد إبراهيم',
      'reportedDate': DateTime.now().subtract(const Duration(days: 3)),
      'severity': 'متوسط',
    },
    {
      'id': 'BUG-003',
      'title': 'خطأ في التقارير',
      'description': 'عدم دقة البيانات في التقارير المالية',
      'status': 'مفتوح',
      'priority': 'عالية',
      'developer': 'أحمد محمد',
      'reportedDate': DateTime.now().subtract(const Duration(days: 1)),
      'severity': 'حرج',
    },
  ];

  // دوال المساعدة للألوان
  Color _backgroundColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF0F8FF);
  }
  
  Color _cardColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  }
  
  Color _textColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Colors.white : const Color(0xFF212121);
  }
  
  Color _textSecondaryColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF757575);
  }
  
  Color _borderColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? const Color(0xFF333333) : const Color(0xFFE0E0E0);
  }

  // دالة للبحث
  List<Map<String, dynamic>> get filteredDevelopers {
    if (_searchQuery.isEmpty) return developers;
    return developers.where((dev) {
      return dev['name'].contains(_searchQuery) ||
             dev['role'].contains(_searchQuery) ||
             dev['email'].contains(_searchQuery);
    }).toList();
  }

  List<Map<String, dynamic>> get filteredProjects {
    if (_searchQuery.isEmpty) return projects;
    return projects.where((proj) {
      return proj['name'].contains(_searchQuery) ||
             proj['description'].contains(_searchQuery) ||
             proj['developer'].contains(_searchQuery);
    }).toList();
  }

  List<Map<String, dynamic>> get filteredFeatures {
    if (_searchQuery.isEmpty) return features;
    return features.where((feat) {
      return feat['name'].contains(_searchQuery) ||
             feat['description'].contains(_searchQuery) ||
             feat['developer'].contains(_searchQuery);
    }).toList();
  }

  List<Map<String, dynamic>> get filteredBugs {
    if (_searchQuery.isEmpty) return bugs;
    return bugs.where((bug) {
      return bug['title'].contains(_searchQuery) ||
             bug['description'].contains(_searchQuery) ||
             bug['developer'].contains(_searchQuery);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: _secondaryColor, width: 2),
              ),
              child: Icon(Icons.code_rounded, color: _primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'فريق التطوير - لوحة التحكم',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: isDarkMode ? _darkPrimaryColor : _primaryColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, color: Colors.white, size: 26),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: _secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              // فتح شاشة الإشعارات
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? _darkPrimaryColor : _primaryColor,
              border: Border(
                bottom: BorderSide(color: _secondaryColor, width: 2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 4, color: _secondaryColor),
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.code_rounded, size: 22),
                    text: 'المطورين',
                  ),
                  Tab(
                    icon: Icon(Icons.folder_rounded, size: 22),
                    text: 'المشاريع',
                  ),
                  Tab(
                    icon: Icon(Icons.extension_rounded, size: 22),
                    text: 'الميزات',
                  ),
                  Tab(
                    icon: Icon(Icons.bug_report_rounded, size: 22),
                    text: 'الأخطاء',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF121212), Color(0xFF1A1A1A)],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF5F5F5), Color(0xFFE8F5E8)],
                ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // شريط البحث والإحصائيات
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSearchBar(isDarkMode),
                      const SizedBox(height: 16),
                      _buildStatsRow(isDarkMode),
                    ],
                  ),
                ),
                
                // المحتوى حسب التبويب
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDevelopersView(isDarkMode),
                      _buildProjectsView(isDarkMode),
                      _buildFeaturesView(isDarkMode),
                      _buildBugsView(isDarkMode),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _borderColor(context),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'ابحث عن مطور، مشروع، ميزة...',
          prefixIcon: Icon(Icons.search_rounded, color: _textSecondaryColor(context)),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, color: _textSecondaryColor(context)),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildStatsRow(bool isDarkMode) {
    int totalProjects = projects.length;
    int completedProjects = projects.where((p) => p['status'] == 'مكتمل').length;
    int activeFeatures = features.where((f) => f['status'] == 'قيد التطوير').length;
    int openBugs = bugs.where((b) => b['status'] == 'مفتوح').length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'المشاريع',
            value: totalProjects.toString(),
            subtitle: '$completedProjects مكتمل',
            icon: Icons.folder_rounded,
            color: _primaryColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            title: 'الميزات',
            value: features.length.toString(),
            subtitle: '$activeFeatures نشط',
            icon: Icons.extension_rounded,
            color: _infoColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            title: 'الأخطاء',
            value: bugs.length.toString(),
            subtitle: '$openBugs مفتوح',
            icon: Icons.bug_report_rounded,
            color: _errorColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: _textSecondaryColor(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textColor(context),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: _textSecondaryColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevelopersView(bool isDarkMode) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredDevelopers.length,
      itemBuilder: (context, index) {
        final developer = filteredDevelopers[index];
        return _buildDeveloperCard(developer, isDarkMode);
      },
    );
  }

  Widget _buildDeveloperCard(Map<String, dynamic> developer, bool isDarkMode) {
    int developerProjects = projects.where((p) => p['developer'] == developer['name']).length;
    int developerFeatures = features.where((f) => f['developer'] == developer['name']).length;
    int developerBugs = bugs.where((b) => b['developer'] == developer['name']).length;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _borderColor(context),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // رأس البطاقة
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: developer['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: developer['color'], width: 1),
                  ),
                  child: Icon(developer['avatar'], color: developer['color'], size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        developer['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: _textColor(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        developer['role'],
                        style: TextStyle(
                          fontSize: 14,
                          color: _textSecondaryColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _successColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    'نشط',
                    style: TextStyle(
                      fontSize: 12,
                      color: _successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // إحصائيات سريعة
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _backgroundColor(context),
              border: Border(
                top: BorderSide(color: _borderColor(context)),
                bottom: BorderSide(color: _borderColor(context)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniStat('المشاريع', developerProjects.toString(), _primaryColor),
                _buildMiniStat('الميزات', developerFeatures.toString(), _infoColor),
                _buildMiniStat('الأخطاء', developerBugs.toString(), _errorColor),
              ],
            ),
          ),
          
          // تفاصيل إضافية
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow('البريد الإلكتروني:', developer['email']),
                const SizedBox(height: 8),
                _buildInfoRow('رقم الهاتف:', developer['phone']),
                const SizedBox(height: 8),
                _buildInfoRow('تاريخ الانضمام:', DateFormat('yyyy-MM-dd').format(developer['joinDate'])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsView(bool isDarkMode) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredProjects.length,
      itemBuilder: (context, index) {
        final project = filteredProjects[index];
        return _buildProjectCard(project, isDarkMode);
      },
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project, bool isDarkMode) {
    Color statusColor = _getProjectStatusColor(project['status']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _borderColor(context),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // رأس البطاقة
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.folder_rounded, color: statusColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: _textColor(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        project['description'],
                        style: TextStyle(
                          fontSize: 12,
                          color: _textSecondaryColor(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    project['status'],
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // شريط التقدم
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'تقدم المشروع',
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondaryColor(context),
                      ),
                    ),
                    Text(
                      '${project['progress']}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: project['progress'] / 100,
                    backgroundColor: _borderColor(context),
                    valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // تفاصيل المشروع
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildProjectDetail(
                        'المطور:',
                        project['developer'],
                        Icons.person_rounded,
                      ),
                    ),
                    Expanded(
                      child: _buildProjectDetail(
                        'الأولوية:',
                        project['priority'],
                        Icons.priority_high_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildProjectDetail(
                        'تاريخ البدء:',
                        DateFormat('yyyy-MM-dd').format(project['startDate']),
                        Icons.calendar_today_rounded,
                      ),
                    ),
                    Expanded(
                      child: _buildProjectDetail(
                        'تاريخ الانتهاء:',
                        DateFormat('yyyy-MM-dd').format(project['endDate']),
                        Icons.event_available_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildProjectDetail(
                        'المهام المكتملة:',
                        '${project['completedTasks']}/${project['tasks']}',
                        Icons.check_circle_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesView(bool isDarkMode) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredFeatures.length,
      itemBuilder: (context, index) {
        final feature = filteredFeatures[index];
        return _buildFeatureCard(feature, isDarkMode);
      },
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature, bool isDarkMode) {
    Color statusColor = _getFeatureStatusColor(feature['status']);
    Color priorityColor = _getPriorityColor(feature['priority']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _borderColor(context),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.extension_rounded, color: statusColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: _textColor(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feature['description'],
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: priorityColor.withOpacity(0.3)),
                ),
                child: Text(
                  feature['priority'],
                  style: TextStyle(
                    fontSize: 10,
                    color: priorityColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildFeatureDetail(
                  'الحالة:',
                  feature['status'],
                  statusColor,
                ),
              ),
              Expanded(
                child: _buildFeatureDetail(
                  'الإصدار:',
                  feature['version'],
                  _infoColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: _buildFeatureDetail(
                  'المطور:',
                  feature['developer'],
                  _accentColor,
                ),
              ),
              if (feature['status'] == 'قيد التطوير' && feature.containsKey('progress'))
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'التقدم:',
                        style: TextStyle(
                          fontSize: 12,
                          color: _textSecondaryColor(context),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${feature['progress']}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              if (feature.containsKey('completionDate'))
                Expanded(
                  child: _buildFeatureDetail(
                    'تاريخ الإكمال:',
                    DateFormat('yyyy-MM-dd').format(feature['completionDate']),
                    _successColor,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBugsView(bool isDarkMode) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredBugs.length,
      itemBuilder: (context, index) {
        final bug = filteredBugs[index];
        return _buildBugCard(bug, isDarkMode);
      },
    );
  }

  Widget _buildBugCard(Map<String, dynamic> bug, bool isDarkMode) {
    Color statusColor = _getBugStatusColor(bug['status']);
    Color severityColor = _getSeverityColor(bug['severity']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _borderColor(context),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.bug_report_rounded, color: severityColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bug['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: _textColor(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bug['description'],
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: severityColor.withOpacity(0.3)),
                ),
                child: Text(
                  bug['severity'],
                  style: TextStyle(
                    fontSize: 10,
                    color: severityColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildBugDetail(
                  'الحالة:',
                  bug['status'],
                  statusColor,
                ),
              ),
              Expanded(
                child: _buildBugDetail(
                  'الأولوية:',
                  bug['priority'],
                  _getPriorityColor(bug['priority']),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Expanded(
                child: _buildBugDetail(
                  'المطور:',
                  bug['developer'],
                  _accentColor,
                ),
              ),
              Expanded(
                child: _buildBugDetail(
                  'تاريخ التبليغ:',
                  DateFormat('yyyy-MM-dd').format(bug['reportedDate']),
                  _textSecondaryColor(context),
                ),
              ),
            ],
          ),
          
          if (bug.containsKey('fixedDate'))
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: _buildBugDetail(
                      'تاريخ الإصلاح:',
                      DateFormat('yyyy-MM-dd').format(bug['fixedDate']),
                      _successColor,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // دوال مساعدة للبطاقات
  Widget _buildMiniStat(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: _textSecondaryColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _textSecondaryColor(context),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: _textColor(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectDetail(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: _textSecondaryColor(context)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            '$label $value',
            style: TextStyle(
              fontSize: 12,
              color: _textColor(context),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureDetail(String label, String value, Color color) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: _textSecondaryColor(context),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildBugDetail(String label, String value, Color color) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: _textSecondaryColor(context),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // دوال مساعدة للألوان
  Color _getProjectStatusColor(String status) {
    switch (status) {
      case 'قيد التطوير':
        return _infoColor;
      case 'مكتمل':
        return _successColor;
      case 'معلق':
        return _warningColor;
      default:
        return _textSecondaryColor(context);
    }
  }

  Color _getFeatureStatusColor(String status) {
    switch (status) {
      case 'مكتمل':
        return _successColor;
      case 'قيد التطوير':
        return _infoColor;
      case 'مخطط':
        return _accentColor;
      default:
        return _textSecondaryColor(context);
    }
  }

  Color _getBugStatusColor(String status) {
    switch (status) {
      case 'تم الإصلاح':
        return _successColor;
      case 'قيد المعالجة':
        return _warningColor;
      case 'مفتوح':
        return _errorColor;
      default:
        return _textSecondaryColor(context);
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'عالية':
        return _errorColor;
      case 'متوسطة':
        return _warningColor;
      case 'منخفضة':
        return _successColor;
      default:
        return _textSecondaryColor(context);
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'حرج':
        return _errorColor;
      case 'متوسط':
        return _warningColor;
      case 'بسيط':
        return _infoColor;
      default:
        return _textSecondaryColor(context);
    }
  }
}