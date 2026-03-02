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
import 'package:mang_mu/screens/employee/Shared Services/esignin_screen.dart';
class WasteSchedulerApp extends StatefulWidget {
  const WasteSchedulerApp({super.key});

  @override
  State<WasteSchedulerApp> createState() => _WasteSchedulerAppState();
}

class _WasteSchedulerAppState extends State<WasteSchedulerApp> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  final Color _primaryColor = const Color(0xFF117E75); 
  final Color _secondaryColor = const Color(0xFFD4AF37);
  final Color _accentColor = const Color(0xFF8D6E63); // بني
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _textColor = const Color(0xFF212121);
  final Color _textSecondaryColor = const Color(0xFF757575);
  final Color _successColor = const Color(0xFF2E7D32);
  final Color _warningColor = const Color(0xFFF57C00);
  final Color _errorColor = const Color(0xFFD32F2F);
  final Color _borderColor = const Color(0xFFE0E0E0);
  Color _cardColor(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  return themeProvider.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
}
  // ========== متغيرات البحث والتصفية ==========
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  int _currentTasksTab = 0; // 0: الكل, 1: مكتمل, 2: قيد التنفيذ, 3: مخطط
  String _areaFilter = 'الكل';
  int _currentComplaintTab = 0;

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

  // ========== مناطق قلعة سكر ==========
  final List<String> _workAreas = [
    'الكل', 
    'قلعة سكر المركز', 
    'حي الزهور', 
    'حي النور', 
    'المنطقة الصناعية', 
    'السوق المركزي',
    'حي الأندلس',
    'المنطقة السكنية الجديدة'
  ];

  // ========== بيانات الجدول الأسبوعي ==========
  List<WasteTask> _weeklyTasks = [];

  // ========== بيانات الشاحنات ==========
  List<Truck> _availableTrucks = [
    Truck(
      id: 1,
      name: 'شاحنة ١ - قلعة سكر',
      type: 'نفايات عامة',
      capacity: '١٥ طن',
      plateNumber: 'ق س ١٢٣٤',
      sector: 'القطاع الشمالي',
      districts: ['قلعة سكر المركز', 'حي الزهور'],
      status: 'جاهزة للعمل',
      isSelected: false,
      lastMaintenance: DateTime.now().subtract(const Duration(days: 10)),
      nextMaintenance: DateTime.now().add(const Duration(days: 50)),
      driver: 'علي جاسم',
    ),
    Truck(
      id: 2,
      name: 'شاحنة ٢ - قلعة سكر',
      type: 'نفايات بناء',
      capacity: '٢٠ طن',
      plateNumber: 'ق س ٥٦٧٨',
      sector: 'القطاع الجنوبي',
      districts: ['حي النور', 'المنطقة الصناعية'],
      status: 'تحت الصيانة',
      isSelected: false,
      lastMaintenance: DateTime.now().subtract(const Duration(days: 55)),
      nextMaintenance: DateTime.now().add(const Duration(days: 35)),
      driver: 'حسن كريم',
    ),
    Truck(
      id: 3,
      name: 'شاحنة ٣ - قلعة سكر',
      type: 'نفايات زراعية',
      capacity: '١٢ طن',
      plateNumber: 'ق س ٩٠١٢',
      sector: 'القطاع الشرقي',
      districts: ['السوق المركزي', 'حي الأندلس'],
      status: 'مشغولة حالياً',
      isSelected: false,
      lastMaintenance: DateTime.now().subtract(const Duration(days: 25)),
      nextMaintenance: DateTime.now().add(const Duration(days: 65)),
      driver: 'محمد صالح',
    ),
    Truck(
      id: 4,
      name: 'شاحنة ٤ - قلعة سكر',
      type: 'نفايات عامة',
      capacity: '١٠ طن',
      plateNumber: 'ق س ٣٤٥٦',
      sector: 'القطاع الغربي',
      districts: ['المنطقة السكنية الجديدة'],
      status: 'جاهزة للعمل',
      isSelected: false,
      lastMaintenance: DateTime.now().subtract(const Duration(days: 15)),
      nextMaintenance: DateTime.now().add(const Duration(days: 75)),
      driver: 'أحمد حسين',
    ),
  ];

  // ========== بيانات العمال ==========
  List<Worker> _workers = [
    Worker(
      id: 1,
      name: 'كريم جبار',
      phone: '٠٧٧١٢٣٤٥٦٧',
      isSelected: false,
      status: 'متاح',
      idNumber: '٨٧٦٥٤٣٢١٠',
      sector: 'القطاع الشمالي',
      experienceYears: 4,
      monthlySalary: '١،٢٠٠،٠٠٠ دينار',
      lastAttendance: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Worker(
      id: 2,
      name: 'ناصر عبدالله',
      phone: '٠٧٧٧٦٥٤٣٢١',
      isSelected: false,
      status: 'متاح',
      idNumber: '٩٨٧٦٥٤٣٢١',
      sector: 'القطاع الجنوبي',
      experienceYears: 6,
      monthlySalary: '١،٥٠٠،٠٠٠ دينار',
      lastAttendance: DateTime.now(),
    ),
    Worker(
      id: 3,
      name: 'سامر محمود',
      phone: '٠٧٧٩٨٧٦٥٤٣',
      isSelected: false,
      status: 'في المهمة',
      idNumber: '١٢٣٤٥٦٧٨٩',
      sector: 'القطاع الشرقي',
      experienceYears: 3,
      monthlySalary: '١،٠٠٠،٠٠٠ دينار',
      lastAttendance: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Worker(
      id: 4,
      name: 'رياض فاضل',
      phone: '٠٧٧٤٥٦٧٨٩٠',
      isSelected: false,
      status: 'متاح',
      idNumber: '٥٥٥٦٦٦٧٧٧',
      sector: 'القطاع الغربي',
      experienceYears: 5,
      monthlySalary: '١،٣٠٠،٠٠٠ دينار',
      lastAttendance: DateTime.now(),
    ),
    Worker(
      id: 5,
      name: 'عباس حسن',
      phone: '٠٧٧٦٧٨٩٠١٢',
      isSelected: false,
      status: 'إجازة',
      idNumber: '٣٣٣٢٢٢١١١',
      sector: 'القطاع الشمالي',
      experienceYears: 7,
      monthlySalary: '١،٨٠٠،٠٠٠ دينار',
      lastAttendance: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Worker(
      id: 6,
      name: 'منتظر كاظم',
      phone: '٠٧٧٣٤٥٦٧٨٩',
      isSelected: false,
      status: 'متاح',
      idNumber: '٤٤٤٥٥٥٦٦٦',
      sector: 'القطاع الجنوبي',
      experienceYears: 2,
      monthlySalary: '٩٠٠،٠٠٠ دينار',
      lastAttendance: DateTime.now(),
    ),
  ];

  // ========== بيانات البلاغات (الشكاوى) ==========
  final List<Map<String, dynamic>> complaints = [
    {
      'id': 'COMP-QS-001',
      'citizenId': 'CIT-QS-001',
      'citizenName': 'علي حسين',
      'phone': '٠٧٧٢٣٥٤٧٧٥١٤',
      'address': 'قلعة سكر - حي الزهور - شارع ١٤',
      'type': 'تأخر جمع النفايات',
      'description': 'تأخر جمع النفايات لمدة ٣ أيام متتالية في حي الزهور',
      'priority': 'عالية',
      'status': 'قيد المعالجة',
      'submittedDate': DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      'images': [
        'https://images.unsplash.com/photo-1562071707-7249ab429b2a?w=400&h=300&fit=crop',
      ],
      'location': '33.3152, 44.3661',
      'assignedTo': 'فريق الجمع ١',
      'notes': 'تم التواصل مع الفريق',
      'lastUpdate': DateTime.now().subtract(const Duration(hours: 12)),
    },
    {
      'id': 'COMP-QS-002',
      'citizenId': 'CIT-QS-002',
      'citizenName': 'فاطمة كريم',
      'phone': '٠٧٨٢٧٥٣٤٩٠٣',
      'address': 'قلعة سكر - السوق المركزي',
      'type': 'حاوية مكسورة',
      'description': 'حاوية النفايات في السوق المركزي مكسورة',
      'priority': 'متوسطة',
      'status': 'مكتمل',
      'submittedDate': DateTime.now().subtract(const Duration(days: 3, hours: 10)),
      'images': [
        'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400&h=300&fit=crop',
      ],
      'location': '33.3125, 44.3689',
      'assignedTo': 'فريق الصيانة',
      'notes': 'تم استبدال الحاوية',
      'lastUpdate': DateTime.now().subtract(const Duration(days: 1)),
      'completionDate': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': 'COMP-QS-003',
      'citizenId': 'CIT-QS-003',
      'citizenName': 'خالد إبراهيم',
      'phone': '٠٧٧٥٨٨٨٨٩٩٩',
      'address': 'قلعة سكر - المنطقة الصناعية',
      'type': 'نفايات صناعية',
      'description': 'تراكم نفايات صناعية خطرة قرب المصنع',
      'priority': 'عالية',
      'status': 'جديد',
      'submittedDate': DateTime.now().subtract(const Duration(hours: 3)),
      'images': [],
      'location': '33.3189, 44.3623',
      'assignedTo': 'لم يتم التخصيص',
      'notes': 'في انتظار المراجعة',
      'lastUpdate': DateTime.now().subtract(const Duration(hours: 3)),
    },
  ];

  // ========== نظام التقارير ==========
  String _selectedReportTypeSystem = 'يومي';
  List<DateTime> _selectedDates = [];
  String? _selectedWeek;
  String? _selectedMonth;
  DateTime? _lastSelectedDate;
  final List<String> _reportTypes = ['يومي', 'أسبوعي', 'شهري'];
  final List<String> _weeks = ['الأسبوع الأول', 'الأسبوع الثاني', 'الأسبوع الثالث', 'الأسبوع الرابع'];
  final List<String> _months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
    _initializeWeeklyTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _initializeWeeklyTasks() {
    final now = DateTime.now();
    final currentWeekStart = now.subtract(Duration(days: now.weekday % 7));
    
    _weeklyTasks = [
      // الأحد
      WasteTask(
        id: 1,
        areaName: 'قلعة سكر المركز',
        truckNumber: 'شاحنة ١',
        workers: ['كريم جبار', 'ناصر عبدالله'],
        startTime: '08:00',
        endTime: '12:00',
        date: currentWeekStart,
        isCompleted: true,
        status: 'مكتمل',
        wasteType: 'منزلي',
        binCount: 25,
      ),
      WasteTask(
        id: 2,
        areaName: 'حي الزهور',
        truckNumber: 'شاحنة ١',
        workers: ['كريم جبار', 'ناصر عبدالله'],
        startTime: '13:00',
        endTime: '16:00',
        date: currentWeekStart,
        isCompleted: true,
        status: 'مكتمل',
        wasteType: 'منزلي',
        binCount: 18,
      ),
      
      // الاثنين
      WasteTask(
        id: 3,
        areaName: 'المنطقة الصناعية',
        truckNumber: 'شاحنة ٢',
        workers: ['سامر محمود', 'رياض فاضل'],
        startTime: '08:30',
        endTime: '12:30',
        date: currentWeekStart.add(const Duration(days: 1)),
        isCompleted: false,
        status: 'قيد التنفيذ',
        wasteType: 'صناعي',
        binCount: 30,
      ),
      WasteTask(
        id: 4,
        areaName: 'السوق المركزي',
        truckNumber: 'شاحنة ٣',
        workers: ['عباس حسن'],
        startTime: '09:00',
        endTime: '13:00',
        date: currentWeekStart.add(const Duration(days: 1)),
        isCompleted: false,
        status: 'قيد التنفيذ',
        wasteType: 'تجاري',
        binCount: 22,
      ),
      
      // الثلاثاء
      WasteTask(
        id: 5,
        areaName: 'حي النور',
        truckNumber: 'شاحنة ١',
        workers: ['كريم جبار', 'منتظر كاظم'],
        startTime: '08:00',
        endTime: '11:00',
        date: currentWeekStart.add(const Duration(days: 2)),
        isCompleted: false,
        status: 'مخطط',
        wasteType: 'منزلي',
        binCount: 20,
      ),
      WasteTask(
        id: 6,
        areaName: 'حي الأندلس',
        truckNumber: 'شاحنة ٤',
        workers: ['رياض فاضل'],
        startTime: '14:00',
        endTime: '17:00',
        date: currentWeekStart.add(const Duration(days: 2)),
        isCompleted: false,
        status: 'مخطط',
        wasteType: 'منزلي',
        binCount: 15,
      ),
      
      // الأربعاء
      WasteTask(
        id: 7,
        areaName: 'المنطقة السكنية الجديدة',
        truckNumber: 'شاحنة ٢',
        workers: ['سامر محمود', 'عباس حسن'],
        startTime: '08:00',
        endTime: '12:00',
        date: currentWeekStart.add(const Duration(days: 3)),
        isCompleted: false,
        status: 'مخطط',
        wasteType: 'منزلي',
        binCount: 28,
      ),
      
      // الخميس
      WasteTask(
        id: 8,
        areaName: 'قلعة سكر المركز',
        truckNumber: 'شاحنة ٣',
        workers: ['ناصر عبدالله', 'منتظر كاظم'],
        startTime: '09:00',
        endTime: '13:00',
        date: currentWeekStart.add(const Duration(days: 4)),
        isCompleted: false,
        status: 'مخطط',
        wasteType: 'منزلي',
        binCount: 25,
      ),
      WasteTask(
        id: 9,
        areaName: 'السوق المركزي',
        truckNumber: 'شاحنة ١',
        workers: ['كريم جبار'],
        startTime: '15:00',
        endTime: '18:00',
        date: currentWeekStart.add(const Duration(days: 4)),
        isCompleted: false,
        status: 'مخطط',
        wasteType: 'تجاري',
        binCount: 20,
      ),
      
      // الجمعة (عطلة)
      WasteTask(
        id: 10,
        areaName: 'يوم عطلة',
        truckNumber: '--',
        workers: [],
        startTime: '--',
        endTime: '--',
        date: currentWeekStart.add(const Duration(days: 5)),
        isCompleted: false,
        status: 'عطلة',
        wasteType: '--',
        binCount: 0,
      ),
      
      // السبت
      WasteTask(
        id: 11,
        areaName: 'حي الزهور',
        truckNumber: 'شاحنة ٤',
        workers: ['رياض فاضل', 'عباس حسن'],
        startTime: '08:00',
        endTime: '12:00',
        date: currentWeekStart.add(const Duration(days: 6)),
        isCompleted: false,
        status: 'مخطط',
        wasteType: 'منزلي',
        binCount: 22,
      ),
    ];
  }

  // ========== دوال المساعدة ==========
  String _getArabicDayName(int weekday) {
    switch (weekday) {
      case DateTime.sunday: return 'الأحد';
      case DateTime.monday: return 'الاثنين';
      case DateTime.tuesday: return 'الثلاثاء';
      case DateTime.wednesday: return 'الأربعاء';
      case DateTime.thursday: return 'الخميس';
      case DateTime.friday: return 'الجمعة';
      case DateTime.saturday: return 'السبت';
      default: return '';
    }
  }

  Color _getDayColor(int weekday) {
    switch (weekday) {
      case DateTime.sunday: return Colors.blue;
      case DateTime.monday: return Colors.green;
      case DateTime.tuesday: return Colors.orange;
      case DateTime.wednesday: return Colors.purple;
      case DateTime.thursday: return Colors.teal;
      case DateTime.friday: return Colors.brown;
      case DateTime.saturday: return Colors.red;
      default: return Colors.grey;
    }
  }

  List<Map<String, dynamic>> _getWeekDays() {
    final today = DateTime.now();
    int daysToSubtract;
    if (today.weekday == DateTime.sunday) {
      daysToSubtract = 0;
    } else {
      daysToSubtract = today.weekday;
    }
    final sundayDate = today.subtract(Duration(days: daysToSubtract));
    
    return List.generate(7, (index) {
      final date = sundayDate.add(Duration(days: index));
      return {
        'name': _getArabicDayName(date.weekday),
        'date': date,
      };
    });
  }

  List<WasteTask> _getTasksForDay(DateTime date) {
    return _weeklyTasks.where((task) {
      return task.date.year == date.year &&
             task.date.month == date.month &&
             task.date.day == date.day;
    }).toList();
  }

  int _calculateTotalBins() {
    return _weeklyTasks.fold(0, (sum, task) => sum + task.binCount);
  }

  int _getUniqueAreas() {
    return _weeklyTasks.map((task) => task.areaName).toSet().length;
  }

  int _getUniqueWorkers() {
    final allWorkers = <String>[];
    for (var task in _weeklyTasks) {
      allWorkers.addAll(task.workers);
    }
    return allWorkers.toSet().length;
  }

  int _getUniqueTrucks() {
    return _weeklyTasks.map((task) => task.truckNumber).toSet().length;
  }

  List<WasteTask> get _filteredTasks {
    List<WasteTask> filtered = _weeklyTasks.where((task) => task.status != 'عطلة').toList();
    
    if (_currentTasksTab == 1) {
      filtered = filtered.where((task) => task.isCompleted).toList();
    } else if (_currentTasksTab == 2) {
      filtered = filtered.where((task) => task.status == 'قيد التنفيذ').toList();
    } else if (_currentTasksTab == 3) {
      filtered = filtered.where((task) => task.status == 'مخطط').toList();
    }
    
    if (_areaFilter != 'الكل') {
      filtered = filtered.where((task) => task.areaName.contains(_areaFilter)).toList();
    }
    
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
  List<Map<String, dynamic>> _getFilteredComplaints() {
    switch (_currentComplaintTab) {
      case 0: return complaints;
      case 1: return complaints.where((c) => c['status'] == 'جديد').toList();
      case 2: return complaints.where((c) => c['status'] == 'قيد المعالجة').toList();
      case 3: return complaints.where((c) => c['status'] == 'مكتمل').toList();
      default: return complaints;
    }
  }

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

  Color _getComplaintStatusColor(String status) {
    switch (status) {
      case 'جديد': return _errorColor;
      case 'قيد المعالجة': return _warningColor;
      case 'مكتمل': return _successColor;
      default: return _textSecondaryColor;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'عالية': return _errorColor;
      case 'متوسطة': return _warningColor;
      case 'منخفضة': return _successColor;
      default: return _textSecondaryColor;
    }
  }

  String _getArabicDate(DateTime date) {
    final dayName = DateFormat('EEEE').format(date);
    final monthName = DateFormat('MMMM').format(date);
    return '${_arabicDays[dayName] ?? dayName} ${date.day} ${_arabicMonths[monthName] ?? monthName} ${date.year}';
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

  // ========== بناء الواجهة الرئيسية ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
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
              child: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'نظام إدارة النفايات - قلعة سكر',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.report_problem_rounded, size: 26),
                onPressed: () {
                  _tabController.animateTo(1);
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
              _showNotifications(context);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(
              color: _primaryColor,
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
                    icon: Icon(Icons.calendar_month_rounded, size: 22),
                    text: 'الجدول',
                  ),
                  Tab(
                    icon: Icon(Icons.report_problem_rounded, size: 22),
                    text: 'البلاغات',
                  ),
                  Tab(
                    icon: Icon(Icons.people_rounded, size: 22),
                    text: 'توزيع الفرق',
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildScheduleView(constraints.maxWidth, constraints.maxHeight),
              _buildComplaintsView(constraints.maxWidth, constraints.maxHeight),
              _buildTeamDistributionView(constraints.maxWidth, constraints.maxHeight),
              _buildReportsView(constraints.maxWidth, constraints.maxHeight),
            ],
          );
        },
      ),
      drawer: _buildDrawer(),
    );
  }

  // ========== شاشة الجدول مع خصائص الإضافة والحذف والتعديل والإرسال ==========
