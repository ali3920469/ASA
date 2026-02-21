/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mang_mu/screens/employee/Shared Services/esignin_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class PremiumServicesSpecialistScreen extends StatefulWidget {
  static const String routeName = '/premium-services-specialist';

  const PremiumServicesSpecialistScreen({super.key});

  @override
  State<PremiumServicesSpecialistScreen> createState() =>
      _PremiumServicesSpecialistScreenState();
}

class _PremiumServicesSpecialistScreenState
    extends State<PremiumServicesSpecialistScreen>
    with TickerProviderStateMixin {
  // ألوان حكومية رسمية
  final Color _primaryColor = const Color(0xFF0d47a1);
  final Color _secondaryColor = const Color(0xFF1565c0);
  final Color _accentColor = const Color(0xFF1976d2);
  final Color _backgroundColor = const Color(0xFFf5f5f5);
  final Color _surfaceColor = Colors.white;
  final Color _textPrimary = const Color(0xFF212121);
  final Color _textSecondary = const Color(0xFF757575);
  final Color _successColor = const Color(0xFF2e7d32);
  final Color _warningColor = const Color(0xFFf57c00);
  final Color _errorColor = const Color(0xFFc62828);
  final Color _borderColor = const Color(0xFFe0e0e0);

  // ألوان الوضع الداكن
  final Color _darkPrimaryColor = Color(0xFF0d47a1);
  final Color _darkBackgroundColor = Color(0xFF121212);
  final Color _darkCardColor = Color(0xFF1E1E1E);
  final Color _darkTextColor = Color(0xFFFFFFFF);
  final Color _darkTextSecondaryColor = Color(0xFFB0B0B0);

  late TabController _tabController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // معلومات الموظف
  final Map<String, dynamic> _employeeInfo = {
    'name': 'أحمد محمد',
    'id': 'EMP-2024-001',
    'department': 'قسم الخدمات المميزة',
    'position': 'اختصاصي خدمات مميزة',
    'phone': '+9647701234567',
    'email': 'ahmed.mohamed@electricity.gov.iq',
    'joinDate': '2023-01-15',
  };

  // الإحصائيات
  final List<Map<String, dynamic>> _stats = [
    {
      'title': 'إجمالي الطلبات',
      'value': '١٢٥',
      'icon': Icons.request_page,
      'color': Colors.blue,
      'subtitle': 'هذا الشهر',
    },
    {
      'title': 'الخدمات النشطة',
      'value': '٨',
      'icon': Icons.business_center,
      'color': Colors.green,
      'subtitle': 'خدمة',
    },
    {
      'title': 'المدفوعات',
      'value': '٧٨,٥٠٠',
      'icon': Icons.payments,
      'color': Colors.orange,
      'subtitle': 'دينار',
    },
    {
      'title': 'رضا العملاء',
      'value': '٩٤٪',
      'icon': Icons.sentiment_satisfied,
      'color': Colors.teal,
      'subtitle': 'معدل الرضا',
    },
  ];

  // الخدمات المميزة
  List<Map<String, dynamic>> _premiumServices = [
    {
      'id': 'SRV-001',
      'name': 'تركيب الألواح الشمسية',
      'category': 'الطاقة المتجددة',
      'price': '٥,٠٠٠,٠٠٠ دينار',
      'duration': '٥ أيام عمل',
      'status': 'نشط',
      'requestsCount': 23,
      'createdDate': '2024-01-15',
      'description': 'خدمة تركيب أنظمة الطاقة الشمسية للمنازل والمنشآت التجارية',
      'requirements': ['مساحة سقف مناسبة', 'تصريح البلدية', 'عقد ملكية'],
    },
    {
      'id': 'SRV-002',
      'name': 'نظام مراقبة الاستهلاك',
      'category': 'الذكاء الاصطناعي',
      'price': '١,٥٠٠,٠٠٠ دينار',
      'duration': '٣ أيام عمل',
      'status': 'نشط',
      'requestsCount': 45,
      'createdDate': '2024-02-01',
      'description': 'نظام ذكي لمراقبة وتحليل استهلاك الطاقة بشكل لحظي',
      'requirements': ['اتصال إنترنت', 'عداد كهربائي حديث'],
    },
    {
      'id': 'SRV-003',
      'name': 'العداد الذكي المتقدم',
      'category': 'التقنيات الحديثة',
      'price': '٢,٥٠٠,٠٠٠ دينار',
      'duration': '٤ أيام عمل',
      'status': 'متوقف',
      'requestsCount': 67,
      'createdDate': '2024-01-20',
      'description': 'عداد ذكي متطور مع إمكانية القراءة عن بعد وإعدادات متقدمة',
      'requirements': ['موقع مناسب للتركيب', 'تصريح فني'],
    },
  ];

  // المدفوعات
  final List<Map<String, dynamic>> _payments = [
    {
      'id': 'PAY-001',
      'customer': 'محمد عبدالله أحمد',
      'service': 'تركيب الألواح الشمسية',
      'amount': '٥,٠٠٠,٠٠٠ دينار',
      'date': DateTime.now().subtract(Duration(days: 2)),
      'status': 'مسدد',
      'method': 'تحويل بنكي',
    },
    {
      'id': 'PAY-002',
      'customer': 'سارة خالد محمد',
      'service': 'نظام مراقبة الاستهلاك',
      'amount': '١,٥٠٠,٠٠٠ دينار',
      'date': DateTime.now().subtract(Duration(days: 1)),
      'status': 'مسدد',
      'method': 'كاش',
    },
    {
      'id': 'PAY-003',
      'customer': 'علي حسين عبدالرحمن',
      'service': 'العداد الذكي المتقدم',
      'amount': '٢,٥٠٠,٠٠٠ دينار',
      'date': DateTime.now().subtract(Duration(hours: 5)),
      'status': 'معلق',
      'method': 'تحويل بنكي',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // تغيير من 4 إلى 3
    _tabController.addListener(() {
      setState(() {
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDarkMode ? _darkBackgroundColor : _backgroundColor,
      appBar: _buildAppBar(),
      drawer: _buildGovernmentDrawer(context, isDarkMode),
      body: Column(
        children: [
          // التبويبات الرئيسية
          _buildMainTabBar(),

          // محتوى التبويبات
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDashboardTab(),
                _buildPremiumServicesTab(),
                _buildPaymentsTab(), // إزالة تبويب طلبات الخدمات
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
  return AppBar(
    title: Container(
      width: double.infinity,
      child: Text(
        '${_employeeInfo['position']}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.right,
      ),
    ),
    backgroundColor: _primaryColor,
    elevation: 4,
    toolbarHeight: 80,
    leading: IconButton(
      icon: Icon(Icons.menu, size: 24, color: Colors.white),
      onPressed: () {
        _scaffoldKey.currentState!.openDrawer();
      },
    ),
    actions: [
      IconButton(
        icon: Stack(
          children: [
            Icon(Icons.notifications_outlined, color: Colors.white, size: 26),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  '5',
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationsScreen()),
          );
        },
      ),
    ],
  );
 }

  Widget _buildGovernmentDrawer(BuildContext context, bool isDarkMode) {
  return Drawer(
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode 
              ? [_darkPrimaryColor, Color(0xFF0D1B2E)]
              : [_primaryColor, Color(0xFF1565C0)],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDarkMode 
                    ? [_darkPrimaryColor, Color(0xFF1A237E)]
                    : [_primaryColor, Color(0xFF1976D2)],
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(
                    Icons.business_center_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  _employeeInfo['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  _employeeInfo['position'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _employeeInfo['department'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              color: isDarkMode ? Color(0xFF0D1B2E) : Color(0xFFE3F2FD),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(height: 20),
                  
                  // إضافة عنصر الحساب في الـ Drawer
                  _buildDrawerMenuItem(
                    icon: Icons.person_rounded,
                    title: 'الحساب',
                    onTap: () {
                      Navigator.pop(context);
                      _showAccountScreen(context, isDarkMode);
                    },
                    isDarkMode: isDarkMode,
                  ),
                  
                  _buildDrawerMenuItem(
                    icon: Icons.settings_rounded,
                    title: 'الإعدادات',
                    onTap: () {
                      Navigator.pop(context);
                      _showSettingsScreen(context, isDarkMode);
                    },
                    isDarkMode: isDarkMode,
                  ),
                  
                  _buildDrawerMenuItem(
                    icon: Icons.help_rounded,
                    title: 'المساعدة والدعم',
                    onTap: () {
                      Navigator.pop(context);
                      _showHelpSupportScreen(context, isDarkMode);
                    },
                    isDarkMode: isDarkMode,
                  ),

                  SizedBox(height: 30),
                  
                  _buildDrawerMenuItem(
                    icon: Icons.logout_rounded,
                    title: 'تسجيل الخروج',
                    onTap: () {
                      _showLogoutConfirmation(context, isDarkMode);
                    },
                    isDarkMode: isDarkMode,
                    isLogout: true,
                  ),

                  SizedBox(height: 40),
                  
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Divider(
                          color: isDarkMode ? Colors.white24 : Colors.grey[400],
                          height: 1,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'وزارة الكهرباء - نظام الخدمات المميزة',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.grey[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
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
// تحديث دالة عرض الحساب لتستخدم الدالة الجديدة
void _showAccountScreen(BuildContext context, bool isDarkMode) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: isDarkMode ? _darkCardColor : _surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.person_rounded, color: _primaryColor),
          SizedBox(width: 8),
          Text('معلومات الحساب'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAccountInfoRow('الاسم:', _employeeInfo['name']),
            _buildAccountInfoRow('رقم الموظف:', _employeeInfo['id']),
            _buildAccountInfoRow('القسم:', _employeeInfo['department']),
            _buildAccountInfoRow('المنصب:', _employeeInfo['position']),
            _buildAccountInfoRow('البريد الإلكتروني:', _employeeInfo['email']),
            _buildAccountInfoRow('رقم الهاتف:', _employeeInfo['phone']),
            _buildAccountInfoRow('تاريخ الانضمام:', _employeeInfo['joinDate']),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إغلاق', style: TextStyle(color: _primaryColor)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // إغلاق الديالوج الحالي
            _showEditAccountScreen(context, isDarkMode); // فتح شاشة التعديل
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
          ),
          child: Text('تعديل المعلومات'),
        ),
      ],
    ),
  );
}
Widget _buildAccountInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _textSecondary,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              color: _textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
// دالة جديدة لعرض شاشة تعديل المعلومات
void _showEditAccountScreen(BuildContext context, bool isDarkMode) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditAccountScreen(
        employeeInfo: _employeeInfo,
        primaryColor: _primaryColor,
        secondaryColor: _secondaryColor,
        accentColor: _accentColor,
        darkCardColor: _darkCardColor,
        cardColor: _surfaceColor,
        darkTextColor: _darkTextColor,
        textColor: _textPrimary,
        darkTextSecondaryColor: _darkTextSecondaryColor,
        textSecondaryColor: _textSecondary,
        onInfoUpdated: (updatedInfo) {
          setState(() {
            // تحديث معلومات الموظف
            _employeeInfo['name'] = updatedInfo['name'];
            _employeeInfo['email'] = updatedInfo['email'];
            _employeeInfo['phone'] = updatedInfo['phone'];
          });
          _showSuccessMessage('تم تحديث المعلومات بنجاح');
        },
      ),
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
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_left_rounded,
          color: isLogout ? Colors.red : (isDarkMode ? Colors.white54 : Colors.grey[500]),
          size: 24,
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? _darkCardColor : _surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: _errorColor),
            SizedBox(width: 8),
            Text('تأكيد تسجيل الخروج'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
          style: TextStyle(
            color: isDarkMode ? _darkTextColor : _textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, EsigninScreen.screenroot);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _errorColor,
              foregroundColor: Colors.white,
            ),
            child: Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }

  void _showSettingsScreen(BuildContext context, bool isDarkMode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          accentColor: _accentColor,
          darkCardColor: _darkCardColor,
          cardColor: _surfaceColor,
          darkTextColor: _darkTextColor,
          textColor: _textPrimary,
          darkTextSecondaryColor: _darkTextSecondaryColor,
          textSecondaryColor: _textSecondary,
          onSettingsChanged: (settings) {
            print('الإعدادات المحدثة: $settings');
          },
        ),
      ),
    );
  }

  void _showHelpSupportScreen(BuildContext context, bool isDarkMode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HelpSupportScreen(
          isDarkMode: isDarkMode,
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          accentColor: _accentColor,
          darkCardColor: _darkCardColor,
          cardColor: _surfaceColor,
          darkTextColor: _darkTextColor,
          textColor: _textPrimary,
          darkTextSecondaryColor: _darkTextSecondaryColor,
          textSecondaryColor: _textSecondary,
        ),
      ),
    );
  }

  Widget _buildMainTabBar() {
    return Container(
      color: _surfaceColor,
      child: TabBar(
        controller: _tabController,
        indicatorColor: _primaryColor,
        labelColor: _primaryColor,
        unselectedLabelColor: _textSecondary,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 9,
        ),
        tabs: const [
          Tab(
            icon: Icon(Icons.dashboard, size: 20),
            text: 'لوحة التحكم',
          ),
          Tab(
            icon: Icon(Icons.business_center, size: 20),
            text: 'الخدمات المميزة',
          ),
          Tab(
            icon: Icon(Icons.payments, size: 20),
            text: 'المدفوعات',
          ),
          // تم إزالة تبويب طلبات الخدمات
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الإحصائيات العامة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatsGrid(),
          const SizedBox(height: 24),

          Text(
            'آخر المدفوعات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: _stats.length,
      itemBuilder: (context, index) {
        final stat = _stats[index];
        return _buildStatItem(stat);
      },
    );
  }

  Widget _buildStatItem(Map<String, dynamic> stat) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: stat['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(stat['icon'], size: 20, color: stat['color']),
                ),
                const Spacer(),
                Text(
                  stat['value'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              stat['title'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              stat['subtitle'],
              style: TextStyle(
                fontSize: 12,
                color: _textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ..._payments.take(3).map((payment) => 
              _buildRecentActivityItem(payment)
            ).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityItem(Map<String, dynamic> payment) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _borderColor),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getStatusColor(payment['status']),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment['service'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
                Text(
                  payment['customer'],
                  style: TextStyle(
                    fontSize: 12,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            DateFormat('yyyy-MM-dd').format(payment['date']),
            style: TextStyle(
              fontSize: 12,
              color: _textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumServicesTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: _surfaceColor,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: _addNewService,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  label: const Text('إضافة خدمة جديدة'),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _premiumServices.length,
            itemBuilder: (context, index) {
              final service = _premiumServices[index];
              return _buildServiceCard(service);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service['category'],
                        style: TextStyle(
                          fontSize: 14,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(service['status']),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildServiceInfoItem(Icons.attach_money, service['price']),
                _buildServiceInfoItem(Icons.schedule, service['duration']),
                _buildServiceInfoItem(Icons.request_page, '${service['requestsCount']} طلب'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _editService(service),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primaryColor,
                      side: BorderSide(color: _primaryColor),
                    ),
                    child: const Text('تعديل'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _manageService(service),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                    ),
                    child: const Text('إدارة',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)
                    ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceInfoItem(IconData icon, String text) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: _textSecondary),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: _textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _payments.length,
      itemBuilder: (context, index) {
        final payment = _payments[index];
        return _buildPaymentCard(payment);
      },
    );
  }

  Widget _buildPaymentCard(Map<String, dynamic> payment) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment['service'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      payment['customer'],
                      style: TextStyle(
                        fontSize: 14,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(payment['status']),
            ],
          ),
          const SizedBox(height: 12),
          _buildPaymentInfoRow('المبلغ:', payment['amount']),
          _buildPaymentInfoRow('طريقة الدفع:', payment['method']),
          _buildPaymentInfoRow(
            'التاريخ:', 
            DateFormat('yyyy-MM-dd').format(payment['date'])
          ),
          
          // إظهار معلومات إضافية إذا كان الدفع مؤكداً
          if (payment['status'] == 'مسدد') ...[
            const SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded, size: 16, color: _successColor),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تم التأكيد بواسطة: ${payment['confirmedBy'] ?? _employeeInfo['name']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: _successColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (payment['confirmedDate'] != null)
                          Text(
                            'تاريخ التأكيد: ${DateFormat('yyyy-MM-dd HH:mm').format(payment['confirmedDate'])}',
                            style: TextStyle(
                              fontSize: 11,
                              color: _textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _viewPaymentDetails(payment),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primaryColor,
                    side: BorderSide(color: _primaryColor),
                  ),
                  child: const Text('تفاصيل الدفع'),
                ),
              ),
              const SizedBox(width: 8),
              if (payment['status'] == 'معلق')
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _confirmPayment(payment),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _successColor,
                    ),
                    child: const Text(
                      'تأكيد الاستلام',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

  Widget _buildPaymentInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: _textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color statusColor = _getStatusColor(status);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'نشط':
      case 'مقبول':
      case 'مسدد':
      case 'مكتمل':
        return _successColor;
      case 'قيد المراجعة':
      case 'قيد الإعداد':
        return _warningColor;
      case 'متوقف':
      case 'معلق':
        return _errorColor;
      default:
        return _textSecondary;
    }
  }


  void _addNewService() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddServiceScreen(
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          accentColor: _accentColor,
          darkCardColor: _darkCardColor,
          cardColor: _surfaceColor,
          darkTextColor: _darkTextColor,
          textColor: _textPrimary,
          darkTextSecondaryColor: _darkTextSecondaryColor,
          textSecondaryColor: _textSecondary,
          onServiceAdded: (newService) {
            setState(() {
              _premiumServices.add(newService);
            });
            _showSuccessMessage('تم إضافة الخدمة بنجاح');
          },
        ),
      ),
    );
  }

  void _editService(Map<String, dynamic> service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddServiceScreen(
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          accentColor: _accentColor,
          darkCardColor: _darkCardColor,
          cardColor: _surfaceColor,
          darkTextColor: _darkTextColor,
          textColor: _textPrimary,
          darkTextSecondaryColor: _darkTextSecondaryColor,
          textSecondaryColor: _textSecondary,
          service: service,
          onServiceAdded: (updatedService) {
            setState(() {
              int index = _premiumServices.indexWhere((s) => s['id'] == service['id']);
              if (index != -1) {
                _premiumServices[index] = updatedService;
              }
            });
            _showSuccessMessage('تم تعديل الخدمة بنجاح');
          },
        ),
      ),
    );
  }

  void _manageService(Map<String, dynamic> service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageServiceScreen(
          service: service,
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          accentColor: _accentColor,
          darkCardColor: _darkCardColor,
          cardColor: _surfaceColor,
          darkTextColor: _darkTextColor,
          textColor: _textPrimary,
          darkTextSecondaryColor: _darkTextSecondaryColor,
          textSecondaryColor: _textSecondary,
          onServiceUpdated: (updatedService) {
            setState(() {
              int index = _premiumServices.indexWhere((s) => s['id'] == service['id']);
              if (index != -1) {
                _premiumServices[index] = updatedService;
              }
            });
          },
          onServiceDeleted: () {
            setState(() {
              _premiumServices.removeWhere((s) => s['id'] == service['id']);
            });
            _showSuccessMessage('تم حذف الخدمة بنجاح');
          },
        ),
      ),
    );
  }

  void _viewRequestDetails(Map<String, dynamic> request) {
    _showSuccessMessage('عرض تفاصيل الطلب: ${request['id']}');
  }

  void _updateRequestStatus(Map<String, dynamic> request) {
    _showSuccessMessage('تحديث حالة الطلب: ${request['id']}');
  }

 // تحديث دالة _viewPaymentDetails لعرض معلومات أكثر تفصيلاً
