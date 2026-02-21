import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show File, Platform;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:mang_mu/screens/employee/Employee_Shared%20Services/esignin_screen.dart';
import 'package:mang_mu/providers/theme_provider.dart';
class ReportingOfficerWaterScreen extends StatefulWidget {
  @override
  _ReportingOfficerWaterScreenState createState() => _ReportingOfficerWaterScreenState();
}

class _ReportingOfficerWaterScreenState extends State<ReportingOfficerWaterScreen> 
    with TickerProviderStateMixin {
  
  late TabController _mainTabController;
  late TabController _waterTabController;
  late TabController _employeeTabController;
  late TabController _appTabController;
  late TabController _waterSubTabController;
  late TabController _employeeSubTabController;
  late TabController _appSubTabController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  String _selectedProblem = '';
  String _problemDescription = '';
  String _problemImage = '';
  bool _showDetails = false;
  String _selectedReportType = 'اليوم';
  List<dynamic> _filteredReports = [];
  TextEditingController _searchController = TextEditingController();
  static const String screenroot = 'esignin_screen';

  // ألوان وزارة المياه الحكومية
  final Color _primaryColor = Color(0xFF0072B5); // أزرق مائي حكومي
  final Color _secondaryColor = Color(0xFF00A0DC); // أزرق فاتح
  final Color _accentColor = Color(0xFF00C1D4); // تركواز مائي
  final Color _warningColor = Color(0xFFFF9800); // برتقالي تحذير
  final Color _dangerColor = Color(0xFFD32F2F); // أحمر تحذير
  final Color _infoColor = Color(0xFF0097A7); // تركواز
  final Color _darkColor = Color(0xFF005A8C); // أزرق داكن
  final Color _lightColor = Color(0xFFF5F7FA); // خلفية فاتحة
  final Color _successColor = Color(0xFF2E7D32); // أخضر نجاح
  final Color _errorColor = Color(0xffdc3545);

  // نظام التقارير
  String _selectedArea = 'جميع المناطق';
  String _selectedReportTypeSystem = 'يومي';
  List<DateTime> _selectedDates = [];
  String? _selectedWeek;
  String? _selectedMonth;
  final List<String> _areas = ['جميع المناطق', 'المنطقة الوسطى', 'المنطقة الشرقية', 'المنطقة الغربية', 'المنطقة الشمالية'];
  final List<String> _reportTypes = ['يومي', 'أسبوعي', 'شهري'];
  final List<String> _weeks = ['الأسبوع الأول', 'الأسبوع الثاني', 'الأسبوع الثالث', 'الأسبوع الرابع'];
  final List<String> _months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
  
  // متغيرات التصفية والتبويبات الفرعية
  String _currentSubTab = 'غير مقروءة';
  Map<String, String> _subTabStatus = {
    'water': 'غير مقروءة',
    'employee': 'غير مقروءة',
    'app': 'غير مقروءة',
  };
  
  // متغيرات التصفية
  String _filterStatus = 'جميع الحالات';
  String _filterPriority = 'جميع الأولويات';
  String _filterArea = 'جميع المناطق';
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  
  // بيانات التقارير
  final List<Map<String, dynamic>> reports = [
    {
      'id': 'REP-2024-001',
      'title': 'تقرير الإيرادات الشهري',
      'type': 'مالي',
      'period': 'يناير 2024',
      'generatedDate': DateTime.now().subtract(Duration(days: 2)),
      'totalRevenue': 3000000,
      'totalBills': 150,
      'paidBills': 120,
    },
  ];

  // بيانات المشاكل للماء
  List<WaterProblem> _waterProblems = [
    WaterProblem(
      customerName: 'أحمد محمد',
      customerId: 'CUST-001',
      problemType: 'انقطاع المياه',
      location: 'حي السلام - شارع الملك فهد',
      waterStation: 'محطة تنقية المياه الرئيسية',
      date: '2024-01-15',
      time: '08:30 ص',
      duration: '3 ساعات',
      description: 'انقطاع كامل للمياه عن المنطقة منذ الساعة 8:30 صباحاً. تم إبلاغ الفنيين والمتابعة جارية.',
      imageAsset: 'assets/water_outage1.jpg',
      status: 'قيد المعالجة',
      priority: 'عالي',
      isRead: false,
      reportedDate: DateTime.now().subtract(Duration(hours: 2)),
      problemCategory: 'انقطاع المياه',
      pressureReading: null,
      meterNumber: null,
      pipelineCode: null,
    ),
    WaterProblem(
      customerName: 'سالم علي',
      customerId: 'CUST-002',
      problemType: 'مشكلة في ضغط المياه',
      location: 'حي النزهة - شارع الأمير محمد',
      waterStation: 'محطة الضخ الرئيسية',
      date: '2024-01-14',
      time: '02:00 م',
      duration: '2 ساعات',
      description: 'انخفاض شديد في ضغط المياه يؤثر على الاستخدام اليومي.',
      imageAsset: 'assets/water_pressure2.jpg',
      status: 'تم المعالجة',
      priority: 'متوسط',
      isRead: true,
      reportedDate: DateTime.now().subtract(Duration(days: 1)),
      problemCategory: 'مشكلة في ضغط المياه',
      pressureReading: '1 بار',
      meterNumber: null,
      pipelineCode: null,
    ),
    WaterProblem(
      customerName: 'فاطمة أحمد',
      customerId: 'CUST-003',
      problemType: 'تلوث المياه',
      location: 'حي المصيف - شارع البحيرة',
      waterStation: 'محطة التنقية الفرعية',
      date: '2024-01-16',
      time: '07:30 ص',
      duration: '1 ساعة',
      description: 'مياه ذات لون عكر ورائحة كريهة تصل إلى المنازل.',
      imageAsset: 'assets/water_quality1.jpg',
      status: 'لم يتم المعالجة',
      priority: 'عالي',
      isRead: false,
      reportedDate: DateTime.now().subtract(Duration(hours: 5)),
      problemCategory: 'جودة المياه',
      pressureReading: null,
      meterNumber: null,
      pipelineCode: null,
    ),
  ];

  List<WaterEmployeeProblem> _waterEmployeeProblems = [
    WaterEmployeeProblem(
      customerName: 'محمد أحمد',
      area: 'حي العليا',
      location: 'شارع الملك فهد - مبنى رقم ١٢٣',
      date: '2024-01-25',
      time: '10:30 ص',
      description: 'تأخر فني المياه في الوصول لإصلاح العطل لمدة تتجاوز 3 ساعات مع عدم التواصل لتحديد موعد جديد.',
      imageAsset: 'assets/water_technical1.jpg',
      problemType: 'موظف الصيانة',
      status: 'لم يتم المعالجة',
      isRead: false,
      reportedDate: DateTime.now().subtract(Duration(hours: 8)),
      employeeName: 'فني المياه - أحمد سعيد',
      delayHours: 3,
      employeeDepartment: 'إدارة الصيانة',
    ),
    WaterEmployeeProblem(
      customerName: 'ناصر خالد',
      area: 'حي الروضة',
      location: 'شارع الأمير سلطان - بجوار المركز الصحي',
      date: '2024-01-24',
      time: '02:20 م',
      description: 'موظف الفواتير لم يستجب لطلب تصحيح الخطأ في فاتورة المياه وتم تجاهل المكالمات الهاتفية المتكررة.',
      imageAsset: 'assets/water_billing2.jpg',
      problemType: 'موظف الفواتير',
      status: 'قيد المعالجة',
      isRead: true,
      reportedDate: DateTime.now().subtract(Duration(days: 2)),
      employeeName: 'محمد علي - قسم الفواتير',
      delayHours: 2,
      employeeDepartment: 'إدارة الفواتير',
    ),
    WaterEmployeeProblem(
      customerName: 'لطيفة علي',
      area: 'حي الورود',
      location: 'شارع الخزان - مقابل الحدائق',
      date: '2024-01-23',
      time: '11:15 ص',
      description: 'موظف الاستقبال تعامل بطريقة غير لائقة مع العميل ورفض تقديم المعلومات المطلوبة.',
      imageAsset: 'assets/water_employee1.jpg',
      problemType: 'أخرى',
      status: 'تم المعالجة',
      isRead: true,
      reportedDate: DateTime.now().subtract(Duration(days: 3)),
      employeeName: 'سالم محمد - الاستقبال',
      delayHours: 1,
      employeeDepartment: 'إدارة الخدمات',
    ),
  ];

  List<WaterAppProblem> _waterAppProblems = [
    WaterAppProblem(
      customerName: 'محمد أحمد',
      area: 'حي العليا',
      location: 'شارع الملك فهد - مبنى رقم ١٢٣',
      date: '2024-01-25',
      time: '10:30 ص',
      description: 'التطبيق يتعطل بشكل متكرر عند محاولة دفع فاتورة المياه، وعند إعادة التشغيل يفقد البيانات المدخلة.',
      imageAsset: 'assets/water_app_crash1.jpg',
      problemType: 'تعطل في التطبيق',
      status: 'لم يتم المعالجة',
      isRead: false,
      reportedDate: DateTime.now().subtract(Duration(hours: 10)),
      appVersion: '2.1.0',
      deviceType: 'Android',
    ),
    WaterAppProblem(
      customerName: 'أحمد محمد',
      area: 'حي العليا',
      location: 'شارع الملك فهد - مبنى رقم ١٢٣',
      date: '2024-01-25',
      time: '10:30 ص',
      description: 'فشل في عملية الدفع عبر البطاقة الائتمانية مع ظهور رسالة خطأ غير واضحة.',
      imageAsset: 'assets/water_payment1.jpg',
      problemType: 'مشكلة في الدفع',
      status: 'لم يتم المعالجة',
      isRead: false,
      reportedDate: DateTime.now().subtract(Duration(hours: 11)),
      appVersion: '2.1.0',
      deviceType: 'iOS',
    ),
  ];

  List<WaterPipelineProblem> _waterPipelineProblems = [
    WaterPipelineProblem(
      customerName: 'علي سعيد',
      location: 'حي الربيع - شارع النخيل',
      area: 'حي الربيع',
      pipelineCode: 'PIPE-045',
      date: '2024-01-18',
      time: '08:00 ص',
      description: 'تسرب مياه من خط الأنابيب الرئيسي مع تكون بركة مياه كبيرة.',
      imageAsset: 'assets/water_pipeline1.jpg',
      status: 'لم يتم المعالجة',
      isRead: false,
      reportedDate: DateTime.now().subtract(Duration(hours: 4)),
    ),
  ];

  List<WaterQualityProblem> _waterQualityProblems = [
    WaterQualityProblem(
      customerName: 'فهد العتيبي',
      area: 'حي العليا',
      location: 'شارع الملك عبدالعزيز - مقابل المدرسة الثانوية',
      date: '2024-01-20',
      time: '09:15 ص',
      description: 'مياه ذات رائحة كريهة ولون أصفر تصل إلى المنازل.',
      imageAsset: 'assets/water_quality2.jpg',
      status: 'لم يتم المعالجة',
      isRead: false,
      reportedDate: DateTime.now().subtract(Duration(hours: 6)),
    ),
  ];

  List<WaterConnectionProblem> _waterConnectionProblems = [
    WaterConnectionProblem(
      customerName: 'علي أحمد',
      area: 'حي العليا',
      location: 'شارع الملك فهد - مقابل المسجد',
      date: '2024-01-25',
      time: '08:15 ص',
      description: 'تأخر في توصيل خدمة المياه للمنزل الجديد.',
      imageAsset: 'assets/water_connection1.jpg',
      problemType: 'تأخر التوصيل',
      status: 'لم يتم المعالجة',
      isRead: false,
      reportedDate: DateTime.now().subtract(Duration(hours: 9)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 4, vsync: this);
    _waterTabController = TabController(length: 4, vsync: this);
    _employeeTabController = TabController(length: 3, vsync: this);
    _appTabController = TabController(length: 4, vsync: this);
    _waterSubTabController = TabController(length: 2, vsync: this);
    _employeeSubTabController = TabController(length: 2, vsync: this);
    _appSubTabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _filterReports();
    
    // إضافة مستمعين للتبويبات الفرعية
    _waterSubTabController.addListener(() {
      setState(() {
        _subTabStatus['water'] = _waterSubTabController.index == 0 ? 'غير مقروءة' : 'مقروءة';
      });
    });
    
    _employeeSubTabController.addListener(() {
      setState(() {
        _subTabStatus['employee'] = _employeeSubTabController.index == 0 ? 'غير مقروءة' : 'مقروءة';
      });
    });
    
    _appSubTabController.addListener(() {
      setState(() {
        _subTabStatus['app'] = _appSubTabController.index == 0 ? 'غير مقروءة' : 'مقروءة';
      });
    });
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _waterTabController.dispose();
    _employeeTabController.dispose();
    _appTabController.dispose();
    _waterSubTabController.dispose();
    _employeeSubTabController.dispose();
    _appSubTabController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
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

    if (problem is WaterProblem) {
      name = problem.customerName;
      type = problem.problemType;
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is WaterEmployeeProblem) {
      name = problem.customerName;
      type = problem.problemType;
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is WaterAppProblem) {
      name = problem.customerName;
      type = problem.problemType;
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is WaterPipelineProblem) {
      name = problem.customerName;
      type = 'مشكلة في خط الأنابيب';
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is WaterQualityProblem) {
      name = problem.customerName;
      type = 'جودة المياه';
      location = problem.location;
      date = problem.date;
      time = problem.time;
      status = problem.status;
    } else if (problem is WaterConnectionProblem) {
      name = problem.customerName;
      type = problem.problemType;
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
      ..._waterProblems,
      ..._waterEmployeeProblems,
      ..._waterAppProblems,
      ..._waterPipelineProblems,
      ..._waterQualityProblems,
      ..._waterConnectionProblems,
    ];
  }

  // دالة لتصفية المشاكل حسب حالة القراءة
  List<dynamic> _filterProblemsByReadStatus(List<dynamic> problems, String tabType) {
    String currentSubTab = _subTabStatus[tabType] ?? 'غير مقروءة';
    
    return problems.where((problem) {
      if (problem is WaterProblem) {
        return currentSubTab == 'غير مقروءة' ? !problem.isRead : problem.isRead;
      } else if (problem is WaterEmployeeProblem) {
        return currentSubTab == 'غير مقروءة' ? !problem.isRead : problem.isRead;
      } else if (problem is WaterAppProblem) {
        return currentSubTab == 'غير مقروءة' ? !problem.isRead : problem.isRead;
      } else if (problem is WaterPipelineProblem) {
        return currentSubTab == 'غير مقروءة' ? !problem.isRead : problem.isRead;
      } else if (problem is WaterQualityProblem) {
        return currentSubTab == 'غير مقروءة' ? !problem.isRead : problem.isRead;
      } else if (problem is WaterConnectionProblem) {
        return currentSubTab == 'غير مقروءة' ? !problem.isRead : problem.isRead;
      }
      return true;
    }).toList();
  }

  // دالة لتحديد لون المشكلة حسب الفئة
  Color _getProblemCategoryColor(String category) {
    switch (category) {
      case 'انقطاع المياه':
        return _dangerColor;
      case 'مشكلة في ضغط المياه':
        return _warningColor;
      case 'جودة المياه':
        return _infoColor;
      case 'أخرى':
        return _darkColor;
      default:
        return _primaryColor;
    }
  }

  // دالة لتحديد أيقونة المشكلة حسب الفئة
  IconData _getProblemCategoryIcon(String category) {
    switch (category) {
      case 'انقطاع المياه':
        return Icons.water_damage;
      case 'مشكلة في ضغط المياه':
        return Icons.speed;
      case 'جودة المياه':
        return Icons.water_drop;
      case 'أخرى':
        return Icons.warning;
      default:
        return Icons.error;
    }
  }

  // دالة لتحديث حالة القراءة
  void _markAsRead(dynamic problem) {
    setState(() {
      if (problem is WaterProblem) {
        final index = _waterProblems.indexWhere((p) => p.customerId == problem.customerId);
        if (index != -1) {
          _waterProblems[index] = _waterProblems[index].copyWith(isRead: true);
        }
      } else if (problem is WaterEmployeeProblem) {
        final index = _waterEmployeeProblems.indexWhere((p) => p.customerName == problem.customerName && p.reportedDate == problem.reportedDate);
        if (index != -1) {
          _waterEmployeeProblems[index] = _waterEmployeeProblems[index].copyWith(isRead: true);
        }
      } else if (problem is WaterAppProblem) {
        final index = _waterAppProblems.indexWhere((p) => p.customerName == problem.customerName && p.reportedDate == problem.reportedDate);
        if (index != -1) {
          _waterAppProblems[index] = _waterAppProblems[index].copyWith(isRead: true);
        }
      } else if (problem is WaterPipelineProblem) {
        final index = _waterPipelineProblems.indexWhere((p) => p.pipelineCode == problem.pipelineCode);
        if (index != -1) {
          _waterPipelineProblems[index] = _waterPipelineProblems[index].copyWith(isRead: true);
        }
      } else if (problem is WaterQualityProblem) {
        final index = _waterQualityProblems.indexWhere((p) => p.customerName == problem.customerName);
        if (index != -1) {
          _waterQualityProblems[index] = _waterQualityProblems[index].copyWith(isRead: true);
        }
      } else if (problem is WaterConnectionProblem) {
        final index = _waterConnectionProblems.indexWhere((p) => p.customerName == problem.customerName);
        if (index != -1) {
          _waterConnectionProblems[index] = _waterConnectionProblems[index].copyWith(isRead: true);
        }
      }
    });
  }

  // دالة لعرض خيارات التصفية
  void _showFilterOptions(String tabType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'خيارات التصفية',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _primaryColor,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 10),
                  
                  Text('الحالة:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8,
                    children: ['جميع الحالات', 'لم يتم المعالجة', 'قيد المعالجة', 'تم المعالجة'].map((status) {
                      return FilterChip(
                        label: Text(status),
                        selected: _filterStatus == status,
                        onSelected: (selected) {
                          setState(() {
                            _filterStatus = selected ? status : 'جميع الحالات';
                          });
                        },
                      );
                    }).toList(),
                  ),
                  
                  SizedBox(height: 20),
                  
                  if (tabType == 'water') ...[
                    Text('فئة المشكلة:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8,
                      children: ['جميع الفئات', 'انقطاع المياه', 'مشكلة في ضغط المياه', 'جودة المياه'].map((category) {
                        return FilterChip(
                          label: Text(category),
                          selected: _filterPriority == category,
                          onSelected: (selected) {
                            setState(() {
                              _filterPriority = selected ? category : 'جميع الفئات';
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                  ],
                  
                  Text('المنطقة:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8,
                    children: ['جميع المناطق', 'المنطقة الوسطى', 'المنطقة الشرقية', 'المنطقة الغربية'].map((area) {
                      return FilterChip(
                        label: Text(area),
                        selected: _filterArea == area,
                        onSelected: (selected) {
                          setState(() {
                            _filterArea = selected ? area : 'جميع المناطق';
                          });
                        },
                      );
                    }).toList(),
                  ),
                  
                  SizedBox(height: 20),
                  
                  Text('الفترة:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          icon: Icon(Icons.calendar_today, size: 16),
                          label: Text(_filterStartDate == null 
                            ? 'من تاريخ' 
                            : DateFormat('yyyy-MM-dd').format(_filterStartDate!),
                            style: TextStyle(fontSize: 12),
                          ),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(Duration(days: 365)),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                _filterStartDate = picked;
                              });
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          icon: Icon(Icons.calendar_today, size: 16),
                          label: Text(_filterEndDate == null 
                            ? 'إلى تاريخ' 
                            : DateFormat('yyyy-MM-dd').format(_filterEndDate!),
                            style: TextStyle(fontSize: 12),
                          ),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now().subtract(Duration(days: 365)),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                _filterEndDate = picked;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  Spacer(),
                  
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _filterStatus = 'جميع الحالات';
                              _filterPriority = 'جميع الفئات';
                              _filterArea = 'جميع المناطق';
                              _filterStartDate = null;
                              _filterEndDate = null;
                            });
                          },
                          child: Text('إعادة التعيين'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('تطبيق التصفية'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _getProblemColor(dynamic problem) {
    if (problem is WaterProblem) {
      return _getProblemCategoryColor(problem.problemCategory);
    }
    if (problem is WaterEmployeeProblem) {
      if (problem.problemType == 'موظف الصيانة') return _dangerColor;
      if (problem.problemType == 'موظف الفواتير') return _warningColor;
      return _infoColor;
    }
    if (problem is WaterAppProblem) {
      if (problem.problemType == 'تعطل في التطبيق') return _dangerColor;
      if (problem.problemType == 'مشكلة في الدفع') return _warningColor;
      if (problem.problemType == 'واجهة المستخدم') return _infoColor;
      return _darkColor;
    }
    if (problem is WaterPipelineProblem) return _darkColor;
    if (problem is WaterQualityProblem) return _dangerColor;
    if (problem is WaterConnectionProblem) return _secondaryColor;
    return _darkColor;
  }

  IconData _getProblemIcon(dynamic problem) {
    if (problem is WaterProblem) {
      return _getProblemCategoryIcon(problem.problemCategory);
    }
    if (problem is WaterEmployeeProblem) {
      if (problem.problemType == 'موظف الصيانة') return Icons.engineering;
      if (problem.problemType == 'موظف الفواتير') return Icons.receipt_long;
      return Icons.person;
    }
    if (problem is WaterAppProblem) {
      if (problem.problemType == 'تعطل في التطبيق') return Icons.error_outline;
      if (problem.problemType == 'مشكلة في الدفع') return Icons.payment;
      if (problem.problemType == 'واجهة المستخدم') return Icons.phone_iphone;
      return Icons.apps;
    }
    if (problem is WaterPipelineProblem) return Icons.water; 
    if (problem is WaterConnectionProblem) return Icons.water;
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
              pw.Text('تقرير نظام المياه', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
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
      final fileName = 'تقرير_المياه_${DateTime.now().millisecondsSinceEpoch}.pdf';
      
      await Share.shareXFiles(
        [
          XFile.fromData(
            pdfBytes,
            name: fileName,
            mimeType: 'application/pdf',
          )
        ],
        subject: 'تقرير المياه - $period',
        text: 'مرفق تقرير بلاغات المياه للفترة $period',
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

  Widget _buildReportsView(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: _primaryColor.withOpacity(0.1)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.summarize, color: _primaryColor, size: 28),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'نظام التقارير المتقدم',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'وزارة المياه - إدارة التقارير',
                          style: TextStyle(
                            color: _textSecondaryColor(context),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 20),
          
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.filter_alt, color: _primaryColor, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'فلترة التقارير',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _textColor(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildReportTypeFilter(),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 20),
          
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildReportOptions(),
            ),
          ),
          
          SizedBox(height: 20),
          
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildGenerateReportButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع التقرير',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: _textColor(context),
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _reportTypes.map((type) {
            final isSelected = _selectedReportTypeSystem == type;
            return ChoiceChip(
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
              selectedColor: _primaryColor,
              backgroundColor: Colors.grey[100],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : _textColor(context),
                fontWeight: FontWeight.bold,
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

  Widget _buildReportOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'خيارات التقرير',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _textColor(context),
          ),
        ),
        SizedBox(height: 16),
        if (_selectedReportTypeSystem == 'يومي') _buildDailyOptions(),
        if (_selectedReportTypeSystem == 'أسبوعي') _buildWeeklyOptions(),
        if (_selectedReportTypeSystem == 'شهري') _buildMonthlyOptions(),
      ],
    );
  }

  Widget _buildDailyOptions() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _showMultiDatePicker,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: _primaryColor,
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: _primaryColor),
            ),
            elevation: 0,
          ),
          icon: Icon(Icons.calendar_today, size: 20),
          label: Text('فتح التقويم واختيار التواريخ'),
        ),
        SizedBox(height: 16),
        if (_selectedDates.isNotEmpty) ...[
          Row(
            children: [
              Icon(Icons.check_circle, color: _successColor, size: 20),
              SizedBox(width: 8),
              Text(
                'التواريخ المختارة:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _textColor(context),
                ),
              ),
            ],
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
              color: _primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _primaryColor.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('${_selectedDates.length}', 'يوم', Icons.today),
                Container(height: 30, width: 1, color: Colors.grey[300]),
                _buildStatItem(DateFormat('yyyy-MM-dd').format(_selectedDates.first), 'التاريخ الأول', Icons.calendar_today),
                Container(height: 30, width: 1, color: Colors.grey[300]),
                _buildStatItem(DateFormat('yyyy-MM-dd').format(_selectedDates.last), 'التاريخ الأخير', Icons.calendar_today),
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
                  style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
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

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: _primaryColor),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
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
            return ChoiceChip(
              label: Text(week),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedWeek = selected ? week : null;
                });
              },
              selectedColor: _primaryColor,
              backgroundColor: Colors.grey[100],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : _textColor(context),
                fontWeight: FontWeight.bold,
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
            return ChoiceChip(
              label: Text(month),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedMonth = selected ? month : null;
                });
              },
              selectedColor: _primaryColor,
              backgroundColor: Colors.grey[100],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : _textColor(context),
                fontWeight: FontWeight.bold,
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

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isFormValid 
            ? LinearGradient(
                colors: [_primaryColor, _secondaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : LinearGradient(
                colors: [Colors.grey[400]!, Colors.grey[500]!],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isFormValid ? _generateReport : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.summarize, color: Colors.white, size: 24),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إنشاء التقرير ${_selectedReportTypeSystem == 'يومي' && _selectedDates.isNotEmpty ? '(${_selectedDates.length} يوم)' : ''}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'وزارة المياه - نظام التقارير',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
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

  Widget _buildGovernmentDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_primaryColor, Color(0xFF00A0DC)],
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
                  colors: [_darkColor, _primaryColor],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(
                      Icons.water_drop,
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
                    "وزارة المياه - إدارة البلاغات",
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
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'وزارة المياه',
                                  style: TextStyle(
                                    color: _primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'نظام الإبلاغات الذكي',
                                  style: TextStyle(
                                    color: _primaryColor,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'الإصدار 2.0.0',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
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
    final Color iconColor = isLogout ? Colors.red : _primaryColor;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isLogout 
                ? Colors.red.withOpacity(0.1)
                : _primaryColor.withOpacity(0.1),
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
            color: isLogout ? Colors.red : _textColor(context),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_left_rounded,
          color: isLogout ? Colors.red : _primaryColor,
          size: 24,
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text('تسجيل الخروج'),
          ],
        ),
        content: Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // هذا السطر يرجلك لواجهة تسجيل الدخول
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EsigninScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          accentColor: _accentColor,
          darkCardColor: Color(0xFF1E1E1E),
          cardColor: Colors.white,
          darkTextColor: Colors.white,
          textColor: _darkColor,
          darkTextSecondaryColor: Colors.white70,
          textSecondaryColor: Colors.grey[700]!,
          onSettingsChanged: (settings) {
            print('الإعدادات المحدثة: $settings');
          },
        ),
      ),
    );
  }

  void _showHelpSupportScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HelpSupportScreen(
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          accentColor: _accentColor,
          backgroundColor: _lightColor,
          cardColor: Colors.white,
          textColor: _darkColor,
          textSecondaryColor: Colors.grey[700]!,
          borderColor: Colors.grey[300]!,
          successColor: _successColor,
          warningColor: _warningColor,
          errorColor: _errorColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.water_drop, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text('نظام الإبلاغات - المياه',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          ],
        ),
        backgroundColor: _primaryColor,
        centerTitle: true,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
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
            onPressed: () => _showNotificationsScreen(context),
          ),
          SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _mainTabController,
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor, _secondaryColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              indicatorWeight: 4,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), // تصغير الخط
              unselectedLabelStyle: TextStyle(fontSize: 11,),
              labelPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 0), // تقليل المسافات
              labelColor: Colors.white,
              unselectedLabelColor: _primaryColor,
              tabs: [
                Tab(
                  icon: Icon(Icons.report_problem, size: 20),
                  text: 'إبلاغ المياه',
                ),
                Tab(
                  icon: Icon(Icons.person, size: 20),
                  text: 'إبلاغ الموظفين',
                ),
                Tab(
                  icon: Icon(Icons.phone_iphone, size: 20),
                  text: 'إبلاغ عن التطبيق',
                ),
                Tab(
                  icon: Icon(Icons.summarize, size: 20),
                  text: 'التقارير',
                ),
              ],
            ),
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
            SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                controller: _mainTabController,
                children: [
                  _buildWaterReportSection(),
                  _buildEmployeeReportSection(),
                  _buildAppProblemSection(),
                  _buildReportsView(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterReportSection() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TabBar(
            controller: _waterTabController,
            isScrollable: true,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: [_dangerColor, Color(0xFFFF7043)],
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
            labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            indicatorPadding: EdgeInsets.zero,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'انقطاع المياه'),
              Tab(text: 'مشكلة في ضغط المياه'),
              Tab(text: 'جودة المياه'),
              Tab(text: 'أخرى'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _waterTabController,
            children: [
              _buildWaterOutageContent(),
              _buildWaterPressureContent(),
              _buildWaterQualityContent(),
              _buildWaterOtherContent(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWaterOutageContent() {
    final filteredProblems = _waterProblems.where((problem) => problem.problemCategory == 'انقطاع المياه').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'water');
    
    return _buildWaterContentTemplate(
      title: 'بلاغات انقطاع المياه',
      icon: Icons.water_damage,
      color: _dangerColor,
      problems: filteredByReadStatus,
    );
  }

  Widget _buildWaterPressureContent() {
    final filteredProblems = _waterProblems.where((problem) => problem.problemCategory == 'مشكلة في ضغط المياه').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'water');
    
    return _buildWaterContentTemplate(
      title: 'بلاغات مشاكل ضغط المياه',
      icon: Icons.speed,
      color: _warningColor,
      problems: filteredByReadStatus,
    );
  }

  Widget _buildWaterQualityContent() {
    final filteredProblems = _waterProblems.where((problem) => problem.problemCategory == 'جودة المياه').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'water');
    
    return _buildWaterContentTemplate(
      title: 'بلاغات جودة المياه',
      icon: Icons.water_drop,
      color: _infoColor,
      problems: filteredByReadStatus,
    );
  }

  Widget _buildWaterOtherContent() {
    final filteredProblems = _waterProblems.where((problem) => problem.problemCategory == 'أخرى').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'water');
    
    return _buildWaterContentTemplate(
      title: 'بلاغات أخرى للمياه',
      icon: Icons.warning,
      color: _darkColor,
      problems: filteredByReadStatus,
    );
  }

  Widget _buildWaterContentTemplate({
    required String title,
    required IconData icon,
    required Color color,
    required List<dynamic> problems,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 24),
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
                            color: color,
                          ),
                        ),
                        Text(
                          'وزارة المياه - إدارة الخدمات',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          '${problems.where((p) => !p.isRead).length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: color,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      SizedBox(width: 4),
                      Chip(
                        label: Text(
                          'غير مقروء',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        backgroundColor: color.withOpacity(0.8),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: TabBar(
                  controller: _waterSubTabController,
                  indicator: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[600],
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('غير مقروءة'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${problems.where((p) => !p.isRead).length}',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('مقروءة'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${problems.where((p) => p.isRead).length}',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Expanded(
          child: problems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        _subTabStatus['water'] == 'غير مقروءة'
                            ? 'لا توجد بلاغات غير مقروءة'
                            : 'لا توجد بلاغات مقروءة',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _subTabStatus['water'] == 'غير مقروءة'
                            ? 'جميع البلاغات تمت قراءتها'
                            : 'لم تتم قراءة أي بلاغ بعد',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: problems.length,
                  itemBuilder: (context, index) {
                    final problem = problems[index];
                    return _buildGenericProblemCard(
                      problem,
                      color,
                      Icons.person_outline,
                      problem.customerName,
                      problem.waterStation,
                      () {
                        _markAsRead(problem);
                        _showProblemDetails(problem);
                      },
                      onShare: () => _showShareDialog(problem),
                      showPriority: true,
                      priority: problem.priority,
                      isRead: problem.isRead,
                      showCategory: true,
                      category: problem.problemCategory,
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
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TabBar(
            controller: _employeeTabController,
            isScrollable: true,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: [_infoColor, _accentColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: _infoColor,
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 11,
            ),
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            indicatorPadding: EdgeInsets.zero,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'موظف الصيانة'),
              Tab(text: 'موظف الفواتير'),
              Tab(text: 'أخرى'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _employeeTabController,
            children: [
              _buildEmployeeMaintenanceContent(),
              _buildEmployeeBillingContent(),
              _buildEmployeeOtherContent(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeMaintenanceContent() {
    final filteredProblems = _waterEmployeeProblems.where((problem) => problem.problemType == 'موظف الصيانة').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'employee');
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _dangerColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.engineering, color: _dangerColor, size: 24),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'بلاغات تقصير موظفي الصيانة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _dangerColor,
                          ),
                        ),
                        Text(
                          'وزارة المياه - إدارة الصيانة',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          '${filteredProblems.where((p) => !p.isRead).length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: _dangerColor,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      SizedBox(width: 4),
                      Chip(
                        label: Text(
                          'غير مقروء',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        backgroundColor: _dangerColor.withOpacity(0.8),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: TabBar(
                  controller: _employeeSubTabController,
                  indicator: BoxDecoration(
                    color: _dangerColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[600],
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('غير مقروءة'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${filteredProblems.where((p) => !p.isRead).length}',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('مقروءة'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${filteredProblems.where((p) => p.isRead).length}',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Expanded(
          child: filteredByReadStatus.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        _subTabStatus['employee'] == 'غير مقروءة'
                            ? 'لا توجد بلاغات غير مقروءة'
                            : 'لا توجد بلاغات مقروءة',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredByReadStatus.length,
                  itemBuilder: (context, index) {
                    final problem = filteredByReadStatus[index];
                    return _buildGenericProblemCard(
                      problem,
                      _dangerColor,
                      Icons.person_outline,
                      problem.customerName,
                      problem.area,
                      () {
                        _markAsRead(problem);
                        _showProblemDetails(problem);
                      },
                      onShare: () => _showShareDialog(problem),
                      showProblemType: true,
                      isRead: problem.isRead,
                      showEmployeeInfo: true,
                      employeeName: problem.employeeName,
                      delayHours: problem.delayHours,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmployeeBillingContent() {
    final filteredProblems = _waterEmployeeProblems.where((problem) => problem.problemType == 'موظف الفواتير').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'employee');
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _warningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.receipt_long, color: _warningColor, size: 24),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'بلاغات تقصير موظفي الفواتير',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _warningColor,
                          ),
                        ),
                        Text(
                          'وزارة المياه - إدارة الفواتير',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          '${filteredProblems.where((p) => !p.isRead).length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: _warningColor,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      SizedBox(width: 4),
                      Chip(
                        label: Text(
                          'غير مقروء',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        backgroundColor: _warningColor.withOpacity(0.8),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: TabBar(
                  controller: _employeeSubTabController,
                  indicator: BoxDecoration(
                    color: _warningColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[600],
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('غير مقروءة'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${filteredProblems.where((p) => !p.isRead).length}',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('مقروءة'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${filteredProblems.where((p) => p.isRead).length}',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Expanded(
          child: filteredByReadStatus.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        _subTabStatus['employee'] == 'غير مقروءة'
                            ? 'لا توجد بلاغات غير مقروءة'
                            : 'لا توجد بلاغات مقروءة',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredByReadStatus.length,
                  itemBuilder: (context, index) {
                    final problem = filteredByReadStatus[index];
                    return _buildGenericProblemCard(
                      problem,
                      _warningColor,
                      Icons.person_outline,
                      problem.customerName,
                      problem.area,
                      () {
                        _markAsRead(problem);
                        _showProblemDetails(problem);
                      },
                      onShare: () => _showShareDialog(problem),
                      showProblemType: true,
                      isRead: problem.isRead,
                      showEmployeeInfo: true,
                      employeeName: problem.employeeName,
                      delayHours: problem.delayHours,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmployeeOtherContent() {
    final filteredProblems = _waterEmployeeProblems.where((problem) => problem.problemType == 'أخرى').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'employee');
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _infoColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.person, color: _infoColor, size: 24),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'بلاغات أخرى عن الموظفين',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _infoColor,
                          ),
                        ),
                        Text(
                          'وزارة المياه - إدارة الموارد البشرية',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          '${filteredProblems.where((p) => !p.isRead).length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: _infoColor,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      SizedBox(width: 4),
                      Chip(
                        label: Text(
                          'غير مقروء',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        backgroundColor: _infoColor.withOpacity(0.8),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: TabBar(
                  controller: _employeeSubTabController,
                  indicator: BoxDecoration(
                    color: _infoColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[600],
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('غير مقروءة'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${filteredProblems.where((p) => !p.isRead).length}',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('مقروءة'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${filteredProblems.where((p) => p.isRead).length}',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Expanded(
          child: filteredByReadStatus.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        _subTabStatus['employee'] == 'غير مقروءة'
                            ? 'لا توجد بلاغات غير مقروءة'
                            : 'لا توجد بلاغات مقروءة',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredByReadStatus.length,
                  itemBuilder: (context, index) {
                    final problem = filteredByReadStatus[index];
                    return _buildGenericProblemCard(
                      problem,
                      _infoColor,
                      Icons.person_outline,
                      problem.customerName,
                      problem.area,
                      () {
                        _markAsRead(problem);
                        _showProblemDetails(problem);
                      },
                      onShare: () => _showShareDialog(problem),
                      showProblemType: true,
                      isRead: problem.isRead,
                      showEmployeeInfo: true,
                      employeeName: problem.employeeName,
                      delayHours: problem.delayHours,
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
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TabBar(
            controller: _appTabController,
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
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 11,
            ),
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            indicatorPadding: EdgeInsets.zero,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'تعطل في التطبيق'),
              Tab(text: 'مشكلة في الدفع'),
              Tab(text: 'واجهة المستخدم'),
              Tab(text: 'أخرى'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _appTabController,
            children: [
              _buildAppCrashContent(),
              _buildAppPaymentContent(),
              _buildAppUIUXContent(),
              _buildAppOtherContent(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppCrashContent() {
    final filteredProblems = _waterAppProblems.where((problem) => problem.problemType == 'تعطل في التطبيق').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'app');
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _dangerColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.error_outline, color: _dangerColor, size: 24),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'بلاغات تعطل التطبيق',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _dangerColor,
                          ),
                        ),
                        Text(
                          'وزارة المياه - الدعم الفني',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          '${filteredProblems.where((p) => !p.isRead).length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: _dangerColor,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      SizedBox(width: 4),
                      Chip(
                        label: Text(
                          'غير مقروء',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        backgroundColor: _dangerColor.withOpacity(0.8),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: TabBar(
                  controller: _appSubTabController,
                  indicator: BoxDecoration(
                    color: _dangerColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[600],
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('غير مقروءة'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${filteredProblems.where((p) => !p.isRead).length}',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('مقروءة'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${filteredProblems.where((p) => p.isRead).length}',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Expanded(
          child: filteredByReadStatus.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        _subTabStatus['app'] == 'غير مقروءة'
                            ? 'لا توجد بلاغات غير مقروءة'
                            : 'لا توجد بلاغات مقروءة',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredByReadStatus.length,
                  itemBuilder: (context, index) {
                    final problem = filteredByReadStatus[index];
                    return _buildGenericProblemCard(
                      problem,
                      _dangerColor,
                      Icons.person_outline,
                      problem.customerName,
                      problem.area,
                      () {
                        _markAsRead(problem);
                        _showProblemDetails(problem);
                      },
                      onShare: () => _showShareDialog(problem),
                      showProblemType: true,
                      isRead: problem.isRead,
                      showAppInfo: true,
                      appVersion: problem.appVersion,
                      deviceType: problem.deviceType,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAppPaymentContent() {
    final filteredProblems = _waterAppProblems.where((problem) => problem.problemType == 'مشكلة في الدفع').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'app');
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _warningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.payment, color: _warningColor, size: 24),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'بلاغات مشاكل الدفع',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _warningColor,
                          ),
                        ),
                        Text(
                          'وزارة المياه - الخدمات المالية',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          '${filteredProblems.where((p) => !p.isRead).length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: _warningColor,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      SizedBox(width: 4),
                      Chip(
                        label: Text(
                          'غير مقروء',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        backgroundColor: _warningColor.withOpacity(0.8),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: TabBar(
                  controller: _appSubTabController,
                  indicator: BoxDecoration(
                    color: _warningColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[600],
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('غير مقروءة'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${filteredProblems.where((p) => !p.isRead).length}',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('مقروءة'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${filteredProblems.where((p) => p.isRead).length}',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Expanded(
          child: filteredByReadStatus.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        _subTabStatus['app'] == 'غير مقروءة'
                            ? 'لا توجد بلاغات غير مقروءة'
                            : 'لا توجد بلاغات مقروءة',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredByReadStatus.length,
                  itemBuilder: (context, index) {
                    final problem = filteredByReadStatus[index];
                    return _buildGenericProblemCard(
                      problem,
                      _warningColor,
                      Icons.person_outline,
                      problem.customerName,
                      problem.area,
                      () {
                        _markAsRead(problem);
                        _showProblemDetails(problem);
                      },
                      onShare: () => _showShareDialog(problem),
                      showProblemType: true,
                      isRead: problem.isRead,
                      showAppInfo: true,
                      appVersion: problem.appVersion,
                      deviceType: problem.deviceType,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAppUIUXContent() {
    final filteredProblems = _waterAppProblems.where((problem) => problem.problemType == 'واجهة المستخدم').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'app');
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _infoColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.phone_iphone, color: _infoColor, size: 24),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'بلاغات واجهة المستخدم',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _infoColor,
                          ),
                        ),
                        Text(
                          'وزارة المياه - تجربة المستخدم',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          '${filteredProblems.where((p) => !p.isRead).length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: _infoColor,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      SizedBox(width: 4),
                      Chip(
                        label: Text(
                          'غير مقروء',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        backgroundColor: _infoColor.withOpacity(0.8),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: TabBar(
                  controller: _appSubTabController,
                  indicator: BoxDecoration(
                    color: _infoColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[600],
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('غير مقروءة'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${filteredProblems.where((p) => !p.isRead).length}',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('مقروءة'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${filteredProblems.where((p) => p.isRead).length}',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Expanded(
          child: filteredByReadStatus.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        _subTabStatus['app'] == 'غير مقروءة'
                            ? 'لا توجد بلاغات غير مقروءة'
                            : 'لا توجد بلاغات مقروءة',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredByReadStatus.length,
                  itemBuilder: (context, index) {
                    final problem = filteredByReadStatus[index];
                    return _buildGenericProblemCard(
                      problem,
                      _infoColor,
                      Icons.person_outline,
                      problem.customerName,
                      problem.area,
                      () {
                        _markAsRead(problem);
                        _showProblemDetails(problem);
                      },
                      onShare: () => _showShareDialog(problem),
                      showProblemType: true,
                      isRead: problem.isRead,
                      showAppInfo: true,
                      appVersion: problem.appVersion,
                      deviceType: problem.deviceType,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAppOtherContent() {
    final filteredProblems = _waterAppProblems.where((problem) => problem.problemType == 'أخرى').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'app');
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _darkColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.apps, color: _darkColor, size: 24),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'بلاغات أخرى عن التطبيق',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _darkColor,
                          ),
                        ),
                        Text(
                          'وزارة المياه - الدعم الفني',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          '${filteredProblems.where((p) => !p.isRead).length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: _darkColor,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      SizedBox(width: 4),
                      Chip(
                        label: Text(
                          'غير مقروء',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        backgroundColor: _darkColor.withOpacity(0.8),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: TabBar(
                  controller: _appSubTabController,
                  indicator: BoxDecoration(
                    color: _darkColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[600],
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('غير مقروءة'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${filteredProblems.where((p) => !p.isRead).length}',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('مقروءة'),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${filteredProblems.where((p) => p.isRead).length}',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Expanded(
          child: filteredByReadStatus.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        _subTabStatus['app'] == 'غير مقروءة'
                            ? 'لا توجد بلاغات غير مقروءة'
                            : 'لا توجد بلاغات مقروءة',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredByReadStatus.length,
                  itemBuilder: (context, index) {
                    final problem = filteredByReadStatus[index];
                    return _buildGenericProblemCard(
                      problem,
                      _darkColor,
                      Icons.person_outline,
                      problem.customerName,
                      problem.area,
                      () {
                        _markAsRead(problem);
                        _showProblemDetails(problem);
                      },
                      onShare: () => _showShareDialog(problem),
                      showProblemType: true,
                      isRead: problem.isRead,
                      showAppInfo: true,
                      appVersion: problem.appVersion,
                      deviceType: problem.deviceType,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildGenericProblemCard(
    dynamic problem,
    Color color,
    IconData icon,
    String name,
    String subtitle,
    VoidCallback onTap, {
    required VoidCallback onShare,
    bool showProblemType = false,
    bool showPriority = false,
    String priority = '',
    required bool isRead,
    bool showCategory = false,
    String category = '',
    bool showEmployeeInfo = false,
    String employeeName = '',
    int delayHours = 0,
    bool showAppInfo = false,
    String appVersion = '',
    String deviceType = '',
  }) {
    Color statusColor = Colors.grey;
    if (problem.status == 'لم يتم المعالجة') {
      statusColor = _dangerColor;
    } else if (problem.status == 'قيد المعالجة') {
      statusColor = _warningColor;
    } else if (problem.status == 'تم المعالجة') {
      statusColor = _successColor;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12, left: 4, right: 4),
      elevation: isRead ? 1 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isRead ? Colors.grey[200]! : color.withOpacity(0.3),
          width: isRead ? 1 : 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color.withOpacity(isRead ? 0.05 : 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: color.withOpacity(isRead ? 0.1 : 0.3),
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: color,
                          size: 22,
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
                                fontSize: 15,
                                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                color: isRead ? Colors.grey[700] : color,
                              ),
                            ),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 11,
                                color: isRead ? Colors.grey[500] : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(isRead ? 0.05 : 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: statusColor.withOpacity(isRead ? 0.2 : 0.3)),
                        ),
                        child: Text(
                          problem.status,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 12),
                  
                  if (!isRead) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _dangerColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.mark_email_unread,
                            size: 12,
                            color: _dangerColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'جديد',
                            style: TextStyle(
                              fontSize: 11,
                              color: _dangerColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                  
                  if (showCategory && category.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(isRead ? 0.05 : 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 11,
                          color: isRead ? color.withOpacity(0.8) : color,
                          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                  
                  if (showProblemType && problem.problemType != null) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(isRead ? 0.05 : 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        problem.problemType,
                        style: TextStyle(
                          fontSize: 11,
                          color: isRead ? _primaryColor.withOpacity(0.8) : _primaryColor,
                          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                  
                  if (showPriority) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: priority == 'عالي' ? _dangerColor.withOpacity(isRead ? 0.05 : 0.1) : _warningColor.withOpacity(isRead ? 0.05 : 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            priority == 'عالي' ? Icons.warning : Icons.info,
                            size: 12,
                            color: priority == 'عالي' ? _dangerColor : _warningColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'أولوية: $priority',
                            style: TextStyle(
                              fontSize: 11,
                              color: priority == 'عالي' ? _dangerColor : _warningColor,
                              fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                  
                  if (showEmployeeInfo && employeeName.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _infoColor.withOpacity(isRead ? 0.05 : 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person,
                            size: 12,
                            color: _infoColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'الموظف: $employeeName',
                            style: TextStyle(
                              fontSize: 11,
                              color: _infoColor,
                              fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                          if (delayHours > 0) ...[
                            SizedBox(width: 8),
                            Icon(
                              Icons.timer,
                              size: 12,
                              color: _dangerColor,
                            ),
                            SizedBox(width: 2),
                            Text(
                              'تأخر: ${delayHours} ساعة',
                              style: TextStyle(
                                fontSize: 11,
                                color: _dangerColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                  
                  if (showAppInfo) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _accentColor.withOpacity(isRead ? 0.05 : 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.phone_iphone,
                            size: 12,
                            color: _accentColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '$deviceType - الإصدار: $appVersion',
                            style: TextStyle(
                              fontSize: 11,
                              color: _accentColor,
                              fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                  
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _getLocation(problem),
                          style: TextStyle(
                            fontSize: 11,
                            color: isRead ? Colors.grey[500] : Colors.grey[700],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 4),
                  
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        problem.date,
                        style: TextStyle(
                          fontSize: 11,
                          color: isRead ? Colors.grey[500] : Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.access_time, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        problem.time,
                        style: TextStyle(
                          fontSize: 11,
                          color: isRead ? Colors.grey[500] : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 12),
                  
                  Text(
                    problem.description.length > 120 
                        ? '${problem.description.substring(0, 120)}...' 
                        : problem.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isRead ? Colors.grey[600] : Colors.grey[800],
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: 12),
                  
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_camera,
                            size: 32,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 4),
                          Text(
                            'صورة البلاغ',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: onShare,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _accentColor.withOpacity(isRead ? 0.05 : 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _accentColor.withOpacity(isRead ? 0.2 : 0.3)),
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
                                'مشاركة مع المسؤول',
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
                      SizedBox(width: 8),
                      if (!isRead)
                        InkWell(
                          onTap: () => _markAsRead(problem),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _successColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: _successColor.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.mark_email_read,
                                  size: 14,
                                  color: _successColor,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'تحديد كمقروء',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: _successColor,
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
            if (isRead)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 10, color: Colors.grey[600]),
                      SizedBox(width: 2),
                      Text(
                        'مقروء',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
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

  String _getLocation(dynamic problem) {
    if (problem is WaterProblem) return problem.location;
    if (problem is WaterEmployeeProblem) return problem.location;
    if (problem is WaterAppProblem) return problem.location;
    if (problem is WaterPipelineProblem) return problem.location;
    if (problem is WaterQualityProblem) return problem.location;
    if (problem is WaterConnectionProblem) return problem.location;
    return '';
  }

  void _showProblemDetails(dynamic problem) {
    String details = '';
    String imageCaption = '';
    
    if (problem is WaterProblem) {
      details = '''
🏢 **وزارة المياه - نظام الإبلاغات**
📋 **تفاصيل البلاغ**

👤 **العميل:** ${problem.customerName}
🆔 **رقم العميل:** ${problem.customerId}
🔧 **نوع المشكلة:** ${problem.problemType}
📊 **فئة المشكلة:** ${problem.problemCategory}
🏭 **محطة المياه:** ${problem.waterStation}
📍 **الموقع:** ${problem.location}
📅 **التاريخ:** ${problem.date}
⏰ **الوقت:** ${problem.time}
⏳ **المدة:** ${problem.duration}
💧 **الأولوية:** ${problem.priority}
📌 **الحالة:** ${problem.status}

📝 **وصف المشكلة:**
${problem.description}

📸 **صورة البلاغ:**
تم رفع صورة توضح المشكلة بواسطة العميل

🗺️ **الموقع الدقيق:**
تم تحديد الموقع الجغرافي عبر نظام التتبع

📊 **معلومات إضافية:'''
      + (problem.pressureReading != null ? '\n💧 **قراءة الضغط:** ${problem.pressureReading}' : '')
      + (problem.meterNumber != null ? '\n🔢 **رقم العداد:** ${problem.meterNumber}' : '')
      + (problem.pipelineCode != null ? '\n🏭 **كود خط الأنابيب:** ${problem.pipelineCode}' : '')
      + '''
      
🚨 **إجراءات الصيانة:**
تم إرسال البلاغ إلى فريق الصيانة للتعامل الفوري
      ''';
      imageCaption = 'صورة توضح مشكلة المياه';
      
    } else if (problem is WaterEmployeeProblem) {
      details = '''
🏢 **وزارة المياه - نظام الإبلاغات**
📋 **تفاصيل بلاغ تقصير الموظف**

👤 **العميل:** ${problem.customerName}
👨‍💼 **نوع الموظف:** ${problem.problemType}
📋 **اسم الموظف:** ${problem.employeeName}
🏘️ **الإدارة:** ${problem.employeeDepartment}
📍 **الموقع:** ${problem.location}
📅 **التاريخ:** ${problem.date}
⏰ **الوقت:** ${problem.time}
⏳ **ساعات التأخير:** ${problem.delayHours} ساعة
📌 **الحالة:** ${problem.status}

📝 **وصف المشكلة:**
${problem.description}

📸 **صورة البلاغ:**
تم رفع صورة توضح المشكلة بواسطة العميل

💼 **نوع البلاغ:** تقصير في أداء الواجب
🎯 **درجة الخطورة:** متوسطة
      ''';
      imageCaption = 'صورة توضح المشكلة مع الموظف';
      
    } else if (problem is WaterAppProblem) {
      details = '''
🏢 **وزارة المياه - نظام الإبلاغات**
📋 **تفاصيل بلاغ مشكلة التطبيق**

👤 **العميل:** ${problem.customerName}
📱 **نوع المشكلة:** ${problem.problemType}
📊 **إصدار التطبيق:** ${problem.appVersion}
📟 **نوع الجهاز:** ${problem.deviceType}
📍 **الموقع:** ${problem.location}
📅 **التاريخ:** ${problem.date}
⏰ **الوقت:** ${problem.time}
📌 **الحالة:** ${problem.status}

📝 **وصف المشكلة:**
${problem.description}

📸 **صورة البلاغ:**
تم رفع لقطة شاشة توضح المشكلة

🔧 **نوع العطل:** برمجي
🚨 **درجة التأثير:** ${problem.problemType == 'تعطل في التطبيق' ? 'عالية' : 'متوسطة'}
      ''';
      imageCaption = 'لقطة شاشة توضح مشكلة التطبيق';
      
    } else if (problem is WaterPipelineProblem) {
      details = '''
🏢 **وزارة المياه - نظام الإبلاغات**
📋 **تفاصيل بلاغ خط الأنابيب**

👤 **العميل:** ${problem.customerName}
🏭 **كود الخط:** ${problem.pipelineCode}
📍 **الموقع:** ${problem.location}
🏘️ **المنطقة:** ${problem.area}
📅 **التاريخ:** ${problem.date}
⏰ **الوقت:** ${problem.time}
📌 **الحالة:** ${problem.status}

📝 **وصف المشكلة:**
${problem.description}

📸 **صورة البلاغ:**
تم رفع صورة توضح مشكلة خط الأنابيب

💧 **نوع المشكلة:** تسرب مياه
      ''';
      imageCaption = 'صورة توضح مشكلة خط الأنابيب';
      
    } else {
      details = '''
🏢 **وزارة المياه - نظام الإبلاغات**
📋 **تفاصيل البلاغ**

👤 **العميل:** ${problem.customerName}
📍 **الموقع:** ${problem.location}
🏘️ **المنطقة:** ${problem.area}
📅 **التاريخ:** ${problem.date}
⏰ **الوقت:** ${problem.time}
🔧 **نوع المشكلة:** ${problem.problemType}
📌 **الحالة:** ${problem.status}

📝 **وصف المشكلة:**
${problem.description}

📸 **صورة البلاغ:**
تم رفع صورة توضح المشكلة

💧 **نوع الخدمة:** خدمة المياه
      ''';
      imageCaption = 'صورة توضح المشكلة المبلغ عنها';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _primaryColor, width: 1),
        ),
        title: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _primaryColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(
            children: [
              Icon(Icons.water_drop, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'تفاصيل البلاغ المائي',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_camera,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 8),
                      Text(
                        imageCaption,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'تم رفعها بواسطة العميل',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'معلومات البلاغ:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    
                    _buildDetailRow('👤 العميل:', problem.customerName),
                    if (problem is WaterProblem && problem.customerId != null)
                      _buildDetailRow('🆔 رقم العميل:', problem.customerId!),
                    if (problem is WaterEmployeeProblem && problem.employeeName != null)
                      _buildDetailRow('👨‍💼 الموظف:', problem.employeeName!),
                    if (problem is WaterEmployeeProblem && problem.employeeDepartment != null)
                      _buildDetailRow('🏘️ الإدارة:', problem.employeeDepartment!),
                    if (problem is WaterEmployeeProblem && problem.delayHours != null)
                      _buildDetailRow('⏳ ساعات التأخير:', '${problem.delayHours} ساعة'),
                    if (problem is WaterAppProblem && problem.appVersion != null)
                      _buildDetailRow('📊 إصدار التطبيق:', problem.appVersion!),
                    if (problem is WaterAppProblem && problem.deviceType != null)
                      _buildDetailRow('📟 نوع الجهاز:', problem.deviceType!),
                    if (problem is WaterPipelineProblem && problem.pipelineCode != null)
                      _buildDetailRow('🏭 كود الخط:', problem.pipelineCode!),
                    if (problem is WaterProblem && problem.problemType != null)
                      _buildDetailRow('🔧 نوع المشكلة:', problem.problemType!),
                    if (problem is WaterEmployeeProblem && problem.problemType != null)
                      _buildDetailRow('📋 نوع البلاغ:', problem.problemType!),
                    if (problem is WaterAppProblem && problem.problemType != null)
                      _buildDetailRow('📱 نوع المشكلة:', problem.problemType!),
                    if (problem is WaterProblem && problem.problemCategory != null)
                      _buildDetailRow('📊 فئة المشكلة:', problem.problemCategory!),
                    if (problem is WaterProblem && problem.waterStation != null)
                      _buildDetailRow('🏭 محطة المياه:', problem.waterStation!),
                    _buildDetailRow('📍 الموقع:', _getLocation(problem)),
                    _buildDetailRow('📅 التاريخ:', problem.date),
                    _buildDetailRow('⏰ الوقت:', problem.time),
                    _buildDetailRow('📌 الحالة:', problem.status),
                    if (problem is WaterProblem && problem.duration != null)
                      _buildDetailRow('⏳ المدة:', problem.duration!),
                    if (problem is WaterProblem && problem.priority != null)
                      _buildDetailRow('💧 الأولوية:', problem.priority!),
                    
                    SizedBox(height: 12),
                    
                    Text(
                      '📝 وصف المشكلة:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      problem.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 16),
              
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🚨 إجراءات المعالجة:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• تم إرسال البلاغ إلى الجهة المختصة',
                      style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                    ),
                    Text(
                      '• سيتم الرد خلال 24 ساعة',
                      style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                    ),
                    Text(
                      '• تم توليد رقم البلاغ: ${_generateReportNumber(problem)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('إغلاق'),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _markAsRead(problem);
              _showSuccessMessage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('تأكيد البلاغ'),
          ),
        ],
      ),
    );
  }

  String _generateReportNumber(dynamic problem) {
    String prefix = 'WATER';
    
    if (problem is WaterProblem) prefix = 'WATER';
    if (problem is WaterEmployeeProblem) prefix = 'EMP';
    if (problem is WaterAppProblem) prefix = 'APP';
    if (problem is WaterPipelineProblem) prefix = 'PIPE';
    if (problem is WaterQualityProblem) prefix = 'QUAL';
    if (problem is WaterConnectionProblem) prefix = 'CONN';
    
    return '$prefix-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showShareDialog(dynamic problem) {
    String problemType = '';
    if (problem is WaterProblem) {
      problemType = problem.problemType;
    } else if (problem is WaterEmployeeProblem) {
      problemType = problem.problemType;
    } else if (problem is WaterAppProblem) {
      problemType = problem.problemType;
    } else if (problem is WaterPipelineProblem) {
      problemType = 'مشكلة في خط الأنابيب';
    } else if (problem is WaterQualityProblem) {
      problemType = 'جودة المياه';
    } else if (problem is WaterConnectionProblem) {
      problemType = problem.problemType;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(Icons.share, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'مشاركة البلاغ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سيتم إرسال هذا البلاغ إلى:',
                style: TextStyle(
                  fontSize: 14,
                  color: _textColor(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _primaryColor,
                    child: Icon(Icons.engineering, color: Colors.white, size: 20),
                  ),
                  title: Text(
                    'الإدارة المختصة',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                  subtitle: Text(
                    'وزارة المياه - القسم المعني',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'تأكيد إرسال بلاغ $problemType؟',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showShareSuccessMessage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'تأكيد الإرسال',
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
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _successColor.withOpacity(0.3)),
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
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _successColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle, color: _successColor, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تم إرسال البلاغ بنجاح',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _successColor,
                      ),
                    ),
                    Text(
                      'سيتم معالجته من قبل الجهة المختصة',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
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

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _successColor.withOpacity(0.3)),
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
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _successColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle, color: _successColor, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تم تأكيد البلاغ بنجاح',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _successColor,
                      ),
                    ),
                    Text(
                      'رقم البلاغ: ${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
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

// دالة لعرض تفاصيل الإشعار
void _showNotificationsScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NotificationsScreen(),
    ),
  );
}

// === فئات البيانات للماء ===

class WaterProblem {
  final String customerName;
  final String customerId;
  final String problemType;
  final String location;
  final String waterStation;
  final String date;
  final String time;
  final String duration;
  final String description;
  final String imageAsset;
  final String status;
  final String priority;
  final bool isRead;
  final DateTime reportedDate;
  final String problemCategory;
  final String? pressureReading;
  final String? meterNumber;
  final String? pipelineCode;

  WaterProblem({
    required this.customerName,
    required this.customerId,
    required this.problemType,
    required this.location,
    required this.waterStation,
    required this.date,
    required this.time,
    required this.duration,
    required this.description,
    required this.imageAsset,
    required this.status,
    required this.priority,
    required this.isRead,
    required this.reportedDate,
    required this.problemCategory,
    this.pressureReading,
    this.meterNumber,
    this.pipelineCode,
  });

  WaterProblem copyWith({
    String? customerName,
    String? customerId,
    String? problemType,
    String? location,
    String? waterStation,
    String? date,
    String? time,
    String? duration,
    String? description,
    String? imageAsset,
    String? status,
    String? priority,
    bool? isRead,
    DateTime? reportedDate,
    String? problemCategory,
    String? pressureReading,
    String? meterNumber,
    String? pipelineCode,
  }) {
    return WaterProblem(
      customerName: customerName ?? this.customerName,
      customerId: customerId ?? this.customerId,
      problemType: problemType ?? this.problemType,
      location: location ?? this.location,
      waterStation: waterStation ?? this.waterStation,
      date: date ?? this.date,
      time: time ?? this.time,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      imageAsset: imageAsset ?? this.imageAsset,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
      reportedDate: reportedDate ?? this.reportedDate,
      problemCategory: problemCategory ?? this.problemCategory,
      pressureReading: pressureReading ?? this.pressureReading,
      meterNumber: meterNumber ?? this.meterNumber,
      pipelineCode: pipelineCode ?? this.pipelineCode,
    );
  }
}

class WaterEmployeeProblem {
  final String customerName;
  final String area;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String problemType;
  final String status;
  final bool isRead;
  final DateTime reportedDate;
  final String? employeeName;
  final int? delayHours;
  final String? employeeDepartment;

  WaterEmployeeProblem({
    required this.customerName,
    required this.area,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.problemType,
    required this.status,
    required this.isRead,
    required this.reportedDate,
    this.employeeName,
    this.delayHours,
    this.employeeDepartment,
  });

  WaterEmployeeProblem copyWith({
    String? customerName,
    String? area,
    String? location,
    String? date,
    String? time,
    String? description,
    String? imageAsset,
    String? problemType,
    String? status,
    bool? isRead,
    DateTime? reportedDate,
    String? employeeName,
    int? delayHours,
    String? employeeDepartment,
  }) {
    return WaterEmployeeProblem(
      customerName: customerName ?? this.customerName,
      area: area ?? this.area,
      location: location ?? this.location,
      date: date ?? this.date,
      time: time ?? this.time,
      description: description ?? this.description,
      imageAsset: imageAsset ?? this.imageAsset,
      problemType: problemType ?? this.problemType,
      status: status ?? this.status,
      isRead: isRead ?? this.isRead,
      reportedDate: reportedDate ?? this.reportedDate,
      employeeName: employeeName ?? this.employeeName,
      delayHours: delayHours ?? this.delayHours,
      employeeDepartment: employeeDepartment ?? this.employeeDepartment,
    );
  }
}

class WaterAppProblem {
  final String customerName;
  final String area;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String problemType;
  final String status;
  final bool isRead;
  final DateTime reportedDate;
  final String? appVersion;
  final String? deviceType;

  WaterAppProblem({
    required this.customerName,
    required this.area,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.problemType,
    required this.status,
    required this.isRead,
    required this.reportedDate,
    this.appVersion,
    this.deviceType,
  });

  WaterAppProblem copyWith({
    String? customerName,
    String? area,
    String? location,
    String? date,
    String? time,
    String? description,
    String? imageAsset,
    String? problemType,
    String? status,
    bool? isRead,
    DateTime? reportedDate,
    String? appVersion,
    String? deviceType,
  }) {
    return WaterAppProblem(
      customerName: customerName ?? this.customerName,
      area: area ?? this.area,
      location: location ?? this.location,
      date: date ?? this.date,
      time: time ?? this.time,
      description: description ?? this.description,
      imageAsset: imageAsset ?? this.imageAsset,
      problemType: problemType ?? this.problemType,
      status: status ?? this.status,
      isRead: isRead ?? this.isRead,
      reportedDate: reportedDate ?? this.reportedDate,
      appVersion: appVersion ?? this.appVersion,
      deviceType: deviceType ?? this.deviceType,
    );
  }
}

class WaterPipelineProblem {
  final String customerName;
  final String location;
  final String area;
  final String pipelineCode;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String status;
  final bool isRead;
  final DateTime reportedDate;

  WaterPipelineProblem({
    required this.customerName,
    required this.location,
    required this.area,
    required this.pipelineCode,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.status,
    required this.isRead,
    required this.reportedDate,
  });

  WaterPipelineProblem copyWith({
    String? customerName,
    String? location,
    String? area,
    String? pipelineCode,
    String? date,
    String? time,
    String? description,
    String? imageAsset,
    String? status,
    bool? isRead,
    DateTime? reportedDate,
  }) {
    return WaterPipelineProblem(
      customerName: customerName ?? this.customerName,
      location: location ?? this.location,
      area: area ?? this.area,
      pipelineCode: pipelineCode ?? this.pipelineCode,
      date: date ?? this.date,
      time: time ?? this.time,
      description: description ?? this.description,
      imageAsset: imageAsset ?? this.imageAsset,
      status: status ?? this.status,
      isRead: isRead ?? this.isRead,
      reportedDate: reportedDate ?? this.reportedDate,
    );
  }
}

class WaterQualityProblem {
  final String customerName;
  final String area;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String status;
  final bool isRead;
  final DateTime reportedDate;

  WaterQualityProblem({
    required this.customerName,
    required this.area,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.status,
    required this.isRead,
    required this.reportedDate,
  });

  WaterQualityProblem copyWith({
    String? customerName,
    String? area,
    String? location,
    String? date,
    String? time,
    String? description,
    String? imageAsset,
    String? status,
    bool? isRead,
    DateTime? reportedDate,
  }) {
    return WaterQualityProblem(
      customerName: customerName ?? this.customerName,
      area: area ?? this.area,
      location: location ?? this.location,
      date: date ?? this.date,
      time: time ?? this.time,
      description: description ?? this.description,
      imageAsset: imageAsset ?? this.imageAsset,
      status: status ?? this.status,
      isRead: isRead ?? this.isRead,
      reportedDate: reportedDate ?? this.reportedDate,
    );
  }
}

class WaterConnectionProblem {
  final String customerName;
  final String area;
  final String location;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String problemType;
  final String status;
  final bool isRead;
  final DateTime reportedDate;

  WaterConnectionProblem({
    required this.customerName,
    required this.area,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.problemType,
    required this.status,
    required this.isRead,
    required this.reportedDate,
  });

  WaterConnectionProblem copyWith({
    String? customerName,
    String? area,
    String? location,
    String? date,
    String? time,
    String? description,
    String? imageAsset,
    String? problemType,
    String? status,
    bool? isRead,
    DateTime? reportedDate,
  }) {
    return WaterConnectionProblem(
      customerName: customerName ?? this.customerName,
      area: area ?? this.area,
      location: location ?? this.location,
      date: date ?? this.date,
      time: time ?? this.time,
      description: description ?? this.description,
      imageAsset: imageAsset ?? this.imageAsset,
      problemType: problemType ?? this.problemType,
      status: status ?? this.status,
      isRead: isRead ?? this.isRead,
      reportedDate: reportedDate ?? this.reportedDate,
    );
  }
}


// === الشاشة الرئيسية للإشعارات (للمياه) ===
class NotificationsScreen extends StatefulWidget {
  static const String routeName = '/notifications';

  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // تعريف الألوان للمياه
  final Color _primaryColor = Color(0xFF0072B5);
  final Color _secondaryColor = Color(0xFF00A0DC);
  final Color _backgroundColor = Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF212121);
  final Color _textSecondaryColor = Color(0xFF757575);
  final Color _borderColor = Color(0xFFE0E0E0);
  final Color _successColor = Color(0xFF2E7D32);
  final Color _warningColor = Color(0xFFF57C00);
  final Color _errorColor = Color(0xFFD32F2F);
  final Color _infoColor = Color(0xFF1976D2);

  int _selectedTab = 0;
  final List<String> _tabs = ['الجميع', 'غير مقروءة', 'مقروءة', 'النظام'];
  
  // قائمة الإشعارات الكاملة
  final List<Map<String, dynamic>> _allNotifications = [
    // إشعارات غير مقروءة
    {
      'id': '1',
      'type': 'water',
      'title': 'انقطاع مياه جديد',
      'description': 'بلاغ جديد عن انقطاع المياه في منطقة حي السلام، تم الإبلاغ الساعة 08:30 صباحاً',
      'time': 'منذ 5 دقائق',
      'read': false,
      'category': 'مياه',
      'priority': 'عالي',
      'icon': Icons.water_damage,
      'color': Color(0xFFD32F2F),
    },
    {
      'id': '2',
      'type': 'employee',
      'title': 'تأخير فني المياه',
      'description': 'مواطن يبلغ عن تأخير فني المياه لمدة 3 ساعات في منطقة حي النزهة',
      'time': 'منذ 15 دقيقة',
      'read': false,
      'category': 'موظفين',
      'priority': 'متوسط',
      'icon': Icons.engineering,
      'color': Color(0xFFF57C00),
    },
    {
      'id': '3',
      'type': 'app',
      'title': 'مشكلة في تطبيق المياه',
      'description': 'عميل يبلغ عن تعطل في التطبيق عند دفع فاتورة المياه، الإصدار 2.1.0',
      'time': 'منذ 30 دقيقة',
      'read': false,
      'category': 'تطبيق',
      'priority': 'عالي',
      'icon': Icons.phone_iphone,
      'color': Color(0xFF1976D2),
    },
    {
      'id': '4',
      'type': 'quality',
      'title': 'مشكلة في جودة المياه',
      'description': 'مياه ذات لون عكر ورائحة كريهة في شارع الملك فهد',
      'time': 'منذ 45 دقيقة',
      'read': false,
      'category': 'جودة',
      'priority': 'عالي',
      'icon': Icons.water_drop,
      'color': Color(0xFFD32F2F),
    },

    // إشعارات مقروءة
    {
      'id': '5',
      'type': 'water',
      'title': 'مشكلة في ضغط المياه',
      'description': 'تم معالجة مشكلة انخفاض ضغط المياه في حي النزهة، تمت الإصلاح الساعة 10:00 صباحاً',
      'time': 'منذ ساعة',
      'read': true,
      'category': 'مياه',
      'priority': 'منخفض',
      'icon': Icons.speed,
      'color': Color(0xFFFF9800),
    },
    {
      'id': '6',
      'type': 'system',
      'title': 'تحديث النظام',
      'description': 'تم تحديث نظام بلاغات المياه إلى الإصدار 2.1.0، تم إضافة ميزات جديدة',
      'time': 'منذ 3 ساعات',
      'read': true,
      'category': 'نظام',
      'priority': 'معلومات',
      'icon': Icons.system_update,
      'color': Color(0xFF4CAF50),
    },
    {
      'id': '7',
      'type': 'report',
      'title': 'تقرير أسبوعي جاهز',
      'description': 'تم إنشاء التقرير الأسبوعي لبلاغات المياه، يمكنك تصديره الآن',
      'time': 'منذ يوم',
      'read': true,
      'category': 'تقارير',
      'priority': 'منخفض',
      'icon': Icons.summarize,
      'color': Color(0xFF9C27B0),
    },
    {
      'id': '8',
      'type': 'alert',
      'title': 'تحذير تسرب مياه',
      'description': 'تسرب مياه من خط الأنابيب الرئيسي في المنطقة الشمالية',
      'time': 'منذ يومين',
      'read': true,
      'category': 'تنبيهات',
      'priority': 'عالي',
      'icon': Icons.warning,
      'color': Color(0xFFD32F2F),
    },
    {
      'id': '9',
      'type': 'payment',
      'title': 'دفع فاتورة مياه ناجح',
      'description': 'تم دفع فاتورة المواطن أحمد محمد بقيمة 75,500 دينار',
      'time': 'منذ 3 أيام',
      'read': true,
      'category': 'مدفوعات',
      'priority': 'منخفض',
      'icon': Icons.payment,
      'color': Color(0xFF4CAF50),
    },
    {
      'id': '10',
      'type': 'maintenance',
      'title': 'صيانة مجدولة',
      'description': 'صيانة مجدولة لمحطة التنقية الرئيسية يوم الخميس القادم',
      'time': 'منذ أسبوع',
      'read': true,
      'category': 'صيانة',
      'priority': 'متوسط',
      'icon': Icons.build,
      'color': Color(0xFF607D8B),
    },
  ];

  // فلترة الإشعارات حسب التبويب المختار
  List<Map<String, dynamic>> get _filteredNotifications {
    switch (_selectedTab) {
      case 0: // الجميع
        return _allNotifications;
      case 1: // غير مقروءة
        return _allNotifications.where((notification) => !notification['read']).toList();
      case 2: // مقروءة
        return _allNotifications.where((notification) => notification['read']).toList();
      case 3: // النظام
        return _allNotifications.where((notification) => notification['type'] == 'system').toList();
      default:
        return _allNotifications;
    }
  }

  // دالة لعرض عدد الإشعارات غير المقروءة
  int get _unreadCount {
    return _allNotifications.where((notification) => !notification['read']).length;
  }

  // دالة لتمييز الإشعار كمقروء
  void _markAsRead(String notificationId) {
    setState(() {
      final index = _allNotifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _allNotifications[index]['read'] = true;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تمييز الإشعار كمقروء'),
        backgroundColor: _successColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // دالة لحذف الإشعار
  void _deleteNotification(String notificationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حذف الإشعار'),
        content: Text('هل أنت متأكد من حذف هذا الإشعار؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allNotifications.removeWhere((n) => n['id'] == notificationId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم حذف الإشعار بنجاح'),
                  backgroundColor: _successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: _errorColor),
            child: Text('حذف'),
          ),
        ],
      ),
    );
  }

  // دالة لتمييز الكل كمقروء
  void _markAllAsRead() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تمييز الكل كمقروء'),
        content: Text('هل تريد تمييز جميع الإشعارات كمقروءة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                for (var notification in _allNotifications) {
                  notification['read'] = true;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم تمييز جميع الإشعارات كمقروءة'),
                  backgroundColor: _successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
            child: Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  // دالة لحذف الكل
  void _deleteAllRead() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حذف الإشعارات المقروءة'),
        content: Text('هل تريد حذف جميع الإشعارات المقروءة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allNotifications.removeWhere((n) => n['read']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم حذف جميع الإشعارات المقروءة'),
                  backgroundColor: _successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: _errorColor),
            child: Text('حذف'),
          ),
        ],
      ),
    );
  }

  // دالة لعرض تفاصيل الإشعار
  void _showNotificationDetails(Map<String, dynamic> notification) {
    // تمييز الإشعار كمقروء عند فتح التفاصيل
    if (!notification['read']) {
      _markAsRead(notification['id']);
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: notification['color'],
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(notification['icon'], color: Colors.white, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification['title'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      notification['category'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule_rounded, size: 16, color: _textSecondaryColor),
                  SizedBox(width: 4),
                  Text(
                    notification['time'],
                    style: TextStyle(color: _textSecondaryColor, fontSize: 12),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: notification['priority'] == 'عالي' 
                          ? _errorColor.withOpacity(0.1)
                          : _warningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'أولوية: ${notification['priority']}',
                      style: TextStyle(
                        fontSize: 10,
                        color: notification['priority'] == 'عالي' 
                            ? _errorColor 
                            : _warningColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16),
              
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  notification['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: _textColor,
                    height: 1.5,
                  ),
                ),
              ),
              
              if (notification['type'] == 'water') ...[
                SizedBox(height: 16),
                Text('تفاصيل إضافية:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                _buildNotificationDetailRow('نوع المشكلة:', 'انقطاع المياه'),
                _buildNotificationDetailRow('الموقع:', 'حي السلام - شارع الملك فهد'),
                _buildNotificationDetailRow('التاريخ:', DateFormat('yyyy-MM-dd').format(DateTime.now())),
                _buildNotificationDetailRow('الوقت:', '08:30 ص'),
                _buildNotificationDetailRow('الحالة:', 'قيد المعالجة'),
                _buildNotificationDetailRow('رقم البلاغ:', 'WATER-${notification['id']}'),
              ],
              if (notification['type'] == 'employee') ...[
                SizedBox(height: 16),
                Text('تفاصيل الموظف:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                _buildNotificationDetailRow('اسم الموظف:', 'أحمد سعيد'),
                _buildNotificationDetailRow('القسم:', 'إدارة صيانة المياه'),
                _buildNotificationDetailRow('ساعات التأخير:', '3 ساعات'),
                _buildNotificationDetailRow('موقع الحادثة:', 'حي النزهة'),
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
              _markAsRead(notification['id']);
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
            child: Text('تمييز كمقروء'),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لعرض صف التفاصيل
  Widget _buildNotificationDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: _textColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دالة لفتح إعدادات الإشعارات
  void _openNotificationSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('شاشة إعدادات الإشعارات قريباً'),
        backgroundColor: _infoColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.notifications_active_rounded, size: 24, color: Colors.white),
            SizedBox(width: 8),
            Text('الإشعارات', style: TextStyle(color: Colors.white)),
            SizedBox(width: 8),
            if (_unreadCount > 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _unreadCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_unreadCount > 0)
            IconButton(
              icon: Icon(Icons.mark_email_read_rounded, color: Colors.white),
              onPressed: _markAllAsRead,
              tooltip: 'تمييز الكل كمقروء',
            ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: Colors.white),
            onSelected: (value) {
              if (value == 'delete_all') {
                _deleteAllRead();
              } else if (value == 'settings') {
                _openNotificationSettings();
              } else if (value == 'refresh') {
                setState(() {});
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh_rounded, color: _primaryColor),
                    SizedBox(width: 8),
                    Text('تحديث'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_rounded, color: _primaryColor),
                    SizedBox(width: 8),
                    Text('إعدادات الإشعارات'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_rounded, color: _errorColor),
                    SizedBox(width: 8),
                    Text('حذف المقروءة'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // تبويبات التصفية
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

          // إحصائيات سريعة
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _cardColor,
              border: Border(bottom: BorderSide(color: _borderColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('الكل', _allNotifications.length.toString(), Icons.list_rounded, _primaryColor),
                _buildStatItem('غير مقروء', _unreadCount.toString(), Icons.mark_email_unread_rounded, _errorColor),
                _buildStatItem('مقروء', (_allNotifications.length - _unreadCount).toString(), Icons.mark_email_read_rounded, _successColor),
              ],
            ),
          ),

          // قائمة الإشعارات
          Expanded(
            child: _filteredNotifications.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(Duration(seconds: 1));
                      setState(() {});
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = _filteredNotifications[index];
                        return _buildNotificationCard(notification);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // دالة بناء زر التبويب
  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTab == index;
    int count = 0;
    
    switch (index) {
      case 0: count = _allNotifications.length; break;
      case 1: count = _allNotifications.where((n) => !n['read']).length; break;
      case 2: count = _allNotifications.where((n) => n['read']).length; break;
      case 3: count = _allNotifications.where((n) => n['type'] == 'system').length; break;
    }
    
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: isSelected ? _primaryColor : _textSecondaryColor,
                  ),
                ),
                SizedBox(height: 2),
                if (count > 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: isSelected ? _primaryColor : _textSecondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // دالة بناء بطاقة الإشعار
  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    Color bgColor = notification['read'] ? _cardColor : _primaryColor.withOpacity(0.05);
    Color borderColor = notification['read'] ? _borderColor : notification['color'].withOpacity(0.3);
    
    return Dismissible(
      key: Key(notification['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        color: _errorColor,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete_rounded, color: Colors.white, size: 24),
      ),
      onDismissed: (direction) => _deleteNotification(notification['id']),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('حذف الإشعار'),
              content: Text('هل تريد حذف هذا الإشعار؟'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(backgroundColor: _errorColor),
                  child: Text('حذف'),
                ),
              ],
            ),
          );
        }
        return false;
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border(left: BorderSide(
                color: notification['color'],
                width: 4,
              )),
            ),
            child: InkWell(
              onTap: () => _showNotificationDetails(notification),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // أيقونة الإشعار
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: notification['color'].withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(notification['icon'], color: notification['color'], size: 20),
                  ),
                  SizedBox(width: 12),
                  
                  // محتوى الإشعار
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // حالة القراءة
                            if (!notification['read'])
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _errorColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            if (!notification['read']) SizedBox(width: 6),
                            
                            // الفئة
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: notification['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                notification['category'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: notification['color'],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 6),
                            
                            // الأولوية
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: notification['priority'] == 'عالي' 
                                    ? _errorColor.withOpacity(0.1)
                                    : _warningColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                notification['priority'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: notification['priority'] == 'عالي' 
                                      ? _errorColor 
                                      : _warningColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Spacer(),
                            
                            // الوقت
                            Text(
                              notification['time'],
                              style: TextStyle(
                                fontSize: 10,
                                color: _textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 8),
                        
                        // العنوان
                        Text(
                          notification['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: _textColor,
                          ),
                        ),
                        
                        SizedBox(height: 4),
                        
                        // الوصف
                        Text(
                          notification['description'],
                          style: TextStyle(
                            fontSize: 12,
                            color: _textSecondaryColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        SizedBox(height: 12),
                        
                        // الأزرار
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (!notification['read'])
                              ElevatedButton(
                                onPressed: () => _markAsRead(notification['id']),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _successColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  minimumSize: Size(0, 0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_rounded, size: 14),
                                    SizedBox(width: 4),
                                    Text('مقروء', style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _showNotificationDetails(notification),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: Size(0, 0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.remove_red_eye_rounded, size: 14),
                                  SizedBox(width: 4),
                                  Text('عرض', style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: borderColor,
          ),
        ],
      ),
    );
  }

  // دالة بناء عنصر الإحصائيات
  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        SizedBox(height: 4),
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

  // دالة بناء حالة فارغة
  Widget _buildEmptyState() {
    IconData icon;
    String title;
    String description;
    
    switch (_selectedTab) {
      case 1: // غير مقروءة
        icon = Icons.mark_email_read_rounded;
        title = 'لا توجد إشعارات غير مقروءة';
        description = 'جميع الإشعارات قد تمت قراءتها';
        break;
      case 2: // مقروءة
        icon = Icons.mark_email_unread_rounded;
        title = 'لا توجد إشعارات مقروءة';
        description = 'لم تتم قراءة أي إشعار بعد';
        break;
      case 3: // النظام
        icon = Icons.notifications_off_rounded;
        title = 'لا توجد إشعارات نظام';
        description = 'لم يتم إصدار أي إشعارات نظام';
        break;
      default:
        icon = Icons.notifications_none_rounded;
        title = 'لا توجد إشعارات';
        description = 'سيظهر هنا الإشعارات عند وصولها';
    }
    
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: _textSecondaryColor),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: _textSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: _textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            if (_selectedTab == 1 && _allNotifications.any((n) => n['read']))
              ElevatedButton(
                onPressed: () => setState(() => _selectedTab = 2),
                style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
                child: Text('عرض الإشعارات المقروءة'),
              ),
          ],
        ),
      ),
    );
  }
}

// === شاشة المساعدة والدعم (للمياه) ===
class HelpSupportScreen extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color cardColor;
  final Color textColor;
  final Color textSecondaryColor;
  final Color borderColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;

  const HelpSupportScreen({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.cardColor,
    required this.textColor,
    required this.textSecondaryColor,
    required this.borderColor,
    required this.successColor,
    required this.warningColor,
    required this.errorColor,
  }) : super(key: key);

  @override
  _HelpSupportScreenState createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['المساعدة', 'الدعم', 'اتصل بنا', 'عن التطبيق'];
  
  // قائمة الأسئلة الشائعة
  final List<Map<String, String>> _faqs = [
    {
      'question': 'كيف يمكنني الإبلاغ عن مشكلة في المياه؟',
      'answer': 'يمكنك الإبلاغ عن مشاكل المياه من خلال التبويب الأول "إبلاغ عن خدمة المياه" → اختر نوع المشكلة → املأ البيانات المطلوبة → اضغط على زر "إرسال البلاغ"'
    },
    {
      'question': 'كيف أتابع حالة البلاغ الذي أرسلته؟',
      'answer': 'يمكنك متابعة حالة البلاغ من خلال قسم "التقارير" → اختر التقرير المناسب → ابحث عن بلاغك باستخدام رقم البلاغ أو اسم العميل'
    },
    {
      'question': 'كيف يمكنني التواصل مع موظف الدعم؟',
      'answer': 'يمكنك التواصل مع موظف الدعم من خلال التبويب "الدعم" في هذه الشاشة → اختر "محادثة مباشرة" أو اتصل على رقم الدعم الفني'
    },
    {
      'question': 'كيف أعدل بياناتي الشخصية؟',
      'answer': 'يمكنك تعديل بياناتك الشخصية من خلال القائمة الجانبية → اختر "الإعدادات" → ثم "المعلومات الشخصية" → قم بالتعديلات المطلوبة'
    },
    {
      'question': 'كيف أتصدير تقرير البلاغات؟',
      'answer': 'اذهب إلى قسم "التقارير" → اختر نوع التقرير → حدد الفترة الزمنية → اضغط على زر "تصدير PDF" → اختر مكان الحفظ'
    },
  ];

  // قائمة مشاكل المياه الشائعة
  final List<Map<String, dynamic>> _commonProblems = [
    {
      'problem': 'انقطاع المياه',
      'solution': 'تحقق من محبس المياه الرئيسي - تأكد من عدم وجود صيانة في المنطقة - اتصل بالدعم الفني',
      'emergency': true,
    },
    {
      'problem': 'انخفاض ضغط المياه',
      'solution': 'افصل الأجهزة التي تستخدم المياه - تحقق من وجود تسرب - أبلغ قسم الصيانة',
      'emergency': false,
    },
    {
      'problem': 'تسرب مياه من خط الأنابيب',
      'solution': 'اغلق محبس المياه الرئيسي - ابتعد عن منطقة التسرب - أبلغ فوراً بخطورة الموقف',
      'emergency': true,
    },
    {
      'problem': 'مياه ذات لون أو رائحة غير طبيعية',
      'solution': 'لا تشرب المياه - استخدم المياه المعبأة - اتصل بقسم جودة المياه فوراً',
      'emergency': true,
    },
  ];

  // قائمة أرقام الطوارئ
  final List<Map<String, dynamic>> _emergencyContacts = [
    {
      'name': 'طوارئ المياه',
      'number': '07725252103',
      'description': 'لبلاغات انقطاع المياه والتسربات الخطرة',
      'icon': Icons.emergency_rounded,
      'color': Color(0xFFD32F2F),
    },
    {
      'name': 'الدعم الفني للمياه',
      'number': '07862268894',
      'description': 'للمساعدة الفنية واستفسارات النظام',
      'icon': Icons.support_agent_rounded,
      'color': Color(0xFF1976D2),
    },
    {
      'name': 'شكاوى موظفي المياه',
      'number': '07758888999',
      'description': 'للتقارير عن تقصير موظفي المياه',
      'icon': Icons.person_rounded,
      'color': Color(0xFFF57C00),
    },
    {
      'name': 'فواتير المياه والمحاسبة',
      'number': '07663334455',
      'description': 'لاستفسارات فواتير المياه والدفعات',
      'icon': Icons.receipt_rounded,
      'color': Color(0xFF388E3C),
    },
  ];

  // دالة للاتصال برقم الهاتف
  void _makePhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('لا يمكن إجراء المكالمة'),
          backgroundColor: widget.errorColor,
        ),
      );
    }
  }

  // دالة لإرسال بريد إلكتروني
  void _sendEmail() async {
    final email = 'support@water.gov.iq';
    final subject = 'استفسار - نظام إبلاغات المياه';
    final body = 'أنا بحاجة إلى مساعدة بخصوص:\n\n\n\nالتاريخ: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}';
    
    final url = 'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
    
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('لا يمكن فتح تطبيق البريد'),
          backgroundColor: widget.errorColor,
        ),
      );
    }
  }

  // دالة لفتح موقع الويب
  void _openWebsite() async {
    const url = 'https://www.water.gov.iq';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('لا يمكن فتح الموقع'),
          backgroundColor: widget.errorColor,
        ),
      );
    }
  }

  // دالة لفتح محادثة الدعم المباشر
  void _openSupportChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveSupportChatScreen(
          primaryColor: widget.primaryColor,
          secondaryColor: widget.secondaryColor,
        ),
      ),
    );
  }

  // دالة لفتح الأسئلة الشائعة
  void _openFAQDetail() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FAQDetailScreen(
        faqs: _faqs,
        primaryColor: widget.primaryColor,
      ),
    );
  }

  // دالة لفتح دليل الاستخدام
  void _openUserGuide() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('دليل الاستخدام'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildGuideStep('1', 'تسجيل الدخول', 'ادخل بيانات الدخول الصحيحة للوصول للنظام'),
              _buildGuideStep('2', 'الإبلاغ عن مشكلة', 'اختر نوع المشكلة واملأ التفاصيل المطلوبة'),
              _buildGuideStep('3', 'متابعة البلاغ', 'تابع حالة البلاغ من قسم التقارير'),
              _buildGuideStep('4', 'التواصل مع الدعم', 'استخدم قسم الدعم للتواصل الفوري'),
              _buildGuideStep('5', 'تصدير التقارير', 'احفظ التقارير بصيغة PDF للمراجعة'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () => _downloadUserGuide(),
            style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor),
            child: Text('تحميل الدليل'),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideStep(String number, String title, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: widget.backgroundColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: widget.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _downloadUserGuide() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تحميل دليل الاستخدام...'),
        backgroundColor: widget.successColor,
      ),
    );
    // Simulate download
    Future.delayed(Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تحميل الدليل بنجاح'),
          backgroundColor: widget.successColor,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.help_outline_rounded, size: 24),
            SizedBox(width: 8),
            Text('المساعدة والدعم'),
          ],
        ),
        backgroundColor: widget.primaryColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download_rounded, color: Colors.white),
            onPressed: _downloadUserGuide,
            tooltip: 'تحميل دليل الاستخدام',
          ),
        ],
      ),
      body: Column(
        children: [
          // تبويبات
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: widget.cardColor,
              border: Border(
                bottom: BorderSide(color: widget.borderColor),
              ),
            ),
            child: Row(
              children: [
                for (int i = 0; i < _tabs.length; i++)
                  _buildTabButton(_tabs[i], i),
              ],
            ),
          ),

          // محتوى التبويب المحدد
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _buildHelpTab(),      // تبويب المساعدة
                _buildSupportTab(),   // تبويب الدعم
                _buildContactTab(),   // تبويب اتصل بنا
                _buildAboutTab(),     // تبويب عن التطبيق
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دالة بناء زر التبويب
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
                color: isSelected ? widget.secondaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: isSelected ? widget.primaryColor : widget.textSecondaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // تبويب المساعدة
  Widget _buildHelpTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // البحث
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: widget.cardColor,
              border: Border.all(color: widget.borderColor),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث في المساعدة...',
                prefixIcon: Icon(Icons.search_rounded, color: widget.textSecondaryColor),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          SizedBox(height: 20),

          // مشاكل المياه الشائعة
          Text(
            'مشاكل المياه الشائعة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.primaryColor,
            ),
          ),
          SizedBox(height: 12),
          
          ..._commonProblems.map((problem) => _buildProblemCard(problem)),

          SizedBox(height: 20),

          // الأسئلة الشائعة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الأسئلة الشائعة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.primaryColor,
                ),
              ),
              TextButton(
                onPressed: _openFAQDetail,
                child: Text('عرض الكل', style: TextStyle(color: widget.primaryColor)),
              ),
            ],
          ),
          
          SizedBox(height: 12),
          
          ..._faqs.take(3).map((faq) => _buildFAQItem(faq)),

          SizedBox(height: 20),

          // دليل الاستخدام
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.primaryColor.withOpacity(0.05),
              border: Border.all(color: widget.primaryColor.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.book_rounded, color: widget.primaryColor),
                    SizedBox(width: 8),
                    Text(
                      'دليل الاستخدام',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'تعرف على كيفية استخدام نظام الإبلاغات خطوة بخطوة',
                  style: TextStyle(color: widget.textSecondaryColor),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _openUserGuide,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    minimumSize: Size(double.infinity, 40),
                  ),
                  child: Text('فتح دليل الاستخدام'),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  // تبويب الدعم
  Widget _buildSupportTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // محادثة مباشرة
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.cardColor,
              border: Border.all(color: widget.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: widget.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.chat_rounded, color: widget.primaryColor, size: 30),
                ),
                SizedBox(height: 16),
                Text(
                  'محادثة مباشرة مع الدعم',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.primaryColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'تواصل مباشر مع فريق الدعم الفني لحل مشكلتك',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: widget.textSecondaryColor),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _openSupportChat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_rounded),
                      SizedBox(width: 8),
                      Text('بدء محادثة جديدة'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // طرق دعم أخرى
          Text(
            'طرق دعم أخرى',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.primaryColor,
            ),
          ),
          SizedBox(height: 12),

          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildSupportOption(
                Icons.video_call_rounded,
                'مكالمة فيديو',
                'مكالمة فيديو مع فني متخصص',
                () => _showComingSoon(),
              ),
              _buildSupportOption(
                Icons.screen_share_rounded,
                'مشاركة شاشة',
                'مشاركة شاشتك مع الدعم',
                () => _showComingSoon(),
              ),
              _buildSupportOption(
                Icons.upload_file_rounded,
                'رفع ملف',
                'رفع صور أو مستندات للمشكلة',
                () => _uploadFile(),
              ),
              _buildSupportOption(
                Icons.schedule_rounded,
                'حجز موعد',
                'حجز موعد مسبق مع الدعم',
                () => _scheduleAppointment(),
              ),
            ],
          ),

          SizedBox(height: 20),

          // حالة الدعم
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.successColor.withOpacity(0.1),
              border: Border.all(color: widget.successColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: widget.successColor),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الدعم متاح الآن',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.successColor,
                        ),
                      ),
                      Text(
                        'فريق الدعم متاح على مدار 24 ساعة',
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.successColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'متصل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  // تبويب اتصل بنا
  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // معلومات الاتصال
          Text(
            'معلومات الاتصال',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.primaryColor,
            ),
          ),
          SizedBox(height: 12),

          ..._emergencyContacts.map((contact) => _buildContactCard(contact)),

          SizedBox(height: 20),

          // وسائل التواصل الاجتماعي
          Text(
            'وسائل التواصل الاجتماعي',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.primaryColor,
            ),
          ),
          SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialMediaButton('فيسبوك', Icons.facebook_rounded, Color(0xFF1877F2), 
                  () => _openSocialMedia('facebook')),
              _buildSocialMediaButton('تويتر', Icons.camera_alt_rounded, Color(0xFF1DA1F2), 
                  () => _openSocialMedia('twitter')),
              _buildSocialMediaButton('يوتيوب', Icons.video_library_rounded, Color(0xFFFF0000), 
                  () => _openSocialMedia('youtube')),
            ],
          ),

          SizedBox(height: 20),

          // موقعنا
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.cardColor,
              border: Border.all(color: widget.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: widget.primaryColor),
                    SizedBox(width: 8),
                    Text(
                      'موقعنا',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'وزارة المياه - العراق\nبغداد - منطقة الوزارات',
                  style: TextStyle(color: widget.textColor),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _openMap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    minimumSize: Size(double.infinity, 40),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_rounded, size: 20),
                      SizedBox(width: 8),
                      Text('فتح الخريطة'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // ساعات العمل
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.cardColor,
              border: Border.all(color: widget.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, color: widget.primaryColor),
                    SizedBox(width: 8),
                    Text(
                      'ساعات العمل',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _buildWorkingHoursRow('الأحد - الخميس', '8:00 ص - 4:00 م'),
                _buildWorkingHoursRow('الجمعة', '8:00 ص - 12:00 م'),
                _buildWorkingHoursRow('السبت', 'عطلة رسمية'),
                _buildWorkingHoursRow('الدعم الفني', '24/7'),
              ],
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  // تبويب عن التطبيق
  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // معلومات التطبيق
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: widget.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.water_drop, 
                      color: Colors.white, size: 40),
                ),
                SizedBox(height: 16),
                Text(
                  'نظام إبلاغات المياه',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: widget.primaryColor,
                  ),
                ),
                Text(
                  'وزارة المياه - العراق',
                  style: TextStyle(
                    color: widget.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // إصدار التطبيق
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.cardColor,
              border: Border.all(color: widget.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معلومات الإصدار',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.primaryColor,
                  ),
                ),
                SizedBox(height: 12),
                _buildAboutInfoRow('الإصدار', '2.0.0'),
                _buildAboutInfoRow('تاريخ البناء', '2024-01-25'),
                _buildAboutInfoRow('رقم البناء', '20240125.1'),
                _buildAboutInfoRow('الترخيص', 'حكومي - وزارة المياه'),
              ],
            ),
          ),

          SizedBox(height: 20),

          // فريق التطوير
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.cardColor,
              border: Border.all(color: widget.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'فريق التطوير',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.primaryColor,
                  ),
                ),
                SizedBox(height: 12),
                _buildTeamMember('فاضل علي', 'مطور رئيسي', Icons.code_rounded),
                _buildTeamMember('أحمد محمد', 'مصمم واجهات', Icons.design_services_rounded),
                _buildTeamMember('سارة عبدالله', 'مديرة مشروع', Icons.engineering_rounded),
                _buildTeamMember('خالد إبراهيم', 'دعم فني', Icons.support_agent_rounded),
              ],
            ),
          ),

          SizedBox(height: 20),

          // سياسة الخصوصية والشروط
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.cardColor,
              border: Border.all(color: widget.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الشروط والسياسات',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.primaryColor,
                  ),
                ),
                SizedBox(height: 12),
                ListTile(
                  leading: Icon(Icons.privacy_tip_rounded, color: widget.primaryColor),
                  title: Text('سياسة الخصوصية'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () => _openPrivacyPolicy(),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.description_rounded, color: widget.primaryColor),
                  title: Text('شروط الاستخدام'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () => _openTermsOfService(),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.security_rounded, color: widget.primaryColor),
                  title: Text('الأمان والحماية'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () => _openSecurityInfo(),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // تحديث التطبيق
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.successColor.withOpacity(0.1),
              border: Border.all(color: widget.successColor.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.update_rounded, color: widget.successColor),
                    SizedBox(width: 8),
                    Text(
                      'تحديث التطبيق',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.successColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'الإصدار الحالي هو الأحدث\nآخر تحديث: 2024-01-20',
                  style: TextStyle(color: widget.textSecondaryColor),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _checkForUpdates,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.successColor,
                    minimumSize: Size(double.infinity, 40),
                  ),
                  child: Text('التحقق من التحديثات'),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  // دوال مساعدة
  Widget _buildProblemCard(Map<String, dynamic> problem) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: widget.cardColor,
        border: Border.all(color: widget.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: problem['emergency'] 
                  ? widget.errorColor.withOpacity(0.1)
                  : widget.warningColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              problem['emergency'] ? Icons.warning_rounded : Icons.info_rounded,
              color: problem['emergency'] ? widget.errorColor : widget.warningColor,
              size: 16,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  problem['problem'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  problem['solution'],
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.textSecondaryColor,
                  ),
                ),
                if (problem['emergency'])
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'طارئ',
                      style: TextStyle(
                        fontSize: 10,
                        color: widget.errorColor,
                        fontWeight: FontWeight.bold,
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

  Widget _buildFAQItem(Map<String, String> faq) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: Icon(Icons.help_outline_rounded, color: widget.primaryColor),
        title: Text(
          faq['question']!,
          style: TextStyle(fontSize: 14),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              faq['answer']!,
              style: TextStyle(
                color: widget.textSecondaryColor,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOption(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: widget.primaryColor, size: 32),
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: widget.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(Map<String, dynamic> contact) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: contact['color'].withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(contact['icon'], color: contact['color']),
        ),
        title: Text(contact['name']),
        subtitle: Text(contact['description']),
        trailing: ElevatedButton(
          onPressed: () => _makePhoneCall(contact['number']),
          style: ElevatedButton.styleFrom(
            backgroundColor: contact['color'],
            foregroundColor: Colors.white,
            minimumSize: Size(0, 0),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          ),
          child: Text('اتصال'),
        ),
        onTap: () => _showContactDetails(contact),
      ),
    );
  }

  Widget _buildSocialMediaButton(String platform, IconData icon, Color color, VoidCallback onTap) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: onTap,
          ),
        ),
        SizedBox(height: 4),
        Text(platform, style: TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildWorkingHoursRow(String day, String hours) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: TextStyle(color: widget.textColor)),
          Text(hours, style: TextStyle(
            color: widget.textSecondaryColor,
            fontWeight: FontWeight.bold,
          )),
        ],
      ),
    );
  }

  Widget _buildAboutInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: widget.textSecondaryColor)),
          Text(value, style: TextStyle(
            color: widget.textColor,
            fontWeight: FontWeight.bold,
          )),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, IconData icon) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: widget.primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: widget.primaryColor, size: 20),
      ),
      title: Text(name),
      subtitle: Text(role),
    );
  }

  // دوال الإجراءات
  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('هذه الميزة قيد التطوير'),
        backgroundColor: widget.warningColor,
      ),
    );
  }

  void _uploadFile() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library_rounded),
              title: Text('معرض الصور'),
              onTap: () => _selectImage(),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt_rounded),
              title: Text('الكاميرا'),
              onTap: () => _takePhoto(),
            ),
            ListTile(
              leading: Icon(Icons.insert_drive_file_rounded),
              title: Text('الملفات'),
              onTap: () => _selectFile(),
            ),
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

  void _selectImage() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري اختيار صورة...'),
        backgroundColor: widget.primaryColor,
      ),
    );
  }

  void _takePhoto() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري فتح الكاميرا...'),
        backgroundColor: widget.primaryColor,
      ),
    );
  }

  void _selectFile() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري اختيار ملف...'),
        backgroundColor: widget.primaryColor,
      ),
    );
  }

  void _scheduleAppointment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حجز موعد مع الدعم'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'سبب الحجز',
                  hintText: 'وصف المشكلة',
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'التاريخ والوقت',
                  hintText: 'اختر التاريخ والوقت',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDateTime(),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'طريقة الاتصال',
                  hintText: 'هاتف / فيديو',
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم حجز الموعد بنجاح'),
                  backgroundColor: widget.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor),
            child: Text('حجز'),
          ),
        ],
      ),
    );
  }

  void _selectDateTime() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    ).then((date) {
      if (date != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
      }
    });
  }

  void _showContactDetails(Map<String, dynamic> contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
          Icon(contact['icon'], color: contact['color']),
          SizedBox(width: 8),
          Text(contact['name']),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'رقم الهاتف: ${contact['number']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(contact['description']),
            SizedBox(height: 16),
            Text(
              'ساعات العمل: 24/7',
              style: TextStyle(fontSize: 12, color: widget.textSecondaryColor),
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
              _makePhoneCall(contact['number']);
            },
            style: ElevatedButton.styleFrom(backgroundColor: contact['color']),
            child: Text('اتصال فوري'),
          ),
        ],
      ),
    );
  }

  void _openSocialMedia(String platform) {
    String url = '';
    switch (platform) {
      case 'facebook':
        url = 'https://www.facebook.com';
        break;
      case 'twitter':
        url = 'https://www.twitter.com';
        break;
      case 'youtube':
        url = 'https://www.youtube.com';
        break;
    }
    
    launch(url).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('لا يمكن فتح الرابط'),
          backgroundColor: widget.errorColor,
        ),
      );
    });
  }

  void _openMap() async {
    const url = 'https://maps.google.com/?q=وزارة+المياه+العراق';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('لا يمكن فتح الخريطة'),
          backgroundColor: widget.errorColor,
        ),
      );
    }
  }

  void _openPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('سياسة الخصوصية'),
        content: SingleChildScrollView(
          child: Text(
            '''
            سياسة الخصوصية لنظام إبلاغات المياه
            
            1. جمع المعلومات:
            - نجمع المعلومات اللازمة لتقديم الخدمة
            - نحافظ على سرية بيانات المستخدمين
            - لا نشارك المعلومات مع أطراف ثالثة
            
            2. استخدام المعلومات:
            - لتحسين الخدمة
            - للتواصل مع المستخدمين
            - لتوليد التقارير الإحصائية
            
            3. حماية المعلومات:
            - تشفير البيانات الحساسة
            - حماية الخوادم من الاختراق
            - تحديث أنظمة الأمان باستمرار
            
            4. حقوق المستخدم:
            - حق الوصول للبيانات
            - حق التعديل أو الحذف
            - حق الاعتراض على المعالجة
            
            تاريخ آخر تحديث: 2024-01-25
            ''',
            style: TextStyle(fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () => _downloadPrivacyPolicy(),
            style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor),
            child: Text('تحميل'),
          ),
        ],
      ),
    );
  }

  void _openTermsOfService() {
    // Similar to privacy policy
  }

  void _openSecurityInfo() {
    // Similar to privacy policy
  }

  void _downloadPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تحميل سياسة الخصوصية'),
        backgroundColor: widget.successColor,
      ),
    );
  }

  void _checkForUpdates() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري التحقق من التحديثات...'),
        backgroundColor: widget.primaryColor,
      ),
    );
    
    Future.delayed(Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('الإصدار الحالي هو الأحدث'),
          backgroundColor: widget.successColor,
        ),
      );
    });
  }
}

