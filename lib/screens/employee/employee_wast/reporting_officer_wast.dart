import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'dart:async';

// استيراد الشاشات الأخرى (يمكنك تعديل المسارات حسب مشروعك)
import 'package:mang_mu/screens/employee/Shared Services/esignin_screen.dart';

class ReportingOfficerWasteScreen extends StatefulWidget {
  static const String screenRoute = '/reporting-officer';

  const ReportingOfficerWasteScreen({super.key});

  @override
  ReportingOfficerWasteScreenState createState() =>
      ReportingOfficerWasteScreenState();
}

class ReportingOfficerWasteScreenState
    extends State<ReportingOfficerWasteScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // متغيرات التحديث لكل تبويب
  final RefreshController _serviceReportsRefreshController = RefreshController();
  final RefreshController _employeeReportsRefreshController = RefreshController();
  final RefreshController _appReportsRefreshController = RefreshController();
  final RefreshController _emergencyReportsRefreshController = RefreshController();
  final RefreshController _reportsRefreshController = RefreshController();

  // متغيرات لمحاكاة التحديث
  bool _isServiceReportsRefreshing = false;
  bool _isEmployeeReportsRefreshing = false;
  bool _isAppReportsRefreshing = false;
  bool _isEmergencyReportsRefreshing = false;
  bool _isReportsRefreshing = false;

  // الألوان الرئيسية (مطابقة للألوان في شاشة المحاسب)
  final Color _primaryColor = const Color.fromARGB(255, 0, 120, 50); // أخضر بلدي
  final Color _secondaryColor = const Color(0xFFD4AF37); // ذهبي
  final Color _accentColor = const Color(0xFF0277BD); // أزرق
  final Color _successColor = const Color(0xFF2E7D32);
  final Color _warningColor = const Color(0xFFF57C00);
  final Color _errorColor = const Color(0xFFD32F2F);
  final Color _darkPrimaryColor = const Color(0xFF006430);

  // متغيرات البحث والتصفية لكل تبويب
  String _serviceReportsSearchQuery = '';
  final TextEditingController _serviceReportsSearchController =
      TextEditingController();

  String _employeeReportsSearchQuery = '';
  final TextEditingController _employeeReportsSearchController =
      TextEditingController();

  String _appReportsSearchQuery = '';
  final TextEditingController _appReportsSearchController =
      TextEditingController();

  String _emergencyReportsSearchQuery = '';
  final TextEditingController _emergencyReportsSearchController =
      TextEditingController();

  String _reportsSearchQuery = '';
  final TextEditingController _reportsSearchController =
      TextEditingController();

  // متغيرات التقارير الداخلية (مطابقة لشاشة المحاسب)
  int _currentReportInnerTab = 0;
  String _selectedReportType = 'يومي';
  List<DateTime> _selectedDates = [];
  String? _selectedWeek;
  String? _selectedMonth;

  // ==================== البيانات التجريبية للبلاغات (وزارة البلدية) ====================

  // 1. بلاغات عن الخدمات البلدية (نظافة، طرق، إنارة، حدائق)
  List<Map<String, dynamic>> serviceReports = [
    {
      'id': 'BLD-SRV-2024-001',
      'citizenName': 'أحمد محمد',
      'citizenPhone': '07712345678',
      'title': 'تراكم النفايات',
      'description': 'تراكم النفايات في حي الرياض منذ أكثر من أسبوع دون معالجة',
      'date': DateTime.now().subtract(const Duration(hours: 3)),
      'status': 'قيد المعالجة',
      'priority': 'عالية',
      'location': 'حي الرياض - شارع الملك فهد',
      'assignedTo': 'فريق النظافة',
      'serviceType': 'نظافة',
    },
    {
      'id': 'BLD-SRV-2024-002',
      'citizenName': 'فاطمة علي',
      'citizenPhone': '07812345678',
      'title': 'حفرة في الطريق',
      'description': 'وجود حفرة كبيرة في منتصف الطريق تشكل خطراً على المركبات',
      'date': DateTime.now().subtract(const Duration(hours: 8)),
      'status': 'تم الاستلام',
      'priority': 'عالية',
      'location': 'حي النخيل - تقاطع فلسطين',
      'assignedTo': 'قيد التقييم',
      'serviceType': 'طرق',
    },
    {
      'id': 'BLD-SRV-2024-003',
      'citizenName': 'خالد إبراهيم',
      'citizenPhone': '07722334455',
      'title': 'إنارة معطلة',
      'description': 'أعمدة الإنارة في شارع العليا معطلة منذ شهر',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'تمت المعالجة',
      'priority': 'متوسطة',
      'location': 'شارع العليا',
      'assignedTo': 'تم إصلاح الإنارة',
      'serviceType': 'إنارة',
    },
    {
      'id': 'BLD-SRV-2024-004',
      'citizenName': 'سارة عبدالله',
      'citizenPhone': '07911223344',
      'title': 'إهمال في الحدائق',
      'description': 'الحديقة العامة مهملة والأعشاب ضارة وتحتاج إلى صيانة',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'status': 'قيد المعالجة',
      'priority': 'متوسطة',
      'location': 'حديقة المنصور',
      'assignedTo': 'فريق الحدائق',
      'serviceType': 'حدائق',
    },
    {
      'id': 'BLD-SRV-2024-005',
      'citizenName': 'عمر خالد',
      'citizenPhone': '07733445566',
      'title': 'مجاري مكشوفة',
      'description': 'مجاري مكشوفة في منطقة الكرادة تشكل خطراً على الصحة العامة',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'قيد المعالجة',
      'priority': 'عالية جداً',
      'location': 'الكرادة - شارع 14 رمضان',
      'assignedTo': 'فريق المجاري',
      'serviceType': 'مجاري',
    },
  ];

  // 2. بلاغات عن الموظفين
  List<Map<String, dynamic>> employeeReports = [
    {
      'id': 'BLD-EMP-2024-001',
      'citizenName': 'محمد حسن',
      'citizenPhone': '07755667788',
      'employeeName': 'علي كريم',
      'employeeId': 'EMP-123',
      'department': 'قسم النظافة',
      'title': 'سوء معاملة',
      'description': 'تلقيت معاملة سيئة من الموظف في دائرة البلدية',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'قيد التحقيق',
      'priority': 'عالية',
      'location': 'دائرة بلدية الكرخ',
    },
    {
      'id': 'BLD-EMP-2024-002',
      'citizenName': 'ليلى أحمد',
      'citizenPhone': '07899887766',
      'employeeName': 'سعد محمد',
      'employeeId': 'EMP-456',
      'department': 'قسم التراخيص',
      'title': 'تأخير في إنهاء المعاملة',
      'description': 'تأخر الموظف في إنهاء معاملة رخصة بناء لمدة أسبوعين',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'تم التحقيق',
      'priority': 'متوسطة',
      'location': 'دائرة بلدية الرصافة',
    },
    {
      'id': 'BLD-EMP-2024-003',
      'citizenName': 'عمر خالد',
      'citizenPhone': '07733445566',
      'employeeName': 'نور الهدى',
      'employeeId': 'EMP-789',
      'department': 'قسم الرخص',
      'title': 'طلب رشوة',
      'description': 'الموظف طلب مبلغ مالي لتسريع إنهاء معاملة رخصة',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'قيد التحقيق',
      'priority': 'عالية جداً',
      'location': 'دائرة بلدية المنصور',
    },
    {
      'id': 'BLD-EMP-2024-004',
      'citizenName': 'فاطمة علي',
      'citizenPhone': '07812345678',
      'employeeName': 'محمد جاسم',
      'employeeId': 'EMP-101',
      'department': 'قسم النظافة',
      'title': 'تجاهل الشكاوى',
      'description': 'الموظف يتجاهل شكاوى المواطنين المتكررة',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'status': 'تم التحقيق',
      'priority': 'متوسطة',
      'location': 'دائرة بلدية الزعفرانية',
    },
  ];

  // 3. بلاغات عن عطل في التطبيق
  List<Map<String, dynamic>> appReports = [
    {
      'id': 'BLD-APP-2024-001',
      'citizenName': 'أحمد محمد',
      'citizenPhone': '07712345678',
      'title': 'تعطل تقديم البلاغ',
      'description': 'لا يمكنني تقديم بلاغ جديد عبر التطبيق، يظهر خطأ في الإرسال',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'قيد الإصلاح',
      'priority': 'عالية',
      'deviceType': 'Samsung Galaxy S21',
      'appVersion': '2.1.0',
    },
    {
      'id': 'BLD-APP-2024-002',
      'citizenName': 'فاطمة علي',
      'citizenPhone': '07812345678',
      'title': 'عدم ظهور البلاغات السابقة',
      'description': 'عند فتح قائمة البلاغات السابقة تظهر صفحة فارغة',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'status': 'تم الإصلاح',
      'priority': 'متوسطة',
      'deviceType': 'iPhone 13',
      'appVersion': '2.1.0',
    },
    {
      'id': 'BLD-APP-2024-003',
      'citizenName': 'خالد إبراهيم',
      'citizenPhone': '07722334455',
      'title': 'تأخر في رفع الصور',
      'description': 'رفع الصور مع البلاغ يستغرق وقتاً طويلاً جداً',
      'date': DateTime.now().subtract(const Duration(hours: 8)),
      'status': 'قيد المعالجة',
      'priority': 'منخفضة',
      'deviceType': 'Xiaomi Redmi Note 10',
      'appVersion': '2.0.9',
    },
    {
      'id': 'BLD-APP-2024-004',
      'citizenName': 'سارة عبدالله',
      'citizenPhone': '07911223344',
      'title': 'تطبيق يغلق تلقائياً',
      'description': 'التطبيق يغلق تلقائياً عند محاولة فتح البلاغات',
      'date': DateTime.now().subtract(const Duration(minutes: 30)),
      'status': 'قيد الإصلاح',
      'priority': 'عالية',
      'deviceType': 'Huawei P30',
      'appVersion': '2.1.0',
    },
  ];

  // 4. بلاغات الطارئة (خاصة بالبلدية)
  List<Map<String, dynamic>> emergencyReports = [
    {
      'id': 'BLD-EMG-2024-001',
      'citizenName': 'محمد حسن',
      'citizenPhone': '07755667788',
      'title': 'انهيار جزئي لمبنى',
      'description': 'انهيار جزئي في مبنى قديم بحي العامل، يوجد خطر على المارة',
      'date': DateTime.now().subtract(const Duration(minutes: 30)),
      'status': 'تم الاستلام',
      'priority': 'طارئة',
      'location': 'حي العامل - قرب المدرسة',
      'responseTime': 'فوري',
      'emergencyType': 'انهيار مبنى',
    },
    {
      'id': 'BLD-EMG-2024-002',
      'citizenName': 'سارة عبدالله',
      'citizenPhone': '07911223344',
      'title': 'انفجار أنبوب مياه رئيسي',
      'description': 'انفجار أنبوب مياه رئيسي في شارع فلسطين يغرق الشارع',
      'date': DateTime.now().subtract(const Duration(hours: 1)),
      'status': 'قيد المعالجة',
      'priority': 'طارئة',
      'location': 'شارع فلسطين - تقاطع الكندي',
      'responseTime': 'فوري',
      'emergencyType': 'انفجار مياه',
    },
    {
      'id': 'BLD-EMG-2024-003',
      'citizenName': 'عمر خالد',
      'citizenPhone': '07733445566',
      'title': 'سقوط شجرة كبيرة',
      'description': 'سقوط شجرة كبيرة على الطريق بسبب الرياح تعيق حركة المرور',
      'date': DateTime.now().subtract(const Duration(minutes: 45)),
      'status': 'تم الاستلام',
      'priority': 'طارئة',
      'location': 'منطقة الكرادة - شارع أبو نؤاس',
      'responseTime': 'فوري',
      'emergencyType': 'سقوط شجرة',
    },
    {
      'id': 'BLD-EMG-2024-004',
      'citizenName': 'أحمد محمد',
      'citizenPhone': '07712345678',
      'title': 'انهيار مجاري',
      'description': 'انهيار في شبكة المجاري يؤدي إلى تدفق المياه القذرة في الشارع',
      'date': DateTime.now().subtract(const Duration(minutes: 15)),
      'status': 'تم الاستلام',
      'priority': 'طارئة',
      'location': 'حي الرياض - شارع الملك فهد',
      'responseTime': 'فوري',
      'emergencyType': 'مجاري',
    },
  ];

  // 5. بيانات التقارير الواردة
  List<Map<String, dynamic>> receivedReports = [
    {
      'id': 'BLD-REP-2024-001',
      'title': 'تقرير البلاغات الشهري - قسم النظافة',
      'sender': 'قسم النظافة',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'type': 'شهري',
      'size': '1.2 MB',
      'status': 'مستلم',
      'fileType': 'PDF',
    },
    {
      'id': 'BLD-REP-2024-002',
      'title': 'تقرير أداء الموظفين - الربع الأول',
      'sender': 'شؤون الموظفين',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'type': 'ربع سنوي',
      'size': '850 KB',
      'status': 'مستلم',
      'fileType': 'PDF',
    },
    {
      'id': 'BLD-REP-2024-003',
      'title': 'تقرير البلاغات الطارئة - الأسبوعي',
      'sender': 'غرفة الطوارئ',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'type': 'أسبوعي',
      'size': '450 KB',
      'status': 'غير مقروء',
      'fileType': 'Excel',
    },
    {
      'id': 'BLD-REP-2024-004',
      'title': 'تقرير أعطال التطبيق',
      'sender': 'قسم تقنية المعلومات',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'type': 'شهري',
      'size': '2.1 MB',
      'status': 'مستلم',
      'fileType': 'PDF',
    },
    {
      'id': 'BLD-REP-2024-005',
      'title': 'تقرير رضا المواطنين عن الخدمات البلدية',
      'sender': 'الإدارة العليا',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'type': 'سنوي',
      'size': '3.5 MB',
      'status': 'مستلم',
      'fileType': 'PDF',
    },
    {
      'id': 'BLD-REP-2024-006',
      'title': 'إحصائية تراخيص البناء',
      'sender': 'قسم التراخيص',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'type': 'شهري',
      'size': '1.8 MB',
      'status': 'مستلم',
      'fileType': 'PDF',
    },
  ];

  // ==================== دوال البحث لكل تبويب ====================

  List<Map<String, dynamic>> get filteredServiceReports {
    if (_serviceReportsSearchQuery.isEmpty) {
      return serviceReports;
    }
    return serviceReports.where((report) {
      return report['citizenName'].toLowerCase().contains(_serviceReportsSearchQuery.toLowerCase()) ||
          report['id'].toLowerCase().contains(_serviceReportsSearchQuery.toLowerCase()) ||
          report['title'].toLowerCase().contains(_serviceReportsSearchQuery.toLowerCase()) ||
          report['location'].toLowerCase().contains(_serviceReportsSearchQuery.toLowerCase()) ||
          (report['serviceType']?.toLowerCase().contains(_serviceReportsSearchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  List<Map<String, dynamic>> get filteredEmployeeReports {
    if (_employeeReportsSearchQuery.isEmpty) {
      return employeeReports;
    }
    return employeeReports.where((report) {
      return report['citizenName'].toLowerCase().contains(_employeeReportsSearchQuery.toLowerCase()) ||
          report['id'].toLowerCase().contains(_employeeReportsSearchQuery.toLowerCase()) ||
          report['employeeName'].toLowerCase().contains(_employeeReportsSearchQuery.toLowerCase()) ||
          report['title'].toLowerCase().contains(_employeeReportsSearchQuery.toLowerCase()) ||
          (report['department']?.toLowerCase().contains(_employeeReportsSearchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  List<Map<String, dynamic>> get filteredAppReports {
    if (_appReportsSearchQuery.isEmpty) {
      return appReports;
    }
    return appReports.where((report) {
      return report['citizenName'].toLowerCase().contains(_appReportsSearchQuery.toLowerCase()) ||
          report['id'].toLowerCase().contains(_appReportsSearchQuery.toLowerCase()) ||
          report['title'].toLowerCase().contains(_appReportsSearchQuery.toLowerCase()) ||
          (report['deviceType']?.toLowerCase().contains(_appReportsSearchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  List<Map<String, dynamic>> get filteredEmergencyReports {
    if (_emergencyReportsSearchQuery.isEmpty) {
      return emergencyReports;
    }
    return emergencyReports.where((report) {
      return report['citizenName'].toLowerCase().contains(_emergencyReportsSearchQuery.toLowerCase()) ||
          report['id'].toLowerCase().contains(_emergencyReportsSearchQuery.toLowerCase()) ||
          report['title'].toLowerCase().contains(_emergencyReportsSearchQuery.toLowerCase()) ||
          report['location'].toLowerCase().contains(_emergencyReportsSearchQuery.toLowerCase()) ||
          (report['emergencyType']?.toLowerCase().contains(_emergencyReportsSearchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  List<Map<String, dynamic>> get filteredReceivedReports {
    if (_reportsSearchQuery.isEmpty) {
      return receivedReports;
    }
    return receivedReports.where((report) {
      return report['title'].toLowerCase().contains(_reportsSearchQuery.toLowerCase()) ||
          report['sender'].toLowerCase().contains(_reportsSearchQuery.toLowerCase()) ||
          report['id'].toLowerCase().contains(_reportsSearchQuery.toLowerCase());
    }).toList();
  }

  // ==================== دوال التحديث (Refresh) ====================

  Future<void> _refreshServiceReports() async {
    setState(() {
      _isServiceReportsRefreshing = true;
    });

    // محاكاة جلب بيانات جديدة من الخادم
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      // يمكن إضافة بيانات جديدة أو تحديث البيانات الحالية هنا
      // على سبيل المثال، إضافة بلاغ جديد وهمي
      final newReport = {
        'id': 'BLD-SRV-2024-${DateTime.now().millisecond}',
        'citizenName': 'مواطن جديد',
        'citizenPhone': '077${DateTime.now().millisecond}',
        'title': 'بلاغ جديد بعد التحديث',
        'description': 'هذا بلاغ تمت إضافته بعد عملية التحديث',
        'date': DateTime.now(),
        'status': 'تم الاستلام',
        'priority': 'متوسطة',
        'location': 'موقع جديد',
        'assignedTo': 'قيد التقييم',
        'serviceType': 'خدمة جديدة',
      };
      
      serviceReports.insert(0, newReport);
      _isServiceReportsRefreshing = false;
    });

    _serviceReportsRefreshController.refreshCompleted();
  }

  Future<void> _refreshEmployeeReports() async {
    setState(() {
      _isEmployeeReportsRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      final newReport = {
        'id': 'BLD-EMP-2024-${DateTime.now().millisecond}',
        'citizenName': 'مواطن جديد',
        'citizenPhone': '077${DateTime.now().millisecond}',
        'employeeName': 'موظف جديد',
        'employeeId': 'EMP-${DateTime.now().millisecond}',
        'department': 'قسم جديد',
        'title': 'بلاغ موظف جديد',
        'description': 'هذا بلاغ موظف تمت إضافته بعد التحديث',
        'date': DateTime.now(),
        'status': 'قيد التحقيق',
        'priority': 'عالية',
        'location': 'دائرة بلدية جديدة',
      };
      
      employeeReports.insert(0, newReport);
      _isEmployeeReportsRefreshing = false;
    });

    _employeeReportsRefreshController.refreshCompleted();
  }

  Future<void> _refreshAppReports() async {
    setState(() {
      _isAppReportsRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      final newReport = {
        'id': 'BLD-APP-2024-${DateTime.now().millisecond}',
        'citizenName': 'مواطن جديد',
        'citizenPhone': '077${DateTime.now().millisecond}',
        'title': 'بلاغ تطبيق جديد',
        'description': 'هذا بلاغ تطبيق تمت إضافته بعد التحديث',
        'date': DateTime.now(),
        'status': 'قيد الإصلاح',
        'priority': 'عالية',
        'deviceType': 'جهاز جديد',
        'appVersion': '2.1.0',
      };
      
      appReports.insert(0, newReport);
      _isAppReportsRefreshing = false;
    });

    _appReportsRefreshController.refreshCompleted();
  }

  Future<void> _refreshEmergencyReports() async {
    setState(() {
      _isEmergencyReportsRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      final newReport = {
        'id': 'BLD-EMG-2024-${DateTime.now().millisecond}',
        'citizenName': 'مواطن جديد',
        'citizenPhone': '077${DateTime.now().millisecond}',
        'title': 'بلاغ طارئ جديد',
        'description': 'هذا بلاغ طارئ تمت إضافته بعد التحديث',
        'date': DateTime.now(),
        'status': 'تم الاستلام',
        'priority': 'طارئة',
        'location': 'موقع جديد',
        'responseTime': 'فوري',
        'emergencyType': 'نوع طارئ جديد',
      };
      
      emergencyReports.insert(0, newReport);
      _isEmergencyReportsRefreshing = false;
    });

    _emergencyReportsRefreshController.refreshCompleted();
  }

  Future<void> _refreshReports() async {
    setState(() {
      _isReportsRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      final newReport = {
        'id': 'BLD-REP-2024-${DateTime.now().millisecond}',
        'title': 'تقرير جديد بعد التحديث',
        'sender': 'قسم جديد',
        'date': DateTime.now(),
        'type': 'شهري',
        'size': '1.5 MB',
        'status': 'غير مقروء',
        'fileType': 'PDF',
      };
      
      receivedReports.insert(0, newReport);
      _isReportsRefreshing = false;
    });

    _reportsRefreshController.refreshCompleted();
  }

  // دالة لتنسيق العملة
  String _formatCurrency(dynamic amount) {
    double numericAmount = 0.0;
    if (amount is int) {
      numericAmount = amount.toDouble();
    } else if (amount is double) {
      numericAmount = amount;
    } else if (amount is String) {
      numericAmount = double.tryParse(amount) ?? 0.0;
    }
    return NumberFormat('#,##0').format(numericAmount);
  }

  // ألوان ديناميكية تعتمد على الوضع المظلم
  Color _backgroundColor(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF0F8FF);
  }

  Color _cardColor(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  }

  Color _textColor(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Colors.white : const Color(0xFF212121);
  }

  Color _textSecondaryColor(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF757575);
  }

  Color _borderColor(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? const Color(0xFF333333) : const Color(0xFFE0E0E0);
  }

  // دوال مساعدة للبحث
  void _updateServiceReportsSearch(String query) {
    setState(() {
      _serviceReportsSearchQuery = query;
    });
  }

  void _clearServiceReportsSearch() {
    setState(() {
      _serviceReportsSearchQuery = '';
      _serviceReportsSearchController.clear();
    });
  }

  void _updateEmployeeReportsSearch(String query) {
    setState(() {
      _employeeReportsSearchQuery = query;
    });
  }

  void _clearEmployeeReportsSearch() {
    setState(() {
      _employeeReportsSearchQuery = '';
      _employeeReportsSearchController.clear();
    });
  }

  void _updateAppReportsSearch(String query) {
    setState(() {
      _appReportsSearchQuery = query;
    });
  }

  void _clearAppReportsSearch() {
    setState(() {
      _appReportsSearchQuery = '';
      _appReportsSearchController.clear();
    });
  }

  void _updateEmergencyReportsSearch(String query) {
    setState(() {
      _emergencyReportsSearchQuery = query;
    });
  }

  void _clearEmergencyReportsSearch() {
    setState(() {
      _emergencyReportsSearchQuery = '';
      _emergencyReportsSearchController.clear();
    });
  }

  void _updateReportsSearch(String query) {
    setState(() {
      _reportsSearchQuery = query;
    });
  }

  void _clearReportsSearch() {
    setState(() {
      _reportsSearchQuery = '';
      _reportsSearchController.clear();
    });
  }

  // ==================== دوال إحصائيات ====================

  int getTotalReports() {
    return serviceReports.length +
        employeeReports.length +
        appReports.length +
        emergencyReports.length;
  }

  int getPendingReports() {
    return serviceReports.where((r) => r['status'] == 'قيد المعالجة' || r['status'] == 'تم الاستلام').length +
        employeeReports.where((r) => r['status'] == 'قيد التحقيق').length +
        appReports.where((r) => r['status'] == 'قيد المعالجة' || r['status'] == 'قيد الإصلاح').length +
        emergencyReports.where((r) => r['status'] == 'تم الاستلام' || r['status'] == 'قيد المعالجة').length;
  }

  int getCompletedReports() {
    return serviceReports.where((r) => r['status'] == 'تمت المعالجة').length +
        employeeReports.where((r) => r['status'] == 'تم التحقيق').length +
        appReports.where((r) => r['status'] == 'تم الإصلاح').length;
  }

  int getHighPriorityReports() {
    return serviceReports.where((r) => r['priority'] == 'عالية' || r['priority'] == 'عالية جداً').length +
        employeeReports.where((r) => r['priority'] == 'عالية' || r['priority'] == 'عالية جداً').length +
        appReports.where((r) => r['priority'] == 'عالية').length +
        emergencyReports.where((r) => r['priority'] == 'طارئة').length;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this); // 5 تبويبات
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _serviceReportsSearchController.dispose();
    _employeeReportsSearchController.dispose();
    _appReportsSearchController.dispose();
    _emergencyReportsSearchController.dispose();
    _reportsSearchController.dispose();
    _serviceReportsRefreshController.dispose();
    _employeeReportsRefreshController.dispose();
    _appReportsRefreshController.dispose();
    _emergencyReportsRefreshController.dispose();
    _reportsRefreshController.dispose();
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
              child: Icon(Icons.apartment_rounded,
                  color: _primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'وزارة البلدية - نظام البلاغات',
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
                Icon(Icons.notifications_outlined,
                    color: Colors.white, size: 26),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: _secondaryColor,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                        minWidth: 16, minHeight: 16),
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
                MaterialPageRoute(
                    builder: (context) => NotificationsScreen()),
              );
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
                  fontSize: 10,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 11,
                ),
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.cleaning_services_rounded, size: 20),
                    text: 'بلاغات الخدمات',
                  ),
                  Tab(
                    icon: Icon(Icons.people_rounded, size: 20),
                    text: 'بلاغات الموظفين',
                  ),
                  Tab(
                    icon: Icon(Icons.phone_android_rounded, size: 20),
                    text: 'بلاغات التطبيق',
                  ),
                  Tab(
                    icon: Icon(Icons.warning_amber_rounded, size: 20),
                    text: 'البلاغات الطارئة',
                  ),
                  Tab(
                    icon: Icon(Icons.summarize_rounded, size: 20),
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
                  colors: [const Color(0xFF121212), const Color(0xFF1A1A1A)],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0xFFF5F5F5), const Color(0xFFE8F5E8)],
                ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;

            return TabBarView(
              controller: _tabController,
              children: [
                // تبويب بلاغات الخدمات البلدية
                _buildServiceReportsView(isDarkMode, screenWidth, screenHeight),
                // تبويب بلاغات الموظفين
                _buildEmployeeReportsView(isDarkMode, screenWidth, screenHeight),
                // تبويب بلاغات التطبيق
                _buildAppReportsView(isDarkMode, screenWidth, screenHeight),
                // تبويب البلاغات الطارئة
                _buildEmergencyReportsView(isDarkMode, screenWidth, screenHeight),
                // تبويب التقارير
                _buildReportsView(isDarkMode, screenWidth, screenHeight),
              ],
            );
          },
        ),
      ),
      drawer: _buildGovernmentDrawer(context, isDarkMode),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddReportDialog(context, isDarkMode);
        },
        backgroundColor: _secondaryColor,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  // ==================== بناء كل تبويب مع خاصية التحديث ====================

  // تبويب 1: بلاغات الخدمات البلدية مع التحديث
  Widget _buildServiceReportsView(
      bool isDarkMode, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      height: screenHeight,
      child: Column(
        children: [
          _buildSearchBar(
            isDarkMode,
            'ابحث في بلاغات الخدمات...',
            _serviceReportsSearchController,
            _updateServiceReportsSearch,
            _clearServiceReportsSearch,
            _serviceReportsSearchQuery,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshServiceReports,
              color: _primaryColor,
              backgroundColor: _cardColor(context),
              child: filteredServiceReports.isEmpty
                  ? ListView(
                      children: [
                        _buildNoResults(
                            isDarkMode, 'لا توجد بلاغات خدمات', _serviceReportsSearchQuery),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredServiceReports.length,
                      itemBuilder: (context, index) {
                        return _buildReportCard(
                            filteredServiceReports[index], isDarkMode, 'service');
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // تبويب 2: بلاغات الموظفين مع التحديث
  Widget _buildEmployeeReportsView(
      bool isDarkMode, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      height: screenHeight,
      child: Column(
        children: [
          _buildSearchBar(
            isDarkMode,
            'ابحث في بلاغات الموظفين...',
            _employeeReportsSearchController,
            _updateEmployeeReportsSearch,
            _clearEmployeeReportsSearch,
            _employeeReportsSearchQuery,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshEmployeeReports,
              color: _primaryColor,
              backgroundColor: _cardColor(context),
              child: filteredEmployeeReports.isEmpty
                  ? ListView(
                      children: [
                        _buildNoResults(
                            isDarkMode, 'لا توجد بلاغات موظفين', _employeeReportsSearchQuery),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredEmployeeReports.length,
                      itemBuilder: (context, index) {
                        return _buildReportCard(
                            filteredEmployeeReports[index], isDarkMode, 'employee');
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // تبويب 3: بلاغات التطبيق مع التحديث
  Widget _buildAppReportsView(
      bool isDarkMode, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      height: screenHeight,
      child: Column(
        children: [
          _buildSearchBar(
            isDarkMode,
            'ابحث في بلاغات التطبيق...',
            _appReportsSearchController,
            _updateAppReportsSearch,
            _clearAppReportsSearch,
            _appReportsSearchQuery,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshAppReports,
              color: _primaryColor,
              backgroundColor: _cardColor(context),
              child: filteredAppReports.isEmpty
                  ? ListView(
                      children: [
                        _buildNoResults(
                            isDarkMode, 'لا توجد بلاغات تطبيق', _appReportsSearchQuery),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredAppReports.length,
                      itemBuilder: (context, index) {
                        return _buildReportCard(
                            filteredAppReports[index], isDarkMode, 'app');
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // تبويب 4: البلاغات الطارئة مع التحديث
  Widget _buildEmergencyReportsView(
      bool isDarkMode, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      height: screenHeight,
      child: Column(
        children: [
          _buildSearchBar(
            isDarkMode,
            'ابحث في البلاغات الطارئة...',
            _emergencyReportsSearchController,
            _updateEmergencyReportsSearch,
            _clearEmergencyReportsSearch,
            _emergencyReportsSearchQuery,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshEmergencyReports,
              color: _primaryColor,
              backgroundColor: _cardColor(context),
              child: filteredEmergencyReports.isEmpty
                  ? ListView(
                      children: [
                        _buildNoResults(
                            isDarkMode, 'لا توجد بلاغات طارئة', _emergencyReportsSearchQuery),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredEmergencyReports.length,
                      itemBuilder: (context, index) {
                        return _buildReportCard(
                            filteredEmergencyReports[index], isDarkMode, 'emergency');
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // تبويب 5: التقارير مع التحديث
  Widget _buildReportsView(
      bool isDarkMode, double screenWidth, double screenHeight) {
    return RefreshIndicator(
      onRefresh: _refreshReports,
      color: _primaryColor,
      backgroundColor: _cardColor(context),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                  child:
                      Icon(Icons.summarize_rounded, color: _primaryColor, size: 24),
                ),
                const SizedBox(width: 8),
                Text(
                  'نظام تقارير البلاغات',
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
                color: _cardColor(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderColor(context)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildReportInnerTabButton('إنشاء التقارير', 0, isDarkMode),
                  ),
                  Expanded(
                    child: _buildReportInnerTabButton('التقارير الواردة', 1, isDarkMode),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // عرض المحتوى حسب التبويب المختار
            _currentReportInnerTab == 0
                ? _buildCreateReportSection(isDarkMode)
                : _buildReceivedReportsSection(isDarkMode),
          ],
        ),
      ),
    );
  }

  // ==================== المكونات المساعدة ====================
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
            color: _textSecondaryColor(context),
          ),
        ),
      ],
    );
  }

  // شريط البحث
  Widget _buildSearchBar(
    bool isDarkMode,
    String hintText,
    TextEditingController controller,
    Function(String) onChanged,
    Function() onClear,
    String query,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
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
          controller: controller,
          onChanged: onChanged,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: _textSecondaryColor(context)),
            prefixIcon: Icon(Icons.search_rounded, color: _textSecondaryColor(context)),
            suffixIcon: query.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear_rounded, color: _textSecondaryColor(context)),
                    onPressed: onClear,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ),
    );
  }

  // بطاقة بلاغ
  Widget _buildReportCard(Map<String, dynamic> report, bool isDarkMode, String type) {
    Color priorityColor = _getPriorityColor(report['priority']);
    String priorityText = report['priority'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _borderColor(context),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: priorityColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: priorityColor, width: 1),
          ),
          child: Icon(
            _getReportIcon(type, report['priority']),
            color: priorityColor,
            size: 24,
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
                  color: _textColor(context),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: priorityColor.withOpacity(0.3)),
              ),
              child: Text(
                priorityText,
                style: TextStyle(
                  fontSize: 10,
                  color: priorityColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'من: ${report['citizenName']} - ${report['id']}',
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor(context),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              report['description'],
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor(context),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const SizedBox(width: 4),
                Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(report['date']),
                  style: TextStyle(
                    fontSize: 8,
                    color: _textSecondaryColor(context),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _textSecondaryColor(context),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.info_outline_rounded, size: 12, color: _textSecondaryColor(context)),
                const SizedBox(width: 4),
                Text(
                  report['status'],
                  style: TextStyle(
                    fontSize: 10,
                    color: _getStatusColor(report['status']),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (type == 'service' && report['serviceType'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(Icons.category_rounded, size: 10, color: _accentColor),
                    const SizedBox(width: 4),
                    Text(
                      'نوع الخدمة: ${report['serviceType']}',
                      style: TextStyle(
                        fontSize: 9,
                        color: _accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded, color: _textSecondaryColor(context)),
          onSelected: (value) => _handleReportAction(value, report, type),
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility_rounded, size: 18, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('عرض التفاصيل'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'assign',
              child: Row(
                children: [
                  Icon(Icons.person_add_rounded, size: 18, color: Colors.green),
                  SizedBox(width: 8),
                  Text('تعيين للمعالجة'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'update',
              child: Row(
                children: [
                  Icon(Icons.update_rounded, size: 18, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('تحديث الحالة'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'share',
              child: Row(
                children: [
                  Icon(Icons.share_rounded, size: 18, color: Colors.purple),
                  SizedBox(width: 8),
                  Text('مشاركة'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_rounded, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('حذف'),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          _showReportDetails(report, type, isDarkMode);
        },
      ),
    );
  }

  // دوال مساعدة للألوان والأيقونات
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'عالية جداً':
      case 'طارئة':
        return _errorColor;
      case 'عالية':
        return _warningColor;
      case 'متوسطة':
        return _accentColor;
      case 'منخفضة':
        return _successColor;
      default:
        return _textSecondaryColor(context);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'تمت المعالجة':
      case 'تم الإصلاح':
      case 'تم التحقيق':
        return _successColor;
      case 'قيد المعالجة':
      case 'قيد الإصلاح':
      case 'قيد التحقيق':
        return _warningColor;
      case 'تم الاستلام':
        return _primaryColor;
      default:
        return _textSecondaryColor(context);
    }
  }

  IconData _getReportIcon(String type, String priority) {
    if (priority == 'طارئة' || priority == 'عالية جداً') {
      return Icons.warning_rounded;
    }
    switch (type) {
      case 'service':
        return Icons.cleaning_services_rounded;
      case 'employee':
        return Icons.person_rounded;
      case 'app':
        return Icons.phone_android_rounded;
      case 'emergency':
        return Icons.emergency_rounded;
      default:
        return Icons.report_problem_rounded;
    }
  }

  void _handleReportAction(String action, Map<String, dynamic> report, String type) {
    switch (action) {
      case 'view':
        _showReportDetails(report, type, false);
        break;
      case 'assign':
        _showAssignDialog(report);
        break;
      case 'update':
        _showUpdateStatusDialog(report);
        break;
      case 'share':
        _shareReport(report);
        break;
      case 'delete':
        _deleteReport(report);
        break;
    }
  }

  // ==================== دوال التقارير (مشابهة للمحاسب) ====================

  Widget _buildReportInnerTabButton(String title, int tabIndex, bool isDarkMode) {
    bool isSelected = _currentReportInnerTab == tabIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentReportInnerTab = tabIndex;
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
              color: isSelected ? Colors.white : _textColor(context),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // قسم إنشاء التقارير
  Widget _buildCreateReportSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إنشاء تقرير جديد',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textColor(context),
          ),
        ),
        const SizedBox(height: 16),
        _buildReportTypeFilter(isDarkMode),
        const SizedBox(height: 20),
        _buildReportOptions(isDarkMode),
        const SizedBox(height: 20),
        _buildGenerateReportButton(isDarkMode),
        const SizedBox(height: 20),
        _buildQuickStats(isDarkMode),
      ],
    );
  }

  // قسم التقارير الواردة
  Widget _buildReceivedReportsSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchBar(
          isDarkMode,
          'ابحث في التقارير الواردة...',
          _reportsSearchController,
          _updateReportsSearch,
          _clearReportsSearch,
          _reportsSearchQuery,
        ),
        const SizedBox(height: 16),

        // إحصائيات سريعة للتقارير
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _backgroundColor(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor(context)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    filteredReceivedReports.length.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                  Text(
                    'إجمالي التقارير',
                    style: TextStyle(
                      color: _textSecondaryColor(context),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    filteredReceivedReports
                        .where((r) => r['status'] == 'غير مقروء')
                        .length
                        .toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _warningColor,
                    ),
                  ),
                  Text(
                    'غير مقروء',
                    style: TextStyle(
                      color: _textSecondaryColor(context),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '${_calculateTotalSize(filteredReceivedReports)} MB',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _successColor,
                    ),
                  ),
                  Text(
                    'الحجم الإجمالي',
                    style: TextStyle(
                      color: _textSecondaryColor(context),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // قائمة التقارير
        ...filteredReceivedReports.map((report) => _buildReceivedReportCard(report, isDarkMode)),
      ],
    );
  }

  // فلتر نوع التقرير
  Widget _buildReportTypeFilter(bool isDarkMode) {
    final List<String> _reportTypes = ['يومي', 'أسبوعي', 'شهري', 'ربع سنوي', 'سنوي'];

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
                        side: BorderSide(
                            color: isSelected ? _primaryColor : _borderColor(context)),
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

  // خيارات التقرير
  Widget _buildReportOptions(bool isDarkMode) {
    final List<String> _weeks = [
      'الأسبوع الأول',
      'الأسبوع الثاني',
      'الأسبوع الثالث',
      'الأسبوع الرابع'
    ];
    final List<String> _months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    final List<String> _quarters = ['الربع الأول', 'الربع الثاني', 'الربع الثالث', 'الربع الرابع'];

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
            if (_selectedReportType == 'أسبوعي')
              Column(
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
                        label: Text(week, style: const TextStyle(fontSize: 12)),
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
                          side: BorderSide(
                              color: isSelected ? _primaryColor : _borderColor(context)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            if (_selectedReportType == 'شهري')
              Column(
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
                        label: Text(month, style: const TextStyle(fontSize: 12)),
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
                          side: BorderSide(
                              color: isSelected ? _primaryColor : _borderColor(context)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            if (_selectedReportType == 'ربع سنوي')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اختر الربع',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _textColor(context),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _quarters.map((quarter) {
                      final isSelected = _selectedWeek == quarter; // نستخدم _selectedWeek مؤقتاً
                      return FilterChip(
                        label: Text(quarter, style: const TextStyle(fontSize: 12)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedWeek = selected ? quarter : null;
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
                          side: BorderSide(
                              color: isSelected ? _primaryColor : _borderColor(context)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // خيارات اليومي
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
          // بطاقة ملخص التواريخ
          Container(
            padding: const EdgeInsets.all(12),
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
                    const SizedBox(width: 8),
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
                const SizedBox(height: 8),
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
          const SizedBox(height: 16),

          // عرض التواريخ المختارة
          Text(
            'التواريخ المحددة:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _textColor(context),
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 120),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedDates.map((date) {
                  return Chip(
                    backgroundColor: _primaryColor,
                    label: Text(
                      DateFormat('yyyy-MM-dd').format(date),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    deleteIcon: const Icon(Icons.close, color: Colors.white, size: 16),
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
          // حالة عدم اختيار أي تواريخ
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
                Icon(Icons.calendar_today_outlined,
                    color: _textSecondaryColor(context), size: 48),
                const SizedBox(height: 12),
                Text(
                  'لم يتم اختيار أي تواريخ',
                  style: TextStyle(
                    color: _textSecondaryColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
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

  // زرار إنشاء التقرير
  Widget _buildGenerateReportButton(bool isDarkMode) {
    bool isFormValid = false;

    switch (_selectedReportType) {
      case 'يومي':
        isFormValid = _selectedDates.isNotEmpty;
        break;
      case 'أسبوعي':
      case 'ربع سنوي':
        isFormValid = _selectedWeek != null;
        break;
      case 'شهري':
        isFormValid = _selectedMonth != null;
        break;
      case 'سنوي':
        isFormValid = true; // يمكن إضافة اختيار السنة
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // إحصائيات سريعة
  Widget _buildQuickStats(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _backgroundColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إحصائيات سريعة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildQuickStatItem('تقارير هذا الشهر', '8',
                  Icons.calendar_today_rounded, _primaryColor),
              _buildQuickStatItem('تقارير معلقة', '3',
                  Icons.pending_rounded, _warningColor),
              _buildQuickStatItem('مشاركة هذا الشهر', '5',
                  Icons.share_rounded, _successColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatItem(
      String title, String value, IconData icon, Color color) {
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
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: _textSecondaryColor(context),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // بطاقة تقرير وارد
  Widget _buildReceivedReportCard(Map<String, dynamic> report, bool isDarkMode) {
    bool isUnread = report['status'] == 'غير مقروء';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
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
            color: _getReportFileColor(report['fileType']).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getReportFileIcon(report['fileType']),
            color: _getReportFileColor(report['fileType']),
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
                  color: _textColor(context),
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
            const SizedBox(height: 4),
            Text(
              'من: ${report['sender']}',
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor(context),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${DateFormat('yyyy-MM-dd').format(report['date'])} • ${report['type']} • ${report['size']}',
              style: TextStyle(
                fontSize: 10,
                color: _textSecondaryColor(context),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded, color: _textSecondaryColor(context)),
          onSelected: (value) {
            _handleReceivedReportAction(value, report);
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility_rounded, size: 18, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('عرض التقرير'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'download',
              child: Row(
                children: [
                  Icon(Icons.download_rounded, size: 18, color: Colors.green),
                  SizedBox(width: 8),
                  Text('تحميل'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'share',
              child: Row(
                children: [
                  Icon(Icons.share_rounded, size: 18, color: Colors.purple),
                  SizedBox(width: 8),
                  Text('مشاركة'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_rounded, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('حذف'),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          _viewReceivedReport(report);
        },
      ),
    );
  }

  Color _getReportFileColor(String fileType) {
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

  IconData _getReportFileIcon(String fileType) {
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

  String _calculateTotalSize(List<Map<String, dynamic>> reports) {
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

  void _handleReceivedReportAction(String action, Map<String, dynamic> report) {
    switch (action) {
      case 'view':
        _viewReceivedReport(report);
        break;
      case 'download':
        _downloadReport(report);
        break;
      case 'share':
        _shareReport(report);
        break;
      case 'delete':
        _deleteReport(report);
        break;
    }
  }

  void _viewReceivedReport(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        title: Row(
          children: [
            Icon(_getReportFileIcon(report['fileType']),
                color: _getReportFileColor(report['fileType'])),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                report['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _textColor(context),
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
              _buildReportDetailRow('المرسل:', report['sender']),
              _buildReportDetailRow('النوع:', report['type']),
              _buildReportDetailRow('الحجم:', report['size']),
              _buildReportDetailRow('صيغة الملف:', report['fileType']),
              _buildReportDetailRow('التاريخ:',
                  DateFormat('yyyy-MM-dd HH:mm').format(report['date'])),
              _buildReportDetailRow('الحالة:', report['status']),
              const SizedBox(height: 16),
              Text(
                'ملخص التقرير:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'هذا التقرير يحتوي على إحصائيات البلاغات البلدية والأداء خلال الفترة المحددة.',
                style: TextStyle(
                  color: _textSecondaryColor(context),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () => _downloadReport(report),
            child: const Text('تحميل'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportDetailRow(String label, String value) {
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
                color: _textSecondaryColor(context),
              ),
            ),
          ),
          Expanded(
            flex: 3,
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

  void _downloadReport(Map<String, dynamic> report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تحميل: ${report['title']}'),
        backgroundColor: _successColor,
      ),
    );
  }

  void _shareReport(Map<String, dynamic> report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('مشاركة: ${report['title']}'),
        backgroundColor: _primaryColor,
      ),
    );
  }

  void _deleteReport(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        title: Row(
          children: [
            Icon(Icons.delete_rounded, color: _errorColor),
            const SizedBox(width: 8),
            const Text('حذف التقرير'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من حذف تقرير "${report['title']}"؟',
          style: TextStyle(
            color: _textColor(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _errorColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                receivedReports.remove(report);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم حذف التقرير: ${report['title']}'),
                  backgroundColor: _errorColor,
                ),
              );
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  // دالة اختيار تواريخ متعددة
  void _showMultiDatePicker() {
    List<DateTime> tempSelectedDates = List.from(_selectedDates);

    showDialog(
      context: context,
      builder: (context) {
        DateTime focusedDay = DateTime.now();

        return Dialog(
          backgroundColor: _cardColor(context),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      Icon(Icons.calendar_today, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'اختر التواريخ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      if (tempSelectedDates.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
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
                                setState(() {
                                  focusedDay = focused;

                                  if (tempSelectedDates.any(
                                      (date) => isSameDay(date, selectedDay))) {
                                    tempSelectedDates.removeWhere(
                                        (date) => isSameDay(date, selectedDay));
                                  } else {
                                    tempSelectedDates.add(DateTime(
                                        selectedDay.year,
                                        selectedDay.month,
                                        selectedDay.day));
                                  }

                                  tempSelectedDates.sort((a, b) => a.compareTo(b));
                                });
                              },
                              calendarStyle: CalendarStyle(
                                defaultTextStyle:
                                    TextStyle(color: _textColor(context)),
                                todayTextStyle: TextStyle(
                                  color: _textColor(context),
                                  fontWeight: FontWeight.bold,
                                ),
                                selectedTextStyle: const TextStyle(
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
                                leftChevronIcon: Icon(Icons.chevron_left,
                                    color: _primaryColor),
                                rightChevronIcon: Icon(Icons.chevron_right,
                                    color: _primaryColor),
                                headerPadding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                headerMargin:
                                    const EdgeInsets.only(bottom: 8),
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
                              weekendDays: [
                                DateTime.friday,
                                DateTime.saturday
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // قسم التواريخ المختارة
                          if (tempSelectedDates.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(16),
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
                                      Icon(Icons.date_range_rounded,
                                          color: _primaryColor, size: 20),
                                      const SizedBox(width: 8),
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
                                  const SizedBox(height: 12),

                                  // عرض التواريخ
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: tempSelectedDates.map((date) {
                                      return Chip(
                                        backgroundColor: _primaryColor,
                                        label: Text(
                                          DateFormat('yyyy-MM-dd').format(date),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        deleteIcon: const Icon(Icons.close,
                                            color: Colors.white, size: 16),
                                        onDeleted: () {
                                          setState(() {
                                            tempSelectedDates.remove(date);
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),

                                  const SizedBox(height: 12),

                                  // نطاق التواريخ
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

                          // رسالة عند عدم اختيار تواريخ
                          if (tempSelectedDates.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(16),
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
                                  const SizedBox(height: 12),
                                  Text(
                                    'انقر على الأيام في التقويم',
                                    style: TextStyle(
                                      color: _textColor(context),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
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

                // الأزرار
                Container(
                  padding: const EdgeInsets.all(16),
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
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('إلغاء'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedDates = List.from(tempSelectedDates);
                            });
                            Navigator.pop(context);
                            _showSuccessSnackbar(
                                'تم اختيار ${_selectedDates.length} يوم');
                          },
                          child: const Text('تم الاختيار'),
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
            reportPeriod =
                '${DateFormat('yyyy-MM-dd').format(sortedDates.first)} إلى ${DateFormat('yyyy-MM-dd').format(sortedDates.last)}';
          }
        }
        break;
      case 'أسبوعي':
        reportPeriod = _selectedWeek ?? 'غير محدد';
        break;
      case 'شهري':
        reportPeriod = _selectedMonth ?? 'غير محدد';
        break;
      case 'ربع سنوي':
        reportPeriod = _selectedWeek ?? 'غير محدد'; // نستخدم _selectedWeek مؤقتاً
        break;
      case 'سنوي':
        reportPeriod = DateTime.now().year.toString();
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
        title: Text('التقرير $period',
            style: TextStyle(
                color: _primaryColor, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('نوع التقرير: $_selectedReportType',
                  style: TextStyle(color: _textColor(context))),
              if (_selectedReportType == 'يومي' && _selectedDates.isNotEmpty)
                Text('عدد الأيام: ${_selectedDates.length}',
                    style: TextStyle(color: _textColor(context))),
              if (_selectedWeek != null)
                Text('الأسبوع: $_selectedWeek',
                    style: TextStyle(color: _textColor(context))),
              if (_selectedMonth != null)
                Text('الشهر: $_selectedMonth',
                    style: TextStyle(color: _textColor(context))),
              const SizedBox(height: 16),
              Text('ملخص البلاغات:',
                  style: TextStyle(
                      color: _primaryColor, fontWeight: FontWeight.bold)),
              Text('- إجمالي البلاغات: ${getTotalReports()}',
                  style: TextStyle(color: _textColor(context))),
              Text('- بلاغات الخدمات: ${serviceReports.length}',
                  style: TextStyle(color: _textColor(context))),
              Text('- بلاغات الموظفين: ${employeeReports.length}',
                  style: TextStyle(color: _textColor(context))),
              Text('- بلاغات التطبيق: ${appReports.length}',
                  style: TextStyle(color: _textColor(context))),
              Text('- بلاغات طارئة: ${emergencyReports.length}',
                  style: TextStyle(color: _textColor(context))),
              Text('- قيد المعالجة: ${getPendingReports()}',
                  style: TextStyle(color: _textColor(context))),
              Text('- مكتملة: ${getCompletedReports()}',
                  style: TextStyle(color: _textColor(context))),
              Text('- عالية الأولوية: ${getHighPriorityReports()}',
                  style: TextStyle(color: _errorColor)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق',
                style: TextStyle(color: _textSecondaryColor(context))),
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
              _buildPdfReportsSummary(),
              pw.SizedBox(height: 20),
              _buildPdfReportsDetails(),
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
      final fileName =
          'تقرير_البلاغات_البلدية_${DateTime.now().millisecondsSinceEpoch}.pdf';

      await Share.shareXFiles(
        [
          XFile.fromData(
            pdfBytes,
            name: fileName,
            mimeType: 'application/pdf',
          )
        ],
        subject: 'تقرير البلاغات البلدية - $period',
        text: 'مرفق تقرير البلاغات البلدية للفترة $period',
      );

      _showSuccessSnackbar('تم تصدير التقرير بنجاح');
    } catch (e) {
      _showErrorSnackbar('خطأ في مشاركة الملف: $e');
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
              'وزارة البلدية - العراق',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green,
              ),
            ),
            pw.Text(
              'تقرير البلاغات',
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

  pw.Widget _buildPdfReportsSummary() {
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
            'ملخص البلاغات',
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
              pw.Text('إجمالي البلاغات:'),
              pw.Text('${getTotalReports()}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('بلاغات الخدمات:'),
              pw.Text('${serviceReports.length}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('بلاغات الموظفين:'),
              pw.Text('${employeeReports.length}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('بلاغات التطبيق:'),
              pw.Text('${appReports.length}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('البلاغات الطارئة:'),
              pw.Text('${emergencyReports.length}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('قيد المعالجة:'),
              pw.Text('${getPendingReports()}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('مكتملة:'),
              pw.Text('${getCompletedReports()}'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('عالية الأولوية:'),
              pw.Text('${getHighPriorityReports()}'),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfReportsDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'تفاصيل البلاغات',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.green,
          ),
        ),
        pw.SizedBox(height: 10),

        // بلاغات الخدمات
        pw.Text(
          'بلاغات الخدمات البلدية:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 5),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.green100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('رقم البلاغ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('المواطن',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('العنوان',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('نوع الخدمة',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الحالة',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            ...serviceReports.take(5).map((report) => pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(report['id']),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(report['citizenName']),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(report['title']),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(report['serviceType'] ?? '-'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(report['status']),
                    ),
                  ],
                )),
          ],
        ),

        pw.SizedBox(height: 15),

        // البلاغات الطارئة (أهمية خاصة)
        pw.Text(
          'البلاغات الطارئة:',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 5),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.red100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('رقم البلاغ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('المواطن',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('العنوان',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('نوع الطارئ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الحالة',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            ...emergencyReports.map((report) => pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(report['id']),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(report['citizenName']),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(report['title']),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(report['emergencyType'] ?? report['location']),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(report['status']),
                    ),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  PdfColor _getPdfPriorityColor(String priority) {
    switch (priority) {
      case 'عالية جداً':
      case 'طارئة':
        return PdfColors.red;
      case 'عالية':
        return PdfColors.orange;
      case 'متوسطة':
        return PdfColors.blue;
      case 'منخفضة':
        return PdfColors.green;
      default:
        return PdfColors.grey;
    }
  }

  // ==================== دوال عرض التفاصيل ====================

  void _showReportDetails(
      Map<String, dynamic> report, String type, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(_getReportIcon(type, report['priority']), color: _primaryColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'تفاصيل البلاغ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _textColor(context),
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
              _buildDetailRow('رقم البلاغ:', report['id']),
              _buildDetailRow('المواطن:', report['citizenName']),
              _buildDetailRow('رقم الهاتف:', report['citizenPhone']),
              _buildDetailRow('العنوان:', report['title']),
              _buildDetailRow('التفاصيل:', report['description']),
              if (type == 'employee') ...[
                _buildDetailRow('الموظف:', report['employeeName']),
                _buildDetailRow('رقم الموظف:', report['employeeId']),
                _buildDetailRow('القسم:', report['department']),
              ],
              if (type == 'app') ...[
                _buildDetailRow('نوع الجهاز:', report['deviceType']),
                _buildDetailRow('إصدار التطبيق:', report['appVersion']),
              ],
              if (type == 'service' || type == 'emergency') ...[
                _buildDetailRow('الموقع:', report['location']),
              ],
              if (type == 'service' && report['serviceType'] != null) ...[
                _buildDetailRow('نوع الخدمة:', report['serviceType']),
              ],
              if (type == 'emergency') ...[
                _buildDetailRow('وقت الاستجابة:', report['responseTime']),
                _buildDetailRow('نوع الطارئ:', report['emergencyType']),
              ],
              _buildDetailRow('التاريخ:', DateFormat('yyyy-MM-dd HH:mm').format(report['date'])),
              _buildDetailRow('الحالة:', report['status']),
              _buildDetailRow('الأولوية:', report['priority']),
              if (report['assignedTo'] != null)
                _buildDetailRow('مسند إلى:', report['assignedTo']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: _primaryColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              _showUpdateStatusDialog(report);
            },
            child: const Text('تحديث الحالة'),
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
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
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
                fontWeight: FontWeight.w500,
                color: _textColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateStatusDialog(Map<String, dynamic> report) {
    String selectedStatus = report['status'];
    final List<String> statuses = [
      'تم الاستلام',
      'قيد المعالجة',
      'تمت المعالجة',
      'مغلوق'
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تحديث حالة البلاغ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses.map((status) {
            return RadioListTile<String>(
              title: Text(status),
              value: status,
              groupValue: selectedStatus,
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                  report['status'] = selectedStatus;
                });
                Navigator.pop(context);
                _showSuccessSnackbar('تم تحديث الحالة إلى: $status');
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  void _showAssignDialog(Map<String, dynamic> report) {
    final TextEditingController assignController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تعيين للمعالجة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: assignController,
              decoration: const InputDecoration(
                labelText: 'اسم المسؤول/الفريق',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (assignController.text.isNotEmpty) {
                setState(() {
                  report['assignedTo'] = assignController.text;
                });
                Navigator.pop(context);
                _showSuccessSnackbar('تم تعيين البلاغ إلى: ${assignController.text}');
              }
            },
            child: const Text('تعيين'),
          ),
        ],
      ),
    );
  }

  void _showAddReportDialog(BuildContext context, bool isDarkMode) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String selectedType = 'service';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('إضافة بلاغ جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'نوع البلاغ',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'service', child: Text('بلاغ خدمة بلدية')),
                  DropdownMenuItem(value: 'employee', child: Text('بلاغ موظف')),
                  DropdownMenuItem(value: 'app', child: Text('بلاغ تطبيق')),
                  DropdownMenuItem(value: 'emergency', child: Text('بلاغ طارئ')),
                ],
                onChanged: (value) {
                  selectedType = value!;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان البلاغ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'تفاصيل البلاغ',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                setState(() {
                  final newReport = {
                    'id': 'BLD-${selectedType.toUpperCase()}-${DateTime.now().millisecond}',
                    'citizenName': 'مواطن جديد',
                    'citizenPhone': '077${DateTime.now().millisecond}',
                    'title': titleController.text,
                    'description': descriptionController.text,
                    'date': DateTime.now(),
                    'status': 'تم الاستلام',
                    'priority': 'متوسطة',
                  };

                  switch (selectedType) {
                    case 'service':
                      newReport.addAll({
                        'location': 'موقع جديد',
                        'assignedTo': 'قيد التقييم',
                        'serviceType': 'خدمة جديدة',
                      });
                      serviceReports.insert(0, newReport);
                      break;
                    case 'employee':
                      newReport.addAll({
                        'employeeName': 'موظف جديد',
                        'employeeId': 'EMP-NEW',
                        'department': 'قسم جديد',
                        'location': 'دائرة بلدية جديدة',
                      });
                      employeeReports.insert(0, newReport);
                      break;
                    case 'app':
                      newReport.addAll({
                        'deviceType': 'جهاز جديد',
                        'appVersion': '2.1.0',
                      });
                      appReports.insert(0, newReport);
                      break;
                    case 'emergency':
                      newReport.addAll({
                        'location': 'موقع جديد',
                        'responseTime': 'فوري',
                        'emergencyType': 'نوع طارئ',
                      });
                      emergencyReports.insert(0, newReport);
                      break;
                  }
                });
                Navigator.pop(context);
                _showSuccessSnackbar('تم إضافة البلاغ بنجاح');
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  // ==================== القائمة الجانبية ====================

  Widget _buildGovernmentDrawer(BuildContext context, bool isDarkMode) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [_darkPrimaryColor, const Color(0xFF0D2B1E)]
                : [_primaryColor, const Color(0xFF2E8B57)],
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
                      : [_primaryColor, const Color(0xFF2E8B57)],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(
                      Icons.apartment_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "مسؤول البلاغات",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "وزارة البلدية - قسم البلاغات",
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

            // القائمة الرئيسية
            Expanded(
              child: Container(
                color: isDarkMode ? const Color(0xFF0D2B1E) : const Color(0xFFE8F5E9),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 20),

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
                            'وزارة البلدية - نظام البلاغات',
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
        backgroundColor: _cardColor(context),
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
              backgroundColor: _errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('تسجيل الخروج'),
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

  // ==================== دوال رسائل ====================

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

  Widget _buildNoResults(bool isDarkMode, String message, String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
               size: 64,
               color: _textSecondaryColor(context)),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: _textSecondaryColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (query.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'لم يتم العثور على نتائج تطابق "$query"',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _textSecondaryColor(context),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// كلاس مساعد للتحكم في التحديث
class RefreshController {
  void refreshCompleted() {
    // يمكن إضافة منطق إضافي هنا إذا لزم الأمر
  }
  
  void dispose() {
    // تنظيف الموارد إذا لزم الأمر
  }
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
// شاشة الاشعارات (مطابقة لشاشة المحاسب)
class NotificationsScreen extends StatefulWidget {
  static const String routeName = '/notifications';

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final Color _primaryColor = const Color(0xFF2E7D32);
  final Color _secondaryColor = const Color(0xFFD4AF37);
  final Color _backgroundColor = const Color(0xFFF5F5F5);
  final Color _cardColor = const Color(0xFFFFFFFF);
  final Color _textColor = const Color(0xFF212121);
  final Color _textSecondaryColor = const Color(0xFF757575);
  final Color _borderColor = const Color(0xFFE0E0E0);

  int _selectedTab = 0;
  final List<String> _tabs = ['الوسائل', 'الطلبات', 'الوظائف', 'الكل'];
  final List<Map<String, dynamic>> _allNotifications = [
    // تبويب الوسائل
    {
      'id': '1',
      'type': 'message',
      'title': 'رسالة جديدة',
      'description': 'لديك رسالة من الإدارة بخصوص تحديث نظام البلاغات',
      'time': 'منذ 3 ساعات',
      'read': true,
      'tab': 0,
    },
    {
      'id': '2',
      'type': 'system',
      'title': 'تحديث النظام',
      'description': 'تم تحديث نظام البلاغات إلى الإصدار 2.1.0',
      'time': 'منذ يوم',
      'read': true,
      'tab': 0,
    },
    {
      'id': '3',
      'type': 'announcement',
      'title': 'إعلان هام',
      'description': 'اجتماع طارئ لموظفي قسم البلاغات يوم الخميس القادم',
      'time': 'منذ يومين',
      'read': true,
      'tab': 0,
    },

    // تبويب الطلبات
    {
      'id': '4',
      'type': 'report',
      'title': 'بلاغ جديد',
      'description': 'بلاغ جديد من المواطن أحمد محمد بخصوص انقطاع التيار',
      'time': 'منذ 5 دقائق',
      'read': false,
      'tab': 1,
    },
    {
      'id': '5',
      'type': 'complaint',
      'title': 'شكوى جديدة',
      'description': 'شكوى من المواطن فاطمة علي بخصوص موظف',
      'time': 'منذ ساعة',
      'read': false,
      'tab': 1,
    },
    {
      'id': '6',
      'type': 'emergency',
      'title': 'بلاغ طارئ جديد',
      'description': 'بلاغ طارئ من المواطن خالد إبراهيم بخصوص حريق',
      'time': 'منذ ساعتين',
      'read': false,
      'tab': 1,
    },

    // تبويب الوظائف
    {
      'id': '7',
      'type': 'assignment',
      'title': 'تعيين جديد',
      'description': 'تم تعيينك مسؤولاً عن متابعة بلاغات المنطقة الشمالية',
      'time': 'منذ 10 دقائق',
      'read': false,
      'tab': 2,
    },
    {
      'id': '8',
      'type': 'task',
      'title': 'مهمة جديدة',
      'description': 'مهمة جديدة لمراجعة تقارير الأداء الشهرية',
      'time': 'منذ 3 أيام',
      'read': true,
      'tab': 2,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedTab == 3) {
      return _allNotifications;
    }
    return _allNotifications
        .where((notification) => notification['tab'] == _selectedTab)
        .toList();
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
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
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

          Container(
            height: 1,
            color: _borderColor,
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshNotifications,
              color: _primaryColor,
              backgroundColor: _cardColor,
              child: _filteredNotifications.isEmpty
                  ? ListView(
                      children: [
                        _buildEmptyState(),
                      ],
                    )
                  : ListView.builder(
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

  Future<void> _refreshNotifications() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      // يمكن إضافة إشعار جديد هنا
    });
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

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification['title'],
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                notification['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: _textSecondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    notification['time'],
                    style: TextStyle(
                      fontSize: 12,
                      color: _textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          color: _borderColor,
          margin: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ],
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
          const SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 18,
              color: _textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
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
}