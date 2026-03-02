import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mang_mu/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/screens/employee/Shared Services/esignin_screen.dart';

class SystemSupervisorScreen extends StatefulWidget {
  const SystemSupervisorScreen({super.key});

  @override
  State<SystemSupervisorScreen> createState() => _SystemSupervisorScreenState();
}

class _SystemSupervisorScreenState extends State<SystemSupervisorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _billFilter = 'الكل';
  String _selectedReportType = 'يومي';
  int _selectedMaintenanceTab = 0;
  String _maintenanceReportFilter = 'الكل';
  int _selectedBillsReportTab = 0; 
  String _billsReportFilter = 'الكل';
  int _selectedConsumptionTab = 0; 
DateTime _selectedDate = DateTime.now();
String _selectedMonth = 'مارس 2024';
String _selectedYear = '2024';
List<String> _availableYears = ['2024', '2023', '2022', '2021', '2020'];

  // متغيرات التحكم في التحديث
  final RefreshController _billsRefreshController = RefreshController();
  final RefreshController _consumptionRefreshController = RefreshController();
  final RefreshController _maintenanceRefreshController = RefreshController();
  final RefreshController _reportsRefreshController = RefreshController();
  bool _isRefreshing = false;

  final Color _primaryColor = Color.fromARGB(255, 46, 30, 169);
  final Color _secondaryColor = Color(0xFFD4AF37);
  final Color _accentColor = Color(0xFF8D6E63);
  final Color _successColor = Color(0xFF2E7D32);
  final Color _warningColor = Color(0xFFF57C00);
  final Color _errorColor = Color(0xFFD32F2F);
  final Color _darkPrimaryColor = Color(0xFF1B5E20);
  
  final List<String> _reportTypes = ['يومي', 'أسبوعي', 'شهري'];
  
// بيانات طلبات التقارير للفواتير
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

// بيانات التقارير الواردة للفواتير
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

  final List<Map<String, dynamic>> bills = [
    {
      'id': 'INV-2024-001',
      'citizenName': 'أحمد محمد',
      'amount': 185.75,
      'amountIQD': 91018,
      'dueDate': DateTime.now().add(Duration(days: 5)),
      'status': 'unpaid',
      'consumption': '250 ك.و.س',
      'billingDate': DateTime.now().subtract(Duration(days: 5)),
      'paymentMethod': 'تحويل بنكي',
      'cardNumber': '1234-****-****-5678',
      'transferTo': 'حساب الرافدين - وزارة الكهرباء',
      'bankAccount': '123456789012',
      'isPaying': true,
      'transfers': [
        {'date': '2024-03-01', 'amount': 45000, 'method': 'تحويل بنكي'},
        {'date': '2024-02-01', 'amount': 46018, 'method': 'زين كاش'}
      ]
    },
    {
      'id': 'INV-2024-002',
      'citizenName': 'فاطمة علي',
      'amount': 230.50,
      'amountIQD': 112945,
      'dueDate': DateTime.now().subtract(Duration(days: 3)),
      'status': 'overdue',
      'consumption': '320 ك.و.س',
      'billingDate': DateTime.now().subtract(Duration(days: 10)),
      'paymentMethod': 'بطاقة ائتمان',
      'cardNumber': '4321-****-****-9876',
      'transferTo': 'حساب وزارة الكهرباء المركزي',
      'bankAccount': 'IQ100100100100100100',
      'isPaying': false,
      'transfers': []
    },
    {
      'id': 'INV-2024-003',
      'citizenName': 'خالد إبراهيم',
      'amount': 315.25,
      'amountIQD': 154473,
      'dueDate': DateTime.now().add(Duration(days: 2)),
      'status': 'unpaid',
      'consumption': '280 ك.و.س',
      'billingDate': DateTime.now().subtract(Duration(days: 7)),
      'paymentMethod': 'زين كاش',
      'phoneNumber': '0780-123-4567',
      'transferTo': 'حساب زين كاش الوزاري',
      'bankAccount': '9647901234567',
      'isPaying': true,
      'transfers': [
        {'date': '2024-03-10', 'amount': 80000, 'method': 'زين كاش'},
        {'date': '2024-02-10', 'amount': 74473, 'method': 'تحويل بنكي'}
      ]
    },
    {
      'id': 'INV-2024-004',
      'citizenName': 'أحمد محمد',
      'amount': 195.50,
      'amountIQD': 95795,
      'dueDate': DateTime.now().subtract(Duration(days: 1)),
      'status': 'paid',
      'consumption': '260 ك.و.س',
      'billingDate': DateTime.now().subtract(Duration(days: 30)),
      'paymentMethod': 'تحويل بنكي',
      'cardNumber': '9876-****-****-4321',
      'transferTo': 'حساب الرشيد - وزارة الكهرباء',
      'bankAccount': '987654321098',
      'isPaying': true,
      'transfers': [
        {'date': '2024-03-15', 'amount': 95795, 'method': 'تحويل بنكي'}
      ],
    },
  ];

  final List<Map<String, dynamic>> _maintenanceReportRequests = [
    {
      'id': 'MNT-REQ-001',
      'type': 'يومي',
      'title': 'طلب تقرير صيانة يومي',
      'requestedBy': 'مسؤول الجودة',
      'date': '2024-03-20',
      'status': 'معلق',
      'priority': 'عادي',
      'dueDate': '2024-03-21',
      'description': 'تقرير مفصل عن أعمال الصيانة اليومية لجميع الفنيين',
    },
    {
      'id': 'MNT-REQ-002',
      'type': 'أسبوعي',
      'title': 'طلب تقرير المهام المتأخرة',
      'requestedBy': 'مدير التشغيل',
      'date': '2024-03-19',
      'status': 'قيد التنفيذ',
      'priority': 'عالي',
      'dueDate': '2024-03-22',
      'description': 'تقرير عن جميع المهام المتأخرة وأسباب التأخير',
    },
    {
      'id': 'MNT-REQ-003',
      'type': 'شهري',
      'title': 'طلب تحليل أداء الفنيين',
      'requestedBy': 'المدير العام',
      'date': '2024-03-15',
      'status': 'مكتمل',
      'priority': 'عالي',
      'dueDate': '2024-03-25',
      'description': 'تحليل شامل لأداء الفنيين ومعدل الإنجاز الشهري',
    },
  ];

  final List<Map<String, dynamic>> _maintenanceReceivedReports = [
    {
      'id': 'MNT-REP-001',
      'title': 'تقرير الصيانة اليومي - 20 مارس',
      'type': 'يومي',
      'sender': 'حسن عبدالله - رئيس الفنيين',
      'date': '2024-03-20',
      'time': '05:30 م',
      'status': 'جديد',
      'read': false,
      'priority': 'متوسط',
      'size': '1.8 MB',
      'format': 'PDF',
      'summary': 'تقرير مفصل عن أعمال الصيانة اليومية مع صور للإصلاحات',
      'attachments': 4,
    },
    {
      'id': 'MNT-REP-002',
      'title': 'تحليل المهام المتأخرة الأسبوعي',
      'type': 'أسبوعي',
      'sender': 'علي محمد - مشرف الصيانة',
      'date': '2024-03-19',
      'time': '03:45 م',
      'status': 'مكتمل',
      'read': true,
      'priority': 'عالي',
      'size': '2.5 MB',
      'format': 'PDF',
      'summary': 'تحليل شامل للمهام المتأخرة مع أسباب وحلول مقترحة',
      'attachments': 3,
    },
    {
      'id': 'MNT-REP-003',
      'title': 'تقرير أداء الفنيين الشهري - فبراير 2024',
      'type': 'شهري',
      'sender': 'محمد كريم - مدير الصيانة',
      'date': '2024-03-05',
      'time': '10:00 ص',
      'status': 'مكتمل',
      'read': true,
      'priority': 'عالي',
      'size': '3.2 MB',
      'format': 'PDF',
      'summary': 'تقرير كامل عن أداء الفنيين ومعدلات الإنجاز الشهرية',
      'attachments': 6,
    },
    {
      'id': 'MNT-REP-004',
      'title': 'تقرير صيانة المحطات الرئيسية',
      'type': 'خاص',
      'sender': 'خالد أحمد - فني متخصص',
      'date': '2024-03-18',
      'time': '01:30 م',
      'status': 'جديد',
      'read': false,
      'priority': 'عالي',
      'size': '4.1 MB',
      'format': 'PDF',
      'summary': 'تقرير مفصل عن صيانة المحطات الرئيسية مع توصيات هامة',
      'attachments': 8,
    },
  ];

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'bank_transfer',
      'name': 'التحويل البنكي',
      'icon': Icons.account_balance_rounded,
      'color': Colors.blue,
      'totalAmount': 186813,
      'totalTransfers': 2,
      'bankAccounts': [
        {
          'bankName': 'الرافدين',
          'accountNumber': '123456789012',
          'accountName': 'وزارة الكهرباء - فواتير'
        },
        {
          'bankName': 'الرشيد',
          'accountNumber': '987654321098',
          'accountName': 'وزارة الكهرباء - خدمات'
        }
      ]
    },
    {
      'id': 'credit_card',
      'name': 'بطاقة ائتمان',
      'icon': Icons.credit_card_rounded,
      'color': Colors.green,
      'totalAmount': 247418,
      'totalTransfers': 2,
      'bankAccounts': [
        {
          'bankName': 'البنك المركزي العراقي',
          'accountNumber': 'IQ100100100100100100',
          'accountName': 'وزارة الكهرباء - الإيرادات'
        }
      ]
    },
    {
      'id': 'zain_cash',
      'name': 'زين كاش',
      'icon': Icons.phone_iphone_rounded,
      'color': Colors.purple,
      'totalAmount': 154473,
      'totalTransfers': 1,
      'bankAccounts': [
        {
          'bankName': 'زين كاش',
          'accountNumber': '9647901234567',
          'accountName': 'وزارة الكهرباء'
        }
      ]
    },
  ];

  final List<Map<String, dynamic>> reports = [
    {
      'id': 'RPT-001',
      'title': 'تقرير الفواتير المدفوعة',
      'type': 'مالي',
      'period': 'شهري',
      'date': 'مارس 2024',
      'totalAmount': 230543,
      'totalBills': 2
    },
    {
      'id': 'RPT-002',
      'title': 'تقرير الفواتير المتأخرة',
      'type': 'مالي',
      'period': 'شهري',
      'date': 'مارس 2024',
      'totalAmount': 205555,
      'totalBills': 2
    },
    {
      'id': 'RPT-003',
      'title': 'تقرير طرق الدفع',
      'type': 'تحليلي',
      'period': 'ربع سنوي',
      'date': 'الربع الأول 2024',
      'totalAmount': 723454,
      'totalBills': 6
    },
  ];

  final List<Map<String, dynamic>> citizens = [
    {
      'name': 'أحمد محمد',
      'totalBills': 2,
      'totalAmount': 186813,
      'lastPayment': '2024-03-15',
      'isPaying': true,
    },
    {
      'name': 'فاطمة علي',
      'totalBills': 1,
      'totalAmount': 112945,
      'lastPayment': '2024-02-20',
      'isPaying': false,
    },
    {
      'name': 'خالد إبراهيم',
      'totalBills': 1,
      'totalAmount': 154473,
      'lastPayment': '2024-02-10',
      'isPaying': true,
    },
    {
      'name': 'سارة عبدالله',
      'totalBills': 1,
      'totalAmount': 134750,
      'lastPayment': '2024-03-18',
      'isPaying': true,
    },
  ];

  final List<String> _filters = ['الكل', 'مدفوعة', 'غير مدفوعة', 'متأخرة'];
  int _currentTabInBills = 0;

  final List<Map<String, dynamic>> _maintenanceTasks = [
    {
      'id': 'MNT-001',
      'title': 'صيانة المحول الرئيسي',
      'technician': 'حسن عبدالله',
      'location': 'المنطقة الشمالية - محطة 5',
      'status': 'قيد التنفيذ',
      'priority': 'عالي',
      'startDate': '2024-03-20',
      'estimatedTime': '4 ساعات',
      'description': 'صيانة دورية للمحول الرئيسي وتغيير الزيت',
    },
    {
      'id': 'MNT-002',
      'title': 'إصلاح خط الكهرباء',
      'technician': 'علي محمد',
      'location': 'المنطقة الجنوبية - شارع الثورة',
      'status': 'معلقة',
      'priority': 'عاجل',
      'startDate': '2024-03-19',
      'estimatedTime': '6 ساعات',
      'description': 'إصلاح خط كهرباء تالف بسبب العوامل الجوية',
    },
    {
      'id': 'MNT-003',
      'title': 'فحص العدادات',
      'technician': 'محمد كريم',
      'location': 'المنطقة الشرقية - حي الأندلس',
      'status': 'مكتملة',
      'priority': 'متوسط',
      'startDate': '2024-03-18',
      'endDate': '2024-03-18',
      'duration': '3 ساعات',
      'rating': 4.5,
    },
    {
      'id': 'MNT-004',
      'title': 'تركيب محول جديد',
      'technician': 'خالد أحمد',
      'location': 'المنطقة الغربية - محطة 2',
      'status': 'متأخرة',
      'priority': 'عالي',
      'startDate': '2024-03-15',
      'estimatedTime': '8 ساعات',
      'delayReason': 'انتظار قطع الغيار',
      'description': 'تركيب محول جديد لزيادة السعة',
    },
    {
      'id': 'MNT-005',
      'title': 'إصلاح كابلات التوزيع',
      'technician': 'أحمد علي',
      'location': 'المنطقة الوسطى - شارع الصناعة',
      'status': 'قيد التنفيذ',
      'priority': 'متوسط',
      'startDate': '2024-03-21',
      'estimatedTime': '5 ساعات',
      'description': 'إصلاح كابلات توزيع تالفة',
    },
  ];

  int _maintenanceCurrentTab = 0;

  @override