void _viewPaymentDetails(Map<String, dynamic> payment) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode ? _darkCardColor : _surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.receipt_long_rounded, color: _primaryColor),
          SizedBox(width: 8),
          Text('تفاصيل الدفع'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('رقم الدفع:', payment['id']),
            _buildDetailRow('العميل:', payment['customer']),
            _buildDetailRow('الخدمة:', payment['service']),
            _buildDetailRow('المبلغ:', payment['amount']),
            _buildDetailRow('طريقة الدفع:', payment['method']),
            _buildDetailRow('الحالة:', payment['status']),
            _buildDetailRow('تاريخ الطلب:', DateFormat('yyyy-MM-dd').format(payment['date'])),
            
            if (payment['status'] == 'مسدد' && payment['confirmedBy'] != null) ...[
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'معلومات التأكيد:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _successColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildDetailRow('تم التأكيد بواسطة:', payment['confirmedBy']),
                    if (payment['confirmedDate'] != null)
                      _buildDetailRow('تاريخ التأكيد:', DateFormat('yyyy-MM-dd HH:mm').format(payment['confirmedDate'])),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إغلاق', style: TextStyle(color: _primaryColor)),
        ),
        if (payment['status'] == 'معلق')
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmPayment(payment);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _successColor,
              foregroundColor: Colors.white,
            ),
            child: Text('تأكيد الاستلام'),
          ),
      ],
    ),
  );
}

  void _confirmPayment(Map<String, dynamic> payment) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode ? _darkCardColor : _surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: _successColor),
          SizedBox(width: 8),
          Text('تأكيد استلام الدفع'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'هل أنت متأكد من أنك تريد تأكيد استلام هذا الدفع؟',
            style: TextStyle(
              color: Provider.of<ThemeProvider>(context).isDarkMode ? _darkTextColor : _textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تفاصيل الدفع:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                _buildPaymentDetailRow('العميل:', payment['customer']),
                _buildPaymentDetailRow('الخدمة:', payment['service']),
                _buildPaymentDetailRow('المبلغ:', payment['amount']),
                _buildPaymentDetailRow('طريقة الدفع:', payment['method']),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إلغاء', style: TextStyle(color: _textSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            _processPaymentConfirmation(payment);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _successColor,
            foregroundColor: Colors.white,
          ),
          child: Text('تأكيد الاستلام'),
        ),
      ],
    ),
  );
}

Widget _buildPaymentDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _textSecondary,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: _textPrimary,
            ),
          ),
        ),
      ],
    ),
  );
}

void _processPaymentConfirmation(Map<String, dynamic> payment) {
  // محاكاة عملية تأكيد الاستلام
  setState(() {
    // تحديث حالة الدفع إلى "مسدد"
    payment['status'] = 'مسدد';
    
    // إضافة تاريخ التأكيد
    payment['confirmedDate'] = DateTime.now();
    
    // إضافة اسم الموظف الذي أكد الاستلام
    payment['confirmedBy'] = _employeeInfo['name'];
  });

  // عرض رسالة نجاح
  _showSuccessMessage('تم تأكيد استلام الدفع بنجاح');

  // يمكن إضافة المزيد من الإجراءات هنا مثل:
  // - إرسال إشعار للعميل
  // - تحديث قاعدة البيانات
  // - إنشاء إيصال استلام
  // - تحديث التقارير المالية
  
  _sendPaymentConfirmationNotification(payment);
}