Widget _buildScheduleView(double screenWidth, double screenHeight) {
  final weekDays = _getWeekDays();
  
  return Container(
    width: screenWidth,
    height: screenHeight,
    color: _backgroundColor,
    child: LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(  // إضافة التمرير العمودي الرئيسي
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // بطاقة العنوان مع أزرار التحكم
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'جدول جمع النفايات',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'قلعة سكر - الأسبوع الحالي',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _secondaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${_weeklyTasks.length} مهمة',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // أزرار التحكم (إضافة - تعديل - حذف - إرسال)
                        Row(
                          children: [
                            Expanded(
                              child: _buildControlButton(
                                icon: Icons.add_rounded,
                                label: 'إضافة',
                                color: Colors.green,
                                onTap: () => _showAddTaskDialog(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildControlButton(
                                icon: Icons.edit_rounded,
                                label: 'تعديل',
                                color: Colors.orange,
                                onTap: () => _showEditTaskDialog(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildControlButton(
                                icon: Icons.delete_rounded,
                                label: 'حذف',
                                color: Colors.red,
                                onTap: () => _showDeleteTaskDialog(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildControlButton(
                                icon: Icons.send_rounded,
                                label: 'إرسال',
                                color: Colors.blue,
                                onTap: _showSendScheduleDialog,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // شريط الإحصائيات
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('إجمالي المهام', _weeklyTasks.length.toString(), Icons.task_alt_rounded, _primaryColor),
                        _buildStatItem('المناطق', _getUniqueAreas().toString(), Icons.location_on_rounded, _accentColor),
                        _buildStatItem('العمال', _getUniqueWorkers().toString(), Icons.people_rounded, _successColor),
                        _buildStatItem('الشاحنات', _getUniqueTrucks().toString(), Icons.local_shipping_rounded, _secondaryColor),
                      ],
                    ),
                  ),

                  // الجدول الرئيسي مع تمرير أفقي
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SingleChildScrollView(  // تمرير أفقي للجدول
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // رؤوس الأعمدة
                            _buildScheduleHeader(),
                            
                            // صفوف البيانات
                            ...List.generate(7, (index) {
                              final dayData = weekDays[index];
                              final dayTasks = _getTasksForDay(dayData['date']);
                              
                              return _buildScheduleRow(
                                dayName: dayData['name'],
                                dayDate: dayData['date'],
                                tasks: dayTasks,
                                rowIndex: index,
                              );
                            }),
                            
                            // صف الإجمالي
                            _buildTotalRow(),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // مسافة في الأسفل
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
// ========== دالة إظهار نافذة إضافة مهمة جديدة (Full Screen) مع حل مشكلة DropdownButton ==========
void _showAddTaskDialog() {
  final formKey = GlobalKey<FormState>();
  String selectedArea = _workAreas[1];
  
  // في بداية دالة _showAddTaskDialog
String selectedTruck = _availableTrucks.isNotEmpty ? _availableTrucks.first.name : '';
  
  List<String> selectedWorkersList = [];
  String startTime = '08:00';
  String endTime = '12:00';
  DateTime selectedDate = DateTime.now();
  String wasteType = 'منزلي';
  int binCount = 10;
  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                // AppBar مخصص
                Container(
                  padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add_task_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'إضافة مهمة جديدة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                
                // المحتوى القابل للتمرير
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // تاريخ المهمة
                          const Text(
                            'تاريخ المهمة',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                lastDate: DateTime.now().add(const Duration(days: 60)),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: _primaryColor,
                                        onPrimary: Colors.white,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setState(() {
                                  selectedDate = picked;
                                });
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${DateFormat('yyyy/MM/dd').format(selectedDate)} - ${_getArabicDayName(selectedDate.weekday)}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Icon(Icons.calendar_today, color: _primaryColor, size: 20),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // منطقة العمل
                          const Text(
                            'منطقة العمل',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<String>(
                              value: selectedArea,
                              isExpanded: true,
                              underline: const SizedBox(),
                              items: _workAreas.where((a) => a != 'الكل').map((area) {
                                return DropdownMenuItem(
                                  value: area,
                                  child: Text(area),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedArea = value!;
                                });
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // الشاحنة - الحل هنا
                          const Text(
                            'الشاحنة',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<String>(
                              value: selectedTruck.isEmpty ? null : selectedTruck, // مهم: إذا كانت القيمة فارغة نمرر null
                              isExpanded: true,
                              underline: const SizedBox(),
                              hint: const Text('اختر شاحنة'), // رسالة عند عدم وجود قيمة
                              items: _availableTrucks.map((truck) {
                                return DropdownMenuItem<String>(
                                  value: truck.name, // الاسم الكامل للشاحنة
                                  child: Text('${truck.name} (${truck.driver})'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedTruck = value!;
                                });
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // العمال
                          const Text(
                            'اختيار العمال',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: _workers.map((worker) {
                                return CheckboxListTile(
                                  title: Text(
                                    worker.name,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    worker.sector,
                                    style: TextStyle(color: _textSecondaryColor, fontSize: 12),
                                  ),
                                  value: selectedWorkersList.contains(worker.name),
                                  onChanged: (checked) {
                                    setState(() {
                                      if (checked!) {
                                        selectedWorkersList.add(worker.name);
                                      } else {
                                        selectedWorkersList.remove(worker.name);
                                      }
                                    });
                                  },
                                  activeColor: _primaryColor,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                );
                              }).toList(),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // وقت البدء والانتهاء
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'وقت البدء',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF212121),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      initialValue: startTime,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        hintText: '08:00',
                                      ),
                                      onChanged: (value) => startTime = value,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'وقت الانتهاء',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF212121),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      initialValue: endTime,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        hintText: '12:00',
                                      ),
                                      onChanged: (value) => endTime = value,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // نوع النفايات وعدد الحاويات
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'نوع النفايات',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF212121),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey[300]!),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: DropdownButton<String>(
                                        value: wasteType,
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        items: ['منزلي', 'تجاري', 'صناعي', 'زراعي'].map((type) {
                                          return DropdownMenuItem(
                                            value: type,
                                            child: Text(type),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            wasteType = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'عدد الحاويات',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF212121),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      initialValue: binCount.toString(),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        binCount = int.tryParse(value) ?? 10;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // أزرار التحكم
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.grey[600],
                                    side: BorderSide(color: Colors.grey[300]!),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'إلغاء',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // التحقق من اختيار شاحنة
                                    if (selectedTruck.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('الرجاء اختيار شاحنة'),
                                          backgroundColor: _errorColor,
                                        ),
                                      );
                                      return;
                                    }
                                    
                                    if (selectedWorkersList.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('الرجاء اختيار عامل واحد على الأقل'),
                                          backgroundColor: _errorColor,
                                        ),
                                      );
                                      return;
                                    }
                                    
                                    final newTask = WasteTask(
                                      id: _weeklyTasks.length + 1,
                                      areaName: selectedArea,
                                      truckNumber: selectedTruck,
                                      workers: selectedWorkersList,
                                      startTime: startTime,
                                      endTime: endTime,
                                      date: selectedDate,
                                      isCompleted: false,
                                      status: 'مخطط',
                                      wasteType: wasteType,
                                      binCount: binCount,
                                    );
                                    
                                    setState(() {
                                      _weeklyTasks.add(newTask);
                                    });
                                    
                                    Navigator.pop(context);
                                    _showSuccessSnackbar('تم إضافة المهمة بنجاح');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'إضافة',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
// ========== دالة إظهار نافذة تعديل مهمة (Full Screen) ==========
void _showEditTaskDialog() {
  final editableTasks = _weeklyTasks.where((task) => !task.isCompleted && task.status != 'عطلة').toList();
  
  if (editableTasks.isEmpty) {
    _showErrorSnackbar('لا توجد مهام قابلة للتعديل');
    return;
  }
  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                // AppBar مخصص
                Container(
                  padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'تعديل مهمة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                
                // المحتوى
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'اختر المهمة للتعديل:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListView.builder(
                              itemCount: editableTasks.length,
                              itemBuilder: (context, index) {
                                final task = editableTasks[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: _primaryColor.withOpacity(0.1),
                                    child: Icon(Icons.task_alt_rounded, color: _primaryColor, size: 20),
                                  ),
                                  title: Text(task.areaName),
                                  subtitle: Text(
                                    '${task.startTime} - ${task.endTime} | ${task.truckNumber}',
                                    style: TextStyle(color: _textSecondaryColor, fontSize: 12),
                                  ),
                                  trailing: const Icon(Icons.arrow_left_rounded),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _showEditTaskForm(task);
                                  },
                                );
                              },
                            ),
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
      },
    ),
  );
}
// ========== دالة عرض نموذج تعديل المهمة (Full Screen) - الحل النهائي والمضمون ==========
void _showEditTaskForm(WasteTask task) {
  final formKey = GlobalKey<FormState>();
  String selectedArea = task.areaName;
  
  // الحل الجذري: تحويل رقم الشاحنة إلى الاسم الكامل الموجود في _availableTrucks
  String selectedTruck = '';
  
  // استخراج رقم الشاحنة من task.truckNumber (مثلاً "شاحنة ٣")
  final truckNumber = task.truckNumber.trim();
  print('رقم الشاحنة من المهمة: $truckNumber'); // للتتبع
  
  // البحث في قائمة الشاحنات عن الاسم الذي يبدأ بنفس الرقم
  for (var truck in _availableTrucks) {
    print('مقارنة مع: ${truck.name}'); // للتتبع
    if (truck.name.startsWith(truckNumber)) {
      selectedTruck = truck.name;
      print('تم العثور على مطابقة: $selectedTruck'); // للتتبع
      break;
    }
  }
  
  // إذا لم يتم العثور على مطابقة، استخدم أول شاحنة كقيمة افتراضية
  if (selectedTruck.isEmpty && _availableTrucks.isNotEmpty) {
    selectedTruck = _availableTrucks.first.name;
    print('استخدام القيمة الافتراضية: $selectedTruck'); // للتتبع
  }
  
  List<String> selectedWorkers = List.from(task.workers);
  String startTime = task.startTime;
  String endTime = task.endTime;
  DateTime selectedDate = task.date;
  String wasteType = task.wasteType;
  int binCount = task.binCount;
  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                // AppBar مخصص
                Container(
                  padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'تعديل: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          task.areaName,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                
                // المحتوى القابل للتمرير
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // تاريخ المهمة
                          const Text(
                            'تاريخ المهمة',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                lastDate: DateTime.now().add(const Duration(days: 60)),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: _primaryColor,
                                        onPrimary: Colors.white,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setState(() {
                                  selectedDate = picked;
                                });
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${DateFormat('yyyy/MM/dd').format(selectedDate)} - ${_getArabicDayName(selectedDate.weekday)}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Icon(Icons.calendar_today, color: _primaryColor, size: 20),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // منطقة العمل
                          const Text(
                            'منطقة العمل',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<String>(
                              value: selectedArea,
                              isExpanded: true,
                              underline: const SizedBox(),
                              items: _workAreas.where((a) => a != 'الكل').map((area) {
                                return DropdownMenuItem(
                                  value: area,
                                  child: Text(area),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedArea = value!;
                                });
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // الشاحنة - الحل النهائي مع التأكد من تطابق القيمة
                          const Text(
                            'الشاحنة',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<String>(
                              // التأكد من أن القيمة موجودة في القائمة
                              value: _availableTrucks.any((truck) => truck.name == selectedTruck) 
                                  ? selectedTruck 
                                  : (_availableTrucks.isNotEmpty ? _availableTrucks.first.name : null),
                              isExpanded: true,
                              underline: const SizedBox(),
                              items: _availableTrucks.map((truck) {
                                return DropdownMenuItem<String>(
                                  value: truck.name,
                                  child: Text('${truck.name} (${truck.driver})'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedTruck = value!;
                                });
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // العمال
                          const Text(
                            'العمال',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: _workers.map((worker) {
                                return CheckboxListTile(
                                  title: Text(
                                    worker.name,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    worker.sector,
                                    style: TextStyle(color: _textSecondaryColor, fontSize: 12),
                                  ),
                                  value: selectedWorkers.contains(worker.name),
                                  onChanged: (checked) {
                                    setState(() {
                                      if (checked!) {
                                        selectedWorkers.add(worker.name);
                                      } else {
                                        selectedWorkers.remove(worker.name);
                                      }
                                    });
                                  },
                                  activeColor: _primaryColor,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                );
                              }).toList(),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // وقت البدء والانتهاء
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'وقت البدء',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF212121),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      initialValue: startTime,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      onChanged: (value) => startTime = value,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'وقت الانتهاء',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF212121),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      initialValue: endTime,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      onChanged: (value) => endTime = value,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // نوع النفايات وعدد الحاويات
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'نوع النفايات',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF212121),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey[300]!),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: DropdownButton<String>(
                                        value: wasteType,
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        items: ['منزلي', 'تجاري', 'صناعي', 'زراعي'].map((type) {
                                          return DropdownMenuItem(
                                            value: type,
                                            child: Text(type),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            wasteType = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'عدد الحاويات',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF212121),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      initialValue: binCount.toString(),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        binCount = int.tryParse(value) ?? binCount;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // أزرار التحكم
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.grey[600],
                                    side: BorderSide(color: Colors.grey[300]!),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'إلغاء',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (selectedWorkers.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('الرجاء اختيار عامل واحد على الأقل'),
                                          backgroundColor: _errorColor,
                                        ),
                                      );
                                      return;
                                    }
                                    
                                    setState(() {
                                      final index = _weeklyTasks.indexWhere((t) => t.id == task.id);
                                      if (index != -1) {
                                        _weeklyTasks[index] = WasteTask(
                                          id: task.id,
                                          areaName: selectedArea,
                                          truckNumber: selectedTruck, // هنا نستخدم الاسم الكامل
                                          workers: selectedWorkers,
                                          startTime: startTime,
                                          endTime: endTime,
                                          date: selectedDate,
                                          isCompleted: task.isCompleted,
                                          status: task.status,
                                          wasteType: wasteType,
                                          binCount: binCount,
                                        );
                                      }
                                    });
                                    
                                    Navigator.pop(context);
                                    _showSuccessSnackbar('تم تعديل المهمة بنجاح');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'حفظ التعديلات',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
// ========== دالة إظهار نافذة حذف مهمة (Full Screen) ==========
void _showDeleteTaskDialog() {
  final deletableTasks = _weeklyTasks.where((task) => task.status != 'عطلة').toList();
  
  if (deletableTasks.isEmpty) {
    _showErrorSnackbar('لا توجد مهام للحذف');
    return;
  }
  
  List<WasteTask> selectedTasks = [];
  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                // AppBar مخصص
                Container(
                  padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'حذف مهام',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                
                // المحتوى
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // شريط التحديد
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'تم اختيار ${selectedTasks.length} مهمة',
                                style: TextStyle(
                                  color: _primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (selectedTasks.length == deletableTasks.length) {
                                      selectedTasks.clear();
                                    } else {
                                      selectedTasks = List.from(deletableTasks);
                                    }
                                  });
                                },
                                child: Text(
                                  selectedTasks.length == deletableTasks.length ? 'إلغاء الكل' : 'تحديد الكل',
                                  style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        const Text(
                          'اختر المهام للحذف:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // قائمة المهام
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListView.builder(
                              itemCount: deletableTasks.length,
                              itemBuilder: (context, index) {
                                final task = deletableTasks[index];
                                return CheckboxListTile(
                                  title: Text(
                                    task.areaName,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  subtitle: Text(
                                    '${DateFormat('yyyy/MM/dd').format(task.date)} | ${task.startTime}-${task.endTime} | ${task.truckNumber}',
                                    style: TextStyle(color: _textSecondaryColor, fontSize: 12),
                                  ),
                                  value: selectedTasks.contains(task),
                                  onChanged: (checked) {
                                    setState(() {
                                      if (checked!) {
                                        selectedTasks.add(task);
                                      } else {
                                        selectedTasks.remove(task);
                                      }
                                    });
                                  },
                                  activeColor: Colors.red,
                                  secondary: CircleAvatar(
                                    backgroundColor: _primaryColor.withOpacity(0.1),
                                    child: Icon(Icons.delete_outline_rounded, color: Colors.red, size: 18),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // أزرار التحكم
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.grey[600],
                                  side: BorderSide(color: Colors.grey[300]!),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'إلغاء',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: selectedTasks.isEmpty ? null : () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('تأكيد الحذف'),
                                      content: Text('هل أنت متأكد من حذف ${selectedTasks.length} مهام؟'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('لا'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _weeklyTasks.removeWhere((task) => selectedTasks.contains(task));
                                            });
                                            Navigator.pop(context); // إغلاق تأكيد الحذف
                                            Navigator.pop(context); // إغلاق نافذة الحذف
                                            _showSuccessSnackbar('تم حذف ${selectedTasks.length} مهام بنجاح');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text('نعم، احذف'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'حذف ${selectedTasks.isEmpty ? '' : '(' + selectedTasks.length.toString() + ')'}',
                                  style: const TextStyle(fontSize: 16),
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
      },
    ),
  );
}

// ========== نافذة إرسال الجدول (Full Screen) ==========
void _showSendScheduleDialog() {
  final weekDays = _getWeekDays();
  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            // AppBar مخصص
            Container(
              padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'إرسال الجدول',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            // المحتوى القابل للتمرير
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // معلومات الأسبوع
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_rounded, color: Colors.blue, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'معلومات الجدول',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          _buildInfoRow('الأسبوع:', '${weekDays.first['name']} ${DateFormat('yyyy/MM/dd').format(weekDays.first['date'])} - ${weekDays.last['name']} ${DateFormat('yyyy/MM/dd').format(weekDays.last['date'])}'),
                          _buildInfoRow('إجمالي المهام:', '${_weeklyTasks.length} مهمة'),
                          _buildInfoRow('المناطق المغطاة:', '${_getUniqueAreas()} منطقة'),
                          _buildInfoRow('عدد العمال:', '${_getUniqueWorkers()} عامل'),
                          _buildInfoRow('عدد الشاحنات:', '${_getUniqueTrucks()} شاحنة'),
                          _buildInfoRow('إجمالي الحاويات:', '${_calculateTotalBins()} حاوية'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    const Text(
                      'خيارات الإرسال:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // خيار PDF
                    _buildFullScreenSendOption(
                      icon: Icons.picture_as_pdf_rounded,
                      iconColor: Colors.red,
                      title: 'تصدير كملف PDF',
                      subtitle: 'إنشاء ملف PDF للجدول الأسبوعي مع جميع التفاصيل',
                      onTap: () {
                        Navigator.pop(context);
                        _generatePdfReport('الأسبوع الحالي');
                      },
                    ),
                    
                    // خيار Excel
                    _buildFullScreenSendOption(
                      icon: Icons.table_chart_rounded,
                      iconColor: Colors.green,
                      title: 'تصدير كملف Excel',
                      subtitle: 'إنشاء ملف CSV للجدول الأسبوعي',
                      onTap: () {
                        Navigator.pop(context);
                        _exportScheduleToExcel();
                      },
                    ),
                    
                    // خيار مشاركة
                    _buildFullScreenSendOption(
                      icon: Icons.share_rounded,
                      iconColor: Colors.blue,
                      title: 'مشاركة الجدول',
                      subtitle: 'مشاركة الجدول عبر التطبيقات كنص',
                      onTap: () {
                        Navigator.pop(context);
                        _shareScheduleText();
                      },
                    ),
                    // زر العودة
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: _textColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'رجوع',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// دالة مساعدة لبناء صف المعلومات
Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF757575),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: _primaryColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

// دالة بناء خيار الإرسال في وضع ملء الشاشة
Widget _buildFullScreenSendOption({
  required IconData icon,
  required Color iconColor,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey[200]!),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: _textSecondaryColor,
          fontSize: 13,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.arrow_forward_rounded, color: iconColor, size: 18),
      ),
      onTap: onTap,
    ),
  );
}
// ========== دالة بناء زر التحكم ==========
Widget _buildControlButton({
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
// دالة مشاركة الجدول كنص
void _shareScheduleText() async {
  try {
    final weekDays = _getWeekDays();
    String scheduleText = '🗓️ جدول مهام النظافة - قلعة سكر\n';
    scheduleText += '📅 الأسبوع: ${weekDays.first['name']} ${DateFormat('yyyy/MM/dd').format(weekDays.first['date'])} - ${weekDays.last['name']} ${DateFormat('yyyy/MM/dd').format(weekDays.last['date'])}\n';
    scheduleText += '================================\n\n';
    
    for (var day in weekDays) {
      final dayTasks = _getTasksForDay(day['date']);
      if (dayTasks.isEmpty) {
        scheduleText += '${day['name']} ${DateFormat('yyyy/MM/dd').format(day['date'])}: لا توجد مهام\n';
      } else {
        scheduleText += '${day['name']} ${DateFormat('yyyy/MM/dd').format(day['date'])}:\n';
        for (var task in dayTasks) {
          scheduleText += '  • ${task.areaName}: ${task.startTime}-${task.endTime} | ${task.truckNumber} | ${task.workers.join('، ')} | ${task.binCount} حاوية\n';
        }
      }
      scheduleText += '\n';
    }
    
    scheduleText += '================================\n';
    scheduleText += '📊 إجمالي المهام: ${_weeklyTasks.length}\n';
    scheduleText += '🏘️ المناطق المغطاة: ${_getUniqueAreas()}\n';
    scheduleText += '👷 عدد العمال: ${_getUniqueWorkers()}\n';
    scheduleText += '🚛 عدد الشاحنات: ${_getUniqueTrucks()}\n';
    scheduleText += '🗑️ إجمالي الحاويات: ${_calculateTotalBins()}\n';
    
    await Share.share(scheduleText, subject: 'جدول مهام النظافة - قلعة سكر');
    _showSuccessSnackbar('تم مشاركة الجدول بنجاح');
  } catch (e) {
    _showErrorSnackbar('خطأ في مشاركة الجدول: $e');
  }
}

// دالة إنشاء صف الإجمالي
Widget _buildTotalRow() {
  int totalBins = _calculateTotalBins();
  int totalTasks = _weeklyTasks.where((t) => t.status != 'عطلة').length;
  int uniqueAreas = _getUniqueAreas();
  int uniqueWorkers = _getUniqueWorkers();
  
  return Container(
    height: 48,
    decoration: BoxDecoration(
      color: _primaryColor.withOpacity(0.05),
      border: Border(
        top: BorderSide(color: _secondaryColor, width: 2),
      ),
    ),
    child: Row(
      children: [
        _buildDataCell(
          width: 120,
          child: Text(
            'الإجمالي',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _primaryColor,
              fontSize: 12,
            ),
          ),
        ),
        _buildDataCell(
          width: 180,
          child: Text('$uniqueAreas منطقة', style: const TextStyle(fontSize: 12)),
        ),
        _buildDataCell(
          width: 140,
          child: Text('$totalTasks مهمة', style: const TextStyle(fontSize: 12)),
        ),
        _buildDataCell(
          width: 200,
          child: Text('$uniqueWorkers عامل', style: const TextStyle(fontSize: 12)),
        ),
        _buildDataCell(
          width: 120,
          child: Text('${_getUniqueTrucks()} شاحنة', style: const TextStyle(fontSize: 12)),
        ),
        _buildDataCell(
          width: 120,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: _successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              totalBins.toString(),
              style: TextStyle(color: _successColor, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );
}
  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 16),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
          fontSize: 14,
        ),
      ),
      Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: _textSecondaryColor,
        ),
      ),
    ],
  );
}

  Widget _buildScheduleHeader() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(color: _secondaryColor, width: 2),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('اليوم', width: 120),
          _buildHeaderCell('منطقة العمل', width: 180),
          _buildHeaderCell('الوقت', width: 140),
          _buildHeaderCell('العمال', width: 200),
          _buildHeaderCell('رقم الشاحنة', width: 120),
          _buildHeaderCell('عدد الحاويات', width: 120),
        ],
      ),
    );
  }

// دالة بناء خلية الرأس
Widget _buildHeaderCell(String title, {required double width}) {
  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    alignment: Alignment.centerRight,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _primaryColor,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const SizedBox(width: 4),
        Icon(Icons.arrow_upward_rounded, size: 14, color: _textSecondaryColor),
      ],
    ),
  );
}

  Widget _buildScheduleRow({
  required String dayName,
  required DateTime dayDate,
  required List<WasteTask> tasks,
  required int rowIndex,
}) {
  final primaryTask = tasks.isNotEmpty ? tasks.first : null;
  final dayColor = _getDayColor(dayDate.weekday);
  final isEvenRow = rowIndex % 2 == 0;
  
  return Column(
    children: [
      Container(
        height: tasks.length > 1 ? 56 : 50,
        color: isEvenRow ? Colors.grey.withOpacity(0.02) : Colors.transparent,
        child: Row(
          children: [
            // عمود اليوم
            _buildDataCell(
              width: 120,
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
                            color: _textSecondaryColor,
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
            _buildDataCell(
              width: 180,
              child: Text(
                primaryTask?.areaName ?? 'يوم عطلة',
                style: TextStyle(
                  color: primaryTask != null ? _textColor : _textSecondaryColor,
                  fontSize: 12,
                  fontStyle: primaryTask == null ? FontStyle.italic : FontStyle.normal,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildDataCell(
              width: 140,
              child: Text(
                primaryTask != null ? '${primaryTask.startTime} - ${primaryTask.endTime}' : '--:--',
                style: TextStyle(
                  color: primaryTask != null ? _textColor : _textSecondaryColor,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildDataCell(
              width: 200,
              child: Text(
                primaryTask != null ? primaryTask.workers.join('، ') : '---',
                style: TextStyle(
                  color: primaryTask != null ? _textColor : _textSecondaryColor,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildDataCell(
              width: 120,
              child: Text(
                primaryTask?.truckNumber ?? '---',
                style: TextStyle(
                  color: primaryTask != null ? _textColor : _textSecondaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildDataCell(
              width: 120,
              child: Row(
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
      
      // الصفوف الفرعية للمهام المتعددة
      if (tasks.length > 1)
        ...tasks.skip(1).map((task) => _buildSubRow(task, isEvenRow)).toList(),
    ],
  );
}

  // دالة بناء خلية بيانات
Widget _buildDataCell({required double width, required Widget child}) {
  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    alignment: Alignment.centerRight,
    child: child,
  );
}

  Widget _buildSubRow(WasteTask task, bool isEvenRow) {
  return Container(
    height: 44,
    color: isEvenRow ? Colors.grey.withOpacity(0.02) : Colors.transparent,
    child: Row(
      children: [
        _buildDataCell(
          width: 120,
          child: Row(
            children: [
              const SizedBox(width: 12),
              Icon(Icons.subdirectory_arrow_right_rounded, size: 16, color: _textSecondaryColor),
            ],
          ),
        ),
        _buildDataCell(
          width: 180,
          child: Text(
            task.areaName,
            style: const TextStyle(fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildDataCell(
          width: 140,
          child: Text(
            '${task.startTime} - ${task.endTime}',
            style: const TextStyle(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildDataCell(
          width: 200,
          child: Text(
            task.workers.join('، '),
            style: const TextStyle(fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildDataCell(
          width: 120,
          child: Text(
            task.truckNumber,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildDataCell(
          width: 120,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${task.binCount}',
              style: TextStyle(
                color: _successColor,
                fontSize: 11,
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
  // ========== شاشة البلاغات ==========
  Widget _buildComplaintsView(double screenWidth, double screenHeight) {
    List<Map<String, dynamic>> filteredComplaints = _getFilteredComplaints();
    
    return Container(
      width: screenWidth,
      height: screenHeight,
      color: _backgroundColor,
      child: Column(
        children: [
          // إحصائيات البلاغات
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildComplaintStat('إجمالي', complaints.length.toString(), Icons.report_problem_rounded, _primaryColor),
                _buildComplaintStat('جديدة', complaints.where((c) => c['status'] == 'جديد').length.toString(), Icons.new_releases_rounded, _errorColor),
                _buildComplaintStat('قيد المعالجة', complaints.where((c) => c['status'] == 'قيد المعالجة').length.toString(), Icons.sync_rounded, _warningColor),
                _buildComplaintStat('مكتملة', complaints.where((c) => c['status'] == 'مكتمل').length.toString(), Icons.check_circle_rounded, _successColor),
              ],
            ),
          ),

          // تبويبات التصفية
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildComplaintFilterChip('الكل', 0),
                _buildComplaintFilterChip('جديدة', 1),
                _buildComplaintFilterChip('قيد المعالجة', 2),
                _buildComplaintFilterChip('مكتملة', 3),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // شريط البحث
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: _buildSearchBar('ابحث عن بلاغ...'),
          ),

          const SizedBox(height: 12),

          // قائمة البلاغات
          Expanded(
            child: filteredComplaints.isEmpty
                ? _buildNoComplaintsMessage()
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredComplaints.length,
                    itemBuilder: (context, index) {
                      return _buildComplaintCard(filteredComplaints[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintStat(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: _textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildComplaintFilterChip(String label, int tabIndex) {
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
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : _textColor,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(String hintText) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: _textSecondaryColor, fontSize: 13),
          prefixIcon: Icon(Icons.search_rounded, color: _textSecondaryColor, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, color: _textSecondaryColor, size: 18),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        style: TextStyle(color: _textColor, fontSize: 14),
      ),
    );
  }

  Widget _buildNoComplaintsMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.report_off_rounded, size: 64, color: _textSecondaryColor),
          const SizedBox(height: 16),
          Text(
            'لا توجد بلاغات',
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

  Widget _buildComplaintCard(Map<String, dynamic> complaint) {
    Color statusColor = _getComplaintStatusColor(complaint['status']);
    Color priorityColor = _getPriorityColor(complaint['priority']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
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
                                color: _textColor,
                                fontSize: 15,
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
                              complaint['priority'],
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
                        style: TextStyle(color: _textSecondaryColor, fontSize: 13),
                      ),
                      Text(
                        complaint['type'],
                        style: TextStyle(color: _textSecondaryColor, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
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
                      style: TextStyle(fontSize: 10, color: _textSecondaryColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'آخر تحديث: ${_formatDateTime(complaint['lastUpdate'] as DateTime)}',
                      style: TextStyle(fontSize: 10, color: _textSecondaryColor),
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

  // ========== شاشة توزيع الفرق ==========
  Widget _buildTeamDistributionView(double screenWidth, double screenHeight) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              labelColor: _primaryColor,
              unselectedLabelColor: _textSecondaryColor,
              indicatorColor: _primaryColor,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              unselectedLabelStyle: const TextStyle(fontSize: 13),
              tabs: const [
                Tab(text: '👷 العمال'),
                Tab(text: '🚛 الشاحنات'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildWorkersView(),
                _buildTrucksView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkersView() {
    int selectedCount = _workers.where((w) => w.isSelected).length;
    int availableCount = _workers.where((w) => w.status == 'متاح').length;
    int onMissionCount = _workers.where((w) => w.status == 'في المهمة').length;
    int vacationCount = _workers.where((w) => w.status == 'إجازة').length;
    
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWorkerStat('المجموع', '${_workers.length}', _primaryColor),
                  _buildWorkerStat('متاح', '$availableCount', _successColor),
                  _buildWorkerStat('مهمة', '$onMissionCount', _warningColor),
                  _buildWorkerStat('إجازة', '$vacationCount', _errorColor),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'تم اختيار $selectedCount عامل',
                  style: TextStyle(color: _primaryColor, fontSize: 13),
                ),
              ),
            ],
          ),
        ),

        // أزرار التحكم
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.check_circle_rounded,
                  label: 'تحديد الكل',
                  color: _successColor,
                  onTap: _selectAllWorkers,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.clear_rounded,
                  label: 'إلغاء الكل',
                  color: _errorColor,
                  onTap: _deselectAllWorkers,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // قائمة العمال
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _workers.length,
            itemBuilder: (context, index) {
              return _buildWorkerCard(_workers[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWorkerStat(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: _textSecondaryColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerCard(Worker worker, int index) {
    Color statusColor = worker.status == 'متاح' ? _successColor :
                        worker.status == 'في المهمة' ? _warningColor : _errorColor;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          right: BorderSide(
            color: worker.isSelected ? _primaryColor : Colors.transparent,
            width: 5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Checkbox(
                  value: worker.isSelected,
                  onChanged: (value) {
                    _toggleWorkerSelection(index);
                  },
                  activeColor: _primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    worker.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _primaryColor.withOpacity(0.1),
                  child: Icon(Icons.person, color: _primaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        worker.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.phone, color: _textSecondaryColor, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            worker.phone,
                            style: TextStyle(color: _textSecondaryColor, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildWorkerInfoRow('القطاع', worker.sector),
                  _buildWorkerInfoRow('الراتب', worker.monthlySalary),
                  _buildWorkerInfoRow('الخبرة', '${worker.experienceYears} سنة'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: const TextStyle(color: Color(0xFF212121), fontSize: 13)),
          Text(title, style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildTrucksView() {
    int selectedCount = _availableTrucks.where((t) => t.isSelected).length;
    int readyCount = _availableTrucks.where((t) => t.status == 'جاهزة للعمل').length;
    int maintenanceCount = _availableTrucks.where((t) => t.status == 'تحت الصيانة').length;
    int busyCount = _availableTrucks.where((t) => t.status == 'مشغولة حالياً').length;
    
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTruckStat('المجموع', '${_availableTrucks.length}', _primaryColor),
                  _buildTruckStat('جاهزة', '$readyCount', _successColor),
                  _buildTruckStat('صيانة', '$maintenanceCount', _warningColor),
                  _buildTruckStat('مشغولة', '$busyCount', _errorColor),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'تم اختيار $selectedCount شاحنة',
                  style: TextStyle(color: _primaryColor, fontSize: 13),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.check_circle_rounded,
                  label: 'تحديد الكل',
                  color: _successColor,
                  onTap: _selectAllTrucks,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.clear_rounded,
                  label: 'إلغاء الكل',
                  color: _errorColor,
                  onTap: _deselectAllTrucks,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _availableTrucks.length,
            itemBuilder: (context, index) {
              return _buildTruckCard(_availableTrucks[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTruckStat(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: _textSecondaryColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTruckCard(Truck truck, int index) {
    Color statusColor = truck.status == 'جاهزة للعمل' ? _successColor :
                        truck.status == 'تحت الصيانة' ? _warningColor : _errorColor;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          right: BorderSide(
            color: truck.isSelected ? _primaryColor : Colors.transparent,
            width: 5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Checkbox(
                  value: truck.isSelected,
                  onChanged: (value) {
                    _toggleTruckSelection(index);
                  },
                  activeColor: _primaryColor,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    truck.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.local_shipping, color: _primaryColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        truck.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        truck.type,
                        style: TextStyle(
                          color: _primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildTruckInfoRow('السائق', truck.driver),
                  _buildTruckInfoRow('القطاع', truck.sector),
                  _buildTruckInfoRow('السعة', truck.capacity),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTruckInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: const TextStyle(color: Color(0xFF212121), fontSize: 13)),
          Text(title, style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  // ========== شاشة التقارير ==========
  Widget _buildReportsView(double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.assessment_rounded, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'نظام التقارير المتقدم',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildReportTypeFilter(),
          const SizedBox(height: 20),
          _buildReportOptions(),
          const SizedBox(height: 20),
          _buildGenerateReportButton(),
        ],
      ),
    );
  }

  Widget _buildReportTypeFilter() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
              borderRadius: BorderRadius.circular(12),
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
        ],
      ],
    );
  }

  Widget _buildWeeklyOptions() {
    return Wrap(
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
        );
      }).toList(),
    );
  }

  Widget _buildMonthlyOptions() {
    return Wrap(
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
        );
      }).toList(),
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
            const Icon(Icons.summarize_rounded),
            const SizedBox(width: 8),
            Text(
              'إنشاء التقرير',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showMultiDatePicker() {
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  const SizedBox(height: 16),
                  if (_selectedDates.isNotEmpty)
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
    );
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

    _showSuccessSnackbar('تم إنشاء التقرير بنجاح');
    _showGeneratedReport(reportPeriod);
  }

  void _showGeneratedReport(String period) {
    int completedTasks = _weeklyTasks.where((task) => task.isCompleted).length;
    int totalTasks = _weeklyTasks.where((task) => task.status != 'عطلة').length;
    double completionRate = totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('التقرير', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('نوع التقرير: $_selectedReportTypeSystem'),
              Text('الفترة: $period'),
              const SizedBox(height: 16),
              Text('ملخص المهام:', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
              Text('- إجمالي المهام: $totalTasks'),
              Text('- المهام المكتملة: $completedTasks'),
              Text('- نسبة الإنجاز: ${completionRate.toStringAsFixed(1)}%'),
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
              _buildPdfSummary(),
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
              'بلدية قلعة سكر',
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
            pw.Text('نوع التقرير: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(_selectedReportTypeSystem),
          ],
        ),
        pw.Row(
          children: [
            pw.Text('الفترة: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(period),
          ],
        ),
        pw.Row(
          children: [
            pw.Text('تاريخ الإنشاء: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPdfSummary() {
    int completedTasks = _weeklyTasks.where((task) => task.isCompleted).length;
    int inProgressTasks = _weeklyTasks.where((task) => task.status == 'قيد التنفيذ').length;
    int plannedTasks = _weeklyTasks.where((task) => task.status == 'مخطط').length;
    int totalTasks = _weeklyTasks.where((task) => task.status != 'عطلة').length;

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.green),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: const pw.EdgeInsets.all(15),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('ملخص المهام', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.green)),
          pw.SizedBox(height: 10),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('إجمالي المهام:'), pw.Text('$totalTasks')]),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('المهام المكتملة:'), pw.Text('$completedTasks')]),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('المهام قيد التنفيذ:'), pw.Text('$inProgressTasks')]),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('المهام المخطط لها:'), pw.Text('$plannedTasks')]),
        ],
      ),
    );
  }

  pw.Widget _buildPdfTasksDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('تفاصيل المهام', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.green)),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.green100),
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('المنطقة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('الشاحنة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('الوقت', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('الحالة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              ],
            ),
            ..._weeklyTasks.where((task) => task.status != 'عطلة').take(10).map((task) => pw.TableRow(
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(task.areaName)),
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(task.truckNumber)),
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('${task.startTime} - ${task.endTime}')),
                pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(task.status)),
              ],
            )).toList(),
          ],
        ),
      ],
    );
  }

  Future<void> _sharePdfFile(Uint8List pdfBytes, String period) async {
    try {
      final fileName = 'تقرير_قلعة_سكر_${DateTime.now().millisecondsSinceEpoch}.pdf';
      
      await Share.shareXFiles(
        [
          XFile.fromData(
            pdfBytes,
            name: fileName,
            mimeType: 'application/pdf',
          )
        ],
        subject: 'تقرير مهام النظافة - قلعة سكر',
        text: 'مرفق تقرير مهام النظافة للفترة $period',
      );

      _showSuccessSnackbar('تم تصدير التقرير بنجاح');
    } catch (e) {
      _showErrorSnackbar('خطأ في مشاركة الملف: $e');
    }
  }

  Future<void> _exportScheduleToExcel() async {
    try {
      String csvContent = 'اليوم,التاريخ,منطقة العمل,وقت البدء,وقت الانتهاء,العمال,رقم الشاحنة,عدد الحاويات,الحالة\n';
      
      final sortedTasks = List<WasteTask>.from(_weeklyTasks)
        ..sort((a, b) => a.date.compareTo(b.date));
      
      for (var task in sortedTasks) {
        final dayName = _getArabicDayName(task.date.weekday);
        final dateStr = DateFormat('yyyy/MM/dd').format(task.date);
        
        csvContent += 
          '"$dayName",' +
          '"$dateStr",' +
          '"${task.areaName}",' +
          '"${task.startTime}",' +
          '"${task.endTime}",' +
          '"${task.workers.join(" - ")}",' +
          '"${task.truckNumber}",' +
          '"${task.binCount}",' +
          '"${task.status}"\n';
      }
      
      csvContent += '\n';
      csvContent += '"الإحصائيات",,,,,,,\n';
      csvContent += '"إجمالي المهام",${_weeklyTasks.where((t) => t.status != 'عطلة').length},,,,,,,\n';
      csvContent += '"إجمالي الحاويات",${_calculateTotalBins()},,,,,,,\n';
      csvContent += '"المناطق المغطاة",${_getUniqueAreas()},,,,,,,\n';
      csvContent += '"عدد العمال",${_getUniqueWorkers()},,,,,,,\n';

      final fileName = 'جدول_مهام_قلعة_سكر_${DateTime.now().millisecondsSinceEpoch}.csv';
      final bytes = utf8.encode(csvContent);
      
      await Share.shareXFiles(
        [
          XFile.fromData(
            Uint8List.fromList(bytes),
            name: fileName,
            mimeType: 'text/csv',
          )
        ],
        subject: 'جدول مهام النظافة - قلعة سكر',
        text: 'تم تصدير جدول المهام الأسبوعي',
      );

      _showSuccessSnackbar('تم تصدير الجدول بنجاح');
    } catch (e) {
      _showErrorSnackbar('خطأ في تصدير الجدول: $e');
    }
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
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
                title: Text('تم إضافة مهمة جديدة في قلعة سكر المركز'),
                subtitle: Text('منذ 10 دقائق'),
              ),
              ListTile(
                leading: Icon(Icons.check_circle_rounded, color: Colors.green),
                title: Text('تم إكمال مهمة حي الزهور'),
                subtitle: Text('منذ ساعة'),
              ),
              ListTile(
                leading: Icon(Icons.report_problem_rounded, color: Colors.orange),
                title: Text('بلاغ جديد في السوق المركزي'),
                subtitle: Text('منذ ساعتين'),
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

  Widget _buildDrawer() {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final isDarkMode = themeProvider.isDarkMode;
  
  return Drawer(
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode 
              ? [const Color(0xFF117E75), const Color(0xFF0D4A43)]
              : [_primaryColor, const Color(0xFF0D4A43)],
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
                    ? [const Color(0xFF117E75), const Color(0xFF0D4A43)]
                    : [_primaryColor, const Color(0xFF388E3C)],
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "نظام إدارة النفايات",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  "قلعة سكر",
                  style: TextStyle(
                    color: Colors.white70,
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
              color: isDarkMode ? const Color(0xFF121212) : Colors.white,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 20),
                  
                  // عناصر القائمة
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
                    icon: Icons.logout_rounded,
                    title: 'تسجيل الخروج',
                    onTap: () {
                      _showLogoutConfirmation();
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
                        const Text(
                          'وزارة البلديات - نظام إدارة النفايات',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'الإصدار 1.0.0',
                          style: TextStyle(
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
  // ========== دالة بناء عنصر القائمة في الدراور ==========
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
  Widget _buildDrawerItem(IconData icon, String title, int tabIndex, {bool isLogout = false}) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isLogout ? Colors.red.withOpacity(0.1) : _primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isLogout ? Colors.red : _primaryColor, size: 20),
      ),
      title: Text(title, style: TextStyle(color: isLogout ? Colors.red : _textColor, fontSize: 16)),
      trailing: Icon(Icons.arrow_left_rounded, color: isLogout ? Colors.red : _textSecondaryColor),
      onTap: () {
        Navigator.pop(context);
        if (isLogout) {
          _showLogoutConfirmation();
        } else if (tabIndex >= 0) {
          _tabController.animateTo(tabIndex);
        }
      },
    );
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
      content: const Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // إغلاق نافذة التأكيد
            
            // إعادة تعيين المكدس بالكامل والذهاب إلى شاشة تسجيل الدخول
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const EsigninScreen()),
              (route) => false,
            );
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
  void _toggleWorkerSelection(int index) {
    setState(() {
      _workers[index] = Worker(
        id: _workers[index].id,
        name: _workers[index].name,
        phone: _workers[index].phone,
        isSelected: !_workers[index].isSelected,
        status: _workers[index].status,
        idNumber: _workers[index].idNumber,
        sector: _workers[index].sector,
        experienceYears: _workers[index].experienceYears,
        monthlySalary: _workers[index].monthlySalary,
        lastAttendance: _workers[index].lastAttendance,
      );
    });
  }

  void _toggleTruckSelection(int index) {
    setState(() {
      _availableTrucks[index] = Truck(
        id: _availableTrucks[index].id,
        name: _availableTrucks[index].name,
        type: _availableTrucks[index].type,
        capacity: _availableTrucks[index].capacity,
        plateNumber: _availableTrucks[index].plateNumber,
        sector: _availableTrucks[index].sector,
        districts: _availableTrucks[index].districts,
        status: _availableTrucks[index].status,
        isSelected: !_availableTrucks[index].isSelected,
        lastMaintenance: _availableTrucks[index].lastMaintenance,
        nextMaintenance: _availableTrucks[index].nextMaintenance,
        driver: _availableTrucks[index].driver,
      );
    });
  }

  void _selectAllWorkers() {
    setState(() {
      for (int i = 0; i < _workers.length; i++) {
        _workers[i] = Worker(
          id: _workers[i].id,
          name: _workers[i].name,
          phone: _workers[i].phone,
          isSelected: true,
          status: _workers[i].status,
          idNumber: _workers[i].idNumber,
          sector: _workers[i].sector,
          experienceYears: _workers[i].experienceYears,
          monthlySalary: _workers[i].monthlySalary,
          lastAttendance: _workers[i].lastAttendance,
        );
      }
    });
    _showSuccessSnackbar('تم تحديد جميع العمال');
  }

  void _deselectAllWorkers() {
    setState(() {
      for (int i = 0; i < _workers.length; i++) {
        _workers[i] = Worker(
          id: _workers[i].id,
          name: _workers[i].name,
          phone: _workers[i].phone,
          isSelected: false,
          status: _workers[i].status,
          idNumber: _workers[i].idNumber,
          sector: _workers[i].sector,
          experienceYears: _workers[i].experienceYears,
          monthlySalary: _workers[i].monthlySalary,
          lastAttendance: _workers[i].lastAttendance,
        );
      }
    });
    _showSuccessSnackbar('تم إلغاء تحديد جميع العمال');
  }

  void _selectAllTrucks() {
    setState(() {
      for (int i = 0; i < _availableTrucks.length; i++) {
        _availableTrucks[i] = Truck(
          id: _availableTrucks[i].id,
          name: _availableTrucks[i].name,
          type: _availableTrucks[i].type,
          capacity: _availableTrucks[i].capacity,
          plateNumber: _availableTrucks[i].plateNumber,
          sector: _availableTrucks[i].sector,
          districts: _availableTrucks[i].districts,
          status: _availableTrucks[i].status,
          isSelected: true,
          lastMaintenance: _availableTrucks[i].lastMaintenance,
          nextMaintenance: _availableTrucks[i].nextMaintenance,
          driver: _availableTrucks[i].driver,
        );
      }
    });
    _showSuccessSnackbar('تم تحديد جميع الشاحنات');
  }

  void _deselectAllTrucks() {
    setState(() {
      for (int i = 0; i < _availableTrucks.length; i++) {
        _availableTrucks[i] = Truck(
          id: _availableTrucks[i].id,
          name: _availableTrucks[i].name,
          type: _availableTrucks[i].type,
          capacity: _availableTrucks[i].capacity,
          plateNumber: _availableTrucks[i].plateNumber,
          sector: _availableTrucks[i].sector,
          districts: _availableTrucks[i].districts,
          status: _availableTrucks[i].status,
          isSelected: false,
          lastMaintenance: _availableTrucks[i].lastMaintenance,
          nextMaintenance: _availableTrucks[i].nextMaintenance,
          driver: _availableTrucks[i].driver,
        );
      }
    });
    _showSuccessSnackbar('تم إلغاء تحديد جميع الشاحنات');
  }  
  // دالة إظهار شاشة الإعدادات
  void _showSettingsScreen(BuildContext context, bool isDarkMode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          accentColor: _accentColor,
          darkCardColor: const Color(0xFF1E1E1E),
          cardColor: Colors.white,
          darkTextColor: Colors.white,
          textColor: const Color(0xFF212121),
          darkTextSecondaryColor: Colors.white70,
          textSecondaryColor: const Color(0xFF757575),
          onSettingsChanged: (settings) {
            print('الإعدادات المحدثة: $settings');
          },
        ),
      ),
    );
  }


}

// ========== كلاسات البيانات ==========
class WasteTask {
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

  WasteTask({
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
  final bool isSelected;
  final String status;
  final String idNumber;
  final String sector;
  final int experienceYears;
  final String monthlySalary;
  final DateTime lastAttendance;

  Worker({
    required this.id,
    required this.name,
    required this.phone,
    required this.isSelected,
    required this.status,
    required this.idNumber,
    required this.sector,
    required this.experienceYears,
    required this.monthlySalary,
    required this.lastAttendance,
  });
}

class Truck {
  final int id;
  final String name;
  final String type;
  final String capacity;
  final String plateNumber;
  final String sector;
  final List<String> districts;
  final String status;
  final bool isSelected;
  final DateTime lastMaintenance;
  final DateTime nextMaintenance;
  final String driver;

  Truck({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.plateNumber,
    required this.sector,
    required this.districts,
    required this.status,
    required this.isSelected,
    required this.lastMaintenance,
    required this.nextMaintenance,
    required this.driver,
  });
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
        content: const Text('تم حفظ الإعدادات بنجاح'),
        backgroundColor: widget.primaryColor,
        duration: const Duration(seconds: 2),
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
              const SizedBox(width: 8),
              const Text('إعادة التعيين'),
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
                
                themeProvider.toggleTheme(false);
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('تم إعادة التعيين إلى الإعدادات الافتراضية'),
                    backgroundColor: widget.primaryColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('تأكيد'),
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
        title: const Text(
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
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            _saveSettings();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded, color: Colors.white),
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
                      colors: [const Color(0xFF121212), const Color(0xFF1A1A1A)],
                    )
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [const Color(0xFFF5F5F5), const Color(0xFFE8F5E8)],
                    ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
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

                  const SizedBox(height: 24),
                  _buildSettingsSection('المظهر', Icons.palette_rounded, themeProvider),
                  
                  _buildDarkModeSwitch(themeProvider),
                  
                  _buildSettingDropdown(
                    'اللغة',
                    _language,
                    _languages,
                    (String? value) => setState(() => _language = value!),
                    themeProvider,
                  ),
                  
                  const SizedBox(height: 24),
                  _buildSettingsSection('الأمان والنسخ الاحتياطي', Icons.security_rounded, themeProvider),
                  
                  _buildSettingSwitch(
                    'النسخ الاحتياطي التلقائي',
                    'إنشاء نسخة احتياطية من البيانات تلقائياً',
                    _autoBackup,
                    (bool value) => setState(() => _autoBackup = value),
                    themeProvider,
                  ),
                  
                  _buildSettingSwitch(
                    'المصادقة البيومترية',
                    'استخدام البصمة أو الوجه لتسجيل الدخول',
                    _biometricAuth,
                    (bool value) => setState(() => _biometricAuth = value),
                    themeProvider,
                  ),
                  
                  _buildSettingSwitch(
                    'المزامنة التلقائية',
                    'مزامنة البيانات مع الخادم تلقائياً',
                    _autoSync,
                    (bool value) => setState(() => _autoSync = value),
                    themeProvider,
                  ),
                  
                  const SizedBox(height: 24),
                  _buildSettingsSection('حول التطبيق', Icons.info_rounded, themeProvider),
                  _buildAboutCard(themeProvider),

                  const SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: _saveSettings,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('حفظ الإعدادات'),
                        ),
                        const SizedBox(height: 12),
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
                  const SizedBox(height: 20),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.isDarkMode ? widget.darkCardColor : widget.cardColor,
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
              color: themeProvider.isDarkMode ? Colors.amber.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: themeProvider.isDarkMode ? Colors.amber : Colors.grey,
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
                    color: themeProvider.isDarkMode ? widget.darkTextColor : widget.textColor,
                  ),
                ),
                const SizedBox(height: 4),
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
          const SizedBox(width: 12),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.isDarkMode ? widget.darkCardColor : widget.cardColor,
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
                    color: themeProvider.isDarkMode ? widget.darkTextColor : widget.textColor,
                  ),
                ),
                const SizedBox(height: 4),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.isDarkMode ? widget.darkCardColor : widget.cardColor,
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
                color: themeProvider.isDarkMode ? widget.darkTextColor : widget.textColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
              underline: const SizedBox(),
              icon: Icon(Icons.arrow_drop_down_rounded, color: widget.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.isDarkMode ? widget.darkCardColor : widget.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
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