void initState() {
  super.initState();
  _tabController = TabController(length: 4, vsync: this);
  
  // التأكد من أن _selectedReportType له قيمة صحيحة
  if (!_reportTypes.contains(_selectedReportType)) {
    _selectedReportType = _reportTypes.first;
  }
}

  @override
  void dispose() {
    _tabController.dispose();
    _billsRefreshController.dispose();
    _consumptionRefreshController.dispose();
    _maintenanceRefreshController.dispose();
    _reportsRefreshController.dispose();
    super.dispose();
  }

  // دوال التحديث
  Future<void> _refreshBillsTab() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(Duration(seconds: 1)); // محاكاة تحميل البيانات
    setState(() {
      // تحديث بيانات الفواتير هنا
      _billFilter = 'الكل';
      _isRefreshing = false;
    });
    _billsRefreshController.refreshCompleted();
  }

  Future<void> _refreshConsumptionTab() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // تحديث بيانات الاستهلاك هنا
      _selectedDate = DateTime.now();
      _selectedMonth = 'مارس 2024';
      _selectedYear = '2024';
      _isRefreshing = false;
    });
    _consumptionRefreshController.refreshCompleted();
  }

  Future<void> _refreshMaintenanceTab() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // تحديث بيانات الصيانة هنا
      _selectedMaintenanceTab = 0;
      _maintenanceReportFilter = 'الكل';
      _maintenanceCurrentTab = 0;
      _isRefreshing = false;
    });
    _maintenanceRefreshController.refreshCompleted();
  }

  Future<void> _refreshReportsTab() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // تحديث بيانات البلاغات هنا
      _selectedBillsReportTab = 0;
      _billsReportFilter = 'الكل';
      _isRefreshing = false;
    });
    _reportsRefreshController.refreshCompleted();
  }

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

  Color _textColor() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.isDarkMode ? Colors.white : Color(0xFF212121);
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
              child: Icon(Icons.bolt_rounded, color: _primaryColor, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'مسؤول محطة الكهرباء',
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
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: _secondaryColor,
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SupervisorNotificationsScreen()),
      );
    },
  ),
],

        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
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
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(icon: Icon(Icons.receipt_long_rounded, size: 22), text: 'الفواتير'),
                Tab(icon: Icon(Icons.analytics_rounded, size: 22), text: 'الاستهلاك'),
                Tab(icon: Icon(Icons.engineering_rounded, size: 22), text: 'الصيانة'),
                Tab(icon: Icon(Icons.report_problem_rounded, size: 22), text: 'البلاغات'),
              ],
            ),
          ),
        ),
      ),
      drawer: _buildSystemSupervisorDrawer(context, isDarkMode),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBillsTab(isDarkMode),
          _buildConsumptionTab(isDarkMode),
          _buildMaintenanceTab(isDarkMode),
          _buildReportsTab(isDarkMode), 
        ],
      ),
    );
  }

  Widget _buildBillsTab(bool isDarkMode) {
    return RefreshIndicator(
      key: const Key('bills_refresh'),
      onRefresh: _refreshBillsTab,
      color: _primaryColor,
      backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0)),
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
            SizedBox(height: 20),
            if (_currentTabInBills == 0) _buildBillsContent(isDarkMode),
            if (_currentTabInBills == 1) _buildPaymentMethodsContent(isDarkMode),
            if (_currentTabInBills == 2) _buildCitizensContent(isDarkMode),
            if (_currentTabInBills == 3) _buildReportsContent(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildInnerTabButton(String title, int index, bool isDarkMode) {
    bool isSelected = _currentTabInBills == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentTabInBills = index),
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
        SizedBox(height: 20),
        _buildBillsFilter(),
        SizedBox(height: 20),
        Text(
          'الفواتير الحالية',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryColor),
        ),
        SizedBox(height: 12),
        ...filteredBills.map((bill) => _buildBillCard(bill)).toList(),
      ],
    );
  }

  Widget _buildPaymentMethodsContent(isDarkMode) {
    double totalAmount = paymentMethods.fold(0.0, (sum, method) => sum + (method['totalAmount'] ?? 0));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0)),
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
        SizedBox(height: 20),
        Text('طرق الدفع المتاحة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryColor)),
        SizedBox(height: 12),
        ...paymentMethods.map((method) => _buildPaymentMethodCard(method)).toList(),
      ],
    );
  }

  Widget _buildCitizensContent(isDarkMode) {
    double totalAmount = citizens.fold(0.0, (sum, citizen) => sum + (citizen['totalAmount'] as int).toDouble());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0)),
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
        SizedBox(height: 20),
        Text('سجل المواطنين', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryColor)),
        SizedBox(height: 12),
        ...citizens.map((citizen) => _buildCitizenCard(citizen)).toList(),
      ],
    );
  }
Widget _buildReportsContent(isDarkMode) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 50,
        decoration: BoxDecoration(
          color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            _buildBillsReportTabButton('طلبات التقارير', 0),
            _buildBillsReportTabButton('التقارير الواردة', 1),
          ],
        ),
      ),
      SizedBox(height: 16),
      
      _selectedBillsReportTab == 0 
          ? _buildBillsReportRequestsSection() 
          : _buildBillsReceivedReportsSection(),
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
Widget _buildBillsReportRequestsSection() {
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
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.send_rounded, color: _primaryColor, size: 24),
              ),
              SizedBox(width: 12),
              Text(
                'طلب تقارير من المحاسب',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor()),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _primaryColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_rounded, color: _primaryColor, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'سيتم إرسال طلب التقرير إلى المحاسب لإنشائه',
                    style: TextStyle(color: _textColor(), fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: _buildBillsReportRequestButton(
                  'طلب تقرير يومي', 
                  Icons.today_rounded, 
                  _primaryColor, 
                  'يومي'
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildBillsReportRequestButton(
                  'طلب تقرير أسبوعي', 
                  Icons.date_range_rounded, 
                  _accentColor, 
                  'أسبوعي'
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildBillsReportRequestButton(
                  'طلب تقرير شهري', 
                  Icons.calendar_month_rounded, 
                  _secondaryColor, 
                  'شهري'
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          Text(
            'طلباتي الأخيرة',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textColor()),
          ),
          SizedBox(height: 12),
          
          if (_billsReportRequests.isEmpty)
            _buildBillsEmptyRequests()
          else
            Column(
              children: _billsReportRequests.map((request) => _buildBillsRequestItem(request)).toList(),
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
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
Widget _buildBillsRequestItem(Map<String, dynamic> request) {
  Color statusColor = _getBillsRequestStatusColor(request['status']);
  
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(12),
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
            _getBillsRequestIcon(request['status']),
            color: statusColor,
            size: 20,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request['title'],
                style: TextStyle(fontWeight: FontWeight.w600, color: _textColor()),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 12, color: _textSecondaryColor()),
                  SizedBox(width: 4),
                  Text(
                    request['date'],
                    style: TextStyle(fontSize: 11, color: _textSecondaryColor()),
                  ),
                  SizedBox(width: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
          onPressed: () => _showBillsRequestDetails(request),
        ),
      ],
    ),
  );
}
Color _getBillsRequestStatusColor(String status) {
  switch (status) {
    case 'معلق': return _warningColor;
    case 'قيد التنفيذ': return _accentColor;
    case 'مكتمل': return _successColor;
    default: return _textSecondaryColor();
  }
}

IconData _getBillsRequestIcon(String status) {
  switch (status) {
    case 'معلق': return Icons.pending_rounded;
    case 'قيد التنفيذ': return Icons.hourglass_bottom_rounded;
    case 'مكتمل': return Icons.check_circle_rounded;
    default: return Icons.receipt_long_rounded;
  }
}
void _showBillsRequestDetails(Map<String, dynamic> request) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(),
      title: Row(
        children: [
          Icon(Icons.request_page_rounded, color: _primaryColor),
          SizedBox(width: 8),
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
            SizedBox(height: 16),
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
          child: Text('إغلاق'),
        ),
      ],
    ),
  );
}
Widget _buildBillsEmptyRequests() {
  return Container(
    padding: EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: _backgroundColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor().withOpacity(0.5), width: 1.5),
    ),
    child: Column(
      children: [
        Icon(Icons.send_rounded, size: 48, color: _textSecondaryColor()),
        SizedBox(height: 12),
        Text(
          'لا توجد طلبات تقارير',
          style: TextStyle(fontSize: 16, color: _textSecondaryColor(), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'يمكنك إرسال طلب تقرير باستخدام الأزرار أعلاه',
          textAlign: TextAlign.center,
          style: TextStyle(color: _textSecondaryColor()),
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
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.send_rounded, color: _primaryColor, size: 24),
          ),
          SizedBox(width: 12),
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
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
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
                    SizedBox(width: 8),
                    Text(
                      'تفاصيل الطلب:',
                      style: TextStyle(fontWeight: FontWeight.bold, color: _textColor()),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                _buildRequestDetail('نوع التقرير', 'تقرير $reportType'),
                _buildRequestDetail('المستلم', 'المحاسب'),
                _buildRequestDetail('حالة الطلب', 'سيكون معلق'),
                _buildRequestDetail('وقت الاستجابة المتوقع', '24-48 ساعة'),
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
              Icon(Icons.send_rounded, size: 18),
              SizedBox(width: 8),
              Text('إرسال الطلب'),
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
      'dueDate': DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1))),
      'description': 'تقرير مفصل عن الفواتير $reportType',
    });
  });
  
  _showSuccessMessage('تم إرسال طلب التقرير $reportType بنجاح');
}

Widget _buildReportsTab(bool isDarkMode) {
  return RefreshIndicator(
    key: const Key('reports_refresh'),
    onRefresh: _refreshReportsTab,
    color: _primaryColor,
    backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReportsStats(),
          SizedBox(height: 20),
          _buildReportsFilter(),
          SizedBox(height: 20),
          _buildReportsList(),
        ],
      ),
    ),
  );
}

Widget _buildReportsStats() {
  int newReports = _reports.where((r) => r['status'] == 'جديد').length;
  int urgentReports = _reports.where((r) => r['priority'] == 'عاجل').length;
  int inProgressReports = _reports.where((r) => r['status'] == 'قيد المعالجة').length;
  int totalReports = _reports.length;
  
  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _borderColor()),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.report_problem_rounded, color: _primaryColor, size: 24),
              ),
              SizedBox(width: 12),
              Text(
                'إحصائيات البلاغات',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryColor),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('إجمالي البلاغات', totalReports.toString(), Icons.receipt_rounded, _primaryColor),
              _buildStatCard('بلاغات جديدة', newReports.toString(), Icons.fiber_new_rounded, _warningColor),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('عاجلة', urgentReports.toString(), Icons.priority_high_rounded, _errorColor),
              _buildStatCard('قيد المعالجة', inProgressReports.toString(), Icons.hourglass_bottom_rounded, _accentColor),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildReportsFilter() {
  List<String> filters = ['الكل', 'جديد', 'قيد المعالجة', 'تمت المعالجة'];
  String _selectedReportFilter = 'الكل';
  
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: filters.map((filter) {
        bool isSelected = _selectedReportFilter == filter;
        return Padding(
          padding: const EdgeInsets.only(left: 8),
          child: FilterChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _selectedReportFilter = filter;
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

Widget _buildReportsList() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'البلاغات الواردة',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryColor),
      ),
      SizedBox(height: 12),
      ..._reports.map((report) => _buildReportCard(report)).toList(),
    ],
  );
}

Widget _buildReportCard(Map<String, dynamic> report) {
  Color statusColor = _getReportStatusColor(report['status']);
  Color priorityColor = _getReportPriorityColor(report['priority']);
  
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor()),
    ),
    child: ExpansionTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(_getReportIcon(report['type']), color: statusColor, size: 24),
      ),
      title: Text(
        report['title'],
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor()),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text('المواطن: ${report['citizenName']}', style: TextStyle(fontSize: 12, color: _textSecondaryColor())),
          SizedBox(height: 2),
          Text(report['location'], style: TextStyle(fontSize: 11, color: _textSecondaryColor())),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: priorityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: priorityColor.withOpacity(0.3)),
            ),
            child: Text(
              report['priority'],
              style: TextStyle(fontSize: 10, color: priorityColor, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              report['status'],
              style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReportDetailRow('رقم البلاغ:', report['id']),
              _buildReportDetailRow('المواطن:', report['citizenName']),
              _buildReportDetailRow('رقم الهاتف:', report['phone']),
              _buildReportDetailRow('الموقع:', report['location']),
              _buildReportDetailRow('تاريخ البلاغ:', '${report['date']} ${report['time']}'),
              _buildReportDetailRow('نوع البلاغ:', report['type']),
              _buildReportDetailRow('الوصف:', report['description']),
              if (report['assignedTo'] != null && report['assignedTo'].isNotEmpty)
                _buildReportDetailRow('المسند إلى:', report['assignedTo']),
              if (report['responseTime'] != null && report['responseTime'].isNotEmpty)
                _buildReportDetailRow('وقت الاستجابة:', report['responseTime']),
              if (report['completedDate'] != null)
                _buildReportDetailRow('تاريخ الإنجاز:', report['completedDate']),
              if (report['images'] > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.image_rounded, size: 16, color: _primaryColor),
                      SizedBox(width: 4),
                      Text('عدد الصور: ${report['images']}', style: TextStyle(color: _primaryColor)),
                    ],
                  ),
                ),
              SizedBox(height: 16),
              Row(
                children: [
                  if (report['status'] == 'جديد')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _assignReport(report),
                        icon: Icon(Icons.assignment_ind_rounded, size: 18),
                        label: Text('إسناد البلاغ'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  if (report['status'] == 'جديد') SizedBox(width: 8),
                  if (report['status'] == 'قيد المعالجة')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _completeReport(report),
                        icon: Icon(Icons.check_circle_rounded, size: 18),
                        label: Text('تأكيد الإنجاز'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _successColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  if (report['status'] == 'قيد المعالجة') SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _viewReportDetails(report),
                      icon: Icon(Icons.visibility_rounded, size: 18),
                      label: Text('عرض التفاصيل'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _accentColor,
                        side: BorderSide(color: _accentColor),
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

Widget _buildReportDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w600, color: _textColor()),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: _textSecondaryColor()),
          ),
        ),
      ],
    ),
  );
}

