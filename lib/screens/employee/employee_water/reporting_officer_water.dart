import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mang_mu/screens/employee/Shared Services/esignin_screen.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:async';
class ReportingOfficerWaterScreen extends StatefulWidget {
  @override
  _ReportingOfficerWaterScreenState createState() => _ReportingOfficerWaterScreenState();
}

class _ReportingOfficerWaterScreenState extends State<ReportingOfficerWaterScreen> 
    with TickerProviderStateMixin {
  
  final SupabaseClient _supabase = Supabase.instance.client;
  
  // متغيرات الطوارئ
  Map<String, String> _emergencySubTabStatus = {
    'emergency': 'غير مقروءة',
  };
  late TabController _emergencyTabController;
  List<Map<String, dynamic>> _emergencyReports = [];
  bool _isLoadingEmergency = true;
  late TabController _emergencySubTabController;
  final RefreshController _emergencyRefreshController = RefreshController();
  late TabController _mainTabController;
  late TabController _waterTabController;
  late TabController _employeeTabController;
  late TabController _appTabController;
  late TabController _waterSubTabController;
  late TabController _employeeSubTabController;
  late TabController _appSubTabController;
  late AnimationController _animationController;
  
  // متغيرات التقارير
  bool _isLoadingReports = false;
  
  // متغيرات التحكم في التحديث
  final RefreshController _waterRefreshController = RefreshController();
  final RefreshController _employeeRefreshController = RefreshController();
  final RefreshController _appRefreshController = RefreshController();
  final RefreshController _reportsRefreshController = RefreshController();
  
  // بيانات البلاغات
  List<Map<String, dynamic>> _waterReports = [];
  List<Map<String, dynamic>> _employeeReports = [];
  List<Map<String, dynamic>> _appReports = [];
  
  bool _isLoadingWater = true;
  bool _isLoadingEmployee = true;
  bool _isLoadingApp = true;
  
  final TextEditingController _searchController = TextEditingController();
  
  // ألوان وزارة المياه
  final Color _primaryColor = Color(0xFF0072B5);
  final Color _secondaryColor = Color(0xFF00A0DC);
  final Color _accentColor = Color(0xFF00C1D4);
  final Color _warningColor = Color(0xFFFF9800);
  final Color _dangerColor = Color(0xFFD32F2F);
  final Color _infoColor = Color(0xFF0097A7);
  final Color _darkColor = Color(0xFF005A8C);
  final Color _lightColor = Color(0xFFF5F7FA);
  final Color _successColor = Color(0xFF2E7D32);
  
  // نظام التقارير
  String _selectedReportTypeSystem = 'يومي';
  List<DateTime> _selectedDates = [];
  String? _selectedWeek;
  String? _selectedMonth;
  final List<String> _reportTypes = ['يومي', 'أسبوعي', 'شهري'];
  final List<String> _weeks = ['الأسبوع الأول', 'الأسبوع الثاني', 'الأسبوع الثالث', 'الأسبوع الرابع'];
  final List<String> _months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
  
  Map<String, String> _subTabStatus = {
    'water': 'غير مقروءة',
    'employee': 'غير مقروءة',
    'app': 'غير مقروءة',
    'emergency': 'غير مقروءة',
  };
  
  final Map<String, Color> _statusColors = {
    'pending': Color(0xFFFF9800),
    'in_progress': Color(0xFF2196F3),
    'resolved': Color(0xFF4CAF50),
    'rejected': Color(0xFFF44336),
  };
  
  final Map<String, String> _statusText = {
    'pending': 'قيد الانتظار',
    'in_progress': 'قيد المعالجة',
    'resolved': 'تم الحل',
    'rejected': 'مرفوض',
  };
  
  // متغير لتحديث الإشعارات تلقائياً
  int _notificationsVersion = 0;
  
  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 5, vsync: this);
    _waterTabController = TabController(length: 5, vsync: this);
    _employeeTabController = TabController(length: 4, vsync: this);
    _appTabController = TabController(length: 4, vsync: this);
    _emergencyTabController = TabController(length: 5, vsync: this);
    _waterSubTabController = TabController(length: 2, vsync: this);
    _employeeSubTabController = TabController(length: 2, vsync: this);
    _appSubTabController = TabController(length: 2, vsync: this);
    _emergencySubTabController = TabController(length: 2, vsync: this);
    _loadUnreadNotificationsCount();

    _emergencySubTabController.addListener(() {
      setState(() {
        _emergencySubTabStatus['emergency'] = _emergencySubTabController.index == 0 ? 'غير مقروءة' : 'مقروءة';
      });
    });
    
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    
    _loadWaterReports();
    _loadEmployeeReports();
    _loadAppReports();
    _loadEmergencyReports();
    
    _filterReports();
    
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
    
    // تحديث الإشعارات كل 10 ثوانٍ
    Timer.periodic(Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _notificationsVersion++;
        });
      }
    });
  }
 Future<void> _transferReportToTechnician(Map<String, dynamic> report) async {
  // تأكيد التحويل
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.engineering, color: _primaryColor),
          SizedBox(width: 8),
          Text(
            'تحويل البلاغ إلى فني الصيانة',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
      content: Text(
        'هل أنت متأكد من تحويل هذا البلاغ إلى فني الصيانة؟',
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            await _performTransferToTechnician(report);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
          ),
          child: Text('تحويل'),
        ),
      ],
    ),
  );
}

