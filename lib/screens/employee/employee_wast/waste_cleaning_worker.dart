import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';

class WasteCleaningWorkerScreen extends StatefulWidget {
  const WasteCleaningWorkerScreen({super.key});

  @override
  State<WasteCleaningWorkerScreen> createState() =>
      _WasteCleaningWorkerScreenState();
}

class _WasteCleaningWorkerScreenState
    extends State<WasteCleaningWorkerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  // ========== متغيرات التحديث ==========
  final GlobalKey<RefreshIndicatorState> _dashboardRefreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _scheduleRefreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _tasksRefreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _complaintsRefreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _reportsRefreshKey = GlobalKey<RefreshIndicatorState>();
  
  bool _isDashboardRefreshing = false;
  bool _isScheduleRefreshing = false;
  bool _isTasksRefreshing = false;
  bool _isComplaintsRefreshing = false;
  bool _isReportsRefreshing = false;

  // ========== نظام التقارير الجديد ==========
  String _selectedReportTypeSystem = 'يومي';
  List<DateTime> _selectedDates = [];
  String? _selectedWeek;
  String? _selectedMonth;
  DateTime? _lastSelectedDate;
  final List<String> _reportTypes = ['يومي', 'أسبوعي', 'شهري'];
  final List<String> _weeks = ['الأسبوع الأول', 'الأسبوع الثاني', 'الأسبوع الثالث', 'الأسبوع الرابع'];
  final List<String> _months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];

  // متغيرات البحث والتصفية
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  int _currentTasksTab = 0; // 0: الكل, 1: مكتمل, 2: قيد التنفيذ, 3: مخطط
  String _areaFilter = 'الكل';

  // الألوان الحكومية (أخضر وذهبي وبني)
  final Color _primaryColor = const Color(0xFF2E7D32); // أخضر حكومي
  final Color _secondaryColor = const Color(0xFFD4AF37); // ذهبي
  final Color _accentColor = const Color(0xFF8D6E63); // بني
  final Color _backgroundColor = const Color(0xFFF5F5F5); // خلفية فاتحة
  final Color _textColor = const Color(0xFF212121);
  final Color _textSecondaryColor = const Color(0xFF757575);
  final Color _successColor = const Color(0xFF2E7D32);
  final Color _warningColor = const Color(0xFFF57C00);
  final Color _errorColor = const Color(0xFFD32F2F);
  final Color _borderColor = const Color(0xFFE0E0E0);
  final Color _cardColor = const Color(0xFFFFFFFF);

  // ألوان الوضع الداكن
  final Color _darkPrimaryColor = const Color(0xFF1B5E20);
  final Color _darkBackgroundColor = const Color(0xFF121212);
  final Color _darkCardColor = const Color(0xFF1E1E1E);
  final Color _darkTextColor = const Color(0xFFFFFFFF);
  final Color _darkTextSecondaryColor = const Color(0xFFB0B0B0);

  // أسماء الأيام والشهور العربية
  final Map<String, String> _arabicDays = {
    'Monday': 'الاثنين',
    'Tuesday': 'الثلاثاء',
    'Wednesday': 'الأربعاء',
    'Thursday': 'الخميس',
    'Friday': 'الجمعة',
    'Saturday': 'السبت',
    'Sunday': 'الأحد',
  };

  final Map<String, String> _arabicMonths = {
    'January': 'يناير',
    'February': 'فبراير',
    'March': 'مارس',
    'April': 'أبريل',
    'May': 'مايو',
    'June': 'يونيو',
    'July': 'يوليو',
    'August': 'أغسطس',
    'September': 'سبتمبر',
    'October': 'أكتوبر',
    'November': 'نوفمبر',
    'December': 'ديسمبر',
  };

  // ========== بيانات البلاغات (الشكاوى) ==========
  final List<Map<String, dynamic>> complaints = [
    {
      'id': 'COMP-2024-001',
      'citizenId': 'CIT-2024-001',
      'citizenName': 'أحمد محمد',
      'phone': '077235477514',
      'address': 'حي الرياض - شارع الملك فهد',
      'type': 'جمع غير منتظم',
      'description': 'تأخر جمع النفايات لمدة 3 أيام متتالية، مما أدى إلى تراكم النفايات ورائحة كريهة',
      'priority': 'عالية',
      'status': 'قيد المعالجة',
      'submittedDate': DateTime.now().subtract(const Duration(days: 2, hours: 5)),
      'images': [
        'https://images.unsplash.com/photo-1562071707-7249ab429b2a?w=400&h=300&fit=crop',
        'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400&h=300&fit=crop',
      ],
      'location': '33.3152, 44.3661',
      'assignedTo': 'فريق الجمع 3',
      'notes': 'تم التواصل مع فريق الجمع، سيتم المعالجة خلال 24 ساعة',
      'lastUpdate': DateTime.now().subtract(const Duration(hours: 12)),
    },
    {
      'id': 'COMP-2024-002',
      'citizenId': 'CIT-2024-002',
      'citizenName': 'فاطمة علي',
      'phone': '07827534903',
      'address': 'حي النخيل - شارع الأمير محمد',
      'type': 'حاوية تالفة',
      'description': 'حاوية النفايات رقم BIN-001235 مكسورة وتحتاج إلى استبدال',
      'priority': 'متوسطة',
      'status': 'مكتمل',
      'submittedDate': DateTime.now().subtract(const Duration(days: 5, hours: 10)),
      'images': [
        'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400&h=300&fit=crop',
      ],
      'location': '33.3125, 44.3689',
      'assignedTo': 'فريق الصيانة 1',
      'notes': 'تم استبدال الحاوية بنجاح',
      'lastUpdate': DateTime.now().subtract(const Duration(days: 2)),
      'completionDate': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': 'COMP-2024-003',
      'citizenId': 'CIT-2024-003',
      'citizenName': 'خالد إبراهيم',
      'phone': '07758888999',
      'address': 'حي العليا - شارع العروبة',
      'type': 'تدوير غير صحيح',
      'description': 'فريق التدوير لا يفصل النفايات بشكل صحيح، يتم خلط المواد القابلة لإعادة التدوير مع النفايات العادية',
      'priority': 'عالية',
      'status': 'جديد',
      'submittedDate': DateTime.now().subtract(const Duration(hours: 3)),
      'images': [
        'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400&h=300&fit=crop',
        'https://images.unsplash.com/photo-1562071707-7249ab429b2a?w=400&h=300&fit=crop',
      ],
      'location': '33.3189, 44.3623',
      'assignedTo': 'لم يتم التخصيص',
      'notes': 'في انتظار المراجعة',
      'lastUpdate': DateTime.now().subtract(const Duration(hours: 3)),
    },
    {
      'id': 'COMP-2024-004',
      'citizenId': 'CIT-2024-001',
      'citizenName': 'أحمد محمد',
      'phone': '077235477514',
      'address': 'حي الرياض - شارع الملك فهد',
      'type': 'رائحة كريهة',
      'description': 'رائحة كريهة قوية تخرج من موقع تجميع النفايات بالقرب من المنزل',
      'priority': 'عالية',
      'status': 'قيد المعالجة',
      'submittedDate': DateTime.now().subtract(const Duration(days: 1, hours: 8)),
      'images': [],
      'location': '33.3155, 44.3658',
      'assignedTo': 'فريق التعقيم 2',
      'notes': 'تم جدولة عملية التعقيم والتطهير',
      'lastUpdate': DateTime.now().subtract(const Duration(hours: 6)),
    },
    {
      'id': 'COMP-2024-005',
      'citizenId': 'CIT-2024-002',
      'citizenName': 'فاطمة علي',
      'phone': '07827534903',
      'address': 'حي النخيل - شارع الأمير محمد',
      'type': 'حصيلة غير صحيحة',
      'description': 'المبلغ المطلوب في الفاتورة لا يتوافق مع كمية النفايات المجمعة',
      'priority': 'منخفضة',
      'status': 'ملغى',
      'submittedDate': DateTime.now().subtract(const Duration(days: 7, hours: 15)),
      'images': [
        'https://images.unsplash.com/photo-1603791445824-0040c5198b38?w=400&h=300&fit=crop',
      ],
      'location': '33.3122, 44.3692',
      'assignedTo': 'فريق الفواتير',
      'notes': 'تم التحقق من الفاتورة وهي صحيحة، تم إغلاق البلاغ',
      'lastUpdate': DateTime.now().subtract(const Duration(days: 5)),
      'completionDate': DateTime.now().subtract(const Duration(days: 5)),
    },
  ];

  // بيانات المهام (محدثة مع مهام لجميع الأيام)
  final List<CleanTask> _todayTasks = [
    // مهام يوم الأحد
    CleanTask(
      id: 10,
      areaName: 'حي الواحة - المنطقة F',
      truckNumber: 'شاحنة 110',
      workers: ['سامر أحمد', 'مازن علي'],
      startTime: '08:30',
      endTime: '12:30',
      date: _getDateForDay(DateTime.sunday),
      isCompleted: false,
      status: 'مخطط',
      wasteType: 'منزلي',
      binCount: 22,
    ),
    
    // مهام يوم الاثنين
    CleanTask(
      id: 11,
      areaName: 'حي الأندلس - المنطقة G',
      truckNumber: 'شاحنة 111',
      workers: ['ياسر محمود', 'باسم حسن'],
      startTime: '09:00',
      endTime: '13:00',
      date: _getDateForDay(DateTime.monday),
      isCompleted: true,
      status: 'مكتمل',
      wasteType: 'تجاري',
      binCount: 18,
    ),
    
    // مهام يوم الثلاثاء
    CleanTask(
      id: 12,
      areaName: 'حي الزهور - المنطقة H',
      truckNumber: 'شاحنة 112',
      workers: ['رامي سعيد', 'هشام عادل'],
      startTime: '10:00',
      endTime: '14:00',
      date: _getDateForDay(DateTime.tuesday),
      isCompleted: false,
      status: 'قيد التنفيذ',
      wasteType: 'منزلي',
      binCount: 25,
    ),
    
    // مهام يوم الأربعاء
    CleanTask(
      id: 13,
      areaName: 'حي النور - المنطقة I',
      truckNumber: 'شاحنة 113',
      workers: ['نبيل إبراهيم', 'رياض كمال'],
      startTime: '11:00',
      endTime: '15:00',
      date: _getDateForDay(DateTime.wednesday),
      isCompleted: false,
      status: 'مخطط',
      wasteType: 'تجاري',
      binCount: 20,
    ),
    
    // مهام يوم الخميس
    CleanTask(
      id: 14,
      areaName: 'حي الفيحاء - المنطقة J',
      truckNumber: 'شاحنة 114',
      workers: ['عصام فؤاد', 'جمال ناصر'],
      startTime: '12:00',
      endTime: '16:00',
      date: _getDateForDay(DateTime.thursday),
      isCompleted: true,
      status: 'مكتمل',
      wasteType: 'منزلي',
      binCount: 30,
    ),
    
    // مهام يوم الجمعة
    CleanTask(
      id: 15,
      areaName: 'حي الروضة - المنطقة K',
      truckNumber: 'شاحنة 115',
      workers: ['عدنان رشيد', 'سمير لطفي'],
      startTime: '13:00',
      endTime: '17:00',
      date: _getDateForDay(DateTime.friday),
      isCompleted: false,
      status: 'مخطط',
      wasteType: 'تجاري',
      binCount: 15,
    ),
    
    // مهام يوم السبت
    CleanTask(
      id: 16,
      areaName: 'حي المروج - المنطقة L',
      truckNumber: 'شاحنة 116',
      workers: ['فائز منير', 'نضال حامد'],
      startTime: '14:00',
      endTime: '18:00',
      date: _getDateForDay(DateTime.saturday),
      isCompleted: false,
      status: 'قيد التنفيذ',
      wasteType: 'منزلي',
      binCount: 28,
    ),
    
    // المهام القديمة
    CleanTask(
      id: 1,
      areaName: 'حي السلام - المنطقة A',
      truckNumber: 'شاحنة 101',
      workers: ['أحمد محمد', 'خالد علي'],
      startTime: '08:00',
      endTime: '12:00',
      date: DateTime.now(),
      isCompleted: true,
      status: 'مكتمل',
      wasteType: 'منزلي',
      binCount: 25,
    ),
    CleanTask(
      id: 2,
      areaName: 'حي النهضة - المنطقة B',
      truckNumber: 'شاحنة 102',
      workers: ['محمود حسن', 'سعيد عبدالله'],
      startTime: '13:00',
      endTime: '16:00',
      date: DateTime.now(),
      isCompleted: false,
      status: 'قيد التنفيذ',
      wasteType: 'تجاري',
      binCount: 15,
    ),
    CleanTask(
      id: 3,
      areaName: 'حي الورود - المنطقة C',
      truckNumber: 'شاحنة 103',
      workers: ['علي كمال', 'فارس ناصر'],
      startTime: '17:00',
      endTime: '19:00',
      date: DateTime.now(),
      isCompleted: false,
      status: 'مخطط',
      wasteType: 'منزلي',
      binCount: 30,
    ),
    CleanTask(
      id: 4,
      areaName: 'حي النخيل - المنطقة D',
      truckNumber: 'شاحنة 104',
      workers: ['حسن علي', 'مصطفى أحمد'],
      startTime: '09:00',
      endTime: '12:00',
      date: DateTime.now().subtract(const Duration(days: 1)),
      isCompleted: true,
      status: 'مكتمل',
      wasteType: 'منزلي',
      binCount: 20,
    ),
    CleanTask(
      id: 5,
      areaName: 'حي الرياض - المنطقة E',
      truckNumber: 'شاحنة 105',
      workers: ['عمر خالد', 'زيدان محمد'],
      startTime: '14:00',
      endTime: '17:00',
      date: DateTime.now().add(const Duration(days: 1)),
      isCompleted: false,
      status: 'مخطط',
      wasteType: 'تجاري',
      binCount: 18,
    ),
  ]; 

  // في نهاية الكلاس، أضف static قبل الدالة
  static DateTime _getDateForDay(int targetWeekday) {
    final today = DateTime.now();
    final currentWeekday = today.weekday;
    
    // حساب الفرق بالأيام للوصول إلى اليوم المطلوب
    int daysToAdd;
    
    if (currentWeekday <= targetWeekday) {
      daysToAdd = targetWeekday - currentWeekday;
    } else {
      daysToAdd = targetWeekday + 7 - currentWeekday;
    }
    
    return today.add(Duration(days: daysToAdd));
  }

  // مناطق العمل
  final List<String> _workAreas = ['الكل', 'حي السلام', 'حي النهضة', 'حي الورود', 'حي النخيل', 'حي الرياض'];

  // دالة للبحث في المهام
  List<CleanTask> get _filteredTasks {
    List<CleanTask> filtered = _todayTasks;
    
    // تطبيق فلتر التبويب
    if (_currentTasksTab == 1) { // مكتمل
      filtered = filtered.where((task) => task.isCompleted).toList();
    } else if (_currentTasksTab == 2) { // قيد التنفيذ
      filtered = filtered.where((task) => task.status == 'قيد التنفيذ').toList();
    } else if (_currentTasksTab == 3) { // مخطط
      filtered = filtered.where((task) => task.status == 'مخطط').toList();
    }
    
    // تطبيق فلتر المنطقة
    if (_areaFilter != 'الكل') {
      filtered = filtered.where((task) => task.areaName.contains(_areaFilter)).toList();
    }
    
    // تطبيق البحث النصي
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((task) {
        return task.areaName.contains(_searchQuery) ||
               task.truckNumber.contains(_searchQuery) ||
               task.workers.any((w) => w.contains(_searchQuery)) ||
               task.wasteType.contains(_searchQuery);
      }).toList();
    }
    
    return filtered;
  }

  // دالة للحصول على البلاغات حسب الحالة
  List<Map<String, dynamic>> _getFilteredComplaints() {
    switch (_currentComplaintTab) {
      case 0: // الكل
        return complaints;
      case 1: // جديد
        return complaints.where((complaint) => complaint['status'] == 'جديد').toList();
      case 2: // قيد المعالجة
        return complaints.where((complaint) => complaint['status'] == 'قيد المعالجة').toList();
      case 3: // مكتمل
        return complaints.where((complaint) => complaint['status'] == 'مكتمل').toList();
      case 4: // ملغى
        return complaints.where((complaint) => complaint['status'] == 'ملغى').toList();
      default:
        return complaints;
    }
  }

  // دالة لتنسيق التاريخ والوقت بدقة
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (date == today) {
      return 'اليوم ${DateFormat('h:mm a').format(dateTime)}';
    } else if (date == yesterday) {
      return 'أمس ${DateFormat('h:mm a').format(dateTime)}';
    } else {
      return DateFormat('yyyy/MM/dd - h:mm a').format(dateTime);
    }
  }

  // تبويبات البلاغات
  int _currentComplaintTab = 0;

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

  Color _getComplaintStatusColor(String status) {
    switch (status) {
      case 'جديد':
        return _errorColor;
      case 'قيد المعالجة':
        return _warningColor;
      case 'مكتمل':
        return _successColor;
      case 'ملغى':
        return _textSecondaryColor;
      default:
        return _textSecondaryColor;
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
        return _textSecondaryColor;
    }
  }

  // دوال تحديث البحث
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

  void _changeAreaFilter(String area) {
    setState(() {
      _areaFilter = area;
    });
  }

  // ========== دوال التحديث ==========
  Future<void> _refreshDashboard() async {
    if (_isDashboardRefreshing) return;
    
    setState(() {
      _isDashboardRefreshing = true;
    });
    
    // محاكاة جلب بيانات جديدة من السيرفر
    await Future.delayed(const Duration(seconds: 1));
    
    // هنا يمكن إضافة كود لجلب البيانات الحقيقية من API
    
    setState(() {
      _isDashboardRefreshing = false;
    });
    
    // إظهار رسالة نجاح
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم تحديث البيانات بنجاح'),
          backgroundColor: _successColor,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _refreshSchedule() async {
    if (_isScheduleRefreshing) return;
    
    setState(() {
      _isScheduleRefreshing = true;
    });
    
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isScheduleRefreshing = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم تحديث جدول المهام'),
          backgroundColor: _successColor,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _refreshTasks() async {
    if (_isTasksRefreshing) return;
    
    setState(() {
      _isTasksRefreshing = true;
    });
    
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isTasksRefreshing = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم تحديث قائمة المهام'),
          backgroundColor: _successColor,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _refreshComplaints() async {
    if (_isComplaintsRefreshing) return;
    
    setState(() {
      _isComplaintsRefreshing = true;
    });
    
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isComplaintsRefreshing = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم تحديث البلاغات'),
          backgroundColor: _successColor,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _refreshReports() async {
    if (_isReportsRefreshing) return;
    
    setState(() {
      _isReportsRefreshing = true;
    });
    
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isReportsRefreshing = false;
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم تحديث التقارير'),
          backgroundColor: _successColor,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
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
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cleaning_services, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'عامل النظافة',
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
          // أيقونة البلاغات
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.report_problem_rounded, size: 26),
                onPressed: () {
                  _tabController.animateTo(3); // التبديل إلى تبويب البلاغات
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: _errorColor,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    complaints.where((c) => c['status'] == 'جديد' || c['status'] == 'قيد المعالجة').length.toString(),
                    style: const TextStyle(
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
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, size: 26),
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
                      '2',
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
              _showNotifications(context);
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                indicator: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 10, color: _secondaryColor),
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 10),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.dashboard_rounded, size: 22),
                    text: 'الرئيسية',
                  ),
                  Tab(
                    icon: Icon(Icons.calendar_month_rounded, size: 22),
                    text: 'الجداول',
                  ),
                  Tab(
                    icon: Icon(Icons.assignment_turned_in_rounded, size: 22),
                    text: 'المهام',
                  ),
                  Tab(
                    icon: Icon(Icons.report_problem_rounded, size: 22),
                    text: 'البلاغات',
                  ),
                  Tab(
                    icon: Icon(Icons.insert_chart_rounded, size: 22),
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
                  colors: [_darkBackgroundColor, const Color(0xFF1A1A1A)],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_backgroundColor, const Color(0xFFE8F5E8)],
                ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            
            return TabBarView(
              controller: _tabController,
              children: [
                _buildDashboardView(isDarkMode, screenWidth, screenHeight),
                _buildScheduleView(isDarkMode, screenWidth, screenHeight),
                _buildTasksView(isDarkMode, screenWidth, screenHeight),
                _buildComplaintsView(isDarkMode, screenWidth, screenHeight),
                _buildReportsView(isDarkMode, screenWidth, screenHeight),
              ],
            );
          },
        ),
      ),
      drawer: _buildGovernmentDrawer(context, isDarkMode),
    );
  }

  // ========== شاشة الرئيسية مع RefreshIndicator ==========
  Widget _buildDashboardView(bool isDarkMode, double screenWidth, double screenHeight) {
    int completedTasks = _todayTasks.where((task) => task.isCompleted).length;
    int inProgressTasks = _todayTasks.where((task) => task.status == 'قيد التنفيذ').length;
    int plannedTasks = _todayTasks.where((task) => task.status == 'مخطط').length;
    
    return RefreshIndicator(
      key: _dashboardRefreshKey,
      onRefresh: _refreshDashboard,
      color: _primaryColor,
      backgroundColor: isDarkMode ? _darkCardColor : _cardColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة ترحيب
            _buildWelcomeCard(isDarkMode),
            
            const SizedBox(height: 20),
            
            // إحصائيات سريعة
            _buildQuickStatsCard(isDarkMode, completedTasks, inProgressTasks, plannedTasks),
            
            const SizedBox(height: 20),
            
            // مهام اليوم
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.task_alt_rounded, color: _primaryColor, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  'مهام اليوم',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? _darkTextColor : _primaryColor,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    _tabController.animateTo(2); // الذهاب إلى تبويب المهام
                  },
                  child: Text(
                    'عرض الكل',
                    style: TextStyle(color: _primaryColor),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // قائمة المهام لليوم
            if (_todayTasks.where((task) => 
                task.date.year == DateTime.now().year &&
                task.date.month == DateTime.now().month &&
                task.date.day == DateTime.now().day).isEmpty)
              _buildNoTasksMessage(isDarkMode, 'لا توجد مهام لليوم')
            else
              ..._todayTasks.where((task) => 
                task.date.year == DateTime.now().year &&
                task.date.month == DateTime.now().month &&
                task.date.day == DateTime.now().day).map((task) => _buildTaskCard(task, isDarkMode)).toList(),
            
            const SizedBox(height: 20),
            
            // آخر البلاغات
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.report_problem_rounded, color: _errorColor, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  'آخر البلاغات',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? _darkTextColor : _primaryColor,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    _tabController.animateTo(3); // الذهاب إلى تبويب البلاغات
                  },
                  child: Text(
                    'عرض الكل',
                    style: TextStyle(color: _primaryColor),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // قائمة آخر 3 بلاغات
            if (complaints.isEmpty)
              _buildNoComplaintsMessage(isDarkMode)
            else
              ...complaints.take(3).map((complaint) => _buildComplaintMiniCard(complaint, isDarkMode)).toList(),
            
            // إضافة مسافة في الأسفل للسماح بالسحب
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDarkMode ? _darkCardColor : _cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : _borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: _primaryColor, width: 2),
              ),
              child: const Icon(Icons.person_rounded, color: Colors.green, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مرحباً، أحمد',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode ? _darkTextColor : _textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'عامل نظافة - الفريق A',
                    style: TextStyle(
                      color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getArabicDate(DateTime.now()),
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsCard(bool isDarkMode, int completed, int inProgress, int planned) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDarkMode ? _darkCardColor : _cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : _borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('مكتمل', completed.toString(), Icons.check_circle_rounded, _successColor),
            _buildStatItem('قيد التنفيذ', inProgress.toString(), Icons.autorenew_rounded, _warningColor),
            _buildStatItem('مخطط', planned.toString(), Icons.schedule_rounded, _primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
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
            color: _textSecondaryColor,
          ),
        ),
      ],
    );
  }  

  // ========== شاشة الجداول مع RefreshIndicator ==========
  Widget _buildScheduleView(bool isDarkMode, double screenWidth, double screenHeight) {
    return RefreshIndicator(
      key: _scheduleRefreshKey,
      onRefresh: _refreshSchedule,
      color: _primaryColor,
      backgroundColor: isDarkMode ? _darkCardColor : _cardColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // شريط الإحصائيات
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? _darkCardColor : _cardColor,
                border: Border(
                  bottom: BorderSide(color: isDarkMode ? Colors.grey[800]! : _borderColor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatChip('إجمالي المهام', _todayTasks.length.toString(), _primaryColor),
                  _buildStatChip('المناطق', _getUniqueAreas().toString(), _successColor),
                  _buildStatChip('العمال', _getUniqueWorkers().toString(), _warningColor),
                  _buildStatChip('الشاحنات', _getUniqueTrucks().toString(), _accentColor),
                ],
              ),
            ),
            
            // الجدول الرئيسي
            Container(
              padding: const EdgeInsets.all(16),
              child: _buildScheduleTable(isDarkMode),
            ),
            
            // إضافة مسافة في الأسفل للسماح بالسحب
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleTable(bool isDarkMode) {
    final weekDays = _getWeekDays();
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // رؤوس الأعمدة
          _buildScheduleHeader(isDarkMode),
          
          // صفوف البيانات
          ...List.generate(7, (index) {
            final dayData = weekDays[index];
            final dayTasks = _getTasksForDay(dayData['date']);
            
            return _buildScheduleRow(
              dayName: dayData['name'],
              dayDate: dayData['date'],
              tasks: dayTasks,
              isDarkMode: isDarkMode,
              rowIndex: index,
            );
          }),
          
          // صف الإجمالي
          _buildTotalRow(isDarkMode),
        ],
      ),
    );
  }

  // ========== شاشة المهام مع RefreshIndicator ==========
  Widget _buildTasksView(bool isDarkMode, double screenWidth, double screenHeight) {
    return RefreshIndicator(
      key: _tasksRefreshKey,
      onRefresh: _refreshTasks,
      color: _primaryColor,
      backgroundColor: isDarkMode ? _darkCardColor : _cardColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // شريط البحث والتصفية
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? _darkCardColor : _cardColor,
                border: Border(
                  bottom: BorderSide(color: isDarkMode ? Colors.grey[800]! : _borderColor),
                ),
              ),
              child: Column(
                children: [
                  _buildSearchBar(isDarkMode, 'ابحث عن مهمة...'),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _workAreas.map((area) {
                        return _buildAreaFilterChip(area, isDarkMode);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // تبويبات المهام
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: isDarkMode ? _darkCardColor : _cardColor,
                border: Border(
                  bottom: BorderSide(color: isDarkMode ? Colors.grey[800]! : _borderColor),
                ),
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildTaskTabButton('الكل', 0, isDarkMode),
                  _buildTaskTabButton('مكتمل', 1, isDarkMode),
                  _buildTaskTabButton('قيد التنفيذ', 2, isDarkMode),
                  _buildTaskTabButton('مخطط', 3, isDarkMode),
                ],
              ),
            ),

            // إحصائيات سريعة للمهام
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? _darkCardColor : _cardColor,
                border: Border(
                  bottom: BorderSide(color: isDarkMode ? Colors.grey[800]! : _borderColor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTaskMiniStat('الإجمالي', _filteredTasks.length.toString(), _primaryColor),
                  _buildTaskMiniStat('مكتمل', _filteredTasks.where((t) => t.isCompleted).length.toString(), _successColor),
                  _buildTaskMiniStat('قيد التنفيذ', _filteredTasks.where((t) => t.status == 'قيد التنفيذ').length.toString(), _warningColor),
                  _buildTaskMiniStat('مخطط', _filteredTasks.where((t) => t.status == 'مخطط').length.toString(), _primaryColor),
                ],
              ),
            ),

            // قائمة المهام
            if (_filteredTasks.isEmpty)
              Container(
                height: 300,
                child: _buildNoTasksMessage(isDarkMode, 'لا توجد مهام تطابق البحث'),
              )
            else
              ..._filteredTasks.map((task) => _buildDetailedTaskCard(task, isDarkMode)).toList(),
            
            // إضافة مسافة في الأسفل للسماح بالسحب
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ========== شاشة البلاغات مع RefreshIndicator ==========
  Widget _buildComplaintsView(bool isDarkMode, double screenWidth, double screenHeight) {
    List<Map<String, dynamic>> filteredComplaints = _getFilteredComplaints();
    
    return RefreshIndicator(
      key: _complaintsRefreshKey,
      onRefresh: _refreshComplaints,
      color: _primaryColor,
      backgroundColor: isDarkMode ? _darkCardColor : _cardColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // إحصائيات البلاغات
            Container(
              padding: const EdgeInsets.all(16),
              child: _buildComplaintsStatsCard(isDarkMode),
            ),
            
            // تبويبات التصفية
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: isDarkMode ? _darkCardColor : _cardColor,
                border: Border(
                  bottom: BorderSide(color: isDarkMode ? Colors.grey[800]! : _borderColor),
                ),
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildComplaintFilterChip('الكل', 0, isDarkMode),
                  _buildComplaintFilterChip('جديدة', 1, isDarkMode),
                  _buildComplaintFilterChip('قيد المعالجة', 2, isDarkMode),
                  _buildComplaintFilterChip('مكتملة', 3, isDarkMode),
                  _buildComplaintFilterChip('ملغية', 4, isDarkMode),
                ],
              ),
            ),
            
            // قائمة البلاغات
            if (filteredComplaints.isEmpty)
              Container(
                height: 300,
                child: _buildNoComplaintsMessage(isDarkMode),
              )
            else
              ...filteredComplaints.map((complaint) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _buildComplaintCard(complaint, isDarkMode),
              )).toList(),
            
            // إضافة مسافة في الأسفل للسماح بالسحب
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ========== شاشة التقارير مع RefreshIndicator ==========
  Widget _buildReportsView(bool isDarkMode, double screenWidth, double screenHeight) {
    return RefreshIndicator(
      key: _reportsRefreshKey,
      onRefresh: _refreshReports,
      color: _primaryColor,
      backgroundColor: isDarkMode ? _darkCardColor : _cardColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                  child: Icon(Icons.assignment, color: _primaryColor, size: 24),
                ),
                const SizedBox(width: 8),
                Text(
                  'نظام التقارير المتقدم',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildReportTypeFilter(),
            const SizedBox(height: 20),
            _buildReportOptions(),
            const SizedBox(height: 20),
            _buildGenerateReportButton(),
            const SizedBox(height: 20),
            
            // إضافة مسافة في الأسفل للسماح بالسحب
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskTabButton(String title, int tabIndex, bool isDarkMode) {
    bool isSelected = _currentTasksTab == tabIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTasksTab = tabIndex;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isSelected ? _secondaryColor : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : (isDarkMode ? _darkTextColor : _textColor),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildAreaFilterChip(String area, bool isDarkMode) {
    bool isSelected = _areaFilter == area;
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: () => _changeAreaFilter(area),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? _primaryColor : (isDarkMode ? _darkCardColor : _cardColor),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? _primaryColor : (isDarkMode ? Colors.grey[700]! : _borderColor),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (area != 'الكل')
                Icon(Icons.location_on, size: 14, color: isSelected ? Colors.white : _primaryColor),
              if (area != 'الكل') const SizedBox(width: 4),
              Text(
                area,
                style: TextStyle(
                  color: isSelected ? Colors.white : (isDarkMode ? _darkTextColor : _textColor),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskMiniStat(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: _textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedTaskCard(CleanTask task, bool isDarkMode) {
    Color statusColor = task.isCompleted 
        ? _successColor 
        : (task.status == 'قيد التنفيذ' ? _warningColor : _primaryColor);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? _darkCardColor : _cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : _borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الهيدر
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    task.isCompleted ? Icons.check_circle_rounded : Icons.cleaning_services_rounded,
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.areaName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: isDarkMode ? _darkTextColor : _textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'الشاحنة: ${task.truckNumber}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    task.status,
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

          // التفاصيل
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black12 : Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: _textSecondaryColor),
                    const SizedBox(width: 4),
                    Text('${task.startTime} - ${task.endTime}', style: TextStyle(color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor)),
                    const SizedBox(width: 16),
                    Icon(Icons.people, size: 16, color: _textSecondaryColor),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        task.workers.join('، '),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.delete_outline, size: 16, color: _textSecondaryColor),
                    const SizedBox(width: 4),
                    Text('نوع النفايات: ${task.wasteType}', style: TextStyle(color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor)),
                    const SizedBox(width: 16),
                    Icon(Icons.inventory, size: 16, color: _textSecondaryColor),
                    const SizedBox(width: 4),
                    Text('${task.binCount} حاوية', style: TextStyle(color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!task.isCompleted)
                      ElevatedButton(
                        onPressed: () => _completeTask(task.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _successColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: const Text('إكمال المهمة'),
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

  Widget _buildTaskCard(CleanTask task, bool isDarkMode) {
    Color statusColor = task.isCompleted 
        ? _successColor 
        : (task.status == 'قيد التنفيذ' ? _warningColor : _primaryColor);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? _darkCardColor : _cardColor,
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : _borderColor,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            task.isCompleted ? Icons.check_circle : Icons.cleaning_services,
            color: statusColor,
            size: 20,
          ),
        ),
        title: Text(
          task.areaName,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: isDarkMode ? _darkTextColor : _textColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${task.truckNumber} - ${task.startTime} إلى ${task.endTime}',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            task.status,
            style: TextStyle(
              fontSize: 10,
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () {
          _showTaskDetails(task, isDarkMode);
        },
      ),
    );
  }

  Widget _buildComplaintMiniCard(Map<String, dynamic> complaint, bool isDarkMode) {
    Color statusColor = _getComplaintStatusColor(complaint['status']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? _darkCardColor : _cardColor,
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : _borderColor,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.report_problem_rounded, color: statusColor, size: 20),
        ),
        title: Text(
          complaint['citizenName'],
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: isDarkMode ? _darkTextColor : _textColor,
          ),
        ),
        subtitle: Text(
          complaint['type'],
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            complaint['status'],
            style: TextStyle(
              fontSize: 10,
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () {
          _showComplaintDetails(complaint, isDarkMode);
        },
      ),
    );
  }

  Widget _buildComplaintsStatsCard(bool isDarkMode) {
    int newComplaints = complaints.where((c) => c['status'] == 'جديد').length;
    int inProgress = complaints.where((c) => c['status'] == 'قيد المعالجة').length;
    int completed = complaints.where((c) => c['status'] == 'مكتمل').length;
    int cancelled = complaints.where((c) => c['status'] == 'ملغى').length;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? _darkCardColor : _cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : _borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildComplaintStat('إجمالي', complaints.length.toString(), Icons.report_problem_rounded, _primaryColor),
            _buildComplaintStat('جديدة', newComplaints.toString(), Icons.new_releases_rounded, _errorColor),
            _buildComplaintStat('قيد المعالجة', inProgress.toString(), Icons.sync_rounded, _warningColor),
            _buildComplaintStat('مكتملة', completed.toString(), Icons.check_circle_rounded, _successColor),
            _buildComplaintStat('ملغية', cancelled.toString(), Icons.cancel_rounded, _textSecondaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintsFilterRow(bool isDarkMode) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isDarkMode ? _darkCardColor : _cardColor,
        border: Border(
          bottom: BorderSide(color: _borderColor),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildComplaintFilterChip('الكل', 0, isDarkMode),
          _buildComplaintFilterChip('جديدة', 1, isDarkMode),
          _buildComplaintFilterChip('قيد المعالجة', 2, isDarkMode),
          _buildComplaintFilterChip('مكتملة', 3, isDarkMode),
          _buildComplaintFilterChip('ملغية', 4, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildComplaintFilterChip(String label, int tabIndex, bool isDarkMode) {
    bool isSelected = _currentComplaintTab == tabIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentComplaintTab = tabIndex;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isSelected ? _secondaryColor : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : (isDarkMode ? _darkTextColor : _textColor),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildComplaintStat(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: _textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildNoComplaintsMessage(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.report_off_rounded, 
               size: 64, 
               color: _textSecondaryColor),
          const SizedBox(height: 16),
          Text(
            'لا توجد بلاغات',
            style: TextStyle(
              fontSize: 18,
              color: _textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'لا توجد بلاغات في التبويب المحدد',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintCard(Map<String, dynamic> complaint, bool isDarkMode) {
    Color statusColor = _getComplaintStatusColor(complaint['status']);
    String priority = complaint['priority'];
    Color priorityColor = _getPriorityColor(priority);
    List<String> images = (complaint['images'] as List<dynamic>).cast<String>();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? _darkCardColor : _cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : _borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الهيدر
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.report_problem_rounded, color: statusColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'بلاغ #${complaint['id']}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: isDarkMode ? _darkTextColor : _textColor,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: priorityColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: priorityColor),
                            ),
                            child: Text(
                              priority,
                              style: TextStyle(
                                fontSize: 10,
                                color: priorityColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        complaint['citizenName'],
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        complaint['type'],
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // الصور المرفقة
          if (images.isNotEmpty)
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

          // الوصف
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              complaint['description'],
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? _darkTextColor : _textColor,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // الفوتر
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black12 : Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تم الإرسال: ${_formatDateTime(complaint['submittedDate'] as DateTime)}',
                      style: TextStyle(
                        fontSize: 10,
                        color: _textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'آخر تحديث: ${_formatDateTime(complaint['lastUpdate'] as DateTime)}',
                      style: TextStyle(
                        fontSize: 10,
                        color: _textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    complaint['status'],
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showComplaintDetails(Map<String, dynamic> complaint, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? _darkCardColor : _cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // الهيدر
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'تفاصيل البلاغ #${complaint['id']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          complaint['status'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // المحتوى
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // المعلومات الأساسية
                      Text(
                        'المعلومات الأساسية',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDarkMode ? _darkTextColor : _primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildComplaintDetailRow('المواطن:', complaint['citizenName']),
                      _buildComplaintDetailRow('رقم الهاتف:', complaint['phone']),
                      _buildComplaintDetailRow('العنوان:', complaint['address']),
                      _buildComplaintDetailRow('نوع البلاغ:', complaint['type']),
                      _buildComplaintDetailRow('الأولوية:', complaint['priority']),
                      _buildComplaintDetailRow('تم التخصيص إلى:', complaint['assignedTo']),
                      
                      const SizedBox(height: 16),
                      
                      // الوصف
                      Text(
                        'وصف البلاغ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDarkMode ? _darkTextColor : _primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.white10 : Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          complaint['description'],
                          style: TextStyle(
                            color: isDarkMode ? _darkTextColor : _textColor,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // الصور
                      if ((complaint['images'] as List).isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الصور المرفقة',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isDarkMode ? _darkTextColor : _primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: complaint['images'].length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(complaint['images'][index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      
                      // المعلومات الزمنية
                      Text(
                        'المعلومات الزمنية',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDarkMode ? _darkTextColor : _primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildComplaintDetailRow('تاريخ الإرسال:', _formatDateTime(complaint['submittedDate'] as DateTime)),
                      _buildComplaintDetailRow('آخر تحديث:', _formatDateTime(complaint['lastUpdate'] as DateTime)),
                      if (complaint['completionDate'] != null)
                        _buildComplaintDetailRow('تاريخ الإكمال:', _formatDateTime(complaint['completionDate'] as DateTime)),
                      
                      const SizedBox(height: 16),
                      
                      // الملاحظات
                      Text(
                        'ملاحظات',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDarkMode ? _darkTextColor : _primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.white10 : Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          complaint['notes'],
                          style: TextStyle(
                            color: isDarkMode ? _darkTextColor : _textColor,
                          ),
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
    );
  }

  Widget _buildComplaintDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: _textSecondaryColor,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTypeFilter() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
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
                color: _textColor,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _reportTypes.map((type) {
                  final isSelected = _selectedReportTypeSystem == type;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedReportTypeSystem = type;
                          _selectedDates.clear();
                          _selectedWeek = null;
                          _selectedMonth = null;
                        });
                      },
                      selectedColor: _primaryColor.withOpacity(0.2),
                      checkmarkColor: _primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? _primaryColor : _textColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: isSelected ? _primaryColor : Colors.grey[300]!),
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

  Widget _buildReportOptions() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
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
                color: _textColor,
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedReportTypeSystem == 'يومي') _buildDailyOptions(),
            if (_selectedReportTypeSystem == 'أسبوعي') _buildWeeklyOptions(),
            if (_selectedReportTypeSystem == 'شهري') _buildMonthlyOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyOptions() {
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
          Text(
            'التواريخ المختارة:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedDates.map((date) {
              return Chip(
                backgroundColor: _primaryColor.withOpacity(0.1),
                label: Text(DateFormat('yyyy-MM-dd').format(date), style: TextStyle(color: _primaryColor)),
                deleteIconColor: _primaryColor,
                onDeleted: () {
                  setState(() {
                    _selectedDates.remove(date);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '${_selectedDates.length}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                    const Text('يوم مختار'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd').format(_selectedDates.first),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ),
                    const Text('التاريخ المختار'),
                  ],
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[400], size: 48),
                const SizedBox(height: 8),
                Text(
                  'لم يتم اختيار أي تواريخ',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'انقر على الزر أعلاه لفتح التقويم واختيار التواريخ',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
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
            color: _textColor,
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
                style: const TextStyle(fontSize: 12),
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
                color: isSelected ? _primaryColor : _textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : Colors.grey[300]!),
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
            color: _textColor,
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
                style: const TextStyle(fontSize: 12),
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
                color: isSelected ? _primaryColor : _textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : Colors.grey[300]!),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGenerateReportButton() {
    bool isFormValid = false;
    
    switch (_selectedReportTypeSystem) {
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
          backgroundColor: isFormValid ? _primaryColor : Colors.grey[400],
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
            const Icon(Icons.summarize),
            const SizedBox(width: 8),
            Text(
              'إنشاء التقرير ${_selectedReportTypeSystem == 'يومي' && _selectedDates.isNotEmpty ? '(${_selectedDates.length} يوم)' : ''}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showMultiDatePicker() {
    // Keep original selection for cancel
    final List<DateTime> originalSelection = List.from(_selectedDates);
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('اختر التواريخ', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  TableCalendar(
                    firstDay: DateTime.now().subtract(const Duration(days: 365)),
                    lastDay: DateTime.now().add(const Duration(days: 365)),
                    focusedDay: DateTime.now(),
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: const {CalendarFormat.month: 'شهري'},
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
                      leftChevronIcon: Icon(Icons.chevron_left, color: _primaryColor),
                      rightChevronIcon: Icon(Icons.chevron_right, color: _primaryColor),
                    ),
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(color: _primaryColor, shape: BoxShape.circle),
                      todayDecoration: BoxDecoration(color: _accentColor, shape: BoxShape.circle),
                      weekendTextStyle: TextStyle(color: _errorColor),
                      defaultTextStyle: TextStyle(color: _textColor),
                      holidayTextStyle: TextStyle(color: _warningColor),
                    ),
                    selectedDayPredicate: (day) {
                      return _lastSelectedDate != null &&
                          _lastSelectedDate!.year == day.year &&
                          _lastSelectedDate!.month == day.month &&
                          _lastSelectedDate!.day == day.day;
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        bool isInList = _selectedDates.any((selectedDate) =>
                            selectedDate.year == selectedDay.year &&
                            selectedDate.month == selectedDay.month &&
                            selectedDate.day == selectedDay.day);
                        
                        if (!isInList) {
                          _selectedDates.add(selectedDay);
                        }
                        
                        _lastSelectedDate = selectedDay;
                      });
                    },
                  ),
                  if (_selectedDates.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'التاريخ المختار:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedDates.map((date) {
                            return Chip(
                              backgroundColor: _primaryColor.withOpacity(0.1),
                              label: Text(DateFormat('yyyy-MM-dd').format(date), style: TextStyle(color: _primaryColor)),
                              deleteIconColor: _primaryColor,
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
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.grey[400], size: 48),
                          const SizedBox(height: 8),
                          Text(
                            'لم يتم اختيار أي تاريخ',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'انقر على التاريخ لاختياره',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _selectedDates.clear();
                  _selectedDates.addAll(originalSelection);
                  Navigator.pop(context);
                },
                child: Text('إلغاء', style: TextStyle(color: Colors.grey[600])),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  if (mounted) {
                    setState(() {});
                  }
                },
                child: const Text('تم'),
              ),
            ],
          );
        },
      ),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _toggleDateSelection(DateTime date) {
    setState(() {
      bool isInList = _selectedDates.any((selectedDate) =>
          selectedDate.year == date.year &&
          selectedDate.month == date.month &&
          selectedDate.day == date.day);
      
      if (!isInList) {
        _selectedDates.add(date);
      }
      
      _lastSelectedDate = date;
    });
  }

  void _generateReport() {
    if (_selectedReportTypeSystem == 'يومي' && _selectedDates.isEmpty) {
      _showErrorSnackbar('يرجى اختيار تواريخ أولاً');
      return;
    }

    String reportPeriod = '';
    
    switch (_selectedReportTypeSystem) {
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

    _showSuccessSnackbar('تم إنشاء التقرير لـ ${_selectedDates.length} يوم بنجاح');
    _showGeneratedReport(reportPeriod);
  }

  void _showGeneratedReport(String period) {
    int completedTasks = _todayTasks.where((task) => task.isCompleted).length;
    int totalTasks = _todayTasks.length;
    double completionRate = totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('التقرير $period', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('نوع التقرير: $_selectedReportTypeSystem', style: TextStyle(color: _textColor)),
              if (_selectedReportTypeSystem == 'يومي' && _selectedDates.isNotEmpty)
                Text('عدد الأيام: ${_selectedDates.length}', style: TextStyle(color: _textColor)),
              if (_selectedWeek != null)
                Text('الأسبوع: $_selectedWeek', style: TextStyle(color: _textColor)),
              if (_selectedMonth != null)
                Text('الشهر: $_selectedMonth', style: TextStyle(color: _textColor)),
              const SizedBox(height: 16),
              Text('ملخص التقرير:', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
              Text('- إجمالي المهام: $totalTasks', style: TextStyle(color: _textColor)),
              Text('- المهام المكتملة: $completedTasks', style: TextStyle(color: _textColor)),
              Text('- نسبة الإنجاز: ${completionRate.toStringAsFixed(1)}%', style: TextStyle(color: _textColor)),
              const SizedBox(height: 8),
              Text('توزيع المهام:', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
              Text('- مكتمل: ${_todayTasks.where((t) => t.isCompleted).length}', style: TextStyle(color: _successColor)),
              Text('- قيد التنفيذ: ${_todayTasks.where((t) => t.status == 'قيد التنفيذ').length}', style: TextStyle(color: _warningColor)),
              Text('- مخطط: ${_todayTasks.where((t) => t.status == 'مخطط').length}', style: TextStyle(color: _primaryColor)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              _generatePdfReport(period);
            },
            child: const Text('تصدير PDF'),
          ),
        ],
      ),
    );
  }

  Future<void> _generatePdfReport(String period) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              _buildPdfHeader(period),
              pw.SizedBox(height: 20),
              _buildPdfTasksSummary(),
              pw.SizedBox(height: 20),
              _buildPdfTasksDetails(),
            ];
          },
        ),
      );

      final Uint8List pdfBytes = await pdf.save();
      await _sharePdfFile(pdfBytes, period);

    } catch (e) {
      _showErrorSnackbar('خطأ في تصدير التقرير: $e');
    }
  }

  pw.Widget _buildPdfHeader(String period) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'وزارة البلديات',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green,
              ),
            ),
            pw.Text(
              'تقرير مهام النظافة',
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
            pw.Text(_selectedReportTypeSystem),
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

  pw.Widget _buildPdfTasksSummary() {
    int completedTasks = _todayTasks.where((task) => task.isCompleted).length;
    int inProgressTasks = _todayTasks.where((task) => task.status == 'قيد التنفيذ').length;
    int plannedTasks = _todayTasks.where((task) => task.status == 'مخطط').length;
    int totalTasks = _todayTasks.length;
    double completionRate = totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0;

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.green),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: const pw.EdgeInsets.all(15),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'ملخص المهام',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('إجمالي المهام:'),
              pw.Text('$totalTasks'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('المهام المكتملة:'),
              pw.Text('$completedTasks'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('المهام قيد التنفيذ:'),
              pw.Text('$inProgressTasks'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('المهام المخطط لها:'),
              pw.Text('$plannedTasks'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('نسبة الإنجاز:'),
              pw.Text('${completionRate.toStringAsFixed(1)}%'),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfTasksDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'تفاصيل المهام',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.green,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.green100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('المنطقة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الشاحنة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الوقت', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الحالة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('نوع النفايات', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            ..._todayTasks.map((task) => pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(task.areaName),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(task.truckNumber),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('${task.startTime} - ${task.endTime}'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    task.status,
                    style: pw.TextStyle(
                      color: task.isCompleted ? PdfColors.green : 
                             (task.status == 'قيد التنفيذ' ? PdfColors.orange : PdfColors.blue),
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(task.wasteType),
                ),
              ],
            )).toList(),
          ],
        ),
      ],
    );
  }

  Future<void> _sharePdfFile(Uint8List pdfBytes, String period) async {
    try {
      final fileName = 'تقرير_مهام_النظافة_${DateTime.now().millisecondsSinceEpoch}.pdf';
      
      await Share.shareXFiles(
        [
          XFile.fromData(
            pdfBytes,
            name: fileName,
            mimeType: 'application/pdf',
          )
        ],
        subject: 'تقرير مهام النظافة - $period',
        text: 'مرفق تقرير مهام النظافة للفترة $period',
      );

      _showSuccessSnackbar('تم تصدير التقرير بنجاح');
    } catch (e) {
      _showErrorSnackbar('خطأ في مشاركة الملف: $e');
    }
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

  void _completeTask(int taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إكمال المهمة'),
        content: const Text('هل أنت متأكد من إكمال هذه المهمة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                for (var task in _todayTasks) {
                  if (task.id == taskId) {
                    task.isCompleted = true;
                    task.status = 'مكتمل';
                    break;
                  }
                }
              });
              Navigator.pop(context);
              _showSuccessSnackbar('تم إكمال المهمة بنجاح');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _successColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  void _showTaskDetails(CleanTask task, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? _darkCardColor : _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.task_alt_rounded, color: _primaryColor),
            const SizedBox(width: 8),
            const Text('تفاصيل المهمة'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('المنطقة:', task.areaName),
              _buildDetailRow('الشاحنة:', task.truckNumber),
              _buildDetailRow('الوقت:', '${task.startTime} - ${task.endTime}'),
              _buildDetailRow('العمال:', task.workers.join('، ')),
              _buildDetailRow('نوع النفايات:', task.wasteType),
              _buildDetailRow('عدد الحاويات:', '${task.binCount} حاوية'),
              _buildDetailRow('الحالة:', task.status),
              _buildDetailRow('التاريخ:', _getArabicDate(task.date)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: _primaryColor)),
          ),
          if (!task.isCompleted)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _completeTask(task.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _successColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('إكمال المهمة'),
            ),
        ],
      ),
    );
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
              color: _textSecondaryColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleHeader(bool isDarkMode) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDarkMode ? _darkPrimaryColor.withOpacity(0.3) : _primaryColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: _secondaryColor, width: 2),
        ),
      ),
      child: Row(
        children: [
          _buildScheduleHeaderCell('اليوم', width: 100, isDarkMode: isDarkMode),
          _buildScheduleHeaderCell('منطقة العمل', width: 180, isDarkMode: isDarkMode),
          _buildScheduleHeaderCell('الوقت', width: 140, isDarkMode: isDarkMode),
          _buildScheduleHeaderCell('العمال', width: 180, isDarkMode: isDarkMode),
          _buildScheduleHeaderCell('رقم الشاحنة', width: 120, isDarkMode: isDarkMode),
          _buildScheduleHeaderCell('عدد البيوت', width: 100, isDarkMode: isDarkMode),
        ],
      ),
    );
  }

  Widget _buildScheduleHeaderCell(String title, {required double width, required bool isDarkMode}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? _darkTextColor : _primaryColor,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.arrow_upward_rounded, size: 14, color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor),
        ],
      ),
    );
  }

  Widget _buildScheduleRow({
    required String dayName,
    required DateTime dayDate,
    required List<CleanTask> tasks,
    required bool isDarkMode,
    required int rowIndex,
  }) {
    final primaryTask = tasks.isNotEmpty ? tasks.first : null;
    final dayColor = _getDayColor(dayDate.weekday);
    final bgColor = rowIndex % 2 == 0
        ? (isDarkMode ? Colors.white.withOpacity(0.02) : Colors.grey.withOpacity(0.01))
        : Colors.transparent;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // الصف الرئيسي
        Container(
          height: tasks.length > 1 ? 56 : 50,
          color: bgColor,
          child: Row(
            children: [
              // عمود اليوم
              _buildScheduleDataCell(
                width: 100,
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: tasks.length > 1 ? 40 : 34,
                      decoration: BoxDecoration(
                        color: dayColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dayName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: dayColor,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            DateFormat('yyyy/MM/dd').format(dayDate),
                            style: TextStyle(
                              color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // باقي الأعمدة
              _buildScheduleDataCell(
                width: 180,
                child: Text(
                  primaryTask?.areaName ?? 'لا توجد مهام',
                  style: TextStyle(
                    color: isDarkMode ? _darkTextColor : _textColor,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildScheduleDataCell(
                width: 140,
                child: Text(
                  primaryTask != null ? '${primaryTask.startTime}-${primaryTask.endTime}' : '--:--',
                  style: TextStyle(
                    color: isDarkMode ? _darkTextColor : _textColor,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildScheduleDataCell(
                width: 180,
                child: Text(
                  primaryTask != null ? primaryTask.workers.join('، ') : '---',
                  style: TextStyle(
                    color: isDarkMode ? _darkTextColor : _textColor,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildScheduleDataCell(
                width: 120,
                child: Text(
                  primaryTask?.truckNumber ?? '---',
                  style: TextStyle(
                    color: isDarkMode ? _darkTextColor : _textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildScheduleDataCell(
                width: 100,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: _successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        primaryTask != null ? '${primaryTask.binCount}' : '0',
                        style: TextStyle(
                          color: _successColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (tasks.length > 1) ...[
                      const SizedBox(width: 4),
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: _warningColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '+${tasks.length - 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // الصفوف الفرعية
        if (tasks.length > 1)
          ...tasks.skip(1).map((task) => _buildScheduleSubRow(task, isDarkMode, bgColor)).toList(),
      ],
    );
  }

  Widget _buildScheduleDataCell({required double width, required Widget child}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      alignment: Alignment.centerRight,
      child: child,
    );
  }

  Widget _buildScheduleSubRow(CleanTask task, bool isDarkMode, Color bgColor) {
    return Container(
      height: 44,
      color: bgColor,
      child: Row(
        children: [
          _buildScheduleDataCell(
            width: 100,
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(Icons.subdirectory_arrow_right_rounded, size: 16, color: _textSecondaryColor),
              ],
            ),
          ),
          _buildScheduleDataCell(
            width: 180,
            child: Text(task.areaName, style: TextStyle(fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          _buildScheduleDataCell(
            width: 140,
            child: Text('${task.startTime}-${task.endTime}', style: TextStyle(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          _buildScheduleDataCell(
            width: 180,
            child: Text(task.workers.join('، '), style: TextStyle(fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          _buildScheduleDataCell(
            width: 120,
            child: Text(task.truckNumber, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          _buildScheduleDataCell(
            width: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('${task.binCount}', style: TextStyle(color: _successColor, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoTasksMessage(bool isDarkMode, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt_rounded, 
               size: 64, 
               color: _textSecondaryColor),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: _textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDarkMode, String hintText) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: isDarkMode ? _darkCardColor : _cardColor,
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : _borderColor,
          width: 0.5,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _updateSearchQuery,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: isDarkMode ? _darkTextSecondaryColor : _textSecondaryColor, fontSize: 11),
          prefixIcon: Icon(Icons.search_rounded, color: _textSecondaryColor, size: 16),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, color: _textSecondaryColor, size: 14),
                  onPressed: _clearSearch,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          isDense: true,
        ),
        style: TextStyle(color: isDarkMode ? _darkTextColor : _textColor, fontSize: 11),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$value ', style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 10)),
          Text(label, style: TextStyle(color: _textSecondaryColor, fontSize: 9)),
        ],
      ),
    );
  }

  Widget _buildTotalRow(bool isDarkMode) {
    int totalBins = _calculateTotalHouses();
    int totalTasks = _todayTasks.length;
    int uniqueAreas = _getUniqueAreas();
    int uniqueWorkers = _getUniqueWorkers();
    
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? _darkPrimaryColor.withOpacity(0.2) : _primaryColor.withOpacity(0.05),
        border: Border(
          top: BorderSide(color: _secondaryColor, width: 2),
          bottom: BorderSide(color: isDarkMode ? Colors.grey[800]! : _borderColor),
        ),
      ),
      child: Row(
        children: [
          // العمود 1: اليوم
          _buildTotalCell(
            width: 100,
            child: Text(
              'الإجمالي',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? _darkTextColor : _primaryColor,
                fontSize: 12,
              ),
            ),
          ),
          
          // العمود 2: منطقة العمل
          _buildTotalCell(
            width: 180,
            child: Text(
              '$uniqueAreas منطقة',
              style: TextStyle(
                color: isDarkMode ? _darkTextColor : _textColor,
                fontSize: 12,
              ),
            ),
          ),
          
          // العمود 3: الوقت
          _buildTotalCell(
            width: 140,
            child: Text(
              '$totalTasks مهمة',
              style: TextStyle(
                color: isDarkMode ? _darkTextColor : _textColor,
                fontSize: 12,
              ),
            ),
          ),
          
          // العمود 4: العمال
          _buildTotalCell(
            width: 180,
            child: Text(
              '$uniqueWorkers عامل',
              style: TextStyle(
                color: isDarkMode ? _darkTextColor : _textColor,
                fontSize: 12,
              ),
            ),
          ),
          
          // العمود 5: رقم الشاحنة
          _buildTotalCell(
            width: 120,
            child: Text(
              '${_getUniqueTrucks()} شاحنة',
              style: TextStyle(
                color: isDarkMode ? _darkTextColor : _textColor,
                fontSize: 12,
              ),
            ),
          ),
          
          // العمود 6: عدد البيوت
          _buildTotalCell(
            width: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                totalBins.toString(),
                style: TextStyle(
                  color: _successColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCell({required double width, required Widget child}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      alignment: Alignment.centerRight,
      child: child,
    );
  }

  int _calculateTotalHouses() {
    return _todayTasks.fold(0, (sum, task) => sum + task.binCount);
  }

  int _getUniqueAreas() {
    return _todayTasks.map((task) => task.areaName).toSet().length;
  }

  int _getUniqueWorkers() {
    final allWorkers = <String>[];
    for (var task in _todayTasks) {
      allWorkers.addAll(task.workers);
    }
    return allWorkers.toSet().length;
  }

  int _getUniqueTrucks() {
    return _todayTasks.map((task) => task.truckNumber).toSet().length;
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.notifications_rounded, color: _primaryColor),
            const SizedBox(width: 8),
            const Text('الإشعارات'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: const [
              ListTile(
                leading: Icon(Icons.info_rounded, color: Colors.blue),
                title: Text('تم إضافة مهمة جديدة'),
                subtitle: Text('منذ 5 دقائق'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle_rounded, color: Colors.green),
                title: Text('تم إكمال المهمة بنجاح'),
                subtitle: Text('منذ ساعة'),
              ),
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

  // دالة للحصول على التاريخ بالعربي
  String _getArabicDate(DateTime date) {
    final dayName = DateFormat('EEEE').format(date);
    final monthName = DateFormat('MMMM').format(date);
    
    return '${_arabicDays[dayName] ?? dayName} ${date.day} ${_arabicMonths[monthName] ?? monthName} ${date.year}';
  }

  // دالة للحصول على الشهر والسنة بالعربي
  String _getArabicMonthYear(DateTime date) {
    final monthName = DateFormat('MMMM').format(date);
    return '${_arabicMonths[monthName] ?? monthName} ${date.year}';
  }

  // دالة للتحقق إذا كان اليوم عطلة نهاية الأسبوع
  bool _isWeekend(DateTime day) {
    return day.weekday == DateTime.friday || day.weekday == DateTime.saturday;
  }

  // دالة للحصول على اسم اليوم بالعربية
  String _getArabicDayName(int weekday) {
    switch (weekday) {
      case DateTime.sunday:
        return 'الأحد';
      case DateTime.monday:
        return 'الاثنين';
      case DateTime.tuesday:
        return 'الثلاثاء';
      case DateTime.wednesday:
        return 'الأربعاء';
      case DateTime.thursday:
        return 'الخميس';
      case DateTime.friday:
        return 'الجمعة';
      case DateTime.saturday:
        return 'السبت';
      default:
        return '';
    }
  }

  // دالة للحصول على أيام الأسبوع بالترتيب من الأحد إلى السبت
  List<Map<String, dynamic>> _getWeekDays() {
    final today = DateTime.now();
    
    int daysToSubtract;
    if (today.weekday == DateTime.sunday) {
      daysToSubtract = 0; 
    } else {
      daysToSubtract = today.weekday; 
    }
    
    final sundayDate = today.subtract(Duration(days: daysToSubtract));
    
    print('تاريخ اليوم: $today');
    print('تاريخ الأحد: $sundayDate');
    
    return List.generate(7, (index) {
      final date = sundayDate.add(Duration(days: index));
      return {
        'name': _getArabicDayName(date.weekday),
        'date': date,
      };
    });
  }

  // دالة للحصول على المهام ليوم معين
  List<CleanTask> _getTasksForDay(DateTime date) {
    return _todayTasks.where((task) {
      return task.date.year == date.year &&
             task.date.month == date.month &&
             task.date.day == date.day;
    }).toList();
  }

  Color _getDayColor(int weekday) {
    switch (weekday) {
      case DateTime.sunday:
        return Colors.blue;
      case DateTime.monday:
        return Colors.green;
      case DateTime.tuesday:
        return Colors.orange;
      case DateTime.wednesday:
        return Colors.purple;
      case DateTime.thursday:
        return Colors.teal;
      case DateTime.friday:
        return Colors.brown;
      case DateTime.saturday:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // بناء القائمة المنسدلة
  Widget _buildGovernmentDrawer(BuildContext context, bool isDarkMode) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode 
                ? [_darkPrimaryColor, const Color(0xFF0D1B0E)]
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
                      ? [_darkPrimaryColor, const Color(0xFF1B5E20)]
                      : [_primaryColor, const Color(0xFF388E3C)],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(
                      Icons.cleaning_services,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "عامل النظافة",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "فريق الجمع - المنطقة A",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
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
                    child: const Text(
                      "المنطقة الوسطى",
                      style: TextStyle(color: Colors.white, fontSize: 14),
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
                            'وزارة البلديات - نظام مهام النظافة',
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
            const SizedBox(width: 8),
            const Text('تأكيد تسجيل الخروج'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
          style: TextStyle(
            color: isDarkMode ? _darkTextColor : _textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/esignin');
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

  
  // شاشة الإعدادات
void _showSettingsScreen(BuildContext context, bool isDarkMode) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SettingsScreen(
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
}

class CleanTask {
  final int id;
  final String areaName;
  final String truckNumber;
  final List<String> workers;
  final String startTime;
  final String endTime;
  final DateTime date;
  bool isCompleted;
  String status;
  String wasteType;
  int binCount;

  CleanTask({
    required this.id,
    required this.areaName,
    required this.truckNumber,
    required this.workers,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.isCompleted,
    required this.status,
    required this.wasteType,
    required this.binCount,
  });
}

class Worker {
  final int id;
  final String name;
  final String phone;
  final bool isOnDuty;
  final String specialization;
  final int experience;

  Worker({
    required this.id,
    required this.name,
    required this.phone,
    required this.isOnDuty,
    required this.specialization,
    required this.experience,
  });
}
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
  final List<String> _languages = ['العربية', 'English', 'Kurdish', 'Turkmen'];

  // إعدادات خاصة بكل شاشة
  bool _showCitizenStats = true;
  bool _showBillStats = true;
  bool _showComplaintStats = true;
  bool _showPaymentStats = true;
  int _itemsPerPage = 10;
  final List<int> _itemsPerPageOptions = [5, 10, 20, 50];

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    // هنا يمكن إضافة كود لتحميل الإعدادات المحفوظة من SharedPreferences
    // مؤقتاً نستخدم القيم الافتراضية
  }

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
      'showCitizenStats': _showCitizenStats,
      'showBillStats': _showBillStats,
      'showComplaintStats': _showComplaintStats,
      'showPaymentStats': _showPaymentStats,
      'itemsPerPage': _itemsPerPage,
    };
    
    widget.onSettingsChanged(settings);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حفظ الإعدادات بنجاح'),
        backgroundColor: widget.primaryColor,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
              Text('إعادة التعيين', 
                style: TextStyle(
                  color: themeProvider.isDarkMode ? widget.darkTextColor : widget.textColor,
                ),
              ),
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
              child: Text('إلغاء', 
                style: TextStyle(color: themeProvider.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor),
              ),
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
                  _showCitizenStats = true;
                  _showBillStats = true;
                  _showComplaintStats = true;
                  _showPaymentStats = true;
                  _itemsPerPage = 10;
                });
                
                themeProvider.toggleTheme(false);
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم إعادة التعيين إلى الإعدادات الافتراضية'),
                    backgroundColor: widget.primaryColor,
                    behavior: SnackBarBehavior.floating,
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
                  // قسم الإشعارات
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
                  
                  // قسم المظهر
                  _buildSettingsSection('المظهر', Icons.palette_rounded, themeProvider),
                  _buildDarkModeSwitch(themeProvider),
                  _buildSettingDropdown(
                    'اللغة',
                    _language,
                    _languages,
                    (String? value) => setState(() => _language = value!),
                    themeProvider,
                  ),

                  SizedBox(height: 24),
                  
                  // قسم تخصيص العرض
                  _buildSettingsSection('تخصيص العرض', Icons.visibility_rounded, themeProvider),
                  _buildSettingSwitch(
                    'إحصائيات المشتركين',
                    'عرض إحصائيات المشتركين في الشاشة الرئيسية',
                    _showCitizenStats,
                    (bool value) => setState(() => _showCitizenStats = value),
                    themeProvider,
                  ),
                  _buildSettingSwitch(
                    'إحصائيات الفواتير',
                    'عرض إحصائيات الفواتير',
                    _showBillStats,
                    (bool value) => setState(() => _showBillStats = value),
                    themeProvider,
                  ),
                  _buildSettingSwitch(
                    'إحصائيات البلاغات',
                    'عرض إحصائيات البلاغات',
                    _showComplaintStats,
                    (bool value) => setState(() => _showComplaintStats = value),
                    themeProvider,
                  ),
                  _buildSettingSwitch(
                    'إحصائيات طرق الدفع',
                    'عرض إحصائيات طرق الدفع',
                    _showPaymentStats,
                    (bool value) => setState(() => _showPaymentStats = value),
                    themeProvider,
                  ),
                  _buildSettingDropdown(
                    'عدد العناصر في الصفحة',
                    _itemsPerPage.toString(),
                    _itemsPerPageOptions.map((e) => e.toString()).toList(),
                    (String? value) => setState(() => _itemsPerPage = int.parse(value!)),
                    themeProvider,
                  ),

                  SizedBox(height: 24),
                  
                  // قسم الخصوصية والأمان
                  _buildSettingsSection('الخصوصية والأمان', Icons.security_rounded, themeProvider),
                  _buildSettingSwitch(
                    'المصادقة البيومترية',
                    'استخدام البصمة أو الوجه لتسجيل الدخول',
                    _biometricAuth,
                    (bool value) => setState(() => _biometricAuth = value),
                    themeProvider,
                  ),
                  _buildSettingSwitch(
                    'النسخ الاحتياطي التلقائي',
                    'نسخ احتياطي للبيانات بشكل دوري',
                    _autoBackup,
                    (bool value) => setState(() => _autoBackup = value),
                    themeProvider,
                  ),
                  _buildSettingSwitch(
                    'المزامنة التلقائية',
                    'مزامنة البيانات مع الخادم تلقائياً',
                    _autoSync,
                    (bool value) => setState(() => _autoSync = value),
                    themeProvider,
                  ),

                  SizedBox(height: 24),
                  
                  // قسم حول التطبيق
                  _buildSettingsSection('حول التطبيق', Icons.info_rounded, themeProvider),
                  _buildAboutCard(themeProvider),

                  SizedBox(height: 32),
                  
                  // أزرار التحكم
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
          _buildAboutRow('الإصدار', '1.0.0', themeProvider),
          _buildAboutRow('تاريخ البناء', '2024-03-20', themeProvider),
          _buildAboutRow('المطور', 'وزارة البلديات - العراق', themeProvider),
          _buildAboutRow('نظام التشغيل', 'نظام فواتير النفايات', themeProvider),
          _buildAboutRow('رقم الترخيص', 'MOW-2024-001', themeProvider),
          _buildAboutRow('آخر تحديث', '2024-03-15', themeProvider),
          _buildAboutRow('البريد الإلكتروني', 'support@municipality.gov.iq', themeProvider),
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