Color _getReportStatusColor(String status) {
  switch (status) {
    case 'جديد': return _warningColor;
    case 'قيد المعالجة': return _primaryColor;
    case 'تمت المعالجة': return _successColor;
    default: return _textSecondaryColor();
  }
}

Color _getReportPriorityColor(String priority) {
  switch (priority) {
    case 'عاجل': return _errorColor;
    case 'عالي': return _warningColor;
    case 'متوسط': return _accentColor;
    case 'منخفض': return _successColor;
    default: return _textSecondaryColor();
  }
}

IconData _getReportIcon(String type) {
  switch (type) {
    case 'انقطاع': return Icons.power_off_rounded;
    case 'عطل فني': return Icons.build_rounded;
    case 'عداد': return Icons.speed_rounded;
    case 'جودة': return Icons.electric_bolt_rounded;
    case 'طوارئ': return Icons.warning_rounded;
    default: return Icons.report_problem_rounded;
  }
}

void _assignReport(Map<String, dynamic> report) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(),
      title: Row(
        children: [
          Icon(Icons.assignment_ind_rounded, color: _primaryColor),
          SizedBox(width: 8),
          Text('إسناد البلاغ', style: TextStyle(color: _textColor())),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('اختر الفني لإسناد البلاغ:', style: TextStyle(color: _textColor())),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: _backgroundColor(),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _borderColor()),
            ),
            child: DropdownButton<String>(
              value: 'فني صيانة',
              isExpanded: true,
              underline: SizedBox(),
              icon: Icon(Icons.arrow_drop_down_rounded, color: _primaryColor),
              items: ['فني صيانة', 'محاسب قواتير', 'مراقب استهلاك'].map((tech) {
                return DropdownMenuItem(
                  value: tech,
                  child: Text(tech, style: TextStyle(color: _textColor())),
                );
              }).toList(),
              onChanged: (value) {},
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
            setState(() {
              report['status'] = 'قيد المعالجة';
              report['assignedTo'] = 'فني صيانة';
            });
            Navigator.pop(context);
            _showSuccessMessage('تم إسناد البلاغ بنجاح');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
          ),
          child: Text('إسناد'),
        ),
      ],
    ),
  );
}

void _completeReport(Map<String, dynamic> report) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(),
      title: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: _successColor),
          SizedBox(width: 8),
          Text('تأكيد إنجاز البلاغ', style: TextStyle(color: _textColor())),
        ],
      ),
      content: Text('هل أنت متأكد من إنجاز البلاغ "${report['title']}"؟'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              report['status'] = 'تمت المعالجة';
              report['completedDate'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
            });
            Navigator.pop(context);
            _showSuccessMessage('تم تأكيد إنجاز البلاغ');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _successColor,
            foregroundColor: Colors.white,
          ),
          child: Text('تأكيد الإنجاز'),
        ),
      ],
    ),
  );
}

void _viewReportDetails(Map<String, dynamic> report) {
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
                  Icon(Icons.report_problem_rounded, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'تفاصيل البلاغ',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
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
                    Text(report['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: _textColor())),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getReportPriorityColor(report['priority']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _getReportPriorityColor(report['priority']).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.priority_high_rounded, color: _getReportPriorityColor(report['priority'])),
                          SizedBox(width: 8),
                          Text('الأولوية: ${report['priority']}', style: TextStyle(fontWeight: FontWeight.bold, color: _getReportPriorityColor(report['priority']))),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildDetailRow('رقم البلاغ:', report['id']),
                    _buildDetailRow('المواطن:', report['citizenName']),
                    _buildDetailRow('رقم الهاتف:', report['phone']),
                    _buildDetailRow('الموقع:', report['location']),
                    _buildDetailRow('تاريخ البلاغ:', '${report['date']} ${report['time']}'),
                    _buildDetailRow('نوع البلاغ:', report['type']),
                    _buildDetailRow('الحالة:', report['status']),
                    _buildDetailRow('الوصف:', report['description']),
                    if (report['assignedTo'] != null && report['assignedTo'].isNotEmpty)
                      _buildDetailRow('المسند إلى:', report['assignedTo']),
                    if (report['responseTime'] != null && report['responseTime'].isNotEmpty)
                      _buildDetailRow('وقت الاستجابة:', report['responseTime']),
                    if (report['completedDate'] != null)
                      _buildDetailRow('تاريخ الإنجاز:', report['completedDate']),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: _borderColor())),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('إغلاق'),
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
Widget _buildBillsReceivedReportsSection() {
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
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.inbox_rounded, color: _successColor, size: 24),
              ),
              SizedBox(width: 12),
              Text(
                'التقارير الواردة من المحاسب',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: _textColor()),
              ),
              Spacer(),
              Badge(
                label: Text('${_billsReceivedReports.where((r) => !r['read']).length}'),
                backgroundColor: _primaryColor,
                child: Icon(Icons.notifications_rounded, color: _primaryColor),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          _buildBillsReportFilter(),
          SizedBox(height: 20),
          
          if (_billsReceivedReports.isEmpty)
            _buildBillsEmptyReports()
          else
            Column(
              children: _getFilteredBillsReports().map((report) => _buildBillsReceivedReportItem(report)).toList(),
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
Widget _buildBillsReceivedReportItem(Map<String, dynamic> report) {
  Color statusColor = _getBillsReportStatusColor(report['status']);
  Color priorityColor = _getBillsPriorityColor(report['priority']);
  
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _backgroundColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor()),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      margin: EdgeInsets.only(right: 8),
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
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
        
        SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_rounded, size: 14, color: _textSecondaryColor()),
                      SizedBox(width: 4),
                      Text(
                        'المرسل:',
                        style: TextStyle(fontSize: 12, color: _textSecondaryColor()),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
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
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 14, color: _textSecondaryColor()),
                      SizedBox(width: 4),
                      Text(
                        'التاريخ:',
                        style: TextStyle(fontSize: 12, color: _textSecondaryColor()),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
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
        
        SizedBox(height: 12),
        
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Icons.description_rounded, size: 12, color: _primaryColor),
                  SizedBox(width: 4),
                  Text(
                    report['type'],
                    style: TextStyle(fontSize: 11, color: _primaryColor),
                  ),
                ],
              ),
            ),
            
            SizedBox(width: 8),
            
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: priorityColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.priority_high_rounded, size: 12, color: priorityColor),
                  SizedBox(width: 4),
                  Text(
                    report['priority'],
                    style: TextStyle(fontSize: 11, color: priorityColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            Spacer(),
            
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
        
        SizedBox(height: 12),
        
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
        
        SizedBox(height: 12),
        
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Icons.receipt_rounded, size: 12, color: _successColor),
                  SizedBox(width: 4),
                  Text(
                    '${report['totalBills']} فاتورة',
                    style: TextStyle(fontSize: 11, color: _successColor),
                  ),
                ],
              ),
            ),
            
            SizedBox(width: 8),
            
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Icons.attach_money_rounded, size: 12, color: _accentColor),
                  SizedBox(width: 4),
                  Text(
                    '${_formatCurrency(report['totalAmount'])}',
                    style: TextStyle(fontSize: 11, color: _accentColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _viewBillsReport(report);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primaryColor,
                  side: BorderSide(color: _primaryColor),
                ),
                icon: Icon(Icons.remove_red_eye_rounded, size: 16),
                label: Text('عرض التقرير',style: TextStyle(fontSize:11),),
              ),
            ),
            
            SizedBox(width: 8),
            
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _downloadBillsReport(report);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                ),
                icon: Icon(Icons.download_rounded, size: 16),
                label: Text('تحميل',style: TextStyle(fontSize:11),),
              ),
            ),
            
            SizedBox(width: 8),
            
            IconButton(
              onPressed: () {
                _showBillsReportOptions(report);
              },
              icon: Icon(Icons.more_vert_rounded, color: _primaryColor),
            ),
          ],
        ),
      ],
    ),
  );
}
Color _getBillsReportStatusColor(String status) {
  switch (status) {
    case 'جديد': return _primaryColor;
    case 'مكتمل': return _successColor;
    case 'قيد المراجعة': return _warningColor;
    case 'مرفوض': return _errorColor;
    default: return _textSecondaryColor();
  }
}

Color _getBillsPriorityColor(String priority) {
  switch (priority) {
    case 'عالي': return _errorColor;
    case 'متوسط': return _warningColor;
    case 'عادي': return _successColor;
    default: return _textSecondaryColor();
  }
}

List<Map<String, dynamic>> _getFilteredBillsReports() {
  if (_billsReportFilter == 'الكل') return _billsReceivedReports;
  return _billsReceivedReports.where((report) => report['type'] == _billsReportFilter).toList();
}
void _viewBillsReport(Map<String, dynamic> report) {
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
                  Icon(Icons.receipt_long_rounded, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      report['title'],
                      style: TextStyle(
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
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildViewDetail('المرسل', report['sender']),
                    _buildViewDetail('نوع التقرير', report['type']),
                    _buildViewDetail('التاريخ', '${report['date']} ${report['time']}'),
                    _buildViewDetail('الأولوية', report['priority']),
                    _buildViewDetail('حجم الملف', report['size']),
                    _buildViewDetail('الصيغة', report['format']),
                    
                    SizedBox(height: 16),
                    Divider(color: _borderColor()),
                    SizedBox(height: 16),
                    
                    Text(
                      'ملخص التقرير',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: _primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      report['summary'],
                      style: TextStyle(
                        color: _textColor(),
                        height: 1.6,
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    Container(
                      padding: EdgeInsets.all(12),
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
                                  '${_formatCurrency(report['totalAmount'])}',
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
                    
                    SizedBox(height: 16),
                    
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
                          SizedBox(height: 8),
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
            
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: _borderColor())),
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
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _downloadBillsReport(report);
                      },
                      icon: Icon(Icons.download_rounded),
                      label: Text('تحميل التقرير'),
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

void _downloadBillsReport(Map<String, dynamic> report) {
  _showSuccessMessage('جاري تحميل التقرير: ${report['title']}');
}

void _showBillsReportOptions(Map<String, dynamic> report) {
  showModalBottomSheet(
    context: context,
    backgroundColor: _cardColor(),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.share_rounded, color: _primaryColor),
            title: Text('مشاركة التقرير'),
            onTap: () {
              Navigator.pop(context);
              _shareBillsReport(report);
            },
          ),
          ListTile(
            leading: Icon(Icons.archive_rounded, color: _primaryColor),
            title: Text('أرشفة التقرير'),
            onTap: () {
              Navigator.pop(context);
              _archiveBillsReport(report);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_rounded, color: _errorColor),
            title: Text('حذف التقرير', style: TextStyle(color: _errorColor)),
            onTap: () {
              Navigator.pop(context);
              _deleteBillsReport(report);
            },
          ),
          SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
        ],
      ),
    ),
  );
}

void _shareBillsReport(Map<String, dynamic> report) {
  _showSuccessMessage('تم إعداد التقرير للمشاركة: ${report['title']}');
}

void _archiveBillsReport(Map<String, dynamic> report) {
  setState(() {
    _billsReceivedReports.remove(report);
  });
  _showSuccessMessage('تم أرشفة التقرير');
}

void _deleteBillsReport(Map<String, dynamic> report) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(),
      title: Row(
        children: [
          Icon(Icons.delete_rounded, color: _errorColor),
          SizedBox(width: 8),
          Text('حذف التقرير'),
        ],
      ),
      content: Text('هل أنت متأكد من حذف التقرير "${report['title']}"؟'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _billsReceivedReports.remove(report);
            });
            Navigator.pop(context);
            _showSuccessMessage('تم حذف التقرير');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _errorColor,
            foregroundColor: Colors.white,
          ),
          child: Text('حذف'),
        ),
      ],
    ),
  );
}

Widget _buildBillsEmptyReports() {
  return Container(
    padding: EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: _backgroundColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor()),
    ),
    child: Column(
      children: [
        Icon(Icons.inbox_rounded, size: 48, color: _textSecondaryColor()),
        SizedBox(height: 12),
        Text(
          'لا توجد تقارير واردة',
          style: TextStyle(fontSize: 16, color: _textSecondaryColor(), fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'سيظهر هنا التقارير المرسلة من المحاسب',
          textAlign: TextAlign.center,
          style: TextStyle(color: _textSecondaryColor()),
        ),
      ],
    ),
  );
}
  Widget _buildBillsStats() {
    int paidBills = bills.where((bill) => bill['status'] == 'paid').length;
    int unpaidBills = bills.where((bill) => bill['status'] == 'unpaid').length;
    int overdueBills = bills.where((bill) => bill['status'] == 'overdue').length;
    double totalRevenue = bills.fold(0.0, (sum, bill) => sum + (bill['amountIQD'] ?? 0));
    
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
            SizedBox(height: 20),
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

  Widget _buildBillCard(Map<String, dynamic> bill) {
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
                SizedBox(height: 8),
                Text(bill['citizenName'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textColor())),
                SizedBox(height: 4),
                Text('${_formatCurrency(bill['amountIQD'])} - ${bill['consumption']}', style: TextStyle(fontSize: 12, color: _textSecondaryColor())),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(color: _backgroundColor(), borderRadius: BorderRadius.circular(8), border: Border.all(color: _borderColor())),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Icon(Icons.payment_rounded, size: 16, color: _primaryColor), SizedBox(width: 8), Text('طريقة الدفع:', style: TextStyle(fontSize: 12, color: _textSecondaryColor())), SizedBox(width: 4), Text(bill['paymentMethod'] ?? 'غير محدد', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _textColor()))]),
                      if (bill['cardNumber'] != null) ...[SizedBox(height: 8), Row(children: [Icon(Icons.credit_card_rounded, size: 14, color: _primaryColor), SizedBox(width: 8), Text('رقم البطاقة: ${bill['cardNumber']}', style: TextStyle(fontSize: 11, color: _textSecondaryColor()))])],
                      if (bill['phoneNumber'] != null) ...[SizedBox(height: 8), Row(children: [Icon(Icons.phone_rounded, size: 14, color: _primaryColor), SizedBox(width: 8), Text('رقم الهاتف: ${bill['phoneNumber']}', style: TextStyle(fontSize: 11, color: _textSecondaryColor()))])],
                      SizedBox(height: 8),
                      Row(children: [Icon(Icons.account_balance_rounded, size: 14, color: _primaryColor), SizedBox(width: 8), Text('محول إلى: ${bill['transferTo']}', style: TextStyle(fontSize: 11, color: _textSecondaryColor()))]),
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

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
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
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(method['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor())),
                  SizedBox(height: 4),
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

  Widget _buildCitizenCard(Map<String, dynamic> citizen) {
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
            SizedBox(width: 12),
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
                  SizedBox(height: 4),
                  Text('${citizen['totalBills']} فواتير - ${_formatCurrency(citizen['totalAmount'])}', style: TextStyle(fontSize: 12, color: _textSecondaryColor())),
                  SizedBox(height: 4),
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 20)),
        SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        Text(title, style: TextStyle(fontSize: 10, color: _textSecondaryColor())),
      ],
    );
  }