/// تنفيذ عملية التحويل إلى فني الصيانة (بدون التحقق من تسجيل الدخول)
Future<void> _performTransferToTechnician(Map<String, dynamic> report) async {
  setState(() => _isLoadingReports = true);
  
  try {
    final supabase = Supabase.instance.client;
    
    // استخدام معرف ثابت للمستخدم الذي يقوم بالتحويل (موظف البلاغات)
    final String defaultUserId = '16fa69df-76f5-461f-9901-dcee7b7ac83c'; // معرف المستخدم الثابت
    
    // الحصول على معرف فني الصيانة
    String technicianId = '';
    String technicianName = '';
    
    try {
      // جلب أول فني صيانة متاح
      final technicians = await supabase
          .schema('water')
          .from('technicians')
          .select('id, full_name')
          .eq('is_active', true)
          .limit(1);
      
      if (technicians.isNotEmpty) {
        technicianId = technicians[0]['id'];
        technicianName = technicians[0]['full_name'];
      } else {
        // إذا لم يوجد فنيين، استخدم معرف افتراضي
        technicianId = '123e4567-e89b-12d3-a456-426614174000';
        technicianName = 'فني الصيانة';
      }
    } catch (e) {
      technicianId = '123e4567-e89b-12d3-a456-426614174000';
      technicianName = 'فني الصيانة';
      print('⚠️ تم استخدام فني افتراضي: $e');
    }
    
    // إدخال المهمة المحولة إلى قاعدة البيانات
    final transferredTask = {
      'report_id': report['id'],
      'report_type': report['report_type'],
      'title': _getSubTypeText(report),
      'description': report['description'],
      'location': report['location'],
      'priority': report['priority'] ?? 'medium',
      'status': 'pending',
      'assigned_to': technicianId,
      'assigned_from': defaultUserId,  // استخدام المعرف الثابت بدلاً من user.id
      'citizen_name': report['citizen_name'],
      'citizen_phone': report['citizen_phone'],
      'sub_type': _getSubTypeText(report),
      'images': report['images'] ?? [],
      'transferred_at': DateTime.now().toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    
    await supabase
        .schema('water')
        .from('transferred_tasks')
        .insert(transferredTask);
    
    print('✅ تم تحويل البلاغ بنجاح إلى الفني: $technicianName');
    
    // تحديث حالة البلاغ الأصلي إلى 'transferred'
    await supabase
        .schema('water')
        .from('water_reports')
        .update({
          'status': 'transferred',
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', report['id']);
    
    // إزالة البلاغ من القائمة الحالية
    setState(() {
      if (report['report_type'] == 'service_problem') {
        _waterReports.removeWhere((r) => r['id'] == report['id']);
      } else if (report['report_type'] == 'employee_fault') {
        _employeeReports.removeWhere((r) => r['id'] == report['id']);
      } else if (report['report_type'] == 'app_problem') {
        _appReports.removeWhere((r) => r['id'] == report['id']);
      } else if (report['report_type'] == 'emergency') {
        _emergencyReports.removeWhere((r) => r['id'] == report['id']);
      }
    });
    
    _showSuccessSnackbar('تم تحويل البلاغ بنجاح إلى فني الصيانة');
    
  } catch (e) {
    print('❌ خطأ في تحويل البلاغ: $e');
    _showErrorSnackbar('حدث خطأ في تحويل البلاغ: ${e.toString()}');
  } finally {
    setState(() => _isLoadingReports = false);
  }
}

/// تنفيذ عملية التحويل
Future<void> _performTransfer(Map<String, dynamic> report, String technicianId, String technicianName) async {
  setState(() => _isLoadingReports = true);
  
  try {
    final supabase = Supabase.instance.client;
    
    
    print('✅ الفني المستهدف: $technicianId');
    
    // إنشاء معرف فريد للبلاغ المحول
    DateTime.now().millisecondsSinceEpoch.toString();
    
    // إدخال المهمة المحولة إلى قاعدة البيانات
    final transferredTask = {
      'id': supabase.rpc('gen_random_uuid'),
      'report_id': report['id'],
      'report_type': report['report_type'],
      'title': _getSubTypeText(report),
      'description': report['description'],
      'location': report['location'],
      'priority': report['priority'] ?? 'medium',
      'status': 'pending',
      'assigned_to': technicianId,
      'citizen_name': report['citizen_name'],
      'citizen_phone': report['citizen_phone'],
      'sub_type': _getSubTypeText(report),
      'images': report['images'] ?? [],
      'transferred_at': DateTime.now().toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    
    print('📤 جاري تحويل البلاغ...');
    print('📋 بيانات التحويل: ${transferredTask.keys}');
    
    await supabase
        .schema('water')
        .from('transferred_tasks')
        .insert(transferredTask);
    
    print('✅ تم تحويل البلاغ بنجاح إلى الفني: $technicianName');
    
    // تحديث حالة البلاغ الأصلي إلى 'transferred'
    await supabase
        .schema('water')
        .from('water_reports')
        .update({
          'status': 'transferred',
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', report['id']);
    
    // إزالة البلاغ من القائمة الحالية
    setState(() {
      if (report['report_type'] == 'service_problem') {
        _waterReports.removeWhere((r) => r['id'] == report['id']);
      } else if (report['report_type'] == 'employee_fault') {
        _employeeReports.removeWhere((r) => r['id'] == report['id']);
      } else if (report['report_type'] == 'app_problem') {
        _appReports.removeWhere((r) => r['id'] == report['id']);
      } else if (report['report_type'] == 'emergency') {
        _emergencyReports.removeWhere((r) => r['id'] == report['id']);
      }
    });
    
    _showSuccessSnackbar('تم تحويل البلاغ بنجاح إلى الفني: $technicianName');
    
  } catch (e) {
    print('❌ خطأ في تحويل البلاغ: $e');
    _showErrorSnackbar('حدث خطأ في تحويل البلاغ: ${e.toString()}');
  } finally {
    setState(() => _isLoadingReports = false);
  }
}
  
  Future<void> _loadUnreadNotificationsCount() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;
      
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('❌ خطأ في تحميل عدد الإشعارات: $e');
    }
  }
  
  Future<void> _loadEmergencyReports() async {
    setState(() => _isLoadingEmergency = true);
    
    try {
      final response = await _supabase
          .schema('water')
          .from('water_reports')
          .select()
          .eq('report_type', 'emergency')
          .order('created_at', ascending: false);
          
      if (mounted) {
        setState(() {
          _emergencyReports = List<Map<String, dynamic>>.from(response);
          _isLoadingEmergency = false;
        });
        print('✅ تم تحميل ${_emergencyReports.length} بلاغ طوارئ');
      }
    } catch (e) {
      print('❌ خطأ في تحميل بلاغات الطوارئ: $e');
      if (mounted) {
        setState(() => _isLoadingEmergency = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في تحميل بلاغات الطوارئ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> _onEmergencyRefresh() async {
    await _loadEmergencyReports();
    _emergencyRefreshController.refreshCompleted();
  }
  
  Future<void> _loadWaterReports() async {
    setState(() => _isLoadingWater = true);
    
    try {
      final response = await _supabase
          .schema('water')
          .from('water_reports')
          .select()
          .eq('report_type', 'service_problem')
          .order('created_at', ascending: false);
          
      if (mounted) {
        setState(() {
          _waterReports = List<Map<String, dynamic>>.from(response);
          _isLoadingWater = false;
        });
        print('✅ تم تحميل ${_waterReports.length} بلاغ مياه');
        
        final Set<String> uniqueSubTypes = {};
        for (var report in _waterReports) {
          uniqueSubTypes.add(report['sub_type'] ?? 'غير محدد');
          print('   - نوع المشكلة: ${report['sub_type']}');
        }
        
        print('أنواع المشاكل الموجودة:');
        for (var type in uniqueSubTypes) {
          print('   * $type');
        }
        
        _checkCategoriesData();
      }
    } catch (e) {
      print('❌ خطأ في تحميل بلاغات المياه: $e');
      if (mounted) {
        setState(() => _isLoadingWater = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في تحميل بلاغات المياه: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> _loadEmployeeReports() async {
    setState(() => _isLoadingEmployee = true);
    
    try {
      final response = await _supabase
          .schema('water')
          .from('water_reports')
          .select()
          .eq('report_type', 'employee_fault')
          .order('created_at', ascending: false);
          
      if (mounted) {
        setState(() {
          _employeeReports = List<Map<String, dynamic>>.from(response);
          _isLoadingEmployee = false;
        });
        print('✅ تم تحميل ${_employeeReports.length} بلاغ موظفين');
      }
    } catch (e) {
      print('❌ خطأ في تحميل بلاغات الموظفين: $e');
      if (mounted) {
        setState(() => _isLoadingEmployee = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في تحميل بلاغات الموظفين: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> _loadAppReports() async {
    setState(() => _isLoadingApp = true);
    
    try {
      final response = await _supabase
          .schema('water')
          .from('water_reports')
          .select()
          .eq('report_type', 'app_problem')
          .order('created_at', ascending: false);
          
      if (mounted) {
        setState(() {
          _appReports = List<Map<String, dynamic>>.from(response);
          _isLoadingApp = false;
        });
        print('✅ تم تحميل ${_appReports.length} بلاغ تطبيق');
      }
    } catch (e) {
      print('❌ خطأ في تحميل بلاغات التطبيق: $e');
      if (mounted) {
        setState(() => _isLoadingApp = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في تحميل بلاغات التطبيق: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> _updateReportStatus(String reportId, String newStatus) async {
    try {
      await _supabase
          .schema('water')
          .from('water_reports')
          .update({
            'status': newStatus,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', reportId);
          
      _loadWaterReports();
      _loadEmployeeReports();
      _loadAppReports();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم تحديث حالة البلاغ إلى ${_statusText[newStatus]}'),
            backgroundColor: _statusColors[newStatus],
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('❌ خطأ في تحديث الحالة: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في تحديث الحالة: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  Future<void> _markReportAsRead(String reportId, String reportType) async {
  try {
    await _supabase
        .schema('water')
        .from('water_reports')
        .update({'is_read': true})
        .eq('id', reportId);
        setState(() {
      if (reportType == 'service_problem') {
        final index = _waterReports.indexWhere((r) => r['id'] == reportId);
        if (index != -1) {
          _waterReports[index]['is_read'] = true;
        }
      } else if (reportType == 'employee_fault') {
        final index = _employeeReports.indexWhere((r) => r['id'] == reportId);
        if (index != -1) {
          _employeeReports[index]['is_read'] = true;
        }
      } else if (reportType == 'app_problem') {
        final index = _appReports.indexWhere((r) => r['id'] == reportId);
        if (index != -1) {
          _appReports[index]['is_read'] = true;
        }
      } else if (reportType == 'emergency') {
        final index = _emergencyReports.indexWhere((r) => r['id'] == reportId);
        if (index != -1) {
          _emergencyReports[index]['is_read'] = true;
        }
      }
    });
    
    print('✅ تم تمييز البلاغ كمقروء: $reportId');
    
  } catch (e) {
    print('❌ خطأ في تمييز البلاغ كمقروء: $e');
  }
}
  
  List<Map<String, dynamic>> _filterReportsByReadStatus(List<Map<String, dynamic>> reports, String tabType) {
    String currentSubTab = _subTabStatus[tabType] ?? 'غير مقروءة';
    return reports.where((report) {
      bool isRead = report['is_read'] ?? false;
      return currentSubTab == 'غير مقروءة' ? !isRead : isRead;
    }).toList();
  }
  
  List<Map<String, dynamic>> _filterWaterReportsByCategory(String category) {
    return _waterReports.where((report) {
      String subType = report['sub_type'] ?? '';
      String subTypeLower = subType.toLowerCase();
      
      switch (category) {
        case 'انقطاع الماء':
          return subTypeLower.contains('انقطاع') || subType == 'انقطاع الماء';
        case 'مشكلة في العداد':
          return subTypeLower.contains('عداد') || subType == 'مشكلة في العداد' ||
                 subTypeLower.contains('meter') || subTypeLower.contains('counter');
        case 'جودة المياه':
          return subTypeLower.contains('جودة') || subType == 'جودة المياه' ||
                 subTypeLower.contains('quality');
        case 'تسرب بسيط':
          return subTypeLower.contains('تسرب') || subType == 'تسرب بسيط' ||
                 subTypeLower.contains('leak');
        case 'أخرى':
          return !subTypeLower.contains('انقطاع') && !subTypeLower.contains('عداد') &&
                 !subTypeLower.contains('جودة') && !subTypeLower.contains('تسرب') &&
                 subType != 'انقطاع الماء' && subType != 'مشكلة في العداد' &&
                 subType != 'جودة المياه' && subType != 'تسرب بسيط';
        default:
          return true;
      }
    }).toList();
  }
  
  void _checkCategoriesData() {
    print('========== تحليل بيانات البلاغات ==========');
    print('إجمالي البلاغات: ${_waterReports.length}');
    
    final categories = [
      'انقطاع الماء',
      'مشكلة في العداد', 
      'جودة المياه',
      'تسرب بسيط',
      'أخرى'
    ];
    
    for (var category in categories) {
      final filtered = _filterWaterReportsByCategory(category);
      print('$category: ${filtered.length} بلاغ');
      if (filtered.isNotEmpty) {
        print('  أمثلة:');
        for (var i = 0; i < filtered.length && i < 3; i++) {
          print('    - ${filtered[i]['sub_type']}');
        }
      }
    }
    print('==========================================');
  }
  
  List<Map<String, dynamic>> _filterEmployeeReportsByType(String type) {
    return _employeeReports.where((report) {
      return report['employee_type'] == type;
    }).toList();
  }
  
  List<Map<String, dynamic>> _filterAppReportsByType(String type) {
    return _appReports.where((report) {
      return report['sub_type'] == type;
    }).toList();
  }
  
  void _filterReports() {
    final now = DateTime.now();
    _searchController.text.toLowerCase();
    setState(() {
      if (_selectedReportTypeSystem == 'اليوم') {
      } else if (_selectedReportTypeSystem == 'الأسبوع') {
        now.subtract(Duration(days: now.weekday - 1));
      } else if (_selectedReportTypeSystem == 'الشهر') {
      }
    });
  }
  
  String _getReportTypeText(String? type) {
    switch (type) {
      case 'emergency':
        return 'بلاغ طارئ';
      case 'service_problem':
        return 'مشكلة في الخدمة';
      case 'employee_fault':
        return 'تقصير موظفين';
      case 'app_problem':
        return 'مشكلة في التطبيق';
      default:
        return type ?? 'غير معروف';
    }
  }
  
  String _getSubTypeText(Map<String, dynamic> report) {
    if (report['report_type'] == 'emergency') {
      return report['emergency_type'] ?? report['sub_type'] ?? 'غير محدد';
    } else if (report['report_type'] == 'employee_fault') {
      return report['employee_type'] ?? report['sub_type'] ?? 'غير محدد';
    }
    return report['sub_type'] ?? 'غير محدد';
  }
  
  String _getStatusText(String? status) {
    return _statusText[status] ?? status ?? 'غير معروف';
  }
  
  Color _getStatusColor(String? status) {
    return _statusColors[status] ?? Colors.grey;
  }
  
  String _getPriorityText(String? priority) {
    switch (priority) {
      case 'high':
        return 'عالي';
      case 'medium':
        return 'متوسط';
      case 'low':
        return 'منخفض';
      default:
        return 'غير محدد';
    }
  }
  
  Color _getPriorityColor(String? priority) {
    switch (priority) {
      case 'high':
        return _dangerColor;
      case 'medium':
        return _warningColor;
      case 'low':
        return _successColor;
      default:
        return Colors.grey;
    }
  }
  
  // دالة لجلب ملخص التقارير حسب الفترة
  Future<Map<String, dynamic>> _getReportsSummary({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return {};
      
      final startDateTime = DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
      final endDateTime = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
      
      final startIso = startDateTime.toIso8601String();
      final endIso = endDateTime.toIso8601String();
      
      print('🔍 جلب التقارير من: $startIso');
      print('🔍 إلى: $endIso');
      
      final response = await _supabase
          .schema('water')
          .from('water_reports')
          .select()
          .gte('created_at', startIso)
          .lte('created_at', endIso);
      
      final reports = List<Map<String, dynamic>>.from(response);
      print('✅ تم العثور على ${reports.length} بلاغ في الفترة المحددة');
      
      for (var i = 0; i < reports.length && i < 3; i++) {
        print('   - البلاغ ${i+1}: ${reports[i]['report_type']} - ${reports[i]['sub_type']} - ${reports[i]['created_at']}');
      }
      
      Map<String, dynamic> summary = {
        'total': reports.length,
        'by_type': {
          'emergency': reports.where((r) => r['report_type'] == 'emergency').length,
          'service_problem': reports.where((r) => r['report_type'] == 'service_problem').length,
          'employee_fault': reports.where((r) => r['report_type'] == 'employee_fault').length,
          'app_problem': reports.where((r) => r['report_type'] == 'app_problem').length,
        },
        'by_status': {
          'pending': reports.where((r) => r['status'] == 'pending').length,
          'in_progress': reports.where((r) => r['status'] == 'in_progress').length,
          'resolved': reports.where((r) => r['status'] == 'resolved').length,
          'rejected': reports.where((r) => r['status'] == 'rejected').length,
        },
        'by_emergency_type': {
          'تسرب مياه خطير': reports.where((r) => 
            r['report_type'] == 'emergency' && 
            (r['emergency_type']?.contains('تسرب') ?? false)).length,
          'أنابيب مكسورة': reports.where((r) => 
            r['report_type'] == 'emergency' && 
            (r['emergency_type']?.contains('أنابيب') ?? false)).length,
          'مياه جارية بغزارة': reports.where((r) => 
            r['report_type'] == 'emergency' && 
            (r['emergency_type']?.contains('جارية') ?? false)).length,
          'خطر غرق': reports.where((r) => 
            r['report_type'] == 'emergency' && 
            (r['emergency_type']?.contains('غرق') ?? false)).length,
          'أخرى': reports.where((r) => 
            r['report_type'] == 'emergency' && 
            !(r['emergency_type']?.contains('تسرب') ?? false) &&
            !(r['emergency_type']?.contains('أنابيب') ?? false) &&
            !(r['emergency_type']?.contains('جارية') ?? false) &&
            !(r['emergency_type']?.contains('غرق') ?? false)).length,
        },
        'by_water_type': {
          'انقطاع الماء': reports.where((r) => 
            r['report_type'] == 'service_problem' && 
            (r['sub_type']?.contains('انقطاع') ?? false)).length,
          'مشكلة في العداد': reports.where((r) => 
            r['report_type'] == 'service_problem' && 
            (r['sub_type']?.contains('عداد') ?? false)).length,
          'جودة المياه': reports.where((r) => 
            r['report_type'] == 'service_problem' && 
            (r['sub_type']?.contains('جودة') ?? false)).length,
          'تسرب بسيط': reports.where((r) => 
            r['report_type'] == 'service_problem' && 
            (r['sub_type']?.contains('تسرب') ?? false)).length,
          'أخرى': reports.where((r) => 
            r['report_type'] == 'service_problem' && 
            !(r['sub_type']?.contains('انقطاع') ?? false) &&
            !(r['sub_type']?.contains('عداد') ?? false) &&
            !(r['sub_type']?.contains('جودة') ?? false) &&
            !(r['sub_type']?.contains('تسرب') ?? false)).length,
        },
        'by_employee_type': {
          'موظف الصيانة': reports.where((r) => 
            r['report_type'] == 'employee_fault' && 
            r['employee_type'] == 'موظف الصيانة').length,
          'موظف الفواتير': reports.where((r) => 
            r['report_type'] == 'employee_fault' && 
            r['employee_type'] == 'موظف الفواتير').length,
          'موظف استقبال البلاغات': reports.where((r) => 
            r['report_type'] == 'employee_fault' && 
            r['employee_type'] == 'موظف استقبال البلاغات').length,
          'آخر': reports.where((r) => 
            r['report_type'] == 'employee_fault' && 
            r['employee_type'] == 'آخر').length,
        },
        'by_app_type': {
          'تعطل في التطبيق': reports.where((r) => 
            r['report_type'] == 'app_problem' && 
            r['sub_type'] == 'تعطل في التطبيق').length,
          'مشكلة في الدفع': reports.where((r) => 
            r['report_type'] == 'app_problem' && 
            r['sub_type'] == 'مشكلة في الدفع').length,
          'واجهة المستخدم': reports.where((r) => 
            r['report_type'] == 'app_problem' && 
            r['sub_type'] == 'واجهة المستخدم').length,
          'أخرى': reports.where((r) => 
            r['report_type'] == 'app_problem' && 
            r['sub_type'] == 'أخرى').length,
        },
        'reports': reports,
      };
      
      return summary;
    } catch (e) {
      print('❌ خطأ في جلب ملخص التقارير: $e');
      return {};
    }
  }
  
  // دالة لتوليد التقرير اليومي
  Future<void> _generateDailyReport() async {
    if (_selectedDates.isEmpty) {
      _showErrorSnackbar('يرجى اختيار التواريخ أولاً');
      return;
    }
    
    setState(() => _isLoadingReports = true);
    
    try {
      final sortedDates = List<DateTime>.from(_selectedDates)..sort();
      final startDate = sortedDates.first;
      final endDate = sortedDates.last;
      
      final summary = await _getReportsSummary(startDate: startDate, endDate: endDate);
      
      if (summary.isEmpty) {
        _showErrorSnackbar('لا توجد بيانات لعرض التقرير');
        return;
      }
      
      _showReportDialog(summary, 'يومي', '$startDate إلى $endDate');
    } catch (e) {
      print('❌ خطأ في إنشاء التقرير اليومي: $e');
      _showErrorSnackbar('حدث خطأ في إنشاء التقرير: $e');
    } finally {
      setState(() => _isLoadingReports = false);
    }
  }
  
  // دالة لتوليد التقرير الأسبوعي
  Future<void> _generateWeeklyReport() async {
    if (_selectedWeek == null) {
      _showErrorSnackbar('يرجى اختيار الأسبوع أولاً');
      return;
    }
    
    setState(() => _isLoadingReports = true);
    
    try {
      final now = DateTime.now();
      DateTime startDate;
      DateTime endDate;
      
      switch (_selectedWeek) {
        case 'الأسبوع الأول':
          startDate = DateTime(now.year, now.month, 1);
          endDate = DateTime(now.year, now.month, 7);
          break;
        case 'الأسبوع الثاني':
          startDate = DateTime(now.year, now.month, 8);
          endDate = DateTime(now.year, now.month, 14);
          break;
        case 'الأسبوع الثالث':
          startDate = DateTime(now.year, now.month, 15);
          endDate = DateTime(now.year, now.month, 21);
          break;
        case 'الأسبوع الرابع':
          startDate = DateTime(now.year, now.month, 22);
          endDate = DateTime(now.year, now.month, DateTime(now.year, now.month + 1, 0).day);
          break;
        default:
          startDate = DateTime(now.year, now.month, 1);
          endDate = DateTime(now.year, now.month, 7);
      }
      
      final summary = await _getReportsSummary(startDate: startDate, endDate: endDate);
      
      if (summary.isEmpty) {
        _showErrorSnackbar('لا توجد بيانات لعرض التقرير');
        return;
      }
      
      _showReportDialog(summary, 'أسبوعي', '${_selectedWeek} من ${DateFormat('MM/yyyy').format(now)}');
    } catch (e) {
      print('❌ خطأ في إنشاء التقرير الأسبوعي: $e');
      _showErrorSnackbar('حدث خطأ في إنشاء التقرير: $e');
    } finally {
      setState(() => _isLoadingReports = false);
    }
  }
  
  // دالة لتوليد التقرير الشهري
  Future<void> _generateMonthlyReport() async {
    if (_selectedMonth == null) {
      _showErrorSnackbar('يرجى اختيار الشهر أولاً');
      return;
    }
    
    setState(() => _isLoadingReports = true);
    
    try {
      final now = DateTime.now();
      final monthIndex = _months.indexOf(_selectedMonth!);
      final year = now.year;
      
      final startDate = DateTime(year, monthIndex + 1, 1);
      final endDate = DateTime(year, monthIndex + 2, 0);
      
      final summary = await _getReportsSummary(startDate: startDate, endDate: endDate);
      
      if (summary.isEmpty) {
        _showErrorSnackbar('لا توجد بيانات لعرض التقرير');
        return;
      }
      
      _showReportDialog(summary, 'شهري', '${_selectedMonth} ${year}');
    } catch (e) {
      print('❌ خطأ في إنشاء التقرير الشهري: $e');
      _showErrorSnackbar('حدث خطأ في إنشاء التقرير: $e');
    } finally {
      setState(() => _isLoadingReports = false);
    }
  }
  
  // دالة لعرض التقرير في نافذة منبثقة
  void _showReportDialog(Map<String, dynamic> summary, String periodType, String periodName) {
    final total = summary['total'] ?? 0;
    final byType = summary['by_type'] ?? {};
    final byStatus = summary['by_status'] ?? {};
    final byEmergencyType = summary['by_emergency_type'] ?? {};
    final byWaterType = summary['by_water_type'] ?? {};
    final byEmployeeType = summary['by_employee_type'] ?? {};
    final byAppType = summary['by_app_type'] ?? {};
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_primaryColor, _secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(Icons.summarize, color: Colors.white, size: 40),
                    SizedBox(height: 8),
                    Text(
                      'تقرير ${periodType}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      periodName,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'إجمالي البلاغات: $total',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildReportSection('📊 البلاغات حسب النوع', [
                        _buildReportRow('بلاغات طارئة', byType['emergency'] ?? 0, total),
                        _buildReportRow('مشاكل المياه', byType['service_problem'] ?? 0, total),
                        _buildReportRow('تقصير موظفين', byType['employee_fault'] ?? 0, total),
                        _buildReportRow('مشاكل التطبيق', byType['app_problem'] ?? 0, total),
                      ]),
                      
                      SizedBox(height: 16),
                      
                      _buildReportSection('🔄 البلاغات حسب الحالة', [
                        _buildReportRow('قيد الانتظار', byStatus['pending'] ?? 0, total, color: _warningColor),
                        _buildReportRow('قيد المعالجة', byStatus['in_progress'] ?? 0, total, color: _infoColor),
                        _buildReportRow('تم الحل', byStatus['resolved'] ?? 0, total, color: _successColor),
                        _buildReportRow('مرفوض', byStatus['rejected'] ?? 0, total, color: _dangerColor),
                      ]),
                      
                      if ((byType['emergency'] ?? 0) > 0) ...[
                        SizedBox(height: 16),
                        _buildReportSection('🚨 تفاصيل البلاغات الطارئة', [
                          _buildReportRow('تسرب مياه خطير', byEmergencyType['تسرب مياه خطير'] ?? 0, byType['emergency'] ?? 0),
                          _buildReportRow('أنابيب مكسورة', byEmergencyType['أنابيب مكسورة'] ?? 0, byType['emergency'] ?? 0),
                          _buildReportRow('مياه جارية بغزارة', byEmergencyType['مياه جارية بغزارة'] ?? 0, byType['emergency'] ?? 0),
                          _buildReportRow('خطر غرق', byEmergencyType['خطر غرق'] ?? 0, byType['emergency'] ?? 0),
                          _buildReportRow('أخرى', byEmergencyType['أخرى'] ?? 0, byType['emergency'] ?? 0),
                        ]),
                      ],
                      
                      if ((byType['service_problem'] ?? 0) > 0) ...[
                        SizedBox(height: 16),
                        _buildReportSection('💧 تفاصيل مشاكل المياه', [
                          _buildReportRow('انقطاع الماء', byWaterType['انقطاع الماء'] ?? 0, byType['service_problem'] ?? 0),
                          _buildReportRow('مشكلة في العداد', byWaterType['مشكلة في العداد'] ?? 0, byType['service_problem'] ?? 0),
                          _buildReportRow('جودة المياه', byWaterType['جودة المياه'] ?? 0, byType['service_problem'] ?? 0),
                          _buildReportRow('تسرب بسيط', byWaterType['تسرب بسيط'] ?? 0, byType['service_problem'] ?? 0),
                          _buildReportRow('أخرى', byWaterType['أخرى'] ?? 0, byType['service_problem'] ?? 0),
                        ]),
                      ],
                      
                      if ((byType['employee_fault'] ?? 0) > 0) ...[
                        SizedBox(height: 16),
                        _buildReportSection('👤 تفاصيل تقصير الموظفين', [
                          _buildReportRow('موظف الصيانة', byEmployeeType['موظف الصيانة'] ?? 0, byType['employee_fault'] ?? 0),
                          _buildReportRow('موظف الفواتير', byEmployeeType['موظف الفواتير'] ?? 0, byType['employee_fault'] ?? 0),
                          _buildReportRow('موظف استقبال البلاغات', byEmployeeType['موظف استقبال البلاغات'] ?? 0, byType['employee_fault'] ?? 0),
                          _buildReportRow('آخر', byEmployeeType['آخر'] ?? 0, byType['employee_fault'] ?? 0),
                        ]),
                      ],
                      
                      if ((byType['app_problem'] ?? 0) > 0) ...[
                        SizedBox(height: 16),
                        _buildReportSection('📱 تفاصيل مشاكل التطبيق', [
                          _buildReportRow('تعطل في التطبيق', byAppType['تعطل في التطبيق'] ?? 0, byType['app_problem'] ?? 0),
                          _buildReportRow('مشكلة في الدفع', byAppType['مشكلة في الدفع'] ?? 0, byType['app_problem'] ?? 0),
                          _buildReportRow('واجهة المستخدم', byAppType['واجهة المستخدم'] ?? 0, byType['app_problem'] ?? 0),
                          _buildReportRow('أخرى', byAppType['أخرى'] ?? 0, byType['app_problem'] ?? 0),
                        ]),
                      ],
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                      label: Text('إغلاق'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _exportReportToPdf(summary, periodType, periodName),
                      icon: Icon(Icons.picture_as_pdf),
                      label: Text('تصدير PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _dangerColor,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
  
  Widget _buildReportSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _primaryColor.withOpacity(0.3)),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
        ),
        SizedBox(height: 8),
        ...children,
      ],
    );
  }
  
  Widget _buildReportRow(String label, int count, int total, {Color? color}) {
    final percentage = total > 0 ? (count / total * 100).toStringAsFixed(1) : '0';
    final barWidth = total > 0 ? (count / total) : 0.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              Text(
                '$count بلاغ ($percentage%)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color ?? _primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              widthFactor: barWidth.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: color ?? _primaryColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // دالة لتصدير التقرير إلى PDF
  Future<void> _exportReportToPdf(Map<String, dynamic> summary, String periodType, String periodName) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(color: _primaryColor),
        ),
      );
      
      final total = summary['total'] ?? 0;
      final byType = summary['by_type'] ?? {};
      final byStatus = summary['by_status'] ?? {};
      final byEmergencyType = summary['by_emergency_type'] ?? {};
      final byWaterType = summary['by_water_type'] ?? {};
      final byEmployeeType = summary['by_employee_type'] ?? {};
      final byAppType = summary['by_app_type'] ?? {};
      
      final pdfWhite = PdfColors.white;
      final pdfWhiteLight = PdfColor.fromInt(0xFFF5F5F5);
      final pdfGrey = PdfColors.grey;
      final pdfGreyLight = PdfColor.fromInt(0xFFEEEEEE);
      final pdfBlue = PdfColors.blue;
      final pdfBlueDark = PdfColor.fromInt(0xFF1976D2);
      final pdfBlueLight = PdfColor.fromInt(0xFFE3F2FD);
      final pdfOrange = PdfColor.fromInt(0xFFFF9800);
      final pdfRed = PdfColor.fromInt(0xFFF44336);
      final pdfGreen = PdfColor.fromInt(0xFF4CAF50);
      
      final pdf = pw.Document();
      
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Container(
                padding: pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue700,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Icon(pw.IconData(0xe3c9), size: 40, color: pdfWhite),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'تقرير $periodType',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: pdfWhite,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      periodName,
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: pdfWhiteLight,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 10),
                    pw.Container(
                      padding: pw.EdgeInsets.all(10),
                      decoration: pw.BoxDecoration(
                        color: pdfWhite,
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Text(
                        'إجمالي البلاغات: $total',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue700,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 20),
              
              pw.Container(
                padding: pw.EdgeInsets.all(15),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: pdfGreyLight),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'معلومات التقرير',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue700,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    _buildPdfInfoRow('نوع التقرير', periodType),
                    _buildPdfInfoRow('الفترة', periodName),
                    _buildPdfInfoRow('تاريخ الإنشاء', DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())),
                    _buildPdfInfoRow('عدد البلاغات', total.toString()),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 20),
              
              _buildPdfSection('📊 البلاغات حسب النوع', pdfBlueLight, pdfBlueDark, [
                _buildPdfStatRow('بلاغات طارئة', byType['emergency'] ?? 0, total, color: pdfRed),
                _buildPdfStatRow('مشاكل المياه', byType['service_problem'] ?? 0, total, color: pdfBlue),
                _buildPdfStatRow('تقصير موظفين', byType['employee_fault'] ?? 0, total, color: pdfOrange),
                _buildPdfStatRow('مشاكل التطبيق', byType['app_problem'] ?? 0, total, color: pdfGreen),
              ]),
              
              pw.SizedBox(height: 20),
              
              _buildPdfSection('🔄 البلاغات حسب الحالة', pdfBlueLight, pdfBlueDark, [
                _buildPdfStatRow('قيد الانتظار', byStatus['pending'] ?? 0, total, color: pdfOrange),
                _buildPdfStatRow('قيد المعالجة', byStatus['in_progress'] ?? 0, total, color: pdfBlue),
                _buildPdfStatRow('تم الحل', byStatus['resolved'] ?? 0, total, color: pdfGreen),
                _buildPdfStatRow('مرفوض', byStatus['rejected'] ?? 0, total, color: pdfRed),
              ]),
              
              if ((byType['emergency'] ?? 0) > 0) ...[
                pw.SizedBox(height: 20),
                _buildPdfSection('🚨 تفاصيل البلاغات الطارئة', pdfBlueLight, pdfBlueDark, [
                  _buildPdfStatRow('تسرب مياه خطير', byEmergencyType['تسرب مياه خطير'] ?? 0, byType['emergency'] ?? 0, color: pdfRed),
                  _buildPdfStatRow('أنابيب مكسورة', byEmergencyType['أنابيب مكسورة'] ?? 0, byType['emergency'] ?? 0, color: pdfOrange),
                  _buildPdfStatRow('مياه جارية بغزارة', byEmergencyType['مياه جارية بغزارة'] ?? 0, byType['emergency'] ?? 0, color: pdfBlue),
                  _buildPdfStatRow('خطر غرق', byEmergencyType['خطر غرق'] ?? 0, byType['emergency'] ?? 0, color: PdfColors.purple),
                  _buildPdfStatRow('أخرى', byEmergencyType['أخرى'] ?? 0, byType['emergency'] ?? 0, color: pdfGrey),
                ]),
              ],
              
              if ((byType['service_problem'] ?? 0) > 0) ...[
                pw.SizedBox(height: 20),
                _buildPdfSection('💧 تفاصيل مشاكل المياه', pdfBlueLight, pdfBlueDark, [
                  _buildPdfStatRow('انقطاع الماء', byWaterType['انقطاع الماء'] ?? 0, byType['service_problem'] ?? 0, color: pdfRed),
                  _buildPdfStatRow('مشكلة في العداد', byWaterType['مشكلة في العداد'] ?? 0, byType['service_problem'] ?? 0, color: pdfOrange),
                  _buildPdfStatRow('جودة المياه', byWaterType['جودة المياه'] ?? 0, byType['service_problem'] ?? 0, color: pdfBlue),
                  _buildPdfStatRow('تسرب بسيط', byWaterType['تسرب بسيط'] ?? 0, byType['service_problem'] ?? 0, color: pdfGreen),
                  _buildPdfStatRow('أخرى', byWaterType['أخرى'] ?? 0, byType['service_problem'] ?? 0, color: pdfGrey),
                ]),
              ],
              
              if ((byType['employee_fault'] ?? 0) > 0) ...[
                pw.SizedBox(height: 20),
                _buildPdfSection('👤 تفاصيل تقصير الموظفين', pdfBlueLight, pdfBlueDark, [
                  _buildPdfStatRow('موظف الصيانة', byEmployeeType['موظف الصيانة'] ?? 0, byType['employee_fault'] ?? 0, color: pdfRed),
                  _buildPdfStatRow('موظف الفواتير', byEmployeeType['موظف الفواتير'] ?? 0, byType['employee_fault'] ?? 0, color: pdfOrange),
                  _buildPdfStatRow('موظف استقبال البلاغات', byEmployeeType['موظف استقبال البلاغات'] ?? 0, byType['employee_fault'] ?? 0, color: pdfBlue),
                  _buildPdfStatRow('آخر', byEmployeeType['آخر'] ?? 0, byType['employee_fault'] ?? 0, color: pdfGrey),
                ]),
              ],
              
              if ((byType['app_problem'] ?? 0) > 0) ...[
                pw.SizedBox(height: 20),
                _buildPdfSection('📱 تفاصيل مشاكل التطبيق', pdfBlueLight, pdfBlueDark, [
                  _buildPdfStatRow('تعطل في التطبيق', byAppType['تعطل في التطبيق'] ?? 0, byType['app_problem'] ?? 0, color: pdfRed),
                  _buildPdfStatRow('مشكلة في الدفع', byAppType['مشكلة في الدفع'] ?? 0, byType['app_problem'] ?? 0, color: pdfOrange),
                  _buildPdfStatRow('واجهة المستخدم', byAppType['واجهة المستخدم'] ?? 0, byType['app_problem'] ?? 0, color: pdfBlue),
                  _buildPdfStatRow('أخرى', byAppType['أخرى'] ?? 0, byType['app_problem'] ?? 0, color: pdfGrey),
                ]),
              ],
              
              pw.SizedBox(height: 30),
              
              pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Column(
                  children: [
                    pw.Divider(),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'وزارة المياه - نظام الإبلاغات الذكي',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: pdfGrey,
                      ),
                    ),
                    pw.Text(
                      'تم إنشاء هذا التقرير بواسطة النظام الآلي',
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: pdfGrey,
                      ),
                    ),
                    pw.Text(
                      'رقم التقرير: #${DateTime.now().millisecondsSinceEpoch}',
                      style: pw.TextStyle(
                        fontSize: 8,
                        color: pdfGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
        ),
      );
      
      final bytes = await pdf.save();
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/تقرير_${periodType}_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(bytes);
      
      Navigator.pop(context);
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.picture_as_pdf, color: Colors.red),
              SizedBox(width: 8),
              Text('تصدير التقرير'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: _successColor, size: 50),
              SizedBox(height: 16),
              Text(
                'تم إنشاء ملف PDF بنجاح',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'حجم الملف: ${(bytes.length / 1024).toStringAsFixed(2)} KB',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 8),
              Text(
                'اختر الإجراء المناسب:',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                final result = await OpenFile.open(file.path);
                if (result.type != ResultType.done) {
                  _showErrorSnackbar('لا يوجد تطبيق لعرض PDF');
                }
              },
              icon: Icon(Icons.visibility),
              label: Text('فتح'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await Share.shareXFiles(
                  [XFile(file.path)],
                  subject: 'تقرير ${periodType} - ${periodName}',
                  text: 'مرفق تقرير البلاغات للفترة $periodName',
                );
                _showSuccessSnackbar('تم مشاركة التقرير بنجاح');
              },
              icon: Icon(Icons.share),
              label: Text('مشاركة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _secondaryColor,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await Printing.sharePdf(bytes: bytes, filename: 'تقرير_$periodType.pdf');
                _showSuccessSnackbar('تم فتح التقرير');
              },
              icon: Icon(Icons.print),
              label: Text('طباعة / عرض'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _secondaryColor,
              ),
            ),
          ],
        ),
      );
      
    } catch (e) {
      print('❌ خطأ في تصدير التقرير: $e');
      Navigator.pop(context);
      _showErrorSnackbar('حدث خطأ في تصدير التقرير: $e');
    }
  }
  
  pw.Widget _buildPdfInfoRow(String label, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 12,
                color: PdfColors.grey700,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(fontSize: 12),
              textAlign: pw.TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
  
  pw.Widget _buildPdfSection(String title, PdfColor bgColor, PdfColor textColor, List<pw.Widget> children) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: pw.BoxDecoration(
            color: bgColor,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Column(children: children),
      ],
    );
  }
  
  pw.Widget _buildPdfStatRow(String label, int count, int total, {PdfColor? color}) {
    final percentage = total > 0 ? (count / total * 100).toStringAsFixed(1) : '0';
    
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(
              label,
              style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
            ),
          ),
          pw.SizedBox(width: 20),
          pw.Text(
            '$count بلاغ ($percentage%)',
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: color ?? PdfColors.blue700,
            ),
          ),
        ],
      ),
    );
  }
  
  String _getLocation(Map<String, dynamic> report) {
    return report['location'] ?? 'غير محدد';
  }
  
  void _showProblemDetails(Map<String, dynamic> report) {
    if ((report['is_read'] ?? false) == false) {
      _markReportAsRead(report['id'], report['report_type']);
    }
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.water_drop, color: Colors.white),
                    SizedBox(width: 8),
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
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailSection('معلومات المواطن', [
                        _buildDetailRow('الاسم', report['citizen_name'] ?? 'غير معروف'),
                        _buildDetailRow('رقم الهاتف', report['citizen_phone'] ?? 'غير معروف'),
                      ]),
                      SizedBox(height: 16),
                      _buildDetailSection('معلومات البلاغ', [
                        _buildDetailRow('نوع البلاغ', _getReportTypeText(report['report_type'])),
                        _buildDetailRow('نوع المشكلة', _getSubTypeText(report)),
                        _buildDetailRow('الوصف', report['description'] ?? 'غير معروف'),
                        if (report['location'] != null && report['location'].toString().isNotEmpty)
                          _buildDetailRow('الموقع', report['location']),
                        _buildDetailRow('تاريخ الإبلاغ',
                            report['created_at'] != null
                                ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(report['created_at']))
                                : 'غير معروف'),
                        _buildDetailRow('الحالة', _getStatusText(report['status'])),
                      ]),
                      if (report['report_type'] == 'emergency') ...[
                        SizedBox(height: 16),
                        _buildDetailSection('معلومات الطوارئ', [
                          _buildDetailRow('نوع الطارئ', report['emergency_type'] ?? report['sub_type'] ?? 'غير محدد'),
                        ]),
                      ],
                      if (report['report_type'] == 'employee_fault') ...[
                        SizedBox(height: 16),
                        _buildDetailSection('معلومات الموظف', [
                          _buildDetailRow('نوع الموظف', report['employee_type'] ?? 'غير محدد'),
                          if (report['employee_name'] != null && report['employee_name'].toString().isNotEmpty)
                            _buildDetailRow('اسم الموظف', report['employee_name']),
                          if (report['incident_date'] != null)
                            _buildDetailRow('تاريخ الحادثة', report['incident_date']),
                          if (report['incident_time'] != null)
                            _buildDetailRow('وقت الحادثة', report['incident_time']),
                        ]),
                      ],
                      if (report['report_type'] == 'app_problem') ...[
                        SizedBox(height: 16),
                        _buildDetailSection('معلومات التطبيق', [
                          if (report['contact_phone'] != null && report['contact_phone'].toString().isNotEmpty)
                            _buildDetailRow('رقم للتواصل', report['contact_phone']),
                        ]),
                      ],
                      if (report['images'] != null && (report['images'] as List).isNotEmpty) ...[
                        SizedBox(height: 16),
                        _buildDetailSection('الصور المرفقة', []),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: (report['images'] as List).length,
                            itemBuilder: (context, imgIndex) {
                              final imageUrl = (report['images'] as List)[imgIndex];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    imageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey[300],
                                        child: Icon(Icons.broken_image, color: Colors.grey[600]),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: Column(
                  children: [
                    if (report['status'] != 'resolved' && report['status'] != 'rejected')
                      Row(
                        children: [
                          if (report['status'] != 'in_progress')
                            Expanded(
                              child: _buildStatusButton(
                                'قيد المعالجة',
                                'in_progress',
                                Color(0xFF2196F3),
                                report['id'],
                              ),
                            ),
                          if (report['status'] != 'in_progress') SizedBox(width: 12),
                          if (report['status'] != 'resolved')
                            Expanded(
                              child: _buildStatusButton(
                                'تم الحل',
                                'resolved',
                                Color(0xFF4CAF50),
                                report['id'],
                              ),
                            ),
                          if (report['status'] != 'resolved') SizedBox(width: 12),
                          if (report['status'] != 'rejected')
                            Expanded(
                              child: _buildStatusButton(
                                'مرفوض',
                                'rejected',
                                Color(0xFFF44336),
                                report['id'],
                              ),
                            ),
                        ],
                      ),
                    SizedBox(height: 12),
                    // زر تحويل البلاغ إلى فني الصيانة
SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
    onPressed: () {
      Navigator.pop(context); // إغلاق نافذة التفاصيل أولاً
      _transferReportToTechnician(report); // ثم فتح نافذة التحويل
    },
    icon: Icon(Icons.engineering, color: _primaryColor),
    label: Text('تحويل البلاغ إلى فني الصيانة'),
    style: OutlinedButton.styleFrom(
      foregroundColor: _primaryColor,
      side: BorderSide(color: _primaryColor),
      padding: EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
),
                    SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('إغلاق'),
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
  
  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _primaryColor.withOpacity(0.3)),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _primaryColor,
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(height: 8),
        ...children,
      ],
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[900],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatusButton(String label, String status, Color color, String reportId) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        _updateReportStatus(reportId, status);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label, style: TextStyle(fontSize: 12)),
    );
  }
  
  Future<void> _shareReport(Map<String, dynamic> report) async {
    final reportDetails = '''
📋 **نوع البلاغ:** ${_getReportTypeText(report['report_type'])}
👤 **المواطن:** ${report['citizen_name'] ?? 'غير معروف'}
📞 **رقم الهاتف:** ${report['citizen_phone'] ?? 'غير معروف'}
📌 **نوع المشكلة:** ${_getSubTypeText(report)}
📝 **الوصف:** ${report['description']}
📍 **الموقع:** ${report['location'] ?? 'غير محدد'}
📅 **التاريخ:** ${report['created_at'] != null ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(report['created_at'])) : 'غير محدد'}
🔄 **الحالة:** ${_getStatusText(report['status'])}
    ''';
    
    try {
      await Share.share(reportDetails, subject: 'بلاغ جديد - وزارة المياه');
    } catch (e) {
      print('❌ خطأ في المشاركة: $e');
    }
  }
  
  Widget _buildEmergencyContentTemplate({
    required String title,
    required IconData icon,
    required Color color,
    required List<Map<String, dynamic>> reports,
    required bool isLoading,
  }) {
    final filteredByReadStatus = _filterReportsByReadStatus(reports, 'emergency');
    
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
                          'وزارة المياه - غرفة الطوارئ',
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
                          '${reports.where((p) => !(p['is_read'] ?? false)).length}',
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
                  controller: _emergencySubTabController,
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
                              '${reports.where((p) => !(p['is_read'] ?? false)).length}',
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
                              '${reports.where((p) => p['is_read'] ?? false).length}',
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
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: color))
              : filteredByReadStatus.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            _emergencySubTabStatus['emergency'] == 'غير مقروءة'
                                ? 'لا توجد بلاغات طوارئ غير مقروءة'
                                : 'لا توجد بلاغات طوارئ مقروءة',
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
                        final report = filteredByReadStatus[index];
                        final isRead = report['is_read'] ?? false;
                        final status = report['status'];
                        final statusColor = _getStatusColor(status);
                        
                        return Card(
                          margin: EdgeInsets.only(bottom: 12),
                          elevation: isRead ? 1 : 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isRead ? Colors.grey[300]! : color.withOpacity(0.5),
                              width: isRead ? 1 : 2,
                            ),
                          ),
                          child: InkWell(
                            onTap: () => _showProblemDetails(report),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
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
                                        ),
                                        child: Icon(icon, color: color, size: 22),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              report['citizen_name'] ?? 'غير معروف',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                                color: isRead ? Colors.grey[700] : color,
                                              ),
                                            ),
                                            Text(
                                              report['citizen_phone'] ?? 'غير معروف',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          _getStatusText(status),
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
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      report['emergency_type'] ?? _getSubTypeText(report),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: color,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    report['description'] ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isRead ? Colors.grey[600] : Colors.grey[800],
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (!isRead)
                                        InkWell(
                                          onTap: () => _markReportAsRead(report['id'], report['report_type']),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.mark_email_read, size: 14, color: Colors.green),
                                                SizedBox(width: 4),
                                                Text(
                                                  'تمييز كمقروء',
                                                  style: TextStyle(fontSize: 10, color: Colors.green),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      SizedBox(width: 8),
                                      InkWell(
                                        onTap: () => _shareReport(report),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: color.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.share, size: 14, color: color),
                                              SizedBox(width: 4),
                                              Text(
                                                'مشاركة',
                                                style: TextStyle(fontSize: 10, color: color),
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
                        );
                      },
                    ),
        ),
      ],
    );
  }
  
  List<Map<String, dynamic>> _filterEmergencyReportsByType(String type) {
    return _emergencyReports.where((report) {
      String emergencyType = report['emergency_type'] ?? report['sub_type'] ?? '';
      String emergencyTypeLower = emergencyType.toLowerCase();
      
      switch (type) {
        case 'تسرب مياه':
          return emergencyTypeLower.contains('تسرب');
        case 'أنابيب مكسورة':
          return emergencyTypeLower.contains('أنابيب') || emergencyTypeLower.contains('مكسورة');
        case 'مياه جارية بغزارة':
          return emergencyTypeLower.contains('جارية') || emergencyTypeLower.contains('محول');
        case 'خطر غرق':
          return emergencyTypeLower.contains('غرق') || emergencyTypeLower.contains('انهيار');
        case 'أخرى':
          return !emergencyTypeLower.contains('تسرب') && 
                 !emergencyTypeLower.contains('أنابيب') &&
                 !emergencyTypeLower.contains('مكسورة') &&
                 !emergencyTypeLower.contains('جارية') &&
                 !emergencyTypeLower.contains('محول') &&
                 !emergencyTypeLower.contains('غرق') &&
                 !emergencyTypeLower.contains('انهيار');
        default:
          return emergencyType == type;
      }
    }).toList();
  }
  
  Widget _buildEmergencyType1Content() {
    final filteredProblems = _filterEmergencyReportsByType('تسرب مياه');
    return _buildEmergencyContentTemplate(
      title: 'تسرب مياه',
      icon: Icons.water_damage,
      color: Color(0xFFD32F2F),
      reports: filteredProblems,
      isLoading: _isLoadingEmergency,
    );
  }
  
  Widget _buildEmergencyType2Content() {
    final filteredProblems = _filterEmergencyReportsByType('أنابيب مكسورة');
    return _buildEmergencyContentTemplate(
      title: 'أنابيب مكسورة',
      icon: Icons.water,
      color: Color(0xFFFF9800),
      reports: filteredProblems,
      isLoading: _isLoadingEmergency,
    );
  }
  
  Widget _buildEmergencyType3Content() {
    final filteredProblems = _filterEmergencyReportsByType('مياه جارية بغزارة');
    return _buildEmergencyContentTemplate(
      title: 'مياه جارية بغزارة',
      icon: Icons.waves,
      color: Color(0xFFF44336),
      reports: filteredProblems,
      isLoading: _isLoadingEmergency,
    );
  }
  
  Widget _buildEmergencyType4Content() {
    final filteredProblems = _filterEmergencyReportsByType('خطر غرق');
    return _buildEmergencyContentTemplate(
      title: 'خطر غرق أو انهيار',
      icon: Icons.warning_amber,
      color: Color(0xFFC2185B),
      reports: filteredProblems,
      isLoading: _isLoadingEmergency,
    );
  }
  
  Widget _buildEmergencyOtherContent() {
    final filteredProblems = _filterEmergencyReportsByType('أخرى');
    return _buildEmergencyContentTemplate(
      title: 'بلاغات طوارئ أخرى',
      icon: Icons.report_problem,
      color: Color(0xFF9C27B0),
      reports: filteredProblems,
      isLoading: _isLoadingEmergency,
    );
  }
  
  Widget _buildEmergencySection() {
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
            controller: _emergencyTabController,
            isScrollable: true,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.red],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.orange,
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
              Tab(text: 'تسرب مياه خطير'),
              Tab(text: 'أنابيب مكسورة'),
              Tab(text: 'مياه جارية بغزارة'),
              Tab(text: 'خطر غرق'),
              Tab(text: 'أخرى'),
            ],
          ),
        ),
        Expanded(
          child: SmartRefresher(
            controller: _emergencyRefreshController,
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropHeader(
              waterDropColor: Colors.red,
              complete: Icon(Icons.done, color: Colors.red),
              refresh: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
            onRefresh: _onEmergencyRefresh,
            child: TabBarView(
              controller: _emergencyTabController,
              children: [
                _buildEmergencyType1Content(),
                _buildEmergencyType2Content(),
                _buildEmergencyType3Content(),
                _buildEmergencyType4Content(),
                _buildEmergencyOtherContent(),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Future<void> _onWaterRefresh() async {
    await _loadWaterReports();
    _waterRefreshController.refreshCompleted();
  }
  
  Future<void> _onEmployeeRefresh() async {
    await _loadEmployeeReports();
    _employeeRefreshController.refreshCompleted();
  }
  
  Future<void> _onAppRefresh() async {
    await _loadAppReports();
    _appRefreshController.refreshCompleted();
  }
  
  Future<void> _onReportsRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    _reportsRefreshController.refreshCompleted();
  }
  
  void _showMultiDatePicker() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
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
                        setStateDialog(() {
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
                              setStateDialog(() {
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
    } else if (_selectedReportTypeSystem == 'أسبوعي' && _selectedWeek == null) {
      _showErrorSnackbar('يرجى اختيار الأسبوع أولاً');
      return;
    } else if (_selectedReportTypeSystem == 'شهري' && _selectedMonth == null) {
      _showErrorSnackbar('يرجى اختيار الشهر أولاً');
      return;
    }
    
    switch (_selectedReportTypeSystem) {
      case 'يومي':
        _generateDailyReport();
        break;
      case 'أسبوعي':
        _generateWeeklyReport();
        break;
      case 'شهري':
        _generateMonthlyReport();
        break;
    }
  }
  
  Widget _buildReportsView(BuildContext context) {
    return SmartRefresher(
      controller: _reportsRefreshController,
      enablePullDown: true,
      enablePullUp: false,
      header: WaterDropHeader(
        waterDropColor: _primaryColor,
        complete: Icon(Icons.done, color: _primaryColor),
        refresh: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
        ),
      ),
      onRefresh: _onReportsRefresh,
      child: SingleChildScrollView(
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
                              color: Colors.grey[600],
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
                            color: _darkColor,
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
            color: _darkColor,
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
                color: isSelected ? Colors.white : _darkColor,
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
            color: _darkColor,
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
                  color: _darkColor,
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
            color: _darkColor,
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
                color: isSelected ? Colors.white : _darkColor,
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
            color: _darkColor,
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
                color: isSelected ? Colors.white : _darkColor,
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
          onTap: isFormValid && !_isLoadingReports ? _generateReport : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: _isLoadingReports
                ? Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : Row(
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
            color: isLogout ? Colors.red : _darkColor,
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
            Text('تسجيل الخروج'
            ),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EsigninScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('تسجيل الخروج',
            style: TextStyle(color: Colors.white),
            ),
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
  
  @override
  void dispose() {
    _mainTabController.dispose();
    _waterTabController.dispose();
    _employeeTabController.dispose();
    _appTabController.dispose();
    _emergencyTabController.dispose();
    _waterSubTabController.dispose();
    _employeeSubTabController.dispose();
    _appSubTabController.dispose();
    _emergencySubTabController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    _waterRefreshController.dispose();
    _employeeRefreshController.dispose();
    _appRefreshController.dispose();
    _emergencyRefreshController.dispose();
    _reportsRefreshController.dispose();
    super.dispose();
  }
  
Future<int> _getUnreadNotificationsCount() async {
  try {
    final supabase = Supabase.instance.client;
    
    final String defaultUserId = '16fa69df-76f5-461f-9901-dcee7b7ac83c';
    
    final response = await supabase
        .schema('water')
        .from('notifications')
        .select()
        .eq('user_id', defaultUserId)
        .eq('is_read', false);
        
    return response.length;
  } catch (e) {
    print('❌ خطأ في جلب عدد الإشعارات: $e');
    return 0;
  }
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
                fontSize: 15,
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
          // أيقونة الإشعارات مع عدد الإشعارات غير المقروءة
          FutureBuilder(
            key: ValueKey(_notificationsVersion),
            future: _getUnreadNotificationsCount(),
            builder: (context, snapshot) {
              int unreadCount = 0;
              
              if (snapshot.hasData) {
                unreadCount = snapshot.data as int;
              }
              
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: Icon(
                      unreadCount > 0 ? Icons.notifications_active : Icons.notifications_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsScreen(),
                        ),
                      );
                      setState(() {
                        _notificationsVersion++;
                      });
                    },
                    tooltip: 'الإشعارات',
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
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
              labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontSize: 11),
              labelPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
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
                  icon: Icon(Icons.electrical_services, size: 20),
                  text: 'الطوارئ',
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
  
  // ==================== دوال بناء الأقسام الرئيسية ====================

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
              Tab(text: 'انقطاع الماء'),
              Tab(text: 'مشكلة في العداد'),
              Tab(text: 'جودة المياه'),
              Tab(text: 'تسرب بسيط'),
              Tab(text: 'أخرى'),
            ],
          ),
        ),
        Expanded(
          child: RefreshConfiguration(
            headerBuilder: () => MaterialClassicHeader(
              color: _primaryColor,
              backgroundColor: Colors.white,
            ),
            footerBuilder: () => ClassicFooter(),
            child: SmartRefresher(
              controller: _waterRefreshController,
              enablePullDown: true,
              enablePullUp: false,
              header: WaterDropHeader(
                waterDropColor: _primaryColor,
                complete: Icon(Icons.done, color: _primaryColor),
                refresh: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                ),
              ),
              onRefresh: _onWaterRefresh,
              child: TabBarView(
                controller: _waterTabController,
                children: [
                  _buildWaterOutageContent(),
                  _buildWaterMeterContent(),
                  _buildWaterQualityContent(),
                  _buildWaterLeakContent(),
                  _buildWaterOtherContent(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildWaterMeterContent() {
    final filteredProblems = _filterWaterReportsByCategory('مشكلة في العداد');
    return _buildWaterContentTemplate(
      title: 'بلاغات مشاكل العداد',
      icon: Icons.speed,
      color: _warningColor,
      reports: filteredProblems,
      isLoading: _isLoadingWater,
    );
  }
  
  Widget _buildWaterLeakContent() {
    final filteredProblems = _filterWaterReportsByCategory('تسرب بسيط');
    return _buildWaterContentTemplate(
      title: 'بلاغات التسرب البسيط',
      icon: Icons.water_drop,
      color: _infoColor,
      reports: filteredProblems,
      isLoading: _isLoadingWater,
    );
  }
  
  Widget _buildWaterOutageContent() {
    final filteredProblems = _filterWaterReportsByCategory('انقطاع الماء');
    return _buildWaterContentTemplate(
      title: 'بلاغات انقطاع المياه',
      icon: Icons.water_damage,
      color: _dangerColor,
      reports: filteredProblems,
      isLoading: _isLoadingWater,
    );
  }
  
  Widget _buildWaterQualityContent() {
    final filteredProblems = _filterWaterReportsByCategory('جودة المياه');
    return _buildWaterContentTemplate(
      title: 'بلاغات جودة المياه',
      icon: Icons.water_drop,
      color: _infoColor,
      reports: filteredProblems,
      isLoading: _isLoadingWater,
    );
  }
  
  Widget _buildWaterOtherContent() {
    final filteredProblems = _filterWaterReportsByCategory('أخرى');
    return _buildWaterContentTemplate(
      title: 'بلاغات أخرى للمياه',
      icon: Icons.warning,
      color: _darkColor,
      reports: filteredProblems,
      isLoading: _isLoadingWater,
    );
  }
  
  Widget _buildWaterContentTemplate({
    required String title,
    required IconData icon,
    required Color color,
    required List<Map<String, dynamic>> reports,
    required bool isLoading,
  }) {
    final filteredByReadStatus = _filterReportsByReadStatus(reports, 'water');
    
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
                          '${reports.where((p) => !(p['is_read'] ?? false)).length}',
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
                              '${reports.where((p) => !(p['is_read'] ?? false)).length}',
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
                              '${reports.where((p) => p['is_read'] ?? false).length}',
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
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: color))
              : filteredByReadStatus.isEmpty
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
                      itemCount: filteredByReadStatus.length,
                      itemBuilder: (context, index) {
                        final report = filteredByReadStatus[index];
                        final isRead = report['is_read'] ?? false;
                        final status = report['status'];
                        final statusColor = _getStatusColor(status);
                        
                        return Card(
                          margin: EdgeInsets.only(bottom: 12),
                          elevation: isRead ? 1 : 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isRead ? Colors.grey[300]! : color.withOpacity(0.5),
                              width: isRead ? 1 : 2,
                            ),
                          ),
                          child: InkWell(
                            onTap: () => _showProblemDetails(report),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
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
                                        ),
                                        child: Icon(icon, color: color, size: 22),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              report['citizen_name'] ?? 'غير معروف',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                                color: isRead ? Colors.grey[700] : color,
                                              ),
                                            ),
                                            Text(
                                              report['citizen_phone'] ?? 'غير معروف',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          _getStatusText(status),
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
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      _getSubTypeText(report),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: color,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    report['description'] ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isRead ? Colors.grey[600] : Colors.grey[800],
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
                                      SizedBox(width: 4),
                                      Text(
                                        report['created_at'] != null
                                            ? DateFormat('yyyy-MM-dd HH:mm').format(
                                                DateTime.parse(report['created_at']),
                                              )
                                            : '',
                                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                                      ),
                                      if (report['location'] != null &&
                                          report['location'].toString().isNotEmpty) ...[
                                        SizedBox(width: 12),
                                        Icon(Icons.location_on, size: 12, color: Colors.grey[500]),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            report['location'],
                                            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (!isRead)
                                        InkWell(
                                          onTap: () => _markReportAsRead(report['id'], report['report_type']),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.mark_email_read, size: 14, color: Colors.green),
                                                SizedBox(width: 4),
                                                Text(
                                                  'تمييز كمقروء',
                                                  style: TextStyle(fontSize: 10, color: Colors.green),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      SizedBox(width: 8),
                                      InkWell(
                                        onTap: () => _shareReport(report),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: color.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.share, size: 14, color: color),
                                              SizedBox(width: 4),
                                              Text(
                                                'مشاركة',
                                                style: TextStyle(fontSize: 10, color: color),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      InkWell(
  onTap: () => _transferReportToTechnician(report),
  child: Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: _primaryColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.engineering, size: 14, color: _primaryColor),
        SizedBox(width: 4),
        Text(
          'تحويل للصيانة',
          style: TextStyle(fontSize: 10, color: _primaryColor),
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
                        );
                      },
                    ),
        ),
      ],
    );
  }
  
  // ==================== دوال قسم الموظفين ====================

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
              Tab(text: 'موظف استقبال البلاغات'),
              Tab(text: 'أخرى'),
            ],
          ),
        ),
        Expanded(
          child: SmartRefresher(
            controller: _employeeRefreshController,
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropHeader(
              waterDropColor: _primaryColor,
              complete: Icon(Icons.done, color: _primaryColor),
              refresh: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
              ),
            ),
            onRefresh: _onEmployeeRefresh,
            child: TabBarView(
              controller: _employeeTabController,
              children: [
                _buildEmployeeMaintenanceContent(),
                _buildEmployeeBillingContent(),
                _buildEmployeeReceptionContent(),
                _buildEmployeeOtherContent(),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildEmployeeMaintenanceContent() {
    final filteredProblems = _filterEmployeeReportsByType('موظف الصيانة');
    final filteredByReadStatus = _filterReportsByReadStatus(filteredProblems, 'employee');
    return _buildEmployeeContentTemplate(
      title: 'بلاغات تقصير موظفي الصيانة',
      icon: Icons.engineering,
      color: _dangerColor,
      reports: filteredByReadStatus,
      isLoading: _isLoadingEmployee,
      tabType: 'employee',
    );
  }
  
  Widget _buildEmployeeBillingContent() {
    final filteredProblems = _filterEmployeeReportsByType('موظف الفواتير');
    final filteredByReadStatus = _filterReportsByReadStatus(filteredProblems, 'employee');
    return _buildEmployeeContentTemplate(
      title: 'بلاغات تقصير موظفي الفواتير',
      icon: Icons.receipt_long,
      color: _warningColor,
      reports: filteredByReadStatus,
      isLoading: _isLoadingEmployee,
      tabType: 'employee',
    );
  }
  
  Widget _buildEmployeeReceptionContent() {
    final filteredProblems = _filterEmployeeReportsByType('موظف استقبال البلاغات');
    final filteredByReadStatus = _filterReportsByReadStatus(filteredProblems, 'employee');
    return _buildEmployeeContentTemplate(
      title: 'بلاغات تقصير موظفي استقبال البلاغات',
      icon: Icons.support_agent,
      color: _accentColor,
      reports: filteredByReadStatus,
      isLoading: _isLoadingEmployee,
      tabType: 'employee',
    );
  }
  
  Widget _buildEmployeeOtherContent() {
    final filteredProblems = _filterEmployeeReportsByType('آخر');
    final filteredByReadStatus = _filterReportsByReadStatus(filteredProblems, 'employee');
    return _buildEmployeeContentTemplate(
      title: 'بلاغات أخرى عن الموظفين',
      icon: Icons.person,
      color: _infoColor,
      reports: filteredByReadStatus,
      isLoading: _isLoadingEmployee,
      tabType: 'employee',
    );
  }
  
  Widget _buildEmployeeContentTemplate({
    required String title,
    required IconData icon,
    required Color color,
    required List<Map<String, dynamic>> reports,
    required bool isLoading,
    required String tabType,
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
                          '${reports.where((p) => !(p['is_read'] ?? false)).length}',
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
                  controller: _employeeSubTabController,
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
                              '${reports.where((p) => !(p['is_read'] ?? false)).length}',
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
                              '${reports.where((p) => p['is_read'] ?? false).length}',
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
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: color))
              : reports.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            _subTabStatus[tabType] == 'غير مقروءة'
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
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final report = reports[index];
                        final isRead = report['is_read'] ?? false;
                        final status = report['status'];
                        final statusColor = _getStatusColor(status);
                        return Card(
                          margin: EdgeInsets.only(bottom: 12),
                          elevation: isRead ? 1 : 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isRead ? Colors.grey[300]! : color.withOpacity(0.5),
                              width: isRead ? 1 : 2,
                            ),
                          ),
                          child: InkWell(
                            onTap: () => _showProblemDetails(report),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
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
                                        ),
                                        child: Icon(icon, color: color, size: 22),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              report['citizen_name'] ?? 'غير معروف',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                                color: isRead ? Colors.grey[700] : color,
                                              ),
                                            ),
                                            Text(
                                              report['citizen_phone'] ?? 'غير معروف',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          _getStatusText(status),
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
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      report['employee_type'] ?? _getSubTypeText(report),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: color,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  if (report['employee_name'] != null)
                                    Text(
                                      'الموظف: ${report['employee_name']}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: isRead ? Colors.grey[600] : Colors.grey[800],
                                      ),
                                    ),
                                  SizedBox(height: 4),
                                  Text(
                                    report['description'] ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isRead ? Colors.grey[600] : Colors.grey[800],
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (!isRead)
                                        InkWell(
                                          onTap: () => _markReportAsRead(report['id'], report['report_type']),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.mark_email_read, size: 14, color: Colors.green),
                                                SizedBox(width: 4),
                                                Text(
                                                  'تمييز كمقروء',
                                                  style: TextStyle(fontSize: 10, color: Colors.green),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      SizedBox(width: 8),
                                      InkWell(
                                        onTap: () => _shareReport(report),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: color.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.share, size: 14, color: color),
                                              SizedBox(width: 4),
                                              Text(
                                                'مشاركة',
                                                style: TextStyle(fontSize: 10, color: color),
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
                        );
                      },
                    ),
        ),
      ],
    );
  }
  
  // ==================== دوال قسم التطبيق ====================

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
          child: SmartRefresher(
            controller: _appRefreshController,
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropHeader(
              waterDropColor: _primaryColor,
              complete: Icon(Icons.done, color: _primaryColor),
              refresh: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
              ),
            ),
            onRefresh: _onAppRefresh,
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
        ),
      ],
    );
  }
  
  Widget _buildAppCrashContent() {
    final filteredProblems = _filterAppReportsByType('تعطل في التطبيق');
    final filteredByReadStatus = _filterReportsByReadStatus(filteredProblems, 'app');
    return _buildAppContentTemplate(
      title: 'بلاغات تعطل التطبيق',
      icon: Icons.error_outline,
      color: _dangerColor,
      reports: filteredByReadStatus,
      isLoading: _isLoadingApp,
      tabType: 'app',
    );
  }
  
  Widget _buildAppPaymentContent() {
    final filteredProblems = _filterAppReportsByType('مشكلة في الدفع');
    final filteredByReadStatus = _filterReportsByReadStatus(filteredProblems, 'app');
    return _buildAppContentTemplate(
      title: 'بلاغات مشاكل الدفع',
      icon: Icons.payment,
      color: _warningColor,
      reports: filteredByReadStatus,
      isLoading: _isLoadingApp,
      tabType: 'app',
    );
  }
  
  Widget _buildAppUIUXContent() {
    final filteredProblems = _filterAppReportsByType('واجهة المستخدم');
    final filteredByReadStatus = _filterReportsByReadStatus(filteredProblems, 'app');
    return _buildAppContentTemplate(
      title: 'بلاغات واجهة المستخدم',
      icon: Icons.phone_iphone,
      color: _infoColor,
      reports: filteredByReadStatus,
      isLoading: _isLoadingApp,
      tabType: 'app',
    );
  }
  
  Widget _buildAppOtherContent() {
    final filteredProblems = _filterAppReportsByType('أخرى');
    final filteredByReadStatus = _filterReportsByReadStatus(filteredProblems, 'app');
    return _buildAppContentTemplate(
      title: 'بلاغات أخرى عن التطبيق',
      icon: Icons.apps,
      color: _darkColor,
      reports: filteredByReadStatus,
      isLoading: _isLoadingApp,
      tabType: 'app',
    );
  }
  Widget _buildAppContentTemplate({
  required String title,
  required IconData icon,
  required Color color,
  required List<Map<String, dynamic>> reports,
  required bool isLoading,
  required String tabType,
}) {
  // التأكد من وجود قيمة افتراضية للتبويب
  if (!_subTabStatus.containsKey(tabType)) {
    _subTabStatus[tabType] = 'غير مقروءة';
  }
  
  final currentSubTab = _subTabStatus[tabType] ?? 'غير مقروءة';
  
  // حساب الأعداد
  final unreadCount = reports.where((r) => (r['is_read'] ?? false) == false).length;
  final readCount = reports.where((r) => (r['is_read'] ?? false) == true).length;
  
  // تصفية البلاغات حسب التبويب الحالي
  final filteredReports = reports.where((report) {
    final isRead = report['is_read'] ?? false;
    if (currentSubTab == 'غير مقروءة') {
      return !isRead;
    } else {
      return isRead;
    }
  }).toList();
  
  // طباعة للتأكد من البيانات (للتجربة)
  print('🔍 تبويب: $tabType, الحالة: $currentSubTab, إجمالي: ${reports.length}, غير مقروء: $unreadCount, مقروء: $readCount, بعد التصفية: ${filteredReports.length}');
  
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
                        '$unreadCount',
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
            // تبويبات غير مقروءة / مقروءة
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  // تبويب غير مقروءة
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _subTabStatus[tabType] = 'غير مقروءة';
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: currentSubTab == 'غير مقروءة' ? color : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'غير مقروءة',
                              style: TextStyle(
                                color: currentSubTab == 'غير مقروءة' ? Colors.white : Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: currentSubTab == 'غير مقروءة' 
                                    ? Colors.white.withOpacity(0.3) 
                                    : color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$unreadCount',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: currentSubTab == 'غير مقروءة' ? Colors.white : color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // تبويب مقروءة
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _subTabStatus[tabType] = 'مقروءة';
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: currentSubTab == 'مقروءة' ? color : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'مقروءة',
                              style: TextStyle(
                                color: currentSubTab == 'مقروءة' ? Colors.white : Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: currentSubTab == 'مقروءة' 
                                    ? Colors.white.withOpacity(0.3) 
                                    : color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$readCount',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: currentSubTab == 'مقروءة' ? Colors.white : color,
                                ),
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
            SizedBox(height: 8),
          ],
        ),
      ),
      Expanded(
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: color))
            : filteredReports.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                        SizedBox(height: 16),
                        Text(
                          currentSubTab == 'غير مقروءة'
                              ? 'لا توجد بلاغات غير مقروءة'
                              : 'لا توجد بلاغات مقروءة',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          currentSubTab == 'غير مقروءة'
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
                    itemCount: filteredReports.length,
                    itemBuilder: (context, index) {
                      final report = filteredReports[index];
                      final isRead = report['is_read'] ?? false;
                      final status = report['status'];
                      final statusColor = _getStatusColor(status);
                      
                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        elevation: isRead ? 1 : 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isRead ? Colors.grey[300]! : color.withOpacity(0.5),
                            width: isRead ? 1 : 2,
                          ),
                        ),
                        child: InkWell(
                          onTap: () => _showProblemDetails(report),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
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
                                      ),
                                      child: Icon(icon, color: color, size: 22),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            report['citizen_name'] ?? 'غير معروف',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                              color: isRead ? Colors.grey[700] : color,
                                            ),
                                          ),
                                          Text(
                                            report['citizen_phone'] ?? 'غير معروف',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        _getStatusText(status),
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
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    _getSubTypeText(report),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: color,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  report['description'] ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isRead ? Colors.grey[600] : Colors.grey[800],
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (!isRead)
                                      InkWell(
                                        onTap: () => _markReportAsRead(report['id'], report['report_type']),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.mark_email_read, size: 14, color: Colors.green),
                                              SizedBox(width: 4),
                                              Text(
                                                'تمييز كمقروء',
                                                style: TextStyle(fontSize: 10, color: Colors.green),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    SizedBox(width: 8),
                                    InkWell(
                                      onTap: () => _shareReport(report),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.share, size: 14, color: color),
                                            SizedBox(width: 4),
                                            Text(
                                              'مشاركة',
                                              style: TextStyle(fontSize: 10, color: color),
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
                      );
                    },
                  ),
        ),
    ],
  );
}
}