// === شاشة الأسئلة الشائعة المفصلة ===
class FAQDetailScreen extends StatelessWidget {
  final List<Map<String, String>> faqs;
  final Color primaryColor;

  FAQDetailScreen({required this.faqs, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // رأس الشاشة
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(Icons.help_outline_rounded, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'الأسئلة الشائعة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // محتوى الأسئلة
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.1),
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      faqs[index]['question']!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          faqs[index]['answer']!,
                          style: TextStyle(
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // زر إغلاق
          Container(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('إغلاق'),
            ),
          ),
        ],
      ),
    );
  }
}

// === شاشة محادثة الدعم المباشر ===
class LiveSupportChatScreen extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;

  LiveSupportChatScreen({required this.primaryColor, required this.secondaryColor});

  @override
  _LiveSupportChatScreenState createState() => _LiveSupportChatScreenState();
}

class _LiveSupportChatScreenState extends State<LiveSupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'مرحباً! أنا فاضل من فريق الدعم الفني لوزارة المياه، كيف يمكنني مساعدتك اليوم؟',
      'isUser': false,
      'time': 'الآن',
      'sender': 'فاضل علي - الدعم الفني للمياه'
    }
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text;
    setState(() {
      _messages.add({
        'text': message,
        'isUser': true,
        'time': 'الآن',
        'sender': 'أنت'
      });
    });

    _messageController.clear();

    // Simulate response
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'text': _getResponse(message),
            'isUser': false,
            'time': 'الآن',
            'sender': 'فاضل علي - الدعم الفني للمياه'
          });
        });
      }
    });
  }

  String _getResponse(String message) {
    if (message.contains('انقطاع') || message.contains('ماء') || message.contains('مياه')) {
      return 'أفهم أنك تواجه مشكلة في المياه. هل يمكنك إخباري بالمنطقة والوقت الذي بدأ فيه الانقطاع؟';
    } else if (message.contains('فاتورة') || message.contains('دفع')) {
      return 'للمساعدة في مشاكل فواتير المياه، أحتاج إلى رقم الفاتورة أو رقم حسابك. هل يمكنك توفير هذه المعلومات؟';
    } else if (message.contains('موظف') || message.contains('تأخير')) {
      return 'أنا آسف لسماع ذلك. سأساعدك في متابعة الأمر مع إدارة الموظفين. هل يمكنك إخباري باسم الموظف وتاريخ الحادثة؟';
    } else if (message.contains('تطبيق') || message.contains('برنامج')) {
      return 'لحل مشاكل التطبيق، أحتاج معرفة: نوع الجهاز، إصدار التطبيق، ومتى تظهر المشكلة بالضبط؟';
    } else if (message.contains('ضغط') || message.contains('جودة')) {
      return 'للمساعدة في مشاكل ضغط أو جودة المياه، أحتاج معرفة: المنطقة، وقت المشكلة، وأي تفاصيل إضافية؟';
    } else {
      return 'شكراً لتواصلكم مع وزارة المياه. سأساعدك في حل هذه المشكلة. هل يمكنك تقديم مزيد من التفاصيل؟';
    }
  }

  void _sendQuickResponse(String response) {
    setState(() {
      _messages.add({
        'text': response,
        'isUser': true,
        'time': 'الآن',
        'sender': 'أنت'
      });
    });

    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'text': 'شكراً للمعلومات. سأقوم بمتابعة الأمر مع القسم المختص وسأعود إليك بالتحديثات.',
            'isUser': false,
            'time': 'الآن',
            'sender': 'فاضل علي - الدعم الفني للمياه'
          });
        });
      }
    });
  }

  void _endChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إنهاء المحادثة'),
        content: Text('هل تريد إنهاء المحادثة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('البقاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('إنهاء'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('محادثة الدعم المباشر'),
            Text('متصل الآن', style: TextStyle(fontSize: 12)),
          ],
        ),
        backgroundColor: widget.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => _endChat(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call_rounded),
            onPressed: () => _makeVoiceCall(),
          ),
        ],
      ),
      body: Column(
        children: [
          // معلومات الدعم
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.primaryColor.withOpacity(0.05),
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: widget.primaryColor,
                  child: Icon(Icons.support_agent_rounded, color: Colors.white),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('فاضل علي - الدعم الفني للمياه', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('متخصص في مشاكل المياه والبلاغات', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('متصل', style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ],
            ),
          ),

          // الرسائل
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // ردود سريعة
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 8),
              children: [
                _buildQuickResponseButton('انقطاع مياه'),
                _buildQuickResponseButton('مشكلة فاتورة'),
                _buildQuickResponseButton('تأخير فني'),
                _buildQuickResponseButton('جودة المياه'),
              ],
            ),
          ),

          // إدخال الرسالة
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file_rounded, color: widget.primaryColor),
                  onPressed: _attachFile,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send_rounded, color: widget.primaryColor),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message['isUser'] ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message['isUser'])
            CircleAvatar(
              backgroundColor: widget.primaryColor,
              radius: 16,
              child: Icon(Icons.support_agent_rounded, color: Colors.white, size: 14),
            ),
          SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: message['isUser'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!message['isUser'])
                  Text(
                    message['sender'],
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message['isUser'] 
                        ? widget.primaryColor.withOpacity(0.9)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message['text'],
                    style: TextStyle(
                      color: message['isUser'] ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message['time'],
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          if (message['isUser'])
            SizedBox(width: 8),
          if (message['isUser'])
            CircleAvatar(
              backgroundColor: widget.secondaryColor,
              radius: 16,
              child: Icon(Icons.person_rounded, color: Colors.white, size: 14),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickResponseButton(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () => _sendQuickResponse(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.primaryColor.withOpacity(0.1),
          foregroundColor: widget.primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(text, style: TextStyle(fontSize: 12)),
      ),
    );
  }

  void _makeVoiceCall() {
    // Implementation for voice call
  }

  void _attachFile() {
    // Implementation for file attachment
  }
}

// === شاشة الإعدادات الكاملة (للمياه) ===
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
          _buildAboutRow('الإصدار', '2.0.0', themeProvider),
          _buildAboutRow('تاريخ البناء', '2024-01-25', themeProvider),
          _buildAboutRow('المطور', 'وزارة المياه - العراق', themeProvider),
          _buildAboutRow('رقم الترخيص', 'MOW-2024-001', themeProvider),
          _buildAboutRow('آخر تحديث', '2024-01-20', themeProvider),
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
