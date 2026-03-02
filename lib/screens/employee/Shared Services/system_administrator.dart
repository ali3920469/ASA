import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';
import 'package:mang_mu/screens/employee/Shared Services/esignin_screen.dart';

class SystemAdministrator extends StatefulWidget {
  static const String screenRoute = '/system-administrator';

  const SystemAdministrator({super.key});

  @override
  State<SystemAdministrator> createState() => _SystemAdministratorState();
}

class _SystemAdministratorState extends State<SystemAdministrator>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // متغيرات البحث والتصفية
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatusFilter = 'الكل';

  // الألوان (منسقة مع باقي الشاشات)
  final Color _primaryColor = const Color.fromARGB(255, 46, 30, 169);
  final Color _secondaryColor = const Color(0xFFD4AF37);
  final Color _accentColor = const Color(0xFF8D6E63);
  final Color _successColor = const Color(0xFF2E7D32);
  final Color _warningColor = const Color(0xFFF57C00);
  final Color _errorColor = const Color(0xFFD32F2F);
  final Color _infoColor = const Color(0xFF1976D2);

  // قوائم البيانات التجريبية للمستخدمين
  final List<Map<String, dynamic>> _allUsers = [
    {
      'id': 'USR-001',
      'name': 'أحمد محمد',
      'email': 'ahmed@example.com',
      'role': 'مدير النظام',
      'department': 'تقنية المعلومات',
      'status': 'نشط',
      'lastLogin': DateTime.now().subtract(const Duration(hours: 2)),
      'permissions': ['كل الصلاحيات'],
      'avatar': 'A',
    },
    {
      'id': 'USR-002',
      'name': 'سارة أحمد',
      'email': 'sara@example.com',
      'role': 'موظف الأحداث',
      'department': 'الأحداث',
      'status': 'نشط',
      'lastLogin': DateTime.now().subtract(const Duration(days: 1)),
      'permissions': ['إدارة الأحداث', 'عرض التقارير'],
      'avatar': 'S',
    },
    {
      'id': 'USR-003',
      'name': 'محمد علي',
      'email': 'mohammed@example.com',
      'role': 'موظف الكهرباء',
      'department': 'الكهرباء',
      'status': 'غير نشط',
      'lastLogin': DateTime.now().subtract(const Duration(days: 5)),
      'permissions': ['إدارة الكهرباء'],
      'avatar': 'M',
    },
    {
      'id': 'USR-004',
      'name': 'فاطمة حسن',
      'email': 'fatima@example.com',
      'role': 'موظف الماء',
      'department': 'الماء',
      'status': 'نشط',
      'lastLogin': DateTime.now().subtract(const Duration(hours: 5)),
      'permissions': ['إدارة الماء'],
      'avatar': 'F',
    },
    {
      'id': 'USR-005',
      'name': 'عمر خالد',
      'email': 'omar@example.com',
      'role': 'موظف النفايات',
      'department': 'البلدية',
      'status': 'نشط',
      'lastLogin': DateTime.now().subtract(const Duration(minutes: 30)),
      'permissions': ['إدارة النفايات'],
      'avatar': 'O',
    },
  ];

  // قائمة سجلات النظام
  final List<Map<String, dynamic>> _systemLogs = [
    {
      'id': 'LOG-001',
      'action': 'تسجيل دخول',
      'user': 'أحمد محمد',
      'details': 'تم تسجيل الدخول بنجاح',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'ip': '192.168.1.100',
      'status': 'نجاح',
    },
    {
      'id': 'LOG-002',
      'action': 'تعديل صلاحيات',
      'user': 'أحمد محمد',
      'details': 'تم تعديل صلاحيات المستخدم سارة أحمد',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'ip': '192.168.1.100',
      'status': 'نجاح',
    },
    {
      'id': 'LOG-003',
      'action': 'محاولة دخول فاشلة',
      'user': 'غير معروف',
      'details': 'محاولة دخول فاشلة باستخدام البريد admin@example.com',
      'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
      'ip': '45.67.89.123',
      'status': 'فشل',
    },
    {
      'id': 'LOG-004',
      'action': 'نسخ احتياطي',
      'user': 'نظام آلي',
      'details': 'تم إنشاء نسخة احتياطية كاملة للنظام',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'ip': '127.0.0.1',
      'status': 'نجاح',
    },
  ];

  // قائمة حالات النظام
  final List<Map<String, dynamic>> _systemServices = [
    {'name': 'بوابة الدفع', 'status': 'عامل', 'uptime': '15 يوم', 'load': '23%'},
    {'name': 'قاعدة البيانات', 'status': 'عامل', 'uptime': '30 يوم', 'load': '45%'},
    {'name': 'خادم التطبيق', 'status': 'عامل', 'uptime': '14 يوم', 'load': '32%'},
    {'name': 'خدمة الإشعارات', 'status': 'عامل', 'uptime': '7 أيام', 'load': '12%'},
    {'name': 'خادم الملفات', 'status': 'صيانة', 'uptime': '0 يوم', 'load': '0%'},
  ];

  // قائمة النسخ الاحتياطية
  final List<Map<String, dynamic>> _backups = [
    {
      'id': 'BKP-001',
      'date': DateTime.now().subtract(const Duration(hours: 6)),
      'size': '2.5 GB',
      'type': 'كامل',
      'status': 'مكتمل',
    },
    {
      'id': 'BKP-002',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'size': '2.4 GB',
      'type': 'كامل',
      'status': 'مكتمل',
    },
    {
      'id': 'BKP-003',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'size': '500 MB',
      'type': 'جزئي',
      'status': 'مكتمل',
    },
  ];

  final List<String> _statuses = ['الكل', 'نشط', 'غير نشط'];

  // دوال المساعدة للألوان
  Color _getStatusColor(String status) {
    switch (status) {
      case 'نشط':
      case 'نجاح':
      case 'عامل':
      case 'مكتمل':
        return _successColor;
      case 'غير نشط':
      case 'فشل':
      case 'معطل':
        return _errorColor;
      case 'صيانة':
        return _warningColor;
      default:
        return _textSecondaryColor(context);
    }
  }

  // دالة لجلب المستخدمين المفلترين
  List<Map<String, dynamic>> get _filteredUsers {
    return _allUsers.where((user) {
      final matchesSearch = _searchQuery.isEmpty ||
          user['name'].contains(_searchQuery) ||
          user['email'].contains(_searchQuery) ||
          user['role'].contains(_searchQuery);

      final matchesStatus = _selectedStatusFilter == 'الكل' ||
          user['status'] == _selectedStatusFilter;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  // دوال للألوان
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // المستخدمين - السجلات - الخدمات - النسخ
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العنوان والصورة
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: _primaryColor.withOpacity(0.1),
                      child: Text(
                        user['avatar'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _textColor(context),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(user['status']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              user['status'],
                              style: TextStyle(
                                fontSize: 12,
                                color: _getStatusColor(user['status']),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // التفاصيل
                _buildDetailRow('البريد الإلكتروني', user['email'], Icons.email_rounded, context),
                _buildDetailRow('الدور', user['role'], Icons.admin_panel_settings_rounded, context),
                _buildDetailRow('الدائرة', user['department'], Icons.business_rounded, context),
                _buildDetailRow('آخر تسجيل دخول', DateFormat('yyyy/MM/dd HH:mm').format(user['lastLogin']), Icons.access_time_rounded, context),

                const SizedBox(height: 16),

                // الصلاحيات
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _borderColor(context)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.security_rounded, color: _primaryColor, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'الصلاحيات',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _textColor(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...user['permissions'].map<Widget>((permission) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_rounded, color: _successColor, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                permission,
                                style: TextStyle(
                                  color: _textSecondaryColor(context),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // الأزرار
                Row(
                  children: [
                   
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showDeleteConfirmation(user);
                        },
                        icon: const Icon(Icons.delete_rounded, size: 18),
                        label: const Text('حذف'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _errorColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('إغلاق', style: TextStyle(color: _textSecondaryColor(context))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _primaryColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label: $value',
              style: TextStyle(
                fontSize: 14,
                color: _textColor(context),
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: _errorColor),
            const SizedBox(width: 8),
            const Text('تأكيد الحذف'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من حذف "${item['name'] ?? item['id']}"؟',
          style: TextStyle(color: _textColor(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor(context))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allUsers.removeWhere((u) => u['id'] == item['id']);
              });
              Navigator.pop(context);
              _showSuccessSnackbar('تم الحذف بنجاح');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _successColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _performLogout() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 8),
            const Text('تم تسجيل الخروج بنجاح'),
          ],
        ),
        backgroundColor: _successColor,
        duration: const Duration(seconds: 2),
      ),
    );
    Navigator.pushReplacementNamed(context, EsigninScreen.screenroot);
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: _errorColor),
            const SizedBox(width: 8),
            const Text('تأكيد تسجيل الخروج'),
          ],
        ),
        content: const Text(
          'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: _accentColor)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }


  void _showRestoreBackupDialog(Map<String, dynamic> backup) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.restore_rounded, color: _warningColor),
            const SizedBox(width: 8),
            const Text('استعادة النسخة الاحتياطية'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من استعادة النسخة ${backup['id']} من تاريخ ${DateFormat('yyyy/MM/dd HH:mm').format(backup['date'])}؟',
          style: TextStyle(color: _textColor(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor(context))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackbar('جاري استعادة النظام...');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _warningColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('استعادة'),
          ),
        ],
      ),
    );
  }

  void _showSystemSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SystemSettingsScreen(
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          accentColor: _accentColor,
          successColor: _successColor,
          warningColor: _warningColor,
          errorColor: _errorColor,
          totalUsers: _allUsers.length,  // تمرير عدد المستخدمين
        activeServices: _systemServices.where((s) => s['status'] == 'عامل').length, // تمرير عدد الخدمات النشطة
        ),
      ),
    );
  }
  void _showServiceDetails(Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(service['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildServiceDetailRow('الحالة', service['status'], _getStatusColor(service['status'])),
            _buildServiceDetailRow('مدة التشغيل', service['uptime'], _infoColor),
            _buildServiceDetailRow('الحمل', service['load'], _warningColor),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: _primaryColor)),
          ),
          if (service['status'] == 'صيانة')
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSuccessSnackbar('جاري تشغيل الخدمة...');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _successColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('تشغيل'),
            ),
        ],
      ),
    );
  }

  Widget _buildServiceDetailRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStatistics() {
    int totalUsers = _allUsers.length;
    int activeUsers = _allUsers.where((u) => u['status'] == 'نشط').length;
    int inactiveUsers = _allUsers.where((u) => u['status'] == 'غير نشط').length;
    int successfulLogs = _systemLogs.where((l) => l['status'] == 'نجاح').length;
    int failedLogs = _systemLogs.where((l) => l['status'] == 'فشل').length;
    int activeServices = _systemServices.where((s) => s['status'] == 'عامل').length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.pie_chart_rounded, color: _primaryColor),
            const SizedBox(width: 8),
            const Text('إحصائيات النظام'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatCard('إجمالي المستخدمين', totalUsers.toString(), Icons.people_rounded, _primaryColor),
              const SizedBox(height: 8),
              _buildStatRow('مستخدمين نشطين', activeUsers, _successColor),
              _buildStatRow('مستخدمين غير نشطين', inactiveUsers, _errorColor),
              const Divider(height: 24),
              _buildStatCard('سجلات النظام', _systemLogs.length.toString(), Icons.history_rounded, _infoColor),
              _buildStatRow('عمليات ناجحة', successfulLogs, _successColor),
              _buildStatRow('عمليات فاشلة', failedLogs, _errorColor),
              const Divider(height: 24),
              _buildStatCard('خدمات نشطة', '$activeServices/${_systemServices.length}', Icons.build_rounded, _warningColor),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: _primaryColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(label),
            ],
          ),
          Text(
            count.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ================ القائمة المنسدلة ================
  Widget _buildSystemDrawer(BuildContext context, bool isDarkMode) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode 
                ? [const Color(0xFF1B5E20), const Color(0xFF0D1B0E)]
                : [_primaryColor, const Color(0xFF4CAF50)],
          ),
        ),
        child: Column(
          children: [
            // رأس الملف الشخصي
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDarkMode 
                      ? [const Color(0xFF1B5E20), const Color(0xFF0D4715)]
                      : [_primaryColor, const Color(0xFF388E3C)],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(
                      Icons.admin_panel_settings_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "مدير النظام",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "مسؤول إدارة النظام - ${DateFormat('yyyy/MM/dd').format(DateTime.now())}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "الصلاحيات: كاملة",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // القائمة الرئيسية
            Expanded(
              child: Container(
                color: isDarkMode ? const Color(0xFF0D1B0E) : const Color(0xFFE8F5E9),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 20),
                    
                    // الإعدادات والمساعدة
                    _buildDrawerHeader('الإعدادات', Icons.settings_rounded, isDarkMode),
                    
                    _buildDrawerMenuItem(
                      icon: Icons.settings_rounded,
                      title: 'إعدادات النظام',
                      onTap: () {
                        Navigator.pop(context);
                        _showSystemSettings();
                      },
                      isDarkMode: isDarkMode,
                    ),
                    // تسجيل الخروج
                    _buildDrawerMenuItem(
                      icon: Icons.logout_rounded,
                      title: 'تسجيل الخروج',
                      onTap: _showLogoutConfirmation,
                      isDarkMode: isDarkMode,
                      isLogout: true,
                    ),

                    const SizedBox(height: 40),
                    
                    // معلومات النسخة
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Divider(
                            color: isDarkMode ? Colors.white24 : Colors.grey[400],
                            height: 1,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'وزارة الكهرباء - نظام إدارة النظام',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.grey[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'الإصدار 1.0.0',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white54 : Colors.grey[600],
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(String title, IconData icon, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: _primaryColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: _primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Divider(
              color: _primaryColor.withOpacity(0.3),
              thickness: 1,
              indent: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDarkMode,
    bool isLogout = false,
  }) {
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color iconColor = isLogout 
        ? Colors.red 
        : (isDarkMode ? Colors.white70 : Colors.grey[700]!);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isLogout ? Colors.red.withOpacity(0.1) : Colors.transparent,
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isLogout 
                ? Colors.red.withOpacity(0.2)
                : (isDarkMode ? Colors.white12 : Colors.grey[100]),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red : textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_left_rounded,
          color: isLogout ? Colors.red : (isDarkMode ? Colors.white54 : Colors.grey[500]),
          size: 24,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  void _showExportOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.download_rounded, color: _primaryColor),
            const SizedBox(width: 8),
            const Text('تصدير التقارير'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildExportOption(
              'تقرير المستخدمين',
              'قائمة بجميع المستخدمين',
              Icons.people_rounded,
              () {
                Navigator.pop(context);
                _showSuccessSnackbar('جاري تصدير تقرير المستخدمين...');
              },
            ),
            _buildExportOption(
              'تقرير سجلات النظام',
              'سجل جميع العمليات',
              Icons.history_rounded,
              () {
                Navigator.pop(context);
                _showSuccessSnackbar('جاري تصدير سجلات النظام...');
              },
            ),
            _buildExportOption(
              'تقرير الخدمات',
              'حالة جميع الخدمات',
              Icons.build_rounded,
              () {
                Navigator.pop(context);
                _showSuccessSnackbar('جاري تصدير تقرير الخدمات...');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor(context))),
          ),
        ],
      ),
    );
  }

  Widget _buildExportOption(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: _primaryColor),
      ),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      onTap: onTap,
    );
  }

  // ================ بناء الواجهة الرئيسية ================
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

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
              child: Icon(Icons.admin_panel_settings_rounded, color: _primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'وزارة الكهرباء - نظام مدير النظام',
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
        backgroundColor: themeProvider.isDarkMode ? const Color(0xFF1B5E20) : _primaryColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        
      ),
      drawer: _buildSystemDrawer(context, themeProvider.isDarkMode),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: themeProvider.isDarkMode
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
        child: Column(
          children: [

            // تبويبات النظام
            Container(
              decoration: BoxDecoration(
                color: _cardColor(context),
                border: Border(
                  bottom: BorderSide(color: _borderColor(context), width: 1),
                  top: BorderSide(color: _borderColor(context), width: 1),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: _secondaryColor,
                indicatorWeight: 3,
                labelColor: _primaryColor,
                unselectedLabelColor: _textSecondaryColor(context),
                tabs: const [
                  Tab(text: 'المستخدمين', icon: Icon(Icons.people_rounded)),
                  Tab(text: 'سجلات النظام', icon: Icon(Icons.history_rounded)),
                  Tab(text: 'الخدمات', icon: Icon(Icons.build_rounded)),
                  Tab(text: 'النسخ الاحتياطي', icon: Icon(Icons.backup_rounded)),
                ],
              ),
            ),

            // محتوى التبويبات
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // تبويب المستخدمين
                  _filteredUsers.isEmpty
                      ? _buildEmptyState(context, 'المستخدمين')
                      : _buildUsersList(_filteredUsers, context),

                  // تبويب سجلات النظام
                  _systemLogs.isEmpty
                      ? _buildEmptyState(context, 'السجلات')
                      : _buildLogsList(_systemLogs, context),

                  // تبويب الخدمات
                  _systemServices.isEmpty
                      ? _buildEmptyState(context, 'الخدمات')
                      : _buildServicesList(_systemServices, context),

                  // تبويب النسخ الاحتياطي
                  _backups.isEmpty
                      ? _buildEmptyState(context, 'النسخ الاحتياطية')
                      : _buildBackupsList(_backups, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemOverviewCard(BuildContext context) {
    int activeUsers = _allUsers.where((u) => u['status'] == 'نشط').length;
    int activeServices = _systemServices.where((s) => s['status'] == 'عامل').length;
    int totalLogs = _systemLogs.length;

    return Card(
      elevation: 4,
      color: _cardColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.dashboard_rounded, color: _primaryColor),
                const SizedBox(width: 8),
                Text(
                  'نظرة عامة على النظام',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textColor(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOverviewStatItem('المستخدمين النشطين', activeUsers.toString(), Icons.people_rounded, _successColor),
                _buildOverviewStatItem('الخدمات العاملة', '$activeServices/${_systemServices.length}', Icons.build_rounded, _infoColor),
                _buildOverviewStatItem('إجمالي السجلات', totalLogs.toString(), Icons.history_rounded, _warningColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _textColor(context),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: _textSecondaryColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
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
        border: Border.all(color: _borderColor(context), width: 1),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'ابحث عن مستخدم...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.filter_alt_rounded, color: _primaryColor, size: 18),
                const SizedBox(width: 4),
                const Text('تصفية:'),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ..._statuses.map((status) => _buildFilterChip(status, _selectedStatusFilter, (value) {
                setState(() => _selectedStatusFilter = value);
              }, context)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String selectedValue, Function(String) onSelected, BuildContext context) {
    bool isSelected = selectedValue == label;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(label),
        selectedColor: _primaryColor.withOpacity(0.2),
        checkmarkColor: _primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? _primaryColor : _textColor(context),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: isSelected ? _primaryColor : _borderColor(context)),
        ),
      ),
    );
  }

  // قائمة المستخدمين
  Widget _buildUsersList(List<Map<String, dynamic>> users, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserCard(user, context);
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user, BuildContext context) {
    Color statusColor = _getStatusColor(user['status']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        border: Border.all(color: _borderColor(context), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: _primaryColor.withOpacity(0.1),
          child: Text(
            user['avatar'],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
        ),
        title: Text(
          user['name'],
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: _textColor(context),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              user['email'],
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor(context),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                // الدور
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _infoColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user['role'],
                    style: TextStyle(
                      fontSize: 10,
                      color: _infoColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // الحالة
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user['status'],
                        style: TextStyle(
                          fontSize: 10,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded, color: _textSecondaryColor(context)),
          onSelected: (value) {
            if (value == 'delete') {
              _showDeleteConfirmation(user);
            } else if (value == 'permissions') {
              _showSuccessSnackbar('تم فتح إدارة صلاحيات ${user['name']}');
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_rounded, color: Color(0xFF2E7D32)),
                  SizedBox(width: 8),
                  Text('تعديل'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'permissions',
              child: Row(
                children: [
                  Icon(Icons.security_rounded, color: Color(0xFF1976D2)),
                  SizedBox(width: 8),
                  Text('إدارة الصلاحيات'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_rounded, color: Color(0xFFD32F2F)),
                  SizedBox(width: 8),
                  Text('حذف'),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _showUserDetails(user),
      ),
    );
  }

  // قائمة سجلات النظام
  Widget _buildLogsList(List<Map<String, dynamic>> logs, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return _buildLogCard(log, context);
      },
    );
  }

  Widget _buildLogCard(Map<String, dynamic> log, BuildContext context) {
    Color statusColor = _getStatusColor(log['status']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        border: Border.all(color: _borderColor(context), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            log['status'] == 'نجاح' ? Icons.check_circle_rounded : Icons.error_rounded,
            color: statusColor,
            size: 24,
          ),
        ),
        title: Text(
          log['action'],
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: _textColor(context),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              log['details'],
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor(context),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                // المستخدم
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _infoColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    log['user'],
                    style: TextStyle(
                      fontSize: 10,
                      color: _infoColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // الوقت
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    DateFormat('HH:mm').format(log['timestamp']),
                    style: TextStyle(
                      fontSize: 10,
                      color: _accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // IP
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    log['ip'],
                    style: TextStyle(
                      fontSize: 10,
                      color: _warningColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: _cardColor(context),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(log['action']),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('التفاصيل', log['details'], Icons.description_rounded, context),
                  _buildDetailRow('المستخدم', log['user'], Icons.person_rounded, context),
                  _buildDetailRow('IP', log['ip'], Icons.computer_rounded, context),
                  _buildDetailRow('الوقت', DateFormat('yyyy/MM/dd HH:mm:ss').format(log['timestamp']), Icons.access_time_rounded, context),
                  _buildDetailRow('الحالة', log['status'], Icons.circle_rounded, context),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('إغلاق', style: TextStyle(color: _primaryColor)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // قائمة الخدمات
  Widget _buildServicesList(List<Map<String, dynamic>> services, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceCard(service, context);
      },
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service, BuildContext context) {
    Color statusColor = _getStatusColor(service['status']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        border: Border.all(color: _borderColor(context), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.build_rounded,
            color: statusColor,
            size: 24,
          ),
        ),
        title: Text(
          service['name'],
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: _textColor(context),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildServiceIndicator('الحالة', service['status'], statusColor),
                ),
                Expanded(
                  child: _buildServiceIndicator('مدة التشغيل', service['uptime'], _infoColor),
                ),
                Expanded(
                  child: _buildServiceIndicator('الحمل', service['load'], _warningColor),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.refresh_rounded, color: _primaryColor),
          onPressed: () {
            _showSuccessSnackbar('جاري إعادة تشغيل الخدمة...');
          },
        ),
        onTap: () => _showServiceDetails(service),
      ),
    );
  }

  Widget _buildServiceIndicator(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: _textSecondaryColor(context),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // قائمة النسخ الاحتياطية
  Widget _buildBackupsList(List<Map<String, dynamic>> backups, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: backups.length,
      itemBuilder: (context, index) {
        final backup = backups[index];
        return _buildBackupCard(backup, context);
      },
    );
  }

  Widget _buildBackupCard(Map<String, dynamic> backup, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        border: Border.all(color: _borderColor(context), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.backup_rounded,
            color: _primaryColor,
            size: 24,
          ),
        ),
        title: Text(
          backup['id'],
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: _textColor(context),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'التاريخ: ${DateFormat('yyyy/MM/dd HH:mm').format(backup['date'])}',
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor(context),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _infoColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'الحجم: ${backup['size']}',
                    style: TextStyle(
                      fontSize: 10,
                      color: _infoColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'النوع: ${backup['type']}',
                    style: TextStyle(
                      fontSize: 10,
                      color: _warningColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded, color: _textSecondaryColor(context)),
          onSelected: (value) {
            if (value == 'restore') {
              _showRestoreBackupDialog(backup);
            } else if (value == 'download') {
              _showSuccessSnackbar('جاري تحميل النسخة الاحتياطية...');
            } else if (value == 'delete') {
              setState(() {
                _backups.remove(backup);
              });
              _showSuccessSnackbar('تم حذف النسخة الاحتياطية');
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'restore',
              child: Row(
                children: [
                  Icon(Icons.restore_rounded, color: Color(0xFF1976D2)),
                  SizedBox(width: 8),
                  Text('استعادة'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'download',
              child: Row(
                children: [
                  Icon(Icons.download_rounded, color: Color(0xFF2E7D32)),
                  SizedBox(width: 8),
                  Text('تحميل'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_rounded, color: Color(0xFFD32F2F)),
                  SizedBox(width: 8),
                  Text('حذف'),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: _cardColor(context),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(backup['id']),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDetailRow('التاريخ', DateFormat('yyyy/MM/dd HH:mm').format(backup['date']), Icons.calendar_today_rounded, context),
                  _buildDetailRow('الحجم', backup['size'], Icons.storage_rounded, context),
                  _buildDetailRow('النوع', backup['type'], Icons.category_rounded, context),
                  _buildDetailRow('الحالة', backup['status'], Icons.check_circle_rounded, context),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor(context))),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showRestoreBackupDialog(backup);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _warningColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('استعادة'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String type) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              type == 'المستخدمين' ? Icons.people_outline_rounded :
              type == 'السجلات' ? Icons.history_rounded :
              type == 'الخدمات' ? Icons.build_rounded :
              Icons.backup_rounded,
              size: 60,
              color: _primaryColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد $type',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _textSecondaryColor(context),
            ),
          ),
          if (type == 'المستخدمين')
            const SizedBox(height: 8),
          if (type == 'المستخدمين')
            Text(
              'يمكنك إضافة مستخدم جديد باستخدام زر +',
              style: TextStyle(
                color: _textSecondaryColor(context),
              ),
            ),
        ],
      ),
    );
  }
}

// ========== شاشة إعدادات النظام ==========
class SystemSettingsScreen extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;
  final int totalUsers;        // إضافة هذا المتغير
  final int activeServices;    // إضافة هذا المتغير


  const SystemSettingsScreen({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.successColor,
    required this.warningColor,
    required this.errorColor,
    required this.totalUsers,      // مطلوب
    required this.activeServices,  // مطلوب
  }) : super(key: key);

  @override
  State<SystemSettingsScreen> createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen> {
  bool _autoBackup = true;
  bool _emailNotifications = true;
  bool _detailedLogs = true;
  String _backupFrequency = 'يومي';
  String _logRetention = '30 يوم';

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 8),
            const Expanded(child: Text('تم حفظ إعدادات النظام بنجاح')),
          ],
        ),
        backgroundColor: widget.successColor,
        duration: const Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
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
                border: Border.all(color: widget.secondaryColor, width: 2),
              ),
              child: Icon(Icons.settings_rounded, color: widget.primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'إعدادات النظام',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: widget.primaryColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded, color: Colors.white),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: Container(
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDarkModeSwitch(context),

              const SizedBox(height: 24),

              _buildSettingsSection('إعدادات النسخ الاحتياطي', Icons.backup_rounded, isDarkMode),
              _buildSettingSwitch(
                'النسخ الاحتياطي التلقائي',
                'إنشاء نسخة احتياطية تلقائياً حسب الجدول',
                _autoBackup,
                (value) => setState(() => _autoBackup = value),
                isDarkMode,
              ),
              _buildSettingDropdown(
                'تكرار النسخ الاحتياطي',
                _backupFrequency,
                ['يومي', 'أسبوعي', 'شهري'],
                (value) => setState(() => _backupFrequency = value!),
                isDarkMode,
              ),

              const SizedBox(height: 16),

              _buildSettingsSection('إعدادات السجلات', Icons.history_rounded, isDarkMode),
              _buildSettingSwitch(
                'سجلات مفصلة',
                'تسجيل جميع العمليات بالتفصيل',
                _detailedLogs,
                (value) => setState(() => _detailedLogs = value),
                isDarkMode,
              ),
              _buildSettingDropdown(
                'مدة الاحتفاظ بالسجلات',
                _logRetention,
                ['7 أيام', '30 يوم', '90 يوم', 'سنة'],
                (value) => setState(() => _logRetention = value!),
                isDarkMode,
              ),

              const SizedBox(height: 16),

              _buildSettingsSection('الإشعارات', Icons.notifications_rounded, isDarkMode),
              _buildSettingSwitch(
                'إشعارات البريد الإلكتروني',
                'إرسال إشعارات عند حدوث أحداث مهمة',
                _emailNotifications,
                (value) => setState(() => _emailNotifications = value),
                isDarkMode,
              ),

              const SizedBox(height: 24),

              _buildSettingsSection('معلومات النظام', Icons.info_rounded, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, IconData icon, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: widget.primaryColor, size: 22),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkModeSwitch(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.amber.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: isDarkMode ? Colors.amber : Colors.grey,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الوضع الداكن',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isDarkMode ? 'مفعل - مناسب للعمل الليلي' : 'معطل - مناسب للعمل النهاري',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
            activeColor: Colors.amber,
            activeTrackColor: Colors.amber.withOpacity(0.5),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSwitch(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    bool isDarkMode,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: widget.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingDropdown(
    String title,
    String value,
    List<String> items,
    Function(String?) onChanged,
    bool isDarkMode,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white10 : Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: widget.primaryColor.withOpacity(0.3)),
            ),
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                );
              }).toList(),
              underline: const SizedBox(),
              icon: Icon(Icons.arrow_drop_down_rounded, color: widget.primaryColor),
              dropdownColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return SizedBox(
      width: 100,
      child: Card(
        color: color.withOpacity(0.1),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