Widget _buildConsumptionTab(isDarkMode) {
  return RefreshIndicator(
    key: const Key('consumption_refresh'),
    onRefresh: _refreshConsumptionTab,
    color: _primaryColor,
    backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0)),
            ),
            child: Row(
              children: [
                _buildConsumptionTabButton('اليومي', 0, Icons.today_rounded),
                _buildConsumptionTabButton('الشهري', 1, Icons.date_range_rounded),
                _buildConsumptionTabButton('السنوي', 2, Icons.calendar_today_rounded),
              ],
            ),
          ),
          SizedBox(height: 20),
          
          if (_selectedConsumptionTab == 0) _buildDailyConsumption(),
          if (_selectedConsumptionTab == 1) _buildMonthlyConsumption(),
          if (_selectedConsumptionTab == 2) _buildYearlyConsumption(),
        ],
      ),
    ),
  );
}
Widget _buildConsumptionTabButton(String title, int index, IconData icon) {
  bool isSelected = _selectedConsumptionTab == index;
  return Expanded(
    child: GestureDetector(
      onTap: () => setState(() => _selectedConsumptionTab = index),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? _primaryColor : _textSecondaryColor()),
              SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? _primaryColor : _textSecondaryColor(),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
Widget _buildDailyConsumption() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor()),
        ),
        child: Row(
          children: [
            Icon(Icons.filter_list_rounded, color: _primaryColor),
            SizedBox(width: 12),
            Text('اختر التاريخ:', style: TextStyle(color: _textColor())),
            SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _backgroundColor(),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _borderColor()),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('yyyy-MM-dd').format(_selectedDate),
                        style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_drop_down_rounded, color: _primaryColor),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 20),
      
      _buildDailyStats(),
    ],
  );
}
Widget _buildDailyStats() {
  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _borderColor()),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.today_rounded, color: _primaryColor, size: 24),
              ),
              SizedBox(width: 12),
              Text(
                'استهلاك ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor()),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildConsumptionStatCard('إجمالي اليوم', '4,250 ك.و.س', Icons.bolt_rounded, _primaryColor),
              _buildConsumptionStatCard('المتوسط', '4,100 ك.و.س', Icons.trending_up_rounded, _accentColor),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildConsumptionStatCard('الذروة', '4,350 ك.و.س', Icons.trending_up_rounded, _warningColor),
              _buildConsumptionStatCard('الحالة', 'طبيعي', Icons.check_circle_rounded, _successColor),
            ],
          ),
        ],
      ),
    ),
  );
}Widget _buildDailyItem(Map<String, dynamic> day) {
  Color statusColor = day['status'] == 'طبيعي' ? _successColor : 
                      day['status'] == 'مرتفع' ? _warningColor : _accentColor;
  
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor()),
    ),
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.bolt_rounded, color: statusColor, size: 24),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day['day'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor()),
              ),
              SizedBox(height: 4),
              Text(
                day['date'],
                style: TextStyle(fontSize: 12, color: _textSecondaryColor()),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${_formatNumber(day['consumption'].toDouble())} ك.و.س',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _primaryColor),
            ),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Text(
                day['status'],
                style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
Widget _buildMonthlyConsumption() {
  List<Map<String, dynamic>> monthlyData = [
    {'month': 'مارس 2024', 'consumption': 125000, 'change': '+5.9%'},
    {'month': 'فبراير 2024', 'consumption': 118000, 'change': '-2.3%'},
    {'month': 'يناير 2024', 'consumption': 120800, 'change': '+3.1%'},
    {'month': 'ديسمبر 2023', 'consumption': 117200, 'change': '-1.5%'},
    {'month': 'نوفمبر 2023', 'consumption': 119000, 'change': '+2.7%'},
    {'month': 'أكتوبر 2023', 'consumption': 115900, 'change': '-0.8%'},
  ];
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor()),
        ),
        child: Row(
          children: [
            Icon(Icons.filter_list_rounded, color: _primaryColor),
            SizedBox(width: 12),
            Text('اختر الشهر:', style: TextStyle(color: _textColor())),
            SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _backgroundColor(),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _borderColor()),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedMonth,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down_rounded, color: _primaryColor),
                    items: monthlyData.map((month) {
                      return DropdownMenuItem<String>(
                        value: month['month'],
                        child: Text(month['month'], style: TextStyle(color: _textColor())),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedMonth = value!),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 20),
      
      _buildMonthlyStats(),
    ],
  );
}
Widget _buildMonthlyStats() {
  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _borderColor()),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.date_range_rounded, color: _accentColor, size: 24),
              ),
              SizedBox(width: 12),
              Text(
                'استهلاك $_selectedMonth',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor()),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildConsumptionStatCard('إجمالي الشهر', '125,000 ك.و.س', Icons.bolt_rounded, _accentColor),
              _buildConsumptionStatCard('المتوسط اليومي', '4,167 ك.و.س', Icons.trending_up_rounded, _primaryColor),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildConsumptionStatCard('مقارنة بالشهر السابق', '+5.9%', Icons.compare_arrows_rounded, _successColor),
              _buildConsumptionStatCard('أعلى يوم', '4,850 ك.و.س', Icons.trending_up_rounded, _warningColor),
            ],
          ),
        ],
      ),
    ),
  );
}
Widget _buildMonthlyItem(Map<String, dynamic> month) {
  bool isPositive = month['change'].contains('+');
  Color changeColor = isPositive ? _successColor : _errorColor;
  
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor()),
    ),
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.calendar_month_rounded, color: _accentColor, size: 24),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            month['month'],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor()),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${_formatNumber(month['consumption'])} ك.و.س',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _primaryColor),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                  size: 14,
                  color: changeColor,
                ),
                SizedBox(width: 2),
                Text(
                  month['change'],
                  style: TextStyle(fontSize: 12, color: changeColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}Widget _buildYearlyConsumption() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor()),
        ),
        child: Row(
          children: [
            Icon(Icons.filter_list_rounded, color: _primaryColor),
            SizedBox(width: 12),
            Text('اختر السنة:', style: TextStyle(color: _textColor())),
            SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _backgroundColor(),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _borderColor()),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedYear,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down_rounded, color: _primaryColor),
                    items: _availableYears.map((year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Text(year, style: TextStyle(color: _textColor())),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedYear = value!),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 20),
      
      _buildYearlyStats(),
    ],
  );
}
Widget _buildYearlyStats() {
  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _borderColor()),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.calendar_today_rounded, color: _successColor, size: 24),
              ),
              SizedBox(width: 12),
              Text(
                'استهلاك $_selectedYear',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor()),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildConsumptionStatCard('إجمالي السنة', '1,500,000 ك.و.س', Icons.bolt_rounded, _successColor),
              _buildConsumptionStatCard('المتوسط الشهري', '125,000 ك.و.س', Icons.trending_up_rounded, _primaryColor),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildConsumptionStatCard('مقارنة بالعام السابق', '+3.5%', Icons.compare_arrows_rounded, _successColor),
              _buildConsumptionStatCard('أعلى شهر', 'مارس', Icons.star_rounded, _warningColor),
            ],
          ),
        ],
      ),
    ),
  );
}
Widget _buildYearlyItem(Map<String, dynamic> year) {
  bool isPositive = year.containsKey('change') && year['change'].contains('+');
  Color changeColor = isPositive ? _successColor : _errorColor;
  
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor()),
    ),
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _successColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.calendar_today_rounded, color: _successColor, size: 24),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            year['year'],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor()),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${_formatNumber(year['consumption'])} ك.و.س',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _primaryColor),
            ),
            if (year.containsKey('change'))
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                      size: 14,
                      color: changeColor,
                    ),
                    SizedBox(width: 2),
                    Text(
                      year['change'],
                      style: TextStyle(fontSize: 12, color: changeColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    ),
  );
}
 Widget _buildConsumptionStatCard(String title, String value, IconData icon, Color color) {
    return Column(children: [Container(width: 60, height: 60, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: color, size: 30)), SizedBox(height: 12), Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textColor()), textAlign: TextAlign.center), SizedBox(height: 4), Text(title, style: TextStyle(fontSize: 12, color: _textSecondaryColor()))]);
  }

  Widget _buildChangeCard(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(width: 60, height: 60, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: color, size: 30)),
        SizedBox(height: 12),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color), textAlign: TextAlign.center),
        SizedBox(height: 4),
        Text(title, style: TextStyle(fontSize: 12, color: _textSecondaryColor())),
      ],
    );
  }

  Widget _buildAreaFilter() {
    List<String> areas = ['جميع المناطق', 'المنطقة الشمالية', 'المنطقة الجنوبية', 'المنطقة الشرقية', 'المنطقة الغربية'];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: _cardColor(), borderRadius: BorderRadius.circular(12), border: Border.all(color: _borderColor())),
      child: Row(children: [Icon(Icons.location_on_rounded, color: _primaryColor, size: 20), SizedBox(width: 12), Text('المنطقة:', style: TextStyle(fontWeight: FontWeight.bold, color: _textColor())), SizedBox(width: 8), Expanded(child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: areas[0], isExpanded: true, icon: Icon(Icons.arrow_drop_down_rounded, color: _primaryColor), items: areas.map((area) => DropdownMenuItem<String>(value: area, child: Text(area, style: TextStyle(color: _textColor())))).toList(), onChanged: (value) {})))]),
    );
  }

  Widget _buildChartBar(num height, String month) { 
  double maxHeight = 150;
  double percentage = height.toDouble() / maxHeight;
  return Column(children: [Container(width: 20, height: 150 * percentage, decoration: BoxDecoration(color: _primaryColor, borderRadius: BorderRadius.circular(4))), SizedBox(height: 8), Text(month.substring(0, 3), style: TextStyle(fontSize: 10, color: _textSecondaryColor()))]);
}

  Widget _buildAlertsSection() {
    return Container(
      decoration: BoxDecoration(color: _cardColor(), borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor())),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: _errorColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.warning_rounded, color: _errorColor, size: 24)), SizedBox(width: 12), Text('إنذارات الاستهلاك', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor())), Spacer(), Badge(label: Text('3'), backgroundColor: _errorColor, child: Icon(Icons.notifications_active_rounded, color: _errorColor))]),
            SizedBox(height: 20),
            _buildAlertItem('استهلاك مرتفع غير طبيعي', 'المنطقة الشمالية - محطة 5', 'منذ ساعتين', _errorColor),
            _buildAlertItem('زيادة مفاجئة في الاستهلاك', 'المنطقة الجنوبية - محطة 2', 'منذ 5 ساعات', _warningColor),
            _buildAlertItem('مقارنة استهلاك سلبية', 'المنطقة الشرقية - محطة 7', 'منذ يوم', _accentColor),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(String title, String location, String time, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2))),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: _textColor())),
                SizedBox(height: 4),
                Row(children: [Icon(Icons.location_on_rounded, size: 12, color: _textSecondaryColor()), SizedBox(width: 4), Expanded(child: Text(location, style: TextStyle(fontSize: 11, color: _textSecondaryColor()), overflow: TextOverflow.ellipsis))]),
              ],
            ),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(time, style: TextStyle(fontSize: 10, color: _textSecondaryColor())), SizedBox(height: 4), ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4), minimumSize: Size.zero), child: Text('معالجة', style: TextStyle(fontSize: 10)))]),
        ],
      ),
    );
  }

  String _formatNumber(num number) {
  if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
  if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
  return number.toStringAsFixed(0);
}

  Widget _buildMaintenanceTab(isdarkmode) {
    return RefreshIndicator(
      key: const Key('maintenance_refresh'),
      onRefresh: _refreshMaintenanceTab,
      color: _primaryColor,
      backgroundColor: isdarkmode ? Color(0xFF1E1E1E) : Colors.white,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMaintenanceStats(),
            SizedBox(height: 20),
            _buildMaintenanceTasksTabs(),
            SizedBox(height: 20),
            _buildMaintenanceReportTabs(),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceStats() {
    int totalTasks = 45;
    int completedTasks = 38;
    int delayedTasks = 5;
    int activeTasks = 2;
    double completionRate = (completedTasks / totalTasks * 100);
    
    return Container(
      decoration: BoxDecoration(color: _cardColor(), borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor())),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(children: [Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: _primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.engineering_rounded, color: _primaryColor, size: 24)), SizedBox(width: 12), Text('إحصائيات الصيانة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryColor))]),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildMaintenanceStatCard('إجمالي المهام', totalTasks.toString(), Icons.task_rounded, _primaryColor), _buildMaintenanceStatCard('معدل الإنجاز', '${completionRate.toStringAsFixed(1)}%', Icons.check_circle_rounded, _successColor)]),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_buildSimpleMaintenanceStat('المكتملة', completedTasks.toString(), _successColor), _buildSimpleMaintenanceStat('المتأخرة', delayedTasks.toString(), _warningColor), _buildSimpleMaintenanceStat('النشطة', activeTasks.toString(), _accentColor), _buildSimpleMaintenanceStat('المؤجلة', '0', _textSecondaryColor())]),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceStatCard(String title, String value, IconData icon, Color color) {
    return Column(children: [Container(width: 60, height: 60, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: color, size: 30)), SizedBox(height: 12), Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor())), SizedBox(height: 4), Text(title, style: TextStyle(fontSize: 12, color: _textSecondaryColor()))]);
  }

  Widget _buildSimpleMaintenanceStat(String title, String value, Color color) {
    return Column(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Center(child: Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)))), SizedBox(height: 6), Text(title, style: TextStyle(fontSize: 11, color: _textSecondaryColor()))]);
  }

  Widget _buildMaintenanceTasksTabs() {
    return Container(
      decoration: BoxDecoration(color: _cardColor(), borderRadius: BorderRadius.circular(12), border: Border.all(color: _borderColor())),
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), border: Border(bottom: BorderSide(color: _borderColor()))),
            child: Row(children: [_buildMaintenanceTaskTabButton('النشطة', 0, Icons.play_circle_filled_rounded), _buildMaintenanceTaskTabButton('المتأخرة', 1, Icons.warning_rounded), _buildMaintenanceTaskTabButton('المكتملة', 2, Icons.check_circle_rounded), _buildMaintenanceTaskTabButton('الكل', 3, Icons.view_list_rounded)]),
          ),
          Container(padding: EdgeInsets.all(16), child: _buildMaintenanceTaskTabContent()),
        ],
      ),
    );
  }

  Widget _buildMaintenanceTaskTabContent() {
    List<Map<String, dynamic>> filteredTasks = [];
    switch (_maintenanceCurrentTab) {
      case 0: filteredTasks = _maintenanceTasks.where((task) => task['status'] == 'قيد التنفيذ' || task['status'] == 'معلقة').toList(); break;
      case 1: filteredTasks = _maintenanceTasks.where((task) => task['status'] == 'متأخرة').toList(); break;
      case 2: filteredTasks = _maintenanceTasks.where((task) => task['status'] == 'مكتملة').toList(); break;
      case 3: filteredTasks = _maintenanceTasks; break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(_getMaintenanceTabTitle(_maintenanceCurrentTab), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor())), Container(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: _getMaintenanceTabColor(_maintenanceCurrentTab).withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: _getMaintenanceTabColor(_maintenanceCurrentTab).withOpacity(0.3))), child: Text('${filteredTasks.length} مهمة', style: TextStyle(fontSize: 12, color: _getMaintenanceTabColor(_maintenanceCurrentTab), fontWeight: FontWeight.bold)))]),
        SizedBox(height: 16),
        if (filteredTasks.isEmpty) _buildEmptyMaintenanceTasks() else Column(children: filteredTasks.map((task) => _buildMaintenanceTaskCard(task)).toList()),
      ],
    );
  }

  Widget _buildEmptyMaintenanceTasks() {
    return Container(padding: EdgeInsets.symmetric(vertical: 40), child: Column(children: [Icon(_getMaintenanceTabIcon(_maintenanceCurrentTab), size: 60, color: _textSecondaryColor()), SizedBox(height: 16), Text(_getEmptyTasksMessage(_maintenanceCurrentTab), style: TextStyle(fontSize: 16, color: _textSecondaryColor(), fontWeight: FontWeight.w600), textAlign: TextAlign.center)]));
  }

  IconData _getMaintenanceTabIcon(int index) {
    switch (index) { case 0: return Icons.play_circle_filled_rounded; case 1: return Icons.warning_rounded; case 2: return Icons.check_circle_rounded; case 3: return Icons.view_list_rounded; default: return Icons.engineering_rounded; }
  }

  String _getEmptyTasksMessage(int index) {
    switch (index) { case 0: return 'لا توجد مهام نشطة حالياً'; case 1: return 'لا توجد مهام متأخرة'; case 2: return 'لا توجد مهام مكتملة'; case 3: return 'لا توجد مهام'; default: return 'لا توجد بيانات'; }
  }

  String _getMaintenanceTabTitle(int index) {
    switch (index) { case 0: return 'المهام النشطة'; case 1: return 'المهام المتأخرة'; case 2: return 'المهام المكتملة'; case 3: return 'جميع المهام'; default: return 'المهام'; }
  }

  Color _getMaintenanceTabColor(int index) {
    switch (index) { case 0: return _primaryColor; case 1: return _warningColor; case 2: return _successColor; case 3: return _accentColor; default: return _primaryColor; }
  }

  Widget _buildMaintenanceTaskTabButton(String title, int index, IconData icon) {
    bool isSelected = _maintenanceCurrentTab == index;
    Color activeColor = _getMaintenanceTabColor(index);
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _maintenanceCurrentTab = index),
        child: Container(
          decoration: BoxDecoration(color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent, border: Border(bottom: BorderSide(color: isSelected ? activeColor : Colors.transparent, width: 3))),
          child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: isSelected ? activeColor : _textSecondaryColor(), size: 18), SizedBox(height: 2), Text(title, style: TextStyle(fontSize: 10, color: isSelected ? activeColor : _textSecondaryColor(), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal))])),
        ),
      ),
    );
  }

  Widget _buildMaintenanceReportTabs() {
    return Column(
      children: [
        Container(height: 50, decoration: BoxDecoration(color: _cardColor(), borderRadius: BorderRadius.circular(12), border: Border.all(color: _borderColor())), child: Row(children: [_buildMaintenanceReportTabButton('طلبات التقارير', 0), _buildMaintenanceReportTabButton('التقارير الواردة', 1)])),
        SizedBox(height: 16),
        _selectedMaintenanceTab == 0 ? _buildMaintenanceReportRequestsSection() : _buildMaintenanceReceivedReportsSection(),
      ],
    );
  }

  Widget _buildMaintenanceReportTabButton(String title, int index) {
    bool isSelected = _selectedMaintenanceTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMaintenanceTab = index),
        child: Container(
          decoration: BoxDecoration(color: isSelected ? _primaryColor.withOpacity(0.1) : Colors.transparent, border: Border(bottom: BorderSide(color: isSelected ? _primaryColor : Colors.transparent, width: 3))),
          child: Center(child: Text(title, style: TextStyle(color: isSelected ? _primaryColor : _textColor(), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal))),
        ),
      ),
    );
  }

  Widget _buildMaintenanceReportRequestsSection() {
    return Container(
      decoration: BoxDecoration(color: _cardColor(), borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor())),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: _primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.send_rounded, color: _primaryColor, size: 24)), SizedBox(width: 12), Text('طلب تقارير من فني الصيانة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor()))]),
            SizedBox(height: 20),
            Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: _primaryColor.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: _primaryColor.withOpacity(0.2))), child: Row(children: [Icon(Icons.info_rounded, color: _primaryColor, size: 20), SizedBox(width: 8), Expanded(child: Text('سيتم إرسال طلب التقرير إلى فني الصيانة المسؤول لإنشائه', style: TextStyle(color: _textColor(), fontSize: 14)))])),
            SizedBox(height: 20),
            Row(children: [Expanded(child: _buildMaintenanceReportRequestButton('طلب تقرير يومي', Icons.today_rounded, _primaryColor, 'يومي')), SizedBox(width: 12), Expanded(child: _buildMaintenanceReportRequestButton('طلب تقرير أسبوعي', Icons.date_range_rounded, _accentColor, 'أسبوعي')), SizedBox(width: 12), Expanded(child: _buildMaintenanceReportRequestButton('طلب تقرير شهري', Icons.calendar_month_rounded, _secondaryColor, 'شهري'))]),
            SizedBox(height: 20),
            Text('طلباتي الأخيرة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textColor())),
            SizedBox(height: 12),
            if (_maintenanceReportRequests.isEmpty) _buildMaintenanceEmptyRequests() else Column(children: _maintenanceReportRequests.map((request) => _buildMaintenanceRequestItem(request)).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceRequestItem(Map<String, dynamic> request) {
    Color statusColor = _getMaintenanceRequestStatusColor(request['status']);
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: _backgroundColor(), borderRadius: BorderRadius.circular(12), border: Border.all(color: _borderColor())),
      child: Row(
        children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(_getMaintenanceRequestIcon(request['status']), color: statusColor, size: 20)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(request['title'], style: TextStyle(fontWeight: FontWeight.w600, color: _textColor())),
                SizedBox(height: 4),
                Row(children: [Icon(Icons.calendar_today_rounded, size: 12, color: _textSecondaryColor()), SizedBox(width: 4), Text(request['date'], style: TextStyle(fontSize: 11, color: _textSecondaryColor())), SizedBox(width: 16), Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(request['status'], style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold)))]),
              ],
            ),
          ),
          IconButton(icon: Icon(Icons.visibility_rounded, color: _primaryColor, size: 20), onPressed: () => _showMaintenanceRequestDetails(request)),
        ],
      ),
    );
  }

  Color _getMaintenanceRequestStatusColor(String status) {
    switch (status) { case 'معلق': return _warningColor; case 'قيد التنفيذ': return _accentColor; case 'مكتمل': return _successColor; default: return _textSecondaryColor(); }
  }

  IconData _getMaintenanceRequestIcon(String status) {
    switch (status) { case 'معلق': return Icons.pending_rounded; case 'قيد التنفيذ': return Icons.hourglass_bottom_rounded; case 'مكتمل': return Icons.check_circle_rounded; default: return Icons.engineering_rounded; }
  }

  void _showMaintenanceRequestDetails(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(),
        title: Row(children: [Icon(Icons.request_page_rounded, color: _primaryColor), SizedBox(width: 8), Text('تفاصيل طلب التقرير', style: TextStyle(color: _textColor()))]),
        content: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text(request['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor())), SizedBox(height: 16), _buildSimpleDetailRow('رقم الطلب:', request['id']), _buildSimpleDetailRow('نوع التقرير:', request['type']), _buildSimpleDetailRow('حالة الطلب:', request['status']), _buildSimpleDetailRow('تاريخ الطلب:', request['date']), _buildSimpleDetailRow('تاريخ التسليم:', request['dueDate']), _buildSimpleDetailRow('الأولوية:', request['priority']), _buildSimpleDetailRow('الوصف:', request['description'])]),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('إغلاق'))],
      ),
    );
  }

  Widget _buildSimpleDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 100, child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: _textColor()))), Expanded(child: Text(value, style: TextStyle(color: _textSecondaryColor())))]),
    );
  }

  Widget _buildMaintenanceTaskCard(Map<String, dynamic> task) {
    Color statusColor = _getTaskStatusColor(task['status']);
    Color priorityColor = _getTaskPriorityColor(task['priority']);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: _cardColor(), borderRadius: BorderRadius.circular(12), border: Border.all(color: _borderColor())),
      child: ExpansionTile(
        leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(_getTaskIcon(task['status']), color: statusColor, size: 20)),
        title: Text(task['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor())),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(height: 4), Text('الفني: ${task['technician']}', style: TextStyle(fontSize: 12, color: _textSecondaryColor())), SizedBox(height: 2), Text(task['location'], style: TextStyle(fontSize: 11, color: _textSecondaryColor()))]),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: priorityColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: priorityColor.withOpacity(0.3))), child: Text(task['priority'], style: TextStyle(fontSize: 10, color: priorityColor, fontWeight: FontWeight.bold))),
            SizedBox(height: 4),
            Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(task['status'], style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold))),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTaskDetailRow('رقم المهمة:', task['id']),
                _buildTaskDetailRow('الفني:', task['technician']),
                _buildTaskDetailRow('الموقع:', task['location']),
                _buildTaskDetailRow('تاريخ البدء:', task['startDate']),
                if (task['estimatedTime'] != null) _buildTaskDetailRow('الوقت المقدر:', task['estimatedTime']),
                if (task['delayReason'] != null) _buildTaskDetailRow('سبب التأخير:', task['delayReason']),
                if (task['description'] != null) _buildTaskDetailRow('الوصف:', task['description']),
                SizedBox(height: 16),
                Row(children: [Expanded(child: ElevatedButton.icon(onPressed: () => _updateTaskStatus(task, 'قيد التنفيذ'), icon: Icon(Icons.play_arrow_rounded, size: 18), label: Text('بدء العمل'), style: ElevatedButton.styleFrom(backgroundColor: _primaryColor, foregroundColor: Colors.white))), SizedBox(width: 8), Expanded(child: OutlinedButton.icon(onPressed: () => _updateTaskStatus(task, 'مؤجلة'), icon: Icon(Icons.schedule_rounded, size: 18), label: Text('تأجيل'), style: OutlinedButton.styleFrom(foregroundColor: _warningColor, side: BorderSide(color: _warningColor))))]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTaskStatusColor(String status) {
    switch (status) { case 'قيد التنفيذ': return _primaryColor; case 'معلقة': return _warningColor; case 'مكتملة': return _successColor; case 'متأخرة': return _errorColor; default: return _textSecondaryColor(); }
  }

  Color _getTaskPriorityColor(String priority) {
    switch (priority) { case 'عاجل': return _errorColor; case 'عالي': return _warningColor; case 'متوسط': return _accentColor; case 'منخفض': return _successColor; default: return _textSecondaryColor(); }
  }

  IconData _getTaskIcon(String status) {
    switch (status) { case 'قيد التنفيذ': return Icons.play_circle_filled_rounded; case 'معلقة': return Icons.pause_circle_filled_rounded; case 'مكتملة': return Icons.check_circle_rounded; case 'متأخرة': return Icons.warning_rounded; default: return Icons.engineering_rounded; }
  }

  Widget _buildTaskDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 100, child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: _textColor()))), Expanded(child: Text(value, style: TextStyle(color: _textSecondaryColor())))]),
    );
  }

  void _updateTaskStatus(Map<String, dynamic> task, String newStatus) {
    setState(() => task['status'] = newStatus);
    _showSuccessMessage('تم تحديث حالة المهمة "${task['title']}" إلى "$newStatus"');
  }

  Widget _buildMaintenanceReportRequestButton(String title, IconData icon, Color color, String reportType) {
    return ElevatedButton(
      onPressed: () => _showMaintenanceReportRequestConfirmation(reportType),
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 24), SizedBox(height: 8), Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center)]),
    );
  }

  void _showMaintenanceReportRequestConfirmation(String reportType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: _primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.send_rounded, color: _primaryColor, size: 24)), SizedBox(width: 12), Text('تأكيد إرسال الطلب', style: TextStyle(color: _textColor(), fontWeight: FontWeight.bold))]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('هل تريد إرسال طلب لتقرير $reportType إلى فني الصيانة المسؤول؟', style: TextStyle(color: _textColor(), fontSize: 16)),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: _backgroundColor(), borderRadius: BorderRadius.circular(12), border: Border.all(color: _borderColor())),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(Icons.description_rounded, size: 16, color: _primaryColor), SizedBox(width: 8), Text('تفاصيل الطلب:', style: TextStyle(fontWeight: FontWeight.bold, color: _textColor()))]), SizedBox(height: 8), _buildRequestDetail('نوع التقرير', 'تقرير $reportType'), _buildRequestDetail('المستلم', 'فني الصيانة المسؤول'), _buildRequestDetail('حالة الطلب', 'سيكون معلق'), _buildRequestDetail('وقت الاستجابة المتوقع', '24-48 ساعة')]),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor()))), ElevatedButton(onPressed: () { _sendMaintenanceReportRequest(reportType); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: _primaryColor, foregroundColor: Colors.white), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.send_rounded, size: 18), SizedBox(width: 8), Text('إرسال الطلب')]))],
      ),
    );
  }

  Widget _buildRequestDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [SizedBox(width: 120, child: Text('$label:', style: TextStyle(fontWeight: FontWeight.w600, color: _textColor(), fontSize: 12))), Expanded(child: Text(value, style: TextStyle(color: _textSecondaryColor(), fontSize: 12)))]),
    );
  }

  void _sendMaintenanceReportRequest(String reportType) {
    setState(() {
      _maintenanceReportRequests.insert(0, {
        'id': 'MNT-REQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(8, 12)}',
        'type': reportType,
        'title': 'طلب تقرير صيانة $reportType',
        'requestedBy': 'مسؤول المحطة',
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'status': 'معلق',
        'priority': 'عادي',
        'dueDate': DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1))),
        'description': 'تقرير مفصل عن أعمال الصيانة $reportType',
      });
    });
    _showSuccessMessage('تم إرسال طلب التقرير $reportType بنجاح');
  }

  Widget _buildMaintenanceEmptyRequests() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(color: _backgroundColor(), borderRadius: BorderRadius.circular(12), border: Border.all(color: _borderColor().withOpacity(0.5), width: 1.5)),
      child: Column(children: [Icon(Icons.send_rounded, size: 48, color: _textSecondaryColor()), SizedBox(height: 12), Text('لا توجد طلبات تقارير', style: TextStyle(fontSize: 16, color: _textSecondaryColor(), fontWeight: FontWeight.bold)), SizedBox(height: 8), Text('يمكنك إرسال طلب تقرير باستخدام الأزرار أعلاه', textAlign: TextAlign.center, style: TextStyle(color: _textSecondaryColor()))]),
    );
  }

  Widget _buildMaintenanceReceivedReportsSection() {
    return Container(
      decoration: BoxDecoration(color: _cardColor(), borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor())),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: _successColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.inbox_rounded, color: _successColor, size: 24)), SizedBox(width: 12), Text('التقارير الواردة من فني الصيانة', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textColor())), Spacer(), Badge(label: Text('${_maintenanceReceivedReports.where((r) => !r['read']).length}'), backgroundColor: _primaryColor, child: Icon(Icons.notifications_rounded, color: _primaryColor))]),
            SizedBox(height: 20),
            _buildMaintenanceReportFilter(),
            SizedBox(height: 20),
            if (_maintenanceReceivedReports.isEmpty) _buildMaintenanceEmptyReports() else Column(children: _getFilteredMaintenanceReports().map((report) => _buildMaintenanceReceivedReportItem(report)).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceReportFilter() {
    List<String> filters = ['الكل', 'يومي', 'أسبوعي', 'شهري', 'خاص'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          bool isSelected = _maintenanceReportFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) => setState(() => _maintenanceReportFilter = filter),
              selectedColor: _primaryColor.withOpacity(0.2),
              checkmarkColor: _primaryColor,
              labelStyle: TextStyle(color: isSelected ? _primaryColor : _textColor(), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: isSelected ? _primaryColor : _borderColor())),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredMaintenanceReports() {
    if (_maintenanceReportFilter == 'الكل') return _maintenanceReceivedReports;
    return _maintenanceReceivedReports.where((report) => report['type'] == _maintenanceReportFilter).toList();
  }

  Widget _buildMaintenanceReceivedReportItem(Map<String, dynamic> report) {
    Color statusColor = _getMaintenanceReportStatusColor(report['status']);
    Color priorityColor = _getMaintenancePriorityColor(report['priority']);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: _backgroundColor(), borderRadius: BorderRadius.circular(12), border: Border.all(color: _borderColor())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(children: [if (!report['read']) Container(width: 8, height: 8, margin: EdgeInsets.only(right: 8), decoration: BoxDecoration(color: _primaryColor, shape: BoxShape.circle)), Expanded(child: Text(report['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor()), maxLines: 2, overflow: TextOverflow.ellipsis))]),
              ),
              Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: statusColor.withOpacity(0.3))), child: Text(report['status'], style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold))),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(Icons.person_rounded, size: 14, color: _textSecondaryColor()), SizedBox(width: 4), Text('المرسل:', style: TextStyle(fontSize: 12, color: _textSecondaryColor()))]), SizedBox(height: 2), Text(report['sender'], style: TextStyle(fontSize: 13, color: _textColor(), fontWeight: FontWeight.w600))])),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(Icons.calendar_today_rounded, size: 14, color: _textSecondaryColor()), SizedBox(width: 4), Text('التاريخ:', style: TextStyle(fontSize: 12, color: _textSecondaryColor()))]), SizedBox(height: 2), Text('${report['date']} ${report['time']}', style: TextStyle(fontSize: 13, color: _textColor(), fontWeight: FontWeight.w600))])),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)), child: Row(children: [Icon(Icons.description_rounded, size: 12, color: _primaryColor), SizedBox(width: 4), Text(report['type'], style: TextStyle(fontSize: 11, color: _primaryColor))])),
              SizedBox(width: 8),
              Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: priorityColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: priorityColor.withOpacity(0.3))), child: Row(children: [Icon(Icons.priority_high_rounded, size: 12, color: priorityColor), SizedBox(width: 4), Text(report['priority'], style: TextStyle(fontSize: 11, color: priorityColor, fontWeight: FontWeight.bold))])),
              Spacer(),
              Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: _backgroundColor(), borderRadius: BorderRadius.circular(6), border: Border.all(color: _borderColor())), child: Text(report['size'], style: TextStyle(fontSize: 11, color: _textSecondaryColor()))),
            ],
          ),
          SizedBox(height: 12),
          Text(report['summary'], style: TextStyle(fontSize: 13, color: _textSecondaryColor(), height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: OutlinedButton.icon(onPressed: () => _viewMaintenanceReport(report), style: OutlinedButton.styleFrom(foregroundColor: _primaryColor, side: BorderSide(color: _primaryColor)), icon: Icon(Icons.remove_red_eye_rounded, size: 16), label: Text('عرض التقرير',style: TextStyle(fontSize:11),))),
              SizedBox(width: 8),
              Expanded(child: ElevatedButton.icon(onPressed: () => _downloadMaintenanceReport(report), style: ElevatedButton.styleFrom(backgroundColor: _primaryColor, foregroundColor: Colors.white), icon: Icon(Icons.download_rounded, size: 16), label: Text('تحميل',style: TextStyle(fontSize:11),))),
              SizedBox(width: 8),
              IconButton(onPressed: () => _showMaintenanceReportOptions(report), icon: Icon(Icons.more_vert_rounded, color: _primaryColor)),
            ],
          ),
        ],
      ),
    );
  }

  Color _getMaintenanceReportStatusColor(String status) {
    switch (status) { case 'جديد': return _primaryColor; case 'مكتمل': return _successColor; case 'قيد المراجعة': return _warningColor; case 'مرفوض': return _errorColor; default: return _textSecondaryColor(); }
  }

  Color _getMaintenancePriorityColor(String priority) {
    switch (priority) { case 'عالي': return _errorColor; case 'متوسط': return _warningColor; case 'عادي': return _successColor; default: return _textSecondaryColor(); }
  }

  void _viewMaintenanceReport(Map<String, dynamic> report) {
    setState(() => report['read'] = true);
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
              Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: _primaryColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))), child: Row(children: [Icon(Icons.engineering_rounded, color: Colors.white), SizedBox(width: 12), Expanded(child: Text(report['title'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)))])),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildViewDetail('المرسل', report['sender']), _buildViewDetail('نوع التقرير', report['type']), _buildViewDetail('التاريخ', '${report['date']} ${report['time']}'), _buildViewDetail('الأولوية', report['priority']), _buildViewDetail('حجم الملف', report['size']), _buildViewDetail('الصيغة', report['format']), SizedBox(height: 16), Divider(color: _borderColor()), SizedBox(height: 16), Text('ملخص التقرير', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _primaryColor)), SizedBox(height: 8), Text(report['summary'], style: TextStyle(color: _textColor(), height: 1.6)), if (report['attachments'] > 0) ...[SizedBox(height: 16), Text('المرفقات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _primaryColor)), SizedBox(height: 8), Text('عدد المرفقات: ${report['attachments']}', style: TextStyle(color: _textSecondaryColor()))]]),
                ),
              ),
              Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(border: Border(top: BorderSide(color: _borderColor()))), child: Row(children: [Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: Text('إغلاق'))), SizedBox(width: 12), Expanded(child: ElevatedButton.icon(onPressed: () { Navigator.pop(context); _downloadMaintenanceReport(report); }, icon: Icon(Icons.download_rounded), label: Text('تحميل التقرير')))])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [SizedBox(width: 80, child: Text('$label:', style: TextStyle(fontWeight: FontWeight.bold, color: _textColor()))), Expanded(child: Text(value, style: TextStyle(color: _textSecondaryColor())))]),
    );
  }

  void _downloadMaintenanceReport(Map<String, dynamic> report) {
    _showSuccessMessage('جاري تحميل التقرير: ${report['title']}');
  }

  void _showMaintenanceReportOptions(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardColor(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: Icon(Icons.share_rounded, color: _primaryColor), title: Text('مشاركة التقرير'), onTap: () { Navigator.pop(context); _shareMaintenanceReport(report); }),
            ListTile(leading: Icon(Icons.archive_rounded, color: _primaryColor), title: Text('أرشفة التقرير'), onTap: () { Navigator.pop(context); _archiveMaintenanceReport(report); }),
            ListTile(leading: Icon(Icons.delete_rounded, color: _errorColor), title: Text('حذف التقرير', style: TextStyle(color: _errorColor)), onTap: () { Navigator.pop(context); _deleteMaintenanceReport(report); }),
            SizedBox(height: 8),
            OutlinedButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ],
        ),
      ),
    );
  }

  void _shareMaintenanceReport(Map<String, dynamic> report) {
    _showSuccessMessage('تم إعداد التقرير للمشاركة: ${report['title']}');
  }

  void _archiveMaintenanceReport(Map<String, dynamic> report) {
    setState(() => _maintenanceReceivedReports.remove(report));
    _showSuccessMessage('تم أرشفة التقرير');
  }

  void _deleteMaintenanceReport(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(),
        title: Row(children: [Icon(Icons.delete_rounded, color: _errorColor), SizedBox(width: 8), Text('حذف التقرير')]),
        content: Text('هل أنت متأكد من حذف التقرير "${report['title']}"؟'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')), ElevatedButton(onPressed: () { setState(() => _maintenanceReceivedReports.remove(report)); Navigator.pop(context); _showSuccessMessage('تم حذف التقرير'); }, style: ElevatedButton.styleFrom(backgroundColor: _errorColor, foregroundColor: Colors.white), child: Text('حذف'))],
      ),
    );
  }

  Widget _buildMaintenanceEmptyReports() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(color: _backgroundColor(), borderRadius: BorderRadius.circular(12), border: Border.all(color: _borderColor())),
      child: Column(children: [Icon(Icons.inbox_rounded, size: 48, color: _textSecondaryColor()), SizedBox(height: 12), Text('لا توجد تقارير واردة', style: TextStyle(fontSize: 16, color: _textSecondaryColor(), fontWeight: FontWeight.bold)), SizedBox(height: 8), Text('سيظهر هنا التقارير المرسلة من فني الصيانة', textAlign: TextAlign.center, style: TextStyle(color: _textSecondaryColor()))]),
    );
  }
  final List<Map<String, dynamic>> _reports = [
    {
      'id': 'RPT-001',
      'title': 'انقطاع التيار الكهربائي',
      'description': 'انقطاع التيار الكهربائي في منطقة المنصور منذ 3 ساعات',
      'citizenName': 'أحمد محمد',
      'phone': '07801234567',
      'location': 'المنصور - شارع 14 رمضان',
      'date': '2024-03-20',
      'time': '08:30 ص',
      'status': 'جديد',
      'priority': 'عاجل',
      'type': 'انقطاع',
      'images': 2,
      'assignedTo': '',
      'responseTime': '',
    },
    {
      'id': 'RPT-002',
      'title': 'عطل في المحول',
      'description': 'المحول الكهربائي في منطقة الكرادة يصدر أصوات غريبة',
      'citizenName': 'فاطمة علي',
      'phone': '07811223344',
      'location': 'الكرادة - شارع العروبة',
      'date': '2024-03-20',
      'time': '10:15 ص',
      'status': 'قيد المعالجة',
      'priority': 'عالي',
      'type': 'عطل فني',
      'images': 1,
      'assignedTo': 'فني صيانة',
      'responseTime': '30 دقيقة',
    },
    {
      'id': 'RPT-003',
      'title': 'تلف عداد الكهرباء',
      'description': 'عداد الكهرباء في منزلي لا يعمل بشكل صحيح',
      'citizenName': 'خالد إبراهيم',
      'phone': '07805566778',
      'location': 'الزعفرانية - حي العامل',
      'date': '2024-03-19',
      'time': '04:45 م',
      'status': 'تمت المعالجة',
      'priority': 'متوسط',
      'type': 'عداد',
      'images': 3,
      'assignedTo': 'فني عدادات',
      'responseTime': 'ساعتان',
      'completedDate': '2024-03-20',
    },
    {
      'id': 'RPT-004',
      'title': 'تذبذب الجهد الكهربائي',
      'description': 'الجهد الكهربائي في منطقتنا غير مستقر ويؤدي إلى تلف الأجهزة',
      'citizenName': 'سارة عبدالله',
      'phone': '07809988776',
      'location': 'اليرموك - مجمع 605',
      'date': '2024-03-20',
      'time': '01:30 م',
      'status': 'جديد',
      'priority': 'عاجل',
      'type': 'جودة',
      'images': 0,
      'assignedTo': '',
      'responseTime': '',
    },
    {
      'id': 'RPT-005',
      'title': 'سقوط عمود كهرباء',
      'description': 'عمود كهرباء سقط بجانب مدرسة النور في منطقة الشعلة',
      'citizenName': 'محمد حسين',
      'phone': '07812349876',
      'location': 'الشعلة - قرب مدرسة النور',
      'date': '2024-03-19',
      'time': '11:20 م',
      'status': 'قيد المعالجة',
      'priority': 'عاجل',
      'type': 'طوارئ',
      'images': 4,
      'assignedTo': 'فريق الطوارئ',
      'responseTime': '15 دقيقة',
    },
  ];  

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [Icon(Icons.check_circle_rounded, color: Colors.white), SizedBox(width: 8), Expanded(child: Text(message))]),
        backgroundColor: _successColor,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredBills() {
    switch (_billFilter) {
      case 'مدفوعة': return bills.where((bill) => bill['status'] == 'paid').toList();
      case 'غير مدفوعة': return bills.where((bill) => bill['status'] == 'unpaid').toList();
      case 'متأخرة': return bills.where((bill) => bill['status'] == 'overdue').toList();
      default: return bills;
    }
  }

  Color _getBillStatusColor(String status) {
    switch (status) { case 'paid': return _successColor; case 'unpaid': return _warningColor; case 'overdue': return _errorColor; default: return _textSecondaryColor(); }
  }

  String _getBillStatusText(String status) {
    switch (status) { case 'paid': return 'مدفوعة'; case 'unpaid': return 'غير مدفوعة'; case 'overdue': return 'متأخرة'; default: return 'غير معروف'; }
  }

  void _showPaymentMethodDetails(Map<String, dynamic> method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(),
        title: Text('تفاصيل طريقة الدفع'),
        content: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildDetailRow('اسم الطريقة:', method['name']), _buildDetailRow('إجمالي المبالغ:', '${_formatCurrency(method['totalAmount'])}'), _buildDetailRow('عدد التحويلات:', method['totalTransfers'].toString()), SizedBox(height: 16), Text('الحسابات البنكية:', style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height: 8), ...method['bankAccounts'].map<Widget>((account) => Container(margin: EdgeInsets.only(bottom: 8), padding: EdgeInsets.all(8), decoration: BoxDecoration(color: _backgroundColor(), borderRadius: BorderRadius.circular(8)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(account['bankName'], style: TextStyle(fontWeight: FontWeight.w600)), SizedBox(height: 4), Text('اسم الحساب: ${account['accountName']}'), Text('رقم الحساب: ${account['accountNumber']}')]))).toList()]),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('إغلاق'))],
      ),
    );
  }

  void _showCitizenDetails(Map<String, dynamic> citizen) {
    List<Map<String, dynamic>> citizenBills = bills.where((bill) => bill['citizenName'] == citizen['name']).toList();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(),
        title: Text('تفاصيل المواطن'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              _buildDetailRow('الاسم:', citizen['name']), 
              _buildDetailRow('الحالة:', citizen['isPaying'] ? 'مدفع' : 'غير مدفع'), 
              _buildDetailRow('عدد الفواتير:', citizen['totalBills'].toString()), 
              _buildDetailRow('إجمالي المبالغ:', '${_formatCurrency(citizen['totalAmount'])}'), 
              _buildDetailRow('آخر دفع:', citizen['lastPayment']), 
              if (citizenBills.isNotEmpty) ...[
                SizedBox(height: 16), 
                Text('فواتير المواطن:', style: TextStyle(fontWeight: FontWeight.bold)), 
                ...citizenBills.map<Widget>((bill) => Container(
                  margin: EdgeInsets.only(bottom: 8), 
                  padding: EdgeInsets.all(8), 
                  decoration: BoxDecoration(
                    color: _cardColor(), 
                    borderRadius: BorderRadius.circular(8)
                  ), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                        children: [
                          Text(bill['id'], style: TextStyle(fontWeight: FontWeight.w600)), 
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2), 
                            decoration: BoxDecoration(
                              color: _getBillStatusColor(bill['status']).withOpacity(0.1), 
                              borderRadius: BorderRadius.circular(4)
                            ), 
                            child: Text(
                              _getBillStatusText(bill['status']), 
                              style: TextStyle(
                                fontSize: 10, 
                                color: _getBillStatusColor(bill['status'])
                              )
                            )
                          )
                        ]
                      ), 
                      SizedBox(height: 4), 
                      Text('المبلغ: ${_formatCurrency(bill['amountIQD'])}'), 
                      Text('الاستهلاك: ${bill['consumption']}'), 
                      Text('طريقة الدفع: ${bill['paymentMethod']}')
                    ]
                  )
                )).toList()
              ]
            ]
          )
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('إغلاق')
          )
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 100, child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: _textColor()))), Expanded(child: Text(value, style: TextStyle(color: _textSecondaryColor())))]),
    );
  }

  void _generateReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(),
        title: Text('إنشاء تقرير جديد'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [Text('سيتم إنشاء تقرير ${_selectedReportType} جديد'), SizedBox(height: 16), Text('هل تريد المتابعة؟')]),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')), ElevatedButton(onPressed: () { Navigator.pop(context); _showSuccessMessage('تم إنشاء التقرير بنجاح'); }, child: Text('تأكيد'))],
      ),
    );
  }

  Widget _buildSystemSupervisorDrawer(BuildContext context, bool isDarkMode) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: isDarkMode ? [_darkPrimaryColor, Color(0xFF0D1B0E)] : [_primaryColor, Color(0xFF4CAF50)])),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: isDarkMode ? [_darkPrimaryColor, Color(0xFF1B5E20)] : [_primaryColor, Color(0xFF388E3C)])),
              child: Column(
                children: [
                  CircleAvatar(radius: 40, backgroundColor: Colors.white.withOpacity(0.2), child: Icon(Icons.engineering_rounded, color: Colors.white, size: 40)),
                  SizedBox(height: 16),
                  Text("مسؤول المحطة", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                  SizedBox(height: 4),
                  Text("مدير محطة كهرباء", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16), textAlign: TextAlign.center),
                  SizedBox(height: 8),
                  Container(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: Text("المحطة المركزية", style: TextStyle(color: Colors.white, fontSize: 14))),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: isDarkMode ? Color(0xFF0D1B0E) : Color(0xFFE8F5E9), 
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
                      isDarkMode: isDarkMode
                    ), 
                    _buildDrawerMenuItem(
                      icon: Icons.logout_rounded, 
                      title: 'تسجيل الخروج', 
                      onTap: () => _showLogoutConfirmation(context), 
                      isDarkMode: isDarkMode, 
                      isLogout: true
                    ), 
                    SizedBox(height: 40), 
                    Container(
                      padding: EdgeInsets.all(16), 
                      child: Column(
                        children: [
                          Divider(
                            color: isDarkMode ? Colors.white24 : Colors.grey[400], 
                            height: 1
                          ), 
                          SizedBox(height: 16), 
                          Text(
                            'وزارة الكهرباء - نظام مسؤول المحطة', 
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.grey[700], 
                              fontSize: 12, 
                              fontWeight: FontWeight.w500
                            ), 
                            textAlign: TextAlign.center
                          ), 
                          SizedBox(height: 4), 
                          Text(
                            'الإصدار 1.0.0', 
                            style: TextStyle(
                              color: isDarkMode ? Colors.white54 : Colors.grey[600], 
                              fontSize: 10
                            ), 
                            textAlign: TextAlign.center
                          )
                        ]
                      )
                    )
                  ]
                )
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerMenuItem({required IconData icon, required String title, required VoidCallback onTap, required bool isDarkMode, bool isLogout = false}) {
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color iconColor = isLogout ? Colors.red : (isDarkMode ? Colors.white70 : Colors.grey[700]!);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: isLogout ? Colors.red.withOpacity(0.1) : Colors.transparent),
      child: ListTile(
        leading: Container(width: 36, height: 36, decoration: BoxDecoration(color: isLogout ? Colors.red.withOpacity(0.2) : (isDarkMode ? Colors.white12 : Colors.grey[100]), shape: BoxShape.circle), child: Icon(icon, color: iconColor, size: 20)),
        title: Text(title, style: TextStyle(color: isLogout ? Colors.red : textColor, fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.arrow_left_rounded, color: isLogout ? Colors.red : (isDarkMode ? Colors.white54 : Colors.grey[500]), size: 24),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [Icon(Icons.logout_rounded, color: _errorColor), SizedBox(width: 8), Text('تأكيد تسجيل الخروج')]),
        content: Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟', style: TextStyle(color: Colors.black87)),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء', style: TextStyle(color: _accentColor))), ElevatedButton(onPressed: () { Navigator.pop(context); _performLogout(context); }, style: ElevatedButton.styleFrom(backgroundColor: _errorColor, foregroundColor: Colors.white), child: Text('تسجيل الخروج'))],
      ),
    );
  }

  void _performLogout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [Icon(Icons.check_circle_rounded, color: Colors.white), SizedBox(width: 8), Text('تم تسجيل الخروج بنجاح')]), backgroundColor: _successColor, duration: Duration(seconds: 2)));
    Navigator.pushReplacementNamed(context, EsigninScreen.screenroot);
  }

  void _showSettingsScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SupervisorSettingsScreen(primaryColor: _primaryColor, secondaryColor: _secondaryColor, accentColor: _accentColor, successColor: _successColor, warningColor: _warningColor, errorColor: _errorColor)));
  }

  Color _textSecondaryColor() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Colors.white70 : Color(0xFF757575);
  }

  Color _cardColor() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
  }

  Color _borderColor() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0);
  }

  Color _backgroundColor() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Color(0xFF121212) : Color(0xFFF0F8FF);
  }
}