class NotificationsScreen extends StatefulWidget {
  static const String routeName = '/notifications';

  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  final Color _primaryColor = Color(0xFF0072B5);
  final Color _successColor = Color(0xFF2E7D32);
  final Color _errorColor = Color(0xFFD32F2F);
  final Color _warningColor = Color(0xFFF57C00);
  final Color _infoColor = Color(0xFF1976D2);
  final Color _textColor = Color(0xFF212121);
  final Color _textSecondaryColor = Color(0xFF757575);
  final Color _backgroundColor = Color(0xFFF5F5F5);
  final Color _cardColor = Colors.white;
  final Color _borderColor = Color(0xFFE0E0E0);

  int _selectedTab = 0;
  final List<String> _tabs = ['الجميع', 'غير مقروءة', 'مقروءة'];
  
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }
  
  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }
      final response = await _supabase
          .schema('water')
          .from('notifications')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);  
      if (mounted) {
        setState(() {
          _notifications = List<Map<String, dynamic>>.from(response);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ خطأ في تحميل الإشعارات: $e');
      setState(() => _isLoading = false);
    }
  }
  
  int get _unreadCount {
    return _notifications.where((n) => !(n['is_read'] ?? false)).length;
  }
  
  List<Map<String, dynamic>> get _filteredNotifications {
    switch (_selectedTab) {
      case 0: return _notifications;
      case 1: return _notifications.where((n) => !(n['is_read'] ?? false)).toList();
      case 2: return _notifications.where((n) => n['is_read'] ?? false).toList();
      default: return _notifications;
    }
  }
  
  Future<void> _markAsRead(String id) async {
    try {
      await _supabase
          .schema('water')
          .from('notifications')
          .update({'is_read': true})
          .eq('id', id); 
      setState(() {
        final index = _notifications.indexWhere((n) => n['id'] == id);
        if (index != -1) {
          _notifications[index]['is_read'] = true;
        }
      });
    } catch (e) {
      print('❌ خطأ في تمييز الإشعار كمقروء: $e');
    }
  }
  
  Future<void> _markAllAsRead() async {
    try {
      final unreadIds = _notifications
          .where((n) => !(n['is_read'] ?? false))
          .map((n) => n['id'])
          .toList(); 
      for (var id in unreadIds) {
        await _supabase
            .schema('water')
            .from('notifications')
            .update({'is_read': true})
            .eq('id', id);
      }
      setState(() {
        for (var notification in _notifications) {
          notification['is_read'] = true;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تمييز جميع الإشعارات كمقروءة'),
          backgroundColor: _successColor,
        ),
      );
    } catch (e) {
      print('❌ خطأ في تمييز الكل كمقروء: $e');
    }
  }
  
  Future<void> _deleteNotification(String id) async {
    try {
      await _supabase
          .schema('water')
          .from('notifications')
          .delete()
          .eq('id', id);
      setState(() {
        _notifications.removeWhere((n) => n['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم حذف الإشعار'),
          backgroundColor: _successColor,
        ),
      );
    } catch (e) {
      print('❌ خطأ في حذف الإشعار: $e');
    }
  }
  
  Color _getNotificationColor(String type, String priority) {
    if (priority == 'high') return _errorColor;
    switch (type) {
      case 'emergency':
        return _errorColor;
      case 'service_problem':
        return _primaryColor;
      case 'employee_fault':
        return _warningColor;
      case 'app_problem':
        return _infoColor;
      default:
        return _primaryColor;
    }
  }
  
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'emergency':
        return Icons.warning_amber;
      case 'service_problem':
        return Icons.water_damage;
      case 'employee_fault':
        return Icons.engineering;
      case 'app_problem':
        return Icons.bug_report;
      default:
        return Icons.notifications;
    }
  }
  
  String _formatTime(String? dateTimeString) {
    if (dateTimeString == null) return '';
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      if (difference.inDays > 0) {
        return 'منذ ${difference.inDays} يوم';
      } else if (difference.inHours > 0) {
        return 'منذ ${difference.inHours} ساعة';
      } else if (difference.inMinutes > 0) {
        return 'منذ ${difference.inMinutes} دقيقة';
      } else {
        return 'الآن';
      }
    } catch (e) {
      return '';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.notifications_active, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text('الإشعارات', style: TextStyle(color: Colors.white)),
            if (_unreadCount > 0)
              Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _unreadCount.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_unreadCount > 0)
            IconButton(
              icon: Icon(Icons.done_all, color: Colors.white),
              onPressed: _markAllAsRead,
              tooltip: 'تمييز الكل كمقروء',
            ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            color: _cardColor,
            child: Row(
              children: _tabs.asMap().entries.map((entry) {
                int index = entry.key;
                String tab = entry.value;
                bool isSelected = _selectedTab == index;
                int count = 0;
                
                if (index == 0) count = _notifications.length;
                else if (index == 1) count = _notifications.where((n) => !(n['is_read'] ?? false)).length;
                else count = _notifications.where((n) => n['is_read'] ?? false).length;
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected ? _primaryColor : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          count > 0 ? '$tab ($count)' : tab,
                          style: TextStyle(
                            color: isSelected ? _primaryColor : _textSecondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: _primaryColor))
                : _filteredNotifications.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
                            SizedBox(height: 16),
                            Text('لا توجد إشعارات', style: TextStyle(color: Colors.grey[600])),
                            SizedBox(height: 8),
                            Text(
                              'ستظهر الإشعارات هنا عند استلام بلاغات جديدة',
                              style: TextStyle(color: Colors.grey[500], fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(12),
                        itemCount: _filteredNotifications.length,
                        itemBuilder: (context, index) {
                          final notification = _filteredNotifications[index];
                          final isRead = notification['is_read'] ?? false;
                          final type = notification['type'] ?? 'general';
                          final priority = notification['priority'] ?? 'normal';
                          final color = _getNotificationColor(type, priority);
                          final icon = _getNotificationIcon(type);
                          
                          return Dismissible(
                            key: Key(notification['id']),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: _errorColor,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(Icons.delete, color: Colors.white, size: 28),
                            ),
                            onDismissed: (direction) => _deleteNotification(notification['id']),
                            child: Card(
                              margin: EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: isRead ? _borderColor : color.withOpacity(0.5),
                                  width: isRead ? 1 : 2,
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (!isRead) _markAsRead(notification['id']);
                                  _showNotificationDetails(notification);
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(icon, color: color, size: 28),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              notification['title'] ?? 'إشعار جديد',
                                              style: TextStyle(
                                                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                                fontSize: 14,
                                                color: isRead ? _textSecondaryColor : _textColor,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              notification['message'] ?? '',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: _textSecondaryColor,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              _formatTime(notification['created_at']),
                                              style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!isRead)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: _errorColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
  
  void _showNotificationDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _primaryColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(
            children: [
              Icon(_getNotificationIcon(notification['type'] ?? 'general'), color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  notification['title'] ?? 'تفاصيل الإشعار',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
              notification['message'] ?? '',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'التاريخ: ${_formatTime(notification['created_at'])}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  if (notification['category'] != null)
                    Text(
                      'التصنيف: ${notification['category']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