void _sendPaymentConfirmationNotification(Map<String, dynamic> payment) {
  // محاكاة إرسال إشعار تأكيد الاستلام
  print('تم إرسال إشعار تأكيد استلام الدفع للعميل: ${payment['customer']}');
  
  // يمكن إضافة كود حقيقي هنا لإرسال:
  // - رسالة SMS
  // - بريد إلكتروني
  // - إشعار داخل التطبيق
}
Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: _textSecondary,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// نموذج بيانات الطلبات الشهرية
class MonthlyRequest {
  final String month;
  final int requests;
  final double revenue;

  MonthlyRequest({
    required this.month,
    required this.requests,
    required this.revenue,
  });
}

class ManageServiceScreen extends StatefulWidget {
  final Map<String, dynamic> service;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color darkCardColor;
  final Color cardColor;
  final Color darkTextColor;
  final Color textColor;
  final Color darkTextSecondaryColor;
  final Color textSecondaryColor;
  final Function(Map<String, dynamic>) onServiceUpdated;
  final VoidCallback onServiceDeleted;

  const ManageServiceScreen({
    Key? key,
    required this.service,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.darkCardColor,
    required this.cardColor,
    required this.darkTextColor,
    required this.textColor,
    required this.darkTextSecondaryColor,
    required this.textSecondaryColor,
    required this.onServiceUpdated,
    required this.onServiceDeleted,
  }) : super(key: key);

  @override
  _ManageServiceScreenState createState() => _ManageServiceScreenState();
}

class _ManageServiceScreenState extends State<ManageServiceScreen> {
  late Map<String, dynamic> _currentService;
  late List<Map<String, dynamic>> _serviceRequests;

  @override
  void initState() {
    super.initState();
    _currentService = Map<String, dynamic>.from(widget.service);
    _serviceRequests = _initializeServiceRequests();
  }

  // تهيئة بيانات الطلبات
  List<Map<String, dynamic>> _initializeServiceRequests() {
  return [
    {
      'id': 'REQ-001',
      'customer': 'محمد أحمد',
      'date': '2024-03-20',
      'status': 'قيد التنفيذ',
      'amount': '٥,٠٠٠,٠٠٠ دينار'
    },
    {
      'id': 'REQ-002',
      'customer': 'سارة خالد',
      'date': '2024-03-19',
      'status': 'مقبول',
      'amount': '٥,٠٠٠,٠٠٠ دينار'
    },
    {
      'id': 'REQ-003',
      'customer': 'علي حسن',
      'date': '2024-03-18',
      'status': 'قيد التنفيذ',
      'amount': '٣,٠٠٠,٠٠٠ دينار'
    },
    {
      'id': 'REQ-004',
      'customer': 'فاطمة عمر',
      'date': '2024-03-17',
      'status': 'قيد التنفيذ',
      'amount': '٢,٥٠٠,٠٠٠ دينار'
    },
    {
      'id': 'REQ-005',
      'customer': 'خالد سعيد',
      'date': '2024-03-16',
      'status': 'ملغي',
      'amount': '١,٠٠٠,٠٠٠ دينار'
    },
    {
      'id': 'REQ-006',
      'customer': 'نورا عبدالله',
      'date': '2024-03-15',
      'status': 'قيد التنفيذ',
      'amount': '٤,٠٠٠,٠٠٠ دينار'
    },
    {
      'id': 'REQ-007',
      'customer': 'يوسف كريم',
      'date': '2024-03-14',
      'status': 'قيد التنفيذ',
      'amount': '٣,٥٠٠,٠٠٠ دينار'
    },
    {
      'id': 'REQ-008',
      'customer': 'هدى محمد',
      'date': '2024-03-13',
      'status': 'ملغي',
      'amount': '٢,٠٠٠,٠٠٠ دينار'
    },
  ];
}

  // دالة تحديث حالة الطلب
  void _updateRequestStatus(Map<String, dynamic> request, String newStatus) {
    setState(() {
      // البحث عن الطلب في القائمة وتحديثه
      int index = _serviceRequests.indexWhere((req) => req['id'] == request['id']);
      if (index != -1) {
        _serviceRequests[index]['status'] = newStatus;
      }
    });

    _showSuccessMessage('تم تحديث حالة الطلب ${request['id']} إلى $newStatus');
  }

