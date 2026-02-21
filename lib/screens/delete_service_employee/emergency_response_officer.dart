/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';

// ========== تعريفات النماذج ==========

class WasteProblem {
  final String employeeName;
  final String employeeId;
  final String problemType;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String status;

  WasteProblem({
    required this.employeeName,
    required this.employeeId,
    required this.problemType,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.status,
  });
}

class LeakageProblem {
  final String citizenName;
  final String location;
  final String area;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String status;

  LeakageProblem({
    required this.citizenName,
    required this.location,
    required this.area,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.status,
  });
}

class OdorProblem {
  final String citizenName;
  final String location;
  final String area;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String status;

  OdorProblem({
    required this.citizenName,
    required this.location,
    required this.area,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.status,
  });
}

class DamagedContainerProblem {
  final String citizenName;
  final String location;
  final String area;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String status;

  DamagedContainerProblem({
    required this.citizenName,
    required this.location,
    required this.area,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.status,
  });
}

class WasteAccumulationProblem {
  final String citizenName;
  final String area;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String status;

  WasteAccumulationProblem({
    required this.citizenName,
    required this.area,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.status,
  });
}

class OtherProblem {
  final String citizenName;
  final String area;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String problemType;
  final String status;

  OtherProblem({
    required this.citizenName,
    required this.area,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.problemType,
    required this.status,
  });
}

class BillingEmployeeProblem {
  final String citizenName;
  final String area;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String problemType;
  final String status;

  BillingEmployeeProblem({
    required this.citizenName,
    required this.area,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.problemType,
    required this.status,
  });
}

class CleaningEmployeeProblem {
  final String citizenName;
  final String area;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String problemType;
  final String status;

  CleaningEmployeeProblem({
    required this.citizenName,
    required this.area,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.problemType,
    required this.status,
  });
}

class AppCrashProblem {
  final String citizenName;
  final String area;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String problemType;
  final String status;

  AppCrashProblem({
    required this.citizenName,
    required this.area,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.problemType,
    required this.status,
  });
}

class PaymentProblem {
  final String citizenName;
  final String area;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String problemType;
  final String status;

  PaymentProblem({
    required this.citizenName,
    required this.area,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.problemType,
    required this.status,
  });
}

class UserInterfaceProblem {
  final String citizenName;
  final String area;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String problemType;
  final String status;

  UserInterfaceProblem({
    required this.citizenName,
    required this.area,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.problemType,
    required this.status,
  });
}

// ========== نموذج الحالات الطارئة ==========

class EmergencyCase {
  final String id;
  final String title;
  final String description;
  final String location;
  final String area;
  final String date;
  final String time;
  final String reportedBy;
  final String phoneNumber;
  final String severity; // حرجة - عالية - متوسطة - منخفضة
  final String status; // مستلمة - قيد المعالجة - تم الحل - مغلقة
  final String emergencyType; // تسرب خطير - حرائق - كوارث بيئية - حوادث
  final String assignedTeam;
  final String notes;
  final String imageAsset;

  EmergencyCase({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.area,
    required this.date,
    required this.time,
    required this.reportedBy,
    required this.phoneNumber,
    required this.severity,
    required this.status,
    required this.emergencyType,
    required this.assignedTeam,
    required this.notes,
    required this.imageAsset,
  });
}

// ========== الشاشة الرئيسية ==========

class ReportingOfficerWasteScreen extends StatefulWidget {
  @override
  _ReportingOfficerWasteScreenState createState() => _ReportingOfficerWasteScreenState();
}

