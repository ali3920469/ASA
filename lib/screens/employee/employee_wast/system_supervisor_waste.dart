import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';
import 'package:mang_mu/screens/employee/Shared Services/esignin_screen.dart';
import 'dart:async';

class SystemSupervisorWasteScreen extends StatefulWidget {
  const SystemSupervisorWasteScreen({super.key});

  @override
  State<SystemSupervisorWasteScreen> createState() => _SystemSupervisorWasteScreenState();
}

class _SystemSupervisorWasteScreenState extends State<SystemSupervisorWasteScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late RefreshController _refreshController;
  
  // ========== الألوان ==========
  final Color _primaryColor = const Color(0xFF117E75);
  final Color _secondaryColor = const Color(0xFFD4AF37);
  final Color _accentColor = const Color(0xFF8D6E63);
  final Color _successColor = const Color(0xFF2E7D32);
  final Color _warningColor = const Color(0xFFF57C00);
  final Color _errorColor = const Color(0xFFD32F2F);
  final Color _darkPrimaryColor = const Color(0xFF0A5F4F);

  // ========== متغيرات الفواتير ==========
  int _currentBillsTab = 0;
  String _billFilter = 'الكل';
  final List<String> _filters = ['الكل', 'مدفوعة', 'غير مدفوعة', 'متأخرة'];
  
  final List<Map<String, dynamic>> bills = [
    {
      'id': 'WST-INV-001',
      'citizenName': 'أحمد محمد',
      'amount': 25000,
      'dueDate': DateTime.now().add(Duration(days: 5)),
      'status': 'unpaid',
      'wasteType': 'نفايات منزلية',
      'billingDate': DateTime.now().subtract(Duration(days: 5)),
      'paymentMethod': 'تحويل بنكي',
      'cardNumber': '1234-****-****-5678',
      'transferTo': 'حساب الرافدين - أمانة بغداد',
      'bankAccount': '123456789012',
      'isPaying': true,
    },
    {
      'id': 'WST-INV-002',
      'citizenName': 'فاطمة علي',
      'amount': 35000,
      'dueDate': DateTime.now().subtract(Duration(days: 3)),
      'status': 'overdue',
      'wasteType': 'نفايات تجارية',
      'billingDate': DateTime.now().subtract(Duration(days: 10)),
      'paymentMethod': 'بطاقة ائتمان',
      'cardNumber': '4321-****-****-9876',
      'transferTo': 'حساب أمانة بغداد المركزي',
      'bankAccount': 'IQ100100100100100100',
      'isPaying': false,
    },
    {
      'id': 'WST-INV-003',
      'citizenName': 'خالد إبراهيم',
      'amount': 18000,
      'dueDate': DateTime.now().add(Duration(days: 2)),
      'status': 'unpaid',
      'wasteType': 'نفايات بناء',
      'billingDate': DateTime.now().subtract(Duration(days: 7)),
      'paymentMethod': 'زين كاش',
      'phoneNumber': '0780-123-4567',
      'transferTo': 'حساب زين كاش - أمانة بغداد',
      'bankAccount': '9647901234567',
      'isPaying': true,
    },
    {
      'id': 'WST-INV-004',
      'citizenName': 'سارة أحمد',
      'amount': 22000,
      'dueDate': DateTime.now().subtract(Duration(days: 1)),
      'status': 'paid',
      'wasteType': 'نفايات منزلية',
      'billingDate': DateTime.now().subtract(Duration(days: 30)),
      'paymentMethod': 'تحويل بنكي',
      'cardNumber': '9876-****-****-4321',
      'transferTo': 'حساب الرشيد - أمانة بغداد',
      'bankAccount': '987654321098',
      'isPaying': true,
    },
  ];

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'bank_transfer',
      'name': 'التحويل البنكي',
      'icon': Icons.account_balance_rounded,
      'color': Colors.blue,
      'totalAmount': 47000,
      'totalTransfers': 2,
      'bankAccounts': [
        {
          'bankName': 'الرافدين',
          'accountNumber': '123456789012',
          'accountName': 'أمانة بغداد - فواتير النفايات'
        },
        {
          'bankName': 'الرشيد',
          'accountNumber': '987654321098',
          'accountName': 'أمانة بغداد - خدمات النظافة'
        }
      ]
    },
    {
      'id': 'credit_card',
      'name': 'بطاقة ائتمان',
      'icon': Icons.credit_card_rounded,
      'color': Colors.green,
      'totalAmount': 35000,
      'totalTransfers': 1,
      'bankAccounts': [
        {
          'bankName': 'البنك المركزي العراقي',
          'accountNumber': 'IQ100100100100100100',
          'accountName': 'أمانة بغداد - الإيرادات'
        }
      ]
    },
    {
      'id': 'zain_cash',
      'name': 'زين كاش',
      'icon': Icons.phone_iphone_rounded,
      'color': Colors.purple,
      'totalAmount': 18000,
      'totalTransfers': 1,
      'bankAccounts': [
        {
          'bankName': 'زين كاش',
          'accountNumber': '9647901234567',
          'accountName': 'أمانة بغداد'
        }
      ]
    },
  ];

  final List<Map<String, dynamic>> citizens = [
    {
      'name': 'أحمد محمد',
      'totalBills': 1,
      'totalAmount': 25000,
      'lastPayment': '2024-03-15',
      'isPaying': true,
    },
    {
      'name': 'فاطمة علي',
      'totalBills': 1,
      'totalAmount': 35000,
      'lastPayment': '2024-02-20',
      'isPaying': false,
    },
    {
      'name': 'خالد إبراهيم',
      'totalBills': 1,
      'totalAmount': 18000,
      'lastPayment': '2024-02-10',
      'isPaying': true,
    },
    {
      'name': 'سارة أحمد',
      'totalBills': 1,
      'totalAmount': 22000,
      'lastPayment': '2024-03-18',
      'isPaying': true,
    },
  ];

  // ========== متغيرات طلبات التقارير للفواتير ==========
  int _selectedBillsReportTab = 0;
  String _billsReportFilter = 'الكل';
  
  final List<Map<String, dynamic>> _billsReportRequests = [
    {
      'id': 'BILL-REQ-001',
      'type': 'يومي',
      'title': 'طلب تقرير فواتير يومي',
      'requestedBy': 'مسؤول المحطة',
      'date': '2024-03-20',
      'status': 'معلق',
      'priority': 'عادي',
      'dueDate': '2024-03-21',
      'description': 'تقرير مفصل عن الفواتير اليومية والإيرادات',
    },
    {
      'id': 'BILL-REQ-002',
      'type': 'أسبوعي',
      'title': 'طلب تقرير الفواتير الأسبوعي',
      'requestedBy': 'مدير التشغيل',
      'date': '2024-03-19',
      'status': 'قيد التنفيذ',
      'priority': 'عالي',
      'dueDate': '2024-03-22',
      'description': 'تقرير عن الفواتير المتأخرة والمدفوعات خلال الأسبوع',
    },
  ];

  final List<Map<String, dynamic>> _billsReceivedReports = [
    {
      'id': 'BILL-REP-001',
      'title': 'تقرير الفواتير اليومي - 20 مارس',
      'type': 'يومي',
      'sender': 'أحمد السعدون - محاسب',
      'date': '2024-03-20',
      'time': '10:30 ص',
      'status': 'جديد',
      'read': false,
      'priority': 'عالي',
      'size': '1.8 MB',
      'format': 'PDF',
      'summary': 'تقرير مفصل عن الفواتير اليومية والإيرادات المحصلة',
      'attachments': 2,
      'totalAmount': 125000,
      'totalBills': 45,
    },
    {
      'id': 'BILL-REP-002',
      'title': 'تحليل الفواتير الأسبوعي',
      'type': 'أسبوعي',
      'sender': 'سارة العبيدي - مدققة حسابات',
      'date': '2024-03-19',
      'time': '02:15 م',
      'status': 'مكتمل',
      'read': true,
      'priority': 'متوسط',
      'size': '2.5 MB',
      'format': 'PDF',
      'summary': 'تحليل شامل للفواتير والمدفوعات خلال الأسبوع',
      'attachments': 3,
      'totalAmount': 450000,
      'totalBills': 120,
    },
  ];

  // ========== بيانات عمال النظافة ==========
  int _currentWorkersTab = 0; // 0: العمال, 1: طلبات التقارير, 2: التقارير الواردة
  String _workersReportFilter = 'الكل';
  int _selectedWorkersReportTab = 0;
  
  List<Cleaner> _cleaners = [
    Cleaner(
      id: 1,
      name: 'علي محمود',
      phone: '0771234567',
      isSelected: false,
      status: 'متاح',
      idNumber: '876543210',
      sector: 'قطاع الكرخ',
      experienceYears: 3,
      monthlySalary: '1,200,000 دينار',
      lastAttendance: DateTime.now().subtract(Duration(days: 1)),
    ),
    Cleaner(
      id: 2,
      name: 'حسن كاظم',
      phone: '0777654321',
      isSelected: false,
      status: 'متاح',
      idNumber: '987654321',
      sector: 'قطاع الرصافة',
      experienceYears: 5,
      monthlySalary: '1,500,000 دينار',
      lastAttendance: DateTime.now(),
    ),
    Cleaner(
      id: 3,
      name: 'مهدي عبدالله',
      phone: '0779876543',
      isSelected: false,
      status: 'في المهمة',
      idNumber: '123456789',
      sector: 'قطاع الكاظمية',
      experienceYears: 2,
      monthlySalary: '1,000,000 دينار',
      lastAttendance: DateTime.now().subtract(Duration(days: 2)),
    ),
    Cleaner(
      id: 4,
      name: 'حسين علي',
      phone: '0774567890',
      isSelected: false,
      status: 'متاح',
      idNumber: '555666777',
      sector: 'قطاع المنصور',
      experienceYears: 4,
      monthlySalary: '1,300,000 دينار',
      lastAttendance: DateTime.now(),
    ),
    Cleaner(
      id: 5,
      name: 'قاسم أحمد',
      phone: '0776789012',
      isSelected: false,
      status: 'إجازة',
      idNumber: '333222111',
      sector: 'قطاع الكرخ',
      experienceYears: 6,
      monthlySalary: '1,800,000 دينار',
      lastAttendance: DateTime.now().subtract(Duration(days: 5)),
    ),
    Cleaner(
      id: 6,
      name: 'جواد حسن',
      phone: '0773456789',
      isSelected: false,
      status: 'متاح',
      idNumber: '444555666',
      sector: 'قطاع الرصافة',
      experienceYears: 1,
      monthlySalary: '900,000 دينار',
      lastAttendance: DateTime.now(),
    ),
  ];

  final List<Map<String, dynamic>> _workersReportRequests = [
    {
      'id': 'WRK-REQ-001',
      'type': 'يومي',
      'title': 'طلب تقرير أداء العمال اليومي',
      'requestedBy': 'مسؤول النفايات',
      'date': '2024-03-20',
      'status': 'معلق',
      'priority': 'عادي',
      'dueDate': '2024-03-21',
      'description': 'تقرير مفصل عن أداء عمال النظافة اليومي',
    },
    {
      'id': 'WRK-REQ-002',
      'type': 'أسبوعي',
      'title': 'طلب تقرير الحضور والانصراف',
      'requestedBy': 'مدير التشغيل',
      'date': '2024-03-19',
      'status': 'قيد التنفيذ',
      'priority': 'عالي',
      'dueDate': '2024-03-22',
      'description': 'تقرير عن حضور وانصراف العمال للأسبوع الحالي',
    },
    {
      'id': 'WRK-REQ-003',
      'type': 'شهري',
      'title': 'طلب تحليل أداء الفرق',
      'requestedBy': 'المدير العام',
      'date': '2024-03-15',
      'status': 'مكتمل',
      'priority': 'عالي',
      'dueDate': '2024-03-25',
      'description': 'تحليل شامل لأداء فرق النظافة ومعدل الإنجاز الشهري',
    },
  ];

  final List<Map<String, dynamic>> _workersReceivedReports = [
    {
      'id': 'WRK-REP-001',
      'title': 'تقرير أداء العمال اليومي - 20 مارس',
      'type': 'يومي',
      'sender': 'حسن عبدالله - مشرف العمال',
      'date': '2024-03-20',
      'time': '05:30 م',
      'status': 'جديد',
      'read': false,
      'priority': 'متوسط',
      'size': '1.8 MB',
      'format': 'PDF',
      'summary': 'تقرير مفصل عن أداء عمال النظافة اليومي مع إحصائيات الإنجاز',
      'attachments': 4,
      'totalWorkers': 45,
      'presentWorkers': 42,
      'absentWorkers': 3,
    },
    {
      'id': 'WRK-REP-002',
      'title': 'تحليل الحضور والغياب الأسبوعي',
      'type': 'أسبوعي',
      'sender': 'علي محمد - مشرف الموارد',
      'date': '2024-03-19',
      'time': '03:45 م',
      'status': 'مكتمل',
      'read': true,
      'priority': 'عالي',
      'size': '2.5 MB',
      'format': 'PDF',
      'summary': 'تحليل شامل للحضور والغياب مع أسباب التغيب',
      'attachments': 3,
      'totalWorkers': 45,
      'presentWorkers': 40,
      'absentWorkers': 5,
    },
    {
      'id': 'WRK-REP-003',
      'title': 'تقرير أداء الفرق الشهري - فبراير 2024',
      'type': 'شهري',
      'sender': 'محمد كريم - مدير العمليات',
      'date': '2024-03-05',
      'time': '10:00 ص',
      'status': 'مكتمل',
      'read': true,
      'priority': 'عالي',
      'size': '3.2 MB',
      'format': 'PDF',
      'summary': 'تقرير كامل عن أداء فرق النظافة ومعدلات الإنجاز الشهرية',
      'attachments': 6,
      'totalWorkers': 45,
      'presentWorkers': 38,
      'absentWorkers': 7,
    },
    {
      'id': 'WRK-REP-004',
      'title': 'تقرير إنتاجية العمال',
      'type': 'خاص',
      'sender': 'خالد أحمد - محلل أداء',
      'date': '2024-03-18',
      'time': '01:30 م',
      'status': 'جديد',
      'read': false,
      'priority': 'عالي',
      'size': '4.1 MB',
      'format': 'PDF',
      'summary': 'تقرير مفصل عن إنتاجية العمال مع توصيات للتحسين',
      'attachments': 8,
      'totalWorkers': 45,
      'presentWorkers': 41,
      'absentWorkers': 4,
    },
  ];

  // ========== بيانات البلاغات ==========
  int _currentReportsTab = 0;
  String _selectedReportType = 'الكل';
  
  final List<Map<String, dynamic>> _reports = [
    {
      'id': 'RPT-001',
      'title': 'تراكم النفايات في الكرخ',
      'description': 'تراكم كبير للنفايات في منطقة الكرخ بالقرب من سوق الشورجة',
      'citizenName': 'أحمد كاظم',
      'phone': '07801234567',
      'location': 'بغداد - الكرخ - شارع حيفا',
      'date': '2024-03-20',
      'time': '08:30 ص',
      'status': 'جديد',
      'priority': 'عاجل',
      'type': 'تراكم نفايات',
      'images': 2,
      'assignedTo': '',
      'responseTime': '',
    },
    {
      'id': 'RPT-002',
      'title': 'تكدس نفايات في الرصافة',
      'description': 'تكدس النفايات بالقرب من مستشفى ابن الخطيب',
      'citizenName': 'سالم محمد',
      'phone': '07807654321',
      'location': 'بغداد - الرصافة - منطقة البتاوين',
      'date': '2024-03-20',
      'time': '10:15 ص',
      'status': 'قيد المعالجة',
      'priority': 'عالي',
      'type': 'تكدس نفايات',
      'images': 1,
      'assignedTo': 'فريق النظافة',
      'responseTime': '30 دقيقة',
    },
    {
      'id': 'RPT-003',
      'title': 'نفايات البناء في المنصور',
      'description': 'تجميع مخلفات البناء في الشوارع الرئيسية بمنطقة المنصور',
      'citizenName': 'فاطمة عبدالله',
      'phone': '07809876543',
      'location': 'بغداد - المنصور - شارع 14 رمضان',
      'date': '2024-03-19',
      'time': '04:45 م',
      'status': 'تمت المعالجة',
      'priority': 'متوسط',
      'type': 'نفايات بناء',
      'images': 3,
      'assignedTo': 'فريق النظافة',
      'responseTime': 'ساعتان',
      'completedDate': '2024-03-20',
    },
    {
      'id': 'RPT-004',
      'title': 'روائح كريهة من النفايات',
      'description': 'روائح كريهة من حاويات النفايات في منطقة اليرموك',
      'citizenName': 'سارة عبدالله',
      'phone': '07809988776',
      'location': 'اليرموك - مجمع 605',
      'date': '2024-03-20',
      'time': '01:30 م',
      'status': 'جديد',
      'priority': 'عاجل',
      'type': 'روائح',
      'images': 0,
      'assignedTo': '',
      'responseTime': '',
    },
    {
      'id': 'RPT-005',
      'title': 'حاوية نفايات مكسورة',
      'description': 'حاوية نفايات مكسورة في منطقة الشعلة تسبب تبعثر النفايات',
      'citizenName': 'محمد حسين',
      'phone': '07812349876',
      'location': 'الشعلة - قرب مدرسة النور',
      'date': '2024-03-19',
      'time': '11:20 م',
      'status': 'قيد المعالجة',
      'priority': 'عاجل',
      'type': 'صيانة حاويات',
      'images': 4,
      'assignedTo': 'فريق الصيانة',
      'responseTime': '15 دقيقة',
    },
  ];

  // ========== بيانات جدول النفايات ==========
  int _currentScheduleTab = 0;
  
  List<DaySchedule> _weeklySchedule = [];
  List<Truck> _availableTrucks = [
    Truck(
      id: 1,
      name: 'الشاحنة الرسمية ١',
      type: 'نفايات عامة',
      capacity: '١٥ طن',
      plateNumber: 'بغداد ١٢٣٤',
      sector: 'قطاع الكرخ',
      districts: ['شارع حيفا', 'سوق الشورجة', 'المنطقة التجارية'],
      status: 'جاهزة للعمل',
      isSelected: false,
      lastMaintenance: DateTime.now().subtract(Duration(days: 15)),
      nextMaintenance: DateTime.now().add(Duration(days: 45)),
      driver: 'أحمد كاظم',
    ),
    Truck(
      id: 2,
      name: 'الشاحنة الرسمية ٢',
      type: 'نفايات بناء',
      capacity: '٢٠ طن',
      plateNumber: 'بغداد ٥٦٧٨',
      sector: 'قطاع الرصافة',
      districts: ['البتاوين', 'الوزيرية', 'الاعظمية'],
      status: 'تحت الصيانة',
      isSelected: false,
      lastMaintenance: DateTime.now().subtract(Duration(days: 60)),
      nextMaintenance: DateTime.now().add(Duration(days: 30)),
      driver: 'سالم محمد',
    ),
    Truck(
      id: 3,
      name: 'الشاحنة الرسمية ٣',
      type: 'نفايات طبية',
      capacity: '١٠ طن',
      plateNumber: 'بغداد ٩٠١٢',
      sector: 'قطاع الكاظمية',
      districts: ['الشعب', 'النهضة', 'حي العلماء'],
      status: 'مشغولة حالياً',
      isSelected: false,
      lastMaintenance: DateTime.now().subtract(Duration(days: 30)),
      nextMaintenance: DateTime.now().add(Duration(days: 60)),
      driver: 'علي محمود',
    ),
    Truck(
      id: 4,
      name: 'الشاحنة الرسمية ٤',
      type: 'نفايات عامة',
      capacity: '١٢ طن',
      plateNumber: 'بغداد ٣٤٥٦',
      sector: 'قطاع المنصور',
      districts: ['شارع ١٤ رمضان', 'حي العدل', 'حي الأطباء'],
      status: 'جاهزة للعمل',
      isSelected: false,
      lastMaintenance: DateTime.now().subtract(Duration(days: 20)),
      nextMaintenance: DateTime.now().add(Duration(days: 70)),
      driver: 'حسن كاظم',
    ),
  ];

  DateTime _selectedDate = DateTime.now();
  String _selectedMonth = 'مارس 2024';
  String _selectedYear = '2024';
  List<String> _availableYears = ['2024', '2023', '2022', '2021', '2020'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _refreshController = RefreshController();
    _initializeSchedule();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _initializeSchedule() {
    final now = DateTime.now();
    final currentWeekStart = now.subtract(Duration(days: now.weekday % 7));
    
    _weeklySchedule = List.generate(7, (index) {
      final day = currentWeekStart.add(Duration(days: index));
      final isFriday = day.weekday == DateTime.friday;
      
      return DaySchedule(
        date: day,
        dayName: _getArabicDayName(day.weekday),
        startTime: isFriday ? 'لا يوجد جمع' : '٨:٠٠ ص',
        endTime: isFriday ? '' : '٦:٠٠ م',
        truck: isFriday ? null : _availableTrucks[index % _availableTrucks.length],
        isDayOff: isFriday,
        assignedCleaners: isFriday ? [] : _getRandomCleanersForDay(index),
      );
    });
  }

  List<Cleaner> _getRandomCleanersForDay(int dayIndex) {
    final shuffled = List<Cleaner>.from(_cleaners)..shuffle();
    return shuffled.take(2 + (dayIndex % 2)).toList();
  }
  // ========== دوال التحديث عند السحب ==========
  Future<void> _refreshBillsTab() async {
    await Future.delayed(Duration(seconds: 1));
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  Future<void> _refreshWorkersTab() async {
    await Future.delayed(Duration(seconds: 1));
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  Future<void> _refreshReportsTab() async {
    await Future.delayed(Duration(seconds: 1));
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  Future<void> _refreshScheduleTab() async {
    await Future.delayed(Duration(seconds: 1));
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  // ========== دوال مساعدة ==========
  String _formatCurrency(dynamic amount) {
    double numericAmount = 0.0;
    if (amount is int) {
      numericAmount = amount.toDouble();
    } else if (amount is double) {
      numericAmount = amount;
    } else if (amount is String) {
      numericAmount = double.tryParse(amount) ?? 0.0;
    }
    return '${NumberFormat('#,##0').format(numericAmount)} د.ع';
  }

  String _formatNumber(num number) {
    if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
    return number.toStringAsFixed(0);
  }

  Color _textColor() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.isDarkMode ? Colors.white : const Color(0xFF212121);
  }

  Color _textSecondaryColor() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF757575);
  }

  Color _cardColor() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  }

  Color _borderColor() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.isDarkMode ? const Color(0xFF333333) : const Color(0xFFE0E0E0);
  }

  Color _backgroundColor() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF0F8FF);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
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
              child: Icon(Icons.delete_outline_rounded, color: _primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'مسؤول النفايات',
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
                const Icon(Icons.notifications_outlined, color: Colors.white, size: 26),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.zero,
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
              // التنقل إلى شاشة الإشعارات
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: isDarkMode ? _darkPrimaryColor : _primaryColor,
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 3, color: _secondaryColor),
                ),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(icon: Icon(Icons.receipt_long_rounded, size: 22), text: 'الفواتير'),
                Tab(icon: Icon(Icons.people_rounded, size: 22), text: 'العمال'),
                Tab(icon: Icon(Icons.report_problem_rounded, size: 22), text: 'البلاغات'),
                Tab(icon: Icon(Icons.calendar_today_rounded, size: 22), text: 'الجدول '),
              ],
            ),
          ),
        ),
      ),
      drawer: _buildDrawer(isDarkMode),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBillsTab(isDarkMode),
          _buildWorkersTab(isDarkMode),
          _buildReportsTab(isDarkMode),
          _buildScheduleTab(isDarkMode),
        ],
      ),
    );
  }

  // ========== تبويب الفواتير ==========
  Widget _buildBillsTab(bool isDarkMode) {
    return RefreshIndicator(
      onRefresh: _refreshBillsTab,
      color: _primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // التبويبات الداخلية للفواتير
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDarkMode ? const Color(0xFF333333) : const Color(0xFFE0E0E0)),
              ),
              child: Row(
                children: [
                  _buildInnerTabButton('الفواتير', 0, isDarkMode),
                  _buildInnerTabButton('طرق الدفع', 1, isDarkMode),
                  _buildInnerTabButton('المواطنين', 2, isDarkMode),
                  _buildInnerTabButton('التقارير', 3, isDarkMode),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_currentBillsTab == 0) _buildBillsContent(isDarkMode),
            if (_currentBillsTab == 1) _buildPaymentMethodsContent(isDarkMode),
            if (_currentBillsTab == 2) _buildCitizensContent(isDarkMode),
            if (_currentBillsTab == 3) _buildBillsReportsContent(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildInnerTabButton(String title, int index, bool isDarkMode) {
    bool isSelected = _currentBillsTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentBillsTab = index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? _primaryColor.withOpacity(0.1) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? _primaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? _primaryColor : _textColor(),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBillsContent(isDarkMode) {
    List<Map<String, dynamic>> filteredBills = _getFilteredBills();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBillsStats(),
        const SizedBox(height: 20),
        _buildBillsFilter(),
        const SizedBox(height: 20),
        Text(
          'الفواتير الحالية',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryColor),
        ),
        const SizedBox(height: 12),
        ...filteredBills.map((bill) => _buildBillCard(bill, isDarkMode)).toList(),
      ],
    );
  }

  Widget _buildBillsStats() {
    int paidBills = bills.where((bill) => bill['status'] == 'paid').length;
    int unpaidBills = bills.where((bill) => bill['status'] == 'unpaid').length;
    int overdueBills = bills.where((bill) => bill['status'] == 'overdue').length;
    double totalRevenue = bills.fold(0.0, (sum, bill) => sum + (bill['amount'] ?? 0));
    
    return Container(
      decoration: BoxDecoration(
        color: _cardColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor()),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('إجمالي الفواتير', bills.length.toString(), Icons.receipt_rounded, _primaryColor),
                _buildStatCard('إجمالي الإيرادات', _formatCurrency(totalRevenue), Icons.attach_money_rounded, _successColor),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('مدفوعة', paidBills.toString(), Icons.done_all_rounded, _successColor),
                _buildStatCard('غير مدفوعة', unpaidBills.toString(), Icons.pending_actions_rounded, _warningColor),
                _buildStatCard('متأخرة', overdueBills.toString(), Icons.warning_rounded, _errorColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillsFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          bool isSelected = _billFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) => setState(() => _billFilter = filter),
              selectedColor: _primaryColor.withOpacity(0.2),
              checkmarkColor: _primaryColor,
              labelStyle: TextStyle(color: isSelected ? _primaryColor : _textColor(), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : _borderColor()),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBillCard(Map<String, dynamic> bill, bool isDarkMode) {
    Color statusColor = _getBillStatusColor(bill['status']);
    String statusText = _getBillStatusText(bill['status']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _cardColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('فاتورة #${bill['id']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor())),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: statusColor.withOpacity(0.3))),
                      child: Text(statusText, style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(bill['citizenName'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textColor())),
                const SizedBox(height: 4),
                Text('${_formatCurrency(bill['amount'])} - ${bill['wasteType']}', style: TextStyle(fontSize: 12, color: _textSecondaryColor())),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: _backgroundColor(), borderRadius: BorderRadius.circular(8), border: Border.all(color: _borderColor())),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Icon(Icons.payment_rounded, size: 16, color: _primaryColor), const SizedBox(width: 8), Text('طريقة الدفع:', style: TextStyle(fontSize: 12, color: _textSecondaryColor())), const SizedBox(width: 4), Text(bill['paymentMethod'] ?? 'غير محدد', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _textColor()))]),
                      if (bill['cardNumber'] != null) ...[const SizedBox(height: 8), Row(children: [Icon(Icons.credit_card_rounded, size: 14, color: _primaryColor), const SizedBox(width: 8), Text('رقم البطاقة: ${bill['cardNumber']}', style: TextStyle(fontSize: 11, color: _textSecondaryColor()))])],
                      if (bill['phoneNumber'] != null) ...[const SizedBox(height: 8), Row(children: [Icon(Icons.phone_rounded, size: 14, color: _primaryColor), const SizedBox(width: 8), Text('رقم الهاتف: ${bill['phoneNumber']}', style: TextStyle(fontSize: 11, color: _textSecondaryColor()))])],
                      const SizedBox(height: 8),
                      Row(children: [Icon(Icons.account_balance_rounded, size: 14, color: _primaryColor), const SizedBox(width: 8), Text('محول إلى: ${bill['transferTo']}', style: TextStyle(fontSize: 11, color: _textSecondaryColor()))]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsContent(isDarkMode) {
    double totalAmount = paymentMethods.fold(0.0, (sum, method) => sum + (method['totalAmount'] ?? 0));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: _cardColor(),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor()),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('إجمالي المبالغ', _formatCurrency(totalAmount), Icons.attach_money_rounded, _primaryColor),
                _buildStatCard('طرق الدفع', paymentMethods.length.toString(), Icons.payment_rounded, _secondaryColor),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('طرق الدفع المتاحة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryColor)),
        const SizedBox(height: 12),
        ...paymentMethods.map((method) => _buildPaymentMethodCard(method, isDarkMode)).toList(),
      ],
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _cardColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor()),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(width: 50, height: 50, decoration: BoxDecoration(color: method['color'].withOpacity(0.1), borderRadius: BorderRadius.circular(25)), child: Icon(method['icon'], color: method['color'], size: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(method['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor())),
                  const SizedBox(height: 4),
                  Text('${method['totalTransfers']} تحويل - ${_formatCurrency(method['totalAmount'])}', style: TextStyle(fontSize: 12, color: _textSecondaryColor())),
                ],
              ),
            ),
            IconButton(icon: Icon(Icons.info_outline_rounded, color: _primaryColor), onPressed: () => _showPaymentMethodDetails(method)),
          ],
        ),
      ),
    );
  }

  Widget _buildCitizensContent(isDarkMode) {
    double totalAmount = citizens.fold(0.0, (sum, citizen) => sum + (citizen['totalAmount'] as int).toDouble());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: _cardColor(),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor()),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('إجمالي المواطنين', citizens.length.toString(), Icons.people_rounded, _primaryColor),
                _buildStatCard('إجمالي المبالغ', _formatCurrency(totalAmount), Icons.attach_money_rounded, _successColor),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('سجل المواطنين', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryColor)),
        const SizedBox(height: 12),
        ...citizens.map((citizen) => _buildCitizenCard(citizen, isDarkMode)).toList(),
      ],
    );
  }

  Widget _buildCitizenCard(Map<String, dynamic> citizen, bool isDarkMode) {
    bool isPaying = citizen['isPaying'] == true;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _cardColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor()),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(width: 50, height: 50, decoration: BoxDecoration(color: isPaying ? _successColor.withOpacity(0.1) : _warningColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(isPaying ? Icons.person : Icons.person_outline, color: isPaying ? _successColor : _warningColor, size: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(citizen['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor())),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: isPaying ? _successColor.withOpacity(0.1) : _warningColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: isPaying ? _successColor.withOpacity(0.3) : _warningColor.withOpacity(0.3))),
                        child: Text(isPaying ? 'مدفع' : 'غير مدفع', style: TextStyle(fontSize: 12, color: isPaying ? _successColor : _warningColor, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${citizen['totalBills']} فواتير - ${_formatCurrency(citizen['totalAmount'])}', style: TextStyle(fontSize: 12, color: _textSecondaryColor())),
                  const SizedBox(height: 4),
                  Text('آخر دفع: ${citizen['lastPayment']}', style: TextStyle(fontSize: 11, color: _textSecondaryColor())),
                ],
              ),
            ),
            IconButton(icon: Icon(Icons.arrow_left_rounded, color: _primaryColor), onPressed: () => _showCitizenDetails(citizen)),
          ],
        ),
      ),
    );
  }

  Widget _buildBillsReportsContent(isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // تبويبات التقارير (طلبات التقارير والتقارير الواردة)
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDarkMode ? const Color(0xFF333333) : const Color(0xFFE0E0E0)),
          ),
          child: Row(
            children: [
              _buildBillsReportTabButton('طلبات التقارير', 0),
              _buildBillsReportTabButton('التقارير الواردة', 1),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _selectedBillsReportTab == 0
            ? _buildBillsReportRequestsSection(isDarkMode)
            : _buildBillsReceivedReportsSection(isDarkMode),
      ],
    );
  }

  Widget _buildBillsReportTabButton(String title, int index) {
    bool isSelected = _selectedBillsReportTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedBillsReportTab = index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? _primaryColor.withOpacity(0.1) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? _primaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? _primaryColor : _textColor(),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBillsReportRequestsSection(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor()),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.send_rounded, color: _primaryColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'طلب تقارير من المحاسب',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor()),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // رسالة توضيحية
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _primaryColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_rounded, color: _primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'سيتم إرسال طلب التقرير إلى المحاسب لإنشائه',
                      style: TextStyle(color: _textColor(), fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // أزرار طلب التقارير
            Row(
              children: [
                Expanded(
                  child: _buildBillsReportRequestButton(
                    'طلب تقرير يومي',
                    Icons.today_rounded,
                    _primaryColor,
                    'يومي',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildBillsReportRequestButton(
                    'طلب تقرير أسبوعي',
                    Icons.date_range_rounded,
                    _accentColor,
                    'أسبوعي',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildBillsReportRequestButton(
                    'طلب تقرير شهري',
                    Icons.calendar_month_rounded,
                    _secondaryColor,
                    'شهري',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // قائمة طلبات التقارير
            Text(
              'طلباتي الأخيرة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textColor()),
            ),
            const SizedBox(height: 12),
            if (_billsReportRequests.isEmpty)
              _buildBillsEmptyRequests()
            else
              Column(
                children: _billsReportRequests.map((request) => _buildBillsRequestItem(request, isDarkMode)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillsReportRequestButton(String title, IconData icon, Color color, String reportType) {
    return ElevatedButton(
      onPressed: () => _showBillsReportRequestConfirmation(reportType),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBillsRequestItem(Map<String, dynamic> request, bool isDarkMode) {
    Color statusColor = _getRequestStatusColor(request['status']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor()),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getRequestIcon(request['status']),
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request['title'],
                  style: TextStyle(fontWeight: FontWeight.w600, color: _textColor()),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 12, color: _textSecondaryColor()),
                    const SizedBox(width: 4),
                    Text(
                      request['date'],
                      style: TextStyle(fontSize: 11, color: _textSecondaryColor()),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        request['status'],
                        style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.visibility_rounded, color: _primaryColor, size: 20),
            onPressed: () => _showRequestDetails(request),
          ),
        ],
      ),
    );
  }

  Widget _buildBillsReceivedReportsSection(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor()),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.inbox_rounded, color: _successColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'التقارير الواردة من المحاسب',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: _textColor()),
                ),
                const Spacer(),
                Badge(
                  label: Text('${_billsReceivedReports.where((r) => !r['read']).length}'),
                  backgroundColor: _primaryColor,
                  child: Icon(Icons.notifications_rounded, color: _primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // فلترة التقارير
            _buildBillsReportFilter(),
            const SizedBox(height: 20),
            // قائمة التقارير الواردة
            if (_billsReceivedReports.isEmpty)
              _buildBillsEmptyReports(isDarkMode)
            else
              Column(
                children: _getFilteredBillsReports().map((report) => _buildBillsReceivedReportItem(report, isDarkMode)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillsReportFilter() {
    List<String> filters = ['الكل', 'يومي', 'أسبوعي', 'شهري', 'خاص'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          bool isSelected = _billsReportFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _billsReportFilter = filter;
                });
              },
              selectedColor: _primaryColor.withOpacity(0.2),
              checkmarkColor: _primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? _primaryColor : _textColor(),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : _borderColor()),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBillsReceivedReportItem(Map<String, dynamic> report, bool isDarkMode) {
    Color statusColor = _getReportStatusColor(report['status']);
    Color priorityColor = _getPriorityColor(report['priority']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صف العنوان والحالة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (!report['read'])
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: _primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        report['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _textColor(),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  report['status'],
                  style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // معلومات التقرير
          Row(
            children: [
              // المرسل
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_rounded, size: 14, color: _textSecondaryColor()),
                        const SizedBox(width: 4),
                        Text(
                          'المرسل:',
                          style: TextStyle(fontSize: 12, color: _textSecondaryColor()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      report['sender'],
                      style: TextStyle(
                        fontSize: 13,
                        color: _textColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // التاريخ والوقت
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 14, color: _textSecondaryColor()),
                        const SizedBox(width: 4),
                        Text(
                          'التاريخ:',
                          style: TextStyle(fontSize: 12, color: _textSecondaryColor()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${report['date']} ${report['time']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: _textColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // نوع التقرير والأولوية
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.description_rounded, size: 12, color: _primaryColor),
                    const SizedBox(width: 4),
                    Text(
                      report['type'],
                      style: TextStyle(fontSize: 11, color: _primaryColor),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: priorityColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.priority_high_rounded, size: 12, color: priorityColor),
                    const SizedBox(width: 4),
                    Text(
                      report['priority'],
                      style: TextStyle(fontSize: 11, color: priorityColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // حجم الملف
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _backgroundColor(),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _borderColor()),
                ),
                child: Text(
                  report['size'],
                  style: TextStyle(fontSize: 11, color: _textSecondaryColor()),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // ملخص التقرير
          Text(
            report['summary'],
            style: TextStyle(
              fontSize: 13,
              color: _textSecondaryColor(),
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 12),
          
          // معلومات إضافية للفواتير
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.receipt_rounded, size: 12, color: _successColor),
                    const SizedBox(width: 4),
                    Text(
                      '${report['totalBills']} فاتورة',
                      style: TextStyle(fontSize: 11, color: _successColor),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.attach_money_rounded, size: 12, color: _accentColor),
                    const SizedBox(width: 4),
                    Text(
                      _formatCurrency(report['totalAmount']),
                      style: TextStyle(fontSize: 11, color: _accentColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // أزرار الإجراءات
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _viewReportDetails(report);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primaryColor,
                    side: BorderSide(color: _primaryColor),
                  ),
                  icon: const Icon(Icons.remove_red_eye_rounded, size: 16),
                  label: const Text('عرض التقرير', style: TextStyle(fontSize:11)),
                ),
              ),
              
              const SizedBox(width: 8),
              
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _downloadReport(report);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.download_rounded, size: 16),
                  label: const Text('تحميل', style: TextStyle(fontSize:11)),
                ),
              ),
              
              const SizedBox(width: 8),
              
              IconButton(
                onPressed: () {
                  _showReportOptions(report);
                },
                icon: Icon(Icons.more_vert_rounded, color: _primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillsEmptyRequests() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor().withOpacity(0.5), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(Icons.send_rounded, size: 48, color: _textSecondaryColor()),
          const SizedBox(height: 12),
          Text(
            'لا توجد طلبات تقارير',
            style: TextStyle(fontSize: 16, color: _textSecondaryColor(), fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'يمكنك إرسال طلب تقرير باستخدام الأزرار أعلاه',
            textAlign: TextAlign.center,
            style: TextStyle(color: _textSecondaryColor()),
          ),
        ],
      ),
    );
  }

  Widget _buildBillsEmptyReports(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor()),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_rounded, size: 48, color: _textSecondaryColor()),
          const SizedBox(height: 12),
          Text(
            'لا توجد تقارير واردة',
            style: TextStyle(fontSize: 16, color: _textSecondaryColor(), fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'سيظهر هنا التقارير المرسلة من المحاسب',
            textAlign: TextAlign.center,
            style: TextStyle(color: _textSecondaryColor()),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 20)),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        Text(title, style: TextStyle(fontSize: 10, color: _textSecondaryColor())),
      ],
    );
  }

  // ========== دوال مساعدة للفواتير ==========
  List<Map<String, dynamic>> _getFilteredBills() {
    switch (_billFilter) {
      case 'مدفوعة': return bills.where((bill) => bill['status'] == 'paid').toList();
      case 'غير مدفوعة': return bills.where((bill) => bill['status'] == 'unpaid').toList();
      case 'متأخرة': return bills.where((bill) => bill['status'] == 'overdue').toList();
      default: return bills;
    }
  }

  Color _getBillStatusColor(String status) {
    switch (status) {
      case 'paid': return _successColor;
      case 'unpaid': return _warningColor;
      case 'overdue': return _errorColor;
      default: return _textSecondaryColor();
    }
  }

  String _getBillStatusText(String status) {
    switch (status) {
      case 'paid': return 'مدفوعة';
      case 'unpaid': return 'غير مدفوعة';
      case 'overdue': return 'متأخرة';
      default: return 'غير معروف';
    }
  }

  Color _getRequestStatusColor(String status) {
    switch (status) {
      case 'معلق': return _warningColor;
      case 'قيد التنفيذ': return _accentColor;
      case 'مكتمل': return _successColor;
      default: return _textSecondaryColor();
    }
  }

  IconData _getRequestIcon(String status) {
    switch (status) {
      case 'معلق': return Icons.pending_rounded;
      case 'قيد التنفيذ': return Icons.hourglass_bottom_rounded;
      case 'مكتمل': return Icons.check_circle_rounded;
      default: return Icons.receipt_long_rounded;
    }
  }

  Color _getReportStatusColor(String status) {
    switch (status) {
      case 'جديد': return _primaryColor;
      case 'مكتمل': return _successColor;
      case 'قيد المراجعة': return _warningColor;
      case 'مرفوض': return _errorColor;
      default: return _textSecondaryColor();
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'عالي': case 'عاجل': return _errorColor;
      case 'متوسط': return _warningColor;
      case 'عادي': return _successColor;
      default: return _textSecondaryColor();
    }
  }

  List<Map<String, dynamic>> _getFilteredBillsReports() {
    if (_billsReportFilter == 'الكل') return _billsReceivedReports;
    return _billsReceivedReports.where((report) => report['type'] == _billsReportFilter).toList();
  }

  void _showRequestDetails(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(),
        title: Row(
          children: [
            Icon(Icons.request_page_rounded, color: _primaryColor),
            const SizedBox(width: 8),
            Text('تفاصيل طلب التقرير', style: TextStyle(color: _textColor())),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                request['title'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor()),
              ),
              const SizedBox(height: 16),
              _buildSimpleDetailRow('رقم الطلب:', request['id']),
              _buildSimpleDetailRow('نوع التقرير:', request['type']),
              _buildSimpleDetailRow('حالة الطلب:', request['status']),
              _buildSimpleDetailRow('تاريخ الطلب:', request['date']),
              _buildSimpleDetailRow('تاريخ التسليم:', request['dueDate']),
              _buildSimpleDetailRow('الأولوية:', request['priority']),
              _buildSimpleDetailRow('الوصف:', request['description']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodDetails(Map<String, dynamic> method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(),
        title: const Text('تفاصيل طريقة الدفع'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSimpleDetailRow('اسم الطريقة:', method['name']),
              _buildSimpleDetailRow('إجمالي المبالغ:', _formatCurrency(method['totalAmount'])),
              _buildSimpleDetailRow('عدد التحويلات:', method['totalTransfers'].toString()),
              const SizedBox(height: 16),
              const Text('الحسابات البنكية:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...method['bankAccounts'].map<Widget>((account) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _backgroundColor(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(account['bankName'], style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('اسم الحساب: ${account['accountName']}'),
                    Text('رقم الحساب: ${account['accountNumber']}'),
                  ],
                ),
              )).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showCitizenDetails(Map<String, dynamic> citizen) {
    List<Map<String, dynamic>> citizenBills = bills.where((bill) => bill['citizenName'] == citizen['name']).toList();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(),
        title: const Text('تفاصيل المواطن'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSimpleDetailRow('الاسم:', citizen['name']),
              _buildSimpleDetailRow('الحالة:', citizen['isPaying'] ? 'مدفع' : 'غير مدفع'),
              _buildSimpleDetailRow('عدد الفواتير:', citizen['totalBills'].toString()),
              _buildSimpleDetailRow('إجمالي المبالغ:', _formatCurrency(citizen['totalAmount'])),
              _buildSimpleDetailRow('آخر دفع:', citizen['lastPayment']),
              if (citizenBills.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('فواتير المواطن:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...citizenBills.map<Widget>((bill) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _cardColor(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(bill['id'], style: const TextStyle(fontWeight: FontWeight.w600)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getBillStatusColor(bill['status']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _getBillStatusText(bill['status']),
                              style: TextStyle(
                                fontSize: 10,
                                color: _getBillStatusColor(bill['status']),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('المبلغ: ${_formatCurrency(bill['amount'])}'),
                      Text('نوع النفايات: ${bill['wasteType']}'),
                      Text('طريقة الدفع: ${bill['paymentMethod']}'),
                    ],
                  ),
                )).toList(),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showBillsReportRequestConfirmation(String reportType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.send_rounded, color: _primaryColor, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              'تأكيد إرسال الطلب',
              style: TextStyle(color: _textColor(), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'هل تريد إرسال طلب لتقرير $reportType إلى المحاسب؟',
              style: TextStyle(color: _textColor(), fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _backgroundColor(),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderColor()),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description_rounded, size: 16, color: _primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'تفاصيل الطلب:',
                        style: TextStyle(fontWeight: FontWeight.bold, color: _textColor()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildSimpleDetailRow('نوع التقرير', 'تقرير $reportType'),
                  _buildSimpleDetailRow('المستلم', 'المحاسب'),
                  _buildSimpleDetailRow('حالة الطلب', 'سيكون معلق'),
                  _buildSimpleDetailRow('وقت الاستجابة المتوقع', '24-48 ساعة'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor())),
          ),
          ElevatedButton(
            onPressed: () {
              _sendBillsReportRequest(reportType);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.send_rounded, size: 18),
                const SizedBox(width: 8),
                const Text('إرسال الطلب'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendBillsReportRequest(String reportType) {
    setState(() {
      _billsReportRequests.insert(0, {
        'id': 'BILL-REQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(8, 12)}',
        'type': reportType,
        'title': 'طلب تقرير فواتير $reportType',
        'requestedBy': 'مسؤول المحطة',
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'status': 'معلق',
        'priority': 'عادي',
        'dueDate': DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1))),
        'description': 'تقرير مفصل عن الفواتير $reportType',
      });
    });
    
    _showSuccessMessage('تم إرسال طلب التقرير $reportType بنجاح');
  }

  void _viewReportDetails(Map<String, dynamic> report) {
    setState(() {
      report['read'] = true;
    });
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _cardColor(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                    Icon(Icons.receipt_long_rounded, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        report['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSimpleDetailRow('المرسل', report['sender']),
                      _buildSimpleDetailRow('نوع التقرير', report['type']),
                      _buildSimpleDetailRow('التاريخ', '${report['date']} ${report['time']}'),
                      _buildSimpleDetailRow('الأولوية', report['priority']),
                      _buildSimpleDetailRow('حجم الملف', report['size']),
                      _buildSimpleDetailRow('الصيغة', report['format']),
                      
                      const SizedBox(height: 16),
                      Divider(color: _borderColor()),
                      const SizedBox(height: 16),
                      
                      // ملخص التقرير
                      Text(
                        'ملخص التقرير',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        report['summary'],
                        style: TextStyle(
                          color: _textColor(),
                          height: 1.6,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // معلومات الفواتير
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _backgroundColor(),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _borderColor()),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '${report['totalBills']}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _primaryColor,
                                    ),
                                  ),
                                  Text(
                                    'عدد الفواتير',
                                    style: TextStyle(fontSize: 12, color: _textSecondaryColor()),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: _borderColor(),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    _formatCurrency(report['totalAmount']),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _successColor,
                                    ),
                                  ),
                                  Text(
                                    'الإجمالي',
                                    style: TextStyle(fontSize: 12, color: _textSecondaryColor()),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // المرفقات
                      if (report['attachments'] > 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'المرفقات',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: _primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'عدد المرفقات: ${report['attachments']}',
                              style: TextStyle(color: _textSecondaryColor()),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              
              // أزرار الإجراءات
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: _borderColor())),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إغلاق'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _downloadReport(report);
                        },
                        icon: const Icon(Icons.download_rounded),
                        label: const Text('تحميل التقرير'),
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

  void _downloadReport(Map<String, dynamic> report) {
    _showSuccessMessage('جاري تحميل التقرير: ${report['title']}');
  }

  void _showReportOptions(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardColor(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.share_rounded, color: _primaryColor),
              title: const Text('مشاركة التقرير'),
              onTap: () {
                Navigator.pop(context);
                _shareReport(report);
              },
            ),
            ListTile(
              leading: Icon(Icons.archive_rounded, color: _primaryColor),
              title: const Text('أرشفة التقرير'),
              onTap: () {
                Navigator.pop(context);
                _archiveReport(report);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_rounded, color: _errorColor),
              title: const Text('حذف التقرير', style: TextStyle(color: Color(0xFFD32F2F))),
              onTap: () {
                Navigator.pop(context);
                _deleteReport(report);
              },
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
          ],
        ),
      ),
    );
  }

  void _shareReport(Map<String, dynamic> report) {
    _showSuccessMessage('تم إعداد التقرير للمشاركة: ${report['title']}');
  }

  void _archiveReport(Map<String, dynamic> report) {
    setState(() {
      if (report.containsKey('read')) {
        if (_billsReceivedReports.contains(report)) {
          _billsReceivedReports.remove(report);
        }
      }
    });
    _showSuccessMessage('تم أرشفة التقرير');
  }

  void _deleteReport(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(),
        title: Row(
          children: [
            Icon(Icons.delete_rounded, color: _errorColor),
            const SizedBox(width: 8),
            const Text('حذف التقرير'),
          ],
        ),
        content: Text('هل أنت متأكد من حذف التقرير "${report['title']}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (report.containsKey('read')) {
                  if (_billsReceivedReports.contains(report)) {
                    _billsReceivedReports.remove(report);
                  }
                }
              });
              Navigator.pop(context);
              _showSuccessMessage('تم حذف التقرير');
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

  Widget _buildSimpleDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: _textColor()))),
          Expanded(child: Text(value, style: TextStyle(color: _textSecondaryColor()))),
        ],
      ),
    );
  }

  // ========== تبويب عمال النظافة ==========
  Widget _buildWorkersTab(bool isDarkMode) {
    return RefreshIndicator(
      onRefresh: _refreshWorkersTab,
      color: _primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // التبويبات الداخلية للعمال
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDarkMode ? const Color(0xFF333333) : const Color(0xFFE0E0E0)),
              ),
              child: Row(
                children: [
                  _buildWorkersInnerTabButton('عمال النظافة', 0, isDarkMode),
                  _buildWorkersInnerTabButton('طلبات التقارير', 1, isDarkMode),
                  _buildWorkersInnerTabButton('التقارير الواردة', 2, isDarkMode),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_currentWorkersTab == 0) _buildCleanersList(isDarkMode),
            if (_currentWorkersTab == 1) _buildWorkersReportRequestsSection(isDarkMode),
            if (_currentWorkersTab == 2) _buildWorkersReceivedReportsSection(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkersInnerTabButton(String title, int index, bool isDarkMode) {
    bool isSelected = _currentWorkersTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentWorkersTab = index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? _primaryColor.withOpacity(0.1) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? _primaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? _primaryColor : _textColor(),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCleanersList(bool isDarkMode) {
    int availableCount = _cleaners.where((c) => c.status == 'متاح').length;
    int onMissionCount = _cleaners.where((c) => c.status == 'في المهمة').length;
    int vacationCount = _cleaners.where((c) => c.status == 'إجازة').length;
    
    return Column(
      children: [
        // إحصائيات العمال
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardColor(),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor()),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.people_rounded, color: _primaryColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'إحصائيات العمال',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor()),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWorkersStatCard('المجموع', '${_cleaners.length}', Icons.people_rounded, _primaryColor),
                  _buildWorkersStatCard('متاح', '$availableCount', Icons.check_circle_rounded, _successColor),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWorkersStatCard('في المهمة', '$onMissionCount', Icons.work_rounded, _accentColor),
                  _buildWorkersStatCard('إجازة', '$vacationCount', Icons.beach_access_rounded, _warningColor),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'قائمة عمال النظافة',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryColor),
        ),
        const SizedBox(height: 12),
        ..._cleaners.map((cleaner) => _buildCleanerCard(cleaner, isDarkMode)).toList(),
      ],
    );
  }

  Widget _buildWorkersStatCard(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(width: 50, height: 50, decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(title, style: TextStyle(fontSize: 11, color: _textSecondaryColor())),
      ],
    );
  }

  Widget _buildCleanerCard(Cleaner cleaner, bool isDarkMode) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.person;
    String statusDescription = '';
    
    switch (cleaner.status) {
      case 'متاح':
        statusColor = _successColor;
        statusIcon = Icons.check_circle;
        statusDescription = 'متاح للتخصيص في أي مهمة';
        break;
      case 'في المهمة':
        statusColor = _accentColor;
        statusIcon = Icons.work;
        statusDescription = 'مشغول حالياً في مهمة جمع نفايات';
        break;
      case 'إجازة':
        statusColor = _warningColor;
        statusIcon = Icons.beach_access;
        statusDescription = 'في إجازة رسمية - غير متاح';
        break;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _cardColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor()),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس البطاقة مع الحالة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        cleaner.status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: cleaner.isSelected,
                  onChanged: (value) {
                    _toggleCleanerSelection(cleaner.id);
                  },
                  activeColor: _primaryColor,
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // معلومات العامل
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
                        cleaner.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _textColor(),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.phone, color: _textSecondaryColor(), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            cleaner.phone,
                            style: TextStyle(color: _textSecondaryColor()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // المعلومات الإضافية
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _backgroundColor(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildCleanerInfoRow('الرقم الوظيفي', cleaner.idNumber),
                  _buildCleanerInfoRow('القطاع', cleaner.sector),
                  _buildCleanerInfoRow('الراتب', cleaner.monthlySalary),
                  _buildCleanerInfoRow('الخبرة', '${cleaner.experienceYears} سنة'),
                  _buildCleanerInfoRow('آخر حضور', DateFormat('yyyy/MM/dd').format(cleaner.lastAttendance)),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // أزرار التحكم
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.edit, size: 18, color: _primaryColor),
                    label: Text(
                      'تغيير الحالة',
                      style: TextStyle(color: _primaryColor),
                    ),
                    onPressed: () => _changeCleanerStatus(cleaner),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: _primaryColor),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.message, size: 18),
                    label: const Text('تواصل'),
                    onPressed: () => _contactCleaner(cleaner),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
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

  Widget _buildCleanerInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(color: _textColor(), fontSize: 13),
          ),
          Text(
            title,
            style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkersReportRequestsSection(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor()),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.send_rounded, color: _primaryColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'طلب تقارير من مشرف العمال',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor()),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // رسالة توضيحية
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _primaryColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_rounded, color: _primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'سيتم إرسال طلب التقرير إلى مشرف العمال لإنشائه',
                      style: TextStyle(color: _textColor(), fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // أزرار طلب التقارير
            Row(
              children: [
                Expanded(
                  child: _buildWorkersReportRequestButton(
                    'طلب تقرير يومي',
                    Icons.today_rounded,
                    _primaryColor,
                    'يومي',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildWorkersReportRequestButton(
                    'طلب تقرير أسبوعي',
                    Icons.date_range_rounded,
                    _accentColor,
                    'أسبوعي',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildWorkersReportRequestButton(
                    'طلب تقرير شهري',
                    Icons.calendar_month_rounded,
                    _secondaryColor,
                    'شهري',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // قائمة طلبات التقارير
            Text(
              'طلباتي الأخيرة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textColor()),
            ),
            const SizedBox(height: 12),
            if (_workersReportRequests.isEmpty)
              _buildWorkersEmptyRequests()
            else
              Column(
                children: _workersReportRequests.map((request) => _buildWorkersRequestItem(request, isDarkMode)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkersReportRequestButton(String title, IconData icon, Color color, String reportType) {
    return ElevatedButton(
      onPressed: () => _showWorkersReportRequestConfirmation(reportType),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkersRequestItem(Map<String, dynamic> request, bool isDarkMode) {
    Color statusColor = _getRequestStatusColor(request['status']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor()),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getRequestIcon(request['status']),
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request['title'],
                  style: TextStyle(fontWeight: FontWeight.w600, color: _textColor()),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 12, color: _textSecondaryColor()),
                    const SizedBox(width: 4),
                    Text(
                      request['date'],
                      style: TextStyle(fontSize: 11, color: _textSecondaryColor()),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        request['status'],
                        style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.visibility_rounded, color: _primaryColor, size: 20),
            onPressed: () => _showWorkersRequestDetails(request),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkersReceivedReportsSection(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor()),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.inbox_rounded, color: _successColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'التقارير الواردة من مشرف العمال',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textColor()),
                ),
                const Spacer(),
                Badge(
                  label: Text('${_workersReceivedReports.where((r) => !r['read']).length}'),
                  backgroundColor: _primaryColor,
                  child: Icon(Icons.notifications_rounded, color: _primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // فلترة التقارير
            _buildWorkersReportFilter(),
            const SizedBox(height: 20),
            // قائمة التقارير الواردة
            if (_workersReceivedReports.isEmpty)
              _buildWorkersEmptyReports(isDarkMode)
            else
              Column(
                children: _getFilteredWorkersReports().map((report) => _buildWorkersReceivedReportItem(report, isDarkMode)).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkersReportFilter() {
    List<String> filters = ['الكل', 'يومي', 'أسبوعي', 'شهري', 'خاص'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          bool isSelected = _workersReportFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _workersReportFilter = filter;
                });
              },
              selectedColor: _primaryColor.withOpacity(0.2),
              checkmarkColor: _primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? _primaryColor : _textColor(),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : _borderColor()),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWorkersReceivedReportItem(Map<String, dynamic> report, bool isDarkMode) {
    Color statusColor = _getReportStatusColor(report['status']);
    Color priorityColor = _getPriorityColor(report['priority']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صف العنوان والحالة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (!report['read'])
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: _primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        report['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _textColor(),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  report['status'],
                  style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // معلومات التقرير
          Row(
            children: [
              // المرسل
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_rounded, size: 14, color: _textSecondaryColor()),
                        const SizedBox(width: 4),
                        Text(
                          'المرسل:',
                          style: TextStyle(fontSize: 12, color: _textSecondaryColor()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      report['sender'],
                      style: TextStyle(
                        fontSize: 13,
                        color: _textColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // التاريخ والوقت
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 14, color: _textSecondaryColor()),
                        const SizedBox(width: 4),
                        Text(
                          'التاريخ:',
                          style: TextStyle(fontSize: 12, color: _textSecondaryColor()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${report['date']} ${report['time']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: _textColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // نوع التقرير والأولوية
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.description_rounded, size: 12, color: _primaryColor),
                    const SizedBox(width: 4),
                    Text(
                      report['type'],
                      style: TextStyle(fontSize: 11, color: _primaryColor),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: priorityColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.priority_high_rounded, size: 12, color: priorityColor),
                    const SizedBox(width: 4),
                    Text(
                      report['priority'],
                      style: TextStyle(fontSize: 11, color: priorityColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // حجم الملف
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _backgroundColor(),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _borderColor()),
                ),
                child: Text(
                  report['size'],
                  style: TextStyle(fontSize: 11, color: _textSecondaryColor()),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // ملخص التقرير
          Text(
            report['summary'],
            style: TextStyle(
              fontSize: 13,
              color: _textSecondaryColor(),
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 12),
          
          // معلومات إضافية للعمال
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.people_rounded, size: 12, color: _successColor),
                    const SizedBox(width: 4),
                    Text(
                      '${report['presentWorkers'] ?? 0}/${report['totalWorkers'] ?? 0} حاضر',
                      style: TextStyle(fontSize: 11, color: _successColor),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person_off_rounded, size: 12, color: _errorColor),
                    const SizedBox(width: 4),
                    Text(
                      '${report['absentWorkers'] ?? 0} غياب',
                      style: TextStyle(fontSize: 11, color: _errorColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // أزرار الإجراءات
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _viewWorkersReportDetails(report);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primaryColor,
                    side: BorderSide(color: _primaryColor),
                  ),
                  icon: const Icon(Icons.remove_red_eye_rounded, size: 16),
                  label: const Text('عرض التقرير', style: TextStyle(fontSize:11)),
                ),
              ),
              
              const SizedBox(width: 8),
              
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _downloadWorkersReport(report);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.download_rounded, size: 16),
                  label: const Text('تحميل', style: TextStyle(fontSize:11)),
                ),
              ),
              
              const SizedBox(width: 8),
              
              IconButton(
                onPressed: () {
                  _showWorkersReportOptions(report);
                },
                icon: Icon(Icons.more_vert_rounded, color: _primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkersEmptyRequests() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor().withOpacity(0.5), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(Icons.send_rounded, size: 48, color: _textSecondaryColor()),
          const SizedBox(height: 12),
          Text(
            'لا توجد طلبات تقارير',
            style: TextStyle(fontSize: 16, color: _textSecondaryColor(), fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'يمكنك إرسال طلب تقرير باستخدام الأزرار أعلاه',
            textAlign: TextAlign.center,
            style: TextStyle(color: _textSecondaryColor()),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkersEmptyReports(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor()),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_rounded, size: 48, color: _textSecondaryColor()),
          const SizedBox(height: 12),
          Text(
            'لا توجد تقارير واردة',
            style: TextStyle(fontSize: 16, color: _textSecondaryColor(), fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'سيظهر هنا التقارير المرسلة من مشرف العمال',
            textAlign: TextAlign.center,
            style: TextStyle(color: _textSecondaryColor()),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredWorkersReports() {
    if (_workersReportFilter == 'الكل') return _workersReceivedReports;
    return _workersReceivedReports.where((report) => report['type'] == _workersReportFilter).toList();
  }

  void _toggleCleanerSelection(int id) {
    setState(() {
      int index = _cleaners.indexWhere((c) => c.id == id);
      if (index != -1) {
        _cleaners[index] = Cleaner(
          id: _cleaners[index].id,
          name: _cleaners[index].name,
          phone: _cleaners[index].phone,
          isSelected: !_cleaners[index].isSelected,
          status: _cleaners[index].status,
          idNumber: _cleaners[index].idNumber,
          sector: _cleaners[index].sector,
          experienceYears: _cleaners[index].experienceYears,
          monthlySalary: _cleaners[index].monthlySalary,
          lastAttendance: _cleaners[index].lastAttendance,
        );
      }
    });
  }

  void _changeCleanerStatus(Cleaner cleaner) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(),
        title: const Text(
          'تغيير حالة العامل',
          textAlign: TextAlign.right,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'اختر الحالة الجديدة:',
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 16),
            _buildCleanerStatusOption('متاح', _successColor, Icons.check_circle, cleaner),
            _buildCleanerStatusOption('في المهمة', _accentColor, Icons.work, cleaner),
            _buildCleanerStatusOption('إجازة', _warningColor, Icons.beach_access, cleaner),
          ],
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

  Widget _buildCleanerStatusOption(String status, Color color, IconData icon, Cleaner cleaner) {
    return ListTile(
      trailing: Icon(icon, color: color),
      title: Text(
        status,
        textAlign: TextAlign.right,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        setState(() {
          int index = _cleaners.indexWhere((c) => c.id == cleaner.id);
          if (index != -1) {
            _cleaners[index] = Cleaner(
              id: cleaner.id,
              name: cleaner.name,
              phone: cleaner.phone,
              isSelected: cleaner.isSelected,
              status: status,
              idNumber: cleaner.idNumber,
              sector: cleaner.sector,
              experienceYears: cleaner.experienceYears,
              monthlySalary: cleaner.monthlySalary,
              lastAttendance: cleaner.lastAttendance,
            );
          }
        });
        Navigator.pop(context);
        _showSuccessMessage('تم تغيير حالة ${cleaner.name} إلى $status');
      },
    );
  }

  void _contactCleaner(Cleaner cleaner) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تواصل مع ${cleaner.name}', style: TextStyle(color: _primaryColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('اختر طريقة التواصل:'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text('اتصال هاتفي'),
              subtitle: Text(cleaner.phone),
              onTap: () {
                Navigator.pop(context);
                _showSuccessMessage('جاري الاتصال بـ ${cleaner.name}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.message, color: Colors.blue),
              title: const Text('رسالة نصية'),
              subtitle: Text(cleaner.phone),
              onTap: () {
                Navigator.pop(context);
                _showSuccessMessage('جاري إرسال رسالة لـ ${cleaner.name}');
              },
            ),
          ],
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

  void _showWorkersRequestDetails(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(),
        title: Row(
          children: [
            Icon(Icons.request_page_rounded, color: _primaryColor),
            const SizedBox(width: 8),
            Text('تفاصيل طلب التقرير', style: TextStyle(color: _textColor())),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                request['title'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor()),
              ),
              const SizedBox(height: 16),
              _buildSimpleDetailRow('رقم الطلب:', request['id']),
              _buildSimpleDetailRow('نوع التقرير:', request['type']),
              _buildSimpleDetailRow('حالة الطلب:', request['status']),
              _buildSimpleDetailRow('تاريخ الطلب:', request['date']),
              _buildSimpleDetailRow('تاريخ التسليم:', request['dueDate']),
              _buildSimpleDetailRow('الأولوية:', request['priority']),
              _buildSimpleDetailRow('الوصف:', request['description']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showWorkersReportRequestConfirmation(String reportType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.send_rounded, color: _primaryColor, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              'تأكيد إرسال الطلب',
              style: TextStyle(color: _textColor(), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'هل تريد إرسال طلب لتقرير $reportType إلى مشرف العمال؟',
              style: TextStyle(color: _textColor(), fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _backgroundColor(),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderColor()),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description_rounded, size: 16, color: _primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'تفاصيل الطلب:',
                        style: TextStyle(fontWeight: FontWeight.bold, color: _textColor()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildSimpleDetailRow('نوع التقرير', 'تقرير $reportType'),
                  _buildSimpleDetailRow('المستلم', 'مشرف العمال'),
                  _buildSimpleDetailRow('حالة الطلب', 'سيكون معلق'),
                  _buildSimpleDetailRow('وقت الاستجابة المتوقع', '24-48 ساعة'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor())),
          ),
          ElevatedButton(
            onPressed: () {
              _sendWorkersReportRequest(reportType);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.send_rounded, size: 18),
                const SizedBox(width: 8),
                const Text('إرسال الطلب'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendWorkersReportRequest(String reportType) {
    setState(() {
      _workersReportRequests.insert(0, {
        'id': 'WRK-REQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(8, 12)}',
        'type': reportType,
        'title': 'طلب تقرير عمال $reportType',
        'requestedBy': 'مسؤول المحطة',
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'status': 'معلق',
        'priority': 'عادي',
        'dueDate': DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1))),
        'description': 'تقرير مفصل عن أداء عمال النظافة $reportType',
      });
    });
    
    _showSuccessMessage('تم إرسال طلب التقرير $reportType بنجاح');
  }

  void _viewWorkersReportDetails(Map<String, dynamic> report) {
    setState(() {
      report['read'] = true;
    });
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _cardColor(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                    Icon(Icons.people_rounded, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        report['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSimpleDetailRow('المرسل', report['sender']),
                      _buildSimpleDetailRow('نوع التقرير', report['type']),
                      _buildSimpleDetailRow('التاريخ', '${report['date']} ${report['time']}'),
                      _buildSimpleDetailRow('الأولوية', report['priority']),
                      _buildSimpleDetailRow('حجم الملف', report['size']),
                      _buildSimpleDetailRow('الصيغة', report['format']),
                      
                      const SizedBox(height: 16),
                      Divider(color: _borderColor()),
                      const SizedBox(height: 16),
                      
                      // ملخص التقرير
                      Text(
                        'ملخص التقرير',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        report['summary'],
                        style: TextStyle(
                          color: _textColor(),
                          height: 1.6,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // معلومات الحضور
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _backgroundColor(),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _borderColor()),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '${report['totalWorkers'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _primaryColor,
                                    ),
                                  ),
                                  Text(
                                    'إجمالي العمال',
                                    style: TextStyle(fontSize: 12, color: _textSecondaryColor()),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: _borderColor(),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '${report['presentWorkers'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _successColor,
                                    ),
                                  ),
                                  Text(
                                    'الحاضرون',
                                    style: TextStyle(fontSize: 12, color: _successColor),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: _borderColor(),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '${report['absentWorkers'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _errorColor,
                                    ),
                                  ),
                                  Text(
                                    'الغياب',
                                    style: TextStyle(fontSize: 12, color: _errorColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // المرفقات
                      if (report['attachments'] > 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'المرفقات',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: _primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'عدد المرفقات: ${report['attachments']}',
                              style: TextStyle(color: _textSecondaryColor()),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              
              // أزرار الإجراءات
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: _borderColor())),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إغلاق'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _downloadWorkersReport(report);
                        },
                        icon: const Icon(Icons.download_rounded),
                        label: const Text('تحميل التقرير'),
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

  void _downloadWorkersReport(Map<String, dynamic> report) {
    _showSuccessMessage('جاري تحميل التقرير: ${report['title']}');
  }

  void _showWorkersReportOptions(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardColor(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.share_rounded, color: _primaryColor),
              title: const Text('مشاركة التقرير'),
              onTap: () {
                Navigator.pop(context);
                _shareWorkersReport(report);
              },
            ),
            ListTile(
              leading: Icon(Icons.archive_rounded, color: _primaryColor),
              title: const Text('أرشفة التقرير'),
              onTap: () {
                Navigator.pop(context);
                _archiveWorkersReport(report);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_rounded, color: _errorColor),
              title: const Text('حذف التقرير', style: TextStyle(color: Color(0xFFD32F2F))),
              onTap: () {
                Navigator.pop(context);
                _deleteWorkersReport(report);
              },
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
          ],
        ),
      ),
    );
  }

  void _shareWorkersReport(Map<String, dynamic> report) {
    _showSuccessMessage('تم إعداد التقرير للمشاركة: ${report['title']}');
  }

  void _archiveWorkersReport(Map<String, dynamic> report) {
    setState(() {
      if (_workersReceivedReports.contains(report)) {
        _workersReceivedReports.remove(report);
      }
    });
    _showSuccessMessage('تم أرشفة التقرير');
  }

  void _deleteWorkersReport(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(),
        title: Row(
          children: [
            Icon(Icons.delete_rounded, color: _errorColor),
            const SizedBox(width: 8),
            const Text('حذف التقرير'),
          ],
        ),
        content: Text('هل أنت متأكد من حذف التقرير "${report['title']}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (_workersReceivedReports.contains(report)) {
                  _workersReceivedReports.remove(report);
                }
              });
              Navigator.pop(context);
              _showSuccessMessage('تم حذف التقرير');
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

  // ========== تبويب البلاغات ==========
  Widget _buildReportsTab(bool isDarkMode) {
    return RefreshIndicator(
      onRefresh: _refreshReportsTab,
      color: _primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportsStats(),
            const SizedBox(height: 20),
            _buildReportsFilter(),
            const SizedBox(height: 20),
            Text(
              'قائمة البلاغات (${_getFilteredReports().length})',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor()),
            ),
            const SizedBox(height: 12),
            ..._getFilteredReports().map((report) => _buildReportCard(report, isDarkMode)).toList(),
            const SizedBox(height: 20),
            _buildAddReportButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsStats() {
    int newCount = _reports.where((r) => r['status'] == 'جديد').length;
    int processingCount = _reports.where((r) => r['status'] == 'قيد المعالجة').length;
    int completedCount = _reports.where((r) => r['status'] == 'تمت المعالجة').length;
    
    return Container(
      decoration: BoxDecoration(
        color: _cardColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor()),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildReportStatCard('جديد', newCount, _primaryColor),
            _buildReportStatCard('قيد المعالجة', processingCount, _warningColor),
            _buildReportStatCard('مكتمل', completedCount, _successColor),
          ],
        ),
      ),
    );
  }

  Widget _buildReportStatCard(String title, int count, Color color) {
    return Column(
      children: [
        Container(width: 50, height: 50, decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Center(child: Text(count.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)))),
        const SizedBox(height: 8),
        Text(title, style: TextStyle(fontSize: 12, color: _textSecondaryColor())),
      ],
    );
  }

  Widget _buildReportsFilter() {
    List<String> filters = ['الكل', 'جديد', 'قيد المعالجة', 'تمت المعالجة'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          bool isSelected = _selectedReportType == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedReportType = filter;
                });
              },
              selectedColor: _primaryColor.withOpacity(0.2),
              checkmarkColor: _primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? _primaryColor : _textColor(),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : _borderColor()),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report, bool isDarkMode) {
    Color statusColor = _getPriorityColor(report['status'] == 'جديد' ? 'عاجل' : (report['status'] == 'قيد المعالجة' ? 'عالي' : 'عادي'));
    Color priorityColor = _getPriorityColor(report['priority']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _cardColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor()),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    report['title'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor()),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    report['status'],
                    style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Icon(Icons.person_rounded, size: 14, color: _textSecondaryColor()),
                const SizedBox(width: 4),
                Text(report['citizenName'], style: TextStyle(color: _textSecondaryColor())),
                const SizedBox(width: 16),
                Icon(Icons.phone_rounded, size: 14, color: _textSecondaryColor()),
                const SizedBox(width: 4),
                Text(report['phone'], style: TextStyle(color: _textSecondaryColor())),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                Icon(Icons.location_on_rounded, size: 14, color: _textSecondaryColor()),
                const SizedBox(width: 4),
                Expanded(child: Text(report['location'], style: TextStyle(color: _textSecondaryColor()))),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: priorityColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.priority_high_rounded, size: 12, color: priorityColor),
                      const SizedBox(width: 4),
                      Text(
                        report['priority'],
                        style: TextStyle(fontSize: 10, color: priorityColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 8),
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.category_rounded, size: 12, color: _primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        report['type'],
                        style: TextStyle(fontSize: 10, color: _primaryColor),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                if (report['images'] > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.image_rounded, size: 12, color: _accentColor),
                        const SizedBox(width: 4),
                        Text(
                          '${report['images']} صور',
                          style: TextStyle(fontSize: 10, color: _accentColor),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewReportDetailsDialog(report),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primaryColor,
                      side: BorderSide(color: _primaryColor),
                    ),
                    icon: const Icon(Icons.remove_red_eye_rounded, size: 16),
                    label: const Text('عرض التفاصيل', style: TextStyle(fontSize:11)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleReport(report),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.play_arrow_rounded, size: 16),
                    label: const Text('معالجة', style: TextStyle(fontSize:11)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddReportButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _showAddReportDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('إضافة بلاغ جديد'),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredReports() {
    if (_selectedReportType == 'الكل') return _reports;
    return _reports.where((report) => report['status'] == _selectedReportType).toList();
  }

  void _viewReportDetailsDialog(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _cardColor(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.report_problem_rounded, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'تفاصيل البلاغ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSimpleDetailRow('رقم البلاغ:', report['id']),
                      _buildSimpleDetailRow('العنوان:', report['title']),
                      _buildSimpleDetailRow('الوصف:', report['description']),
                      _buildSimpleDetailRow('المواطن:', report['citizenName']),
                      _buildSimpleDetailRow('رقم الهاتف:', report['phone']),
                      _buildSimpleDetailRow('الموقع:', report['location']),
                      _buildSimpleDetailRow('التاريخ:', '${report['date']} ${report['time']}'),
                      _buildSimpleDetailRow('الحالة:', report['status']),
                      _buildSimpleDetailRow('الأولوية:', report['priority']),
                      _buildSimpleDetailRow('النوع:', report['type']),
                      if (report['assignedTo'].isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text('معلومات المعالجة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        _buildSimpleDetailRow('مسؤول:', report['assignedTo']),
                        _buildSimpleDetailRow('وقت الاستجابة:', report['responseTime']),
                      ],
                      if (report['completedDate'] != null)
                        _buildSimpleDetailRow('تاريخ الإكمال:', report['completedDate']),
                    ],
                  ),
                ),
              ),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: _borderColor())),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إغلاق'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _handleReport(report);
                        },
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('معالجة'),
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

  void _handleReport(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(),
        title: Row(
          children: [
            Icon(Icons.play_arrow_rounded, color: _primaryColor),
            const SizedBox(width: 8),
            const Text('معالجة البلاغ'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('هل أنت متأكد من معالجة هذا البلاغ؟'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'تعيين إلى',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'فريق النظافة', child: Text('فريق النظافة')),
                DropdownMenuItem(value: 'فريق الصيانة', child: Text('فريق الصيانة')),
                DropdownMenuItem(value: 'فريق الطوارئ', child: Text('فريق الطوارئ')),
              ],
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                report['status'] = 'قيد المعالجة';
                report['assignedTo'] = 'فريق النظافة';
              });
              Navigator.pop(context);
              _showSuccessMessage('تم معالجة البلاغ بنجاح');
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  void _showAddReportDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _cardColor(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.add_alert_rounded, color: _primaryColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'إضافة بلاغ جديد',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor()),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'عنوان البلاغ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'وصف البلاغ',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'اسم المواطن',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'الموقع',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showSuccessMessage('تم إضافة البلاغ بنجاح');
                      },
                      child: const Text('إضافة البلاغ'),
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

  // ========== تبويب جدول النفايات (محدث) ==========
Widget _buildScheduleTab(bool isDarkMode) {
  return RefreshIndicator(
    onRefresh: _refreshScheduleTab,
    color: _primaryColor,
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شريط الإحصائيات
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cardColor(),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor()),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildScheduleStatChip('إجمالي المهام', _weeklySchedule.length.toString(), _primaryColor),
                _buildScheduleStatChip('المناطق', _getUniqueAreasFromSchedule().toString(), _successColor),
                _buildScheduleStatChip('العمال', _getUniqueWorkersFromSchedule().toString(), _warningColor),
                _buildScheduleStatChip('الشاحنات', _getUniqueTrucksFromSchedule().toString(), _accentColor),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // الجدول الرئيسي
          Container(
            decoration: BoxDecoration(
              color: _cardColor(),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor()),
            ),
            padding: const EdgeInsets.all(12),
            child: _buildScheduleTable(isDarkMode),
          ),
          
          // إضافة مسافة في الأسفل للسماح بالسحب
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

Widget _buildScheduleStatChip(String label, String value, Color color) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          color: _textSecondaryColor(),
          fontSize: 11,
        ),
      ),
    ],
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
        _buildScheduleTotalRow(isDarkMode),
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
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
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
              color: isDarkMode ? _darkTextColor() : _primaryColor,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const SizedBox(width: 4),
        Icon(Icons.arrow_upward_rounded, size: 14, color: isDarkMode ? _darkTextSecondaryColor() : _textSecondaryColor()),
      ],
    ),
  );
}
Widget _buildScheduleSubRow(DaySchedule task, bool isDarkMode, Color bgColor) {
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
              Icon(Icons.subdirectory_arrow_right_rounded, size: 16, color: _textSecondaryColor()),
            ],
          ),
        ),
        _buildScheduleDataCell(
          width: 180,
          child: Text(
            task.areaName, 
            style: const TextStyle(fontSize: 11), 
            maxLines: 2, 
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildScheduleDataCell(
          width: 140,
          child: Text(
            '${task.startTime} - ${task.endTime}', 
            style: const TextStyle(fontSize: 11), 
            maxLines: 1, 
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildScheduleDataCell(
          width: 180,
          child: Text(
            task.assignedCleaners.map((c) => c.name).join('، '), 
            style: const TextStyle(fontSize: 11), 
            maxLines: 2, 
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildScheduleDataCell(
          width: 120,
          child: Text(
            task.truck?.name ?? '---', 
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500), 
            maxLines: 1, 
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildScheduleDataCell(
          width: 100,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${_calculateDayBins(task)}',
              style: TextStyle(
                color: _successColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
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

Widget _buildScheduleTotalRow(bool isDarkMode) {
  int totalBins = _calculateTotalBinsFromSchedule();
  int totalTasks = _weeklySchedule.length;
  int uniqueAreas = _getUniqueAreasFromSchedule();
  int uniqueWorkers = _getUniqueWorkersFromSchedule();
  int uniqueTrucks = _getUniqueTrucksFromSchedule();
  
  return Container(
    decoration: BoxDecoration(
      color: isDarkMode ? _darkPrimaryColor.withOpacity(0.2) : _primaryColor.withOpacity(0.05),
      border: Border(
        top: BorderSide(color: _secondaryColor, width: 2),
        bottom: BorderSide(color: isDarkMode ? Colors.grey[800]! : _borderColor()),
      ),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(8),
      ),
    ),
    child: Row(
      children: [
        // العمود 1: اليوم
        _buildScheduleTotalCell(
          width: 100,
          child: Text(
            'الإجمالي',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? _darkTextColor() : _primaryColor,
              fontSize: 12,
            ),
          ),
        ),
        
        // العمود 2: منطقة العمل
        _buildScheduleTotalCell(
          width: 180,
          child: Text(
            '$uniqueAreas منطقة',
            style: TextStyle(
              color: isDarkMode ? _darkTextColor() : _textColor(),
              fontSize: 12,
            ),
          ),
        ),
        
        // العمود 3: الوقت
        _buildScheduleTotalCell(
          width: 140,
          child: Text(
            '$totalTasks مهمة',
            style: TextStyle(
              color: isDarkMode ? _darkTextColor() : _textColor(),
              fontSize: 12,
            ),
          ),
        ),
        
        // العمود 4: العمال
        _buildScheduleTotalCell(
          width: 180,
          child: Text(
            '$uniqueWorkers عامل',
            style: TextStyle(
              color: isDarkMode ? _darkTextColor() : _textColor(),
              fontSize: 12,
            ),
          ),
        ),
        
        // العمود 5: رقم الشاحنة
        _buildScheduleTotalCell(
          width: 120,
          child: Text(
            '$uniqueTrucks شاحنة',
            style: TextStyle(
              color: isDarkMode ? _darkTextColor() : _textColor(),
              fontSize: 12,
            ),
          ),
        ),
        
        // العمود 6: عدد البيوت
        _buildScheduleTotalCell(
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

Widget _buildScheduleTotalCell({required double width, required Widget child}) {
  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
    alignment: Alignment.centerRight,
    child: child,
  );
}

// دوال مساعدة للجدول
List<Map<String, dynamic>> _getWeekDays() {
  final today = DateTime.now();
  
  // الحصول على يوم الأحد من هذا الأسبوع
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

List<DaySchedule> _getTasksForDay(DateTime date) {
  return _weeklySchedule.where((schedule) {
    return schedule.date.year == date.year &&
           schedule.date.month == date.month &&
           schedule.date.day == date.day;
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

int _calculateDayBins(DaySchedule schedule) {
  // قيمة افتراضية لعدد البيوت (يمكن تعديلها حسب البيانات الفعلية)
  return 15 + (schedule.date.day % 10);
}

int _calculateTotalBinsFromSchedule() {
  int total = 0;
  for (var schedule in _weeklySchedule) {
    if (!schedule.isDayOff) {
      total += _calculateDayBins(schedule);
    }
  }
  return total;
}

int _getUniqueAreasFromSchedule() {
  final areas = <String>{};
  for (var schedule in _weeklySchedule) {
    if (!schedule.isDayOff) {
      areas.add(schedule.areaName);
    }
  }
  return areas.length;
}

int _getUniqueWorkersFromSchedule() {
  final workers = <String>{};
  for (var schedule in _weeklySchedule) {
    for (var cleaner in schedule.assignedCleaners) {
      workers.add(cleaner.name);
    }
  }
  return workers.length;
}

int _getUniqueTrucksFromSchedule() {
  final trucks = <String>{};
  for (var schedule in _weeklySchedule) {
    if (schedule.truck != null) {
      trucks.add(schedule.truck!.name);
    }
  }
  return trucks.length;
}

// دوال الألوان المساعدة (للوضع الداكن)
Color _darkTextColor() {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  return themeProvider.isDarkMode ? Colors.white : const Color(0xFF212121);
}

Color _darkTextSecondaryColor() {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  return themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF757575);
}

  Widget _buildScheduleInnerTabButton(String title, int index, bool isDarkMode) {
    bool isSelected = _currentScheduleTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentScheduleTab = index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? _primaryColor.withOpacity(0.1) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isSelected ? _primaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? _primaryColor : _textColor(),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
Widget _buildWasteSchedule(bool isDarkMode) {
  final weekDays = _getWeekDays();
  
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor()),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.calendar_month_rounded, color: _primaryColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'جدول جمع النفايات',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor()),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // استخدام الجدول الجديد بدلاً من التكرار على _weeklySchedule مباشرة
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  _buildScheduleTotalRow(isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
  Widget _buildScheduleRow({
  required String dayName,
  required DateTime dayDate,
  required List<DaySchedule> tasks,
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
                            color: isDarkMode ? _darkTextSecondaryColor() : _textSecondaryColor(),
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
                  color: isDarkMode ? _darkTextColor() : _textColor(),
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildScheduleDataCell(
              width: 140,
              child: Text(
                primaryTask != null && !primaryTask.isDayOff 
                    ? '${primaryTask.startTime} - ${primaryTask.endTime}' 
                    : (primaryTask?.isDayOff == true ? 'عطلة' : '--:--'),
                style: TextStyle(
                  color: isDarkMode ? _darkTextColor() : _textColor(),
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildScheduleDataCell(
              width: 180,
              child: Text(
                primaryTask != null && primaryTask.assignedCleaners.isNotEmpty
                    ? primaryTask.assignedCleaners.map((c) => c.name).join('، ')
                    : '---',
                style: TextStyle(
                  color: isDarkMode ? _darkTextColor() : _textColor(),
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildScheduleDataCell(
              width: 120,
              child: Text(
                primaryTask?.truck?.name ?? '---',
                style: TextStyle(
                  color: isDarkMode ? _darkTextColor() : _textColor(),
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
                  if (primaryTask != null && !primaryTask.isDayOff)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: _successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_calculateDayBins(primaryTask)}',
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

  Widget _buildTrucksList(bool isDarkMode) {
    int readyCount = _availableTrucks.where((t) => t.status == 'جاهزة للعمل').length;
    int maintenanceCount = _availableTrucks.where((t) => t.status == 'تحت الصيانة').length;
    int busyCount = _availableTrucks.where((t) => t.status == 'مشغولة حالياً').length;
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardColor(),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor()),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.local_shipping_rounded, color: _primaryColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'أسطول الشاحنات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor()),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTruckStatCard('جاهزة', '$readyCount', Icons.check_circle_rounded, _successColor),
                  _buildTruckStatCard('صيانة', '$maintenanceCount', Icons.build_rounded, _warningColor),
                  _buildTruckStatCard('مشغولة', '$busyCount', Icons.work_rounded, _accentColor),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'قائمة الشاحنات',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryColor),
        ),
        const SizedBox(height: 12),
        ..._availableTrucks.map((truck) => _buildTruckCard(truck, isDarkMode)).toList(),
      ],
    );
  }

  Widget _buildTruckStatCard(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 20)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        Text(title, style: TextStyle(fontSize: 10, color: _textSecondaryColor())),
      ],
    );
  }

  Widget _buildTruckCard(Truck truck, bool isDarkMode) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.local_shipping;
    String statusDescription = '';
    
    switch (truck.status) {
      case 'جاهزة للعمل':
        statusColor = _successColor;
        statusIcon = Icons.check_circle;
        statusDescription = 'جاهزة للعمل - متاحة للاستخدام الفوري';
        break;
      case 'تحت الصيانة':
        statusColor = _warningColor;
        statusIcon = Icons.build;
        statusDescription = 'قيد الصيانة الدورية - غير متاحة';
        break;
      case 'مشغولة حالياً':
        statusColor = _accentColor;
        statusIcon = Icons.work;
        statusDescription = 'مشغولة في مهمة جمع نفايات';
        break;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _cardColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor()),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس البطاقة مع الحالة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        truck.status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: truck.isSelected,
                  onChanged: (value) {
                    _toggleTruckSelection(truck.id);
                  },
                  activeColor: _primaryColor,
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // معلومات الشاحنة
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.local_shipping, color: _primaryColor, size: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        truck.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _textColor(),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        truck.type,
                        style: TextStyle(
                          color: _primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // المعلومات الفنية
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _backgroundColor(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildTruckInfoRow('السعة', truck.capacity, Icons.inventory)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTruckInfoRow('اللوحة', truck.plateNumber, Icons.confirmation_number)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildTruckInfoRow('السائق', truck.driver, Icons.person)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTruckInfoRow('القطاع', truck.sector, Icons.location_on)),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // مناطق الخدمة
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _primaryColor.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مناطق الخدمة:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    truck.districts.join('، '),
                    style: TextStyle(
                      color: _textSecondaryColor(),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // معلومات الصيانة
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'آخر صيانة: ${DateFormat('yyyy/MM/dd').format(truck.lastMaintenance)}',
                        style: TextStyle(color: statusColor, fontSize: 11),
                      ),
                      Text(
                        'الصيانة القادمة: ${DateFormat('yyyy/MM/dd').format(truck.nextMaintenance)}',
                        style: TextStyle(color: statusColor, fontSize: 11),
                      ),
                    ],
                  ),
                  Icon(statusIcon, color: statusColor, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTruckInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: _primaryColor, size: 14),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(color: _textColor(), fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                label,
                style: TextStyle(color: _primaryColor, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _editScheduleRow(DaySchedule schedule) {
    // هنا يمكن إضافة منطق تعديل الجدول
    _showSuccessMessage('يمكن تعديل الجدول هنا');
  }

  void _toggleTruckSelection(int id) {
    setState(() {
      int index = _availableTrucks.indexWhere((t) => t.id == id);
      if (index != -1) {
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
      }
    });
  }

  // ========== الدوال المساعدة العامة ==========
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: _successColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDrawer(bool isDarkMode) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode ? [_darkPrimaryColor, const Color(0xFF0D1B0E)] : [_primaryColor, const Color(0xFF117E75)],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDarkMode ? [_darkPrimaryColor, const Color(0xFF0A5F4F)] : [_primaryColor, const Color(0xFF0E6B62)],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(Icons.delete_outline_rounded, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "مسؤول النفايات",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "مدير إدارة النفايات",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
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
                      "بلدية بغداد",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: isDarkMode ? const Color(0xFF0D1B0E) : const Color(0xFFE8F5E9),
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
                      onTap: () => _showLogoutConfirmation(context),
                      isDarkMode: isDarkMode,
                      isLogout: true,
                    ),
                    const SizedBox(height: 40),
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
                            'بلدية بغداد - نظام إدارة النفايات',
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
    final Color iconColor = isLogout ? Colors.red : (isDarkMode ? Colors.white70 : Colors.grey[700]!);
    
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
            color: isLogout ? Colors.red.withOpacity(0.2) : (isDarkMode ? Colors.white12 : Colors.grey[100]),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
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

  void _showLogoutConfirmation(BuildContext context) {
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
        content: const Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟', style: TextStyle(color: Colors.black87)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: _accentColor)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout(context);
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

  void _performLogout(BuildContext context) {
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

// ========== كلاس RefreshController للتحديث ==========
class RefreshController {
  void refreshCompleted() {}
  void dispose() {}
}

// ========== كلاسات النماذج ==========
class Cleaner {
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
  
  Cleaner({
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
// تعديل كلاس DaySchedule
class DaySchedule {
  final DateTime date;
  final String dayName;
  String startTime;
  String endTime;
  Truck? truck;
  bool isDayOff;
  List<Cleaner> assignedCleaners;
  
  String get areaName {
    return truck?.sector ?? 'منطقة غير محددة';
  }
  
  DaySchedule({
    required this.date,
    required this.dayName,
    required this.startTime,
    required this.endTime,
    required this.truck,
    required this.isDayOff,
    required this.assignedCleaners,
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