  // دالة عرض رسالة النجاح
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showStatusUpdateDialog(Map<String, dynamic> request) {
  final List<String> statusOptions = ['مقبول', 'قيد التنفيذ', 'ملغي'];
  
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white, // تغيير إلى اللون الأبيض
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    builder: (context) => Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // العنوان
          Row(
            children: [
              Icon(Icons.update_rounded, color: widget.primaryColor),
              SizedBox(width: 8),
              Text(
                'تحديث حالة الطلب',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // تغيير إلى الأسود
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '${request['id']} - ${request['customer']}',
            style: TextStyle(
              color: Colors.grey[700], // تغيير إلى رمادي داكن
            ),
          ),
          SizedBox(height: 16),
          
          // الحالة الحالية
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_rounded, size: 16, color: widget.primaryColor),
                SizedBox(width: 8),
                Text(
                  'الحالة الحالية: ',
                  style: TextStyle(
                    color: Colors.grey[700], // تغيير إلى رمادي داكن
                  ),
                ),
                Text(
                  request['status'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(request['status']),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          
          // قائمة الحالات
          Text(
            'اختر الحالة الجديدة:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black, // تغيير إلى الأسود
            ),
          ),
          SizedBox(height: 12),
          
          ...statusOptions.map((status) => ListTile(
            leading: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getStatusColor(status),
                shape: BoxShape.circle,
              ),
            ),
            title: Text(
              status,
              style: TextStyle(
                color: Colors.black, // تغيير إلى الأسود
                fontWeight: request['status'] == status ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: request['status'] == status 
                ? Icon(Icons.check_rounded, color: widget.primaryColor)
                : null,
            onTap: () {
              Navigator.pop(context);
              _updateRequestStatus(request, status);
            },
          )).toList(),
          
          SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: widget.primaryColor,
              side: BorderSide(color: widget.primaryColor),
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('إلغاء'),
          ),
          SizedBox(height: 8),
        ],
      ),
    ),
  );
}

  void _viewRequestDetails(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.darkCardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.info_rounded, color: widget.primaryColor),
            SizedBox(width: 8),
            Text('تفاصيل الطلب'),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('رقم الطلب:', request['id']),
                _buildDetailRow('العميل:', request['customer']),
                _buildDetailRow('التاريخ:', request['date']),
                _buildDetailRow('المبلغ:', request['amount']),
                _buildDetailRow('الحالة:', request['status']),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الخدمة المطلوبة:',
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.darkTextSecondaryColor,
                        ),
                      ),
                      Text(
                        _currentService['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showStatusUpdateDialog(request);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryColor,
            ),
            child: Text('تغيير الحالة'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: widget.darkTextColor,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: widget.darkTextSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changeServiceStatus(String newStatus) {
    setState(() {
      _currentService['status'] = newStatus;
    });
    
    final updatedService = Map<String, dynamic>.from(_currentService);
    updatedService['status'] = newStatus;
    widget.onServiceUpdated(updatedService);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تغيير حالة الخدمة إلى $newStatus'),
        backgroundColor: widget.primaryColor,
      ),
    );
  }

  void _deleteService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.darkCardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('تأكيد الحذف'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من أنك تريد حذف هذه الخدمة؟ لا يمكن التراجع عن هذا الإجراء.',
          style: TextStyle(
            color: widget.darkTextColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onServiceDeleted();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('حذف'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'إدارة الخدمة',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          backgroundColor: widget.primaryColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_rounded, color: Colors.white),
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.pop(context);
                } else if (value == 'delete') {
                  _deleteService();
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_rounded, color: widget.primaryColor),
                      SizedBox(width: 8),
                      Text('تعديل الخدمة'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_rounded, color: Colors.red),
                      SizedBox(width: 8),
                      Text('حذف الخدمة'),
                    ],
                  ),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'نظرة عامة'),
              Tab(text: 'الطلبات'),
              Tab(text: 'الإحصائيات'),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: isDarkMode
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF121212), Color(0xFF1A1A1A)],
                  )
                : LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFF5F5F5), Color(0xFFE8F5E8)],
                  ),
          ),
          child: TabBarView(
            children: [
              _buildOverviewTab(isDarkMode),
              _buildRequestsTab(isDarkMode),
              _buildStatisticsTab(isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab(bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            color: isDarkMode ? widget.darkCardColor : widget.cardColor,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentService['name'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? widget.darkTextColor : widget.textColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _currentService['category'],
                              style: TextStyle(
                                fontSize: 16,
                                color: isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildStatusChip(_currentService['status']),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildInfoRow('السعر:', _currentService['price'], isDarkMode),
                  _buildInfoRow('مدة التنفيذ:', _currentService['duration'], isDarkMode),
                  _buildInfoRow('تاريخ الإضافة:', _currentService['createdDate'], isDarkMode),
                  _buildInfoRow('عدد الطلبات:', '${_currentService['requestsCount']} طلب', isDarkMode),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          Card(
            elevation: 2,
            color: isDarkMode ? widget.darkCardColor : widget.cardColor,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'وصف الخدمة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? widget.darkTextColor : widget.textColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _currentService['description'] ?? 'لا يوجد وصف',
                    style: TextStyle(
                      color: isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          Card(
            elevation: 2,
            color: isDarkMode ? widget.darkCardColor : widget.cardColor,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'متطلبات الخدمة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? widget.darkTextColor : widget.textColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...(_currentService['requirements'] as List<dynamic>? ?? []).map((requirement) => 
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_rounded, size: 16, color: widget.primaryColor),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              requirement.toString(),
                              style: TextStyle(
                                color: isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ).toList(),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          Card(
            elevation: 2,
            color: isDarkMode ? widget.darkCardColor : widget.cardColor,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تغيير حالة الخدمة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? widget.darkTextColor : widget.textColor,
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildStatusButton('نشط', isDarkMode),
                      _buildStatusButton('متوقف', isDarkMode),
                      _buildStatusButton('قيد التطوير', isDarkMode),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsTab(bool isDarkMode) {
  return DefaultTabController(
    length: 4, // عدد التبويبات
    child: Column(
      children: [
        // تبويبات الفلترة فقط
        Container(
          color: isDarkMode ? widget.darkCardColor : widget.cardColor,
          child: TabBar(
            indicatorColor: widget.primaryColor,
            labelColor: widget.primaryColor,
            unselectedLabelColor: isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            tabs: [
              Tab(text: 'الكل'),
              Tab(text: 'مقبول'),
              Tab(text: 'قيد التنفيذ'),
              Tab(text: 'ملغي'),
            ],
          ),
        ),
        
        // محتوى التبويبات
        Expanded(
          child: TabBarView(
            children: [
              // تبويب "الكل"
              _buildRequestsList(_serviceRequests, isDarkMode),
              
              // تبويب "مقبول"
              _buildRequestsList(
                _serviceRequests.where((request) => request['status'] == 'مقبول').toList(), 
                isDarkMode
              ),
              
              // تبويب "قيد التنفيذ"
              _buildRequestsList(
                _serviceRequests.where((request) => request['status'] == 'قيد التنفيذ').toList(), 
                isDarkMode
              ),
              
              // تبويب "ملغي"
              _buildRequestsList(
                _serviceRequests.where((request) => request['status'] == 'ملغي').toList(), 
                isDarkMode
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
Widget _buildRequestsList(List<Map<String, dynamic>> requests, bool isDarkMode) {
  if (requests.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 64,
            color: isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد طلبات',
            style: TextStyle(
              fontSize: 18,
              color: isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  return ListView.builder(
    padding: EdgeInsets.all(16),
    itemCount: requests.length,
    itemBuilder: (context, index) {
      final request = requests[index];
      return Card(
        elevation: 2,
        margin: EdgeInsets.only(bottom: 12),
        color: isDarkMode ? widget.darkCardColor : widget.cardColor,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس البطاقة
              Row(
                children: [
                  // أيقونة العميل
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: widget.primaryColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  
                  // معلومات العميل
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request['customer'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? widget.darkTextColor : widget.textColor,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          request['date'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // حالة الطلب
                  _buildStatusChip(request['status']),
                ],
              ),
              
              SizedBox(height: 12),
              
              // معلومات الطلب
              _buildInfoRow('رقم الطلب:', request['id'], isDarkMode),
              _buildInfoRow('المبلغ:', request['amount'], isDarkMode),
              
              SizedBox(height: 12),
              
              // أزرار التحكم
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.visibility_rounded, size: 18),
                      onPressed: () => _viewRequestDetails(request),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: widget.primaryColor,
                        side: BorderSide(color: widget.primaryColor),
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      label: Text('عرض التفاصيل'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.update_rounded, size: 18),
                      onPressed: () => _showStatusUpdateDialog(request),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      label: Text('تحديث الحالة'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
Widget _buildStatItem(String title, String value, bool isDarkMode) {
  return Column(
    children: [
      Text(
        value,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: widget.primaryColor,
        ),
      ),
      SizedBox(height: 4),
      Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
        ),
      ),
    ],
  );
}
  Widget _buildStatisticsTab(bool isDarkMode) {
    // بيانات نموذجية للطلبات الشهرية
    final List<MonthlyRequest> monthlyData = [
      MonthlyRequest(month: 'يناير', requests: 12, revenue: 45000000),
      MonthlyRequest(month: 'فبراير', requests: 18, revenue: 68000000),
      MonthlyRequest(month: 'مارس', requests: 25, revenue: 92000000),
      MonthlyRequest(month: 'أبريل', requests: 15, revenue: 55000000),
      MonthlyRequest(month: 'مايو', requests: 22, revenue: 78000000),
      MonthlyRequest(month: 'يونيو', requests: 30, revenue: 110000000),
      MonthlyRequest(month: 'يوليو', requests: 28, revenue: 95000000),
      MonthlyRequest(month: 'أغسطس', requests: 35, revenue: 125000000),
      MonthlyRequest(month: 'سبتمبر', requests: 40, revenue: 145000000),
      MonthlyRequest(month: 'أكتوبر', requests: 32, revenue: 115000000),
      MonthlyRequest(month: 'نوفمبر', requests: 38, revenue: 135000000),
      MonthlyRequest(month: 'ديسمبر', requests: 45, revenue: 160000000),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // إحصائيات سريعة
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildStatCard('إجمالي الطلبات', '${_currentService['requestsCount']}', Icons.request_page, isDarkMode),
              _buildStatCard('معدل القبول', '٨٥٪', Icons.thumb_up_rounded, isDarkMode),
              _buildStatCard('الإيرادات', '٧٨,٥٠٠ دينار', Icons.attach_money_rounded, isDarkMode),
              _buildStatCard('معدل الرضا', '٩٢٪', Icons.sentiment_satisfied_rounded, isDarkMode),
            ],
          ),

          SizedBox(height: 24),

          // مخطط توزيع الطلبات الشهري
          Card(
            elevation: 2,
            color: isDarkMode ? widget.darkCardColor : widget.cardColor,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'توزيع الطلبات خلال السنة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? widget.darkTextColor : widget.textColor,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.filter_list_rounded, color: widget.primaryColor),
                        onSelected: (value) {
                          // معالجة تغيير الفلتر
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                            value: 'requests',
                            child: Text('عرض الطلبات'),
                          ),
                          PopupMenuItem<String>(
                            value: 'revenue',
                            child: Text('عرض الإيرادات'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 300,
                    child: _buildMonthlyChart(monthlyData, isDarkMode),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // جدول البيانات التفصيلي
          Card(
            elevation: 2,
            color: isDarkMode ? widget.darkCardColor : widget.cardColor,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'التفاصيل الشهرية',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? widget.darkTextColor : widget.textColor,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildMonthlyTable(monthlyData, isDarkMode),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // ملخص الإحصائيات
          Card(
            elevation: 2,
            color: isDarkMode ? widget.darkCardColor : widget.cardColor,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ملخص الأداء',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? widget.darkTextColor : widget.textColor,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildPerformanceSummary(monthlyData, isDarkMode),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // بناء المخطط الشهري
  Widget _buildMonthlyChart(List<MonthlyRequest> data, bool isDarkMode) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: data.map((e) => e.requests.toDouble()).reduce((a, b) => a > b ? a : b) * 1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: isDarkMode ? Colors.white : Colors.black,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${data[groupIndex].month}\n${data[groupIndex].requests} طلب',
                TextStyle(
                  color: isDarkMode ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 4,
                    child: Container(
                      width: 50,
                      child: Text(
                        data[index].month,
                        style: TextStyle(
                          fontSize: 9,
                          color: isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 40,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                  ),
                );
              },
              reservedSize: 28,
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDarkMode ? Colors.white12 : Colors.grey[300],
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: data.asMap().entries.map((entry) {
          final index = entry.key;
          final monthData = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: monthData.requests.toDouble(),
                gradient: LinearGradient(
                  colors: [
                    widget.primaryColor,
                    widget.secondaryColor,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: 14,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // بناء الجدول التفصيلي
  Widget _buildMonthlyTable(List<MonthlyRequest> data, bool isDarkMode) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        dataRowColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return widget.primaryColor.withOpacity(0.2);
            }
            return null;
          },
        ),
        columns: [
          DataColumn(
            label: Text(
              'الشهر',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? widget.darkTextColor : widget.textColor,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'عدد الطلبات',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? widget.darkTextColor : widget.textColor,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'الإيرادات',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? widget.darkTextColor : widget.textColor,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'النسبة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? widget.darkTextColor : widget.textColor,
              ),
            ),
          ),
        ],
        rows: data.map((monthData) {
          final totalRequests = data.map((e) => e.requests).reduce((a, b) => a + b);
          final percentage = (monthData.requests / totalRequests * 100).toStringAsFixed(1);
          
          return DataRow(
            cells: [
              DataCell(Text(
                monthData.month,
                style: TextStyle(
                  color: isDarkMode ? widget.darkTextColor : widget.textColor,
                ),
              )),
              DataCell(Text(
                '${monthData.requests}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? widget.darkTextColor : widget.textColor,
                ),
              )),
              DataCell(Text(
                '${_formatCurrency(monthData.revenue)} دينار',
                style: TextStyle(
                  color: isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                ),
              )),
              DataCell(Text(
                '$percentage%',
                style: TextStyle(
                  color: _getPercentageColor(double.parse(percentage)),
                  fontWeight: FontWeight.bold,
                ),
              )),
            ],
          );
        }).toList(),
      ),
    );
  }

  // بناء ملخص الأداء
  Widget _buildPerformanceSummary(List<MonthlyRequest> data, bool isDarkMode) {
    final totalRequests = data.map((e) => e.requests).reduce((a, b) => a + b);
    final totalRevenue = data.map((e) => e.revenue).reduce((a, b) => a + b);
    final averageRequests = totalRequests / data.length;
    final maxRequests = data.map((e) => e.requests).reduce((a, b) => a > b ? a : b);
    final bestMonth = data.firstWhere((e) => e.requests == maxRequests);
    
    return Column(
      children: [
        _buildSummaryRow('إجمالي الطلبات السنوية', '$totalRequests طلب', isDarkMode),
        _buildSummaryRow('إجمالي الإيرادات السنوية', '${_formatCurrency(totalRevenue)} دينار', isDarkMode),
        _buildSummaryRow('متوسط الطلبات الشهري', '${averageRequests.toStringAsFixed(1)} طلب', isDarkMode),
        _buildSummaryRow('أفضل شهر أداء', '${bestMonth.month} (${bestMonth.requests} طلب)', isDarkMode),
        _buildSummaryRow('معدل النمو', '+١٥٫٢٪', isDarkMode),
      ],
    );
  }

  // صف في ملخص الأداء
  Widget _buildSummaryRow(String title, String value, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? widget.darkTextColor : widget.textColor,
            ),
          ),
        ],
      ),
    );
  }

  // تنسيق العملة
  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  // لون النسبة المئوية
  Color _getPercentageColor(double percentage) {
    if (percentage >= 15) return Colors.green;
    if (percentage >= 10) return Colors.orange;
    return Colors.red;
  }

  Widget _buildInfoRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? widget.darkTextColor : widget.textColor,
            ),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              color: isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color statusColor = _getStatusColor(status);
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'مقبول':
      case 'مكتمل':
        return Colors.green;
      case 'قيد التنفيذ':
        return Colors.blue;
      case 'ملغي':
        return Colors.red;
      case 'نشط':
        return Colors.green;
      case 'متوقف':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatusButton(String status, bool isDarkMode) {
    return ElevatedButton(
      onPressed: () => _changeServiceStatus(status),
      style: ElevatedButton.styleFrom(
        backgroundColor: _currentService['status'] == status 
            ? widget.primaryColor 
            : (isDarkMode ? Colors.white10 : Colors.grey[100]),
        foregroundColor: _currentService['status'] == status 
            ? Colors.white 
            : (isDarkMode ? widget.darkTextColor : widget.textColor),
      ),
      child: Text(status),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, bool isDarkMode) {
    return Card(
      elevation: 2,
      color: isDarkMode ? widget.darkCardColor : widget.cardColor,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: widget.primaryColor),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? widget.darkTextColor : widget.textColor,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
class AddServiceScreen extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color darkCardColor;
  final Color cardColor;
  final Color darkTextColor;
  final Color textColor;
  final Color darkTextSecondaryColor;
  final Color textSecondaryColor;
  final Map<String, dynamic>? service;
  final Function(Map<String, dynamic>) onServiceAdded;

  const AddServiceScreen({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.darkCardColor,
    required this.cardColor,
    required this.darkTextColor,
    required this.textColor,
    required this.darkTextSecondaryColor,
    required this.textSecondaryColor,
    this.service,
    required this.onServiceAdded,
  }) : super(key: key);

  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _categories = [
    'الطاقة المتجددة',
    'الذكاء الاصطناعي',
    'التقنيات الحديثة',
    'خدمات الصيانة',
    'الاستشارات الفنية'
  ];
  final List<String> _statusOptions = ['نشط', 'متوقف', 'قيد التطوير'];

  String _name = '';
  String _category = 'الطاقة المتجددة';
  String _price = '';
  String _duration = '';
  String _status = 'نشط';
  String _description = '';
  List<String> _requirements = [''];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      _name = widget.service!['name'] ?? '';
      _category = widget.service!['category'] ?? 'الطاقة المتجددة';
      _price = widget.service!['price'] ?? '';
      _duration = widget.service!['duration'] ?? '';
      _status = widget.service!['status'] ?? 'نشط';
      _description = widget.service!['description'] ?? '';
      _requirements = List<String>.from(widget.service!['requirements'] ?? ['']);
    }
  }

  void _addRequirement() {
    setState(() {
      _requirements.add('');
    });
  }

  void _removeRequirement(int index) {
    setState(() {
      _requirements.removeAt(index);
    });
  }

  void _updateRequirement(int index, String value) {
    setState(() {
      _requirements[index] = value;
    });
  }

  void _saveService() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() { _isLoading = true; });

      await Future.delayed(Duration(seconds: 2));

      final newService = {
        'id': widget.service?['id'] ?? 'SRV-${DateTime.now().millisecondsSinceEpoch}',
        'name': _name,
        'category': _category,
        'price': _price,
        'duration': _duration,
        'status': _status,
        'description': _description,
        'requirements': _requirements.where((req) => req.isNotEmpty).toList(),
        'requestsCount': widget.service?['requestsCount'] ?? 0,
        'createdDate': widget.service?['createdDate'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
      };

      widget.onServiceAdded(newService);
      setState(() { _isLoading = false; });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.service != null ? 'تعديل الخدمة' : 'إضافة خدمة جديدة',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: widget.primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF121212), Color(0xFF1A1A1A)],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF5F5F5), Color(0xFFE8F5E8)],
                ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('المعلومات الأساسية', Icons.info_rounded, isDarkMode),
                _buildTextField(
                  'اسم الخدمة',
                  'أدخل اسم الخدمة',
                  (value) => _name = value!,
                  initialValue: _name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال اسم الخدمة';
                    }
                    return null;
                  },
                  isDarkMode: isDarkMode,
                ),
                _buildDropdownField(
                  'الفئة',
                  _category,
                  _categories,
                  (value) => setState(() => _category = value!),
                  isDarkMode: isDarkMode,
                ),
                _buildTextField(
                  'السعر',
                  'أدخل السعر (مثال: ٥,٠٠٠,٠٠٠ دينار)',
                  (value) => _price = value!,
                  initialValue: _price,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال السعر';
                    }
                    return null;
                  },
                  isDarkMode: isDarkMode,
                ),
                _buildTextField(
                  'مدة التنفيذ',
                  'أدخل مدة التنفيذ (مثال: ٥ أيام عمل)',
                  (value) => _duration = value!,
                  initialValue: _duration,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال مدة التنفيذ';
                    }
                    return null;
                  },
                  isDarkMode: isDarkMode,
                ),
                _buildDropdownField(
                  'الحالة',
                  _status,
                  _statusOptions,
                  (value) => setState(() => _status = value!),
                  isDarkMode: isDarkMode,
                ),

                SizedBox(height: 24),
                
                _buildSectionTitle('وصف الخدمة', Icons.description_rounded, isDarkMode),
                _buildTextArea(
                  'وصف الخدمة',
                  'أدخل وصفاً مفصلاً للخدمة...',
                  (value) => _description = value!,
                  initialValue: _description,
                  isDarkMode: isDarkMode,
                ),

                SizedBox(height: 24),
                
                _buildSectionTitle('متطلبات الخدمة', Icons.checklist_rounded, isDarkMode),
                ..._buildRequirementsList(isDarkMode),
                _buildAddRequirementButton(isDarkMode),

                SizedBox(height: 32),
                
                _buildActionButtons(isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, bool isDarkMode) {
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
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? widget.darkTextColor : widget.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, Function(String?) onSaved, {
    String? initialValue,
    String? Function(String?)? validator,
    required bool isDarkMode,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? widget.darkTextColor : widget.textColor,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: widget.primaryColor.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: widget.primaryColor.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: widget.primaryColor),
              ),
              filled: true,
              fillColor: isDarkMode ? widget.darkCardColor : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextArea(String label, String hint, Function(String?) onSaved, {
    String? initialValue,
    required bool isDarkMode,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? widget.darkTextColor : widget.textColor,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            initialValue: initialValue,
            onSaved: onSaved,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: widget.primaryColor.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: widget.primaryColor.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: widget.primaryColor),
              ),
              filled: true,
              fillColor: isDarkMode ? widget.darkCardColor : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, Function(String?) onChanged, {
    required bool isDarkMode,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? widget.darkTextColor : widget.textColor,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: widget.primaryColor.withOpacity(0.3)),
              color: isDarkMode ? widget.darkCardColor : Colors.white,
            ),
            child: DropdownButtonFormField<String>(
              value: value,
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: isDarkMode ? widget.darkTextColor : widget.textColor,
                    ),
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRequirementsList(bool isDarkMode) {
    return _requirements.asMap().entries.map((entry) {
      int index = entry.key;
      String requirement = entry.value;
      
      return Container(
        margin: EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: requirement,
                onChanged: (value) => _updateRequirement(index, value),
                decoration: InputDecoration(
                  hintText: 'المتطلب ${index + 1}',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: widget.primaryColor.withOpacity(0.3)),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? widget.darkCardColor : Colors.white,
                ),
              ),
            ),
            if (_requirements.length > 1)
              IconButton(
                icon: Icon(Icons.remove_circle_rounded, color: Colors.red),
                onPressed: () => _removeRequirement(index),
              ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildAddRequirementButton(bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: OutlinedButton.icon(
        onPressed: _addRequirement,
        style: OutlinedButton.styleFrom(
          foregroundColor: widget.primaryColor,
          side: BorderSide(color: widget.primaryColor),
        ),
        icon: Icon(Icons.add_rounded, size: 20),
        label: Text('إضافة متطلب جديد'),
      ),
    );
  }

  Widget _buildActionButtons(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: widget.primaryColor,
              side: BorderSide(color: widget.primaryColor),
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text('إلغاء'),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveService,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            child: _isLoading 
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(widget.service != null ? 'حفظ التعديلات' : 'إضافة الخدمة'),
          ),
        ),
      ],
    );
  }
}
// شاشة الإعدادات الكاملة
class SettingsScreen extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color darkCardColor;
  final Color cardColor;
  final Color darkTextColor;
  final Color textColor;
  final Color darkTextSecondaryColor;
  final Color textSecondaryColor;
  final Function(Map<String, dynamic>) onSettingsChanged;

  const SettingsScreen({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.darkCardColor,
    required this.cardColor,
    required this.darkTextColor,
    required this.textColor,
    required this.darkTextSecondaryColor,
    required this.textSecondaryColor,
    required this.onSettingsChanged,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = false;
  bool _autoBackup = true;
  bool _biometricAuth = false;
  bool _autoSync = true;
  String _language = 'العربية';
  final List<String> _languages = ['العربية', 'English'];

  void _saveSettings() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final Map<String, dynamic> settings = {
      'notificationsEnabled': _notificationsEnabled,
      'soundEnabled': _soundEnabled,
      'vibrationEnabled': _vibrationEnabled,
      'darkMode': themeProvider.isDarkMode,
      'autoBackup': _autoBackup,
      'biometricAuth': _biometricAuth,
      'autoSync': _autoSync,
      'language': _language,
    };
    
    widget.onSettingsChanged(settings);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حفظ الإعدادات بنجاح'),
        backgroundColor: widget.primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        return AlertDialog(
          backgroundColor: themeProvider.isDarkMode ? widget.darkCardColor : widget.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.restart_alt_rounded, color: widget.primaryColor),
              SizedBox(width: 8),
              Text('إعادة التعيين'),
            ],
          ),
          content: Text(
            'هل أنت متأكد من أنك تريد إعادة جميع الإعدادات إلى القيم الافتراضية؟',
            style: TextStyle(
              color: themeProvider.isDarkMode ? widget.darkTextColor : widget.textColor,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء', style: TextStyle(color: widget.textSecondaryColor)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _notificationsEnabled = true;
                  _soundEnabled = true;
                  _vibrationEnabled = false;
                  _autoBackup = true;
                  _biometricAuth = false;
                  _autoSync = true;
                  _language = 'العربية';
                });
                
                // إعادة تعيين الوضع المظلم إلى الوضع الفاتح
                themeProvider.toggleTheme(false);
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم إعادة التعيين إلى الإعدادات الافتراضية'),
                    backgroundColor: widget.primaryColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text('تأكيد'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الإعدادات',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: widget.primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            _saveSettings();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save_rounded, color: Colors.white),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: themeProvider.isDarkMode
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF121212), Color(0xFF1A1A1A)],
                    )
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFF5F5F5), Color(0xFFE8F5E8)],
                    ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSettingsSection('الإشعارات', Icons.notifications_rounded, themeProvider),
                  _buildSettingSwitch(
                    'تفعيل الإشعارات',
                    'استلام إشعارات حول الفواتير والتحديثات',
                    _notificationsEnabled,
                    (bool value) => setState(() => _notificationsEnabled = value),
                    themeProvider,
                  ),
                  _buildSettingSwitch(
                    'الصوت',
                    'تشغيل صوت للإشعارات الواردة',
                    _soundEnabled,
                    (bool value) => setState(() => _soundEnabled = value),
                    themeProvider,
                  ),
                  _buildSettingSwitch(
                    'الاهتزاز',
                    'اهتزاز الجهاز عند استلام الإشعارات',
                    _vibrationEnabled,
                    (bool value) => setState(() => _vibrationEnabled = value),
                    themeProvider,
                  ),

                  SizedBox(height: 24),
                  _buildSettingsSection('المظهر', Icons.palette_rounded, themeProvider),
                  
                  // زر الوضع المظلم - محدث ليعمل مع ThemeProvider
                  _buildDarkModeSwitch(themeProvider),
                  
                  _buildSettingDropdown(
                    'اللغة',
                    _language,
                    _languages,
                    (String? value) => setState(() => _language = value!),
                    themeProvider,
                  ),
                  
                  SizedBox(height: 24),
                  _buildSettingsSection('حول التطبيق', Icons.info_rounded, themeProvider),
                  _buildAboutCard(themeProvider),

                  SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: _saveSettings,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('حفظ الإعدادات'),
                        ),
                        SizedBox(height: 12),
                        TextButton(
                          onPressed: _resetToDefaults,
                          child: Text(
                            'إعادة التعيين إلى الإعدادات الافتراضية',
                            style: TextStyle(color: widget.textSecondaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // زر الوضع المظلم المحدث
  Widget _buildDarkModeSwitch(ThemeProvider themeProvider) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.isDarkMode ? widget.darkCardColor : widget.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // أيقونة الوضع المظلم
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode ? Colors.amber.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: themeProvider.isDarkMode ? Colors.amber : Colors.grey,
              size: 22,
            ),
          ),
          SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الوضع الداكن',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: themeProvider.isDarkMode ? widget.darkTextColor : widget.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  themeProvider.isDarkMode ? 'مفعل - استمتع بتجربة مريحة للعين' : 'معطل - استمتع بالمظهر الافتراضي',
                  style: TextStyle(
                    fontSize: 12,
                    color: themeProvider.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // زر التبديل
          Switch(
            value: themeProvider.isDarkMode,
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

  Widget _buildSettingsSection(String title, IconData icon, ThemeProvider themeProvider) {
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
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: themeProvider.isDarkMode ? widget.darkTextColor : widget.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSwitch(String title, String subtitle, bool value, Function(bool) onChanged, ThemeProvider themeProvider) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.isDarkMode ? widget.darkCardColor : widget.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
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
                    color: themeProvider.isDarkMode ? widget.darkTextColor : widget.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: themeProvider.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
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

  Widget _buildSettingDropdown(String title, String value, List<String> items, Function(String?) onChanged, ThemeProvider themeProvider) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.isDarkMode ? widget.darkCardColor : widget.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
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
                color: themeProvider.isDarkMode ? widget.darkTextColor : widget.textColor,
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode ? Colors.white10 : Colors.grey[50],
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
                      color: themeProvider.isDarkMode ? widget.darkTextColor : widget.textColor,
                    ),
                  ),
                );
              }).toList(),
              underline: SizedBox(),
              icon: Icon(Icons.arrow_drop_down_rounded, color: widget.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(ThemeProvider themeProvider) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.isDarkMode ? widget.darkCardColor : widget.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildAboutRow('الإصدار', '1.0.0', themeProvider),
          _buildAboutRow('تاريخ البناء', '2024-03-20', themeProvider),
          _buildAboutRow('المطور', 'وزارة الكهرباء - العراق', themeProvider),
          _buildAboutRow('رقم الترخيص', 'MOE-2024-001', themeProvider),
          _buildAboutRow('آخر تحديث', '2024-03-15', themeProvider),
          _buildAboutRow('البريد الإلكتروني', 'support@electric.gov.iq', themeProvider),
        ],
      ),
    );
  }

  Widget _buildAboutRow(String title, String value, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: themeProvider.isDarkMode ? widget.darkTextColor : widget.textColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: themeProvider.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// شاشة المساعدة والدعم الكاملة
class HelpSupportScreen extends StatelessWidget {
  final bool isDarkMode;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color darkCardColor;
  final Color cardColor;
  final Color darkTextColor;
  final Color textColor;
  final Color darkTextSecondaryColor;
  final Color textSecondaryColor;

  const HelpSupportScreen({
    Key? key,
    required this.isDarkMode,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.darkCardColor,
    required this.cardColor,
    required this.darkTextColor,
    required this.textColor,
    required this.darkTextSecondaryColor,
    required this.textSecondaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'المساعدة والدعم',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF121212), Color(0xFF1A1A1A)],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF5F5F5), Color(0xFFE8F5E8)],
                ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // بطاقة جهات الاتصال
              _buildContactCard(context),

              SizedBox(height: 24),

              // الأسئلة الشائعة
              _buildSectionTitle('الأسئلة الشائعة'),
              ..._buildFAQItems(),

              SizedBox(height: 24),
              // معلومات التطبيق
              _buildSectionTitle('معلومات التطبيق'),
              _buildAppInfoCard(),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // بطاقة جهات الاتصال
  Widget _buildContactCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDarkMode ? darkCardColor : cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.support_agent_rounded, color: primaryColor, size: 28),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'مركز الدعم الفني',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? darkTextColor : textColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildContactItem(Icons.phone_rounded, 'رقم الدعم الفني', '07701234567', true, context),
          _buildContactItem(Icons.phone_rounded, 'رقم الطوارئ', '07801234567', true, context),
          _buildContactItem(Icons.email_rounded, 'البريد الإلكتروني', 'support@electricity.gov.iq', false, context),
          _buildContactItem(Icons.access_time_rounded, 'ساعات العمل', '8:00 ص - 4:00 م', false, context),
          _buildContactItem(Icons.location_on_rounded, 'العنوان', 'بغداد - وزارة الكهرباء', false, context),
          SizedBox(height: 16),
          
          // أزرار الاتصال
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _makePhoneCall('07701234567', context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(Icons.phone_rounded, size: 20),
                  label: Text('اتصال فوري'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _openSupportChat(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(Icons.chat_rounded, size: 20),
                  label: Text('مراسلة الدعم'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // دالة فتح محادثة الدعم
  void _openSupportChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SupportChatScreen(
          isDarkMode: isDarkMode,
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
          accentColor: accentColor,
          darkCardColor: darkCardColor,
          cardColor: cardColor,
          darkTextColor: darkTextColor,
          textColor: textColor,
          darkTextSecondaryColor: darkTextSecondaryColor,
          textSecondaryColor: textSecondaryColor,
        ),
      ),
    );
  }

  // عنصر جهة اتصال
  Widget _buildContactItem(IconData icon, String title, String value, bool isPhone, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDarkMode ? darkTextColor : textColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: isPhone ? () => _makePhoneCall(value, context) : null,
              child: Text(
                value,
                style: TextStyle(
                  color: isPhone ? primaryColor : (isDarkMode ? darkTextSecondaryColor : textSecondaryColor),
                  decoration: isPhone ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // عنوان القسم
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: isDarkMode ? darkTextColor : textColor,
        ),
      ),
    );
  }

  // الأسئلة الشائعة
  List<Widget> _buildFAQItems() {
    List<Map<String, String>> faqs = [
      {
        'question': 'كيف يمكنني إضافة خدمة جديدة؟',
        'answer': 'اذهب إلى قسم الخدمات المميزة → انقر على زر "إضافة خدمة جديدة" → املأ البيانات المطلوبة (اسم الخدمة، السعر، المدة) → اضغط على زر "حفظ"'
      },
      {
        'question': 'كيف أعرض تقرير المبيعات الشهري؟',
        'answer': 'انتقل إلى قسم التقارير → اختر "تقرير شهري" → حدد الفترة الزمنية المطلوبة → انقر على "عرض التقرير"'
      },
      {
        'question': 'كيف أعدل بيانات خدمة مسجلة؟',
        'answer': 'اذهب إلى قسم الخدمات المميزة → انقر على الخدمة المطلوبة → اختر "تعديل" → قم بالتعديلات المطلوبة → اضغط على "حفظ التغييرات"'
      },
      {
        'question': 'كيف أتحقق من حالة طلبات الخدمات؟',
        'answer': 'انتقل إلى قسم طلبات الخدمات → استخدم فلتر الحالة → اختر "قيد المراجعة" أو "مقبول" أو "مكتمل" → سيتم عرض الطلبات حسب الحالة المختارة'
      },
    ];

    return faqs.map((faq) {
      return _buildExpandableItem(faq['question']!, faq['answer']!);
    }).toList();
  }

  // عنصر قابل للتمديد (للأسئلة الشائعة)
  Widget _buildExpandableItem(String question, String answer) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDarkMode ? darkCardColor : cardColor,
      ),
      child: ExpansionTile(
        leading: Icon(Icons.help_outline_rounded, color: primaryColor),
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isDarkMode ? darkTextColor : textColor,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(
                color: isDarkMode ? darkTextSecondaryColor : textSecondaryColor,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }  

  // بطاقة معلومات التطبيق
  Widget _buildAppInfoCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDarkMode ? darkCardColor : cardColor,
      ),
      child: Column(
        children: [
          _buildInfoRow('الإصدار', '1.0.0'),
          _buildInfoRow('تاريخ البناء', '2024-03-20'),
          _buildInfoRow('المطور', 'وزارة الكهرباء'),
          _buildInfoRow('رقم الترخيص', 'MOE-2024-001'),
          _buildInfoRow('آخر تحديث', '2024-03-15'),
        ],
      ),
    );
  }

  // صف معلومات
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? darkTextColor : textColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDarkMode ? darkTextSecondaryColor : textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
  // الاتصال الهاتفي
  void _makePhoneCall(String phoneNumber, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري الاتصال بـ $phoneNumber'),
        backgroundColor: primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
     launch('tel:07725252103');
  }
}