// RefreshController helper class
class RefreshController {
  void refreshCompleted() {}
  void dispose() {}
}

class SupervisorSettingsScreen extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;

  const SupervisorSettingsScreen({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.successColor,
    required this.warningColor,
    required this.errorColor,
  }) : super(key: key);

  @override
  State<SupervisorSettingsScreen> createState() => _SupervisorSettingsScreenState();
}

class _SupervisorSettingsScreenState extends State<SupervisorSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = false;
  bool _autoBackup = true;
  bool _biometricAuth = false;
  bool _autoSync = true;
  String _language = 'العربية';
  final List<String> _languages = ['العربية', 'English'];

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم حفظ الإعدادات بنجاح'), backgroundColor: widget.successColor));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('الإعدادات', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.white)),
        backgroundColor: widget.primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
        actions: [IconButton(icon: Icon(Icons.save_rounded, color: Colors.white), onPressed: _saveSettings)],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: themeProvider.isDarkMode ? LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF121212), Color(0xFF1A1A1A)]) : LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFF5F5F5), Color(0xFFE8F5E8)])),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDarkModeSwitch(context),
              _buildSettingsSection('الإشعارات', Icons.notifications_rounded, isDarkMode),
              _buildSettingSwitch('تفعيل الإشعارات', 'استلام إشعارات حول الفواتير والتحديثات', _notificationsEnabled, (bool value) => setState(() => _notificationsEnabled = value), isDarkMode),
              _buildSettingSwitch('الصوت', 'تشغيل صوت للإشعارات الواردة', _soundEnabled, (bool value) => setState(() => _soundEnabled = value), isDarkMode),
              _buildSettingSwitch('الاهتزاز', 'اهتزاز الجهاز عند استلام الإشعارات', _vibrationEnabled, (bool value) => setState(() => _vibrationEnabled = value), isDarkMode),
              SizedBox(height: 24),
              _buildSettingsSection('المظهر', Icons.palette_rounded, isDarkMode),
              _buildDarkModeSwitch(context),
              _buildSettingDropdown('اللغة', _language, _languages, (String? value) => setState(() => _language = value!), isDarkMode),
              SizedBox(height: 24),
              _buildSettingsSection('الأمان والبيانات', Icons.security_rounded, isDarkMode),
              _buildSettingSwitch('النسخ الاحتياطي التلقائي', 'نسخ احتياطي تلقائي للبيانات', _autoBackup, (bool value) => setState(() => _autoBackup = value), isDarkMode),
              _buildSettingSwitch('المصادقة البيومترية', 'استخدام بصمة الإصبع أو التعرف على الوجه', _biometricAuth, (bool value) => setState(() => _biometricAuth = value), isDarkMode),
              _buildSettingSwitch('المزامنة التلقائية', 'مزامنة البيانات تلقائياً مع السحابة', _autoSync, (bool value) => setState(() => _autoSync = value), isDarkMode),
              SizedBox(height: 24),
              _buildSettingsSection('حول التطبيق', Icons.info_rounded, isDarkMode),
              _buildAboutCard(isDarkMode),
              SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(onPressed: _saveSettings, style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text('حفظ الإعدادات')),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, IconData icon, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: widget.primaryColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: widget.primaryColor, size: 22)), SizedBox(width: 12), Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDarkMode ? Colors.white : Colors.black87))]),
    );
  }

  Widget _buildDarkModeSwitch(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: Offset(0, 2))]),
      child: Row(
        children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: isDarkMode ? Colors.amber.withOpacity(0.2) : Colors.grey.withOpacity(0.2), shape: BoxShape.circle), child: Icon(isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: isDarkMode ? Colors.amber : Colors.grey, size: 22)),
          SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('الوضع الداكن', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: isDarkMode ? Colors.white : Colors.black87)), SizedBox(height: 4), Text(isDarkMode ? 'مفعل - استمتع بتجربة مريحة للعين' : 'معطل - استمتع بالمظهر الافتراضي', style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.white70 : Colors.grey[600]))])),
          Switch(value: isDarkMode, onChanged: (value) => themeProvider.toggleTheme(value), activeColor: Colors.amber, activeTrackColor: Colors.amber.withOpacity(0.5), inactiveThumbColor: Colors.grey, inactiveTrackColor: Colors.grey.withOpacity(0.5)),
        ],
      ),
    );
  }

  Widget _buildSettingSwitch(String title, String subtitle, bool value, Function(bool) onChanged, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: Offset(0, 2))]),
      child: Row(
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: isDarkMode ? Colors.white : Colors.black87)), SizedBox(height: 4), Text(subtitle, style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.white70 : Colors.grey[600]))])),
          Switch(value: value, onChanged: onChanged, activeColor: widget.primaryColor),
        ],
      ),
    );
  }

  Widget _buildSettingDropdown(String title, String value, List<String> items, Function(String?) onChanged, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: Offset(0, 2))]),
      child: Row(
        children: [
          Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: isDarkMode ? Colors.white : Colors.black87))),
          SizedBox(width: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: isDarkMode ? Colors.white10 : Colors.grey[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: widget.primaryColor.withOpacity(0.3))),
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String item) => DropdownMenuItem<String>(value: item, child: Text(item, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)))).toList(),
              underline: SizedBox(),
              icon: Icon(Icons.arrow_drop_down_rounded, color: widget.primaryColor),
              dropdownColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: Offset(0, 2))]),
      child: Column(children: [_buildAboutRow('الإصدار', '1.0.0', isDarkMode), _buildAboutRow('تاريخ البناء', '2024-03-20', isDarkMode), _buildAboutRow('المطور', 'وزارة الكهرباء - العراق', isDarkMode), _buildAboutRow('رقم الترخيص', 'MOE-SUP-2024-001', isDarkMode), _buildAboutRow('آخر تحديث', '2024-03-15', isDarkMode), _buildAboutRow('البريد الإلكتروني', 'supervisor@electric.gov.iq', isDarkMode)]),
    );
  }

  Widget _buildAboutRow(String title, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isDarkMode ? Colors.white : Colors.black87)), Text(value, style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey[600]))]),
    );
  }
}

