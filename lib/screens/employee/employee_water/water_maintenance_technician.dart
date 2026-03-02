import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart'; // إضافة هذا السطر

class WaterMaintenanceTechnicianScreen extends StatefulWidget {
  const WaterMaintenanceTechnicianScreen({super.key});

  @override
  _WaterMaintenanceTechnicianScreenState createState() =>
      _WaterMaintenanceTechnicianScreenState();
}

class _WaterMaintenanceTechnicianScreenState
    extends State<WaterMaintenanceTechnicianScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ألوان وزارة الموارد المائية العراقية
  final Color _primaryColor = const Color(0xFF0066CC); // أزرق مياه
  final Color _secondaryColor = const Color(0xFF0099FF); // أزرق فاتح
  final Color _accentColor = const Color(0xFF66CCFF); // أزرق مائي فاتح
  final Color _backgroundColor = const Color(0xFFF0F8FF); // أزرق فاتح جداً
  final Color _cardColor = Colors.white;
  
  // ألوان النصوص
  final Color _textColor = const Color(0xFF003366); // أزرق داكن للنصوص الرئيسية
  final Color _textSecondaryColor = const Color(0xFF424242); // رمادي داكن للنصوص الثانوية
  final Color _textLightColor = const Color(0xFF757575); // رمادي فاتح
  
  final Color _successColor = const Color(0xFF00897B); // أخضر مزرق
  final Color _warningColor = const Color(0xFFFF8C00); // برتقالي
  final Color _errorColor = const Color(0xFFD32F2F); // أحمر

  // ألوان الوضع الداكن
  final Color _darkPrimaryColor = Color(0xFF006699);
  final Color _darkBackgroundColor = Color(0xFF0A1929);
  final Color _darkCardColor = Color(0xFF1E2E3D);
  final Color _darkTextColor = Color(0xFFE3F2FD);
  final Color _darkTextSecondaryColor = Color(0xFF90CAF9);
  final Color _darkTextLightColor = Color(0xFFB0BEC5);

  // متغيرات التحديث - استخدام RefreshController من المكتبة
  late RefreshController _activeTasksRefreshController;
  late RefreshController _delayedTasksRefreshController;
  late RefreshController _completedTasksRefreshController;
  late RefreshController _reportsRefreshController;
  late RefreshController _newReportsRefreshController;

  // متغيرات التقارير
  String _selectedReportType = 'يومي';
  List<DateTime> _selectedDates = [];
  String? _selectedWeek;
  String? _selectedMonth;
  int _currentReportTab = 0;
  final List<String> _reportTypes = ['يومي', 'أسبوعي', 'شهري'];
  final List<String> _weeks = ['الأسبوع الأول', 'الأسبوع الثاني', 'الأسبوع الثالث', 'الأسبوع الرابع'];
  final List<String> _months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];

  // بيانات المهام النشطة (مياه)
  List<Map<String, dynamic>> activeTasks = [
    {
      'id': 'WATER-001',
      'location': 'المنطقة الخضراء، بغداد',
      'type': 'تسرب مياه',
      'priority': 'عالي',
      'estimatedTime': '2 ساعة',
      'status': 'قيد التنفيذ',
      'customerName': 'علي حسين',
      'customerPhone': '07701234567',
      'meterNumber': 'WTR-2024-001',
      'consumption': '15 م³',
      'notes': 'التسرب في الطابق الأرضي',
    },
    {
      'id': 'WATER-002',
      'location': 'حي الجامعة، البصرة',
      'type': 'انسداد شبكة',
      'priority': 'عاجل',
      'estimatedTime': '3 ساعات',
      'status': 'معلقة',
      'customerName': 'سميرة عبدالله',
      'customerPhone': '07807654321',
      'meterNumber': 'WTR-2024-045',
      'consumption': '12 م³',
      'notes': 'يوجد رائحة كريهة - ارتداء معدات السلامة',
    },
    {
      'id': 'WATER-003',
      'location': 'شارع فلسطين، الموصل',
      'type': 'صيانة مضخة',
      'priority': 'متوسط',
      'estimatedTime': '4 ساعات',
      'status': 'قيد التنفيذ',
      'customerName': 'حسن كريم',
      'customerPhone': '07701122334',
      'meterNumber': 'WTR-2024-078',
      'consumption': '20 م³',
      'notes': 'المضخة قديمة وتحتاج لفحص دقيق',
    },
  ];

  // بيانات المهام المكتملة (مياه)
  List<Map<String, dynamic>> completedTasks = [
    {
      'id': 'WATER-004',
      'location': 'حي القادسية، كربلاء',
      'type': 'استبدال عداد',
      'completionDate': DateTime.now().subtract(Duration(days: 1)),
      'duration': '3 ساعات',
      'customerName': 'خالد إبراهيم',
      'cost': '150,000 دينار',
      'customerFeedback': 'خدمة ممتازة، تم إصلاح التسرب بسرعة',
    },
    {
      'id': 'WATER-005',
      'location': 'شارع السعدون، بغداد',
      'type': 'تنظيف خزانات',
      'completionDate': DateTime.now().subtract(Duration(days: 2)),
      'duration': '2 ساعة',
      'customerName': 'سعد محمد',
      'cost': '80,000 دينار',
      'customerFeedback': 'عمل متقن ونظيف، شكراً لكم',
    },
    {
      'id': 'WATER-006',
      'location': 'حي الأندلس، النجف',
      'type': 'إصلاح أنابيب',
      'completionDate': DateTime.now().subtract(Duration(days: 3)),
      'duration': '5 ساعات',
      'customerName': 'مهدي عبدالكريم',
      'cost': '220,000 دينار',
      'customerFeedback': 'تم إصلاح الأنابيب باحترافية',
    },
  ];

  // بيانات المهام المتأخرة (مياه)
  List<Map<String, dynamic>> delayedTasks = [
    {
      'id': 'WATER-007',
      'location': 'حي الصحة، أربيل',
      'type': 'إصلاح شبكة رئيسية',
      'priority': 'عالي',
      'status': 'متأخرة',
      'delayReason': 'انتظار قطع الغيار',
      'customerName': 'محمد حسن',
      'customerPhone': '07709876543',
      'estimatedTime': '5 ساعات',
    },
    {
      'id': 'WATER-008',
      'location': 'حي الثورة، بغداد',
      'type': 'صيانة محطة ضخ',
      'priority': 'عاجل',
      'status': 'متأخرة',
      'delayReason': 'فيضان المياه',
      'customerName': 'علي أحمد',
      'customerPhone': '07801122334',
      'estimatedTime': '6 ساعات',
    },
    {
      'id': 'WATER-009',
      'location': 'حي الأكراد، كركوك',
      'type': 'تركيب عداد جديد',
      'priority': 'متوسط',
      'status': 'متأخرة',
      'delayReason': 'تعطل المعدات',
      'customerName': 'نورس جميل',
      'customerPhone': '07705556677',
      'estimatedTime': '3 ساعات',
    },
  ];

  // بيانات تجريبية للبلاغات الجديدة (خاصة بالمياه)
  List<Map<String, dynamic>> newReports = [
    {
      'id': 'WREP-2024-001',
      'title': 'تسرب مياه رئيسي',
      'location': 'المنطقة الخضراء، بغداد',
      'customerName': 'علي حسين',
      'customerPhone': '07701234567',
      'reportDate': DateTime.now().subtract(Duration(minutes: 30)),
      'priority': 'عاجل',
      'type': 'تسرب رئيسي',
      'status': 'جديد',
      'description': 'تسرب مياه كبير من الشبكة الرئيسية أمام المنزل',
      'affectedArea': 'شارع 42، المنطقة الخضراء',
      'meterNumber': 'WTR-2024-001',
      'images': 3,
      'pressure': 'منخفض جداً',
    },
    {
      'id': 'WREP-2024-002',
      'title': 'انخفاض ضغط المياه',
      'location': 'حي الجامعة، البصرة',
      'customerName': 'سميرة عبدالله',
      'customerPhone': '07807654321',
      'reportDate': DateTime.now().subtract(Duration(hours: 2)),
      'priority': 'متوسط',
      'type': 'انخفاض الضغط',
      'status': 'جديد',
      'description': 'ضعف شديد في ضغط المياه يصل إلى انقطاع في الطوابق العليا',
      'affectedArea': 'مجمع 5، حي الجامعة',
      'meterNumber': 'WTR-2024-045',
      'images': 2,
      'pressure': 'ضعيف',
    },
    {
      'id': 'WREP-2024-003',
      'title': 'انفجار أنبوب مياه',
      'location': 'شارع فلسطين، الموصل',
      'customerName': 'حسن كريم',
      'customerPhone': '07701122334',
      'reportDate': DateTime.now().subtract(Duration(hours: 5)),
      'priority': 'عاجل',
      'type': 'انفجار أنبوب',
      'status': 'قيد المعالجة',
      'description': 'انفجار في الأنبوب الرئيسي للشارع مع تجمع مياه غزير',
      'affectedArea': 'تقاطع فلسطين، الموصل',
      'meterNumber': 'WTR-2024-078',
      'images': 4,
      'pressure': 'مرتفع جداً',
    },
    {
      'id': 'WREP-2024-004',
      'title': 'تلف عداد المياه',
      'location': 'حي القادسية، كربلاء',
      'customerName': 'خالد إبراهيم',
      'customerPhone': '07651234567',
      'reportDate': DateTime.now().subtract(Duration(hours: 8)),
      'priority': 'منخفض',
      'type': 'تلف عداد',
      'status': 'جديد',
      'description': 'العداد لا يعمل ولا يسجل الاستهلاك نهائياً',
      'affectedArea': 'شارع 7، حي القادسية',
      'meterNumber': 'WTR-2024-156',
      'images': 1,
      'pressure': 'غير مؤثر',
    },
    {
      'id': 'WREP-2024-005',
      'title': 'مياه ملوثة',
      'location': 'شارع السعدون، بغداد',
      'customerName': 'سعد محمد',
      'customerPhone': '07705556677',
      'reportDate': DateTime.now().subtract(Duration(hours: 12)),
      'priority': 'عاجل',
      'type': 'تلوث مياه',
      'status': 'قيد المعالجة',
      'description': 'لون ورائحة غير طبيعية للمياه، يشتبه بتلوث',
      'affectedArea': 'مقابل مستشفى السعدون',
      'meterNumber': 'WTR-2024-201',
      'images': 5,
      'pressure': '-',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    
    // تهيئة متغيرات التحديث
    _activeTasksRefreshController = RefreshController();
    _delayedTasksRefreshController = RefreshController();
    _completedTasksRefreshController = RefreshController();
    _reportsRefreshController = RefreshController();
    _newReportsRefreshController = RefreshController();
  }

  @override
  void dispose() {
    _activeTasksRefreshController.dispose();
    _delayedTasksRefreshController.dispose();
    _completedTasksRefreshController.dispose();
    _reportsRefreshController.dispose();
    _newReportsRefreshController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // دوال التحديث لكل شاشة
  Future<void> _refreshActiveTasks() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // محاكاة تحديث البيانات
      activeTasks = activeTasks.map((task) {
        return {...task};
      }).toList();
    });
    _activeTasksRefreshController.refreshCompleted();
  }

  Future<void> _refreshDelayedTasks() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      delayedTasks = delayedTasks.map((task) {
        return {...task};
      }).toList();
    });
    _delayedTasksRefreshController.refreshCompleted();
  }

  Future<void> _refreshCompletedTasks() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      completedTasks = completedTasks.map((task) {
        return {...task};
      }).toList();
    });
    _completedTasksRefreshController.refreshCompleted();
  }

  Future<void> _refreshReports() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // محاكاة تحديث التقارير
    });
    _reportsRefreshController.refreshCompleted();
  }

  Future<void> _refreshNewReports() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      newReports = newReports.map((report) {
        return {...report};
      }).toList();
    });
    _newReportsRefreshController.refreshCompleted();
  }

  Future<void> _loadMoreActiveTasks() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // محاكاة تحميل المزيد من البيانات
    });
    _activeTasksRefreshController.loadComplete();
  }

  Future<void> _loadMoreDelayedTasks() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // محاكاة تحميل المزيد من البيانات
    });
    _delayedTasksRefreshController.loadComplete();
  }

  Future<void> _loadMoreCompletedTasks() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // محاكاة تحميل المزيد من البيانات
    });
    _completedTasksRefreshController.loadComplete();
  }

  Future<void> _loadMoreNewReports() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // محاكاة تحميل المزيد من البيانات
    });
    _newReportsRefreshController.loadComplete();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'لم يتم المعالجة':
        return _errorColor;
      case 'قيد المعالجة':
        return _warningColor;
      case 'مكتمل':
        return _successColor;
      default:
        return _textLightColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'فني صيانة المياه',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          )
        ),
        backgroundColor: isDarkMode ? _darkPrimaryColor : _primaryColor,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
        
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 4,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 10,
            color: Colors.white
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 13,
            color: Colors.white.withOpacity(0.7)
          ),
          tabs: [
            Tab(
              icon: Icon(Icons.engineering, size: 20, color: Colors.white),
              text: 'قيد التنفيذ',
            ),
            Tab(
              icon: Icon(Icons.timer_off, size: 20, color: Colors.white),
              text: 'متأخرة',
            ),
            Tab(
              icon: Icon(Icons.task_alt, size: 20, color: Colors.white),
              text: 'مكتملة',
            ),
            Tab(
              icon: Icon(Icons.assessment, size: 20, color: Colors.white),
              text: 'التقارير',
            ),
            Tab(
              icon: Icon(Icons.notifications_active, size: 20, color: Colors.white),
              text: 'البلاغات',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveTasksView(isDarkMode),
          _buildDelayedTasksView(isDarkMode),
          _buildCompletedTasksView(isDarkMode),
          _buildReportsView(isDarkMode),
          _buildNewReportsView(isDarkMode),
        ],
      ),
      drawer: _buildDrawer(context, isDarkMode),
    );
  }

  // ========== دوال التبويب الخامس - البلاغات الجديدة (خاصة بالمياه) ==========
  Widget _buildNewReportsView(bool isDarkMode) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          // شريط التبويبات الداخلية
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? _darkCardColor : _cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDarkMode ? Colors.white24 : Color(0xFFE0E0E0)),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _primaryColor,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: isDarkMode ? _darkTextColor : _textColor,
              tabs: [
                Tab(text: 'جديد (${newReports.where((r) => r['status'] == 'جديد').length})'),
                Tab(text: 'قيد المعالجة (${newReports.where((r) => r['status'] == 'قيد المعالجة').length})'),
                Tab(text: 'الكل (${newReports.length})'),
              ],
            ),
          ),
          
          // عرض البلاغات حسب التبويب مع التحديث
          Expanded(
            child: TabBarView(
              children: [
                _buildRefreshableReportsList('جديد', isDarkMode),
                _buildRefreshableReportsList('قيد المعالجة', isDarkMode),
                _buildRefreshableAllReportsList(isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshableReportsList(String status, bool isDarkMode) {
    return SmartRefresher(
      controller: _newReportsRefreshController,
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(
        waterDropColor: _primaryColor,
        complete: Icon(Icons.check_rounded, color: _successColor),
        failed: Icon(Icons.error_rounded, color: _errorColor),
      ),
      footer: ClassicFooter(
        loadStyle: LoadStyle.ShowWhenLoading,
        completeDuration: Duration(milliseconds: 300),
        height: 60.0,
        noDataText: 'لا توجد المزيد من البيانات',
        loadingText: 'جاري التحميل...',
        canLoadingText: 'اترك لتحميل المزيد',
        idleText: 'اسحب لتحميل المزيد',
        failedText: 'فشل التحميل! حاول مرة أخرى',
      ),
      onRefresh: _refreshNewReports,
      onLoading: _loadMoreNewReports,
      child: _buildFilteredReportsList(status, isDarkMode),
    );
  }

  Widget _buildRefreshableAllReportsList(bool isDarkMode) {
    return SmartRefresher(
      controller: _newReportsRefreshController,
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(
        waterDropColor: _primaryColor,
        complete: Icon(Icons.check_rounded, color: _successColor),
        failed: Icon(Icons.error_rounded, color: _errorColor),
      ),
      footer: ClassicFooter(
        loadStyle: LoadStyle.ShowWhenLoading,
        completeDuration: Duration(milliseconds: 300),
        height: 60.0,
        noDataText: 'لا توجد المزيد من البيانات',
        loadingText: 'جاري التحميل...',
        canLoadingText: 'اترك لتحميل المزيد',
        idleText: 'اسحب لتحميل المزيد',
        failedText: 'فشل التحميل! حاول مرة أخرى',
      ),
      onRefresh: _refreshNewReports,
      onLoading: _loadMoreNewReports,
      child: _buildAllReportsList(isDarkMode),
    );
  }

  Widget _buildFilteredReportsList(String status, bool isDarkMode) {
    final filteredReports = newReports.where((r) => r['status'] == status).toList();
    
    return filteredReports.isEmpty
        ? _buildEmptyReportsState('لا توجد بلاغات $status', Icons.notifications_off, isDarkMode)
        : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: filteredReports.length,
            itemBuilder: (context, index) {
              return _buildReportCard(filteredReports[index], isDarkMode);
            },
          );
  }

  Widget _buildAllReportsList(bool isDarkMode) {
    return newReports.isEmpty
        ? _buildEmptyReportsState('لا توجد بلاغات', Icons.notifications_off, isDarkMode)
        : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: newReports.length,
            itemBuilder: (context, index) {
              return _buildReportCard(newReports[index], isDarkMode);
            },
          );
  }

  Widget _buildReportCard(Map<String, dynamic> report, bool isDarkMode) {
    Color priorityColor = _getReportPriorityColor(report['priority']);
    String timeAgo = _getTimeAgo(report['reportDate']);
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? _darkCardColor : _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: report['status'] == 'جديد'
              ? _warningColor.withOpacity(0.5)
              : (isDarkMode ? Colors.white24 : Color(0xFFE0E0E0)),
          width: report['status'] == 'جديد' ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // رأس البطاقة
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDarkMode ? Colors.white24 : Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // أيقونة الحالة
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getReportTypeIcon(report['type']).value.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getReportTypeIcon(report['type']).key,
                    color: _getReportTypeIcon(report['type']).value,
                    size: 28,
                  ),
                ),
                SizedBox(width: 12),
                
                // المحتوى الرئيسي
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              report['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDarkMode ? _darkTextColor : _textColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (report['status'] == 'جديد')
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _warningColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'جديد',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        report['location'],
                        style: TextStyle(
                          fontSize: 13,
                          color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          // أولوية البلاغ
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: priorityColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: priorityColor.withOpacity(0.3)),
                            ),
                            child: Text(
                              report['priority'],
                              style: TextStyle(
                                fontSize: 11,
                                color: priorityColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          // الوقت
                          Row(
                            children: [
                              Icon(Icons.access_time_rounded,
                                  size: 14,
                                  color: isDarkMode ? _darkTextLightColor : _textLightColor),
                              SizedBox(width: 4),
                              Text(
                                timeAgo,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDarkMode ? _darkTextLightColor : _textLightColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // تفاصيل إضافية
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // معلومات العميل
                Row(
                  children: [
                    Expanded(
                      child: _buildReportInfoChip(
                        icon: Icons.person_rounded,
                        label: report['customerName'],
                        isDarkMode: isDarkMode,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildReportInfoChip(
                        icon: Icons.phone_rounded,
                        label: report['customerPhone'],
                        isDarkMode: isDarkMode,
                        isPhone: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                
                // معلومات إضافية (مخصصة للمياه)
                Row(
                  children: [
                    Expanded(
                      child: _buildReportInfoChip(
                        icon: Icons.speed_rounded,
                        label: 'الضغط: ${report['pressure']}',
                        isDarkMode: isDarkMode,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildReportInfoChip(
                        icon: Icons.image_rounded,
                        label: '${report['images']} صور',
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  ],
                ),
                if (report['meterNumber'] != '-') ...[
                  SizedBox(height: 8),
                  _buildReportInfoChip(
                    icon: Icons.confirmation_number_rounded,
                    label: 'رقم العداد: ${report['meterNumber']}',
                    isDarkMode: isDarkMode,
                    fullWidth: true,
                  ),
                ],
                
                SizedBox(height: 12),
                
                // أزرار الإجراءات
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showReportDetails(report, isDarkMode),
                        icon: Icon(Icons.visibility_rounded, size: 18),
                        label: Text('عرض التفاصيل'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _acceptReport(report, isDarkMode),
                        icon: Icon(Icons.check_circle_rounded, size: 18),
                        label: Text('قبول البلاغ'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _successColor,
                          side: BorderSide(color: _successColor),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
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

  Widget _buildReportInfoChip({
    required IconData icon,
    required String label,
    required bool isDarkMode,
    bool isPhone = false,
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? _darkBackgroundColor : _backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isDarkMode ? Colors.white24 : Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isPhone ? _successColor : (isDarkMode ? _darkTextColor : _textColor),
          ),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isPhone
                    ? _successColor
                    : (isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDetails(Map<String, dynamic> report, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? _darkCardColor : _cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // العنوان
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.report_rounded, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'تفاصيل البلاغ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              // المحتوى
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('رقم البلاغ:', report['id'], isDarkMode),
                      _buildDetailRow('العنوان:', report['title'], isDarkMode),
                      _buildDetailRow('الموقع:', report['location'], isDarkMode),
                      _buildDetailRow('المنطقة المتأثرة:', report['affectedArea'], isDarkMode),
                      _buildDetailRow('اسم العميل:', report['customerName'], isDarkMode),
                      _buildDetailRow('رقم الهاتف:', report['customerPhone'], isDarkMode),
                      _buildDetailRow('رقم العداد:', report['meterNumber'], isDarkMode),
                      _buildDetailRow('الضغط:', report['pressure'], isDarkMode),
                      _buildDetailRow('الأولوية:', report['priority'], isDarkMode),
                      _buildDetailRow('الحالة:', report['status'], isDarkMode),
                      _buildDetailRow('عدد الصور:', '${report['images']} صور', isDarkMode),
                      _buildDetailRow('تاريخ البلاغ:', DateFormat('yyyy-MM-dd HH:mm').format(report['reportDate']), isDarkMode),
                      SizedBox(height: 16),
                      Text(
                        'وصف البلاغ:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDarkMode ? _darkBackgroundColor : _backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isDarkMode ? Colors.white24 : Color(0xFFE0E0E0)),
                        ),
                        child: Text(
                          report['description'],
                          style: TextStyle(
                            color: isDarkMode ? _darkTextColor : _textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // الأزرار
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: isDarkMode ? Colors.white24 : Color(0xFFE0E0E0),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('إغلاق'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _acceptReport(report, isDarkMode);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _successColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('قبول البلاغ'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _acceptReport(Map<String, dynamic> report, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? _darkCardColor : _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: _successColor),
            SizedBox(width: 8),
            Text(
              'قبول البلاغ',
              style: TextStyle(
                color: isDarkMode ? _darkTextColor : _textColor,
              ),
            ),
          ],
        ),
        content: Text(
          'هل أنت متأكد من قبول البلاغ رقم ${report['id']}؟',
          style: TextStyle(
            color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _successColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                report['status'] = 'قيد المعالجة';
              });
              _showSuccessSnackbar('تم قبول البلاغ بنجاح');
            },
            child: Text('قبول'),
          ),
        ],
      ),
    );
  }

  Color _getReportPriorityColor(String priority) {
    switch (priority) {
      case 'عاجل':
        return _errorColor;
      case 'متوسط':
        return _warningColor;
      case 'منخفض':
        return _successColor;
      default:
        return _accentColor;
    }
  }

  MapEntry<IconData, Color> _getReportTypeIcon(String type) {
    switch (type) {
      case 'تسرب رئيسي':
        return MapEntry(Icons.water_drop_rounded, _errorColor);
      case 'انخفاض الضغط':
        return MapEntry(Icons.speed_rounded, _warningColor);
      case 'انفجار أنبوب':
        return MapEntry(Icons.science_rounded, Colors.orange);
      case 'تلف عداد':
        return MapEntry(Icons.confirmation_number_rounded, _accentColor);
      case 'تلوث مياه':
        return MapEntry(Icons.warning_rounded, Colors.red);
      default:
        return MapEntry(Icons.report_rounded, _primaryColor);
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }

  Widget _buildEmptyReportsState(String message, IconData icon, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: isDarkMode ? _darkCardColor : _backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 60,
              color: isDarkMode ? _darkTextLightColor : _textLightColor,
            ),
          ),
          SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? _darkTextColor : _textColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'سيتم إشعارك عند وصول بلاغات جديدة',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // ========== دوال التبويب الأول - المهام النشطة مع التحديث ==========
  Widget _buildActiveTasksView(bool isDarkMode) {
    final activeTasksList = activeTasks.where((task) => task['status'] != 'مكتملة').toList();
    
    return Container(
      color: isDarkMode ? _darkBackgroundColor : _backgroundColor,
      child: activeTasksList.isEmpty
          ? _buildEmptyState('لا توجد مهام قيد التنفيذ', Icons.engineering, isDarkMode)
          : SmartRefresher(
              controller: _activeTasksRefreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(
                waterDropColor: _primaryColor,
                complete: Icon(Icons.check_rounded, color: _successColor),
                failed: Icon(Icons.error_rounded, color: _errorColor),
              ),
              footer: ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
                completeDuration: Duration(milliseconds: 300),
                height: 60.0,
                noDataText: 'لا توجد المزيد من البيانات',
                loadingText: 'جاري التحميل...',
                canLoadingText: 'اترك لتحميل المزيد',
                idleText: 'اسحب لتحميل المزيد',
                failedText: 'فشل التحميل! حاول مرة أخرى',
              ),
              onRefresh: _refreshActiveTasks,
              onLoading: _loadMoreActiveTasks,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  _buildTechnicianInfoCard(isDarkMode),
                  SizedBox(height: 20),
                  ...activeTasksList.map((task) => _buildActiveTaskCard(task, isDarkMode)).toList(),
                ],
              ),
            ),
    );
  }

  Widget _buildDelayedTasksView(bool isDarkMode) {
    return Container(
      color: isDarkMode ? _darkBackgroundColor : _backgroundColor,
      child: delayedTasks.isEmpty
          ? _buildEmptyState('لا توجد مهام متأخرة', Icons.timer_off, isDarkMode)
          : SmartRefresher(
              controller: _delayedTasksRefreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(
                waterDropColor: _warningColor,
                complete: Icon(Icons.check_rounded, color: _successColor),
                failed: Icon(Icons.error_rounded, color: _errorColor),
              ),
              footer: ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
                completeDuration: Duration(milliseconds: 300),
                height: 60.0,
                noDataText: 'لا توجد المزيد من البيانات',
                loadingText: 'جاري التحميل...',
                canLoadingText: 'اترك لتحميل المزيد',
                idleText: 'اسحب لتحميل المزيد',
                failedText: 'فشل التحميل! حاول مرة أخرى',
              ),
              onRefresh: _refreshDelayedTasks,
              onLoading: _loadMoreDelayedTasks,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  _buildDelayedTasksHeader(isDarkMode),
                  SizedBox(height: 20),
                  ...delayedTasks.map((task) => _buildDelayedTaskCard(task, isDarkMode)).toList(),
                ],
              ),
            ),
    );
  }

  Widget _buildCompletedTasksView(bool isDarkMode) {
    return Container(
      color: isDarkMode ? _darkBackgroundColor : _backgroundColor,
      child: completedTasks.isEmpty
          ? _buildEmptyState('لا توجد مهام مكتملة', Icons.task_alt, isDarkMode)
          : SmartRefresher(
              controller: _completedTasksRefreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(
                waterDropColor: _successColor,
                complete: Icon(Icons.check_rounded, color: _successColor),
                failed: Icon(Icons.error_rounded, color: _errorColor),
              ),
              footer: ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
                completeDuration: Duration(milliseconds: 300),
                height: 60.0,
                noDataText: 'لا توجد المزيد من البيانات',
                loadingText: 'جاري التحميل...',
                canLoadingText: 'اترك لتحميل المزيد',
                idleText: 'اسحب لتحميل المزيد',
                failedText: 'فشل التحميل! حاول مرة أخرى',
              ),
              onRefresh: _refreshCompletedTasks,
              onLoading: _loadMoreCompletedTasks,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  _buildCompletedTasksHeader(isDarkMode),
                  SizedBox(height: 20),
                  ...completedTasks.map((task) => _buildCompletedTaskCard(task, isDarkMode)).toList(),
                ],
              ),
            ),
    );
  }

  Widget _buildReportsView(bool isDarkMode) {
    return SmartRefresher(
      controller: _reportsRefreshController,
      enablePullDown: true,
      enablePullUp: false,
      header: WaterDropHeader(
        waterDropColor: _primaryColor,
        complete: Icon(Icons.check_rounded, color: _successColor),
        failed: Icon(Icons.error_rounded, color: _errorColor),
      ),
      onRefresh: _refreshReports,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان الرئيسي
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
                  'نظام تقارير صيانة المياه',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // تبويبات داخلية (إنشاء التقارير / التقارير الواردة)
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: isDarkMode ? _darkCardColor : _cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDarkMode ? _darkTextLightColor : _textLightColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMaintenanceReportInnerTabButton('إنشاء التقارير', 0, isDarkMode),
                  ),
                  Expanded(
                    child: _buildMaintenanceReportInnerTabButton('التقارير الواردة', 1, isDarkMode),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // عرض المحتوى حسب التبويب المختار
            _currentReportTab == 0 
                ? _buildCreateMaintenanceReportSection(isDarkMode)
                : _buildReceivedMaintenanceReportsSection(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceReportInnerTabButton(String title, int tabIndex, bool isDarkMode) {
    bool isSelected = _currentReportTab == tabIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentReportTab = tabIndex;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _primaryColor : Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : (isDarkMode ? _darkTextColor : _textColor),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // قسم إنشاء التقارير للصيانة
  Widget _buildCreateMaintenanceReportSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إنشاء تقرير صيانة جديد',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? _darkTextColor : _textColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildReportTypeFilter(isDarkMode),
        const SizedBox(height: 20),
        _buildReportOptions(isDarkMode),
        const SizedBox(height: 20),
        _buildGenerateReportButton(isDarkMode),
        const SizedBox(height: 20),
        
        // إضافة إحصائيات سريعة للصيانة
        _buildMaintenanceQuickStats(isDarkMode),
      ],
    );
  }

  // قسم التقارير الواردة للصيانة
  Widget _buildReceivedMaintenanceReportsSection(bool isDarkMode) {
    // بيانات تجريبية للتقارير الواردة الخاصة بالصيانة
    final List<Map<String, dynamic>> maintenanceReceivedReports = [
      {
        'id': 'MREP-2024-001',
        'title': 'تقرير صيانة أسبوعي للمنطقة الشمالية',
        'sender': 'مشرف الصيانة - بغداد',
        'date': DateTime.now().subtract(Duration(days: 2)),
        'type': 'أسبوعي',
        'size': '1.2 MB',
        'status': 'مستلم',
        'fileType': 'PDF',
        'technicianName': 'مهدي العبادي',
        'completedTasks': 15,
        'pendingTasks': 3,
      },
      {
        'id': 'MREP-2024-002',
        'title': 'تقرير المهام المتأخرة - مارس 2024',
        'sender': 'مدير قسم الصيانة',
        'date': DateTime.now().subtract(Duration(days: 5)),
        'type': 'شهري',
        'size': '850 KB',
        'status': 'مستلم',
        'fileType': 'PDF',
        'technicianName': 'مهدي العبادي',
        'delayedTasks': 8,
        'reason': 'انتظار قطع الغيار',
      },
      {
        'id': 'MREP-2024-003',
        'title': 'تقرير الأداء اليومي',
        'sender': 'فريق الصيانة المركزية',
        'date': DateTime.now().subtract(Duration(days: 1)),
        'type': 'يومي',
        'size': '480 KB',
        'status': 'غير مقروء',
        'fileType': 'Excel',
        'technicianName': 'مهدي العبادي',
        'completedToday': 7,
        'avgCompletionTime': '2.3 ساعة',
      },
      {
        'id': 'MREP-2024-004',
        'title': 'تقرير رضا العملاء عن خدمات الصيانة',
        'sender': 'شؤون العملاء',
        'date': DateTime.now().subtract(Duration(days: 7)),
        'type': 'شهري',
        'size': '1.8 MB',
        'status': 'مستلم',
        'fileType': 'PDF',
        'technicianName': 'مهدي العبادي',
        'customerRating': 4.7,
        'totalFeedbacks': 42,
      },
      {
        'id': 'MREP-2024-005',
        'title': 'تقرير استهلاك قطع الغيار',
        'sender': 'مستودع الصيانة',
        'date': DateTime.now().subtract(Duration(days: 10)),
        'type': 'شهري',
        'size': '920 KB',
        'status': 'مستلم',
        'fileType': 'PDF',
        'technicianName': 'مهدي العبادي',
        'sparePartsUsed': 23,
        'totalCost': '1,450,000 دينار',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التقارير المستلمة - الصيانة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? _darkTextColor : _textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'عرض وإدارة جميع التقارير التي تم استلامها في قسم صيانة المياه',
          style: TextStyle(
            color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
          ),
        ),
        const SizedBox(height: 20),
        
        // إحصائيات سريعة للصيانة
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? _darkBackgroundColor : _backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDarkMode ? _darkTextLightColor : _textLightColor.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    maintenanceReceivedReports.length.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                  Text(
                    'إجمالي التقارير',
                    style: TextStyle(
                      color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    maintenanceReceivedReports.where((r) => r['status'] == 'غير مقروء').length.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _warningColor,
                    ),
                  ),
                  Text(
                    'غير مقروء',
                    style: TextStyle(
                      color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '${_calculateMaintenanceTotalSize(maintenanceReceivedReports)} MB',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _successColor,
                    ),
                  ),
                  Text(
                    'الحجم الإجمالي',
                    style: TextStyle(
                      color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // قائمة التقارير الخاصة بالصيانة
        ...maintenanceReceivedReports.map((report) => _buildMaintenanceReceivedReportCard(report, isDarkMode)),
      ],
    );
  }

  // بناء بطاقة تقرير واردة للصيانة
  Widget _buildMaintenanceReceivedReportCard(Map<String, dynamic> report, bool isDarkMode) {
    bool isUnread = report['status'] == 'غير مقروء';
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? _darkCardColor : _cardColor,
        border: Border.all(color: isDarkMode ? _darkTextLightColor : _textLightColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getMaintenanceReportColor(report['fileType']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getMaintenanceReportIcon(report['fileType']),
            color: _getMaintenanceReportColor(report['fileType']),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                report['title'],
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: isDarkMode ? _darkTextColor : _textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isUnread)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _warningColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              'من: ${report['sender']}',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
              ),
            ),
            SizedBox(height: 2),
            Text(
              '${DateFormat('yyyy-MM-dd').format(report['date'])} • ${report['type']} • ${report['size']}',
              style: TextStyle(
                fontSize: 10,
                color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded, color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor),
          onSelected: (value) {
            _handleMaintenanceReportAction(value, report);
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility_rounded, size: 18, color: _primaryColor),
                  SizedBox(width: 8),
                  Text('عرض التقرير'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'download',
              child: Row(
                children: [
                  Icon(Icons.download_rounded, size: 18, color: _successColor),
                  SizedBox(width: 8),
                  Text('تحميل'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'share',
              child: Row(
                children: [
                  Icon(Icons.share_rounded, size: 18, color: _secondaryColor),
                  SizedBox(width: 8),
                  Text('مشاركة'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_rounded, size: 18, color: _errorColor),
                  SizedBox(width: 8),
                  Text('حذف'),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          _viewMaintenanceReceivedReport(report, isDarkMode);
        },
      ),
    );
  }

  // إحصائيات سريعة للصيانة
  Widget _buildMaintenanceQuickStats(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? _darkBackgroundColor : _backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDarkMode ? _darkTextLightColor : _textLightColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إحصائيات سريعة - الصيانة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMaintenanceQuickStatItem('تقارير هذا الشهر', '6', Icons.calendar_today_rounded, _primaryColor),
              _buildMaintenanceQuickStatItem('تقارير معلقة', '1', Icons.pending_rounded, _warningColor),
              _buildMaintenanceQuickStatItem('مقاسمة هذا الشهر', '3', Icons.share_rounded, _successColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceQuickStatItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: _textSecondaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // دوال مساعدة للتقارير الواردة للصيانة
  Color _getMaintenanceReportColor(String fileType) {
    switch (fileType) {
      case 'PDF':
        return _errorColor;
      case 'Excel':
        return _successColor;
      case 'Word':
        return _primaryColor;
      default:
        return _accentColor;
    }
  }

  IconData _getMaintenanceReportIcon(String fileType) {
    switch (fileType) {
      case 'PDF':
        return Icons.picture_as_pdf_rounded;
      case 'Excel':
        return Icons.table_chart_rounded;
      case 'Word':
        return Icons.description_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  String _calculateMaintenanceTotalSize(List<Map<String, dynamic>> reports) {
    double total = 0;
    for (var report in reports) {
      String sizeStr = report['size'];
      if (sizeStr.contains('MB')) {
        total += double.parse(sizeStr.replaceAll(' MB', ''));
      } else if (sizeStr.contains('KB')) {
        total += double.parse(sizeStr.replaceAll(' KB', '')) / 1024;
      }
    }
    return total.toStringAsFixed(1);
  }

  void _handleMaintenanceReportAction(String action, Map<String, dynamic> report) {
    switch (action) {
      case 'view':
        _viewMaintenanceReceivedReport(report, Provider.of<ThemeProvider>(context, listen: false).isDarkMode);
        break;
      case 'download':
        _downloadMaintenanceReport(report);
        break;
      case 'share':
        _shareMaintenanceReport(report);
        break;
      case 'delete':
        _deleteMaintenanceReport(report);
        break;
    }
  }

  void _viewMaintenanceReceivedReport(Map<String, dynamic> report, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? _darkCardColor : _cardColor,
        title: Row(
          children: [
            Icon(_getMaintenanceReportIcon(report['fileType']), color: _getMaintenanceReportColor(report['fileType'])),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                report['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? _darkTextColor : _textColor,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMaintenanceReportDetailRow('المرسل:', report['sender'], isDarkMode),
              _buildMaintenanceReportDetailRow('الفني:', report['technicianName'], isDarkMode),
              _buildMaintenanceReportDetailRow('النوع:', report['type'], isDarkMode),
              _buildMaintenanceReportDetailRow('الحجم:', report['size'], isDarkMode),
              _buildMaintenanceReportDetailRow('صيغة الملف:', report['fileType'], isDarkMode),
              _buildMaintenanceReportDetailRow('التاريخ:', DateFormat('yyyy-MM-dd HH:mm').format(report['date']), isDarkMode),
              _buildMaintenanceReportDetailRow('الحالة:', report['status'], isDarkMode),
              
              if (report['completedTasks'] != null)
                _buildMaintenanceReportDetailRow('المهام المكتملة:', '${report['completedTasks']}', isDarkMode),
              
              if (report['pendingTasks'] != null)
                _buildMaintenanceReportDetailRow('المهام المعلقة:', '${report['pendingTasks']}', isDarkMode),
              
              if (report['delayedTasks'] != null)
                _buildMaintenanceReportDetailRow('المهام المتأخرة:', '${report['delayedTasks']}', isDarkMode),
              
              if (report['reason'] != null)
                _buildMaintenanceReportDetailRow('سبب التأخير:', report['reason'], isDarkMode),
              
              if (report['customerRating'] != null)
                _buildMaintenanceReportDetailRow('تقييم العملاء:', '${report['customerRating']}/5', isDarkMode),
              
              if (report['sparePartsUsed'] != null)
                _buildMaintenanceReportDetailRow('قطع الغيار المستخدمة:', '${report['sparePartsUsed']}', isDarkMode),
              
              SizedBox(height: 16),
              Text(
                'ملخص التقرير:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'هذا التقرير يحتوي على تفاصيل أداء الصيانة والمهام المنجزة خلال الفترة المحددة. '
                'يشمل إحصائيات المهام المكتملة والمعلقة والمتأخرة، بالإضافة إلى رضا العملاء واستهلاك قطع الغيار.',
                style: TextStyle(
                  color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () => _downloadMaintenanceReport(report),
            child: Text('تحميل'),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceReportDetailRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: isDarkMode ? _darkTextColor : _textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _downloadMaintenanceReport(Map<String, dynamic> report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تحميل: ${report['title']}'),
        backgroundColor: _successColor,
      ),
    );
  }

  void _shareMaintenanceReport(Map<String, dynamic> report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('مشاركة: ${report['title']}'),
        backgroundColor: _primaryColor,
      ),
    );
  }

  void _deleteMaintenanceReport(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Provider.of<ThemeProvider>(context, listen: false).isDarkMode ? _darkCardColor : _cardColor,
        title: Row(
          children: [
            Icon(Icons.delete_rounded, color: _errorColor),
            SizedBox(width: 8),
            Text('حذف التقرير'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من حذف تقرير "${report['title']}"؟',
          style: TextStyle(
            color: Provider.of<ThemeProvider>(context, listen: false).isDarkMode ? _darkTextColor : _textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _errorColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم حذف التقرير: ${report['title']}'),
                  backgroundColor: _errorColor,
                ),
              );
            },
            child: Text('حذف'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTypeFilter(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? _darkCardColor : _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode ? _darkTextLightColor : _textLightColor.withOpacity(0.3)),
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
                color: isDarkMode ? _darkTextColor : _textColor,
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
                        color: isSelected ? _primaryColor : (isDarkMode ? _darkTextColor : _textColor),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: isSelected ? _primaryColor : (isDarkMode ? _darkTextLightColor : _textLightColor.withOpacity(0.3))),
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
        color: isDarkMode ? _darkCardColor : _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode ? _darkTextLightColor : _textLightColor.withOpacity(0.3)),
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
              'خيارات التقرير',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? _darkTextColor : _textColor,
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedReportType == 'يومي') _buildDailyOptions(isDarkMode),
            if (_selectedReportType == 'أسبوعي') _buildWeeklyOptions(isDarkMode),
            if (_selectedReportType == 'شهري') _buildMonthlyOptions(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyOptions(bool isDarkMode) {
    return Column(
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
                    color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? _darkBackgroundColor : _backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDarkMode ? _darkTextLightColor : _textLightColor.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Icon(Icons.calendar_today_outlined, color: isDarkMode ? _darkTextLightColor : _textLightColor, size: 48),
                SizedBox(height: 12),
                Text(
                  'لم يتم اختيار أي تواريخ',
                  style: TextStyle(
                    color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'انقر على الزر أعلاه لفتح التقويم\nواختيار التواريخ المطلوبة للتقرير',
                  style: TextStyle(
                    color: isDarkMode ? _darkTextLightColor : _textLightColor,
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

  Widget _buildWeeklyOptions(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر الأسبوع',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? _darkTextColor : _textColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _weeks.map((week) {
            final isSelected = _selectedWeek == week;
            return FilterChip(
              label: Text(week),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedWeek = selected ? week : null;
                });
              },
              selectedColor: _primaryColor.withOpacity(0.2),
              checkmarkColor: _primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? _primaryColor : (isDarkMode ? _darkTextColor : _textColor),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : (isDarkMode ? _darkTextLightColor : _textLightColor.withOpacity(0.3))),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMonthlyOptions(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر الشهر',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? _darkTextColor : _textColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _months.map((month) {
            final isSelected = _selectedMonth == month;
            return FilterChip(
              label: Text(month),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedMonth = selected ? month : null;
                });
              },
              selectedColor: _primaryColor.withOpacity(0.2),
              checkmarkColor: _primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? _primaryColor : (isDarkMode ? _darkTextColor : _textColor),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : (isDarkMode ? _darkTextLightColor : _textLightColor.withOpacity(0.3))),
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
        onPressed: isFormValid ? () => _generateMaintenanceReport(isDarkMode) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid ? _primaryColor : (isDarkMode ? _darkTextLightColor : _textLightColor),
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

  void _showMultiDatePicker() {
    List<DateTime> tempSelectedDates = List.from(_selectedDates);
    
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final bool isDarkMode = themeProvider.isDarkMode;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            DateTime focusedDay = DateTime.now();
            
            return Dialog(
              backgroundColor: isDarkMode ? _darkCardColor : _cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // العنوان
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
                              // التقويم
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: isDarkMode ? _darkTextLightColor : _textLightColor.withOpacity(0.3)),
                                ),
                                child: TableCalendar(
                                  firstDay: DateTime.utc(2020, 1, 1),
                                  lastDay: DateTime.utc(2030, 12, 31),
                                  focusedDay: focusedDay,
                                  
                                  selectedDayPredicate: (day) {
                                    return tempSelectedDates.any((selectedDate) {
                                      return _isSameDay(selectedDate, day);
                                    });
                                  },
                                  
                                  onDaySelected: (selectedDay, focused) {
                                    setStateDialog(() {
                                      focusedDay = focused;
                                      
                                      if (tempSelectedDates.any((date) => _isSameDay(date, selectedDay))) {
                                        tempSelectedDates.removeWhere((date) => _isSameDay(date, selectedDay));
                                      } else {
                                        tempSelectedDates.add(DateTime(selectedDay.year, selectedDay.month, selectedDay.day));
                                      }
                                      
                                      tempSelectedDates.sort((a, b) => a.compareTo(b));
                                    });
                                  },
                                  
                                  calendarStyle: CalendarStyle(
                                    defaultDecoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    
                                    todayDecoration: BoxDecoration(
                                      color: _accentColor.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    
                                    selectedDecoration: BoxDecoration(
                                      color: _primaryColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    
                                    outsideDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    
                                    defaultTextStyle: TextStyle(
                                      color: isDarkMode ? _darkTextColor : _textColor,
                                    ),
                                    todayTextStyle: TextStyle(
                                      color: isDarkMode ? _darkTextColor : _textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    selectedTextStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    outsideTextStyle: TextStyle(
                                      color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                                    ),
                                    disabledTextStyle: TextStyle(
                                      color: isDarkMode ? _darkTextLightColor : _textLightColor,
                                    ),
                                    
                                    markerDecoration: BoxDecoration(
                                      color: _secondaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    
                                    weekendDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    
                                    holidayDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    
                                    withinRangeDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
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
                                      color: isDarkMode ? _darkTextColor : _textColor,
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
                              
                              // قسم التواريخ المختارة
                              if (tempSelectedDates.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isDarkMode ? _darkBackgroundColor : _backgroundColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: isDarkMode ? _darkTextLightColor : _textLightColor.withOpacity(0.3)),
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
                                      
                                      // عرض التواريخ
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
                                              setStateDialog(() {
                                                tempSelectedDates.remove(date);
                                              });
                                            },
                                          );
                                        }).toList(),
                                      ),
                                      
                                      SizedBox(height: 12),
                                      
                                      // نطاق التواريخ
                                      if (tempSelectedDates.length > 1)
                                        Text(
                                          'من ${DateFormat('yyyy-MM-dd').format(tempSelectedDates.first)} '
                                          'إلى ${DateFormat('yyyy-MM-dd').format(tempSelectedDates.last)} '
                                          '(${tempSelectedDates.length} يوم)',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              
                              // رسالة عند عدم اختيار تواريخ
                              if (tempSelectedDates.isEmpty)
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isDarkMode ? _darkBackgroundColor : _backgroundColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: isDarkMode ? _darkTextLightColor : _textLightColor.withOpacity(0.3)),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.touch_app_rounded, 
                                           size: 40, 
                                           color: isDarkMode ? _darkTextLightColor : _textLightColor),
                                      SizedBox(height: 12),
                                      Text(
                                        'انقر على الأيام في التقويم',
                                        style: TextStyle(
                                          color: isDarkMode ? _darkTextColor : _textColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'اختر الأيام المطلوبة للتقرير',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: isDarkMode ? _darkTextLightColor : _textLightColor,
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
                    
                    // الأزرار
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: isDarkMode ? _darkTextLightColor : _textLightColor.withOpacity(0.3))),
                        color: isDarkMode ? _darkCardColor : _cardColor,
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
      },
    );
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _generateMaintenanceReport(bool isDarkMode) {
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
    _showGeneratedMaintenanceReport(reportPeriod, isDarkMode);
  }

  void _showGeneratedMaintenanceReport(String period, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? _darkCardColor : _cardColor,
        title: Text('تقرير أداء صيانة المياه - $period', 
            style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('نوع التقرير: $_selectedReportType', 
                  style: TextStyle(color: isDarkMode ? _darkTextColor : _textColor)),
              if (_selectedReportType == 'يومي' && _selectedDates.isNotEmpty)
                Text('عدد الأيام: ${_selectedDates.length}', 
                    style: TextStyle(color: isDarkMode ? _darkTextColor : _textColor)),
              if (_selectedWeek != null)
                Text('الأسبوع: $_selectedWeek', 
                    style: TextStyle(color: isDarkMode ? _darkTextColor : _textColor)),
              if (_selectedMonth != null)
                Text('الشهر: $_selectedMonth', 
                    style: TextStyle(color: isDarkMode ? _darkTextColor : _textColor)),
              const SizedBox(height: 16),
              Text('ملخص التقرير:', 
                  style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
              Text('- إجمالي المهام: 42', 
                  style: TextStyle(color: isDarkMode ? _darkTextColor : _textColor)),
              Text('- المهام المكتملة: 35', 
                  style: TextStyle(color: isDarkMode ? _darkTextColor : _textColor)),
              Text('- معدل الإنجاز: 83.3%', 
                  style: TextStyle(color: isDarkMode ? _darkTextColor : _textColor)),
              Text('- متوسط وقت الإنجاز: 2.5 ساعة', 
                  style: TextStyle(color: isDarkMode ? _darkTextColor : _textColor)),
              Text('- رضا العملاء: 4.7/5', 
                  style: TextStyle(color: isDarkMode ? _darkTextColor : _textColor)),
              Text('- كمية المياه المحفوظة: 1,200 م³', 
                  style: TextStyle(color: isDarkMode ? _darkTextColor : _textColor)),
              Text('- التكلفة الإجمالية: 5,800,000 دينار', 
                  style: TextStyle(color: isDarkMode ? _darkTextColor : _textColor)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: _textSecondaryColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackbar('تم تصدير التقرير بنجاح');
            },
            child: const Text('تصدير PDF'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: isDarkMode ? _darkTextLightColor : _textLightColor,
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicianInfoCard(bool isDarkMode) {
    return Card(
      elevation: 3,
      color: isDarkMode ? _darkCardColor : _cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: _primaryColor.withOpacity(0.2),
              child: Icon(Icons.plumbing, color: _primaryColor, size: 30),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('مهدي العبادي', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 18,
                        color: isDarkMode ? _darkTextColor : _textColor
                      )),
                  SizedBox(height: 4),
                  Text('فني صيانة مياه',
                      style: TextStyle(
                        color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor
                      )),
                  SizedBox(height: 4),
                  Text('المهام النشطة: ${activeTasks.length} | المكتملة: ${completedTasks.length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? _darkTextLightColor : _textLightColor
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDelayedTasksHeader(bool isDarkMode) {
    return Card(
      elevation: 3,
      color: _warningColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.warning, color: _warningColor, size: 30),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('المهام المتأخرة', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 18,
                        color: _warningColor
                      )),
                  Text('إجمالي المهام المتأخرة: ${delayedTasks.length}',
                      style: TextStyle(
                        color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedTasksHeader(bool isDarkMode) {
    return Card(
      elevation: 3,
      color: _successColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: _successColor, size: 30),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('المهام المكتملة', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 18,
                        color: _successColor
                      )),
                  Text('إجمالي المهام المكتملة: ${completedTasks.length}',
                      style: TextStyle(
                        color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTaskCard(Map<String, dynamic> task, bool isDarkMode) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: isDarkMode ? _darkCardColor : _cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Icon(Icons.water_damage, color: _primaryColor),
        title: Text(task['type'], 
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? _darkTextColor : _textColor
            )),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task['location'],
                style: TextStyle(
                  color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor
                )),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.schedule, size: 14, color: _primaryColor),
                SizedBox(width: 4),
                Text('${task['estimatedTime']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? _darkTextLightColor : _textLightColor
                    )),
              ],
            ),
          ],
        ),
        trailing: Chip(
          label: Text(task['status'], style: TextStyle(color: Colors.white, fontSize: 12)),
          backgroundColor: _getStatusColor(task['status']),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildDetailRow('العميل:', task['customerName'], isDarkMode),
                _buildDetailRow('الهاتف:', task['customerPhone'], isDarkMode),
                _buildDetailRow('رقم العداد:', task['meterNumber'], isDarkMode),
                _buildDetailRow('الاستهلاك:', task['consumption'], isDarkMode),
                _buildDetailRow('الوقت المقدر:', task['estimatedTime'], isDarkMode),
                if (task['notes'] != null)
                  _buildDetailRow('ملاحظات:', task['notes'], isDarkMode),
                SizedBox(height: 16),
                
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _updateTaskStatus(task, 'قيد التنفيذ'),
                      icon: Icon(Icons.play_arrow),
                      label: Text('بدء العمل'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _successColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _updateTaskStatus(task, 'مؤجلة'),
                      icon: Icon(Icons.schedule),
                      label: Text('تأجيل'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _warningColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _updateTaskStatus(task, 'مكتملة'),
                      icon: Icon(Icons.check_circle),
                      label: Text('إنهاء'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _openMap(task['location']),
                  icon: Icon(Icons.map),
                  label: Text('التوجيه إلى الموقع'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _secondaryColor,
                    minimumSize: Size(double.infinity, 40),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDelayedTaskCard(Map<String, dynamic> task, bool isDarkMode) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: isDarkMode ? _darkCardColor : _cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.warning, color: _errorColor),
        title: Text(task['type'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? _darkTextColor : _textColor
            )),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task['location'],
                style: TextStyle(
                  color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor
                )),
            SizedBox(height: 4),
            Text('سبب التأخير: ${task['delayReason']}',
                style: TextStyle(
                  fontSize: 12,
                  color: _errorColor,
                  fontWeight: FontWeight.bold
                )),
          ],
        ),
        trailing: Chip(
          label: Text('متأخرة', style: TextStyle(color: Colors.white, fontSize: 12)),
          backgroundColor: _errorColor,
        ),
        onTap: () => _showTaskDetails(task, isDarkMode),
      ),
    );
  }

  Widget _buildCompletedTaskCard(Map<String, dynamic> task, bool isDarkMode) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: isDarkMode ? _darkCardColor : _cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.check_circle, color: _successColor),
        title: Text(task['type'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? _darkTextColor : _textColor
            )),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('العميل: ${task['customerName']}',
                style: TextStyle(
                  color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor
                )),
            SizedBox(height: 4),
            Text('التكلفة: ${task['cost']}',
                style: TextStyle(
                  fontSize: 12,
                  color: _successColor,
                  fontWeight: FontWeight.bold
                )),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // تم حذف RatingBar.builder هنا
            Text('مكتملة', 
                style: TextStyle(
                  fontSize: 10,
                  color: _successColor,
                  fontWeight: FontWeight.bold
                )),
          ],
        ),
        onTap: () => _showCompletedTaskDetails(task, isDarkMode),
      ),
    );
  }

  void _showTaskDetails(Map<String, dynamic> task, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? _darkCardColor : _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.info, color: _primaryColor),
            SizedBox(width: 8),
            Text('تفاصيل المهمة',
                style: TextStyle(
                  color: isDarkMode ? _darkTextColor : _textColor
                )),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('نوع المهمة:', task['type'], isDarkMode),
              _buildDetailRow('الموقع:', task['location'], isDarkMode),
              _buildDetailRow('العميل:', task['customerName'], isDarkMode),
              _buildDetailRow('الهاتف:', task['customerPhone'], isDarkMode),
              if (task['estimatedTime'] != null)
                _buildDetailRow('الوقت المقدر:', task['estimatedTime'], isDarkMode),
              if (task['delayReason'] != null)
                _buildDetailRow('سبب التأخير:', task['delayReason'], isDarkMode),
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

  void _showCompletedTaskDetails(Map<String, dynamic> task, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? _darkCardColor : _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.task_alt, color: _successColor),
            SizedBox(width: 8),
            Text('تفاصيل المهمة المكتملة',
                style: TextStyle(
                  color: isDarkMode ? _darkTextColor : _textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                )),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('نوع المهمة:', task['type'], isDarkMode),
              _buildDetailRow('الموقع:', task['location'], isDarkMode),
              _buildDetailRow('العميل:', task['customerName'], isDarkMode),
              _buildDetailRow('التكلفة:', task['cost'], isDarkMode),
              _buildDetailRow('المدة:', task['duration'], isDarkMode),
              // تم حذف سطر التقييم هنا
              if (task['customerFeedback'] != null)
                _buildDetailRow('ملاحظات العميل:', task['customerFeedback'], isDarkMode),
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

  void _updateTaskStatus(Map<String, dynamic> task, String newStatus) {
    setState(() {
      task['status'] = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تحديث حالة المهمة إلى "$newStatus"'), 
        backgroundColor: _primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _openMap(String location) async {
    final Uri url = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تعذر فتح خرائط Google'),
          backgroundColor: _errorColor,
        ),
      );
    }
  }

  Widget _buildDetailRow(String title, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? _darkTextColor : _textColor
              )),
          Flexible(
            child: Text(value, 
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor
                )),
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context, bool isDarkMode) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode 
                ? [_darkPrimaryColor, Color(0xFF003366)]
                : [_primaryColor, Color(0xFF0099FF)],
          ),
        ),
        child: Column(
          children: [
            // رأس الملف الشخصي
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDarkMode 
                      ? [_darkPrimaryColor, Color(0xFF003366)]
                      : [_primaryColor, Color(0xFF0099FF)],
                ),
              ),
              child: Column(
                children: [
                  // الصورة الرمزية
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(
                      Icons.plumbing_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 16),
                  // الاسم والوظيفة
                  Text(
                    "مهدي العبادي",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "فني صيانة مياه - قسم توزيع بغداد",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  // المنطقة
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "منطقة بغداد الكرخ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // القائمة الرئيسية
            Expanded(
              child: Container(
                color: isDarkMode ? Color(0xFF0D1B2A) : Color(0xFFE8F4FD),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(height: 20),
                    
                    // الإعدادات
                    _buildDrawerMenuItem(
                      icon: Icons.settings_rounded,
                      title: 'الإعدادات',
                      onTap: () {
                        Navigator.pop(context);
                        _showSettingsScreen(context, isDarkMode);
                      },
                      isDarkMode: isDarkMode,
                    ),
                    // تسجيل الخروج
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
                    
                    // معلومات النسخة - في الأسفل
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
                            'وزارة الموارد المائية - جمهورية العراق',
                            style: TextStyle(
                              color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'الإصدار 2.0.0 - 2024',
                            style: TextStyle(
                              color: isDarkMode ? _darkTextLightColor : _textLightColor,
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
    final Color textColor = isDarkMode ? _darkTextColor : _textColor;
    final Color iconColor = isLogout 
        ? _errorColor 
        : (isDarkMode ? _darkTextColor : _primaryColor);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isLogout ? _errorColor.withOpacity(0.1) : Colors.transparent,
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isLogout 
                ? _errorColor.withOpacity(0.2)
                : (isDarkMode ? Colors.white12 : _primaryColor.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(18),
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
            color: isLogout ? _errorColor : textColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_left_rounded,
          color: isLogout ? _errorColor : (isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor),
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
        backgroundColor: isDarkMode ? _darkCardColor : _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: _errorColor),
            SizedBox(width: 8),
            Text('تأكيد تسجيل الخروج',
                style: TextStyle(
                  color: isDarkMode ? _darkTextColor : _textColor
                )),
          ],
        ),
        content: Text(
          'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
          style: TextStyle(
            color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                'esignin_screen',
                (route) => false,
              );
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
        builder: (context) => WaterTechnicianSettingsScreen(
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          accentColor: _accentColor,
          darkCardColor: _darkCardColor,
          cardColor: _cardColor,
          darkTextColor: _darkTextColor,
          textColor: _textColor,
          darkTextSecondaryColor: _darkTextSecondaryColor,
          textSecondaryColor: _textSecondaryColor,
          onSettingsChanged: (settings) {
            print('الإعدادات المحدثة: $settings');
          },
        ),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _successColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _errorColor,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

// شاشة الإعدادات لفني صيانة المياه
class WaterTechnicianSettingsScreen extends StatefulWidget {
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

  const WaterTechnicianSettingsScreen({
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
  State<WaterTechnicianSettingsScreen> createState() => _WaterTechnicianSettingsScreenState();
}

class _WaterTechnicianSettingsScreenState extends State<WaterTechnicianSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = false;
  bool _autoBackup = true;
  bool _locationTracking = true;
  bool _autoSync = true;
  String _language = 'العربية';
  
  void _saveSettings() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final Map<String, dynamic> settings = {
      'notificationsEnabled': _notificationsEnabled,
      'soundEnabled': _soundEnabled,
      'vibrationEnabled': _vibrationEnabled,
      'darkMode': themeProvider.isDarkMode,
      'autoBackup': _autoBackup,
      'locationTracking': _locationTracking,
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إعدادات فني صيانة المياه',
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
                      colors: [Color.fromARGB(255, 237, 234, 234), Color(0xFF1A1A1A)],
                    )
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFF8F9FA), Color(0xFFE8F4FD)],
                    ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  _buildSettingsSection('المظهر', Icons.palette_rounded, themeProvider),
                  
                  // زر الوضع المظلم
                  _buildDarkModeSwitch(themeProvider),
                  _buildSettingsSection('حول التطبيق', Icons.info_rounded, themeProvider),
                  _buildAboutCard(themeProvider),

                  SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
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
              borderRadius: BorderRadius.circular(20),
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
          _buildAboutRow('المطور', 'وزارة الموارد المائية - العراق', themeProvider),
          _buildAboutRow('رقم الترخيص', 'MWR-2024-001', themeProvider),
          _buildAboutRow('آخر تحديث', '2024-03-15', themeProvider),
          _buildAboutRow('البريد الإلكتروني', 'support@water.gov.iq', themeProvider),
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