// شاشة محادثة الدعم
class SupportChatScreen extends StatefulWidget {
  final bool isDarkMode;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color darkCardColor;
  final Color cardColor;
  final Color darkTextColor;
  final Color textColor;
  final Color darkTextSecondaryColor;
  final Color textSecondaryColor;

  const SupportChatScreen({
    Key? key,
    required this.isDarkMode,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.darkCardColor,
    required this.cardColor,
    required this.darkTextColor,
    required this.textColor,
    required this.darkTextSecondaryColor,
    required this.textSecondaryColor,
  }) : super(key: key);

  @override
  _SupportChatScreenState createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'مرحباً! كيف يمكنني مساعدتك اليوم؟',
      'isUser': false,
      'time': 'الآن',
      'sender': 'موظف الدعم'
    }
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': _messageController.text,
        'isUser': true,
        'time': 'الآن',
        'sender': 'أنت'
      });
    });

    _messageController.clear();

    // محاكاة رد الدعم بعد ثانيتين
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'text': 'شكراً لتواصلكم. سأقوم بمساعدتك في حل هذه المشكلة. هل يمكنك تقديم مزيد من التفاصيل؟',
            'isUser': false,
            'time': 'الآن',
            'sender': 'موظف الدعم'
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'محادثة الدعم الفني',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              'متصل الآن',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        backgroundColor: widget.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: Colors.white),
            onSelected: (value) {
              if (value == 'end_chat') {
                _endChat(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'end_chat',
                child: Row(
                  children: [
                    Icon(Icons.close_rounded, color: Colors.red),
                    SizedBox(width: 8),
                    Text('إنهاء المحادثة'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // معلومات الدعم
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.primaryColor.withOpacity(0.05),
              border: Border(
                bottom: BorderSide(color: widget.primaryColor.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.support_agent_rounded, color: Colors.white, size: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'أحمد محمد - موظف الدعم',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: widget.isDarkMode ? widget.darkTextColor : widget.textColor,
                        ),
                      ),
                      Text(
                        'متخصص في نظام الخدمات المميزة',
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'متصل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // قائمة الرسائل
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // حقل إدخال الرسالة
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isDarkMode ? widget.darkCardColor : widget.cardColor,
              border: Border(
                top: BorderSide(color: widget.primaryColor.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.isDarkMode ? Colors.white10 : Colors.grey[50],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالتك هنا...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.attach_file_rounded, color: widget.primaryColor),
                          onPressed: () => _showAttachmentOptions(context),
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: widget.primaryColor,
                  child: IconButton(
                    icon: Icon(Icons.send_rounded, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final bool isUser = message['isUser'] as bool;
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: widget.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.support_agent_rounded, color: Colors.white, size: 16),
            ),
          SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isUser)
                  Text(
                    message['sender'],
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser 
                        ? widget.primaryColor 
                        : (widget.isDarkMode ? Colors.white10 : Colors.grey[100]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message['text'],
                    style: TextStyle(
                      color: isUser ? Colors.white : (widget.isDarkMode ? widget.darkTextColor : widget.textColor),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message['time'],
                  style: TextStyle(
                    fontSize: 10,
                    color: widget.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          if (isUser)
            SizedBox(width: 8),
          if (isUser)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: widget.secondaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_rounded, color: Colors.white, size: 16),
            ),
        ],
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.isDarkMode ? widget.darkCardColor : widget.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'إرفاق ملف',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: widget.isDarkMode ? widget.darkTextColor : widget.textColor,
              ),
            ),
            SizedBox(height: 16),
            _buildAttachmentOption(Icons.photo_rounded, 'صورة', () {}),
            _buildAttachmentOption(Icons.description_rounded, 'ملف', () {}),
            _buildAttachmentOption(Icons.receipt_rounded, 'فاتورة', () {}),
            _buildAttachmentOption(Icons.location_on_rounded, 'موقع', () {}),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: widget.primaryColor),
      title: Text(text),
      onTap: onTap,
    );
  }

  void _endChat(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDarkMode ? widget.darkCardColor : widget.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.close_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('إنهاء المحادثة'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من أنك تريد إنهاء المحادثة؟',
          style: TextStyle(
            color: widget.isDarkMode ? widget.darkTextColor : widget.textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('البقاء في المحادثة'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق حوار التأكيد
              Navigator.pop(context); // العودة للشاشة السابقة
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إنهاء المحادثة بنجاح'),
                  backgroundColor: widget.primaryColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('إنهاء المحادثة'),
          ),
        ],
      ),
    );
  }
}
class NotificationsScreen extends StatefulWidget {
  static const String routeName = '/notifications';

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final Color _primaryColor = Color(0xFF0d47a1);
  final Color _secondaryColor = Color(0xFF1565c0);
  final Color _backgroundColor = Color(0xFFF5F5F5);
  final Color _cardColor = Color(0xFFFFFFFF);
  final Color _textColor = Color(0xFF212121);
  final Color _textSecondaryColor = Color(0xFF757575);
  final Color _borderColor = Color(0xFFE0E0E0);
  final Color _successColor = Color(0xFF2e7d32);
  final Color _darkCardColor = Color(0xFF1E1E1E);
  final Color _darkTextColor = Color(0xFFFFFFFF);

  int _selectedTab = 0;
  final List<String> _tabs = ['الكل', 'طلبات الخدمات', 'المدفوعات', 'النظام'];
  
  // بيانات الإشعارات الخاصة باختصاصي الخدمات المميزة
  final List<Map<String, dynamic>> _allNotifications = [
    // تبويب الكل
    {
      'id': '1',
      'type': 'service_request',
      'title': 'طلب خدمة جديد',
      'description': 'طلب جديد لخدمة تركيب الألواح الشمسية من العميل محمد عبدالله أحمد',
      'time': 'منذ 5 دقائق',
      'read': false,
      'tab': 0,
    },
    {
      'id': '2',
      'type': 'payment',
      'title': 'دفع جديد',
      'description': 'تم دفع مبلغ ٥,٠٠٠,٠٠٠ دينار لخدمة تركيب الألواح الشمسية',
      'time': 'منذ 30 دقيقة',
      'read': false,
      'tab': 0,
    },
    {
      'id': '3',
      'type': 'system',
      'title': 'تحديث النظام',
      'description': 'تم تحديث نظام الخدمات المميزة إلى الإصدار 1.2.0',
      'time': 'منذ ساعة',
      'read': true,
      'tab': 0,
    },

    // تبويب طلبات الخدمات
    {
      'id': '4',
      'type': 'service_request',
      'title': 'طلب خدمة نظام مراقبة',
      'description': 'طلب جديد لخدمة نظام مراقبة الاستهلاك من العميلة سارة خالد محمد',
      'time': 'منذ 15 دقيقة',
      'read': false,
      'tab': 1,
    },
    {
      'id': '5',
      'type': 'service_status',
      'title': 'تحديث حالة الخدمة',
      'description': 'تم تغيير حالة خدمة العداد الذكي إلى "قيد التنفيذ"',
      'time': 'منذ ساعتين',
      'read': true,
      'tab': 1,
    },
    {
      'id': '6',
      'type': 'service_completed',
      'title': 'خدمة مكتملة',
      'description': 'تم إكمال خدمة تركيب الألواح الشمسية للعميل علي حسين',
      'time': 'منذ 3 أيام',
      'read': true,
      'tab': 1,
    },

    // تبويب المدفوعات
    {
      'id': '7',
      'type': 'payment_received',
      'title': 'استلام دفعة',
      'description': 'تم استلام دفعة بقيمة ١,٥٠٠,٠٠٠ دينار لخدمة نظام المراقبة',
      'time': 'منذ 45 دقيقة',
      'read': false,
      'tab': 2,
    },
    {
      'id': '8',
      'type': 'payment_pending',
      'title': 'دفعة معلقة',
      'description': 'دفعة بقيمة ٢,٥٠٠,٠٠٠ دينار لخدمة العداد الذكي بانتظار التأكيد',
      'time': 'منذ يوم',
      'read': true,
      'tab': 2,
    },
    {
      'id': '9',
      'type': 'payment_confirmed',
      'title': 'تأكيد دفعة',
      'description': 'تم تأكيد استلام الدفعة للخدمة الشمسية بقيمة ٥,٠٠٠,٠٠٠ دينار',
      'time': 'منذ يومين',
      'read': true,
      'tab': 2,
    },

    // تبويب النظام
    {
      'id': '10',
      'type': 'system_maintenance',
      'title': 'صيانة النظام',
      'description': 'سيتم إجراء صيانة للنظام يوم الجمعة القادم من الساعة 10 مساءً حتى 2 صباحاً',
      'time': 'منذ 6 ساعات',
      'read': true,
      'tab': 3,
    },
    {
      'id': '11',
      'type': 'new_feature',
      'title': 'ميزة جديدة',
      'description': 'تم إضافة تقارير أداء الخدمات المميزة في التحديث الجديد',
      'time': 'منذ 3 أيام',
      'read': true,
      'tab': 3,
    },
    {
      'id': '12',
      'type': 'security_update',
      'title': 'تحديث أمني',
      'description': 'تم تثبيت تحديث أمني مهم لنظام الخدمات المميزة',
      'time': 'منذ أسبوع',
      'read': true,
      'tab': 3,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedTab == 0) { // الكل
      return _allNotifications;
    }
    return _allNotifications.where((notification) => notification['tab'] == _selectedTab).toList();
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'service_request':
        return _primaryColor;
      case 'payment_received':
        return Colors.green;
      case 'payment_pending':
        return Colors.orange;
      case 'system':
        return Colors.blue;
      case 'service_status':
        return Colors.purple;
      case 'service_completed':
        return Colors.teal;
      case 'payment_confirmed':
        return Colors.green;
      case 'system_maintenance':
        return Colors.amber;
      case 'new_feature':
        return Colors.blueAccent;
      case 'security_update':
        return Colors.red;
      default:
        return _primaryColor;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'service_request':
        return Icons.business_center_rounded;
      case 'payment_received':
      case 'payment_pending':
      case 'payment_confirmed':
        return Icons.payments_rounded;
      case 'system':
      case 'system_maintenance':
        return Icons.settings_rounded;
      case 'service_status':
      case 'service_completed':
        return Icons.assignment_turned_in_rounded;
      case 'new_feature':
        return Icons.new_releases_rounded;
      case 'security_update':
        return Icons.security_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          'الإشعارات',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.checklist_rounded, color: Colors.white),
            onPressed: _markAllAsRead,
          ),
        ],
      ),
      body: Column(
        children: [
          // تبويبات الإشعارات
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: _cardColor,
              border: Border(
                bottom: BorderSide(color: _borderColor),
              ),
            ),
            child: Row(
              children: [
                for (int i = 0; i < _tabs.length; i++)
                  _buildTabButton(_tabs[i], i),
              ],
            ),
          ),

          // خط فاصل تحت التبويبات
          Container(
            height: 1,
            color: _borderColor,
          ),

          // إحصائيات سريعة
          _buildStatsHeader(),

          // قائمة الإشعارات
          Expanded(
            child: _filteredNotifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = _filteredNotifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? _secondaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isSelected ? _primaryColor : _textSecondaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsHeader() {
    int unreadCount = _allNotifications.where((n) => !n['read']).length;
    int serviceRequests = _allNotifications.where((n) => n['tab'] == 1 && !n['read']).length;
    int payments = _allNotifications.where((n) => n['tab'] == 2 && !n['read']).length;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        border: Border(
          bottom: BorderSide(color: _borderColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('غير مقروء', unreadCount.toString(), _primaryColor),
          _buildStatItem('طلبات الخدمات', serviceRequests.toString(), Colors.orange),
          _buildStatItem('المدفوعات', payments.toString(), Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: _textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    Color notificationColor = _getNotificationColor(notification['type']);
    bool isUnread = !notification['read'];

    return GestureDetector(
      onTap: () {
        _handleNotificationTap(notification);
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cardColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // أيقونة الإشعار
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: notificationColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getNotificationIcon(notification['type']),
                    color: notificationColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                
                // محتوى الإشعار
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: _textColor,
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        notification['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: _textSecondaryColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notification['time'],
                            style: TextStyle(
                              fontSize: 12,
                              color: _textSecondaryColor,
                            ),
                          ),
                          _buildNotificationBadge(notification['type']),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: _borderColor,
            margin: EdgeInsets.symmetric(horizontal: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationBadge(String type) {
    String badgeText = '';
    Color badgeColor = _primaryColor;

    switch (type) {
      case 'service_request':
        badgeText = 'طلب جديد';
        badgeColor = Colors.orange;
        break;
      case 'payment_received':
        badgeText = 'دفعة';
        badgeColor = Colors.green;
        break;
      case 'payment_pending':
        badgeText = 'معلق';
        badgeColor = Colors.amber;
        break;
      case 'system':
        badgeText = 'نظام';
        badgeColor = Colors.blue;
        break;
      case 'service_completed':
        badgeText = 'مكتمل';
        badgeColor = Colors.teal;
        break;
    }

    if (badgeText.isEmpty) return SizedBox();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Text(
        badgeText,
        style: TextStyle(
          fontSize: 10,
          color: badgeColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_rounded,
            size: 64,
            color: _textSecondaryColor,
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 18,
              color: _textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'لا توجد إشعارات في التبويب المحدد',
            style: TextStyle(
              color: _textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _allNotifications) {
        notification['read'] = true;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تحديد جميع الإشعارات كمقروءة'),
        backgroundColor: _primaryColor,
      ),
    );
  }

  // دالة جديدة للتعامل مع الضغط على الإشعارات
  void _handleNotificationTap(Map<String, dynamic> notification) {
    // تحديث حالة الإشعار إلى مقروء
    setState(() {
      notification['read'] = true;
    });

    // التعامل مع كل نوع إشعار بشكل مختلف
    switch (notification['type']) {
      case 'service_request':
        _handleServiceRequestNotification(notification);
        break;
      case 'payment_received':
        _handlePaymentNotification(notification);
        break;
      case 'payment_pending':
        _handlePaymentNotification(notification);
        break;
      case 'system':
        _handleSystemNotification(notification);
        break;
      case 'service_status':
        _handleServiceStatusNotification(notification);
        break;
      case 'service_completed':
        _handleServiceCompletedNotification(notification);
        break;
      case 'payment_confirmed':
        _handlePaymentConfirmedNotification(notification);
        break;
      case 'system_maintenance':
        _handleSystemMaintenanceNotification(notification);
        break;
      case 'new_feature':
        _handleNewFeatureNotification(notification);
        break;
      case 'security_update':
        _handleSecurityUpdateNotification(notification);
        break;
      default:
        _showGeneralNotificationDetails(notification);
    }
  }

  // دوال التعامل مع أنواع الإشعارات المختلفة
  void _handleServiceRequestNotification(Map<String, dynamic> notification) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode ? _darkCardColor : _cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.business_center_rounded, color: _primaryColor),
          SizedBox(width: 8),
          Text('طلب خدمة جديد'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification['description'],
            style: TextStyle(
              fontSize: 14,
              color: Provider.of<ThemeProvider>(context).isDarkMode ? _darkTextColor : _textColor,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الإجراءات المتاحة:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
                SizedBox(height: 8),
                Text('• عرض تفاصيل الطلب'),
                Text('• الانتقال إلى إدارة الخدمات'),
                Text('• التواصل مع العميل'),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إغلاق'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // إغلاق الديالوج
            Navigator.pop(context); // العودة للشاشة الرئيسية
            _navigateToServicesTab();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
          ),
          child: Text('إدارة الخدمات'),
        ),
      ],
    ),
  );
}
  void _handlePaymentNotification(Map<String, dynamic> notification) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode ? _darkCardColor : _cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.payments_rounded, color: Colors.green),
          SizedBox(width: 8),
          Text('إشعار دفع'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification['description'],
            style: TextStyle(
              fontSize: 14,
              color: Provider.of<ThemeProvider>(context).isDarkMode ? _darkTextColor : _textColor,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الإجراءات المتاحة:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 8),
                Text('• تأكيد استلام الدفع'),
                Text('• عرض سجل المدفوعات'),
                Text('• إنشاء إيصال'),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إغلاق'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // إغلاق الديالوج
            Navigator.pop(context); // العودة للشاشة الرئيسية
            _navigateToPaymentsTab();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Text('إدارة المدفوعات'),
        ),
      ],
    ),
  );
}
// دوال جديدة للتنقل بين التبويبات
void _navigateToServicesTab() {
  // استخدام Navigator للعودة للشاشة الرئيسية والانتقال لتبويب الخدمات
  // نستخدم GlobalKey للوصول لـ TabController في الشاشة الرئيسية
  _showSuccessMessage('سيتم الانتقال إلى إدارة الخدمات');
  
  // في التطبيق الحقيقي، يمكنك استخدام:
  // Navigator.pushReplacementNamed(context, '/main', arguments: {'tabIndex': 1});
}