class _ReportingOfficerWasteScreenState extends State<ReportingOfficerWasteScreen> 
    with TickerProviderStateMixin {
  
  late TabController _mainTabController;
  late TabController _wasteTabController;
  late TabController _employeeTabController;
  late TabController _appProblemTabController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  String _selectedProblem = '';
  String _problemDescription = '';
  String _problemImage = '';
  bool _showDetails = false;
  String _selectedReportType = 'اليوم';
  List<dynamic> _filteredReports = [];
  TextEditingController _searchController = TextEditingController();

  // ألوان
  final Color _primaryColor = Color(0xFF2E7D32);
  final Color _secondaryColor = Color(0xFF4CAF50);
  final Color _accentColor = Color(0xFF2196F3);
  final Color _warningColor = Color(0xFFFF9800);
  final Color _dangerColor = Color(0xFFF44336);
  final Color _infoColor = Color(0xFF00BCD4);
  final Color _darkColor = Color(0xFF333333);
  final Color _lightColor = Color(0xFFF5F5F5);
  final Color _errorColor = Color(0xffdc3545);
  final Color _emergencyColor = Color(0xFFFF5722);

  // نظام التقارير
  String _selectedArea = 'جميع المناطق';
  String _selectedReportTypeSystem = 'يومي';
  List<DateTime> _selectedDates = [];
  String? _selectedWeek;
  String? _selectedMonth;
  final List<String> _areas = ['جميع المناطق', 'حي الرياض', 'حي النخيل', 'حي العليا', 'حي الصفا'];
  final List<String> _reportTypes = ['يومي', 'أسبوعي', 'شهري'];
  final List<String> _weeks = ['الأسبوع الأول', 'الأسبوع الثاني', 'الأسبوع الثالث', 'الأسبوع الرابع'];
  final List<String> _months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
  
  // بيانات التقارير
  final List<Map<String, dynamic>> reports = [
    {
      'id': 'REP-2024-001',
      'title': 'تقرير الإيرادات الشهري للنفايات',
      'type': 'مالي',
      'period': 'يناير 2024',
      'generatedDate': DateTime.now().subtract(Duration(days: 2)),
      'totalRevenue': 5000000,
      'totalBills': 200,
      'paidBills': 180,
    },
  ];

  // بيانات العينات للتقارير
  final List<Map<String, dynamic>> _reportData = [
    {
      'area': 'حي الرياض',
      'reportsCount': 25,
      'solvedCount': 18,
      'pendingCount': 7,
      'responseTime': '2.3 ساعة',
      'satisfactionRate': 85,
    },
  ];

  final List<Map<String, dynamic>> _recentReports = [
    {
      'type': 'عدم جمع النفايات',
      'area': 'حي العليا',
      'citizen': 'أحمد محمد',
      'date': '2024-01-15',
      'time': '08:30 ص',
      'status': 'تم المعالجة',
      'priority': 'عالي',
    },
  ];

  // بيانات المشاكل لعدم جمع النفايات
  final List<WasteProblem> _wasteProblems = [
    WasteProblem(
      employeeName: 'أحمد محمد',
      employeeId: 'EMP-001',
      problemType: 'عدم جمع النفايات',
      location: 'حي السلام - شارع الملك فهد',
      date: '2024-01-15',
      time: '08:30 ص',
      description: 'لم يتم جمع النفايات من المنطقة المخصصة صباح اليوم رغم مرور موعد الجمع المعتاد. يوجد تراكم كبير للنفايات أمام المنازل.',
      imageAsset: 'assets/waste1.jpg',
      status: 'لم يتم المعالجة',
    ),
  ];

  final List<LeakageProblem> _leakageProblems = [
    LeakageProblem(
      citizenName: 'فاطمة أحمد',
      location: 'حي المصيف - شارع البحيرة',
      area: 'حي المصيف',
      date: '2024-01-16',
      time: '07:30 ص',
      description: 'تسرب شديد من حاوية النفايات أمام المبنى رقم ٤٥.',
      imageAsset: 'assets/leakage1.jpg',
      status: 'لم يتم المعالجة',
    ),
  ];

  final List<OdorProblem> _odorProblems = [
    OdorProblem(
      citizenName: 'سالم علي',
      location: 'حي الخليج - شارع البحيرة',
      area: 'حي الخليج',
      date: '2024-01-17',
      time: '02:30 م',
      description: 'روائح كريهة شديدة تنبعث من حاوية النفايات.',
      imageAsset: 'assets/odor1.jpg',
      status: 'لم يتم المعالجة',
    ),
  ];

  final List<DamagedContainerProblem> _damagedContainerProblems = [
    DamagedContainerProblem(
      citizenName: 'علي سعيد',
      location: 'حي الربيع - شارع النخيل',
      area: 'حي الربيع',
      date: '2024-01-18',
      time: '08:00 ص',
      description: 'حاوية نفايات تالفة بالكامل مع وجود صدأ شديد.',
      imageAsset: 'assets/damaged1.jpg',
      status: 'لم يتم المعالجة',
    ),
  ];

  final List<WasteAccumulationProblem> _wasteAccumulationProblems = [
    WasteAccumulationProblem(
      citizenName: 'فهد العتيبي',
      area: 'حي العليا',
      location: 'شارع الملك عبدالعزيز - مقابل المدرسة الثانوية',
      date: '2024-01-20',
      time: '09:15 ص',
      description: 'تراكم كبير للنفايات أمام العمارة رقم ٣٤ منذ ثلاثة أيام.',
      imageAsset: 'assets/accumulation1.jpg',
      status: 'لم يتم المعالجة',
    ),
  ];

  final List<OtherProblem> _otherProblems = [
    OtherProblem(
      citizenName: 'سارة عبدالله',
      area: 'حي الروضة',
      location: 'شارع الأمير سلطان - بجوار المركز الصحي',
      date: '2024-01-22',
      time: '10:30 ص',
      description: 'وجود حيوانات ضالة تتغذى على النفايات المتراكمة.',
      imageAsset: 'assets/other1.jpg',
      problemType: 'حيوانات ضالة',
      status: 'لم يتم المعالجة',
    ),
  ];

  final List<BillingEmployeeProblem> _billingEmployeeProblems = [
    BillingEmployeeProblem(
      citizenName: 'محمد أحمد',
      area: 'حي العليا',
      location: 'شارع الملك فهد - مبنى رقم ١٢٣',
      date: '2024-01-25',
      time: '10:30 ص',
      description: 'خطأ في فاتورة الشهر الحالي.',
      imageAsset: 'assets/billing1.jpg',
      problemType: 'خطأ في الفاتورة',
      status: 'لم يتم المعالجة',
    ),
  ];

  final List<CleaningEmployeeProblem> _cleaningEmployeeProblems = [
    CleaningEmployeeProblem(
      citizenName: 'علي أحمد',
      area: 'حي العليا',
      location: 'شارع الملك فهد - مقابل المسجد',
      date: '2024-01-25',
      time: '08:15 ص',
      description: 'لم يقم موظف النظافة بجمع النفايات.',
      imageAsset: 'assets/cleaning1.jpg',
      problemType: 'عدم جمع النفايات',
      status: 'لم يتم المعالجة',
    ),
  ];

  final List<AppCrashProblem> _appCrashProblems = [
    AppCrashProblem(
      citizenName: 'محمد أحمد',
      area: 'حي العليا',
      location: 'شارع الملك فهد - مبنى رقم ١٢٣',
      date: '2024-01-25',
      time: '10:30 ص',
      description: 'التطبيق يتعطل بشكل متكرر.',
      imageAsset: 'assets/app_crash1.jpg',
      problemType: 'تعطيل في التطبيق',
      status: 'لم يتم المعالجة',
    ),
  ];

  final List<PaymentProblem> _paymentProblems = [
    PaymentProblem(
      citizenName: 'أحمد محمد',
      area: 'حي العليا',
      location: 'شارع الملك فهد - مبنى رقم ١٢٣',
      date: '2024-01-25',
      time: '10:30 ص',
      description: 'فشل في عملية الدفع عبر البطاقة الائتمانية.',
      imageAsset: 'assets/payment1.jpg',
      problemType: 'فشل في عملية الدفع',
      status: 'لم يتم المعالجة',
    ),
  ];

  final List<UserInterfaceProblem> _userInterfaceProblems = [
    UserInterfaceProblem(
      citizenName: 'محمد أحمد',
      area: 'حي العليا',
      location: 'شارع الملك فهد - مبنى رقم ١٢٣',
      date: '2024-01-25',
      time: '10:30 ص',
      description: 'واجهة المستخدم غير واضحة وصعبة الاستخدام.',
      imageAsset: 'assets/ui1.jpg',
      problemType: 'صعوبة في الاستخدام',
      status: 'لم يتم المعالجة',
    ),
  ];

  // بيانات الحالات الطارئة
  final List<EmergencyCase> _emergencyCases = [
    EmergencyCase(
      id: 'EMG-2024-001',
      title: 'تسرب خطير من حاوية النفايات الطبية',
      description: 'تسرب شديد من حاوية النفايات الطبية في المستشفى المركزي، مع انتشار سوائل خطيرة على الأرض. تم عزل المنطقة ولكن هناك خطر على الصحة العامة.',
      location: 'المستشفى المركزي - شارع الملك خالد',
      area: 'حي الصفا',
      date: '2024-01-28',
      time: '14:30 م',
      reportedBy: 'د. محمد العتيبي',
      phoneNumber: '0555123456',
      severity: 'حرجة',
      status: 'قيد المعالجة',
      emergencyType: 'تسرب خطير',
      assignedTeam: 'فريق الطوارئ البيئية ١',
      notes: 'تم إرسال فريق مختص بالنفايات الخطرة. منطقة الحادث معزولة.',
      imageAsset: 'assets/emergency1.jpg',
    ),
    EmergencyCase(
      id: 'EMG-2024-002',
      title: 'حرق نفايات غير قانوني',
      description: 'حرق كميات كبيرة من النفايات في منطقة مفتوحة، مع انبعاث أدخنة سامة تؤثر على سكان المنطقة المجاورة.',
      location: 'منطقة الصناعات الخفيفة - جنوب المدينة',
      area: 'حي الصناعية',
      date: '2024-01-28',
      time: '10:15 ص',
      reportedBy: 'مواطن مجهول',
      phoneNumber: 'غير متوفر',
      severity: 'عالية',
      status: 'مستلمة',
      emergencyType: 'حرائق',
      assignedTeam: 'فريق الإطفاء والبيئة',
      notes: 'تم إبلاغ الدفاع المدني. المنطقة لا تزال تشتعل.',
      imageAsset: 'assets/emergency2.jpg',
    ),
    EmergencyCase(
      id: 'EMG-2024-003',
      title: 'انهيار جبل نفايات',
      description: 'انهيار جزئي لجبل النفايات في المكب الرئيسي، مع خطر انزلاق كامل. يحتاج إلى تدخل فوري.',
      location: 'مكب النفايات الرئيسي - طريق المطار',
      area: 'حي المطار',
      date: '2024-01-27',
      time: '18:45 م',
      reportedBy: 'عامل المكب',
      phoneNumber: '0555987654',
      severity: 'حرجة',
      status: 'تم الحل',
      emergencyType: 'كوارث بيئية',
      assignedTeam: 'فريق الهندسة البيئية',
      notes: 'تم تثبيت الجبل ووضع تدابير أمان إضافية.',
      imageAsset: 'assets/emergency3.jpg',
    ),
    EmergencyCase(
      id: 'EMG-2024-004',
      title: 'تصادم شاحنة نفايات',
      description: 'تصادم شاحنة نقل نفايات مع مركبة خاصة، مع تسرب جزئي للنفايات على الطريق الرئيسي.',
      location: 'طريق الملك فهد - تقاطع النخيل',
      area: 'حي النخيل',
      date: '2024-01-26',
      time: '08:30 ص',
      reportedBy: 'المرور',
      phoneNumber: '993',
      severity: 'متوسطة',
      status: 'مغلقة',
      emergencyType: 'حوادث',
      assignedTeam: 'فريق الطوارئ ٣',
      notes: 'تم تنظيف الطريق وإصلاح الشاحنة.',
      imageAsset: 'assets/emergency4.jpg',
    ),
  ];

  // متغيرات التصفية للحالات الطارئة
  String _selectedSeverity = 'جميع الدرجات';
  String _selectedStatus = 'جميع الحالات';
  String _selectedEmergencyType = 'جميع الأنواع';
  List<EmergencyCase> _filteredEmergencyCases = [];

  // متغيرات الإعدادات
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = false;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'العربية';

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 5, vsync: this);
    _wasteTabController = TabController(length: 6, vsync: this);
    _employeeTabController = TabController(length: 3, vsync: this);
    _appProblemTabController = TabController(length: 4, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _filteredEmergencyCases = _emergencyCases;
    _filterReports();
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _wasteTabController.dispose();
    _employeeTabController.dispose();
    _appProblemTabController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterEmergencyCases() {
    setState(() {
      _filteredEmergencyCases = _emergencyCases.where((emergency) {
        bool matchesSeverity = _selectedSeverity == 'جميع الدرجات' || emergency.severity == _selectedSeverity;
        bool matchesStatus = _selectedStatus == 'جميع الحالات' || emergency.status == _selectedStatus;
        bool matchesType = _selectedEmergencyType == 'جميع الأنواع' || emergency.emergencyType == _selectedEmergencyType;
        
        return matchesSeverity && matchesStatus && matchesType;
      }).toList();
    });
  }

  void _filterReports() {
    final now = DateTime.now();
    final searchQuery = _searchController.text.toLowerCase();
    
    setState(() {
      List<dynamic> allProblems = _getAllProblems();
      
      if (_selectedReportType == 'اليوم') {
        _filteredReports = allProblems.where((problem) {
          final problemDate = DateTime.parse(problem.date);
          final matchesDate = problemDate.year == now.year &&
                 problemDate.month == now.month &&
                 problemDate.day == now.day;
          final matchesSearch = _problemMatchesSearch(problem, searchQuery);
          return matchesDate && matchesSearch;
        }).toList();
      } else if (_selectedReportType == 'الأسبوع') {
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        _filteredReports = allProblems.where((problem) {
          final problemDate = DateTime.parse(problem.date);
          final matchesDate = problemDate.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
                 problemDate.isBefore(now.add(Duration(days: 1)));
          final matchesSearch = _problemMatchesSearch(problem, searchQuery);
          return matchesDate && matchesSearch;
        }).toList();
      } else if (_selectedReportType == 'الشهر') {
        _filteredReports = allProblems.where((problem) {
          final problemDate = DateTime.parse(problem.date);
          final matchesDate = problemDate.year == now.year &&
                 problemDate.month == now.month;
          final matchesSearch = _problemMatchesSearch(problem, searchQuery);
          return matchesDate && matchesSearch;
        }).toList();
      }
    });
  }

  bool _problemMatchesSearch(dynamic problem, String searchQuery) {
    if (searchQuery.isEmpty) return true;
    
    String name = '';
    String type = '';
    String location = '';
    String date = '';
    String time = '';
    String status = '';

    if (problem is WasteProblem) {
      name = problem.employeeName;
      type = problem.problemType;
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is LeakageProblem) {
      name = problem.citizenName;
      type = 'تسرب من الحاويات';
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is OdorProblem) {
      name = problem.citizenName;
      type = 'روائح كريهة';
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is DamagedContainerProblem) {
      name = problem.citizenName;
      type = 'حاويات تالفة';
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is WasteAccumulationProblem) {
      name = problem.citizenName;
      type = 'تراكم النفايات';
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is OtherProblem) {
      name = problem.citizenName;
      type = problem.problemType;
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is BillingEmployeeProblem) {
      name = problem.citizenName;
      type = problem.problemType;
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is CleaningEmployeeProblem) {
      name = problem.citizenName;
      type = problem.problemType;
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is AppCrashProblem) {
      name = problem.citizenName;
      type = problem.problemType;
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is PaymentProblem) {
      name = problem.citizenName;
      type = problem.problemType;
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is UserInterfaceProblem) {
      name = problem.citizenName;
      type = problem.problemType;
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is EmergencyCase) {
      name = problem.reportedBy;
      type = problem.emergencyType;
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    }

    return name.toLowerCase().contains(searchQuery) ||
           type.toLowerCase().contains(searchQuery) ||
           location.toLowerCase().contains(searchQuery) ||
           date.contains(searchQuery) ||
           time.contains(searchQuery) ||
           status.toLowerCase().contains(searchQuery);
  }

  List<dynamic> _getAllProblems() {
    return [
      ..._wasteProblems,
      ..._leakageProblems,
      ..._odorProblems,
      ..._damagedContainerProblems,
      ..._wasteAccumulationProblems,
      ..._otherProblems,
      ..._billingEmployeeProblems,
      ..._cleaningEmployeeProblems,
      ..._appCrashProblems,
      ..._paymentProblems,
      ..._userInterfaceProblems,
      ..._emergencyCases,
    ];
  }

  Color _getProblemColor(dynamic problem) {
    if (problem is WasteProblem) return _primaryColor;
    if (problem is LeakageProblem) return _warningColor;
    if (problem is OdorProblem) return _dangerColor;
    if (problem is DamagedContainerProblem) return _infoColor;
    if (problem is WasteAccumulationProblem) return _darkColor;
    if (problem is OtherProblem) return _secondaryColor;
    if (problem is BillingEmployeeProblem) return _accentColor;
    if (problem is CleaningEmployeeProblem) return _warningColor;
    if (problem is AppCrashProblem) return _dangerColor;
    if (problem is PaymentProblem) return _primaryColor;
    if (problem is UserInterfaceProblem) return _infoColor;
    if (problem is EmergencyCase) return _emergencyColor;
    return _darkColor;
  }

  IconData _getProblemIcon(dynamic problem) {
    if (problem is WasteProblem) return Icons.delete;
    if (problem is LeakageProblem) return Icons.water_damage;
    if (problem is OdorProblem) return Icons.air;
    if (problem is DamagedContainerProblem) return Icons.breakfast_dining;
    if (problem is WasteAccumulationProblem) return Icons.clean_hands;
    if (problem is OtherProblem) return Icons.more_horiz;
    if (problem is BillingEmployeeProblem) return Icons.receipt_long;
    if (problem is CleaningEmployeeProblem) return Icons.cleaning_services;
    if (problem is AppCrashProblem) return Icons.error_outline;
    if (problem is PaymentProblem) return Icons.payment;
    if (problem is UserInterfaceProblem) return Icons.phone_iphone;
    if (problem is EmergencyCase) return Icons.warning;
    return Icons.report_problem;
  }
  
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Color _cardColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
  }
  
  Color _textColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Colors.white : Color(0xFF1A2E35);
  }
  
  Color _textSecondaryColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Colors.white70 : Color(0xFF5A6C7D);
  }

  // ========== دالة التقويم المصححة ==========
  void _showMultiDatePicker() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('اختر التواريخ', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TableCalendar(
                      firstDay: DateTime.now().subtract(Duration(days: 365)),
                      lastDay: DateTime.now().add(Duration(days: 365)),
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
                        weekendTextStyle: TextStyle(color: _dangerColor),
                        defaultTextStyle: TextStyle(color: _darkColor),
                        holidayTextStyle: TextStyle(color: _warningColor),
                      ),
                      selectedDayPredicate: (day) {
                        return _selectedDates.any((selectedDate) =>
                            selectedDate.year == day.year &&
                            selectedDate.month == day.month &&
                            selectedDate.day == day.day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          bool isInList = _selectedDates.any((selectedDate) =>
                              selectedDate.year == selectedDay.year &&
                              selectedDate.month == selectedDay.month &&
                              selectedDate.day == selectedDay.day);
                          
                          if (isInList) {
                            _selectedDates.removeWhere((selectedDate) =>
                                selectedDate.year == selectedDay.year &&
                                selectedDate.month == selectedDay.month &&
                                selectedDate.day == selectedDay.day);
                          } else {
                            _selectedDates.add(selectedDay);
                          }
                        });
                      },
                    ),
                    if (_selectedDates.isNotEmpty) ...[
                      SizedBox(height: 16),
                      Text(
                        'التواريخ المختارة:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                      SizedBox(height: 8),
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
                    ] else ...[
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.grey[400], size: 48),
                            SizedBox(height: 8),
                            Text(
                              'لم يتم اختيار أي تاريخ',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            SizedBox(height: 8),
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
            ),
            actions: [
              TextButton(
                onPressed: () {
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
                child: Text('تم'),
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
    
    if (_selectedReportTypeSystem == 'يومي' && _selectedDates.isNotEmpty) {
      final sortedDates = List<DateTime>.from(_selectedDates)..sort();
      if (_selectedDates.length == 1) {
        reportPeriod = DateFormat('yyyy-MM-dd').format(_selectedDates.first);
      } else {
        reportPeriod = '${DateFormat('yyyy-MM-dd').format(sortedDates.first)} إلى ${DateFormat('yyyy-MM-dd').format(sortedDates.last)}';
      }
    } else if (_selectedReportTypeSystem == 'أسبوعي') {
      reportPeriod = _selectedWeek ?? 'غير محدد';
    } else if (_selectedReportTypeSystem == 'شهري') {
      reportPeriod = _selectedMonth ?? 'غير محدد';
    }

    _showSuccessSnackbar('تم إنشاء التقرير لـ ${_selectedDates.length} يوم بنجاح');
    _showGeneratedReport(reportPeriod);
  }

  void _showGeneratedReport(String period) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('التقرير $period', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('نوع التقرير: $_selectedReportTypeSystem', style: TextStyle(color: _darkColor)),
              if (_selectedReportTypeSystem == 'يومي' && _selectedDates.isNotEmpty)
                Text('عدد الأيام: ${_selectedDates.length}', style: TextStyle(color: _darkColor)),
              if (_selectedWeek != null)
                Text('الأسبوع: $_selectedWeek', style: TextStyle(color: _darkColor)),
              if (_selectedMonth != null)
                Text('الشهر: $_selectedMonth', style: TextStyle(color: _darkColor)),
              SizedBox(height: 16),
              Text('ملخص التقرير:', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
              Text('- إجمالي الفواتير: ${reports[0]['totalBills']}', style: TextStyle(color: _darkColor)),
              Text('- الفواتير المدفوعة: ${reports[0]['paidBills']}', style: TextStyle(color: _darkColor)),
              Text('- الفواتير غير المدفوعة: ${(reports[0]['totalBills'] as int) - (reports[0]['paidBills'] as int)}', style: TextStyle(color: _darkColor)),
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
            child: Text('تصدير PDF'),
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
              pw.Text('تقرير النظام', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('الفترة: $period'),
              pw.Text('نوع التقرير: $_selectedReportTypeSystem'),
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

  Future<void> _sharePdfFile(Uint8List pdfBytes, String period) async {
    try {
      final fileName = 'تقرير_البلاغات_${DateTime.now().millisecondsSinceEpoch}.pdf';
      
      await Share.shareXFiles(
        [
          XFile.fromData(
            pdfBytes,
            name: fileName,
            mimeType: 'application/pdf',
          )
        ],
        subject: 'تقرير البلاغات - $period',
        text: 'مرفق تقرير البلاغات للفترة $period',
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
        backgroundColor: _secondaryColor,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _dangerColor,
        duration: Duration(seconds: 4),
      ),
    );
  }

  // ========== واجهة التقارير ==========
  Widget _buildReportsView(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.assignment, color: _primaryColor, size: 24),
              ),
              SizedBox(width: 8),
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
          SizedBox(height: 20),
          _buildReportTypeFilter(),
          SizedBox(height: 20),
          _buildReportOptions(),
          SizedBox(height: 20),
          _buildGenerateReportButton(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildReportTypeFilter() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
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
            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _reportTypes.map((type) {
                  final isSelected = _selectedReportTypeSystem == type;
                  return Container(
                    margin: EdgeInsets.only(right: 8),
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
                        color: isSelected ? _primaryColor : _textColor(context),
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
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'خيارات التقرير',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor(context),
              ),
            ),
            SizedBox(height: 16),
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
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: 8),
              Text('فتح التقويم واختيار التواريخ'),
            ],
          ),
        ),
        SizedBox(height: 16),
        if (_selectedDates.isNotEmpty) ...[
          Text(
            'التواريخ المختارة:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _textColor(context),
            ),
          ),
          SizedBox(height: 8),
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
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
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
                    Text('يوم مختار'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd').format(_selectedDates.first),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textColor(context),
                      ),
                    ),
                    Text('التاريخ المختار'),
                  ],
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[400], size: 48),
                SizedBox(height: 8),
                Text(
                  'لم يتم اختيار أي تواريخ',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
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
            color: _textColor(context),
          ),
        ),
        SizedBox(height: 12),
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
                color: isSelected ? _primaryColor : _textColor(context),
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
            color: _textColor(context),
          ),
        ),
        SizedBox(height: 12),
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
                color: isSelected ? _primaryColor : _textColor(context),
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
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.summarize),
            SizedBox(width: 8),
            Text(
              'إنشاء التقرير ${_selectedReportTypeSystem == 'يومي' && _selectedDates.isNotEmpty ? '(${_selectedDates.length} يوم)' : ''}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // ========== واجهة الدراور ==========
  Widget _buildGovernmentDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_primaryColor, Color(0xFF4CAF50)],
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
                  colors: [_primaryColor, Color(0xFF388E3C)],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(
                      Icons.report_problem_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "مسؤول الإبلاغات",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "مسؤول - قسم الإبلاغات والمشاكل",
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

            Expanded(
              child: Container(
                color: Color(0xFFE8F5E9),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(height: 20),
                    _buildDrawerMenuItem(
                      icon: Icons.settings_rounded,
                      title: 'الإعدادات',
                      onTap: () {
                        Navigator.pop(context);
                        _showSettingsScreen(context);
                      },
                    ),
                    
                    _buildDrawerMenuItem(
                      icon: Icons.help_rounded,
                      title: 'المساعدة والدعم',
                      onTap: () {
                        Navigator.pop(context);
                        _showHelpSupportScreen(context);
                      },
                    ),

                    SizedBox(height: 30),
                    
                    _buildDrawerMenuItem(
                      icon: Icons.logout_rounded,
                      title: 'تسجيل الخروج',
                      onTap: () {
                        _showLogoutConfirmation(context);
                      },
                      isLogout: true,
                    ),

                    SizedBox(height: 40),
                    
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Divider(
                            color: Colors.grey[400],
                            height: 1,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'وزارة الكهرباء - نظام الإبلاغات',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'الإصدار 1.0.0',
                            style: TextStyle(
                              color: Colors.grey[600],
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
    bool isLogout = false,
  }) {
    final Color iconColor = isLogout ? Colors.red : Colors.grey[700]!;

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
                : Colors.grey[100],
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
            color: isLogout ? Colors.red : Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_left_rounded,
          color: isLogout ? Colors.red : Colors.grey[500],
          size: 24,
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout, color: _errorColor),
            SizedBox(width: 8),
            Text('تسجيل الخروج', style: TextStyle(color: _textColor(context))),
          ],
        ),
        content: Text(
          'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
          style: TextStyle(color: _textColor(context)),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor(context))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
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

  void _showSettingsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          notificationsEnabled: _notificationsEnabled,
          soundEnabled: _soundEnabled,
          vibrationEnabled: _vibrationEnabled,
          darkModeEnabled: _darkModeEnabled,
          selectedLanguage: _selectedLanguage,
          onSettingsChanged: (settings) {
            setState(() {
              _notificationsEnabled = settings['notificationsEnabled'] ?? _notificationsEnabled;
              _soundEnabled = settings['soundEnabled'] ?? _soundEnabled;
              _vibrationEnabled = settings['vibrationEnabled'] ?? _vibrationEnabled;
              _darkModeEnabled = settings['darkModeEnabled'] ?? _darkModeEnabled;
              _selectedLanguage = settings['selectedLanguage'] ?? _selectedLanguage;
            });
          },
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          accentColor: _accentColor,
          darkCardColor: _darkColor,
          cardColor: _lightColor,
          darkTextColor: Colors.white,
          textColor: _darkColor,
          darkTextSecondaryColor: Colors.white70,
          textSecondaryColor: Colors.grey[700]!,
        ),
      ),
    );
  }

  void _showHelpSupportScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HelpSupportScreen(
          isDarkMode: false,
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          accentColor: _accentColor,
          darkCardColor: _darkColor,
          cardColor: _lightColor,
          darkTextColor: Colors.white,
          textColor: _darkColor,
          darkTextSecondaryColor: Colors.white70,
          textSecondaryColor: Colors.grey[700]!,
        ),
      ),
    );
  }

  // ========== بناء الواجهة الرئيسية ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('نظام الإبلاغ عن المشاكل',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
        backgroundColor: _primaryColor,
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(2),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: TabBar(
            controller: _mainTabController,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 10,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            tabs: [
              Tab(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_outlined, size: 18),
                    SizedBox(height: 3),
                    Text('النفايات', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.people_outlined, size: 18),
                    SizedBox(height: 3),
                    Text('الموظفين', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bug_report_outlined, size: 18),
                    SizedBox(height: 3),
                    Text('المشاكل', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning, size: 18),
                    SizedBox(height: 3),
                    Text('الطوارئ', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.assignment, size: 18),
                    SizedBox(height: 3),
                    Text('التقارير', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
      drawer: _buildGovernmentDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _lightColor,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 6),
            Expanded(
              child: TabBarView(
                controller: _mainTabController,
                children: [
                  _buildWasteReportSection(),
                  _buildEmployeeReportSection(),
                  _buildAppProblemSection(),
                  _buildEmergencySection(),
                  _buildReportsView(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== قسم الحالات الطارئة مع التصفية ==========
  Widget _buildEmergencySection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس القسم
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _emergencyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.warning, color: _emergencyColor, size: 24),
              ),
              SizedBox(width: 8),
              Text(
                'الحالات الطارئة للنفايات',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _emergencyColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'نظام متكامل لإدارة الحالات الطارئة والمشاكل الخطيرة المتعلقة بالنفايات',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          
          SizedBox(height: 24),
          
          // إحصائيات الحالات الطارئة
          _buildEmergencyStats(),
          
          SizedBox(height: 24),
          
          // فلتر الحالات الطارئة - درجة الخطورة، حالة البلاغ، نوع الطوارئ فقط
          _buildEmergencyFilter(),
          
          SizedBox(height: 24),
          
          // قائمة الحالات الطارئة المصفاة
          _buildEmergencyCasesList(),
        ],
      ),
    );
  }

  Widget _buildEmergencyStats() {
    int totalCases = _emergencyCases.length;
    int criticalCases = _emergencyCases.where((c) => c.severity == 'حرجة').length;
    int activeCases = _emergencyCases.where((c) => c.status == 'مستلمة' || c.status == 'قيد المعالجة').length;
    int resolvedCases = _emergencyCases.where((c) => c.status == 'تم الحل' || c.status == 'مغلقة').length;

    return Container(
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'إحصائيات الحالات الطارئة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textColor(context),
                  ),
                ),
                Chip(
                  label: Text(
                    '${_emergencyCases.length} حالة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: _emergencyColor,
                ),
              ],
            ),
            SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildStatCard(
                  'إجمالي الحالات',
                  '$totalCases',
                  Icons.warning,
                  _emergencyColor,
                ),
                _buildStatCard(
                  'حالات حرجة',
                  '$criticalCases',
                  Icons.error,
                  _dangerColor,
                ),
                _buildStatCard(
                  'نشطة',
                  '$activeCases',
                  Icons.timelapse,
                  _warningColor,
                ),
                _buildStatCard(
                  'تم حلها',
                  '$resolvedCases',
                  Icons.check_circle,
                  _primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyFilter() {
    List<String> severityFilters = ['جميع الدرجات', 'حرجة', 'عالية', 'متوسطة', 'منخفضة'];
    List<String> statusFilters = ['جميع الحالات', 'مستلمة', 'قيد المعالجة', 'تم الحل', 'مغلقة'];
    List<String> typeFilters = ['جميع الأنواع', 'تسرب خطير', 'حرائق', 'كوارث بيئية', 'حوادث'];

    return Container(
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'فلتر الحالات الطارئة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor(context),
              ),
            ),
            SizedBox(height: 16),
            
            Text(
              'درجة الخطورة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _textColor(context),
              ),
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: severityFilters.map((severity) {
                  final isSelected = _selectedSeverity == severity;
                  return Container(
                    margin: EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(severity),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedSeverity = severity;
                          _filterEmergencyCases();
                        });
                      },
                      selectedColor: _emergencyColor.withOpacity(0.2),
                      checkmarkColor: _emergencyColor,
                      labelStyle: TextStyle(
                        color: isSelected ? _emergencyColor : _textColor(context),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: isSelected ? _emergencyColor : Colors.grey[300]!),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            
            SizedBox(height: 16),
            
            Text(
              'حالة البلاغ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _textColor(context),
              ),
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: statusFilters.map((status) {
                  final isSelected = _selectedStatus == status;
                  return Container(
                    margin: EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(status),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStatus = status;
                          _filterEmergencyCases();
                        });
                      },
                      selectedColor: _accentColor.withOpacity(0.2),
                      checkmarkColor: _accentColor,
                      labelStyle: TextStyle(
                        color: isSelected ? _accentColor : _textColor(context),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: isSelected ? _accentColor : Colors.grey[300]!),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            
            SizedBox(height: 16),
            
            Text(
              'نوع الطوارئ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _textColor(context),
              ),
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: typeFilters.map((type) {
                  final isSelected = _selectedEmergencyType == type;
                  return Container(
                    margin: EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedEmergencyType = type;
                          _filterEmergencyCases();
                        });
                      },
                      selectedColor: _warningColor.withOpacity(0.2),
                      checkmarkColor: _warningColor,
                      labelStyle: TextStyle(
                        color: isSelected ? _warningColor : _textColor(context),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: isSelected ? _warningColor : Colors.grey[300]!),
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

  Widget _buildEmergencyCasesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'الحالات الطارئة المستلمة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor(context),
              ),
            ),
            Text(
              '(${_filteredEmergencyCases.length} حالة)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        
        if (_filteredEmergencyCases.isEmpty)
          Center(
            child: Column(
              children: [
                Icon(Icons.warning_amber, size: 64, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text(
                  'لا توجد حالات طارئة تطابق معايير البحث',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'قم بتغيير معايير التصفية',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _filteredEmergencyCases.length,
            itemBuilder: (context, index) {
              final emergency = _filteredEmergencyCases[index];
              return _buildEmergencyCaseCard(emergency);
            },
          ),
      ],
    );
  }

  Widget _buildEmergencyCaseCard(EmergencyCase emergency) {
    Color severityColor = _getSeverityColor(emergency.severity);
    Color statusColor = _getStatusColor(emergency.status);
    
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          _showEmergencyDetails(emergency);
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الرأس
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: severityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.warning,
                      color: severityColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          emergency.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: severityColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'رقم الحالة: ${emergency.id}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      emergency.status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              // معلومات المبلغ
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    'المبلغ: ${emergency.reportedBy}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.phone, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    emergency.phoneNumber,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 8),
              
              // الموقع والمنطقة
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      emergency.location,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.place, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    emergency.area,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 8),
              
              // التاريخ والوقت
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    emergency.date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    emergency.time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              // وصف مختصر
              Text(
                emergency.description.length > 120 
                    ? '${emergency.description.substring(0, 120)}...' 
                    : emergency.description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: 12),
              
              // معلومات إضافية
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(
                      emergency.emergencyType,
                      style: TextStyle(
                        fontSize: 10,
                        color: _warningColor,
                      ),
                    ),
                    backgroundColor: _warningColor.withOpacity(0.1),
                  ),
                  Chip(
                    label: Text(
                      emergency.severity,
                      style: TextStyle(
                        fontSize: 10,
                        color: severityColor,
                      ),
                    ),
                    backgroundColor: severityColor.withOpacity(0.1),
                  ),
                  Chip(
                    label: Text(
                      emergency.assignedTeam,
                      style: TextStyle(
                        fontSize: 10,
                        color: _accentColor,
                      ),
                    ),
                    backgroundColor: _accentColor.withOpacity(0.1),
                  ),
                ],
              ),
              
              SizedBox(height: 8),
              
              // أزرار الإجراءات
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showEmergencyDetails(emergency);
                      },
                      icon: Icon(Icons.remove_red_eye, size: 16),
                      label: Text('عرض التفاصيل'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _accentColor,
                        side: BorderSide(color: _accentColor),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showEmergencyActions(emergency);
                      },
                      icon: Icon(Icons.play_arrow, size: 16),
                      label: Text('إجراءات'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _emergencyColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'حرجة':
        return _dangerColor;
      case 'عالية':
        return _emergencyColor;
      case 'متوسطة':
        return _warningColor;
      case 'منخفضة':
        return _infoColor;
      default:
        return _darkColor;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'مستلمة':
        return _accentColor;
      case 'قيد المعالجة':
        return _warningColor;
      case 'تم الحل':
        return _primaryColor;
      case 'مغلقة':
        return Colors.green;
      default:
        return _darkColor;
    }
  }

  void _showNewEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.add_alert, color: _emergencyColor),
            SizedBox(width: 8),
            Text('إضافة حالة طارئة جديدة'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'عنوان الحالة',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'الوصف',
                  border: OutlineInputBorder(),
                  hintText: 'وصف تفصيلي للحالة الطارئة',
                ),
                maxLines: 3,
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'الموقع',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
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
              _showSuccessSnackbar('تم إضافة الحالة الطارئة بنجاح');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _emergencyColor,
            ),
            child: Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDetails(EmergencyCase emergency) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.warning, color: _getSeverityColor(emergency.severity)),
            SizedBox(width: 8),
            Text('تفاصيل الحالة الطارئة'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                emergency.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _getSeverityColor(emergency.severity),
                ),
              ),
              SizedBox(height: 8),
              Text('رقم الحالة: ${emergency.id}'),
              SizedBox(height: 16),
              
              Text(
                'معلومات الحالة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _darkColor,
                ),
              ),
              SizedBox(height: 8),
              _buildDetailRow('نوع الطوارئ:', emergency.emergencyType),
              _buildDetailRow('درجة الخطورة:', emergency.severity),
              _buildDetailRow('الحالة:', emergency.status),
              _buildDetailRow('الفريق المكلف:', emergency.assignedTeam),
              
              SizedBox(height: 16),
              
              Text(
                'معلومات المبلغ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _darkColor,
                ),
              ),
              SizedBox(height: 8),
              _buildDetailRow('اسم المبلغ:', emergency.reportedBy),
              _buildDetailRow('رقم الهاتف:', emergency.phoneNumber),
              
              SizedBox(height: 16),
              
              Text(
                'الموقع والتوقيت',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _darkColor,
                ),
              ),
              SizedBox(height: 8),
              _buildDetailRow('المنطقة:', emergency.area),
              _buildDetailRow('الموقع:', emergency.location),
              _buildDetailRow('التاريخ:', emergency.date),
              _buildDetailRow('الوقت:', emergency.time),
              
              SizedBox(height: 16),
              
              Text(
                'وصف الحالة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _darkColor,
                ),
              ),
              SizedBox(height: 8),
              Text(emergency.description),
              
              SizedBox(height: 16),
              
              if (emergency.notes.isNotEmpty) ...[
                Text(
                  'ملاحظات إضافية',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _darkColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(emergency.notes),
                SizedBox(height: 16),
              ],
            ],
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
              _showEmergencyActions(emergency);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _emergencyColor,
            ),
            child: Text('إجراءات'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmergencyActions(EmergencyCase emergency) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.play_arrow, color: _emergencyColor),
            SizedBox(width: 8),
            Text('إجراءات الحالة الطارئة'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.update, color: _accentColor),
                title: Text('تحديث الحالة'),
                subtitle: Text('تغيير حالة البلاغ'),
                onTap: () {
                  Navigator.pop(context);
                  _showUpdateStatusDialog(emergency);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.group_add, color: _primaryColor),
                title: Text('تعيين فريق'),
                subtitle: Text('تعيين فريق معالجة جديد'),
                onTap: () {
                  Navigator.pop(context);
                  _showAssignTeamDialog(emergency);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.note_add, color: _warningColor),
                title: Text('إضافة ملاحظة'),
                subtitle: Text('إضافة ملاحظة أو تحديث'),
                onTap: () {
                  Navigator.pop(context);
                  _showAddNoteDialog(emergency);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.share, color: _infoColor),
                title: Text('مشاركة'),
                subtitle: Text('مشاركة تفاصيل الحالة'),
                onTap: () {
                  Navigator.pop(context);
                  _shareEmergencyCase(emergency);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.download, color: _secondaryColor),
                title: Text('تصدير تقرير'),
                subtitle: Text('تصدير تقرير PDF'),
                onTap: () {
                  Navigator.pop(context);
                  _exportEmergencyReport(emergency);
                },
              ),
            ],
          ),
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

  void _showUpdateStatusDialog(EmergencyCase emergency) {
    List<String> statusOptions = ['مستلمة', 'قيد المعالجة', 'تم الحل', 'مغلقة'];
    String selectedStatus = emergency.status;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('تحديث حالة البلاغ'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('اختر الحالة الجديدة للبلاغ:'),
                SizedBox(height: 16),
                ...statusOptions.map((status) {
                  return RadioListTile(
                    title: Text(status),
                    value: status,
                    groupValue: selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value.toString();
                      });
                    },
                  );
                }).toList(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSuccessSnackbar('تم تحديث حالة البلاغ إلى "$selectedStatus"');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _emergencyColor,
                ),
                child: Text('تحديث'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAssignTeamDialog(EmergencyCase emergency) {
    List<String> teams = [
      'فريق الطوارئ البيئية ١',
      'فريق الطوارئ البيئية ٢',
      'فريق الإطفاء والبيئة',
      'فريق الهندسة البيئية',
      'فريق الطوارئ ٣',
      'فريق النفايات الخطرة',
    ];

    String selectedTeam = emergency.assignedTeam;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('تعيين فريق معالجة'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('اختر الفريق المكلف بالمعالجة:'),
                SizedBox(height: 16),
                DropdownButtonFormField(
                  value: selectedTeam,
                  items: teams.map((team) {
                    return DropdownMenuItem(
                      value: team,
                      child: Text(team),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTeam = value.toString();
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSuccessSnackbar('تم تعيين الفريق "$selectedTeam" للحالة');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _emergencyColor,
                ),
                child: Text('تعيين'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddNoteDialog(EmergencyCase emergency) {
    TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('إضافة ملاحظة'),
        content: TextField(
          controller: noteController,
          decoration: InputDecoration(
            hintText: 'أدخل ملاحظة جديدة...',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (noteController.text.isNotEmpty) {
                Navigator.pop(context);
                _showSuccessSnackbar('تم إضافة الملاحظة بنجاح');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _emergencyColor,
            ),
            child: Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _shareEmergencyCase(EmergencyCase emergency) {
    String shareText = '''
📍 حالة طارئة - نظام النفايات
────────────────
🆔 رقم الحالة: ${emergency.id}
📌 العنوان: ${emergency.title}
⚠️ درجة الخطورة: ${emergency.severity}
📊 الحالة: ${emergency.status}
👥 الفريق: ${emergency.assignedTeam}
📍 الموقع: ${emergency.location}
🏙️ المنطقة: ${emergency.area}
📅 التاريخ: ${emergency.date}
⏰ الوقت: ${emergency.time}
────────────────
📋 الوصف:
${emergency.description}
────────────────
📞 المبلغ: ${emergency.reportedBy}
☎️ الهاتف: ${emergency.phoneNumber}
────────────────
📝 ملاحظات:
${emergency.notes}
    ''';

    Share.share(shareText, subject: 'حالة طارئة: ${emergency.title}');
  }

  Future<void> _exportEmergencyReport(EmergencyCase emergency) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Text('تقرير الحالة الطارئة', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('رقم الحالة: ${emergency.id}'),
              pw.Text('العنوان: ${emergency.title}'),
              pw.Text('درجة الخطورة: ${emergency.severity}'),
              pw.Text('الحالة: ${emergency.status}'),
              pw.Text('الفريق المكلف: ${emergency.assignedTeam}'),
              pw.Text('المكان: ${emergency.location}'),
              pw.Text('المنطقة: ${emergency.area}'),
              pw.Text('التاريخ: ${emergency.date}'),
              pw.Text('الوقت: ${emergency.time}'),
              pw.SizedBox(height: 20),
              pw.Text('الوصف:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text(emergency.description),
              pw.SizedBox(height: 20),
              pw.Text('معلومات المبلغ:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text('الاسم: ${emergency.reportedBy}'),
              pw.Text('رقم الهاتف: ${emergency.phoneNumber}'),
              pw.SizedBox(height: 20),
              pw.Text('ملاحظات:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text(emergency.notes),
            ];
          },
        ),
      );

      final Uint8List pdfBytes = await pdf.save();
      await _sharePdfFile(pdfBytes, 'حالة طارئة ${emergency.id}');

    } catch (e) {
      _showErrorSnackbar('خطأ في تصدير التقرير: $e');
    }
  }

  // ========== بقية الأقسام ==========
  Widget _buildWasteReportSection() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TabBar(
            controller: _wasteTabController,
            isScrollable: true,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, _secondaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: _primaryColor,
            labelStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 11,
            ),
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('عدم جمع النفايات'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('تسرب من الحاويات'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('روائح كريهة'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('حاويات تالفة'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('تراكم النفايات'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('أخرى'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _wasteTabController,
            children: [
              _buildWasteContent(),
              _buildLeakageContent(),
              _buildOdorContent(),
              _buildDamagedContainerContent(),
              _buildWasteAccumulationContent(),
              _buildOtherContent(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWasteContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.delete, color: _primaryColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات عدم جمع النفايات',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_wasteProblems.length} بلاغ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _primaryColor,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _wasteProblems.length,
            itemBuilder: (context, index) {
              final problem = _wasteProblems[index];
              return _buildGenericProblemCard(
                problem,
                _primaryColor,
                Icons.person,
                problem.employeeName,
                problem.employeeId,
                () => _showProblemDetails(problem),
                onShare: () => _showShareDialog(problem),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLeakageContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.water_damage, color: _warningColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات تسرب من الحاويات',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _warningColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_leakageProblems.length} بلاغ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _warningColor,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _leakageProblems.length,
            itemBuilder: (context, index) {
              final problem = _leakageProblems[index];
              return _buildGenericProblemCard(
                problem,
                _warningColor,
                Icons.person,
                problem.citizenName,
                problem.area,
                () => _showProblemDetails(problem),
                onShare: () => _showShareDialog(problem),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOdorContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.air, color: _dangerColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات الروائح الكريهة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _dangerColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_odorProblems.length} بلاغ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _dangerColor,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _odorProblems.length,
            itemBuilder: (context, index) {
              final problem = _odorProblems[index];
              return _buildGenericProblemCard(
                problem,
                _dangerColor,
                Icons.person,
                problem.citizenName,
                problem.area,
                () => _showProblemDetails(problem),
                onShare: () => _showShareDialog(problem),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDamagedContainerContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.breakfast_dining, color: _infoColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات حاويات تالفة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _infoColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_damagedContainerProblems.length} بلاغ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _infoColor,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _damagedContainerProblems.length,
            itemBuilder: (context, index) {
              final problem = _damagedContainerProblems[index];
              return _buildGenericProblemCard(
                problem,
                _infoColor,
                Icons.person,
                problem.citizenName,
                problem.area,
                () => _showProblemDetails(problem),
                onShare: () => _showShareDialog(problem),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWasteAccumulationContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.clean_hands, color: _darkColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات تراكم النفايات',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _darkColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_wasteAccumulationProblems.length} بلاغ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _darkColor,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _wasteAccumulationProblems.length,
            itemBuilder: (context, index) {
              final problem = _wasteAccumulationProblems[index];
              return _buildGenericProblemCard(
                problem,
                _darkColor,
                Icons.person,
                problem.citizenName,
                problem.area,
                () => _showProblemDetails(problem),
                onShare: () => _showShareDialog(problem),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOtherContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.more_horiz, color: _secondaryColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات أخرى متنوعة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _secondaryColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_otherProblems.length} بلاغ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _secondaryColor,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _otherProblems.length,
            itemBuilder: (context, index) {
              final problem = _otherProblems[index];
              return _buildGenericProblemCard(
                problem,
                _secondaryColor,
                Icons.person,
                problem.citizenName,
                problem.area,
                () => _showProblemDetails(problem),
                onShare: () => _showShareDialog(problem),
                showProblemType: true,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeReportSection() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TabBar(
            controller: _employeeTabController,
            isScrollable: true,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: [_accentColor, _infoColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: _accentColor,
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 11,
            ),
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('موظف الفواتير'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('موظف النظافة'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('أخرى'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _employeeTabController,
            children: [
              _buildBillingEmployeeContent(),
              _buildCleaningEmployeeContent(),
              _buildEmptyContent('أخرى', Icons.more_horiz, _secondaryColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBillingEmployeeContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.receipt_long, color: _accentColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات مشاكل موظف الفواتير',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _accentColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_billingEmployeeProblems.length} بلاغ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _accentColor,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _billingEmployeeProblems.length,
            itemBuilder: (context, index) {
              final problem = _billingEmployeeProblems[index];
              return _buildGenericProblemCard(
                problem,
                _accentColor,
                Icons.person,
                problem.citizenName,
                problem.area,
                () => _showProblemDetails(problem),
                onShare: () => _showShareDialog(problem),
                showProblemType: true,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCleaningEmployeeContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.cleaning_services, color: _warningColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات مشاكل موظف النظافة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _warningColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_cleaningEmployeeProblems.length} بلاغ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _warningColor,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _cleaningEmployeeProblems.length,
            itemBuilder: (context, index) {
              final problem = _cleaningEmployeeProblems[index];
              return _buildGenericProblemCard(
                problem,
                _warningColor,
                Icons.person,
                problem.citizenName,
                problem.area,
                () => _showProblemDetails(problem),
                onShare: () => _showShareDialog(problem),
                showProblemType: true,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAppProblemSection() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TabBar(
            controller: _appProblemTabController,
            isScrollable: true,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: [_dangerColor, _warningColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: _dangerColor,
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 11,
            ),
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('تعطيل في التطبيق'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('مشكلة في الدفع'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('واجهة المستخدم'),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('أخرى'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _appProblemTabController,
            children: [
              _buildAppCrashContent(),
              _buildPaymentProblemContent(),
              _buildUserInterfaceContent(),
              _buildEmptyContent('أخرى', Icons.more_horiz, _secondaryColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppCrashContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: _dangerColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات تعطيل التطبيق',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _dangerColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_appCrashProblems.length} بلاغ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _dangerColor,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _appCrashProblems.length,
            itemBuilder: (context, index) {
              final problem = _appCrashProblems[index];
              return _buildGenericProblemCard(
                problem,
                _dangerColor,
                Icons.person,
                problem.citizenName,
                problem.area,
                () => _showProblemDetails(problem),
                onShare: () => _showShareDialog(problem),
                showProblemType: true,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentProblemContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.payment, color: _primaryColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات مشاكل الدفع',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_paymentProblems.length} بلاغ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _primaryColor,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _paymentProblems.length,
            itemBuilder: (context, index) {
              final problem = _paymentProblems[index];
              return _buildGenericProblemCard(
                problem,
                _primaryColor,
                Icons.person,
                problem.citizenName,
                problem.area,
                () => _showProblemDetails(problem),
                onShare: () => _showShareDialog(problem),
                showProblemType: true,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserInterfaceContent() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.phone_iphone, color: _infoColor, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغات مشاكل واجهة المستخدم',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _infoColor,
                ),
              ),
              Spacer(),
              Chip(
                label: Text(
                  '${_userInterfaceProblems.length} بلاغ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                backgroundColor: _infoColor,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _userInterfaceProblems.length,
            itemBuilder: (context, index) {
              final problem = _userInterfaceProblems[index];
              return _buildGenericProblemCard(
                problem,
                _infoColor,
                Icons.person,
                problem.citizenName,
                problem.area,
                () => _showProblemDetails(problem),
                onShare: () => _showShareDialog(problem),
                showProblemType: true,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyContent(String title, IconData icon, Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: color.withOpacity(0.5)),
          SizedBox(height: 16),
          Text(
            'قسم $title',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'سيتم إضافة محتوى هذا القسم قريباً',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // ========== البطاقة العامة للمشاكل ==========
  Widget _buildGenericProblemCard(
    dynamic problem,
    Color color,
    IconData icon,
    String name,
    String subtitle,
    VoidCallback onTap, {
    required VoidCallback onShare,
    bool showProblemType = false,
  }) {
    Color statusColor = Colors.grey;
    if (problem.status == 'لم يتم المعالجة') {
      statusColor = _dangerColor;
    } else if (problem.status == 'قيد المعالجة') {
      statusColor = _warningColor;
    } else if (problem.status == 'تم المعالجة') {
      statusColor = _primaryColor;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withOpacity(0.1),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      problem.status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _getLocation(problem),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 4),
              
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    problem.date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    problem.time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 8),
              
              Text(
                problem.description.length > 100 
                    ? '${problem.description.substring(0, 100)}...' 
                    : problem.description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: 8),
              
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: Icon(
                  Icons.photo_camera,
                  size: 40,
                  color: Colors.grey[400],
                ),
              ),

              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: onShare,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _accentColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.share,
                          size: 14,
                          color: _accentColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'مشاركة',
                          style: TextStyle(
                            fontSize: 10,
                            color: _accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocation(dynamic problem) {
    if (problem is WasteProblem) return problem.location;
    if (problem is LeakageProblem) return problem.location;
    if (problem is OdorProblem) return problem.location;
    if (problem is DamagedContainerProblem) return problem.location;
    if (problem is WasteAccumulationProblem) return problem.location;
    if (problem is OtherProblem) return problem.location;
    if (problem is BillingEmployeeProblem) return problem.location;
    if (problem is CleaningEmployeeProblem) return problem.location;
    if (problem is AppCrashProblem) return problem.location;
    if (problem is PaymentProblem) return problem.location;
    if (problem is UserInterfaceProblem) return problem.location;
    if (problem is EmergencyCase) return problem.location;
    return '';
  }

  void _showProblemDetails(dynamic problem) {
    setState(() {
      if (problem is WasteProblem) {
        _selectedProblem = problem.problemType;
        _problemDescription = '''
الموظف: ${problem.employeeName}
رقم الموظف: ${problem.employeeId}
نوع المشكلة: ${problem.problemType}
المكان: ${problem.location}
التاريخ: ${problem.date}
الوقت: ${problem.time}
الحالة: ${problem.status}

تفاصيل المشكلة:
${problem.description}
''';
      } else if (problem is LeakageProblem) {
        _selectedProblem = 'تسرب من الحاويات';
        _problemDescription = '''
المبلغ: ${problem.citizenName}
المنطقة: ${problem.area}
الموقع: ${problem.location}
التاريخ: ${problem.date}
الوقت: ${problem.time}
الحالة: ${problem.status}

تفاصيل المشكلة:
${problem.description}
''';
      } else if (problem is OdorProblem) {
        _selectedProblem = 'روائح كريهة';
        _problemDescription = '''
المبلغ: ${problem.citizenName}
المنطقة: ${problem.area}
الموقع: ${problem.location}
التاريخ: ${problem.date}
الوقت: ${problem.time}
الحالة: ${problem.status}

تفاصيل المشكلة:
${problem.description}
''';
      } else if (problem is EmergencyCase) {
        _selectedProblem = 'حالة طارئة';
        _problemDescription = '''
رقم الحالة: ${problem.id}
العنوان: ${problem.title}
نوع الطوارئ: ${problem.emergencyType}
درجة الخطورة: ${problem.severity}
الحالة: ${problem.status}
الفريق المكلف: ${problem.assignedTeam}

المبلغ: ${problem.reportedBy}
رقم الهاتف: ${problem.phoneNumber}

المنطقة: ${problem.area}
الموقع: ${problem.location}
التاريخ: ${problem.date}
الوقت: ${problem.time}

تفاصيل المشكلة:
${problem.description}

ملاحظات:
${problem.notes}
''';
      } else {
        _selectedProblem = problem.problemType ?? 'مشكلة';
        _problemDescription = '''
المبلغ: ${problem.citizenName}
المنطقة: ${problem.area}
الموقع: ${problem.location}
التاريخ: ${problem.date}
الوقت: ${problem.time}
نوع المشكلة: ${problem.problemType}
الحالة: ${problem.status}

تفاصيل المشكلة:
${problem.description}
''';
      }
      _problemImage = problem.imageAsset;
      _showDetails = true;
    });
    _animationController.forward();
  }

  void _showShareDialog(dynamic problem) {
    String problemType = '';
    if (problem is WasteProblem) {
      problemType = problem.problemType;
    } else if (problem is LeakageProblem) {
      problemType = 'تسرب من الحاويات';
    } else if (problem is OdorProblem) {
      problemType = 'روائح كريهة';
    } else if (problem is DamagedContainerProblem) {
      problemType = 'حاويات تالفة';
    } else if (problem is WasteAccumulationProblem) {
      problemType = 'تراكم النفايات';
    } else if (problem is OtherProblem) {
      problemType = problem.problemType;
    } else if (problem is BillingEmployeeProblem) {
      problemType = problem.problemType;
    } else if (problem is CleaningEmployeeProblem) {
      problemType = problem.problemType;
    } else if (problem is AppCrashProblem) {
      problemType = problem.problemType;
    } else if (problem is PaymentProblem) {
      problemType = problem.problemType;
    } else if (problem is UserInterfaceProblem) {
      problemType = problem.problemType;
    } else if (problem is EmergencyCase) {
      problemType = 'حالة طارئة: ${problem.emergencyType}';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.share, color: _primaryColor),
              SizedBox(width: 8),
              Text(
                'مشاركة البلاغ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سيتم مشاركة هذا البلاغ مع:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _primaryColor,
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مسؤول جدولة النظافة',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _primaryColor,
                            ),
                          ),
                          Text(
                            'Cleaning Schedule Manager',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'تأكيد مشاركة بلاغ $problemType؟',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showShareSuccessMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'تأكيد المشاركة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showShareSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: _primaryColor, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'تم مشاركة البلاغ بنجاح',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget _buildProblemDetailsCard() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 25,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, _secondaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.report_problem, color: Colors.white, size: 32),
                SizedBox(height: 8),
                Text(
                  _selectedProblem,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.image,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.grey[200]!,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          _problemDescription,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            height: 1.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _animationController.reverse().then((value) {
                              setState(() {
                                _showDetails = false;
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.grey[700],
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'إلغاء',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _animationController.reverse().then((value) {
                              setState(() {
                                _showDetails = false;
                              });
                            });
                            _showSuccessMessage();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            shadowColor: _primaryColor.withOpacity(0.3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'تأكيد الإبلاغ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: _primaryColor, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'تم الإبلاغ عن المشكلة بنجاح',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }
}

// ========== شاشة الإعدادات ==========

class SettingsScreen extends StatefulWidget {
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool darkModeEnabled;
  final String selectedLanguage;
  final Function(Map<String, dynamic>) onSettingsChanged;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color darkCardColor;
  final Color cardColor;
  final Color darkTextColor;
  final Color textColor;
  final Color darkTextSecondaryColor;
  final Color textSecondaryColor;

  SettingsScreen({
    required this.notificationsEnabled,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.darkModeEnabled,
    required this.selectedLanguage,
    required this.onSettingsChanged,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.darkCardColor,
    required this.cardColor,
    required this.darkTextColor,
    required this.textColor,
    required this.darkTextSecondaryColor,
    required this.textSecondaryColor,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _notificationsEnabled;
  late bool _soundEnabled;
  late bool _vibrationEnabled;
  late bool _darkModeEnabled;
  late String _selectedLanguage;
  
  final List<String> _languages = ['العربية', 'English', 'Français', 'Español'];

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = widget.notificationsEnabled;
    _soundEnabled = widget.soundEnabled;
    _vibrationEnabled = widget.vibrationEnabled;
    _darkModeEnabled = widget.darkModeEnabled;
    _selectedLanguage = widget.selectedLanguage;
  }

  void _saveSettings() {
    final settings = {
      'notificationsEnabled': _notificationsEnabled,
      'soundEnabled': _soundEnabled,
      'vibrationEnabled': _vibrationEnabled,
      'darkModeEnabled': _darkModeEnabled,
      'selectedLanguage': _selectedLanguage,
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
        title: Text('الإعدادات'),
        backgroundColor: widget.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: Container(
        color: widget.cardColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSettingsSection(
                title: 'إعدادات التطبيق',
                icon: Icons.settings,
                children: [
                  _buildSettingItem(
                    title: 'تفعيل الإشعارات',
                    subtitle: 'تلقي إشعارات عن البلاغات والتحديثات',
                    icon: Icons.notifications,
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                  _buildSettingItem(
                    title: 'تفعيل الصوت',
                    subtitle: 'تشغيل أصوات التطبيق',
                    icon: Icons.volume_up,
                    value: _soundEnabled,
                    onChanged: (value) {
                      setState(() {
                        _soundEnabled = value;
                      });
                    },
                  ),
                  _buildSettingItem(
                    title: 'تفعيل الاهتزاز',
                    subtitle: 'اهتزاز الجهاز عند تلقي الإشعارات',
                    icon: Icons.vibration,
                    value: _vibrationEnabled,
                    onChanged: (value) {
                      setState(() {
                        _vibrationEnabled = value;
                      });
                    },
                  ),
                  _buildSettingItem(
                    title: 'تفعيل المظهر الداكن',
                    subtitle: 'تفعيل الوضع الداكن للتطبيق',
                    icon: Icons.dark_mode,
                    value: _darkModeEnabled,
                    onChanged: (value) {
                      setState(() {
                        _darkModeEnabled = value;
                      });
                    },
                  ),
                ],
              ),
              
              SizedBox(height: 24),
              
              _buildSettingsSection(
                title: 'إعدادات اللغة',
                icon: Icons.language,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedLanguage,
                      items: _languages.map((language) {
                        return DropdownMenuItem(
                          value: language,
                          child: Text(language),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'اختر اللغة',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.translate),
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 24),
              
              _buildSettingsSection(
                title: 'معلومات التطبيق',
                icon: Icons.info,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.apps),
                          title: Text('الإصدار'),
                          subtitle: Text('1.0.0'),
                          trailing: Text('أحدث إصدار'),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.update),
                          title: Text('آخر تحديث'),
                          subtitle: Text('يناير 2024'),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.storage),
                          title: Text('حجم التطبيق'),
                          subtitle: Text('50 MB'),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.developer_mode),
                          title: Text('المطور'),
                          subtitle: Text('وزارة الكهرباء'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save),
                      SizedBox(width: 8),
                      Text(
                        'حفظ الإعدادات',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    _resetSettings();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: widget.primaryColor,
                    side: BorderSide(color: widget.primaryColor),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('استعادة الإعدادات الافتراضية'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: widget.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: widget.primaryColor, size: 20),
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.textColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: widget.primaryColor, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.textSecondaryColor,
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

  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('استعادة الإعدادات الافتراضية'),
        content: Text('هل أنت متأكد من أنك تريد استعادة جميع الإعدادات إلى القيم الافتراضية؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _notificationsEnabled = true;
                _soundEnabled = true;
                _vibrationEnabled = false;
                _darkModeEnabled = false;
                _selectedLanguage = 'العربية';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم استعادة الإعدادات الافتراضية'),
                  backgroundColor: widget.primaryColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryColor,
            ),
            child: Text('تأكيد'),
          ),
        ],
      ),
    );
  }
}

// ========== شاشة المساعدة والدعم ==========

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

  HelpSupportScreen({
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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المساعدة والدعم'),
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: cardColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpSection(
                title: 'المركز الدعم الفني',
                icon: Icons.support_agent,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.phone, color: primaryColor),
                          title: Text('رقم الدعم الفني'),
                          subtitle: Text('920012345'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // إجراء الاتصال
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                            ),
                            child: Text('اتصال'),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.email, color: primaryColor),
                          title: Text('البريد الإلكتروني'),
                          subtitle: Text('support@electricity.gov.sa'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // إرسال بريد إلكتروني
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                            ),
                            child: Text('إرسال'),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.access_time, color: primaryColor),
                          title: Text('ساعات العمل'),
                          subtitle: Text('من 8 صباحاً إلى 4 مساءً'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 24),
              
              _buildHelpSection(
                title: 'الأسئلة الشائعة',
                icon: Icons.help,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildFAQItem(
                          question: 'كيف يمكنني الإبلاغ عن مشكلة؟',
                          answer: 'يمكنك الإبلاغ عن المشكلة من خلال الضغط على زر "إضافة بلاغ" في الصفحة الرئيسية.',
                        ),
                        Divider(),
                        _buildFAQItem(
                          question: 'ماذا أفعل إذا لم يتم معالجة بلاغي؟',
                          answer: 'يمكنك التواصل مع الدعم الفني على الرقم 920012345 لمتابعة حالة البلاغ.',
                        ),
                        Divider(),
                        _buildFAQItem(
                          question: 'كيف يمكنني تغيير إعدادات التطبيق؟',
                          answer: 'يمكنك الوصول إلى الإعدادات من القائمة الجانبية ثم اختيار "الإعدادات".',
                        ),
                        Divider(),
                        _buildFAQItem(
                          question: 'هل يمكنني تتبع حالة البلاغ؟',
                          answer: 'نعم، يمكنك تتبع حالة البلاغ من خلال صفحة "التقارير" في التطبيق.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 24),
              
              _buildHelpSection(
                title: 'معلومات عن التطبيق',
                icon: Icons.info,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.apps, color: primaryColor),
                          title: Text('اسم التطبيق'),
                          subtitle: Text('نظام الإبلاغ عن المشاكل'),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.code, color: primaryColor),
                          title: Text('الإصدار'),
                          subtitle: Text('1.0.0'),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.calendar_today, color: primaryColor),
                          title: Text('تاريخ الإصدار'),
                          subtitle: Text('يناير 2024'),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.business, color: primaryColor),
                          title: Text('المطور'),
                          subtitle: Text('وزارة الكهرباء'),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.description, color: primaryColor),
                          title: Text('شروط الخدمة'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // عرض شروط الخدمة
                          },
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.security, color: primaryColor),
                          title: Text('سياسة الخصوصية'),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // عرض سياسة الخصوصية
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: primaryColor, size: 20),
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            answer,
            style: TextStyle(
              fontSize: 13,
              color: textSecondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
*/