class SupervisorNotificationsScreen extends StatefulWidget {
  static const String routeName = '/supervisor-notifications';

  @override
  _SupervisorNotificationsScreenState createState() => _SupervisorNotificationsScreenState();
}

class _SupervisorNotificationsScreenState extends State<SupervisorNotificationsScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['الصيانة', 'الفواتير', 'البلاغات', 'الكل'];
  final RefreshController _notificationsRefreshController = RefreshController();
  
  final Color _primaryColor = Color.fromARGB(255, 46, 30, 169);
  final Color _secondaryColor = Color(0xFFD4AF37);
  final Color _successColor = Color(0xFF2E7D32);
  final Color _warningColor = Color(0xFFF57C00);
  final Color _errorColor = Color(0xFFD32F2F);
  final Color _accentColor = Color(0xFF8D6E63);
  
  final List<Map<String, dynamic>> _allNotifications = [
    {
      'id': '1',
      'type': 'maintenance',
      'title': 'مهمة صيانة جديدة',
      'description': 'تم تعيين مهمة صيانة جديدة للمحول الرئيسي في المنطقة الشمالية',
      'time': 'منذ 10 دقائق',
      'read': false,
      'tab': 0,
      'icon': Icons.engineering_rounded,
      'color': Color(0xFF2E7D32),
      'priority': 'عالي',
    },
    {
      'id': '2',
      'type': 'maintenance_complete',
      'title': 'اكتمال مهمة صيانة',
      'description': 'اكتملت مهمة صيانة خط الكهرباء في المنطقة الجنوبية',
      'time': 'منذ ساعة',
      'read': true,
      'tab': 0,
      'icon': Icons.check_circle_rounded,
      'color': Color(0xFF2E7D32),
      'priority': 'متوسط',
    },
    {
      'id': '3',
      'type': 'maintenance_delay',
      'title': 'تأخير في مهمة صيانة',
      'description': 'تأخرت مهمة تركيب المحول الجديد بسبب انتظار قطع الغيار',
      'time': 'منذ 3 ساعات',
      'read': false,
      'tab': 0,
      'icon': Icons.warning_rounded,
      'color': Color(0xFFF57C00),
      'priority': 'عاجل',
    },
    {
      'id': '4',
      'type': 'technician_report',
      'title': 'تقرير فني جديد',
      'description': 'وصل تقرير جديد من الفني حسن عبدالله بخصوص صيانة المحطة 5',
      'time': 'منذ 5 ساعات',
      'read': true,
      'tab': 0,
      'icon': Icons.description_rounded,
      'color': Color(0xFF8D6E63),
      'priority': 'متوسط',
    },
    {
      'id': '5',
      'type': 'bill_overdue',
      'title': 'فواتير متأخرة',
      'description': 'هناك 3 فواتير متأخرة بحاجة إلى متابعة',
      'time': 'منذ 30 دقيقة',
      'read': false,
      'tab': 1,
      'icon': Icons.warning_amber_rounded,
      'color': Color(0xFFD32F2F),
      'priority': 'عالي',
    },
    {
      'id': '6',
      'type': 'bill_paid',
      'title': 'دفع فواتير',
      'description': 'تم دفع فاتورتين بقيمة إجمالية 186,813 دينار',
      'time': 'منذ ساعتين',
      'read': true,
      'tab': 1,
      'icon': Icons.payment_rounded,
      'color': Color(0xFF2E7D32),
      'priority': 'عادي',
    },
    {
      'id': '7',
      'type': 'bill_report',
      'title': 'تقرير فواتير جديد',
      'description': 'تقرير الفواتير اليومي متاح للعرض من قسم المحاسبة',
      'time': 'منذ 4 ساعات',
      'read': false,
      'tab': 1,
      'icon': Icons.receipt_long_rounded,
      'color': Color(0xFF2E7D32),
      'priority': 'متوسط',
    },
    {
      'id': '8',
      'type': 'report_new',
      'title': 'بلاغ جديد',
      'description': 'بلاغ جديد عن انقطاع التيار في منطقة المنصور',
      'time': 'منذ 15 دقيقة',
      'read': false,
      'tab': 2,
      'icon': Icons.report_problem_rounded,
      'color': Color(0xFFD32F2F),
      'priority': 'عاجل',
    },
    {
      'id': '9',
      'type': 'report_processed',
      'title': 'تمت معالجة بلاغ',
      'description': 'تمت معالجة بلاغ عطل المحول في منطقة الكرادة',
      'time': 'منذ ساعة',
      'read': true,
      'tab': 2,
      'icon': Icons.check_circle_rounded,
      'color': Color(0xFF2E7D32),
      'priority': 'عالي',
    },
    {
      'id': '10',
      'type': 'report_urgent',
      'title': 'بلاغ طارئ',
      'description': 'سقوط عمود كهرباء في منطقة الشعلة - بحاجة إلى تدخل فوري',
      'time': 'منذ 25 دقيقة',
      'read': false,
      'tab': 2,
      'icon': Icons.warning_rounded,
      'color': Color(0xFFD32F2F),
      'priority': 'عاجل',
    },
    {
      'id': '11',
      'type': 'report_followup',
      'title': 'متابعة بلاغ',
      'description': 'بلاغ تذبذب الجهد في اليرموك بحاجة إلى متابعة',
      'time': 'منذ 3 ساعات',
      'read': true,
      'tab': 2,
      'icon': Icons.follow_the_signs_rounded,
      'color': Color(0xFFF57C00),
      'priority': 'متوسط',
    },
    {
      'id': '12',
      'type': 'system',
      'title': 'تحديث النظام',
      'description': 'تم تحديث نظام إدارة المحطة إلى الإصدار 2.1.0',
      'time': 'منذ يوم',
      'read': true,
      'tab': 3,
      'icon': Icons.system_update_rounded,
      'color': Color(0xFF2E7D32),
      'priority': 'عادي',
    },
    {
      'id': '13',
      'type': 'meeting',
      'title': 'اجتماع المدراء',
      'description': 'اجتماع دوري لمدراء المحطات يوم الأحد القادم الساعة 10 صباحاً',
      'time': 'منذ يومين',
      'read': true,
      'tab': 3,
      'icon': Icons.meeting_room_rounded,
      'color': Color(0xFF8D6E63),
      'priority': 'متوسط',
    },
  ];

  Future<void> _refreshNotifications() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {});
    _notificationsRefreshController.refreshCompleted();
  }

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedTab == 3) {
      return _allNotifications;
    }
    return _allNotifications.where((notification) => notification['tab'] == _selectedTab).toList();
  }

  int get _unreadCount {
    return _allNotifications.where((n) => !n['read']).length;
  }

  @override
  void dispose() {
    _notificationsRefreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'الإشعارات',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            if (_unreadCount > 0)
              Container(
                margin: EdgeInsets.only(right: 8),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _secondaryColor,
                  borderRadius: BorderRadius.circular(12),
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
        backgroundColor: isDarkMode ? Color(0xFF1B5E20) : _primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.done_all_rounded, color: Colors.white),
            onPressed: _markAllAsRead,
            tooltip: 'تحديد الكل كمقروء',
          ),
        ],
      ),
      body: RefreshIndicator(
        key: const Key('notifications_refresh'),
        onRefresh: _refreshNotifications,
        color: _primaryColor,
        backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
                border: Border(
                  bottom: BorderSide(color: isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0)),
                ),
              ),
              child: Row(
                children: [
                  for (int i = 0; i < _tabs.length; i++)
                    _buildTabButton(_tabs[i], i, isDarkMode),
                ],
              ),
            ),

            Expanded(
              child: _filteredNotifications.isEmpty
                  ? _buildEmptyState(isDarkMode)
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: _filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = _filteredNotifications[index];
                        return _buildNotificationCard(notification, isDarkMode);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index, bool isDarkMode) {
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
                color: isSelected ? _primaryColor : (isDarkMode ? Colors.white70 : Color(0xFF757575)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, bool isDarkMode) {
    final bool isRead = notification['read'];
    final Color cardColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Color(0xFF212121);
    final Color textSecondaryColor = isDarkMode ? Colors.white70 : Color(0xFF757575);
    final Color borderColor = isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0);
    
    return InkWell(
      onTap: () => _markAsRead(notification),
      child: Container(
        color: isRead ? Colors.transparent : (isDarkMode ? _primaryColor.withOpacity(0.1) : Color(0xFFE8F5E9)),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: (notification['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      notification['icon'],
                      color: notification['color'],
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 12),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification['title'],
                                style: TextStyle(
                                  fontWeight: isRead ? FontWeight.normal : FontWeight.w700,
                                  fontSize: 16,
                                  color: textColor,
                                ),
                              ),
                            ),
                            if (!isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          notification['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: textSecondaryColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(notification['priority']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: _getPriorityColor(notification['priority']).withOpacity(0.3)),
                              ),
                              child: Text(
                                notification['priority'] ?? 'عادي',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _getPriorityColor(notification['priority']),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              notification['time'],
                              style: TextStyle(
                                fontSize: 12,
                                color: textSecondaryColor,
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
            Container(
              height: 1,
              color: borderColor,
              margin: EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'عاجل':
        return _errorColor;
      case 'عالي':
        return _warningColor;
      case 'متوسط':
        return _accentColor;
      case 'عادي':
      default:
        return _successColor;
    }
  }

  Widget _buildEmptyState(bool isDarkMode) {
    final Color textSecondaryColor = isDarkMode ? Colors.white70 : Color(0xFF757575);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_rounded,
            size: 64,
            color: textSecondaryColor,
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 18,
              color: textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'لا توجد إشعارات في التبويب المحدد',
            style: TextStyle(
              color: textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _markAsRead(Map<String, dynamic> notification) {
    if (!notification['read']) {
      setState(() {
        notification['read'] = true;
      });
    }
    
    _showNotificationDetails(notification);
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _allNotifications) {
        notification['read'] = true;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تحديد جميع الإشعارات كمقروءة'),
        backgroundColor: _successColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (notification['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      notification['icon'],
                      color: notification['color'],
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      notification['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Color(0xFF212121),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                notification['description'],
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white70 : Color(0xFF757575),
                ),
              ),
              SizedBox(height: 16),
              Divider(color: isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0)),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الوقت:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Color(0xFF212121),
                    ),
                  ),
                  Text(
                    notification['time'],
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Color(0xFF757575),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الأولوية:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Color(0xFF212121),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(notification['priority']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: _getPriorityColor(notification['priority']).withOpacity(0.3)),
                    ),
                    child: Text(
                      notification['priority'] ?? 'عادي',
                      style: TextStyle(
                        fontSize: 12,
                        color: _getPriorityColor(notification['priority']),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('إغلاق'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}