void _navigateToPaymentsTab() {
  _showSuccessMessage('سيتم الانتقال إلى إدارة المدفوعات');
  
  // في التطبيق الحقيقي، يمكنك استخدام:
  // Navigator.pushReplacementNamed(context, '/main', arguments: {'tabIndex': 2});
}

  void _handleSystemNotification(Map<String, dynamic> notification) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode ? _darkCardColor : _cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.settings_rounded, color: Colors.blue),
          SizedBox(width: 8),
          Text('تحديث النظام'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification['description'],
            style: TextStyle(
              fontSize: 14,
              color: Provider.of<ThemeProvider>(context).isDarkMode ? _darkTextColor : _textColor,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معلومات التحديث:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 8),
                Text('• الإصدار: 2.1.0'),
                Text('• تاريخ النشر: 2024-03-20'),
                Text('• الحجم: 15 MB'),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إغلاق'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _performSystemUpdate();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: Text('تحديث الآن'),
        ),
      ],
    ),
  );
}
void _performSystemUpdate() {
  _showSuccessMessage('جاري تحميل التحديث...');
  
  // محاكاة عملية التحديث
  Future.delayed(Duration(seconds: 3), () {
    if (mounted) {
      _showSuccessMessage('تم تحديث النظام بنجاح');
      Navigator.pop(context); // العودة للشاشة الرئيسية
    }
  });
}
// إضافة دالة للتعامل مع إشعارات التواصل مع العملاء
void _handleCustomerCommunication(Map<String, dynamic> notification) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode ? _darkCardColor : _cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.phone_rounded, color: Colors.green),
          SizedBox(width: 8),
          Text('التواصل مع العميل'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختر طريقة التواصل مع العميل:',
            style: TextStyle(
              fontSize: 14,
              color: Provider.of<ThemeProvider>(context).isDarkMode ? _darkTextColor : _textColor,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.phone_rounded, color: Colors.green),
                    onPressed: () {
                      Navigator.pop(context);
                      _makePhoneCall();
                    },
                  ),
                  Text('اتصال'),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.message_rounded, color: Colors.blue),
                    onPressed: () {
                      Navigator.pop(context);
                      _sendMessage();
                    },
                  ),
                  Text('رسالة'),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.email_rounded, color: Colors.orange),
                    onPressed: () {
                      Navigator.pop(context);
                      _sendEmail();
                    },
                  ),
                  Text('بريد'),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إلغاء'),
        ),
      ],
    ),
  );
}
void _makePhoneCall() {
  _showSuccessMessage('جاري الاتصال بالعميل...');
  // يمكن إضافة كود حقيقي للاتصال هنا
}

