import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:mang_mu/screens/employee/Shared Services/esignin_screen.dart';

class ReportingOfficerElectricityScreen extends StatefulWidget {
  @override
  _ReportingOfficerElectricityScreenState createState() => _ReportingOfficerElectricityScreenState();
}

class _ReportingOfficerElectricityScreenState extends State<ReportingOfficerElectricityScreen> 
    with TickerProviderStateMixin {
  
  late TabController _mainTabController;
  late TabController _electricityTabController;
  late TabController _employeeTabController;
  late TabController _appTabController;
  late TabController _electricitySubTabController;
  late TabController _employeeSubTabController;
  late TabController _appSubTabController;
  late AnimationController _animationController;
  late TabController _emergencyTabController;
  late TabController _emergencySubTabController;

  // متغيرات التحكم في التحديث
  final GlobalKey<RefreshIndicatorState> _refreshElectricityKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshEmployeeKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshAppKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshEmergencyKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshReportsKey = GlobalKey<RefreshIndicatorState>();

  // ألوان موحدة للتبويبات
  late Color _tabPrimaryColor;
  late Color _tabSecondaryColor;

  String _selectedReportType = 'اليوم';
  TextEditingController _searchController = TextEditingController();
  int _currentReportTab = 0;
  
  // ألوان وزارة الكهرباء الحكومية
  final Color _primaryColor = Color(0xFF0056A4); // أزرق حكومي
  final Color _secondaryColor = Color(0xFF0077C8); // أزرق فاتح
  final Color _accentColor = Color(0xFF00A8E8); // أزرق سماوي
  final Color _warningColor = Color(0xFFFF9800); // برتقالي تحذير
  final Color _dangerColor = Color(0xFFD32F2F); // أحمر تحذير
  final Color _infoColor = Color(0xFF0097A7); // تركواز
  final Color _darkColor = Color(0xFF1A237E); // أزرق داكن
  final Color _lightColor = Color(0xFFF5F7FA); // خلفية فاتحة
  final Color _successColor = Color(0xFF2E7D32); // أخضر نجاح

  // نظام التقارير
  String _selectedReportTypeSystem = 'يومي';
  List<DateTime> _selectedDates = [];
  String? _selectedWeek;
  String? _selectedMonth;
  final List<String> _reportTypes = ['يومي', 'أسبوعي', 'شهري'];
  final List<String> _weeks = ['الأسبوع الأول', 'الأسبوع الثاني', 'الأسبوع الثالث', 'الأسبوع الرابع'];
  final List<String> _months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
  
  // متغيرات التصفية والتبويبات الفرعية
  Map<String, String> _subTabStatus = {
    'electricity': 'غير مقروءة',
    'employee': 'غير مقروءة',
    'app': 'غير مقروءة',
    'emergency': 'غير مقروءة',
  };

  // متغيرات حالة التحميل
  bool _isLoadingElectricity = false;
  bool _isLoadingEmployee = false;
  bool _isLoadingApp = false;
  bool _isLoadingEmergency = false;
  bool _isLoadingReports = false;

  // بيانات إضافية لانقطاع التيار الكهربائي
List<ElectricityProblem> _outageProblems = [
  ElectricityProblem(
    customerName: 'محمد عبدالله',
    customerId: 'CUST-004',
    problemType: 'انقطاع التيار الكهربائي',
    location: 'حي النور - شارع 14 رمضان',
    substation: 'محطة تحويل النور 33/11 ك.ف',
    date: '2024-01-26',
    time: '06:45 ص',
    duration: '5 ساعات',
    description: 'انقطاع كامل للتيار الكهربائي عن الحي منذ الفجر. تم إرسال فرق الصيانة والتحقيق جارٍ.',
    imageAsset: 'assets/outage2.jpg',
    status: 'قيد المعالجة',
    priority: 'عالي',
    isRead: false,
    reportedDate: DateTime.now().subtract(Duration(hours: 6)),
    problemCategory: 'انقطاع التيار الكهربائي',
    voltageReading: null,
    meterNumber: null,
    transformerCode: null,
  ),
  ElectricityProblem(
    customerName: 'نورا سليم',
    customerId: 'CUST-005',
    problemType: 'انقطاع التيار الكهربائي',
    location: 'مجمع السلام السكني - بناية 7',
    substation: 'محطة تحويل السلام',
    date: '2024-01-25',
    time: '22:30 م',
    duration: '2 ساعات',
    description: 'انقطاع التيار الكهربائي عن المجمع بسبب عطل في الكابل الرئيسي.',
    imageAsset: 'assets/outage3.jpg',
    status: 'تم المعالجة',
    priority: 'متوسط',
    isRead: true,
    reportedDate: DateTime.now().subtract(Duration(days: 1)),
    problemCategory: 'انقطاع التيار الكهربائي',
    voltageReading: null,
    meterNumber: null,
    transformerCode: null,
  ),

];
// بيانات إضافية لمشاكل الفولطية
List<ElectricityProblem> _voltageProblems = [
  ElectricityProblem(
    customerName: 'زينب محمد',
    customerId: 'CUST-007',
    problemType: 'مشكلة في الفولطية',
    location: 'حي الزهور - عمارة 12',
    substation: 'محطة تحويل الزهور',
    date: '2024-01-26',
    time: '09:20 ص',
    duration: '4 ساعات',
    description: 'ارتفاع مفاجئ في الجهد الكهربائي أدى إلى احتراق 3 أجهزة منزلية.',
    imageAsset: 'assets/voltage3.jpg',
    status: 'لم يتم المعالجة',
    priority: 'عالي',
    isRead: false,
    reportedDate: DateTime.now().subtract(Duration(hours: 5)),
    problemCategory: 'مشكلة في الفولطية',
    voltageReading: '250 فولت',
    meterNumber: 'MTR-0089',
    transformerCode: null,
  ),
  ElectricityProblem(
    customerName: 'كريم جاسم',
    customerId: 'CUST-008',
    problemType: 'مشكلة في الفولطية',
    location: 'مجمع الأندلس - شقة 45',
    substation: 'محطة تحويل الأندلس',
    date: '2024-01-25',
    time: '15:40 م',
    duration: '6 ساعات',
    description: 'تذبذب في الجهد الكهربائي يسبب وميض في الإضاءة وانقطاع متكرر.',
    imageAsset: 'assets/voltage4.jpg',
    status: 'قيد المعالجة',
    priority: 'متوسط',
    isRead: true,
    reportedDate: DateTime.now().subtract(Duration(days: 1)),
    problemCategory: 'مشكلة في الفولطية',
    voltageReading: '170-230 فولت',
    meterNumber: 'MTR-0156',
    transformerCode: null,
  ),
];
// بيانات إضافية لمشاكل العدادات
List<ElectricityProblem> _meterProblems = [
  ElectricityProblem(
    customerName: 'عبدالله حميد',
    customerId: 'CUST-009',
    problemType: 'مشكلة في العدادات',
    location: 'حي العاملين - منزل 23',
    substation: 'محطة تحويل العاملين',
    date: '2024-01-26',
    time: '08:30 ص',
    duration: '2 ساعات',
    description: 'العداد لا يسجل الاستهلاك بشكل صحيح والفواتير تأتي بقيم خاطئة.',
    imageAsset: 'assets/meter1.jpg',
    status: 'لم يتم المعالجة',
    priority: 'متوسط',
    isRead: false,
    reportedDate: DateTime.now().subtract(Duration(hours: 4)),
    problemCategory: 'مشكلة في العدادات',
    voltageReading: null,
    meterNumber: 'MTR-0789',
    transformerCode: null,
  ),
  ElectricityProblem(
    customerName: 'منى سعيد',
    customerId: 'CUST-010',
    problemType: 'مشكلة في العدادات',
    location: 'شارع الخوارزمي - محل 8',
    substation: 'محطة تحويل الخوارزمي',
    date: '2024-01-25',
    time: '12:15 م',
    duration: '24 ساعة',
    description: 'العداد متوقف عن العمل تماماً ولا تظهر أي قراءات على الشاشة.',
    imageAsset: 'assets/meter2.jpg',
    status: 'تم المعالجة',
    priority: 'عالي',
    isRead: true,
    reportedDate: DateTime.now().subtract(Duration(days: 2)),
    problemCategory: 'مشكلة في العدادات',
    voltageReading: null,
    meterNumber: 'MTR-0345',
    transformerCode: null,
  ),
];
// بيانات إضافية لموظفي الصيانة
List<EmployeeProblem> _maintenanceEmployeeProblems = [
  EmployeeProblem(
    customerName: 'سلمان خالد',
    area: 'حي الجامعة',
    location: 'شارع فلسطين - مجمع 5',
    date: '2024-01-26',
    time: '09:00 ص',
    description: 'فني الصيانة تأخر 4 ساعات عن الموعد المحدد وعند وصوله لم يعمل بشكل صحيح.',
    imageAsset: 'assets/technical2.jpg',
    problemType: 'موظف الصيانة',
    status: 'لم يتم المعالجة',
    isRead: false,
    reportedDate: DateTime.now().subtract(Duration(hours: 7)),
    employeeName: 'فني الصيانة - محمد إبراهيم',
    delayHours: 4,
    employeeDepartment: 'إدارة الصيانة',
  ),
  EmployeeProblem(
    customerName: 'هند عبدالرحمن',
    area: 'حي الواحة',
    location: 'عمارة البرج - الطابق 6',
    date: '2024-01-25',
    time: '14:30 م',
    description: 'الفني رفض إصلاح العطل بحجة أنه خارج أوقات الدوام الرسمي.',
    imageAsset: 'assets/technical3.jpg',
    problemType: 'موظف الصيانة',
    status: 'قيد المعالجة',
    isRead: false,
    reportedDate: DateTime.now().subtract(Duration(days: 1)),
    employeeName: 'فني الصيانة - سامي عبدالله',
    delayHours: 2,
    employeeDepartment: 'إدارة الصيانة',
  ),
];
// بيانات إضافية لموظفي الفواتير
List<EmployeeProblem> _billingEmployeeProblems = [
  EmployeeProblem(
    customerName: 'ماجد فوزي',
    area: 'حي الأمل',
    location: 'منزل 17 - زقاق 3',
    date: '2024-01-26',
    time: '11:45 ص',
    description: 'موظف الفواتير أخطأ في قراءة العداد وأصدر فاتورة بقيمة مضاعفة 3 مرات.',
    imageAsset: 'assets/billing3.jpg',
    problemType: 'موظف الفواتير',
    status: 'لم يتم المعالجة',
    isRead: false,
    reportedDate: DateTime.now().subtract(Duration(hours: 5)),
    employeeName: 'موظف الفواتير - كريم جبار',
    delayHours: 0,
    employeeDepartment: 'إدارة الفواتير',
  ),
];
  List<EmergencyReport> _emergencyReports = [
    EmergencyReport(
      customerName: 'علي حميد',
      location: 'حي الصحة - شارع المستشفى',
      area: 'حي الصحة',
      emergencyType: 'حادث كهربائي',
      accidentLocation: 'أمام المستشفى العام',
      date: '2024-01-26',
      time: '10:15 ص',
      description: 'حادث انفجار محول كهربائي أمام المستشفى العام، يوجد مصابين.',
      imageAsset: 'assets/emergency1.jpg',
      status: 'لم يتم المعالجة',
      isRead: false,
      reportedDate: DateTime.now().subtract(Duration(minutes: 30)),
      severity: 'حرجة',
      injuredCount: 2,
      firePresent: true,
      roadClosed: true,
    ),
    EmergencyReport(
      customerName: 'سعاد أحمد',
      location: 'حي الأندلس - شارع المدارس',
      area: 'حي الأندلس',
      emergencyType: 'حادث سير مع عمود كهرباء',
      accidentLocation: 'تقاطع شارع المدارس مع شارع الرياض',
      date: '2024-01-26',
      time: '09:45 ص',
      description: 'تصادم سيارة مع عمود إنارة كهربائي، العمود مائل ويشكل خطراً.',
      imageAsset: 'assets/emergency2.jpg',
      status: 'قيد المعالجة',
      isRead: true,
      reportedDate: DateTime.now().subtract(Duration(hours: 2)),
      severity: 'عالية',
      injuredCount: 1,
      firePresent: false,
      roadClosed: true,
    ),
    EmergencyReport(
      customerName: 'مصطفى كريم',
      location: 'حي القادسية - سوق الخضار',
      area: 'حي القادسية',
      emergencyType: 'حريق في لوحة توزيع',
      accidentLocation: 'سوق الخضار المركزي - المحل رقم 45',
      date: '2024-01-25',
      time: '11:30 ص',
      description: 'حريق في لوحة التوزيع الكهربائية بسوق الخضار، تم إخلاء المنطقة.',
      imageAsset: 'assets/emergency3.jpg',
      status: 'قيد المعالجة',
      isRead: false,
      reportedDate: DateTime.now().subtract(Duration(days: 1)),
      severity: 'عالية',
      injuredCount: 0,
      firePresent: true,
      roadClosed: false,
    ),
  ];

  // بيانات التقارير
  final List<Map<String, dynamic>> reports = [
    {
      'id': 'REP-2024-001',
      'title': 'تقرير الإيرادات الشهري',
      'type': 'مالي',
      'period': 'يناير 2024',
      'generatedDate': DateTime.now().subtract(Duration(days: 2)),
      'totalRevenue': 5000000,
      'totalBills': 200,
      'paidBills': 180,
    },
  ];

  // بيانات المشاكل للكهرباء
  List<ElectricityProblem> _electricityProblems = [
    ElectricityProblem(
      customerName: 'أحمد محمد',
      customerId: 'CUST-001',
      problemType: 'انقطاع التيار الكهربائي',
      location: 'حي السلام - شارع الملك فهد',
      substation: 'محطة تحويل الرياض 132/13.8 ك.ف',
      date: '2024-01-15',
      time: '08:30 ص',
      duration: '3 ساعات',
      description: 'انقطاع كامل للتيار الكهربائي عن المنطقة منذ الساعة 8:30 صباحاً. تم إبلاغ الفنيين والمتابعة جارية.',
      imageAsset: 'assets/outage1.jpg',
      status: 'قيد المعالجة',
      priority: 'عالي',
      isRead: false,
      reportedDate: DateTime.now().subtract(Duration(hours: 2)),
      problemCategory: 'انقطاع التيار الكهربائي',
      voltageReading: null,
      meterNumber: null,
      transformerCode: null,
    ),
    ElectricityProblem(
      customerName: 'سالم علي',
      customerId: 'CUST-002',
      problemType: 'مشكلة في الفولطية',
      location: 'حي النزهة - شارع الأمير محمد',
      substation: 'محطة تحويل النزهة 132/13.8 ك.ف',
      date: '2024-01-14',
      time: '02:00 م',
      duration: '2 ساعات',
      description: 'انخفاض شديد في الجهد الكهربائي يؤثر على عمل الأجهزة الكهربائية.',
      imageAsset: 'assets/voltage2.jpg',
      status: 'تم المعالجة',
      priority: 'متوسط',
      isRead: true,
      reportedDate: DateTime.now().subtract(Duration(days: 1)),
      problemCategory: 'مشكلة في الفولطية',
      voltageReading: '190 فولت',
      meterNumber: null,
      transformerCode: null,
    ),
  ];

  List<EmployeeProblem> _employeeProblems = [
    EmployeeProblem(
      customerName: 'محمد أحمد',
      area: 'حي العليا',
      location: 'شارع الملك فهد - مبنى رقم ١٢٣',
      date: '2024-01-25',
      time: '10:30 ص',
      description: 'تأخر فني الكهرباء في الوصول لإصلاح العطل لمدة تتجاوز 3 ساعات مع عدم التواصل لتحديد موعد جديد.',
      imageAsset: 'assets/technical1.jpg',
      problemType: 'موظف الصيانة',
      status: 'لم يتم المعالجة',
      isRead: false,
      reportedDate: DateTime.now().subtract(Duration(hours: 8)),
      employeeName: 'فني الكهرباء - أحمد سعيد',
      delayHours: 3,
      employeeDepartment: 'إدارة الصيانة',
    ),
    EmployeeProblem(
      customerName: 'ناصر خالد',
      area: 'حي الروضة',
      location: 'شارع الأمير سلطان - بجوار المركز الصحي',
      date: '2024-01-24',
      time: '02:20 م',
      description: 'موظف الفواتير لم يستجب لطلب تصحيح الخطأ في الفاتورة وتم تجاهل المكالمات الهاتفية المتكررة.',
      imageAsset: 'assets/billing2.jpg',
      problemType: 'موظف الفواتير',
      status: 'قيد المعالجة',
      isRead: true,
      reportedDate: DateTime.now().subtract(Duration(days: 2)),
      employeeName: 'محمد علي - قسم الفواتير',
      delayHours: 2,
      employeeDepartment: 'إدارة الفواتير',
    ),
  ];

  List<AppProblem> _appProblems = [
    AppProblem(
      customerName: 'محمد أحمد',
      area: 'حي العليا',
      location: 'شارع الملك فهد - مبنى رقم ١٢٣',
      date: '2024-01-25',
      time: '10:30 ص',
      description: 'التطبيق يتعطل بشكل متكرر عند محاولة دفع الفاتورة، وعند إعادة التشغيل يفقد البيانات المدخلة.',
      imageAsset: 'assets/app_crash1.jpg',
      problemType: 'تعطل في التطبيق',
      status: 'لم يتم المعالجة',
      isRead: false,
      reportedDate: DateTime.now().subtract(Duration(hours: 10)),
      appVersion: '2.1.0',
      deviceType: 'Android',
    ),
    AppProblem(
      customerName: 'أحمد محمد',
      area: 'حي العليا',
      location: 'شارع الملك فهد - مبنى رقم ١٢٣',
      date: '2024-01-25',
      time: '10:30 ص',
      description: 'فشل في عملية الدفع عبر البطاقة الائتمانية مع ظهور رسالة خطأ غير واضحة.',
      imageAsset: 'assets/payment1.jpg',
      problemType: 'مشكلة في الدفع',
      status: 'لم يتم المعالجة',
      isRead: false,
      reportedDate: DateTime.now().subtract(Duration(hours: 11)),
      appVersion: '2.1.0',
      deviceType: 'iOS',
    ),
    AppProblem(
      customerName: 'سارة عبدالله',
      area: 'حي الروضة',
      location: 'شارع الأمير سلطان - بجوار المركز الصحي',
      date: '2024-01-22',
      time: '10:30 ص',
      description: 'واجهة المستخدم غير واضحة وصعبة الاستخدام، خاصة في قسم دفع الفواتير.',
      imageAsset: 'assets/ui1.jpg',
      problemType: 'واجهة المستخدم',
      status: 'قيد المعالجة',
      isRead: true,
      reportedDate: DateTime.now().subtract(Duration(days: 2)),
      appVersion: '2.0.5',
      deviceType: 'Android',
    ),
  ];

  List<TransformerProblem> _transformerProblems = [
    TransformerProblem(
      customerName: 'علي سعيد',
      location: 'حي الربيع - شارع النخيل',
      area: 'حي الربيع',
      transformerCode: 'TRF-045',
      date: '2024-01-18',
      time: '08:00 ص',
      description: 'ضوضاء عالية من محول الكهرباء مع انبعاث رائحة احتراق.',
      imageAsset: 'assets/transformer1.jpg',
      status: 'لم يتم المعالجة',
      isRead: false,
      reportedDate: DateTime.now().subtract(Duration(hours: 4)),
    ),
  ];

  List<SafetyHazardProblem> _safetyHazardProblems = [
    SafetyHazardProblem(
      customerName: 'فهد العتيبي',
      area: 'حي العليا',
      location: 'شارع الملك عبدالعزيز - مقابل المدرسة الثانوية',
      date: '2024-01-20',
      time: '09:15 ص',
      description: 'أسلاك كهرباء مكشوفة ومتدلية تشكل خطراً على المارة.',
      imageAsset: 'assets/safety1.jpg',
      status: 'لم يتم المعالجة',
      isRead: false,
      reportedDate: DateTime.now().subtract(Duration(hours: 6)),
    ),
  ];

  List<ConnectionProblem> _connectionProblems = [
    ConnectionProblem(
      customerName: 'علي أحمد',
      area: 'حي العليا',
      location: 'شارع الملك فهد - مقابل المسجد',
      date: '2024-01-25',
      time: '08:15 ص',
      description: 'تأخر في توصيل خدمة الكهرباء للمنزل الجديد.',
      imageAsset: 'assets/connection1.jpg',
      problemType: 'تأخر التوصيل',
      status: 'لم يتم المعالجة',
      isRead: false,
      reportedDate: DateTime.now().subtract(Duration(hours: 9)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // تعيين ألوان موحدة للتبويبات
    _tabPrimaryColor = _primaryColor;
    _tabSecondaryColor = _secondaryColor;
    
    _mainTabController = TabController(length: 5, vsync: this);
    _electricityTabController = TabController(length: 4, vsync: this);
    _employeeTabController = TabController(length: 3, vsync: this);
    _appTabController = TabController(length: 4, vsync: this);
    _emergencyTabController = TabController(length: 3, vsync: this);
    _electricitySubTabController = TabController(length: 2, vsync: this);
    _employeeSubTabController = TabController(length: 2, vsync: this);
    _appSubTabController = TabController(length: 2, vsync: this);
    _emergencySubTabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _filterReports();
    _electricityProblems.addAll(_outageProblems);
  _electricityProblems.addAll(_voltageProblems);
  _electricityProblems.addAll(_meterProblems);
  
  _employeeProblems.addAll(_maintenanceEmployeeProblems);
  _employeeProblems.addAll(_billingEmployeeProblems);

    // إضافة مستمعين للتبويبات الفرعية
    _electricitySubTabController.addListener(() {
      setState(() {
        _subTabStatus['electricity'] = _electricitySubTabController.index == 0 ? 'غير مقروءة' : 'مقروءة';
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
    
    _emergencySubTabController.addListener(() {
      setState(() {
        _subTabStatus['emergency'] = _emergencySubTabController.index == 0 ? 'غير مقروءة' : 'مقروءة';
      });
    });
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _electricityTabController.dispose();
    _employeeTabController.dispose();
    _appTabController.dispose();
    _emergencyTabController.dispose();
    _electricitySubTabController.dispose();
    _employeeSubTabController.dispose();
    _appSubTabController.dispose();
    _emergencySubTabController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterReports() {
    final now = DateTime.now();
    _searchController.text.toLowerCase();
    
    setState(() {      
      if (_selectedReportType == 'اليوم') {
      } else if (_selectedReportType == 'الأسبوع') {
        now.subtract(Duration(days: now.weekday - 1));
      } else if (_selectedReportType == 'الشهر') {
      }
    });
  }

  // دوال التحديث لكل شاشة
  Future<void> _refreshElectricityData() async {
    setState(() {
      _isLoadingElectricity = true;
    });
    
    // محاكاة جلب بيانات جديدة من الخادم
    await Future.delayed(Duration(seconds: 2));
    
    // هنا يمكنك إضافة منطق جلب البيانات الجديدة من الـ API
    // مثلاً: إعادة تحميل البيانات من قاعدة البيانات أو الـ API
    
    setState(() {
      _isLoadingElectricity = false;
    });
    
    // عرض رسالة نجاح
    _showSuccessSnackbar('تم تحديث بيانات الكهرباء بنجاح');
  }

  Future<void> _refreshEmployeeData() async {
    setState(() {
      _isLoadingEmployee = true;
    });
    
    await Future.delayed(Duration(seconds: 2));
    
    setState(() {
      _isLoadingEmployee = false;
    });
    
    _showSuccessSnackbar('تم تحديث بيانات الموظفين بنجاح');
  }

  Future<void> _refreshAppData() async {
    setState(() {
      _isLoadingApp = true;
    });
    
    await Future.delayed(Duration(seconds: 2));
    
    setState(() {
      _isLoadingApp = false;
    });
    
    _showSuccessSnackbar('تم تحديث بيانات التطبيق بنجاح');
  }

  Future<void> _refreshEmergencyData() async {
    setState(() {
      _isLoadingEmergency = true;
    });
    
    await Future.delayed(Duration(seconds: 2));
    
    setState(() {
      _isLoadingEmergency = false;
    });
    
    _showSuccessSnackbar('تم تحديث بيانات الطوارئ بنجاح');
  }

  Future<void> _refreshReportsData() async {
    setState(() {
      _isLoadingReports = true;
    });
    
    await Future.delayed(Duration(seconds: 2));
    
    setState(() {
      _isLoadingReports = false;
    });
    
    _showSuccessSnackbar('تم تحديث التقارير بنجاح');
  }

  // دالة موحدة لبناء تبويب رئيسي
  Widget _buildMainTab(String text, IconData icon, int index, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [_tabPrimaryColor, _tabSecondaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? Colors.white : _tabPrimaryColor,
          ),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : _tabPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // دالة موحدة لبناء تبويب فرعي
 Widget _buildSubTab({
  required String text,
  required int count,
  required int tabIndex,
  required int currentIndex,
  required bool isDarkMode,
  required TabController controller,
}) {
  bool isSelected = currentIndex == tabIndex;
  
  return Expanded(
    child: GestureDetector(
      onTap: () {
        controller.animateTo(tabIndex);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? _tabPrimaryColor : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected 
                      ? (isDarkMode ? Colors.white : _tabPrimaryColor)
                      : (isDarkMode ? Colors.white70 : Colors.grey[600]),
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? _tabPrimaryColor 
                      : (isDarkMode ? Colors.white24 : Colors.grey[300]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected 
                        ? Colors.white 
                        : (isDarkMode ? Colors.white70 : Colors.grey[700]),
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
// استبدل دالة _filterProblemsByReadStatus بهذا الكود المبسط
List<dynamic> _filterProblemsByReadStatus(List<dynamic> problems, String tabType) {
  bool showUnread = _subTabStatus[tabType] == 'غير مقروءة';
  
  if (showUnread) {
    return problems.where((p) {
      if (p is ElectricityProblem) return !p.isRead;
      if (p is EmployeeProblem) return !p.isRead;
      if (p is AppProblem) return !p.isRead;
      if (p is EmergencyReport) return !p.isRead;
      return false;
    }).toList();
  } else {
    return problems.where((p) {
      if (p is ElectricityProblem) return p.isRead;
      if (p is EmployeeProblem) return p.isRead;
      if (p is AppProblem) return p.isRead;
      if (p is EmergencyReport) return p.isRead;
      return false;
    }).toList();
  }
}
  // دالة لتحديث حالة القراءة
  void _markAsRead(dynamic problem) {
  print('=== بداية تحديث حالة البلاغ ===');
  print('نوع المشكلة: ${problem.runtimeType}');
  
  setState(() {
    if (problem is ElectricityProblem) {
      print('قبل التحديث - isRead: ${problem.isRead}');
      final index = _electricityProblems.indexWhere((p) => 
          p.customerId == problem.customerId && 
          p.reportedDate == problem.reportedDate);
      if (index != -1) {
        print('تم العثور على البلاغ في index: $index');
        _electricityProblems[index] = _electricityProblems[index].copyWith(isRead: true);
        print('بعد التحديث - isRead: ${_electricityProblems[index].isRead}');
      } else {
        print('لم يتم العثور على البلاغ!');
      }
    }
  });
  
  print('عدد البلاغات المقروءة بعد التحديث: ${_electricityProblems.where((p) => p.isRead).length}');
  print('عدد البلاغات غير المقروءة بعد التحديث: ${_electricityProblems.where((p) => !p.isRead).length}');
  print('=== نهاية تحديث حالة البلاغ ===');
}
  // دالة لبناء حالة فارغة موحدة
  Widget _buildEmptyContent(bool isDarkMode, bool isUnread) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: isDarkMode ? Colors.white24 : Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              isUnread ? 'لا توجد بلاغات غير مقروءة' : 'لا توجد بلاغات مقروءة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              isUnread 
                  ? 'جميع البلاغات تمت قراءتها' 
                  : 'لم تتم قراءة أي بلاغ بعد',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white54 : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
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
              pw.Text('تقرير نظام الكهرباء', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
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
      final fileName = 'تقرير_الكهرباء_${DateTime.now().millisecondsSinceEpoch}.pdf';
      
      await Share.shareXFiles(
        [
          XFile.fromData(
            pdfBytes,
            name: fileName,
            mimeType: 'application/pdf',
          )
        ],
        subject: 'تقرير الكهرباء - $period',
        text: 'مرفق تقرير بلاغات الكهرباء للفترة $period',
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return RefreshIndicator(
      key: _refreshReportsKey,
      onRefresh: _refreshReportsData,
      color: _tabPrimaryColor,
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoadingReports)
              LinearProgressIndicator(
                color: _tabPrimaryColor,
                backgroundColor: _tabPrimaryColor.withOpacity(0.1),
              ),
            SizedBox(height: 8),
            // تبويبات داخلية (إنشاء التقارير / التقارير الواردة)
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDarkMode ? Colors.white24 : Colors.grey[300]!),
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
            _currentReportTab == 0 
                ? _buildCreateReportSection(isDarkMode)
                : _buildReceivedReportsSection(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildReportInnerTabButton(String title, int tabIndex, bool isDarkMode) {
    bool isSelected = _currentReportTab == tabIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentReportTab = tabIndex;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? _tabPrimaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _tabPrimaryColor : Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : (isDarkMode ? Colors.white : _tabPrimaryColor),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateReportSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    Icon(Icons.filter_alt, color: _tabPrimaryColor, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'فلترة التقارير',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : _textColor(context),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildReportTypeFilter(isDarkMode),
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
            child: _buildReportOptions(isDarkMode),
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
    );
  }

  Widget _buildReceivedReportsSection(bool isDarkMode) {
    // بيانات تجريبية للتقارير الواردة
    final List<Map<String, dynamic>> receivedReports = [
      {
        'id': 'REP-ELEC-2024-001',
        'title': 'تقرير بلاغات الكهرباء الشهري',
        'sender': 'قسم البلاغات',
        'date': DateTime.now().subtract(Duration(days: 2)),
        'type': 'شهري',
        'size': '1.8 MB',
        'status': 'مستلم',
        'fileType': 'PDF',
        'area': 'المنطقة الشرقية',
      },
      {
        'id': 'REP-ELEC-2024-002',
        'title': 'تقرير بلاغات الموظفين الأسبوعي',
        'sender': 'فرع بغداد',
        'date': DateTime.now().subtract(Duration(days: 5)),
        'type': 'أسبوعي',
        'size': '850 KB',
        'status': 'مستلم',
        'fileType': 'PDF',
        'area': 'حي السلام',
      },
      {
        'id': 'REP-ELEC-2024-003',
        'title': 'تقرير بلاغات الطوارئ',
        'sender': 'غرفة العمليات',
        'date': DateTime.now().subtract(Duration(days: 1)),
        'type': 'يومي',
        'size': '650 KB',
        'status': 'غير مقروء',
        'fileType': 'PDF',
        'area': 'جميع المناطق',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التقارير المستلمة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : _textColor(context),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'عرض وإدارة جميع التقارير التي تم استلامها',
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : _textSecondaryColor(context),
          ),
        ),
        const SizedBox(height: 20),
        
        // إحصائيات سريعة
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF1E1E1E) : _lightColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDarkMode ? Colors.white24 : Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    receivedReports.length.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _tabPrimaryColor,
                    ),
                  ),
                  Text(
                    'إجمالي التقارير',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    receivedReports.where((r) => r['status'] == 'غير مقروء').length.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _warningColor,
                    ),
                  ),
                  Text(
                    'غير مقروء',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '8.5 MB',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _successColor,
                    ),
                  ),
                  Text(
                    'الحجم الإجمالي',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
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
        ...receivedReports.map((report) => _buildReceivedReportCard(report, isDarkMode)),
      ],
    );
  }

  Widget _buildReceivedReportCard(Map<String, dynamic> report, bool isDarkMode) {
    bool isUnread = report['status'] == 'غير مقروء';
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        border: Border.all(color: isDarkMode ? Colors.white24 : Colors.grey[200]!),
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
            color: _tabPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.picture_as_pdf_rounded,
            color: _tabPrimaryColor,
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
                  color: isDarkMode ? Colors.white : _textColor(context),
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
                color: isDarkMode ? Colors.white70 : _textSecondaryColor(context),
              ),
            ),
            SizedBox(height: 2),
            Row(
              children: [
                Text(
                  '${DateFormat('yyyy-MM-dd').format(report['date'])} • ${report['type']} • ${report['size']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white70 : _textSecondaryColor(context),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded, color: isDarkMode ? Colors.white70 : _textSecondaryColor(context)),
          onSelected: (value) {
            _handleReportAction(value, report);
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility_rounded, size: 18, color: _tabPrimaryColor),
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
                  Icon(Icons.share_rounded, size: 18, color: _accentColor),
                  SizedBox(width: 8),
                  Text('مشاركة'),
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

  void _handleReportAction(String action, Map<String, dynamic> report) {
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
    }
  }

  void _viewReceivedReport(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.picture_as_pdf_rounded, color: _tabPrimaryColor),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                report['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _tabPrimaryColor,
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
              _buildReportDetailRow('المنطقة:', report['area']),
              _buildReportDetailRow('الحجم:', report['size']),
              _buildReportDetailRow('صيغة الملف:', report['fileType']),
              _buildReportDetailRow('التاريخ:', DateFormat('yyyy-MM-dd HH:mm').format(report['date'])),
              _buildReportDetailRow('الحالة:', report['status']),
              SizedBox(height: 16),
              Text(
                'ملخص التقرير:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _tabPrimaryColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'هذا التقرير يحتوي على بيانات البلاغات المستلمة للكهرباء. يشمل بلاغات الكهرباء، بلاغات الموظفين، بلاغات التطبيق، وبلاغات الطوارئ.',
                style: TextStyle(
                  color: Colors.grey[700],
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
              backgroundColor: _tabPrimaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () => _downloadReport(report),
            child: Text('تحميل'),
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
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
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
        backgroundColor: _tabPrimaryColor,
      ),
    );
  }

  Widget _buildReportTypeFilter(bool isDarkMode) {
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
              selectedColor: _tabPrimaryColor,
              backgroundColor: Colors.grey[100],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : _textColor(context),
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _tabPrimaryColor : Colors.grey[300]!),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReportOptions(bool isDarkMode) {
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
            foregroundColor: _tabPrimaryColor,
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: _tabPrimaryColor),
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
                backgroundColor: _tabPrimaryColor.withOpacity(0.1),
                label: Text(DateFormat('yyyy-MM-dd').format(date), style: TextStyle(color: _tabPrimaryColor)),
                deleteIconColor: _tabPrimaryColor,
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
              color: _tabPrimaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _tabPrimaryColor.withOpacity(0.2)),
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
        Icon(icon, size: 16, color: _tabPrimaryColor),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: _tabPrimaryColor,
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
              selectedColor: _tabPrimaryColor,
              backgroundColor: Colors.grey[100],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : _textColor(context),
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _tabPrimaryColor : Colors.grey[300]!),
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
              selectedColor: _tabPrimaryColor,
              backgroundColor: Colors.grey[100],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : _textColor(context),
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _tabPrimaryColor : Colors.grey[300]!),
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
                colors: [_tabPrimaryColor, _tabSecondaryColor],
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
                      'وزارة الكهرباء - نظام التقارير',
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
            colors: [_tabPrimaryColor, Color(0xFF0077C8)],
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
                  colors: [_darkColor, _tabPrimaryColor],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(
                      Icons.electrical_services_rounded,
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
                    "وزارة الكهرباء - إدارة البلاغات",
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
                              color: _tabPrimaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'وزارة الكهرباء',
                                  style: TextStyle(
                                    color: _tabPrimaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'نظام الإبلاغات الذكي',
                                  style: TextStyle(
                                    color: _tabPrimaryColor,
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
    final Color iconColor = isLogout ? Colors.red : _tabPrimaryColor;

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
                : _tabPrimaryColor.withOpacity(0.1),
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
          color: isLogout ? Colors.red : _tabPrimaryColor,
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
            Text('تسجيل الخروج', style: TextStyle(color: Colors.white),),
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
          primaryColor: _tabPrimaryColor,
          secondaryColor: _tabSecondaryColor,
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.electrical_services, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text('نظام الإبلاغات - الكهرباء',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          ],
        ),
        backgroundColor: _tabPrimaryColor,
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
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
                Positioned(
                  right: -4,
                  top: -4,
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
                        fontSize: 8,
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
         
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: TabBar(
              controller: _mainTabController,
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_tabPrimaryColor, _tabSecondaryColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              indicatorWeight: 4,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontSize: 11),
              labelPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
              labelColor: Colors.white,
              unselectedLabelColor: _tabPrimaryColor,
              tabs: [
                Tab(
                  icon: Icon(Icons.report_problem, size: 18),
                  text: 'إبلاغ الكهرباء',
                ),
                Tab(
                  icon: Icon(Icons.person, size: 18),
                  text: 'إبلاغ الموظفين',
                ),
                Tab(
                  icon: Icon(Icons.phone_iphone, size: 18),
                  text: 'مشاكل التطبيق',
                ),
                Tab( 
                  icon: Icon(Icons.emergency, size: 18),
                  text: 'أمر طارئ',
                ),
                Tab(
                  icon: Icon(Icons.summarize, size: 18),
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
                  _buildElectricityReportSection(),
                  _buildEmployeeReportSection(),
                  _buildAppProblemSection(),
                  _buildEmergencyReportSection(),
                  _buildReportsView(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElectricityReportSection() {
    return RefreshIndicator(
      key: _refreshElectricityKey,
      onRefresh: _refreshElectricityData,
      color: _tabPrimaryColor,
      backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode ? Colors.grey[800] : Colors.white,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            if (_isLoadingElectricity)
              LinearProgressIndicator(
                color: _tabPrimaryColor,
                backgroundColor: _tabPrimaryColor.withOpacity(0.1),
              ),
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
                controller: _electricityTabController,
                isScrollable: true,
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_tabPrimaryColor, _tabSecondaryColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: _tabPrimaryColor,
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
                  Tab(text: 'انقطاع التيار الكهربائي'),
                  Tab(text: 'مشكلة في الفولطية'),
                  Tab(text: 'مشكلة في العدادات'),
                  Tab(text: 'أخرى'),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: TabBarView(
                controller: _electricityTabController,
                children: [
                  _buildElectricityOutageContent(),
                  _buildElectricityVoltageContent(),
                  _buildElectricityMeterContent(),
                  _buildElectricityOtherContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElectricityOutageContent() {
    final filteredProblems = _electricityProblems.where((problem) => problem.problemCategory == 'انقطاع التيار الكهربائي').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'electricity');
    
    return _buildElectricityContentTemplate(
      title: 'بلاغات انقطاع التيار الكهربائي',
      icon: Icons.power_off,
      problems: filteredByReadStatus,
    );
  }

  Widget _buildElectricityVoltageContent() {
    final filteredProblems = _electricityProblems.where((problem) => problem.problemCategory == 'مشكلة في الفولطية').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'electricity');
    
    return _buildElectricityContentTemplate(
      title: 'بلاغات مشاكل الفولطية',
      icon: Icons.bolt,
      problems: filteredByReadStatus,
    );
  }

  Widget _buildElectricityMeterContent() {
    final filteredProblems = _electricityProblems.where((problem) => problem.problemCategory == 'مشكلة في العدادات').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'electricity');
    
    return _buildElectricityContentTemplate(
      title: 'بلاغات مشاكل العدادات',
      icon: Icons.speed,
      problems: filteredByReadStatus,
    );
  }

  Widget _buildElectricityOtherContent() {
    final filteredProblems = _electricityProblems.where((problem) => problem.problemCategory == 'أخرى').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'electricity');
    
    return _buildElectricityContentTemplate(
      title: 'بلاغات أخرى للكهرباء',
      icon: Icons.warning,
      problems: filteredByReadStatus,
    );
  }

  Widget _buildElectricityContentTemplate({
    required String title,
    required IconData icon,
    required List<dynamic> problems,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    int unreadCount = problems.where((p) => !p.isRead).length;
    int readCount = problems.where((p) => p.isRead).length;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          // عنوان القسم
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _tabPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: _tabPrimaryColor, size: 24),
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
                          color: isDarkMode ? Colors.white : _tabPrimaryColor,
                        ),
                      ),
                      Text(
                        'وزارة الكهرباء - إدارة الخدمات',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _tabPrimaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${problems.length} بلاغ',
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
          
          // التبويبات الفرعية (غير مقروءة / مقروءة)
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
              border: Border(
                bottom: BorderSide(color: isDarkMode ? Colors.white24 : Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
_buildSubTab(
  text: 'غير مقروءة',
  count: unreadCount,
  tabIndex: 0,
  currentIndex: _electricitySubTabController.index,
  isDarkMode: isDarkMode,
  controller: _electricitySubTabController,
),              _buildSubTab(
  text: 'مقروءة',
  count: readCount,
  tabIndex: 1,
  currentIndex: _electricitySubTabController.index,
  isDarkMode: isDarkMode,
  controller: _electricitySubTabController,
),            ],
          ),
        ),
        
        SizedBox(height: 8),
        
        // المحتوى
        Expanded(
          child: problems.isEmpty
              ? _buildEmptyContent(isDarkMode, _subTabStatus['electricity'] == 'غير مقروءة')
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: problems.length,
                  itemBuilder: (context, index) {
                    final problem = problems[index];
                    return _buildGenericProblemCard(
                      problem,
                      _tabPrimaryColor,
                      Icons.electrical_services,
                      problem.customerName,
                      problem.substation,
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
    ),
  );
  }

  Widget _buildEmployeeReportSection() {
    return RefreshIndicator(
      key: _refreshEmployeeKey,
      onRefresh: _refreshEmployeeData,
      color: _tabPrimaryColor,
      backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode ? Colors.grey[800] : Colors.white,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            if (_isLoadingEmployee)
              LinearProgressIndicator(
                color: _tabPrimaryColor,
                backgroundColor: _tabPrimaryColor.withOpacity(0.1),
              ),
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
                    colors: [_tabPrimaryColor, _tabSecondaryColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: _tabPrimaryColor,
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
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
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
        ),
      ),
    );
  }

  Widget _buildEmployeeMaintenanceContent() {
    final filteredProblems = _employeeProblems.where((problem) => problem.problemType == 'موظف الصيانة').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'employee');
    
    return _buildEmployeeContentTemplate(
      title: 'بلاغات تقصير موظفي الصيانة',
      icon: Icons.engineering,
      problems: filteredByReadStatus,
    );
  }

  Widget _buildEmployeeBillingContent() {
    final filteredProblems = _employeeProblems.where((problem) => problem.problemType == 'موظف الفواتير').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'employee');
    
    return _buildEmployeeContentTemplate(
      title: 'بلاغات تقصير موظفي الفواتير',
      icon: Icons.receipt_long,
      problems: filteredByReadStatus,
    );
  }

  Widget _buildEmployeeOtherContent() {
    final filteredProblems = _employeeProblems.where((problem) => problem.problemType == 'أخرى').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'employee');
    
    return _buildEmployeeContentTemplate(
      title: 'بلاغات أخرى عن الموظفين',
      icon: Icons.person,
      problems: filteredByReadStatus,
    );
  }

  Widget _buildEmployeeContentTemplate({
    required String title,
    required IconData icon,
    required List<dynamic> problems,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    int unreadCount = problems.where((p) => !p.isRead).length;
    int readCount = problems.where((p) => p.isRead).length;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          // عنوان القسم
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _tabPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: _tabPrimaryColor, size: 24),
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
                          color: isDarkMode ? Colors.white : _tabPrimaryColor,
                        ),
                      ),
                      Text(
                        'وزارة الكهرباء - إدارة الموارد البشرية',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _tabPrimaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${problems.length} بلاغ',
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
          
          // التبويبات الفرعية
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
              border: Border(
                bottom: BorderSide(color: isDarkMode ? Colors.white24 : Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                _buildSubTab(
  text: 'غير مقروءة',
  count: unreadCount,
  tabIndex: 0,
  currentIndex: _appSubTabController.index,
  isDarkMode: isDarkMode,
  controller: _appSubTabController,
),
_buildSubTab(
  text: 'مقروءة',
  count: readCount,
  tabIndex: 1,
  currentIndex: _appSubTabController.index,
  isDarkMode: isDarkMode,
  controller: _appSubTabController,
),
            ],
          ),
        ),
        
        SizedBox(height: 8),
        
        // المحتوى
        Expanded(
          child: problems.isEmpty
              ? _buildEmptyContent(isDarkMode, _subTabStatus['employee'] == 'غير مقروءة')
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: problems.length,
                  itemBuilder: (context, index) {
                    final problem = problems[index];
                    return _buildGenericProblemCard(
                      problem,
                      _tabPrimaryColor,
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
    ),
    );
  }

  Widget _buildAppProblemSection() {
    return RefreshIndicator(
      key: _refreshAppKey,
      onRefresh: _refreshAppData,
      color: _tabPrimaryColor,
      backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode ? Colors.grey[800] : Colors.white,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            if (_isLoadingApp)
              LinearProgressIndicator(
                color: _tabPrimaryColor,
                backgroundColor: _tabPrimaryColor.withOpacity(0.1),
              ),
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
                    colors: [_tabPrimaryColor, _tabSecondaryColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: _tabPrimaryColor,
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
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
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
        ),
      ),
    );
  }

  Widget _buildAppCrashContent() {
    final filteredProblems = _appProblems.where((problem) => problem.problemType == 'تعطل في التطبيق').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'app');
    
    return _buildAppContentTemplate(
      title: 'بلاغات تعطل التطبيق',
      icon: Icons.error_outline,
      problems: filteredByReadStatus,
    );
  }

  Widget _buildAppPaymentContent() {
    final filteredProblems = _appProblems.where((problem) => problem.problemType == 'مشكلة في الدفع').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'app');
    
    return _buildAppContentTemplate(
      title: 'بلاغات مشاكل الدفع',
      icon: Icons.payment,
      problems: filteredByReadStatus,
    );
  }

  Widget _buildAppUIUXContent() {
    final filteredProblems = _appProblems.where((problem) => problem.problemType == 'واجهة المستخدم').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'app');
    
    return _buildAppContentTemplate(
      title: 'بلاغات واجهة المستخدم',
      icon: Icons.phone_iphone,
      problems: filteredByReadStatus,
    );
  }

  Widget _buildAppOtherContent() {
    final filteredProblems = _appProblems.where((problem) => problem.problemType == 'أخرى').toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'app');
    
    return _buildAppContentTemplate(
      title: 'بلاغات أخرى عن التطبيق',
      icon: Icons.apps,
      problems: filteredByReadStatus,
    );
  }

  Widget _buildAppContentTemplate({
    required String title,
    required IconData icon,
    required List<dynamic> problems,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    int unreadCount = problems.where((p) => !p.isRead).length;
    int readCount = problems.where((p) => p.isRead).length;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          // عنوان القسم
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _tabPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: _tabPrimaryColor, size: 24),
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
                          color: isDarkMode ? Colors.white : _tabPrimaryColor,
                        ),
                      ),
                      Text(
                        'وزارة الكهرباء - الدعم الفني',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _tabPrimaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${problems.length} بلاغ',
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
          
          // التبويبات الفرعية
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
              border: Border(
                bottom: BorderSide(color: isDarkMode ? Colors.white24 : Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                _buildSubTab(
  text: 'غير مقروءة',
  count: unreadCount,
  tabIndex: 0,
  currentIndex: _appSubTabController.index,
  isDarkMode: isDarkMode,
  controller: _appSubTabController,
),
_buildSubTab(
  text: 'مقروءة',
  count: readCount,
  tabIndex: 1,
  currentIndex: _appSubTabController.index,
  isDarkMode: isDarkMode,
  controller: _appSubTabController,
),
            ],
          ),
        ),
        
        SizedBox(height: 8),
        
        // المحتوى
        Expanded(
          child: problems.isEmpty
              ? _buildEmptyContent(isDarkMode, _subTabStatus['app'] == 'غير مقروءة')
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: problems.length,
                  itemBuilder: (context, index) {
                    final problem = problems[index];
                    return _buildGenericProblemCard(
                      problem,
                      _tabPrimaryColor,
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
    ),
    );
  }

  Widget _buildEmergencyReportSection() {
    return RefreshIndicator(
      key: _refreshEmergencyKey,
      onRefresh: _refreshEmergencyData,
      color: _tabPrimaryColor,
      backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode ? Colors.grey[800] : Colors.white,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            if (_isLoadingEmergency)
              LinearProgressIndicator(
                color: _tabPrimaryColor,
                backgroundColor: _tabPrimaryColor.withOpacity(0.1),
              ),
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
                controller: _emergencyTabController,
                isScrollable: true,
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_tabPrimaryColor, _tabSecondaryColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: _tabPrimaryColor,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 11,
                ),
                padding: EdgeInsets.zero,
                labelPadding: EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                indicatorPadding: EdgeInsets.zero,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(text: 'حوادث كهربائية'),
                  Tab(text: 'حرائق'),
                  Tab(text: 'أخرى'),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: TabBarView(
                controller: _emergencyTabController,
                children: [
                  _buildElectricalAccidentsContent(),
                  _buildFireEmergenciesContent(),
                  _buildOtherEmergenciesContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElectricalAccidentsContent() {
    final filteredProblems = _emergencyReports.where((problem) => 
        problem.emergencyType.contains('كهربائي')).toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'emergency');
    
    return _buildEmergencyContentTemplate(
      title: 'بلاغات الحوادث الكهربائية',
      icon: Icons.electrical_services,
      problems: filteredByReadStatus,
    );
  }

  Widget _buildFireEmergenciesContent() {
    final filteredProblems = _emergencyReports.where((problem) => 
        problem.emergencyType.contains('حريق')).toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'emergency');
    
    return _buildEmergencyContentTemplate(
      title: 'بلاغات الحرائق الكهربائية',
      icon: Icons.local_fire_department,
      problems: filteredByReadStatus,
    );
  }

  Widget _buildOtherEmergenciesContent() {
    final filteredProblems = _emergencyReports.where((problem) => 
        !problem.emergencyType.contains('كهربائي') && 
        !problem.emergencyType.contains('حريق')).toList();
    final filteredByReadStatus = _filterProblemsByReadStatus(filteredProblems, 'emergency');
    
    return _buildEmergencyContentTemplate(
      title: 'بلاغات طارئة أخرى',
      icon: Icons.warning,
      problems: filteredByReadStatus,
    );
  }

  Widget _buildEmergencyContentTemplate({
    required String title,
    required IconData icon,
    required List<dynamic> problems,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    int unreadCount = problems.where((p) => !p.isRead).length;
    int readCount = problems.where((p) => p.isRead).length;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          // عنوان القسم
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _tabPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: _tabPrimaryColor, size: 24),
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
                          color: isDarkMode ? Colors.white : _tabPrimaryColor,
                        ),
                      ),
                      Text(
                        'وزارة الكهرباء - الطوارئ',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _tabPrimaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${problems.length} بلاغ',
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
          
          // التبويبات الفرعية
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
              border: Border(
                bottom: BorderSide(color: isDarkMode ? Colors.white24 : Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                _buildSubTab(
  text: 'غير مقروءة',
  count: unreadCount,
  tabIndex: 0,
  currentIndex: _appSubTabController.index,
  isDarkMode: isDarkMode,
  controller: _appSubTabController,
),
_buildSubTab(
  text: 'مقروءة',
  count: readCount,
  tabIndex: 1,
  currentIndex: _appSubTabController.index,
  isDarkMode: isDarkMode,
  controller: _appSubTabController,
),
            ],
          ),
        ),
        
        SizedBox(height: 8),
        
        // المحتوى
        Expanded(
          child: problems.isEmpty
              ? _buildEmptyContent(isDarkMode, _subTabStatus['emergency'] == 'غير مقروءة')
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: problems.length,
                  itemBuilder: (context, index) {
                    final problem = problems[index];
                    return _buildEmergencyProblemCard(
                      problem,
                      _tabPrimaryColor,
                      () {
                        _markAsRead(problem);
                        _showEmergencyDetails(problem);
                      },
                    );
                  },
                ),
        ),
      ],
    ),
    );
  }

  Widget _buildEmergencyProblemCard(EmergencyReport problem, Color color, VoidCallback onTap) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Card(
      margin: EdgeInsets.only(bottom: 12, left: 4, right: 4),
      elevation: problem.isRead ? 1 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: problem.isRead ? Colors.grey[200]! : _tabPrimaryColor.withOpacity(0.3),
          width: problem.isRead ? 1 : 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس البطاقة
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _tabPrimaryColor.withOpacity(problem.isRead ? 0.05 : 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _tabPrimaryColor.withOpacity(problem.isRead ? 0.1 : 0.3),
                      ),
                    ),
                    child: Icon(
                      Icons.emergency,
                      color: _tabPrimaryColor,
                      size: 22,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          problem.customerName,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: problem.isRead ? FontWeight.normal : FontWeight.bold,
                            color: problem.isRead ? Colors.grey[700] : _tabPrimaryColor,
                          ),
                        ),
                        Text(
                          problem.area,
                          style: TextStyle(
                            fontSize: 11,
                            color: problem.isRead ? Colors.grey[500] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _getEmergencyStatusColor(problem.status).withOpacity(problem.isRead ? 0.05 : 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _getEmergencyStatusColor(problem.status).withOpacity(problem.isRead ? 0.2 : 0.3)
                      ),
                    ),
                    child: Text(
                      problem.status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: problem.isRead ? FontWeight.normal : FontWeight.bold,
                        color: _getEmergencyStatusColor(problem.status),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // شدة الحالة
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getSeverityColor(problem.severity).withOpacity(problem.isRead ? 0.05 : 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning,
                      size: 12,
                      color: _getSeverityColor(problem.severity),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'شدة الحالة: ${problem.severity}',
                      style: TextStyle(
                        fontSize: 11,
                        color: _getSeverityColor(problem.severity),
                        fontWeight: problem.isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8),

              // نوع الطارئ
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _tabPrimaryColor.withOpacity(problem.isRead ? 0.05 : 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  problem.emergencyType,
                  style: TextStyle(
                    fontSize: 11,
                    color: problem.isRead ? _tabPrimaryColor.withOpacity(0.8) : _tabPrimaryColor,
                    fontWeight: problem.isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 8),

              // معلومات إضافية
              Row(
                children: [
                  if (problem.injuredCount > 0)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(problem.isRead ? 0.05 : 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.personal_injury, size: 12, color: Colors.red),
                          SizedBox(width: 4),
                          Text(
                            '${problem.injuredCount} مصاب',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  if (problem.firePresent)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(problem.isRead ? 0.05 : 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_fire_department, size: 12, color: Colors.orange),
                          SizedBox(width: 4),
                          Text(
                            'حريق',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  if (problem.roadClosed)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(problem.isRead ? 0.05 : 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.no_crash, size: 12, color: Colors.blue),
                          SizedBox(width: 4),
                          Text(
                            'طريق مغلق',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              SizedBox(height: 12),

              // الموقع والتاريخ
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      problem.location,
                      style: TextStyle(
                        fontSize: 11,
                        color: problem.isRead ? Colors.grey[500] : Colors.grey[700],
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
                      color: problem.isRead ? Colors.grey[500] : Colors.grey[700],
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.access_time, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    problem.time,
                    style: TextStyle(
                      fontSize: 11,
                      color: problem.isRead ? Colors.grey[500] : Colors.grey[700],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // الوصف
              Text(
                problem.description.length > 120 
                    ? '${problem.description.substring(0, 120)}...' 
                    : problem.description,
                style: TextStyle(
                  fontSize: 12,
                  color: problem.isRead ? Colors.grey[600] : Colors.grey[800],
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 12),

              // صورة البلاغ
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
                        Icons.emergency_rounded,
                        size: 32,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'صورة الطارئ',
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

              // الأزرار
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => _forwardToCivilDefense(problem),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(problem.isRead ? 0.05 : 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red.withOpacity(problem.isRead ? 0.2 : 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_police,
                            size: 14,
                            color: Colors.red,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'إرسال للدفاع المدني',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  if (!problem.isRead)
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
      ),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
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
          color: isRead ? Colors.grey[200]! : _tabPrimaryColor.withOpacity(0.3),
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
                          color: _tabPrimaryColor.withOpacity(isRead ? 0.05 : 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _tabPrimaryColor.withOpacity(isRead ? 0.1 : 0.3),
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: _tabPrimaryColor,
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
                                color: isRead ? Colors.grey[700] : _tabPrimaryColor,
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
                        color: _tabPrimaryColor.withOpacity(isRead ? 0.05 : 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 11,
                          color: isRead ? _tabPrimaryColor.withOpacity(0.8) : _tabPrimaryColor,
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
                        color: _tabPrimaryColor.withOpacity(isRead ? 0.05 : 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        problem.problemType,
                        style: TextStyle(
                          fontSize: 11,
                          color: isRead ? _tabPrimaryColor.withOpacity(0.8) : _tabPrimaryColor,
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

  void _showProblemDetails(dynamic problem) {
    // ignore: unused_local_variable
    String details = '';
    String imageCaption = '';
    
    if (problem is ElectricityProblem) {
      details = '''
🏢 **وزارة الكهرباء - نظام الإبلاغات**
📋 **تفاصيل البلاغ**

👤 **العميل:** ${problem.customerName}
🆔 **رقم العميل:** ${problem.customerId}
🔧 **نوع المشكلة:** ${problem.problemType}
📊 **فئة المشكلة:** ${problem.problemCategory}
🏭 **محطة التحويل:** ${problem.substation}
📍 **الموقع:** ${problem.location}
📅 **التاريخ:** ${problem.date}
⏰ **الوقت:** ${problem.time}
⏳ **المدة:** ${problem.duration}
⚡ **الأولوية:** ${problem.priority}
📌 **الحالة:** ${problem.status}

📝 **وصف المشكلة:**
${problem.description}

📸 **صورة البلاغ:**
تم رفع صورة توضح المشكلة بواسطة العميل

🗺️ **الموقع الدقيق:**
تم تحديد الموقع الجغرافي عبر نظام التتبع

📊 **معلومات إضافية:'''
      + (problem.voltageReading != null ? '\n⚡ **قراءة الفولطية:** ${problem.voltageReading}' : '')
      + (problem.meterNumber != null ? '\n🔢 **رقم العداد:** ${problem.meterNumber}' : '')
      + (problem.transformerCode != null ? '\n🏭 **كود المحول:** ${problem.transformerCode}' : '')
      + '''
      
🚨 **إجراءات الصيانة:**
تم إرسال البلاغ إلى فريق الصيانة للتعامل الفوري
      ''';
      imageCaption = 'صورة توضح مشكلة الكهرباء';
      
    } else if (problem is EmployeeProblem) {
      details = '''
🏢 **وزارة الكهرباء - نظام الإبلاغات**
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
      
    } else if (problem is AppProblem) {
      details = '''
🏢 **وزارة الكهرباء - نظام الإبلاغات**
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
      
    } else if (problem is TransformerProblem) {
      details = '''
🏢 **وزارة الكهرباء - نظام الإبلاغات**
📋 **تفاصيل بلاغ المحول الكهربائي**

👤 **العميل:** ${problem.customerName}
🏭 **كود المحول:** ${problem.transformerCode}
📍 **الموقع:** ${problem.location}
🏘️ **المنطقة:** ${problem.area}
📅 **التاريخ:** ${problem.date}
⏰ **الوقت:** ${problem.time}
📌 **الحالة:** ${problem.status}

📝 **وصف المشكلة:**
${problem.description}

📸 **صورة البلاغ:**
تم رفع صورة توضح مشكلة المحول

⚡ **نوع المشكلة:** تقنية
      ''';
      imageCaption = 'صورة توضح مشكلة المحول الكهربائي';
      
    } else {
      details = '''
🏢 **وزارة الكهرباء - نظام الإبلاغات**
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

⚡ **نوع الخدمة:** خدمة الكهرباء
      ''';
      imageCaption = 'صورة توضح المشكلة المبلغ عنها';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _tabPrimaryColor, width: 1),
        ),
        title: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _tabPrimaryColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(
            children: [
              Icon(Icons.electrical_services, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'تفاصيل البلاغ الكهربائي',
                style: TextStyle(
                  fontSize: 17,
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
                        color: _tabPrimaryColor,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    
                    _buildDetailRow('👤 العميل:', problem.customerName),
                    if (problem is ElectricityProblem)
                      _buildDetailRow('🆔 رقم العميل:', problem.customerId),
                    if (problem is EmployeeProblem && problem.employeeName != null)
                      _buildDetailRow('👨‍💼 الموظف:', problem.employeeName!),
                    if (problem is EmployeeProblem && problem.employeeDepartment != null)
                      _buildDetailRow('🏘️ الإدارة:', problem.employeeDepartment!),
                    if (problem is EmployeeProblem && problem.delayHours != null)
                      _buildDetailRow('⏳ ساعات التأخير:', '${problem.delayHours} ساعة'),
                    if (problem is AppProblem && problem.appVersion != null)
                      _buildDetailRow('📊 إصدار التطبيق:', problem.appVersion!),
                    if (problem is AppProblem && problem.deviceType != null)
                      _buildDetailRow('📟 نوع الجهاز:', problem.deviceType!),
                    if (problem is TransformerProblem)
                      _buildDetailRow('🏭 كود المحول:', problem.transformerCode),
                    if (problem is ElectricityProblem)
                      _buildDetailRow('🔧 نوع المشكلة:', problem.problemType),
                    if (problem is EmployeeProblem)
                      _buildDetailRow('📋 نوع البلاغ:', problem.problemType),
                    if (problem is AppProblem)
                      _buildDetailRow('📱 نوع المشكلة:', problem.problemType),
                    if (problem is ElectricityProblem)
                      _buildDetailRow('📊 فئة المشكلة:', problem.problemCategory),
                    if (problem is ElectricityProblem)
                      _buildDetailRow('🏭 محطة التحويل:', problem.substation),
                    _buildDetailRow('📅 التاريخ:', problem.date),
                    _buildDetailRow('⏰ الوقت:', problem.time),
                    _buildDetailRow('📌 الحالة:', problem.status),
                    if (problem is ElectricityProblem )
                      _buildDetailRow('⏳ المدة:', problem.duration),
                    if (problem is ElectricityProblem )
                      _buildDetailRow('⚡ الأولوية:', problem.priority),
                    
                    SizedBox(height: 12),
                    
                    Text(
                      '📝 وصف المشكلة:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _tabPrimaryColor,
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
              backgroundColor: _tabPrimaryColor,
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
    String prefix = 'ELEC';
    
    if (problem is ElectricityProblem) prefix = 'ELEC';
    if (problem is EmployeeProblem) prefix = 'EMP';
    if (problem is AppProblem) prefix = 'APP';
    if (problem is TransformerProblem) prefix = 'TRF';
    if (problem is SafetyHazardProblem) prefix = 'SAFE';
    if (problem is ConnectionProblem) prefix = 'CONN';
    
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
    if (problem is ElectricityProblem) {
      problemType = problem.problemType;
    } else if (problem is EmployeeProblem) {
      problemType = problem.problemType;
    } else if (problem is AppProblem) {
      problemType = problem.problemType;
    } else if (problem is TransformerProblem) {
      problemType = 'مشكلة في المحول';
    } else if (problem is SafetyHazardProblem) {
      problemType = 'خطر أماني';
    } else if (problem is ConnectionProblem) {
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
              color: _tabPrimaryColor,
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
                    backgroundColor: _tabPrimaryColor,
                    child: Icon(Icons.engineering, color: Colors.white, size: 20),
                  ),
                  title: Text(
                    'الإدارة المختصة',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _tabPrimaryColor,
                    ),
                  ),
                  subtitle: Text(
                    'وزارة الكهرباء - القسم المعني',
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
                backgroundColor: _tabPrimaryColor,
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

  void _showNotificationsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationsScreen(),
      ),
    );
  }

  void _showEmergencyDetails(EmergencyReport emergency) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.red, width: 2),
        ),
        title: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(
            children: [
              Icon(Icons.emergency_rounded, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'بلاغ طارئ - ${emergency.emergencyType}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // صورة البلاغ
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.emergency_rounded,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'صورة الحادثة',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'تم رفعها بواسطة الشاهد',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 16),
              
              // معلومات الطارئ
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEmergencyDetailRow('👤 الشاهد:', emergency.customerName),
                    _buildEmergencyDetailRow('🚨 نوع الطارئ:', emergency.emergencyType),
                    _buildEmergencyDetailRow('📍 موقع الحادثة:', emergency.accidentLocation),
                    _buildEmergencyDetailRow('🏘️ المنطقة:', emergency.area),
                    _buildEmergencyDetailRow('📅 التاريخ:', emergency.date),
                    _buildEmergencyDetailRow('⏰ الوقت:', emergency.time),
                    _buildEmergencyDetailRow('⚡ الشدة:', emergency.severity),
                    _buildEmergencyDetailRow('📌 الحالة:', emergency.status),
                    _buildEmergencyDetailRow('🚑 الإصابات:', '${emergency.injuredCount} مصاب'),
                    _buildEmergencyDetailRow('🔥 حريق:', emergency.firePresent ? 'نعم' : 'لا'),
                    _buildEmergencyDetailRow('🚧 طريق مغلق:', emergency.roadClosed ? 'نعم' : 'لا'),
                  ],
                ),
              ),
              
              SizedBox(height: 16),
              
              // وصف الحادثة
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📝 وصف الحادثة:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      emergency.description,
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
              
              // إجراءات الطوارئ
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🚨 إجراءات الطوارئ المتخذة:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('• تم إخلاء المنطقة من المدنيين', style: TextStyle(fontSize: 11)),
                    Text('• تم فصل التيار الكهربائي عن المنطقة', style: TextStyle(fontSize: 11)),
                    Text('• تم إبلاغ الدفاع المدني (115)', style: TextStyle(fontSize: 11)),
                    Text('• تم إبلاغ الإسعاف (122)', style: TextStyle(fontSize: 11)),
                    Text('• تم تنبيه أقسام الشرطة المجاورة', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _forwardToCivilDefense(emergency);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('إرسال للدفاع المدني'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getEmergencyStatusColor(String status) {
    switch (status) {
      case 'لم يتم المعالجة':
        return Colors.red;
      case 'قيد المعالجة':
        return Colors.orange;
      case 'تم المعالجة':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'حرجة':
        return Colors.red;
      case 'عالية':
        return Colors.orange;
      case 'متوسطة':
        return Colors.yellow[700]!;
      case 'منخفضة':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _forwardToCivilDefense(EmergencyReport emergency) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.red, width: 1),
        ),
        title: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(
            children: [
              Icon(Icons.local_police, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'إرسال للدفاع المدني',
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('سيتم إرسال هذا البلاغ الطارئ إلى:'),
              SizedBox(height: 16),
              Card(
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.local_police, color: Colors.white, size: 20),
                  ),
                  title: Text(
                    'الدفاع المدني - غرفة الطوارئ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  subtitle: Text(
                    'رقم الطوارئ: 115',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Card(
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.local_hospital, color: Colors.white, size: 20),
                  ),
                  title: Text(
                    'الإسعاف',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  subtitle: Text(
                    'رقم الطوارئ: 122',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text('هل تريد إرسال البلاغ الطارئ؟'),
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
              _showEmergencyForwardedMessage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('إرسال فوري'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyForwardedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
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
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.local_police, color: Colors.red, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تم إرسال البلاغ للدفاع المدني',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      'سيتم التعامل مع الحالة فوراً',
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
        duration: Duration(seconds: 4),
      ),
    );
  }
}

// شاشة الإشعارات (نفس الكود بدون تغيير)
class NotificationsScreen extends StatefulWidget {
  static const String routeName = '/notifications';

  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final Color _primaryColor = Color(0xFF0056A4);
  final Color _secondaryColor = Color(0xFF0077C8);
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
  
  final List<Map<String, dynamic>> _allNotifications = [
    {
      'id': '1',
      'type': 'electricity',
      'title': 'انقطاع تيار كهربائي جديد',
      'description': 'بلاغ جديد عن انقطاع التيار في منطقة حي السلام، تم الإبلاغ الساعة 08:30 صباحاً',
      'time': 'منذ 5 دقائق',
      'read': false,
      'category': 'كهرباء',
      'priority': 'عالي',
      'icon': Icons.power_off,
      'color': Color(0xFFD32F2F),
    },
    {
      'id': '2',
      'type': 'employee',
      'title': 'تأخير موظف الصيانة',
      'description': 'مواطن يبلغ عن تأخير موظف الصيانة لمدة 3 ساعات في منطقة حي النزهة',
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
      'title': 'مشكلة في التطبيق',
      'description': 'عميل يبلغ عن تعطل في التطبيق عند دفع الفاتورة، الإصدار 2.1.0',
      'time': 'منذ 30 دقيقة',
      'read': false,
      'category': 'تطبيق',
      'priority': 'عالي',
      'icon': Icons.phone_iphone,
      'color': Color(0xFF1976D2),
    },
    {
      'id': '4',
      'type': 'safety',
      'title': 'خطر أماني',
      'description': 'أسلاك كهرباء مكشوفة في شارع الملك فهد، تشكل خطراً على المارة',
      'time': 'منذ 45 دقيقة',
      'read': false,
      'category': 'أمان',
      'priority': 'عالي',
      'icon': Icons.warning,
      'color': Color(0xFFD32F2F),
    },
    {
      'id': '5',
      'type': 'electricity',
      'title': 'مشكلة في الفولطية',
      'description': 'تم معالجة مشكلة انخفاض الجهد في حي النزهة، تمت الإصلاح الساعة 10:00 صباحاً',
      'time': 'منذ ساعة',
      'read': true,
      'category': 'كهرباء',
      'priority': 'منخفض',
      'icon': Icons.bolt,
      'color': Color(0xFFFF9800),
    },
    {
      'id': '6',
      'type': 'system',
      'title': 'تحديث النظام',
      'description': 'تم تحديث نظام البلاغات إلى الإصدار 2.1.0، تم إضافة ميزات جديدة',
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
      'description': 'تم إنشاء التقرير الأسبوعي لبلاغات الكهرباء، يمكنك تصديره الآن',
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
      'title': 'تحذير عاصفة',
      'description': 'تحذير من عاصفة رعدية قد تؤثر على شبكة الكهرباء في المنطقة الشمالية',
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
      'title': 'دفع فاتورة ناجح',
      'description': 'تم دفع فاتورة المواطن أحمد محمد بقيمة 185,750 دينار',
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
      'description': 'صيانة مجدولة لمحطة التحويل الرئيسية يوم الخميس القادم',
      'time': 'منذ أسبوع',
      'read': true,
      'category': 'صيانة',
      'priority': 'متوسط',
      'icon': Icons.build,
      'color': Color(0xFF607D8B),
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    switch (_selectedTab) {
      case 0:
        return _allNotifications;
      case 1:
        return _allNotifications.where((notification) => !notification['read']).toList();
      case 2:
        return _allNotifications.where((notification) => notification['read']).toList();
      case 3:
        return _allNotifications.where((notification) => notification['type'] == 'system').toList();
      default:
        return _allNotifications;
    }
  }

  int get _unreadCount {
    return _allNotifications.where((notification) => !notification['read']).length;
  }

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
                  backgroundColor: _primaryColor,
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

  void _showNotificationDetails(Map<String, dynamic> notification) {
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
              
              if (notification['type'] == 'electricity') ...[
                SizedBox(height: 16),
                Text('تفاصيل إضافية:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                _buildNotificationDetailRow('نوع المشكلة:', 'انقطاع التيار الكهربائي'),
                _buildNotificationDetailRow('الموقع:', 'حي السلام - شارع الملك فهد'),
                _buildNotificationDetailRow('التاريخ:', DateFormat('yyyy-MM-dd').format(DateTime.now())),
                _buildNotificationDetailRow('الوقت:', '08:30 ص'),
                _buildNotificationDetailRow('الحالة:', 'قيد المعالجة'),
                _buildNotificationDetailRow('رقم البلاغ:', 'ELEC-${notification['id']}'),
              ],
              if (notification['type'] == 'employee') ...[
                SizedBox(height: 16),
                Text('تفاصيل الموظف:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                _buildNotificationDetailRow('اسم الموظف:', 'أحمد سعيد'),
                _buildNotificationDetailRow('القسم:', 'إدارة الصيانة'),
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

          Expanded(
            child: _filteredNotifications.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(Duration(seconds: 1));
                      setState(() {});
                    },
                    color: _primaryColor,
                    backgroundColor: Colors.white,
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
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
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
                        
                        Text(
                          notification['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: _textColor,
                          ),
                        ),
                        
                        SizedBox(height: 4),
                        
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

  Widget _buildEmptyState() {
    IconData icon;
    String title;
    String description;
    
    switch (_selectedTab) {
      case 1:
        icon = Icons.mark_email_read_rounded;
        title = 'لا توجد إشعارات غير مقروءة';
        description = 'جميع الإشعارات قد تمت قراءتها';
        break;
      case 2:
        icon = Icons.mark_email_unread_rounded;
        title = 'لا توجد إشعارات مقروءة';
        description = 'لم تتم قراءة أي إشعار بعد';
        break;
      case 3:
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

// شاشة الإعدادات (نفس الكود بدون تغيير)
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

// كلاسات المشاكل (نفس الكود بدون تغيير)
class ElectricityProblem {
  final String customerName;
  final String customerId;
  final String problemType;
  final String location;
  final String substation;
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
  final String? voltageReading;
  final String? meterNumber;
  final String? transformerCode;

  ElectricityProblem({
    required this.customerName,
    required this.customerId,
    required this.problemType,
    required this.location,
    required this.substation,
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
    this.voltageReading,
    this.meterNumber,
    this.transformerCode,
  });

  ElectricityProblem copyWith({
    String? customerName,
    String? customerId,
    String? problemType,
    String? location,
    String? substation,
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
    String? voltageReading,
    String? meterNumber,
    String? transformerCode,
  }) {
    return ElectricityProblem(
      customerName: customerName ?? this.customerName,
      customerId: customerId ?? this.customerId,
      problemType: problemType ?? this.problemType,
      location: location ?? this.location,
      substation: substation ?? this.substation,
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
      voltageReading: voltageReading ?? this.voltageReading,
      meterNumber: meterNumber ?? this.meterNumber,
      transformerCode: transformerCode ?? this.transformerCode,
    );
  }
}

class EmployeeProblem {
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

  EmployeeProblem({
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

  EmployeeProblem copyWith({
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
    return EmployeeProblem(
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

class AppProblem {
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

  AppProblem({
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

  AppProblem copyWith({
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
    return AppProblem(
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

class TransformerProblem {
  final String customerName;
  final String location;
  final String area;
  final String transformerCode;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String status;
  final bool isRead;
  final DateTime reportedDate;

  TransformerProblem({
    required this.customerName,
    required this.location,
    required this.area,
    required this.transformerCode,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.status,
    required this.isRead,
    required this.reportedDate,
  });

  TransformerProblem copyWith({
    String? customerName,
    String? location,
    String? area,
    String? transformerCode,
    String? date,
    String? time,
    String? description,
    String? imageAsset,
    String? status,
    bool? isRead,
    DateTime? reportedDate,
  }) {
    return TransformerProblem(
      customerName: customerName ?? this.customerName,
      location: location ?? this.location,
      area: area ?? this.area,
      transformerCode: transformerCode ?? this.transformerCode,
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

class SafetyHazardProblem {
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

  SafetyHazardProblem({
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

  SafetyHazardProblem copyWith({
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
    return SafetyHazardProblem(
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

class ConnectionProblem {
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

  ConnectionProblem({
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

  ConnectionProblem copyWith({
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
    return ConnectionProblem(
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

class EmergencyReport {
  final String customerName;
  final String location;
  final String area;
  final String emergencyType;
  final String accidentLocation;
  final String date;
  final String time;
  final String description;
  final String imageAsset;
  final String status;
  final bool isRead;
  final DateTime reportedDate;
  final String severity;
  final int injuredCount;
  final bool firePresent;
  final bool roadClosed;

  EmergencyReport({
    required this.customerName,
    required this.location,
    required this.area,
    required this.emergencyType,
    required this.accidentLocation,
    required this.date,
    required this.time,
    required this.description,
    required this.imageAsset,
    required this.status,
    required this.isRead,
    required this.reportedDate,
    required this.severity,
    required this.injuredCount,
    required this.firePresent,
    required this.roadClosed,
  });

  EmergencyReport copyWith({
    String? customerName,
    String? location,
    String? area,
    String? emergencyType,
    String? accidentLocation,
    String? date,
    String? time,
    String? description,
    String? imageAsset,
    String? status,
    bool? isRead,
    DateTime? reportedDate,
    String? severity,
    int? injuredCount,
    bool? firePresent,
    bool? roadClosed,
  }) {
    return EmergencyReport(
      customerName: customerName ?? this.customerName,
      location: location ?? this.location,
      area: area ?? this.area,
      emergencyType: emergencyType ?? this.emergencyType,
      accidentLocation: accidentLocation ?? this.accidentLocation,
      date: date ?? this.date,
      time: time ?? this.time,
      description: description ?? this.description,
      imageAsset: imageAsset ?? this.imageAsset,
      status: status ?? this.status,
      isRead: isRead ?? this.isRead,
      reportedDate: reportedDate ?? this.reportedDate,
      severity: severity ?? this.severity,
      injuredCount: injuredCount ?? this.injuredCount,
      firePresent: firePresent ?? this.firePresent,
      roadClosed: roadClosed ?? this.roadClosed,
    );
  }
}