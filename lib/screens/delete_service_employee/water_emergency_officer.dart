import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mang_mu/screens/employee/Employee_Shared%20Services/esignin_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';

class WaterEmergencyOfficerScreen extends StatefulWidget {
  static const String screenRoute = '/water-emergency-officer-dashboard';
  
  const WaterEmergencyOfficerScreen({super.key});

  @override
  WaterEmergencyOfficerScreenState createState() => WaterEmergencyOfficerScreenState();
}

class WaterEmergencyOfficerScreenState extends State<WaterEmergencyOfficerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // ألوان وزارة المياه (أزرق معدل للطوارئ)
  final Color _primaryColor = Color.fromARGB(255, 0, 102, 160); // أزرق أعمق للطوارئ
  final Color _secondaryColor = Color(0xFF29B6F6);
  final Color _accentColor = Color(0xFF0288D1);
  final Color _successColor = Color(0xFF2E7D32);
  final Color _warningColor = Color(0xFFF57C00);
  final Color _errorColor = Color(0xFFD32F2F);
  final Color _emergencyRed = Color(0xFFD32F2F);
  
  // متغيرات تبويب التقارير (مأخوذة من المحاسب)
  int _currentCitizenTab = 0;
  int _currentPaymentTab = 0;
  String _billFilter = 'الكل';
  String _selectedReportType = 'يومي';
  List<DateTime> _selectedDates = [];
  String? _selectedWeek;
  String? _selectedMonth;

  // قوائم التقارير (مأخوذة من المحاسب)
  final List<String> _reportTypes = ['يومي', 'أسبوعي', 'شهري'];
  final List<String> _weeks = ['الأسبوع الأول', 'الأسبوع الثاني', 'الأسبوع الثالث', 'الأسبوع الرابع'];
  final List<String> _months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
  
  // ألوان الوضع المظلم
  final Color _darkPrimaryColor = Color(0xFF1565C0);
  
  // بيانات الطوارئ
  final List<Map<String, dynamic>> emergencies = [
    {
      'id': 'EMG-001',
      'type': 'انقطاع مياه',
      'location': 'حي السعدون - شارع الربيع',
      'severity': 'عالي',
      'status': 'نشط',
      'reportedAt': DateTime.now().subtract(Duration(hours: 2)),
      'assignedTeam': 'فريق الصيانة السريعة',
      'progress': 65,
    },
    {
      'id': 'EMG-002',
      'type': 'تسرب رئيسي',
      'location': 'حي الجامعة - شارع الخليج',
      'severity': 'حرج',
      'status': 'نشط',
      'reportedAt': DateTime.now().subtract(Duration(minutes: 30)),
      'assignedTeam': 'فريق الطوارئ الليلي',
      'progress': 30,
    },
    {
      'id': 'EMG-003',
      'type': 'انخفاض ضغط',
      'location': 'حي الواحة - مجمع 5',
      'severity': 'متوسط',
      'status': 'مكتمل',
      'reportedAt': DateTime.now().subtract(Duration(hours: 5)),
      'assignedTeam': 'فريق الجودة',
      'progress': 100,
    },
    {
      'id': 'EMG-004',
      'type': 'تلوث مياه',
      'location': 'حي الزهراء - المنطقة الصناعية',
      'severity': 'عالي',
      'status': 'قيد التحقيق',
      'reportedAt': DateTime.now().subtract(Duration(hours: 1)),
      'assignedTeam': 'فريق الجودة',
      'progress': 20,
    },
  ];

  final List<Map<String, dynamic>> teams = [
    {
      'id': 'T001',
      'name': 'فريق الصيانة السريعة',
      'status': 'متاح',
      'members': 4,
      'specialization': 'إصلاح الأعطال',
      'currentLocation': 'المركز الرئيسي',
      'lastActive': DateTime.now().subtract(Duration(minutes: 10)),
    },
    {
      'id': 'T002',
      'name': 'فريق الطوارئ الليلي',
      'status': 'في الميدان',
      'members': 3,
      'specialization': 'طوارئ ليلية',
      'currentLocation': 'حي الجامعة',
      'lastActive': DateTime.now(),
    },
    {
      'id': 'T003',
      'name': 'فريق الجودة',
      'status': 'متاح',
      'members': 5,
      'specialization': 'فحص الجودة',
      'currentLocation': 'المختبر المركزي',
      'lastActive': DateTime.now().subtract(Duration(minutes: 30)),
    },
    {
      'id': 'T004',
      'name': 'فريق الاستجابة السريعة',
      'status': 'جاهز',
      'members': 6,
      'specialization': 'استجابة أولية',
      'currentLocation': 'مركز الطوارئ',
      'lastActive': DateTime.now().subtract(Duration(minutes: 5)),
    },
  ];

  final List<Map<String, dynamic>> equipment = [
    {
      'id': 'EQP-001',
      'name': 'سيارة إصلاح شبكات',
      'type': 'مركبة',
      'status': 'متاح',
      'location': 'المركز الرئيسي',
      'lastMaintenance': DateTime.now().subtract(Duration(days: 5)),
    },
    {
      'id': 'EQP-002',
      'name': 'مضخة مياه متنقلة',
      'type': 'معدات',
      'status': 'مستعمل',
      'location': 'حي الجامعة',
      'lastMaintenance': DateTime.now().subtract(Duration(days: 10)),
    },
    {
      'id': 'EQP-003',
      'name': 'مجس تسرب المياه',
      'type': 'أجهزة',
      'status': 'متاح',
      'location': 'المخزن',
      'lastMaintenance': DateTime.now().subtract(Duration(days: 2)),
    },
  ];

  // إحصائيات سريعة
  int _activeEmergencies = 2;
  int _availableTeams = 2;
  int _resolvedToday = 3;
  double _responseTime = 45.5; // دقيقة

  // البحث
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ================ الدوال المساعدة ================

  String _formatCurrency(dynamic amount) {
    double numericAmount = 0.0;
    if (amount is int) {
      numericAmount = amount.toDouble();
    } else if (amount is double) {
      numericAmount = amount;
    } else if (amount is String) {
      numericAmount = double.tryParse(amount) ?? 0.0;
    }
    
    return '${NumberFormat('#,##0').format(numericAmount)} ';
  }

  // دالة تنسيق التواريخ للطوارئ
  String _formatEmergencyDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  // دالة الحصول على لون الأولوية للطوارئ
  Color _getEmergencyPriorityColor(String priority) {
    switch (priority) {
      case 'عالي':
        return _emergencyRed;
      case 'متوسط':
        return _warningColor;
      case 'منخفض':
        return _successColor;
      default:
        return _textSecondaryColor(context);
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'حرج':
        return _emergencyRed;
      case 'عالي':
        return Colors.orange;
      case 'متوسط':
        return _warningColor;
      case 'منخفض':
        return _successColor;
      default:
        return _textSecondaryColor(context);
    }
  }

  List<Map<String, dynamic>> get _filteredEmergencies {
    if (_searchQuery.isEmpty) {
      return emergencies;
    }
    
    return emergencies.where((emergency) {
      return emergency['type'].contains(_searchQuery) ||
             emergency['location'].contains(_searchQuery) ||
             emergency['severity'].contains(_searchQuery);
    }).toList();
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} يوم';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} ساعة';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  // ألوان ديناميكية تعتمد على الوضع المظلم
  Color _backgroundColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Color(0xFF121212) : Color(0xFFF0F8FF);
  }
  
  Color _cardColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
  }
  
  Color _textColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Colors.white : Color(0xFF212121);
  }
  
  Color _textSecondaryColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Colors.white70 : Color(0xFF757575);
  }
  
  Color _borderColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0);
  }

  // ================ الواجهات الرئيسية ================

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
              child: Icon(Icons.emergency_rounded, color: _primaryColor, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'مركز قيادة طوارئ المياه',
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
        iconTheme: IconThemeData(color: Colors.white),
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
                      color: _emergencyRed,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
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
              _showEmergencyNotifications(context);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? _darkPrimaryColor : _primaryColor,
              border: Border(
                bottom: BorderSide(color: _secondaryColor, width: 2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left:0, right:0),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 4, color: _secondaryColor),
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
                padding: EdgeInsets.zero,
                labelPadding: EdgeInsets.symmetric(horizontal:5),
                tabs: [
                  Tab(
                    icon: Icon(Icons.dashboard_rounded, size: 22),
                    text: 'لوحة القيادة',
                  ),
                  Tab(
                    icon: Icon(Icons.emergency_rounded, size: 22),
                    text: 'حالات الطوارئ',
                  ),
                  Tab(
                    icon: Icon(Icons.engineering_rounded, size: 22),
                    text: 'فرق العمل',
                  ),
                  Tab(
                    icon: Icon(Icons.summarize_rounded, size: 22),
                    text: 'التقارير',
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
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF121212), Color(0xFF1A1A1A)],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF5F5F5), Color(0xFFE3F2FD)],
                ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildDashboardView(isDarkMode),
            _buildEmergenciesView(isDarkMode),
            _buildTeamsView(isDarkMode),
            _buildReportsView(isDarkMode), // تبويب التقارير الجديد
          ],
        ),
      ),
      drawer: _buildEmergencyDrawer(context, isDarkMode),
    );
  }

  Widget _buildDashboardView(bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بطاقة معلومات الضابط
          _buildOfficerCard(isDarkMode),
          
          SizedBox(height: 16),
          
          // الإحصائيات السريعة
          _buildQuickStatsRow(isDarkMode),
          
          SizedBox(height: 20),
          
          // حالة الطوارئ الحالية
          _buildCurrentEmergencyStatus(isDarkMode),
          
          SizedBox(height: 20),
          
          // فرق العمل المتاحة
          _buildAvailableTeamsSection(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildEmergenciesView(bool isDarkMode) {
    return Column(
      children: [
        // شريط البحث
        Padding(
          padding: const EdgeInsets.all(16),
          child: _buildSearchBar(isDarkMode, 'ابحث عن حالة طوارئ...'),
        ),
        
        Expanded(
          child: _filteredEmergencies.isEmpty && _searchQuery.isNotEmpty
              ? _buildNoResults(isDarkMode)
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredEmergencies.length,
                  itemBuilder: (context, index) {
                    return _buildEmergencyCard(_filteredEmergencies[index], isDarkMode);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTeamsView(bool isDarkMode) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          'فرق طوارئ المياه',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: isDarkMode ? _textColor(context) : _primaryColor,
          ),
        ),
        SizedBox(height: 16),
        
        ...teams.map((team) => _buildTeamCard(team, isDarkMode)),
        
        SizedBox(height: 20),
        
        Text(
          'المعدات المتاحة',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDarkMode ? _textColor(context) : _primaryColor,
          ),
        ),
        SizedBox(height: 12),
        
        ...equipment.map((item) => _buildEquipmentCard(item, isDarkMode)),
      ],
    );
  }

  // ================ تبويب التقارير (مأخوذ من المحاسب) ================

  Widget _buildReportsView(bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.summarize_rounded, color: _primaryColor, size: 24),
              ),
              const SizedBox(width: 8),
              Text(
                'نظام التقارير الطارئة',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildReportTypeFilter(isDarkMode),
          const SizedBox(height: 20),
          _buildReportOptions(isDarkMode),
          const SizedBox(height: 20),
          _buildGenerateReportButton(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildReportTypeFilter(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'نوع التقرير',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor(context),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _reportTypes.map((type) {
                  final isSelected = _selectedReportType == type;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedReportType = type;
                          _selectedDates.clear();
                          _selectedWeek = null;
                          _selectedMonth = null;
                        });
                      },
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
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportOptions(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'خيارات التقرير',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor(context),
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedReportType == 'يومي') _buildDailyOptions(),
            if (_selectedReportType == 'أسبوعي') _buildWeeklyOptions(),
            if (_selectedReportType == 'شهري') _buildMonthlyOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyOptions() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ElevatedButton(
        onPressed: _showMultiDatePicker,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today),
            SizedBox(width: 8),
            Text('فتح التقويم واختيار التواريخ'),
          ],
        ),
      ),
      const SizedBox(height: 16),
      
      if (_selectedDates.isNotEmpty) ...[
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _primaryColor.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: _successColor),
                  SizedBox(width: 8),
                  Text(
                    'تم اختيار ${_selectedDates.length} يوم',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'من ${DateFormat('yyyy-MM-dd').format(_selectedDates.reduce((a, b) => a.isBefore(b) ? a : b))} '
                'إلى ${DateFormat('yyyy-MM-dd').format(_selectedDates.reduce((a, b) => a.isAfter(b) ? a : b))}',
                style: TextStyle(
                  color: _textSecondaryColor(context),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        
        Text(
          'التواريخ المحددة:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _textColor(context),
          ),
        ),
        SizedBox(height: 8),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 120),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedDates.map((date) {
                return Chip(
                  backgroundColor: _primaryColor,
                  label: Text(
                    DateFormat('yyyy-MM-dd').format(date),
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  deleteIcon: Icon(Icons.close, color: Colors.white, size: 16),
                  onDeleted: () {
                    setState(() {
                      _selectedDates.remove(date);
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ] else ...[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _backgroundColor(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor(context)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today_outlined, color: _textSecondaryColor(context), size: 48),
              SizedBox(height: 12),
              Text(
                'لم يتم اختيار أي تواريخ',
                style: TextStyle(
                  color: _textSecondaryColor(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'انقر على الزر أعلاه لفتح التقويم\nواختيار التواريخ المطلوبة للتقرير',
                style: TextStyle(
                  color: _textSecondaryColor(context),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    ],
  );
}

  Widget _buildWeeklyOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر الأسبوع',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _textColor(context),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _weeks.map((week) {
            final isSelected = _selectedWeek == week;
            return FilterChip(
              label: Text(
                week,
                style: TextStyle(fontSize: 12),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedWeek = selected ? week : null;
                });
              },
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
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMonthlyOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر الشهر',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _textColor(context),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _months.map((month) {
            final isSelected = _selectedMonth == month;
            return FilterChip(
              label: Text(
                month,
                style: TextStyle(fontSize: 12),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedMonth = selected ? month : null;
                });
              },
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
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGenerateReportButton(bool isDarkMode) {
    bool isFormValid = false;
    
    switch (_selectedReportType) {
      case 'يومي':
        isFormValid = _selectedDates.isNotEmpty;
        break;
      case 'أسبوعي':
        isFormValid = _selectedWeek != null;
        break;
      case 'شهري':
        isFormValid = _selectedMonth != null;
        break;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isFormValid ? _generateReport : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid ? _primaryColor : _textSecondaryColor(context),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.summarize),
            const SizedBox(width: 8),
            Text(
              'إنشاء التقرير ${_selectedReportType == 'يومي' && _selectedDates.isNotEmpty ? '(${_selectedDates.length} يوم)' : ''}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // دوال التقويم متعددة التواريخ
  void _showMultiDatePicker() {
    List<DateTime> tempSelectedDates = List.from(_selectedDates);

    showDialog(
      context: context,
      builder: (context) {
        DateTime focusedDay = DateTime.now();
        
        return Dialog(
          backgroundColor: _cardColor(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'اختر التواريخ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Spacer(),
                      if (tempSelectedDates.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${tempSelectedDates.length} يوم',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _borderColor(context)),
                            ),
                            child: TableCalendar(
                              firstDay: DateTime.utc(2020, 1, 1),
                              lastDay: DateTime.utc(2030, 12, 31),
                              focusedDay: focusedDay,
                              
                              selectedDayPredicate: (day) {
                                return tempSelectedDates.any((selectedDate) {
                                  return isSameDay(selectedDate, day);
                                });
                              },
                              
                              onDaySelected: (selectedDay, focused) {
                                focusedDay = focused;
                                
                                if (tempSelectedDates.any((date) => isSameDay(date, selectedDay))) {
                                  tempSelectedDates.removeWhere((date) => isSameDay(date, selectedDay));
                                } else {
                                  tempSelectedDates.add(DateTime(selectedDay.year, selectedDay.month, selectedDay.day));
                                }
                                
                                tempSelectedDates.sort((a, b) => a.compareTo(b));
                                
                                (context as Element).markNeedsBuild();
                              },
                              
                              calendarStyle: CalendarStyle(
                                defaultTextStyle: TextStyle(color: _textColor(context)),
                                todayTextStyle: TextStyle(
                                  color: _textColor(context),
                                  fontWeight: FontWeight.bold,
                                ),
                                selectedTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                todayDecoration: BoxDecoration(
                                  color: _accentColor.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: _primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              
                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                titleTextStyle: TextStyle(
                                  color: _primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                leftChevronIcon: Icon(Icons.chevron_left, color: _primaryColor),
                                rightChevronIcon: Icon(Icons.chevron_right, color: _primaryColor),
                                headerPadding: EdgeInsets.symmetric(vertical: 8),
                                headerMargin: EdgeInsets.only(bottom: 8),
                              ),
                              
                              daysOfWeekStyle: DaysOfWeekStyle(
                                weekdayStyle: TextStyle(
                                  color: _textColor(context),
                                  fontWeight: FontWeight.w600,
                                ),
                                weekendStyle: TextStyle(
                                  color: _errorColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              
                              daysOfWeekHeight: 30,
                              weekendDays: [DateTime.friday, DateTime.saturday],
                            ),
                          ),
                          
                          SizedBox(height: 20),
                          
                          if (tempSelectedDates.isNotEmpty)
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _backgroundColor(context),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _borderColor(context)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.date_range_rounded, color: _primaryColor, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'التواريخ المختارة',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _primaryColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: tempSelectedDates.map((date) {
                                      return Chip(
                                        backgroundColor: _primaryColor,
                                        label: Text(
                                          DateFormat('yyyy-MM-dd').format(date),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        deleteIcon: Icon(Icons.close, color: Colors.white, size: 16),
                                        onDeleted: () {
                                          tempSelectedDates.remove(date);
                                          (context as Element).markNeedsBuild();
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  
                                  SizedBox(height: 12),
                                  
                                  if (tempSelectedDates.length > 1)
                                    Text(
                                      'من ${DateFormat('yyyy-MM-dd').format(tempSelectedDates.first)} '
                                      'إلى ${DateFormat('yyyy-MM-dd').format(tempSelectedDates.last)} '
                                      '(${tempSelectedDates.length} يوم)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _textSecondaryColor(context),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          
                          if (tempSelectedDates.isEmpty)
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _backgroundColor(context),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _borderColor(context)),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.touch_app_rounded, 
                                       size: 40, 
                                       color: _textSecondaryColor(context)),
                                  SizedBox(height: 12),
                                  Text(
                                    'انقر على الأيام في التقويم',
                                    style: TextStyle(
                                      color: _textColor(context),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'اختر الأيام المطلوبة للتقرير',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _textSecondaryColor(context),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: _borderColor(context))),
                    color: _cardColor(context),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _errorColor,
                            side: BorderSide(color: _errorColor),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('إلغاء'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedDates = List.from(tempSelectedDates);
                            });
                            Navigator.pop(context);
                            _showSuccessSnackbar('تم اختيار ${_selectedDates.length} يوم');
                          },
                          child: Text('تم الاختيار'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _generateReport() {
    if (_selectedReportType == 'يومي' && _selectedDates.isEmpty) {
      _showErrorSnackbar('يرجى اختيار تواريخ أولاً');
      return;
    }

    String reportPeriod = '';
    
    switch (_selectedReportType) {
      case 'يومي':
        if (_selectedDates.isNotEmpty) {
          final sortedDates = List<DateTime>.from(_selectedDates)..sort();
          if (_selectedDates.length == 1) {
            reportPeriod = DateFormat('yyyy-MM-dd').format(_selectedDates.first);
          } else {
            reportPeriod = '${DateFormat('yyyy-MM-dd').format(sortedDates.first)} إلى ${DateFormat('yyyy-MM-dd').format(sortedDates.last)}';
          }
        }
        break;
      case 'أسبوعي':
        reportPeriod = _selectedWeek ?? 'غير محدد';
        break;
      case 'شهري':
        reportPeriod = _selectedMonth ?? 'غير محدد';
        break;
    }

    _showSuccessSnackbar('تم إنشاء التقرير بنجاح');
    _showGeneratedReport(reportPeriod);
  }

  void _showGeneratedReport(String period) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        title: Text('التقرير $period', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('نوع التقرير: $_selectedReportType', style: TextStyle(color: _textColor(context))),
              if (_selectedReportType == 'يومي' && _selectedDates.isNotEmpty)
                Text('عدد الأيام: ${_selectedDates.length}', style: TextStyle(color: _textColor(context))),
              if (_selectedWeek != null)
                Text('الأسبوع: $_selectedWeek', style: TextStyle(color: _textColor(context))),
              if (_selectedMonth != null)
                Text('الشهر: $_selectedMonth', style: TextStyle(color: _textColor(context))),
              const SizedBox(height: 16),
              Text('ملخص التقرير الطارئ:', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
              Text('- إجمالي حالات الطوارئ: ${emergencies.length}', style: TextStyle(color: _textColor(context))),
              Text('- الحالات النشطة: ${emergencies.where((e) => e['status'] == 'نشط').length}', style: TextStyle(color: _textColor(context))),
              Text('- الحالات المكتملة: ${emergencies.where((e) => e['status'] == 'مكتمل').length}', style: TextStyle(color: _textColor(context))),
              Text('- حالات قيد التحقيق: ${emergencies.where((e) => e['status'] == 'قيد التحقيق').length}', style: TextStyle(color: _textColor(context))),
              Text('- عدد فرق العمل: ${teams.length}', style: TextStyle(color: _textColor(context))),
              Text('- معدل الاستجابة: ${_responseTime} دقيقة', style: TextStyle(color: _textColor(context))),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: _textSecondaryColor(context))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              _generateEmergencyPdfReport(period);
            },
            child: const Text('تصدير PDF'),
          ),
        ],
      ),
    );
  }

  // دوال PDF للتقارير الطارئة
  Future<void> _generateEmergencyPdfReport(String period) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              _buildEmergencyPdfHeader(period),
              pw.SizedBox(height: 20),
              _buildEmergencyPdfEmergencySummary(),
              pw.SizedBox(height: 20),
              _buildEmergencyPdfEmergencyDetails(),
              pw.SizedBox(height: 20),
              _buildEmergencyPdfTeamsSummary(),
            ];
          },
        ),
      );

      final Uint8List pdfBytes = await pdf.save();
      await _shareEmergencyPdfFile(pdfBytes, period);

    } catch (e) {
      _showErrorSnackbar('خطأ في تصدير التقرير: $e');
    }
  }

  Future<void> _shareEmergencyPdfFile(Uint8List pdfBytes, String period) async {
    try {
      final fileName = 'تقرير_طارئ_المياه_${DateTime.now().millisecondsSinceEpoch}.pdf';
      
      await Share.shareXFiles(
        [
          XFile.fromData(
            pdfBytes,
            name: fileName,
            mimeType: 'application/pdf',
          )
        ],
        subject: 'تقرير طارئ المياه - $period',
        text: 'مرفق التقرير الطارئ لحالات طوارئ المياه للفترة $period',
      );

      _showSuccessSnackbar('تم تصدير التقرير بنجاح');
    } catch (e) {
      _showErrorSnackbar('خطأ في مشاركة الملف: $e');
    }
  }

  pw.Widget _buildEmergencyPdfHeader(String period) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'وزارة الموارد المائية - العراق',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
              ),
            ),
            pw.Text(
              'التقرير الطارئ لطوارئ المياه',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            pw.Text(
              'نوع التقرير: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(_selectedReportType),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            pw.Text(
              'الفترة: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(period),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            pw.Text(
              'تاريخ الإنشاء: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildEmergencyPdfEmergencySummary() {
    int activeEmergencies = emergencies.where((emergency) => emergency['status'] == 'نشط').length;
    int completedEmergencies = emergencies.where((emergency) => emergency['status'] == 'مكتمل').length;
    int investigatingEmergencies = emergencies.where((emergency) => emergency['status'] == 'قيد التحقيق').length;
    int criticalEmergencies = emergencies.where((emergency) => emergency['severity'] == 'حرج').length;
    int highEmergencies = emergencies.where((emergency) => emergency['severity'] == 'عالي').length;
    int mediumEmergencies = emergencies.where((emergency) => emergency['severity'] == 'متوسط').length;
    
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blue),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: const pw.EdgeInsets.all(15),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'ملخص حالات الطوارئ',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('إجمالي حالات الطوارئ:'),
              pw.Text('${emergencies.length}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('الحالات النشطة:'),
              pw.Text('$activeEmergencies'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('الحالات المكتملة:'),
              pw.Text('$completedEmergencies'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('حالات قيد التحقيق:'),
              pw.Text('$investigatingEmergencies'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('حالات حرجة:'),
              pw.Text('$criticalEmergencies'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('حالات عالية الخطورة:'),
              pw.Text('$highEmergencies'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('حالات متوسطة الخطورة:'),
              pw.Text('$mediumEmergencies'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('معدل الاستجابة:'),
              pw.Text('${_responseTime} دقيقة'),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildEmergencyPdfEmergencyDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'تفاصيل حالات الطوارئ',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.blue100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('رقم الحالة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('نوع الطوارئ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الموقع', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الخطورة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الحالة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('تاريخ التبليغ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            ...emergencies.map((emergency) => pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(emergency['id']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(emergency['type']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(emergency['location']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    emergency['severity'],
                    style: pw.TextStyle(
                      color: _getEmergencyPdfSeverityColor(emergency['severity']),
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(emergency['status']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(DateFormat('yyyy-MM-dd HH:mm').format(emergency['reportedAt'])),
                ),
              ],
            )).toList(),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildEmergencyPdfTeamsSummary() {
    int availableTeams = teams.where((team) => team['status'] == 'متاح').length;
    int inFieldTeams = teams.where((team) => team['status'] == 'في الميدان').length;
    int readyTeams = teams.where((team) => team['status'] == 'جاهز').length;
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'فرق العمل',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.blue100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('اسم الفريق', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('التخصص', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('عدد الأعضاء', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الحالة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الموقع الحالي', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            ...teams.map((team) => pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(team['name']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(team['specialization']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('${team['members']}'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    team['status'],
                    style: pw.TextStyle(
                      color: _getEmergencyPdfTeamStatusColor(team['status']),
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(team['currentLocation']),
                ),
              ],
            )).toList(),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('إجمالي الفرق:'),
            pw.Text('${teams.length}'),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('الفرق المتاحة:'),
            pw.Text('$availableTeams'),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('فرق في الميدان:'),
            pw.Text('$inFieldTeams'),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('فرق جاهزة:'),
            pw.Text('$readyTeams'),
          ],
        ),
      ],
    );
  }

  PdfColor _getEmergencyPdfSeverityColor(String severity) {
    switch (severity) {
      case 'حرج':
        return PdfColors.red;
      case 'عالي':
        return PdfColors.orange;
      case 'متوسط':
        return PdfColors.yellow;
      case 'منخفض':
        return PdfColors.green;
      default:
        return PdfColors.grey;
    }
  }

  PdfColor _getEmergencyPdfTeamStatusColor(String status) {
    switch (status) {
      case 'متاح':
        return PdfColors.green;
      case 'في الميدان':
        return PdfColors.blue;
      case 'جاهز':
        return PdfColors.orange;
      default:
        return PdfColors.grey;
    }
  }

  // ================ واجهات فرعية ================

  Widget _buildOfficerCard(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _borderColor(context),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: _secondaryColor, width: 2),
                  ),
                  child: Icon(
                    Icons.security_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'أحمد محمد',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: _textColor(context),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'ضابط طوارئ المياه - القطاع الشمالي',
                        style: TextStyle(
                          fontSize: 14,
                          color: _textSecondaryColor(context),
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'على رأس العمل',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh_rounded, color: _primaryColor),
                  onPressed: () {
                    setState(() {
                      _resolvedToday++;
                    });
                    _showSuccessSnackbar('تم تحديث البيانات');
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDashboardStat(
                  Icons.emergency_rounded,
                  '$_activeEmergencies',
                  'حالات نشطة',
                  _emergencyRed,
                ),
                _buildDashboardStat(
                  Icons.engineering_rounded,
                  '$_availableTeams',
                  'فرق متاحة',
                  _primaryColor,
                ),
                _buildDashboardStat(
                  Icons.check_circle_rounded,
                  '$_resolvedToday',
                  'تم حلها اليوم',
                  _successColor,
                ),
                _buildDashboardStat(
                  Icons.access_time_rounded,
                  '${_responseTime}د',
                  'متوسط الاستجابة',
                  _warningColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardStat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: _textSecondaryColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatsRow(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'حالات الطوارئ',
            '${emergencies.length}',
            Icons.warning_amber_rounded,
            _emergencyRed,
            () => _showAllEmergencies(context),
            isDarkMode,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            'فرق العمل',
            '${teams.length}',
            Icons.group_rounded,
            _primaryColor,
            () => _showAllTeams(context),
            isDarkMode,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            'نسبة الإنجاز',
            '85%',
            Icons.trending_up_rounded,
            _successColor,
            () => _showPerformanceAnalytics(context),
            isDarkMode,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, VoidCallback onTap, bool isDarkMode) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _cardColor(context),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: _borderColor(context),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: _textSecondaryColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentEmergencyStatus(bool isDarkMode) {
    Map<String, dynamic>? currentEmergency = emergencies.firstWhere(
      (e) => e['status'] == 'نشط',
      orElse: () => emergencies[0],
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _borderColor(context),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _emergencyRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.warning_amber_rounded, color: _emergencyRed, size: 24),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'حالة الطوارئ الحالية',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _textColor(context),
                        ),
                      ),
                      Text(
                        currentEmergency['type'],
                        style: TextStyle(
                          fontSize: 14,
                          color: _textSecondaryColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(currentEmergency['severity']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    currentEmergency['severity'],
                    style: TextStyle(
                      color: _getSeverityColor(currentEmergency['severity']),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.location_on_rounded, color: _primaryColor, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    currentEmergency['location'],
                    style: TextStyle(
                      color: _textColor(context),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time_rounded, color: _primaryColor, size: 16),
                SizedBox(width: 8),
                Text(
                  'منذ ${DateFormat('HH:mm').format(currentEmergency['reportedAt'])}',
                  style: TextStyle(
                    color: _textColor(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: currentEmergency['progress'] / 100,
              backgroundColor: _borderColor(context),
              color: _primaryColor,
              borderRadius: BorderRadius.circular(4),
              minHeight: 8,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'التقدم: ${currentEmergency['progress']}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: _textSecondaryColor(context),
                  ),
                ),
                Text(
                  currentEmergency['assignedTeam'],
                  style: TextStyle(
                    fontSize: 12,
                    color: _primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showEmergencyDetails(currentEmergency, context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primaryColor,
                      side: BorderSide(color: _primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('عرض التفاصيل'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateEmergencyProgress(currentEmergency),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('تحديث الحالة'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableTeamsSection(bool isDarkMode) {
    List<Map<String, dynamic>> availableTeams = teams.where((team) => team['status'] == 'متاح').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'فرق العمل المتاحة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _textColor(context),
              ),
            ),
            TextButton(
              onPressed: () => _showAllTeams(context),
              child: Text(
                'عرض الكل',
                style: TextStyle(color: _primaryColor),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        availableTeams.isEmpty
            ? _buildEmptyState('لا توجد فرق متاحة حالياً', Icons.group_off_rounded, isDarkMode)
            : GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: availableTeams.length,
                itemBuilder: (context, index) {
                  return _buildTeamMiniCard(availableTeams[index], isDarkMode);
                },
              ),
      ],
    );
  }

  Widget _buildEmergencyCard(Map<String, dynamic> emergency, bool isDarkMode) {
    Color severityColor = _getSeverityColor(emergency['severity']);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _borderColor(context),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: severityColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.warning_amber_rounded, color: severityColor, size: 24),
        ),
        title: Text(
          emergency['type'],
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: _textColor(context),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              emergency['location'],
              style: TextStyle(
                fontSize: 14,
                color: _textSecondaryColor(context),
              ),
            ),
            SizedBox(height: 2),
            Text(
              'منذ ${_formatDuration(DateTime.now().difference(emergency['reportedAt']))}',
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor(context),
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: severityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                emergency['severity'],
                style: TextStyle(
                  fontSize: 12,
                  color: severityColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: emergency['status'] == 'نشط' ? _primaryColor.withOpacity(0.1) : _successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                emergency['status'],
                style: TextStyle(
                  fontSize: 10,
                  color: emergency['status'] == 'نشط' ? _primaryColor : _successColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        onTap: () => _showEmergencyDetails(emergency, context),
      ),
    );
  }

  Widget _buildTeamCard(Map<String, dynamic> team, bool isDarkMode) {
    bool isAvailable = team['status'] == 'متاح';
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _borderColor(context),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isAvailable ? _primaryColor.withOpacity(0.1) : _warningColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.engineering_rounded, 
               color: isAvailable ? _primaryColor : _warningColor, 
               size: 24),
        ),
        title: Text(
          team['name'],
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: _textColor(context),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              team['specialization'],
              style: TextStyle(
                fontSize: 14,
                color: _textSecondaryColor(context),
              ),
            ),
            SizedBox(height: 2),
            Text(
              '${team['members']} أعضاء - ${team['currentLocation']}',
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor(context),
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isAvailable ? _successColor.withOpacity(0.1) : _warningColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                team['status'],
                style: TextStyle(
                  fontSize: 12,
                  color: isAvailable ? _successColor : _warningColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 4),
            IconButton(
              icon: Icon(Icons.send_rounded, color: _primaryColor, size: 18),
              onPressed: () => _assignTeamToEmergency(team, context),
            ),
          ],
        ),
        onTap: () => _showTeamDetails(team, context),
      ),
    );
  }

  Widget _buildEquipmentCard(Map<String, dynamic> equipment, bool isDarkMode) {
    bool isAvailable = equipment['status'] == 'متاح';
    
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _backgroundColor(context),
        border: Border.all(color: _borderColor(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isAvailable ? _primaryColor.withOpacity(0.1) : _warningColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.build_rounded, 
                 color: isAvailable ? _primaryColor : _warningColor, 
                 size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  equipment['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _textColor(context),
                  ),
                ),
                Text(
                  '${equipment['type']} - ${equipment['location']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: _textSecondaryColor(context),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isAvailable ? _successColor.withOpacity(0.1) : _warningColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              equipment['status'],
              style: TextStyle(
                fontSize: 10,
                color: isAvailable ? _successColor : _warningColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMiniCard(Map<String, dynamic> team, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        border: Border.all(color: _borderColor(context)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.engineering_rounded, color: _primaryColor, size: 18),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    team['status'],
                    style: TextStyle(
                      fontSize: 10,
                      color: _successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              team['name'],
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: _textColor(context),
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${team['members']} أعضاء',
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor(context),
              ),
            ),
            SizedBox(height: 8),
            Text(
              team['currentLocation'],
              style: TextStyle(
                fontSize: 10,
                color: _primaryColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDarkMode, String hintText) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _borderColor(context),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _updateSearchQuery,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(Icons.search_rounded, color: _textSecondaryColor(context)),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, color: _textSecondaryColor(context)),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(icon, size: 64, color: _textSecondaryColor(context)),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: _textSecondaryColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, 
               size: 64, 
               color: _textSecondaryColor(context)),
          SizedBox(height: 16),
          Text(
            'لا توجد نتائج للبحث',
            style: TextStyle(
              fontSize: 18,
              color: _textSecondaryColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'لم نتمكن من العثور على أي حالة طوارئ تطابق "$_searchQuery"',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textSecondaryColor(context),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _clearSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('مسح البحث'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyDrawer(BuildContext context, bool isDarkMode) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode 
                ? [_darkPrimaryColor, Color(0xFF0D1B2A)]
                : [_primaryColor, Color(0xFF29B6F6)],
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
                      ? [_darkPrimaryColor, Color(0xFF1565C0)]
                      : [_primaryColor, Color(0xFF0288D1)],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(
                      Icons.security_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "ضابط طوارئ المياه",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "أحمد محمد - القطاع الشمالي",
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "على رأس العمل",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                color: isDarkMode ? Color(0xFF0D1B2A) : Color(0xFFE3F2FD),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerMenuItem(
                      icon: Icons.settings_rounded,
                      title: 'الإعدادات',
                      onTap: () => _showSettingsScreen(context, isDarkMode),
                      isDarkMode: isDarkMode,
                    ),
                    
                    _buildDrawerMenuItem(
                      icon: Icons.help_rounded,
                      title: 'المساعدة والدعم',
                      onTap: () => _showHelpSupportScreen(context, isDarkMode),
                      isDarkMode: isDarkMode,
                    ),

                    SizedBox(height: 30),
                    
                    _buildDrawerMenuItem(
                      icon: Icons.logout_rounded,
                      title: 'تسجيل الخروج',
                      onTap: () => _showLogoutConfirmation(context, isDarkMode),
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
                            'وزارة الموارد المائية - مركز طوارئ المياه',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.grey[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'الإصدار 1.0.0 - نظام القيادة',
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

  // ================ دوال تفاعلية ================

  void _showEmergencyNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.notifications_active_rounded, color: _primaryColor),
            SizedBox(width: 8),
            Text('إشعارات الطوارئ'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNotificationItem(
                'بلاغ طارئ جديد',
                'انقطاع مياه في حي السعدون',
                'منذ 5 دقائق',
                _emergencyRed,
              ),
              _buildNotificationItem(
                'تحديث حالة الفريق',
                'فريق الصيانة السريعة أكمل المهمة',
                'منذ ساعة',
                _successColor,
              ),
              _buildNotificationItem(
                'تحذير جودة المياه',
                'انخفاض في جودة المياه بالقطاع الشرقي',
                'منذ 3 ساعات',
                _warningColor,
              ),
              _buildNotificationItem(
                'اجتماع طارئ',
                'اجتماع طارئ لإدارة الأزمة',
                'منذ يوم',
                _primaryColor,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: _textSecondaryColor(context))),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String message, String time, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color.withOpacity(0.05),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, color: color, size: 8),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _textColor(context),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    color: _textSecondaryColor(context),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: _textSecondaryColor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDetails(Map<String, dynamic> emergency, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: _cardColor(context),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _primaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'تفاصيل حالة الطوارئ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      emergency['id'],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getSeverityColor(emergency['severity']).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            color: _getSeverityColor(emergency['severity']),
                            size: 32,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                emergency['type'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: _textColor(context),
                                ),
                              ),
                              Text(
                                'حالة ${emergency['status']}',
                                style: TextStyle(
                                  color: emergency['status'] == 'نشط' ? _primaryColor : _successColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    _buildDetailItem('المكان:', emergency['location'], Icons.location_on_rounded),
                    _buildDetailItem('تاريخ التبليغ:', DateFormat('yyyy-MM-dd HH:mm').format(emergency['reportedAt']), Icons.access_time_rounded),
                    _buildDetailItem('الخطورة:', emergency['severity'], Icons.warning_amber_rounded),
                    _buildDetailItem('الفريق المكلف:', emergency['assignedTeam'], Icons.engineering_rounded),
                    
                    SizedBox(height: 24),
                    Text(
                      'تقدم الحل',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _textColor(context),
                      ),
                    ),
                    SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: emergency['progress'] / 100,
                      backgroundColor: _borderColor(context),
                      color: _primaryColor,
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 12,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${emergency['progress']}%',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _primaryColor,
                          ),
                        ),
                        Text(
                          emergency['progress'] == 100 ? 'مكتمل' : 'قيد التنفيذ',
                          style: TextStyle(
                            color: _textSecondaryColor(context),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _updateEmergencyProgress(emergency),
                            icon: Icon(Icons.update_rounded, size: 18),
                            label: Text('تحديث التقدم'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _primaryColor,
                              side: BorderSide(color: _primaryColor),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _assignNewTeam(emergency, context),
                            icon: Icon(Icons.group_add_rounded, size: 18),
                            label: Text('تغيير الفريق'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: _primaryColor, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: _textSecondaryColor(context),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textColor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTeamDetails(Map<String, dynamic> team, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.engineering_rounded, color: _primaryColor),
            ),
            SizedBox(width: 12),
            Text('تفاصيل الفريق'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                team['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _textColor(context),
                ),
              ),
              SizedBox(height: 8),
              Text(
                team['specialization'],
                style: TextStyle(
                  color: _textSecondaryColor(context),
                ),
              ),
              SizedBox(height: 16),
              _buildTeamDetailRow('الحالة:', team['status']),
              _buildTeamDetailRow('عدد الأعضاء:', '${team['members']} أعضاء'),
              _buildTeamDetailRow('الموقع الحالي:', team['currentLocation']),
              _buildTeamDetailRow('آخر نشاط:', DateFormat('HH:mm').format(team['lastActive'])),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: _textSecondaryColor(context))),
          ),
          ElevatedButton(
            onPressed: () => _assignTeamToEmergency(team, context),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('تكليف بمهمة'),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: _textSecondaryColor(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: _textColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _updateEmergencyProgress(Map<String, dynamic> emergency) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          int progress = emergency['progress'];
          
          return AlertDialog(
            backgroundColor: _cardColor(context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(Icons.update_rounded, color: _primaryColor),
                SizedBox(width: 8),
                Text('تحديث تقدم الحل'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'تقدم حالة الطوارئ ${emergency['id']}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _textColor(context),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '$progress%',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: _primaryColor,
                  ),
                ),
                SizedBox(height: 20),
                Slider(
                  value: progress.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 10,
                  onChanged: (value) {
                    setState(() {
                      progress = value.toInt();
                    });
                  },
                  activeColor: _primaryColor,
                  inactiveColor: _borderColor(context),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'ملاحظات التحديث',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor(context))),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    emergency['progress'] = progress;
                    if (progress == 100) {
                      emergency['status'] = 'مكتمل';
                      _activeEmergencies--;
                      _resolvedToday++;
                    }
                  });
                  Navigator.pop(context);
                  _showSuccessSnackbar('تم تحديث التقدم بنجاح');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text('تحديث'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _assignTeamToEmergency(Map<String, dynamic> team, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          String? selectedEmergencyId;
          
          return AlertDialog(
            backgroundColor: _cardColor(context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(Icons.group_add_rounded, color: _primaryColor),
                SizedBox(width: 8),
                Text('تكليف الفريق بمهمة'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'توجيه ${team['name']} إلى:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _textColor(context),
                  ),
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedEmergencyId,
                  onChanged: (String? newValue) {
                    setState(() => selectedEmergencyId = newValue);
                  },
                  items: emergencies.where((e) => e['status'] == 'نشط').map<DropdownMenuItem<String>>((emergency) {
                    return DropdownMenuItem<String>(
                      value: emergency['id'],
                      child: Text('${emergency['id']} - ${emergency['type']}'),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'اختر حالة الطوارئ',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'تعليمات خاصة للفريق',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor(context))),
              ),
              ElevatedButton(
                onPressed: selectedEmergencyId == null ? null : () {
                  var emergency = emergencies.firstWhere((e) => e['id'] == selectedEmergencyId);
                  setState(() {
                    emergency['assignedTeam'] = team['name'];
                    team['status'] = 'في الميدان';
                    _availableTeams--;
                  });
                  Navigator.pop(context);
                  _showSuccessSnackbar('تم تكليف الفريق بنجاح');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: Text('تأكيد التكليف'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _assignNewTeam(Map<String, dynamic> emergency, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('تغيير الفريق المكلف'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: teams.map((team) {
              return ListTile(
                leading: Icon(Icons.engineering_rounded, 
                     color: team['status'] == 'متاح' ? _primaryColor : _textSecondaryColor(context)),
                title: Text(team['name']),
                subtitle: Text('${team['members']} أعضاء - ${team['status']}'),
                trailing: team['status'] == 'متاح' 
                    ? Icon(Icons.check_circle_outline_rounded, color: _primaryColor)
                    : Icon(Icons.block_rounded, color: _textSecondaryColor(context)),
                onTap: team['status'] == 'متاح' ? () {
                  setState(() {
                    emergency['assignedTeam'] = team['name'];
                    team['status'] = 'في الميدان';
                  });
                  Navigator.pop(context);
                  _showSuccessSnackbar('تم تغيير الفريق المكلف');
                } : null,
              );
            }).toList(),
          ),
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

  void _showAllEmergencies(BuildContext context) {
    _tabController.animateTo(1);
  }

  void _showAllTeams(BuildContext context) {
    _tabController.animateTo(2);
  }

  void _showPerformanceAnalytics(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.analytics_rounded, color: _primaryColor),
            SizedBox(width: 8),
            Text('تحليلات الأداء'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('📊 أداء هذا الشهر:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              _buildPerformanceMetric('معدل الاستجابة', '${_responseTime} دقيقة', 85, Colors.green),
              _buildPerformanceMetric('حالات مكتملة', '${_resolvedToday} حالة', 92, Colors.blue),
              _buildPerformanceMetric('الكفاءة', '88%', 88, Colors.orange),
              _buildPerformanceMetric('سرعة الإنجاز', '78%', 78, Colors.purple),
              SizedBox(height: 20),
              Text('🎯 الأهداف:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• تقليل وقت الاستجابة إلى 40 دقيقة'),
              Text('• إكمال 95% من الحالات في وقتها'),
              Text('• رفع كفاءة الفرق إلى 90%'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: _textSecondaryColor(context))),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetric(String label, String value, int percent, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text(value),
            ],
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: percent / 100,
            backgroundColor: _borderColor(context),
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
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
          darkCardColor: Color(0xFF1E1E1E),
          cardColor: Colors.white,
          darkTextColor: Colors.white,
          textColor: Color(0xFF212121),
          darkTextSecondaryColor: Colors.white70,
          textSecondaryColor: Color(0xFF757575),
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
          darkCardColor: Color(0xFF1E1E1E),
          cardColor: Colors.white,
          darkTextColor: Colors.white,
          textColor: Color(0xFF212121),
          darkTextSecondaryColor: Colors.white70,
          textSecondaryColor: Color(0xFF757575),
        ),
      ),
    );
  }
  
  void _showLogoutConfirmation(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('تأكيد تسجيل الخروج'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
          style: TextStyle(
            color: _textColor(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor(context))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, EsigninScreen.screenroot);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('تسجيل الخروج'),
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
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _errorColor,
        duration: Duration(seconds: 4),
      ),
    );
  }
}

// ================ شاشة الإعدادات ================

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
  bool _emergencyAlerts = true;
  bool _gpsTracking = true;
  bool _teamNotifications = true;
  String _mapProvider = 'Google Maps';
  String _reportFormat = 'PDF';
  String _language = 'العربية';
  final List<String> _languages = ['العربية', 'English'];
  final List<String> _mapProviders = ['Google Maps', 'OpenStreetMap', 'ArcGIS'];
  final List<String> _reportFormats = ['PDF', 'Excel', 'Word', 'Text'];

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
      'emergencyAlerts': _emergencyAlerts,
      'gpsTracking': _gpsTracking,
      'teamNotifications': _teamNotifications,
      'mapProvider': _mapProvider,
      'reportFormat': _reportFormat,
      'language': _language,
    };
    
    widget.onSettingsChanged(settings);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حفظ إعدادات الطوارئ بنجاح'),
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
            'هل أنت متأكد من أنك تريد إعادة جميع إعدادات الطوارئ إلى القيم الافتراضية؟',
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
                  _emergencyAlerts = true;
                  _gpsTracking = true;
                  _teamNotifications = true;
                  _mapProvider = 'Google Maps';
                  _reportFormat = 'PDF';
                  _language = 'العربية';
                });
                
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
          'إعدادات نظام الطوارئ',
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
                      colors: [Color(0xFFF5F5F5), Color(0xFFE3F2FD)],
                    ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSettingsSection('الإشعارات الطارئة', Icons.notifications_active_rounded, themeProvider),
                  _buildSettingSwitch(
                    'إشعارات الطوارئ',
                    'استلام إشعارات حالات الطوارئ الجديدة',
                    _emergencyAlerts,
                    (bool value) => setState(() => _emergencyAlerts = value),
                    themeProvider,
                  ),
                  _buildSettingSwitch(
                    'إشعارات الفرق',
                    'تحديثات من الفرق الميدانية',
                    _teamNotifications,
                    (bool value) => setState(() => _teamNotifications = value),
                    themeProvider,
                  ),
                  _buildSettingSwitch(
                    'الصوت',
                    'تشغيل صوت للإشعارات الطارئة',
                    _soundEnabled,
                    (bool value) => setState(() => _soundEnabled = value),
                    themeProvider,
                  ),
                  _buildSettingSwitch(
                    'الاهتزاز',
                    'اهتزاز الجهاز عند الإشعارات الطارئة',
                    _vibrationEnabled,
                    (bool value) => setState(() => _vibrationEnabled = value),
                    themeProvider,
                  ),

                  SizedBox(height: 24),
                  _buildSettingsSection('المظهر والخريطة', Icons.palette_rounded, themeProvider),
                  
                  _buildDarkModeSwitch(themeProvider),
                  
                  _buildSettingDropdown(
                    'مزود الخريطة',
                    _mapProvider,
                    _mapProviders,
                    (String? value) => setState(() => _mapProvider = value!),
                    themeProvider,
                  ),
                  
                  _buildSettingDropdown(
                    'اللغة',
                    _language,
                    _languages,
                    (String? value) => setState(() {
                      if (value != null) {
                        _language = value;
                      }
                    }),
                    themeProvider,
                  ),

                  SizedBox(height: 24),
                  _buildSettingsSection('الأمان والبيانات', Icons.security_rounded, themeProvider),
                  _buildSettingSwitch(
                    'المصادقة البيومترية',
                    'استخدام البصمة أو الوجه لتسجيل الدخول',
                    _biometricAuth,
                    (bool value) => setState(() => _biometricAuth = value),
                    themeProvider,
                  ),
                  _buildSettingSwitch(
                    'نسخ احتياطي تلقائي',
                    'نسخ بيانات الطوارئ تلقائياً',
                    _autoBackup,
                    (bool value) => setState(() => _autoBackup = value),
                    themeProvider,
                  ),
                  _buildSettingSwitch(
                    'المزامنة التلقائية',
                    'مزامنة البيانات مع السحابة',
                    _autoSync,
                    (bool value) => setState(() => _autoSync = value),
                    themeProvider,
                  ),
                  _buildSettingSwitch(
                    'تتبع الموقع',
                    'مشاركة الموقع مع مركز القيادة',
                    _gpsTracking,
                    (bool value) => setState(() => _gpsTracking = value),
                    themeProvider,
                  ),

                  SizedBox(height: 24),
                  _buildSettingsSection('التقارير والمستندات', Icons.description_rounded, themeProvider),
                  _buildSettingDropdown(
                    'صيغة التقارير',
                    _reportFormat,
                    _reportFormats,
                    (String? value) => setState(() => _reportFormat = value!),
                    themeProvider,
                  ),

                  SizedBox(height: 24),
                  _buildSettingsSection('حول النظام', Icons.info_rounded, themeProvider),
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
                  themeProvider.isDarkMode ? 'مفعل - مثالي للمناوبات الليلية' : 'معطل - استمتع بالمظهر الافتراضي',
                  style: TextStyle(
                    fontSize: 12,
                    color: themeProvider.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
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
              dropdownColor: themeProvider.isDarkMode ? widget.darkCardColor : widget.cardColor,
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
          _buildAboutRow('الإصدار', '2.0.1 (الطوارئ)', themeProvider),
          _buildAboutRow('تاريخ البناء', '2024-03-20', themeProvider),
          _buildAboutRow('المطور', 'وزارة الموارد المائية - قسم الطوارئ', themeProvider),
          _buildAboutRow('رقم الترخيص', 'MWR-EMG-2024-001', themeProvider),
          _buildAboutRow('آخر تحديث', '2024-03-15', themeProvider),
          _buildAboutRow('البريد الإلكتروني', 'emergency-support@water.gov.iq', themeProvider),
          _buildAboutRow('رقم الطوارئ', '0770-123-4567', themeProvider),
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

// ================ شاشة المساعدة والدعم ================

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
          'المساعدة والدعم - نظام الطوارئ',
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
                  colors: [Color(0xFFF5F5F5), Color(0xFFE3F2FD)],
                ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEmergencyContactCard(context),

              SizedBox(height: 24),

              _buildSectionTitle('التعليمات السريعة للطوارئ'),
              ..._buildEmergencyFAQItems(),

              SizedBox(height: 24),
              _buildSectionTitle('إجراءات الطوارئ'),
              ..._buildEmergencyProcedures(),

              SizedBox(height: 24),
              _buildSectionTitle('أرقام الطوارئ المهمة'),
              _buildEmergencyNumbersCard(),

              SizedBox(height: 24),
              _buildSectionTitle('معلومات النظام'),
              _buildSystemInfoCard(),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyContactCard(BuildContext context) {
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
                  'مركز قيادة طوارئ المياه',
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
          _buildEmergencyContactItem(Icons.phone_rounded, 'الطوارئ الفنية', '0770-123-4567', true, context),
          _buildEmergencyContactItem(Icons.phone_rounded, 'الطوارئ الرئيسية', '0780-987-6543', true, context),
          _buildEmergencyContactItem(Icons.email_rounded, 'البريد الطارئ', 'emergency@water.gov.iq', false, context),
          _buildEmergencyContactItem(Icons.access_time_rounded, 'الدعم 24/7', 'مستمر على مدار الساعة', false, context),
          _buildEmergencyContactItem(Icons.location_on_rounded, 'مركز القيادة', 'بغداد - وزارة الموارد المائية', false, context),
          SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _makeEmergencyCall('07701234567', context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(Icons.emergency_rounded, size: 20),
                  label: Text('اتصال طارئ فوري'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _openEmergencyChat(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
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

  void _openEmergencyChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmergencySupportChatScreen(
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

  Widget _buildEmergencyContactItem(IconData icon, String title, String value, bool isPhone, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: isPhone ? Colors.red : primaryColor, size: 20),
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
              onTap: isPhone ? () => _makeEmergencyCall(value, context) : null,
              child: Text(
                value,
                style: TextStyle(
                  color: isPhone ? Colors.red : (isDarkMode ? darkTextSecondaryColor : textSecondaryColor),
                  decoration: isPhone ? TextDecoration.underline : TextDecoration.none,
                  fontWeight: isPhone ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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

  List<Widget> _buildEmergencyFAQItems() {
    List<Map<String, String>> faqs = [
      {
        'question': 'كيف أضيف حالة طوارئ جديدة في النظام؟',
        'answer': 'انقر على زر "+" الأحمر → اختر نوع الطوارئ → حدد الموقع → اختر درجة الخطورة → أضف التفاصيل → اضغط "إضافة الحالة"'
      },
      {
        'question': 'كيف أتصل بفريق العمل في الميدان؟',
        'answer': 'اذهب إلى قسم "فرق العمل" → اختر الفريق المطلوب → انقر على أيقونة الاتصال → اختر طريقة الاتصال → تأكيد الاتصال'
      },
      {
        'question': 'كيف أحدد أولوية حالة الطوارئ؟',
        'answer': 'حالات "حرج": انقطاع شامل، تلوث خطير\nحالات "عالي": تسرب رئيسي، أضرار بشرية\nحالات "متوسط": انخفاض ضغط، أعطال جزئية\nحالات "منخفض": شكاوى بسيطة، طلبات صيانة'
      },
      {
        'question': 'كيف أتابع تقدم حل حالة الطوارئ؟',
        'answer': 'اذهب إلى "حالات الطوارئ" → اختر الحالة → انظر إلى شريط التقدم → انقر "تحديث الحالة" → أدخل النسبة الجديدة'
      },
      {
        'question': 'كيف أنشئ تقريراً طارئاً؟',
        'answer': 'اذهب إلى قسم "التقارير" → انقر "إنشاء تقرير جديد" → اختر نوع التقرير → املأ التفاصيل → احفظ التقرير'
      },
    ];

    return faqs.map((faq) {
      return _buildExpandableItem(faq['question']!, faq['answer']!);
    }).toList();
  }

  List<Widget> _buildEmergencyProcedures() {
    List<Map<String, String>> procedures = [
      {
        'title': 'إجراءات انقطاع المياه الشامل',
        'steps': '1. تصنيف الحالة كـ"حرج"\n2. إشعار المواطنين فوراً\n3. توجيه فرق الإصلاح\n4. توفير صهاريج المياه\n5. متابعة الحالة كل ساعة'
      },
      {
        'title': 'إجراءات التسرب الخطير',
        'steps': '1. عزل المنطقة المتضررة\n2. إغلاق المحابس الرئيسية\n3. إخلاء المنطقة إذا لزم الأمر\n4. إرسال فرق الإصلاح\n5. تقييم الأضرار'
      },
      {
        'title': 'إجراءات تلوث المياه',
        'steps': '1. إيقاف ضخ المياه فوراً\n2. أخذ عينات للفحص\n3. إشعار الجهات الصحية\n4. توفير مياه بديلة\n5. تطبيق برنامج التعقيم'
      },
      {
        'title': 'إجراءات الأعطال الليلية',
        'steps': '1. تفعيل الفريق الليلي\n2. استخدام الإضاءة والسلامة\n3. تسجيل جميع التفاصيل\n4. متابعة حتى الصباح\n5. تسليم التقرير'
      },
    ];

    return procedures.map((proc) {
      return _buildProcedureCard(proc['title']!, proc['steps']!);
    }).toList();
  }

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

  Widget _buildProcedureCard(String title, String steps) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.red.withOpacity(0.05),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? darkTextColor : textColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            steps,
            style: TextStyle(
              color: isDarkMode ? darkTextSecondaryColor : textSecondaryColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyNumbersCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? darkCardColor : cardColor,
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildEmergencyNumberRow('الدفاع المدني', '998', Colors.red),
          _buildEmergencyNumberRow('الشرطة', '911', Colors.blue),
          _buildEmergencyNumberRow('الإسعاف', '122', Colors.green),
          _buildEmergencyNumberRow('شرطة المياه', '155', primaryColor),
          _buildEmergencyNumberRow('وزارة الصحة', '*121#', Colors.teal),
          _buildEmergencyNumberRow('وزارة البيئة', '*123#', Colors.green),
        ],
      ),
    );
  }

  Widget _buildEmergencyNumberRow(String agency, String number, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              agency,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDarkMode ? darkTextColor : textColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _makeEmergencyCall(number, null),
            child: Text(
              number,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemInfoCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? darkCardColor : cardColor,
      ),
      child: Column(
        children: [
          _buildInfoRow('إصدار النظام', '2.0.1 (الطوارئ)', isDarkMode),
          _buildInfoRow('تاريخ التحديث', '2024-03-20', isDarkMode),
          _buildInfoRow('رقم الرخصة', 'MWR-EMG-2024-001', isDarkMode),
          _buildInfoRow('المطور', 'قسم تكنولوجيا الطوارئ', isDarkMode),
          _buildInfoRow('سعة النظام', '1000 حالة/يوم', isDarkMode),
          _buildInfoRow('وقت الاستجابة', '< 5 دقائق', isDarkMode),
          _buildInfoRow('التوافق', 'Android 8.0+, iOS 12+', isDarkMode),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, bool isDarkMode) {
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

  void _makeEmergencyCall(String phoneNumber, BuildContext? context) {
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('جارٍ الاتصال بـ $phoneNumber'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
    
    launch('tel:$cleanNumber');
  }
}

// ================ شاشة الدردشة الطارئة ================

class EmergencySupportChatScreen extends StatefulWidget {
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

  const EmergencySupportChatScreen({
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
  _EmergencySupportChatScreenState createState() => _EmergencySupportChatScreenState();
}

class _EmergencySupportChatScreenState extends State<EmergencySupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'مرحباً! أنا مشرف دعم طوارئ المياه، هل لديك حالة طارئة تحتاج للمساعدة؟',
      'isUser': false,
      'time': 'الآن',
      'sender': 'مشرف الدعم الطارئ'
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

    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'text': 'تم استلام رسالتك. هل هذه حالة طارئة تتطلب استجابة فورية؟',
            'isUser': false,
            'time': 'الآن',
            'sender': 'مشرف الدعم الطارئ'
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
              'دردشة الدعم الطارئ للمياه',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              'متصل الآن - استجابة فورية',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
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
                _endEmergencyChat(context);
              } else if (value == 'share_location') {
                _shareLocation(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'share_location',
                child: Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: widget.primaryColor),
                    SizedBox(width: 8),
                    Text('مشاركة الموقع'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'end_chat',
                child: Row(
                  children: [
                    Icon(Icons.close_rounded, color: Colors.red),
                    SizedBox(width: 8),
                    Text('إنهاء المحادثة الطارئة'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.05),
              border: Border(
                bottom: BorderSide(color: Colors.red.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red,
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
                        'محمد علي - مشرف الطوارئ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: widget.isDarkMode ? widget.darkTextColor : widget.textColor,
                        ),
                      ),
                      Text(
                        'متخصص في إدارة أزمات المياه',
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
                  child: Row(
                    children: [
                      Icon(Icons.circle, color: Colors.white, size: 6),
                      SizedBox(width: 4),
                      Text(
                        'متصل',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildEmergencyMessageBubble(message);
              },
            ),
          ),

          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isDarkMode ? widget.darkCardColor : widget.cardColor,
              border: Border(
                top: BorderSide(color: Colors.red.withOpacity(0.1)),
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
                        hintText: 'اكتب رسالة طارئة...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.attach_file_rounded, color: widget.primaryColor),
                          onPressed: () => _showEmergencyAttachmentOptions(context),
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.red,
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

  Widget _buildEmergencyMessageBubble(Map<String, dynamic> message) {
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
                color: Colors.red,
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
                        ? Colors.red 
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
                color: widget.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_rounded, color: Colors.white, size: 16),
            ),
        ],
      ),
    );
  }

  void _showEmergencyAttachmentOptions(BuildContext context) {
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
              'إرفاق ملف طارئ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: widget.isDarkMode ? widget.darkTextColor : widget.textColor,
              ),
            ),
            SizedBox(height: 16),
            _buildEmergencyAttachmentOption(Icons.photo_rounded, 'صورة الموقع', () {}),
            _buildEmergencyAttachmentOption(Icons.videocam_rounded, 'فيديو الحالة', () {}),
            _buildEmergencyAttachmentOption(Icons.location_on_rounded, 'إحداثيات GPS', () {}),
            _buildEmergencyAttachmentOption(Icons.assignment_rounded, 'تقرير طوارئ', () {}),
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

  Widget _buildEmergencyAttachmentOption(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(text),
      onTap: onTap,
    );
  }

  void _endEmergencyChat(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDarkMode ? widget.darkCardColor : widget.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('إنهاء المحادثة الطارئة'),
          ],
        ),
        content: Text(
          'هل تم حل حالة الطوارئ؟ تأكد من عدم وجود حاجة للمساعدة الفورية قبل إنهاء المحادثة.',
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
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إنهاء المحادثة الطارئة'),
                  backgroundColor: Colors.green,
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

  void _shareLocation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جارٍ مشاركة موقعك مع فريق الدعم...'),
        backgroundColor: widget.primaryColor,
      ),
    );
  }
}