void _sendMessage() {
  _showSuccessMessage('جاري فتح محادثة مع العميل...');
  // يمكن إضافة كود حقيقي لإرسال الرسائل هنا
}

void _sendEmail() {
  _showSuccessMessage('جاري فتح بريد إلكتروني للعميل...');
  // يمكن إضافة كود حقيقي لإرسال البريد هنا
}
  void _handleServiceStatusNotification(Map<String, dynamic> notification) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode ? _darkCardColor : _cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.assignment_turned_in_rounded, color: Colors.purple),
          SizedBox(width: 8),
          Text('تحديث حالة الخدمة'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification['description'],
            style: TextStyle(
              fontSize: 14,
              color: Provider.of<ThemeProvider>(context).isDarkMode ? _darkTextColor : _textColor,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_rounded, color: Colors.purple),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'تم تحديث حالة الخدمة بنجاح ويمكنك متابعة التقدم من خلال قسم الخدمات المميزة',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إغلاق'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context); // العودة للشاشة الرئيسية
            _navigateToServicesTab();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
          child: Text('متابعة الخدمة'),
        ),
      ],
    ),
  );
}

  void _handleServiceCompletedNotification(Map<String, dynamic> notification) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode ? _darkCardColor : _cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.teal),
          SizedBox(width: 8),
          Text('خدمة مكتملة'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification['description'],
            style: TextStyle(
              fontSize: 14,
              color: Provider.of<ThemeProvider>(context).isDarkMode ? _darkTextColor : _textColor,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.celebration_rounded, color: Colors.teal),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'تهانينا! تم إكمال الخدمة بنجاح. يمكنك الآن إنشاء تقرير الإنجاز',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إغلاق'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _createCompletionReport(notification);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          child: Text('إنشاء تقرير'),
        ),
      ],
    ),
  );
}
void _createCompletionReport(Map<String, dynamic> notification) {
  // محاكاة إنشاء تقرير
  _showSuccessMessage('جاري إنشاء تقرير إنجاز الخدمة...');
  
  // بعد 2 ثانية، إظهار رسالة نجاح
  Future.delayed(Duration(seconds: 2), () {
    if (mounted) {
      _showSuccessMessage('تم إنشاء تقرير الإنجاز بنجاح');
      Navigator.pop(context); // العودة للشاشة الرئيسية
    }
  });
}
  // دوال إضافية لأنواع الإشعارات الأخرى
  void _handlePaymentConfirmedNotification(Map<String, dynamic> notification) {
    _showGeneralNotificationDialog(notification, 'تأكيد دفعة', Icons.verified_rounded, Colors.green);
  }

  void _handleSystemMaintenanceNotification(Map<String, dynamic> notification) {
    _showGeneralNotificationDialog(notification, 'صيانة النظام', Icons.engineering_rounded, Colors.amber);
  }

  void _handleNewFeatureNotification(Map<String, dynamic> notification) {
    _showGeneralNotificationDialog(notification, 'ميزة جديدة', Icons.new_releases_rounded, Colors.blueAccent);
  }

  void _handleSecurityUpdateNotification(Map<String, dynamic> notification) {
    _showGeneralNotificationDialog(notification, 'تحديث أمني', Icons.security_rounded, Colors.red);
  }

  void _showGeneralNotificationDialog(Map<String, dynamic> notification, String title, IconData icon, Color color) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode ? _darkCardColor : _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(
          notification['description'],
          style: TextStyle(
            fontSize: 14,
            color: Provider.of<ThemeProvider>(context).isDarkMode ? _darkTextColor : _textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('تم معالجة الإشعار');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
            ),
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showGeneralNotificationDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode ? _darkCardColor : _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.notifications_rounded, color: _primaryColor),
            SizedBox(width: 8),
            Text('تفاصيل الإشعار'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Provider.of<ThemeProvider>(context).isDarkMode ? _darkTextColor : _textColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              notification['description'],
              style: TextStyle(
                fontSize: 14,
                color: Provider.of<ThemeProvider>(context).isDarkMode ? _darkTextColor : _textColor,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time_rounded, size: 16),
                  SizedBox(width: 8),
                  Text(
                    notification['time'],
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لعرض رسائل النجاح
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}// شاشة تعديل المعلومات
class EditAccountScreen extends StatefulWidget {
  final Map<String, dynamic> employeeInfo;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color darkCardColor;
  final Color cardColor;
  final Color darkTextColor;
  final Color textColor;
  final Color darkTextSecondaryColor;
  final Color textSecondaryColor;
  final Function(Map<String, dynamic>) onInfoUpdated;

  const EditAccountScreen({
    Key? key,
    required this.employeeInfo,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.darkCardColor,
    required this.cardColor,
    required this.darkTextColor,
    required this.textColor,
    required this.darkTextSecondaryColor,
    required this.textSecondaryColor,
    required this.onInfoUpdated,
  }) : super(key: key);

  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employeeInfo['name']);
    _emailController = TextEditingController(text: widget.employeeInfo['email']);
    _phoneController = TextEditingController(text: widget.employeeInfo['phone']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // محاكاة عملية الحفظ
      await Future.delayed(Duration(seconds: 2));

      final updatedInfo = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
      };

      widget.onInfoUpdated(updatedInfo);
      
      setState(() {
        _isLoading = false;
      });
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تعديل المعلومات الشخصية',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: widget.primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF121212), Color(0xFF1A1A1A)],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF5F5F5), Color(0xFFE8F5E8)],
                ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // صورة الملف الشخصي
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: widget.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.primaryColor,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: widget.primaryColor,
                    size: 50,
                  ),
                ),
                SizedBox(height: 20),

                // معلومات لا يمكن تعديلها
                _buildReadOnlyInfo('رقم الموظف', widget.employeeInfo['id'], isDarkMode),
                _buildReadOnlyInfo('القسم', widget.employeeInfo['department'], isDarkMode),
                _buildReadOnlyInfo('المنصب', widget.employeeInfo['position'], isDarkMode),
                _buildReadOnlyInfo('تاريخ الانضمام', widget.employeeInfo['joinDate'], isDarkMode),

                SizedBox(height: 24),

                // الحقول القابلة للتعديل
                _buildEditableField(
                  'الاسم الكامل',
                  _nameController,
                  Icons.person_rounded,
                  'أدخل الاسم الكامل',
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال الاسم الكامل';
                    }
                    return null;
                  },
                  isDarkMode,
                ),

                _buildEditableField(
                  'البريد الإلكتروني',
                  _emailController,
                  Icons.email_rounded,
                  'أدخل البريد الإلكتروني',
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال البريد الإلكتروني';
                    }
                    if (!value.contains('@')) {
                      return 'يرجى إدخال بريد إلكتروني صحيح';
                    }
                    return null;
                  },
                  isDarkMode,
                ),

                _buildEditableField(
                  'رقم الهاتف',
                  _phoneController,
                  Icons.phone_rounded,
                  'أدخل رقم الهاتف',
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال رقم الهاتف';
                    }
                    if (value.length < 10) {
                      return 'يرجى إدخال رقم هاتف صحيح';
                    }
                    return null;
                  },
                  isDarkMode,
                ),

                SizedBox(height: 32),

                // أزرار الحفظ والإلغاء
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: widget.primaryColor,
                          side: BorderSide(color: widget.primaryColor),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('إلغاء'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text('حفظ التغييرات'),
                      ),
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

  Widget _buildReadOnlyInfo(String label, String value, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDarkMode ? Colors.white10 : Colors.grey[50],
        border: Border.all(color: widget.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDarkMode ? widget.darkTextColor : widget.textColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    IconData icon,
    String hint,
    String? Function(String?) validator,
    bool isDarkMode,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? widget.darkTextColor : widget.textColor,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: widget.primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: widget.primaryColor.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: widget.primaryColor.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: widget.primaryColor),
              ),
              filled: true,
              fillColor: isDarkMode ? widget.darkCardColor : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
*/
