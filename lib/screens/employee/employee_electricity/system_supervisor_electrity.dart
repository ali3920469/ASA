import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mang_mu/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/screens/employee/Employee_Shared%20Services/esignin_screen.dart';
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
  int _selectedMaintenanceTab = 0; // 0: طلبات التقارير، 1: التقارير الواردة
  String _maintenanceReportFilter = 'الكل';
  bool _isDarkMode = false; // يمكن استبداله بـ Provider
  // الألوان الحكومية (أزرق وذهبي)
  final Color _primaryColor = Color.fromARGB(255, 46, 30, 169); // أزرق حكومي
  final Color _secondaryColor = Color(0xFFD4AF37); // ذهبي
  final Color _accentColor = Color(0xFF8D6E63); // بني
  final Color _successColor = Color(0xFF2E7D32);
  final Color _warningColor = Color(0xFFF57C00);
  final Color _errorColor = Color(0xFFD32F2F);

  // ألوان الوضع المظلم
  final Color _darkPrimaryColor = Color(0xFF1B5E20);
  
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
  Color _backgroundColor() {
  final themeProvider = Provider.of<ThemeProvider>(context);
  return themeProvider.isDarkMode ? Color(0xFF121212) : Color(0xFFF0F8FF);
}

Color _cardColor() {
  final themeProvider = Provider.of<ThemeProvider>(context);
  return themeProvider.isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
}

Color _textColor() {
  final themeProvider = Provider.of<ThemeProvider>(context);
  return themeProvider.isDarkMode ? Colors.white : Color(0xFF212121);
}
  Color _textSecondaryColor() {
      final themeProvider = Provider.of<ThemeProvider>(context);
    return  themeProvider.isDarkMode ? Colors.white70 : Color(0xFF757575);
  }
  
  Color _borderColor() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return themeProvider.isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0);
  }
  String _qualityReportFilter = 'الكل';

  // قوائم التقارير
  final List<String> _reportTypes = ['يومي', 'أسبوعي', 'شهري'];
  
  // بيانات الفواتير المحدثة
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
      ]
    },
  ];
  // قائمة طلبات التقارير للصيانة
List<Map<String, dynamic>> _maintenanceReportRequests = [
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

// قائمة التقارير الواردة للصيانة
List<Map<String, dynamic>> _maintenanceReceivedReports = [
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

  // بيانات طرق الدفع
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

  // بيانات التقارير داخل الفواتير
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

  // بيانات المواطنين داخل الفواتير (مبسطة)
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

  // فلاتر داخل الفواتير
  final List<String> _filters = ['الكل', 'مدفوعة', 'غير مدفوعة', 'متأخرة'];
  int _currentTabInBills = 0; // 0: الفواتير، 1: طرق الدفع، 2: المواطنين، 3: التقارير

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
              child: Icon(Icons.bolt_rounded, color: _primaryColor, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'مسؤول محطة الكهرباء ',
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
                    padding: EdgeInsets.all(2),
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
              // الذهاب إلى شاشة الإشعارات
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            color: _isDarkMode ? _darkPrimaryColor : _primaryColor,
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
                Tab(
                  icon: Icon(Icons.receipt_long_rounded, size: 22),
                  text: 'الفواتير',
                ),
                Tab(
                  icon: Icon(Icons.analytics_rounded, size: 22),
                  text: 'الاستهلاك',
                ),
                Tab(
                  icon: Icon(Icons.engineering_rounded, size: 22),
                  text: 'الصيانة',
                ),
                Tab(
                  icon: Icon(Icons.verified_user_rounded, size: 22),
                  text: 'الجودة',
                ),
                Tab(
                  icon: Icon(Icons.report_problem_rounded, size: 22),
                  text: 'البلاغات',
                ),
              ],
            ),
          ),
        ),
      ),
     drawer: _buildSystemSupervisorDrawer(context, isDarkMode), // ← مرر isDarkMode
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBillsTab(isDarkMode),
          _buildConsumptionTab(isDarkMode), 
          _buildMaintenanceTab(isDarkMode),
          _buildQualityTab(isDarkMode), 
          _buildReportsTab(isDarkMode), 
        ],
      ),

    );
  }

  // تبويب الفواتير الجديد
  Widget _buildBillsTab(bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شريط التبويبات الداخلية
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
          
          // المحتوى حسب التبويب المختار
           if (_currentTabInBills == 0) _buildBillsContent(isDarkMode),
        if (_currentTabInBills == 1) _buildPaymentMethodsContent(isDarkMode),
        if (_currentTabInBills == 2) _buildCitizensContent(isDarkMode),
        if (_currentTabInBills == 3) _buildReportsContent(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildInnerTabButton(String title, int index, bool isDarkMode) {
    bool isSelected = _currentTabInBills == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentTabInBills = index;
          });
        },
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
        // إحصائيات الفواتير
        _buildBillsStats(),
        SizedBox(height: 20),
        
        // فلتر الفواتير
        _buildBillsFilter(),
        SizedBox(height: 20),
        
        // قائمة الفواتير
        Text(
          'الفواتير الحالية',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        SizedBox(height: 12),
        
        ...filteredBills.map((bill) => _buildBillCard(bill)).toList(),
      ],
    );
  }

  Widget _buildPaymentMethodsContent(isDarkMode) {
    double totalAmount = paymentMethods.fold(0.0, (sum, method) => sum + (method['totalAmount'] ?? 0));
    int totalTransfers = paymentMethods.fold(0, (sum, method) => sum + (method['totalTransfers'] as int? ?? 0));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // إحصائيات طرق الدفع
        Container(
          decoration: BoxDecoration(
            color: _cardColor(),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor()),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('إجمالي المبالغ', _formatCurrency(totalAmount), Icons.attach_money_rounded, _primaryColor),
                    _buildStatCard('إجمالي التحويلات', totalTransfers.toString(), Icons.swap_horiz_rounded, _successColor),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('طرق الدفع', paymentMethods.length.toString(), Icons.payment_rounded, _secondaryColor),
                    _buildStatCard('الحسابات البنكية', '6', Icons.account_balance_rounded, _accentColor),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        
        // طرق الدفع المتاحة
        Text(
          'طرق الدفع المتاحة',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        SizedBox(height: 12),
        
        ...paymentMethods.map((method) => _buildPaymentMethodCard(method)),
        
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCitizensContent(isDarkMode) {
    int payingCitizens = citizens.where((citizen) => citizen['isPaying'] == true).length;
    int nonPayingCitizens = citizens.where((citizen) => citizen['isPaying'] == false).length;
    double totalAmount = citizens.fold(0.0, (sum, citizen) => sum + (citizen['totalAmount'] as int).toDouble());
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // إحصائيات المواطنين
        Container(
          decoration: BoxDecoration(
            color: _cardColor(),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor()),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('إجمالي المواطنين', citizens.length.toString(), Icons.people_rounded, _primaryColor),
                    _buildStatCard('إجمالي المبالغ', _formatCurrency(totalAmount), Icons.attach_money_rounded, _successColor),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('مدفوعين', payingCitizens.toString(), Icons.check_circle_rounded, _successColor),
                    _buildStatCard('غير مدفوعين', nonPayingCitizens.toString(), Icons.pending_rounded, _warningColor),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        
        // قائمة المواطنين
        Text(
          'سجل المواطنين',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        SizedBox(height: 12),
        
        ...citizens.map((citizen) => _buildCitizenCard(citizen)),
      ],
    );
  }

  Widget _buildReportsContent(isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // خيارات التقرير
        Container(
          decoration: BoxDecoration(
            color: _cardColor(),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor()),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
                SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _reportTypes.map((type) {
                      bool isSelected = _selectedReportType == type;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedReportType = type;
                            });
                          },
                          selectedColor: _primaryColor.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? _primaryColor : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        
        // التقارير المحفوظة
        Text(
          'التقارير المحفوظة',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        SizedBox(height: 12),
        
        ...reports.map((report) => _buildReportCard(report)),
        
        SizedBox(height: 20),
        
        // زر إنشاء تقرير جديد
        Container(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _generateReport,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(Icons.add_chart_rounded),
            label: Text('إنشاء تقرير جديد'),
          ),
        ),
      ],
    );
  }

  Widget _buildBillsStats() {
    int paidBills = bills.where((bill) => bill['status'] == 'paid').length;
    int unpaidBills = bills.where((bill) => bill['status'] == 'unpaid').length;
    int overdueBills = bills.where((bill) => bill['status'] == 'overdue').length;
    double totalRevenue = bills.fold(0.0, (sum, bill) => sum + (bill['amountIQD'] ?? 0));
    double collectedRevenue = bills.where((bill) => bill['status'] == 'paid').fold(0.0, (sum, bill) => sum + (bill['amountIQD'] ?? 0));

    return Container(
      decoration: BoxDecoration(
        color: _cardColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor()),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
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
                _buildStatCard('المحصول', _formatCurrency(collectedRevenue), Icons.check_circle_rounded, _successColor),
                _buildStatCard('المتبقي', _formatCurrency(totalRevenue - collectedRevenue), Icons.pending_rounded, _warningColor),
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
              onSelected: (selected) {
                setState(() {
                  _billFilter = filter;
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
                side: BorderSide(
                  color: isSelected ? _primaryColor : _borderColor(),
                ),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
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
                    Text(
                      'فاتورة #${bill['id']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: _textColor(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  bill['citizenName'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textColor(),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${_formatCurrency(bill['amountIQD'])} - ${bill['consumption']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: _textSecondaryColor(),
                  ),
                ),
                SizedBox(height: 12),
                
                // معلومات التحويلات
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _backgroundColor(),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _borderColor()),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.payment_rounded, size: 16, color: _primaryColor),
                          SizedBox(width: 8),
                          Text(
                            'طريقة الدفع:',
                            style: TextStyle(fontSize: 12, color: _textSecondaryColor()),
                          ),
                          SizedBox(width: 4),
                          Text(
                            bill['paymentMethod'] ?? 'غير محدد',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _textColor()),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      
                      if (bill['cardNumber'] != null)
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.credit_card_rounded, size: 14, color: _primaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'رقم البطاقة: ${bill['cardNumber']}',
                                  style: TextStyle(fontSize: 11, color: _textSecondaryColor()),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                          ],
                        ),
                      
                      if (bill['phoneNumber'] != null)
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.phone_rounded, size: 14, color: _primaryColor),
                                SizedBox(width: 8),
                                Text(
                                  'رقم الهاتف: ${bill['phoneNumber']}',
                                  style: TextStyle(fontSize: 11, color: _textSecondaryColor()),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                          ],
                        ),
                      
                      Row(
                        children: [
                          Icon(Icons.account_balance_rounded, size: 14, color: _primaryColor),
                          SizedBox(width: 8),
                          Text(
                            'محول إلى: ${bill['transferTo']}',
                            style: TextStyle(fontSize: 11, color: _textSecondaryColor()),
                          ),
                        ],
                      ),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: method['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(method['icon'], color: method['color'], size: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: _textColor(),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${method['totalTransfers']} تحويل - ${_formatCurrency(method['totalAmount'])}',
                    style: TextStyle(
                      fontSize: 12,
                      color: _textSecondaryColor(),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.info_outline_rounded, color: _primaryColor),
              onPressed: () => _showPaymentMethodDetails(method),
            ),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isPaying ? _successColor.withOpacity(0.1) : _warningColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPaying ? Icons.person : Icons.person_outline,
                color: isPaying ? _successColor : _warningColor,
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        citizen['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _textColor(),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: isPaying ? _successColor.withOpacity(0.1) : _warningColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isPaying ? _successColor.withOpacity(0.3) : _warningColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          isPaying ? 'مدفع' : 'غير مدفع',
                          style: TextStyle(
                            fontSize: 12,
                            color: isPaying ? _successColor : _warningColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${citizen['totalBills']} فواتير - ${_formatCurrency(citizen['totalAmount'])}',
                    style: TextStyle(
                      fontSize: 12,
                      color: _textSecondaryColor(),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'آخر دفع: ${citizen['lastPayment']}',
                    style: TextStyle(
                      fontSize: 11,
                      color: _textSecondaryColor(),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_left_rounded, color: _primaryColor),
              onPressed: () => _showCitizenDetails(citizen),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _cardColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor()),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(Icons.summarize_rounded, color: _primaryColor, size: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: _textColor(),
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _backgroundColor(),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          report['type'],
                          style: TextStyle(fontSize: 10, color: _textSecondaryColor()),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _backgroundColor(),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          report['period'],
                          style: TextStyle(fontSize: 10, color: _textSecondaryColor()),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${report['totalBills']} فواتير - ${_formatCurrency(report['totalAmount'])}',
                    style: TextStyle(fontSize: 12, color: _textSecondaryColor()),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'التاريخ: ${report['date']}',
                    style: TextStyle(fontSize: 11, color: _textSecondaryColor()),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.visibility_rounded, color: _primaryColor),
                  onPressed: () => _viewReport(report),
                ),
                IconButton(
                  icon: Icon(Icons.download_rounded, color: _primaryColor),
                  onPressed: () => _downloadReport(report),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: _textSecondaryColor(),
          ),
        ),
      ],
    );
  }


  Widget _buildConsumptionTab(isDarkMode) {
  return SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // إحصائيات الاستهلاك
        _buildConsumptionStats(),
        SizedBox(height: 20),
        
        // فلتر المنطقة
        _buildAreaFilter(),
        SizedBox(height: 20),
        
        // مخطط الاستهلاك
        _buildConsumptionChart(),
        SizedBox(height: 20),
        
        // تبويبات التقارير الواردة وطلبات التقارير
        _buildReportTabs(),
        SizedBox(height: 20),
        
        // قسم الإنذارات
        _buildAlertsSection(),
      ],
    ),
  );
}
Widget _buildReportTabs() {
  return Column(
    children: [
      // شريط التبويبات
      Container(
        height: 50,
        decoration: BoxDecoration(
          color: _cardColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor()),
        ),
        child: Row(
          children: [
            _buildReportTabButton('طلبات التقارير', 0),
            _buildReportTabButton('التقارير الواردة', 1),
          ],
        ),
      ),
      
      SizedBox(height: 16),
      
      // محتوى التبويب المحدد
      _selectedReportTab == 0 ? _buildReportRequestsSection() : _buildReceivedReportsSection(),
    ],
  );
}

int _selectedReportTab = 0; // 0: طلبات، 1: واردة
Widget _buildReportTabButton(String title, int index) {
  bool isSelected = _selectedReportTab == index;
  return Expanded(
    child: GestureDetector(
      onTap: () {
        setState(() {
          _selectedReportTab = index;
        });
      },
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
Widget _buildReportRequestsSection() {
  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _borderColor()),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
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
                'طلب تقارير من المراقب',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textColor(),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // رسالة توضيحية
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
                    'سيتم إرسال طلب التقرير إلى مسؤول مراقبة الاستهلاك لإنشائه',
                    style: TextStyle(
                      color: _textColor(),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          
          // أزرار طلب التقارير
          Row(
            children: [
              Expanded(
                child: _buildReportRequestButton(
                  'طلب تقرير يومي', 
                  Icons.today_rounded, 
                  _primaryColor, 
                  'يومي'
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildReportRequestButton(
                  'طلب تقرير أسبوعي', 
                  Icons.date_range_rounded, 
                  _accentColor, 
                  'أسبوعي'
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildReportRequestButton(
                  'طلب تقرير شهري', 
                  Icons.calendar_month_rounded, 
                  _secondaryColor, 
                  'شهري'
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // قائمة طلبات التقارير
          Text(
            'طلباتي الأخيرة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textColor(),
            ),
          ),
          SizedBox(height: 12),
          
          if (_reportRequests.isEmpty)
            _buildEmptyRequests()
          else
            Column(
              children: _reportRequests.map((request) => _buildRequestItem(request)).toList(),
            ),
        ],
      ),
    ),
  );
}
Widget _buildRequestItem(Map<String, dynamic> request) {
  Color statusColor = _getRequestStatusColor(request['status']);
  
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
            _getRequestIcon(request['status']),
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
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _textColor(),
                ),
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
          onPressed: () {
            _showRequestDetails(request);
          },
        ),
      ],
    ),
  );
}
Color _getRequestStatusColor(String status) {
  switch (status) {
    case 'معلق':
      return _warningColor;
    case 'قيد التنفيذ':
      return _accentColor;
    case 'مكتمل':
      return _successColor;
    default:
      return _textSecondaryColor();
  }
}
IconData _getRequestIcon(String status) {
  switch (status) {
    case 'معلق':
      return Icons.pending_rounded;
    case 'قيد التنفيذ':
      return Icons.hourglass_bottom_rounded;
    case 'مكتمل':
      return Icons.check_circle_rounded;
    default:
      return Icons.description_rounded;
  }
}
void _showRequestDetails(Map<String, dynamic> request) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(),
      title: Row(
        children: [
          Icon(Icons.request_page_rounded, color: _primaryColor),
          SizedBox(width: 8),
          Text('تفاصيل الطلب', style: TextStyle(color: _textColor())),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              request['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: _textColor(),
              ),
            ),
            SizedBox(height: 16),
            _buildRequestDetailRow('رقم الطلب:', request['id']),
            _buildRequestDetailRow('نوع التقرير:', request['type']),
            _buildRequestDetailRow('حالة الطلب:', request['status']),
            _buildRequestDetailRow('تاريخ الطلب:', request['date']),
            _buildRequestDetailRow('تاريخ التسليم:', request['dueDate']),
            _buildRequestDetailRow('الأولوية:', request['priority']),
            _buildRequestDetailRow('الوصف:', request['description']),
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
Widget _buildRequestDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _textColor(),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: _textSecondaryColor(),
            ),
          ),
        ),
      ],
    ),
  );
}
 List<Map<String, dynamic>> _reportRequests = [
    {
      'id': 'REQ-001',
      'type': 'يومي',
      'title': 'طلب تقرير استهلاك يومي',
      'requestedBy': 'مسؤول المحطة',
      'date': '2024-03-20',
      'status': 'معلق',
      'priority': 'عادي',
      'dueDate': '2024-03-21',
      'description': 'تقرير مفصل عن الاستهلاك اليومي لجميع المناطق',
    },
    {
      'id': 'REQ-002',
      'type': 'أسبوعي',
      'title': 'طلب تقرير الإنذارات الأسبوعي',
      'requestedBy': 'مسؤول الجودة',
      'date': '2024-03-19',
      'status': 'قيد التنفيذ',
      'priority': 'عالي',
      'dueDate': '2024-03-22',
      'description': 'تقرير عن جميع الإنذارات والانحرافات خلال الأسبوع',
    },
    {
      'id': 'REQ-003',
      'type': 'شهري',
      'title': 'طلب تحليل الاستهلاك الشهري',
      'requestedBy': 'المدير العام',
      'date': '2024-03-15',
      'status': 'مكتمل',
      'priority': 'عالي',
      'dueDate': '2024-03-25',
      'description': 'تحليل شامل للاستهلاك الشهري ومقارنة مع الشهر السابق',
    },
  ];
  
  // أضف هذا: تعريف _receivedReports
  List<Map<String, dynamic>> _receivedReports = [
    {
      'id': 'REP-001',
      'title': 'تقرير الاستهلاك اليومي - 20 مارس',
      'type': 'يومي',
      'sender': 'أحمد السعدون - مراقب استهلاك',
      'date': '2024-03-20',
      'time': '10:30 ص',
      'status': 'جديد',
      'read': false,
      'priority': 'عالي',
      'size': '2.4 MB',
      'format': 'PDF',
      'summary': 'تقرير مفصل عن الاستهلاك اليومي لجميع المناطق مع تحليل للانحرافات',
      'attachments': 3,
    },
    {
      'id': 'REP-002',
      'title': 'تحليل الإنذارات الأسبوعي',
      'type': 'أسبوعي',
      'sender': 'سارة العبيدي - مراقبة جودة',
      'date': '2024-03-19',
      'time': '02:15 م',
      'status': 'مكتمل',
      'read': true,
      'priority': 'متوسط',
      'size': '3.1 MB',
      'format': 'PDF',
      'summary': 'تحليل شامل للإنذارات والمخالفات خلال الأسبوع مع توصيات',
      'attachments': 5,
    },
    {
      'id': 'REP-003',
      'title': 'تقرير الاستهلاك الشهري - فبراير 2024',
      'type': 'شهري',
      'sender': 'محمد الحسين - رئيس المراقبة',
      'date': '2024-03-05',
      'time': '09:00 ص',
      'status': 'مكتمل',
      'read': true,
      'priority': 'عالي',
      'size': '4.8 MB',
      'format': 'PDF',
      'summary': 'تحليل كامل للاستهلاك الشهري ومقارنة مع الأشهر السابقة',
      'attachments': 7,
    },
    {
      'id': 'REP-004',
      'title': 'تقرير استهلاك المناطق الشمالية',
      'type': 'خاص',
      'sender': 'خالد إبراهيم - مراقب منطقة',
      'date': '2024-03-18',
      'time': '11:45 ص',
      'status': 'جديد',
      'read': false,
      'priority': 'عالي',
      'size': '1.9 MB',
      'format': 'PDF',
      'summary': 'تقرير مفصل عن استهلاك المنطقة الشمالية مع إنذارات هامة',
      'attachments': 2,
    },
  ];
// ========== قسم التقارير الواردة ==========
Widget _buildReceivedReportsSection() {
  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _borderColor()),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
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
                'التقارير الواردة من المراقب',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textColor(),
                ),
              ),
              Spacer(),
              Badge(
                label: Text('${_receivedReports.where((r) => !r['read']).length}'),
                backgroundColor: _primaryColor,
                child: Icon(Icons.notifications_rounded, color: _primaryColor),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // فلترة التقارير
          _buildReportFilter(),
          SizedBox(height: 20),
          
          // قائمة التقارير الواردة
          if (_receivedReports.isEmpty)
            _buildEmptyReports()
          else
            Column(
              children: _getFilteredReports().map((report) => _buildReceivedReportItem(report)).toList(),
            ),
        ],
      ),
    ),
  );
}
// ========== بيانات التقارير الواردة ==========
String _reportFilter = 'الكل'; // الكل، يومي، أسبوعي، شهري، خاص
Widget _buildReportFilter() {
  List<String> filters = ['الكل', 'يومي', 'أسبوعي', 'شهري', 'خاص'];
  
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: filters.map((filter) {
        bool isSelected = _reportFilter == filter;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _reportFilter = filter;
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
              side: BorderSide(
                color: isSelected ? _primaryColor : _borderColor(),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
List<Map<String, dynamic>> _getFilteredReports() {
  if (_reportFilter == 'الكل') return _receivedReports;
  return _receivedReports.where((report) => report['type'] == _reportFilter).toList();
}
// بناء القائمة المنسدلة المبسطة
// ... الكود السابق يبقى كما هو ...

Widget _buildSystemSupervisorDrawer(BuildContext context, bool isDarkMod) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  final isDarkMode = themeProvider.isDarkMode;
  
  return Drawer(
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode 
              ? [_darkPrimaryColor, Color(0xFF0D1B0E)]
              : [_primaryColor, Color(0xFF4CAF50)],
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
                    ? [_darkPrimaryColor, Color(0xFF1B5E20)]
                    : [_primaryColor, Color(0xFF388E3C)],
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(
                    Icons.engineering_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "مسؤول المحطة",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  "مدير محطة كهرباء",
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
                    "المحطة المركزية",
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
              color: isDarkMode ? Color(0xFF0D1B0E) : Color(0xFFE8F5E9),
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
                      _showSettingsScreen(context);
                    },
                    isDarkMode: isDarkMode,
                  ),
                  
                  // المساعدة والدعم
                  _buildDrawerMenuItem(
                    icon: Icons.help_rounded,
                    title: 'المساعدة والدعم',
                    onTap: () {
                      Navigator.pop(context);
                      _showHelpSupportScreen(context);
                    },
                    isDarkMode: isDarkMode,
                  ),

                  SizedBox(height: 30),
                  
                  // تسجيل الخروج
                  _buildDrawerMenuItem(
                    icon: Icons.logout_rounded,
                    title: 'تسجيل الخروج',
                    onTap: () {
                      _showLogoutConfirmation(context);
                    },
                    isDarkMode: isDarkMode,
                    isLogout: true,
                  ),

                  SizedBox(height: 40),
                  
                  // معلومات النسخة
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
                          'وزارة الكهرباء - نظام مسؤول المحطة',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.grey[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
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
      title: Row(
        children: [
          Icon(Icons.logout_rounded, color: _errorColor),
          SizedBox(width: 8),
          Text('تأكيد تسجيل الخروج'),
        ],
      ),
      content: Text(
        'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
        style: TextStyle(
          color: Colors.black87,
        ),
      ),
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
          child: Text('تسجيل الخروج'),
        ),
      ],
    ),
  );
}

void _performLogout(BuildContext context) {
  // هنا يمكنك إضافة منطق تسجيل الخروج الفعلي مثل:
  // 1. مسح بيانات الجلسة
  // 2. تحديث حالة تسجيل الدخول
  // 3. مسح بيانات التخزين المحلي
  
  // مؤقتاً: إظهار رسالة نجاح
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.white),
          SizedBox(width: 8),
          Text('تم تسجيل الخروج بنجاح'),
        ],
      ),
      backgroundColor: _successColor,
      duration: Duration(seconds: 2),
    ),
  );
  
  // العودة إلى شاشة تسجيل الدخول
  Navigator.pushReplacementNamed(context, EsigninScreen.screenroot);
}
// شاشة الإعدادات
void _showSettingsScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SupervisorSettingsScreen(
        primaryColor: _primaryColor,
        secondaryColor: _secondaryColor,
        accentColor: _accentColor,
        successColor: _successColor,
        warningColor: _warningColor,
        errorColor: _errorColor,
      ),
    ),
  );
}
Widget _buildSettingsOption(String title, bool value, Function(bool) onChanged) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: TextStyle(color: _textColor())),
      Switch(
        value: value,
        onChanged: onChanged,
        activeColor: _primaryColor,
      ),
    ],
  );
}
// شاشة المساعدة والدعم
void _showHelpSupportScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SupervisorHelpSupportScreen(
        primaryColor: _primaryColor,
        secondaryColor: _secondaryColor,
        accentColor: _accentColor,
        successColor: _successColor,
        warningColor: _warningColor,
        errorColor: _errorColor,
      ),
    ),
  );
}
Widget _buildHelpItem(String title, String value, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, color: _primaryColor, size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
              Text(value),
            ],
          ),
        ),
      ],
    ),
  );
}

void _showContactSupport(BuildContext context) {
  Navigator.pop(context);
  _showSuccessMessage('جاري الاتصال بالدعم الفني...');
}

Widget _buildSupervisorDrawerMenuItem({
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
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
    ),
  );
}

Widget _buildReceivedReportItem(Map<String, dynamic> report) {
  Color statusColor = _getReportStatusColor(report['status']);
  Color priorityColor = _getPriorityColor(report['priority']);
  
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
                style: TextStyle(
                  fontSize: 10,
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 12),
        
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
            
            // التاريخ والوقت
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
        
        // نوع التقرير والأولوية
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
            
            // حجم الملف
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
        
        SizedBox(height: 16),
        
        // أزرار الإجراءات
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _viewReport(report);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primaryColor,
                  side: BorderSide(color: _primaryColor),
                ),
                icon: Icon(Icons.remove_red_eye_rounded, size: 16),
                label: Text('عرض التقرير'),
              ),
            ),
            
            SizedBox(width: 8),
            
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _downloadReport(report);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                ),
                icon: Icon(Icons.download_rounded, size: 16),
                label: Text('تحميل'),
              ),
            ),
            
            SizedBox(width: 8),
            
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

Color _getReportStatusColor(String status) {
  switch (status) {
    case 'جديد':
      return _primaryColor;
    case 'مكتمل':
      return _successColor;
    case 'قيد المراجعة':
      return _warningColor;
    case 'مرفوض':
      return _errorColor;
    default:
      return _textSecondaryColor();
  }
}

Color _getPriorityColor(String priority) {
  switch (priority) {
    case 'عالي':
      return _errorColor;
    case 'متوسط':
      return _warningColor;
    case 'عادي':
      return _successColor;
    default:
      return _textSecondaryColor();
  }
}

Widget _buildEmptyRequests() {
  return Container(
    padding: EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: _backgroundColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: _borderColor().withOpacity(0.5), // شفافية للحصول على مظهر أخف
        width: 1.5,
      ),
    ),
    child: Column(
      children: [
        Icon(Icons.send_rounded, size: 48, color: _textSecondaryColor()),
        SizedBox(height: 12),
        Text(
          'لا توجد طلبات تقارير',
          style: TextStyle(
            fontSize: 16,
            color: _textSecondaryColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'يمكنك إرسال طلب تقرير باستخدام الأزرار أعلاه',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _textSecondaryColor(),
          ),
        ),
      ],
    ),
  );
}
Widget _buildEmptyReports() {
  return Container(
    padding: EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: _backgroundColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor(), style: BorderStyle.solid), // تم التصحيح هنا
    ),
    child: Column(
      children: [
        Icon(Icons.inbox_rounded, size: 48, color: _textSecondaryColor()),
        SizedBox(height: 12),
        Text(
          'لا توجد تقارير واردة',
          style: TextStyle(
            fontSize: 16,
            color: _textSecondaryColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'سيظهر هنا التقارير المرسلة من مراقب الاستهلاك',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _textSecondaryColor(),
          ),
        ),
      ],
    ),
  );
}
// ========== دوال التفاعل مع التقارير الواردة ==========

void _viewReport(Map<String, dynamic> report) {
  // تحديث حالة القراءة
  setState(() {
    report['read'] = true;
  });
  
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: _cardColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // رأس التقرير
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
                  Icon(Icons.description_rounded, color: Colors.white),
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
                    // معلومات التقرير
                    _buildViewDetail('المرسل', report['sender']),
                    _buildViewDetail('نوع التقرير', report['type']),
                    _buildViewDetail('التاريخ', '${report['date']} ${report['time']}'),
                    _buildViewDetail('الأولوية', report['priority']),
                    _buildViewDetail('حجم الملف', report['size']),
                    _buildViewDetail('الصيغة', report['format']),
                    
                    SizedBox(height: 16),
                    Divider(color: _borderColor()),
                    SizedBox(height: 16),
                    
                    // ملخص التقرير
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
            
            // أزرار الإجراءات
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
                        _downloadReport(report);
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
Widget _buildViewDetail(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _textColor(),
            ),
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
void _downloadReport(Map<String, dynamic> report) {
  _showSuccessMessage('جاري تحميل التقرير: ${report['title']}');
}

void _showReportOptions(Map<String, dynamic> report) {
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
              _shareReport(report);
            },
          ),
          ListTile(
            leading: Icon(Icons.archive_rounded, color: _primaryColor),
            title: Text('أرشفة التقرير'),
            onTap: () {
              Navigator.pop(context);
              _archiveReport(report);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_rounded, color: _errorColor),
            title: Text('حذف التقرير', style: TextStyle(color: _errorColor)),
            onTap: () {
              Navigator.pop(context);
              _deleteReport(report);
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

void _shareReport(Map<String, dynamic> report) {
  _showSuccessMessage('تم إعداد التقرير للمشاركة: ${report['title']}');
}

void _archiveReport(Map<String, dynamic> report) {
  setState(() {
    _receivedReports.remove(report);
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
              _receivedReports.remove(report);
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
Widget _buildConsumptionStats() {
  // بيانات افتراضية للاستهلاك
  double totalConsumption = 125000; // ك.و.س
  double dailyAvg = 4166.67;
  double monthlyAvg = 125000;
  double yearlyAvg = 1500000;
  double previousMonth = 118000;
  double changePercent = ((totalConsumption - previousMonth) / previousMonth * 100);

  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _borderColor()),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // العنوان
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.bolt_rounded, color: _primaryColor, size: 24),
              ),
              SizedBox(width: 12),
              Text(
                'إحصائيات الاستهلاك',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // إحصائيات رئيسية
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildConsumptionStatCard(
                'إجمالي الاستهلاك',
                '${_formatNumber(totalConsumption)} ك.و.س',
                Icons.bar_chart_rounded,
                _primaryColor,
                changePercent > 0 ? '+' : '',
                changePercent.abs().toStringAsFixed(1),
              ),
              _buildConsumptionStatCard(
                'متوسط الاستهلاك',
                '${_formatNumber(dailyAvg)} ك.و.س/يوم',
                Icons.trending_up_rounded,
                _accentColor,
                '',
                '',
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // إحصائيات ثانوية
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSimpleStatCard('اليومي', '${_formatNumber(dailyAvg)} ك.و.س'),
              _buildSimpleStatCard('الشهري', '${_formatNumber(monthlyAvg)} ك.و.س'),
              _buildSimpleStatCard('السنوي', '${_formatNumber(yearlyAvg)} ك.و.س'),
            ],
          ),
        ],
      ),
    ),
  );
}
Widget _buildConsumptionStatCard(String title, String value, IconData icon, Color color, String changeSign, String changePercent) {
  return Column(
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: color, size: 30),
      ),
      SizedBox(height: 12),
      Text(
        value,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: _textColor(),
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 4),
      Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: _textSecondaryColor(),
        ),
      ),
      if (changePercent.isNotEmpty)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              changeSign == '+' ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              size: 14,
              color: changeSign == '+' ? _errorColor : _successColor,
            ),
            Text(
              '$changeSign$changePercent%',
              style: TextStyle(
                fontSize: 12,
                color: changeSign == '+' ? _errorColor : _successColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
    ],
  );
}

Widget _buildSimpleStatCard(String title, String value) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _backgroundColor(),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _borderColor()),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: _textColor(),
          ),
        ),
      ),
      SizedBox(height: 4),
      Text(
        title,
        style: TextStyle(
          fontSize: 11,
          color: _textSecondaryColor(),
        ),
      ),
    ],
  );
}

Widget _buildAreaFilter() {
  List<String> areas = ['جميع المناطق', 'المنطقة الشمالية', 'المنطقة الجنوبية', 'المنطقة الشرقية', 'المنطقة الغربية'];
  String selectedArea = areas[0];

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor()),
    ),
    child: Row(
      children: [
        Icon(Icons.location_on_rounded, color: _primaryColor, size: 20),
        SizedBox(width: 12),
        Text(
          'المنطقة:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _textColor(),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedArea,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down_rounded, color: _primaryColor),
              items: areas.map((area) {
                return DropdownMenuItem<String>(
                  value: area,
                  child: Text(
                    area,
                    style: TextStyle(color: _textColor()),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                // Handle area change
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildConsumptionChart() {
  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _borderColor()),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'مخطط الاستهلاك الشهري',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textColor(),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _primaryColor.withOpacity(0.3)),
                ),
                child: Text(
                  'آخر 12 شهر',
                  style: TextStyle(
                    fontSize: 12,
                    color: _primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // مخطط مبسط (يمكن استبداله بمخطط حقيقي)
          Container(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildChartBar(120, 'يناير'),
                _buildChartBar(95, 'فبراير'),
                _buildChartBar(110, 'مارس'),
                _buildChartBar(105, 'أبريل'),
                _buildChartBar(125, 'مايو'),
                _buildChartBar(130, 'يونيو'),
                _buildChartBar(140, 'يوليو'),
                _buildChartBar(135, 'أغسطس'),
                _buildChartBar(120, 'سبتمبر'),
                _buildChartBar(115, 'أكتوبر'),
                _buildChartBar(125, 'نوفمبر'),
                _buildChartBar(150, 'ديسمبر'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildChartBar(double height, String month) {
  double maxHeight = 150;
  double percentage = height / maxHeight;
  
  return Column(
    children: [
      Container(
        width: 20,
        height: 150 * percentage,
        decoration: BoxDecoration(
          color: _primaryColor,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      SizedBox(height: 8),
      Text(
        month.substring(0, 3),
        style: TextStyle(
          fontSize: 10,
          color: _textSecondaryColor(),
        ),
      ),
    ],
  );
}

Widget _buildReportsSection() {
  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _borderColor()),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
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
                  color: _secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.summarize_rounded, color: _secondaryColor, size: 24),
              ),
              SizedBox(width: 12),
              Text(
                'طلب تقارير من المراقب',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textColor(),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'طلب مباشر',
                  style: TextStyle(
                    color: _successColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // رسالة توضيحية
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
                    'سيتم إرسال طلب التقرير إلى مسؤول مراقبة الاستهلاك لإنشائه',
                    style: TextStyle(
                      color: _textColor(),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          
          // أزرار طلب التقارير
          Row(
            children: [
              Expanded(
                child: _buildReportRequestButton(
                  'طلب تقرير يومي', 
                  Icons.today_rounded, 
                  _primaryColor, 
                  'يومي'
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildReportRequestButton(
                  'طلب تقرير أسبوعي', 
                  Icons.date_range_rounded, 
                  _accentColor, 
                  'أسبوعي'
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildReportRequestButton(
                  'طلب تقرير شهري', 
                  Icons.calendar_month_rounded, 
                  _secondaryColor, 
                  'شهري'
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // آخر طلبات التقارير
          Text(
            'آخر طلبات التقارير',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textColor(),
            ),
          ),
          SizedBox(height: 12),
          
          _buildRecentRequestItem('طلب تقرير يومي', 'اليوم', 'معلق', Icons.pending_rounded, _warningColor),
          _buildRecentRequestItem('طلب تقرير أسبوعي', 'منذ 2 يوم', 'قيد التنفيذ', Icons.hourglass_bottom_rounded, _accentColor),
          _buildRecentRequestItem('طلب تقرير شهري', 'منذ أسبوع', 'مكتمل', Icons.check_circle_rounded, _successColor),
          _buildRecentRequestItem('طلب تحليل استهلاك', 'منذ 3 أيام', 'مكتمل', Icons.check_circle_rounded, _successColor),
        ],
      ),
    ),
  );
}
Widget _buildReportRequestButton(String title, IconData icon, Color color, String reportType) {
  return ElevatedButton(
    onPressed: () {
      _showReportRequestConfirmation(reportType);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
void _showReportRequestConfirmation(String reportType) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
            style: TextStyle(
              color: _textColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'هل تريد إرسال طلب لتقرير $reportType إلى مسؤول مراقبة الاستهلاك؟',
            style: TextStyle(
              color: _textColor(),
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          
          // تفاصيل الطلب
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _textColor(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                _buildRequestDetail('نوع التقرير', 'تقرير $reportType'),
                _buildRequestDetail('المستلم', 'مسؤول مراقبة الاستهلاك'),
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
          child: Text(
            'إلغاء',
            style: TextStyle(color: _textSecondaryColor()),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _sendReportRequest(reportType);
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
Widget _buildRequestDetail(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _textColor(),
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: _textSecondaryColor(),
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
}
void _sendReportRequest(String reportType) {
  // هنا يمكنك إضافة منطق إرسال الطلب فعلياً
  // مثل حفظ في قاعدة البيانات أو إرسال إشعار
  
  // إظهار رسالة نجاح
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.white),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'تم إرسال طلب التقرير $reportType بنجاح',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      backgroundColor: _successColor,
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
  
  // إظهار نافذة التأكيد النهائية
  _showRequestSentSuccess(reportType);
}

void _showRequestSentSuccess(String reportType) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: _cardColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // أيقونة نجاح
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _successColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: _successColor, width: 2),
              ),
              child: Icon(
                Icons.check_rounded,
                color: _successColor,
                size: 40,
              ),
            ),
            SizedBox(height: 20),
            
            // نص التأكيد
            Text(
              'تم إرسال الطلب بنجاح!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _textColor(),
              ),
            ),
            SizedBox(height: 12),
            
            Text(
              'تم إرسال طلب تقرير $reportType إلى مسؤول مراقبة الاستهلاك',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _textSecondaryColor(),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
            
            // تفاصيل إضافية
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _backgroundColor(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildSuccessDetail('رقم الطلب', 'REQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}'),
                  _buildSuccessDetail('تاريخ الطلب', DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())),
                  _buildSuccessDetail('حالة الطلب', 'معلق'),
                  _buildSuccessDetail('رقم التتبع', 'TRK-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}'),
                ],
              ),
            ),
            SizedBox(height: 24),
            
            // زر الإغلاق
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('موافق'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildSuccessDetail(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: _textColor(),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: _primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}

Widget _buildRecentRequestItem(String title, String date, String status, IconData icon, Color color) {
  // إنشاء Map للطلب
  Map<String, dynamic> requestData = {
    'title': title,
    'date': date,
    'status': status,
    'id': 'REQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(8, 12)}',
    'type': _getRequestTypeFromTitle(title),
    'priority': 'عادية',
    'description': 'طلب تقرير تفصيلي'
  };
  
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
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _textColor(),
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 12, color: _textSecondaryColor()),
                  SizedBox(width: 4),
                  Text(
                    date,
                    style: TextStyle(fontSize: 11, color: _textSecondaryColor()),
                  ),
                  SizedBox(width: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.visibility_rounded, color: _primaryColor, size: 20),
          onPressed: () {
            _showRequestDetails(requestData); 
          },
        ),
      ],
    ),
  );
}

// دالة مساعدة لاستخراج نوع الطلب من العنوان
String _getRequestTypeFromTitle(String title) {
  if (title.contains('يومي')) return 'يومي';
  if (title.contains('أسبوعي')) return 'أسبوعي';
  if (title.contains('شهري')) return 'شهري';
  return 'عام';
}

Widget _buildReportButton(String title, IconData icon, Color color, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _buildRecentReportItem(String title, String date, String status, Color statusColor) {
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
          child: Icon(Icons.description_rounded, color: statusColor, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _textColor(),
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 12, color: _textSecondaryColor()),
                  SizedBox(width: 4),
                  Text(
                    date,
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
                      status,
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
          onPressed: () {
            // عرض التقرير
          },
        ),
      ],
    ),
  );
}

Widget _buildAlertsSection() {
  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _borderColor()),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
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
                  color: _errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.warning_rounded, color: _errorColor, size: 24),
              ),
              SizedBox(width: 12),
              Text(
                'إنذارات الاستهلاك',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textColor(),
                ),
              ),
              Spacer(),
              Badge(
                label: Text('3'),
                backgroundColor: _errorColor,
                child: Icon(Icons.notifications_active_rounded, color: _errorColor),
              ),
            ],
          ),
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
    decoration: BoxDecoration(
      color: color.withOpacity(0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Row(
      children: [
        Icon(Icons.warning_amber_rounded, color: color, size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _textColor(),
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on_rounded, size: 12, color: _textSecondaryColor()),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      location,
                      style: TextStyle(fontSize: 11, color: _textSecondaryColor()),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: TextStyle(fontSize: 10, color: _textSecondaryColor()),
            ),
            SizedBox(height: 4),
            ElevatedButton(
              onPressed: () {
                // معالجة الإنذار
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                minimumSize: Size.zero,
              ),
              child: Text(
                'معالجة',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


Widget _buildReportFeature(String feature) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(Icons.check_circle_rounded, color: _successColor, size: 16),
        SizedBox(width: 8),
        Text(feature, style: TextStyle(fontSize: 14)),
      ],
    ),
  );
}

String _formatNumber(double number) {
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  }
  return number.toStringAsFixed(0);
}


  // ... الكود السابق يبقى كما هو ...

Widget _buildMaintenanceTab(isdarkmode) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // إحصائيات الصيانة
        _buildMaintenanceStats(),
        SizedBox(height: 20),
        
        // تبويبات المهام
        _buildMaintenanceTasksTabs(),
        SizedBox(height: 20),
        
        // تبويبات التقارير الواردة وطلبات التقارير (مثل الاستهلاك)
        _buildMaintenanceReportTabs(),
      ],
    ),
  );
}
Widget _buildMaintenanceTasksTabs() {
  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor()),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        // شريط التبويبات
        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            border: Border(
              bottom: BorderSide(color: _borderColor()),
            ),
          ),
          child: Row(
            children: [
              _buildMaintenanceTaskTabButton('النشطة', 0, Icons.play_circle_filled_rounded),
              _buildMaintenanceTaskTabButton('المتأخرة', 1, Icons.warning_rounded),
              _buildMaintenanceTaskTabButton('المكتملة', 2, Icons.check_circle_rounded),
              _buildMaintenanceTaskTabButton('الكل', 3, Icons.view_list_rounded),
            ],
          ),
        ),
        
        // محتوى التبويب المحدد
        Container(
          padding: EdgeInsets.all(16),
          child: _buildMaintenanceTaskTabContent(),
        ),
      ],
    ),
  );
}
Widget _buildMaintenanceTaskTabContent() {
  // بيانات المهام (ستأتي من قاعدة البيانات أو API)
  List<Map<String, dynamic>> allTasks = [
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
  
  // تصفية المهام حسب التبويب المختار
  List<Map<String, dynamic>> filteredTasks = [];
  
  switch (_maintenanceCurrentTab) {
    case 0: // النشطة
      filteredTasks = allTasks.where((task) => 
          task['status'] == 'قيد التنفيذ' || task['status'] == 'معلقة').toList();
      break;
    case 1: // المتأخرة
      filteredTasks = allTasks.where((task) => 
          task['status'] == 'متأخرة').toList();
      break;
    case 2: // المكتملة
      filteredTasks = allTasks.where((task) => 
          task['status'] == 'مكتملة').toList();
      break;
    case 3: // الكل
      filteredTasks = allTasks;
      break;
  }
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // عنوان القسم مع العدد
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _getMaintenanceTabTitle(_maintenanceCurrentTab),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textColor(),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _getMaintenanceTabColor(_maintenanceCurrentTab).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getMaintenanceTabColor(_maintenanceCurrentTab).withOpacity(0.3),
              ),
            ),
            child: Text(
              '${filteredTasks.length} مهمة',
              style: TextStyle(
                fontSize: 12,
                color: _getMaintenanceTabColor(_maintenanceCurrentTab),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      
      // قائمة المهام
      if (filteredTasks.isEmpty)
        _buildEmptyMaintenanceTasks()
      else
        Column(
          children: filteredTasks.map((task) => _buildMaintenanceTaskCard(task)).toList(),
        ),
    ],
  );
}
Widget _buildEmptyMaintenanceTasks() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 40),
    child: Column(
      children: [
        Icon(
          _getMaintenanceTabIcon(_maintenanceCurrentTab),
          size: 60,
          color: _textSecondaryColor(),
        ),
        SizedBox(height: 16),
        Text(
          _getEmptyTasksMessage(_maintenanceCurrentTab),
          style: TextStyle(
            fontSize: 16,
            color: _textSecondaryColor(),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
IconData _getMaintenanceTabIcon(int index) {
  switch (index) {
    case 0:
      return Icons.play_circle_filled_rounded;
    case 1:
      return Icons.warning_rounded;
    case 2:
      return Icons.check_circle_rounded;
    case 3:
      return Icons.view_list_rounded;
    default:
      return Icons.engineering_rounded;
  }
}

String _getEmptyTasksMessage(int index) {
  switch (index) {
    case 0:
      return 'لا توجد مهام نشطة حالياً';
    case 1:
      return 'لا توجد مهام متأخرة';
    case 2:
      return 'لا توجد مهام مكتملة';
    case 3:
      return 'لا توجد مهام';
    default:
      return 'لا توجد بيانات';
  }
}
String _getMaintenanceTabTitle(int index) {
  switch (index) {
    case 0:
      return 'المهام النشطة';
    case 1:
      return 'المهام المتأخرة';
    case 2:
      return 'المهام المكتملة';
    case 3:
      return 'جميع المهام';
    default:
      return 'المهام';
  }
}
Color _getMaintenanceTabColor(int index) {
  switch (index) {
    case 0: // النشطة
      return _primaryColor;
    case 1: // المتأخرة
      return _warningColor;
    case 2: // المكتملة
      return _successColor;
    case 3: // الكل
      return _accentColor;
    default:
      return _primaryColor;
  }
}
Widget _buildMaintenanceTaskTabButton(String title, int index, IconData icon) {
  bool isSelected = _maintenanceCurrentTab == index;
  Color activeColor = _getMaintenanceTabColor(index);
  
  return Expanded(
    child: GestureDetector(
      onTap: () {
        setState(() {
          _maintenanceCurrentTab = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isSelected ? activeColor : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? activeColor : _textSecondaryColor(),
                size: 18,
              ),
              SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? activeColor : _textSecondaryColor(),
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
Widget _buildMaintenanceReports() {
  return SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // قسم تبويبات التقارير
        _buildMaintenanceReportTabs(),
        
        SizedBox(height: 20),
        
        // قسم التحليل والإحصائيات (إضافي)
        Container(
          decoration: BoxDecoration(
            color: _cardColor(),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _borderColor()),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
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
                        color: _accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.analytics_rounded, color: _accentColor, size: 24),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'تحليل تقارير الصيانة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _textColor(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                
                // إحصائيات التقارير
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildReportStatCard('التقارير الكلية', '12', Icons.description_rounded, _primaryColor),
                    _buildReportStatCard('تم التحميل', '8', Icons.download_done_rounded, _successColor),
                    _buildReportStatCard('قيد الانتظار', '4', Icons.pending_rounded, _warningColor),
                  ],
                ),
                SizedBox(height: 20),
                
                // أنواع التقارير
                Text(
                  'أنواع التقارير',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textColor(),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    _buildReportTypeChip('يومي', 5, _primaryColor),
                    SizedBox(width: 8),
                    _buildReportTypeChip('أسبوعي', 4, _accentColor),
                    SizedBox(width: 8),
                    _buildReportTypeChip('شهري', 3, _secondaryColor),
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

Widget _buildReportStatCard(String title, String value, IconData icon, Color color) {
  return Column(
    children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      SizedBox(height: 8),
      Text(
        value,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: _textColor(),
        ),
      ),
      SizedBox(height: 4),
      Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: _textSecondaryColor(),
        ),
      ),
    ],
  );
}

Widget _buildReportTypeChip(String type, int count, Color color) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          type,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
Widget _buildMaintenanceStats() {
  // هذه البيانات ستأتي من واجهة فني الصيانة
  int totalTasks = 45; // إجمالي المهام
  int completedTasks = 38; // المهام المكتملة
  int delayedTasks = 5; // المهام المتأخرة
  int activeTasks = 2; // المهام النشطة
  double completionRate = (completedTasks / totalTasks * 100);
  
  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _borderColor()),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // العنوان
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.engineering_rounded, color: _primaryColor, size: 24),
              ),
              SizedBox(width: 12),
              Text(
                'إحصائيات الصيانة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // إحصائيات رئيسية
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMaintenanceStatCard(
                'إجمالي المهام',
                totalTasks.toString(),
                Icons.task_rounded,
                _primaryColor,
              ),
              _buildMaintenanceStatCard(
                'معدل الإنجاز',
                '${completionRate.toStringAsFixed(1)}%',
                Icons.check_circle_rounded,
                _successColor,
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // إحصائيات ثانوية
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSimpleMaintenanceStat('المكتملة', completedTasks.toString(), _successColor),
              _buildSimpleMaintenanceStat('المتأخرة', delayedTasks.toString(), _warningColor),
              _buildSimpleMaintenanceStat('النشطة', activeTasks.toString(), _accentColor),
              _buildSimpleMaintenanceStat('المؤجلة', '0', _textSecondaryColor()),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildMaintenanceStatCard(String title, String value, IconData icon, Color color) {
  return Column(
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: color, size: 30),
      ),
      SizedBox(height: 12),
      Text(
        value,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _textColor(),
        ),
      ),
      SizedBox(height: 4),
      Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: _textSecondaryColor(),
        ),
      ),
    ],
  );
}

Widget _buildSimpleMaintenanceStat(String title, String value, Color color) {
  return Column(
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
      SizedBox(height: 6),
      Text(
        title,
        style: TextStyle(
          fontSize: 11,
          color: _textSecondaryColor(),
        ),
      ),
    ],
  );
}

// متغير لتتبع التبويب الحالي في الصيانة
int _maintenanceCurrentTab = 0; // 0: النشطة، 1: المتأخرة، 2: المكتملة، 3: التقارير

Widget _buildMaintenanceTabs() {
  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor()),
    ),
    child: Column(
      children: [
        // شريط التبويبات
        Container(
          height: 50,
          child: Row(
            children: [
              _buildMaintenanceTabButton('النشطة', 0, Icons.play_circle_filled_rounded),
              _buildMaintenanceTabButton('المتأخرة', 1, Icons.warning_rounded),
              _buildMaintenanceTabButton('المكتملة', 2, Icons.check_circle_rounded),
              _buildMaintenanceTabButton('التقارير', 3, Icons.assessment_rounded),
            ],
          ),
        ),
        
        // محتوى التبويب المحدد
        Padding(
          padding: const EdgeInsets.all(16),
          child: _buildMaintenanceTabContent(),
        ),
      ],
    ),
  );
}

Widget _buildMaintenanceTabButton(String title, int index, IconData icon) {
  bool isSelected = _maintenanceCurrentTab == index;
  Color activeColor = _getMaintenanceTabColor(index);
  
  return Expanded(
    child: GestureDetector(
      onTap: () {
        setState(() {
          _maintenanceCurrentTab = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isSelected ? activeColor : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? activeColor : _textSecondaryColor(),
                size: 20,
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? activeColor : _textSecondaryColor(),
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
Widget _buildMaintenanceTabContent() {
  switch (_maintenanceCurrentTab) {
    case 0:
      return _buildActiveMaintenanceTasks();
    case 1:
      return _buildDelayedMaintenanceTasks();
    case 2:
      return _buildCompletedMaintenanceTasks();
    case 3:
      return _buildMaintenanceReports();
    default:
      return Container();
  }
}

// بيانات المهام (ستأتي من واجهة فني الصيانة)
List<Map<String, dynamic>> _maintenanceTasks = [
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
];

Widget _buildActiveMaintenanceTasks() {
  List<Map<String, dynamic>> activeTasks = _maintenanceTasks
      .where((task) => task['status'] == 'قيد التنفيذ' || task['status'] == 'معلقة')
      .toList();
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'المهام النشطة (${activeTasks.length})',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _textColor(),
        ),
      ),
      SizedBox(height: 12),
      
      if (activeTasks.isEmpty)
        _buildEmptyMaintenanceState('لا توجد مهام نشطة حالياً', Icons.engineering_rounded)
      else
        Column(
          children: activeTasks.map((task) => _buildMaintenanceTaskCard(task)).toList(),
        ),
    ],
  );
}

Widget _buildDelayedMaintenanceTasks() {
  List<Map<String, dynamic>> delayedTasks = _maintenanceTasks
      .where((task) => task['status'] == 'متأخرة')
      .toList();
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'المهام المتأخرة (${delayedTasks.length})',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _textColor(),
        ),
      ),
      SizedBox(height: 12),
      
      if (delayedTasks.isEmpty)
        _buildEmptyMaintenanceState('لا توجد مهام متأخرة', Icons.warning_rounded)
      else
        Column(
          children: delayedTasks.map((task) => _buildMaintenanceTaskCard(task)).toList(),
        ),
    ],
  );
}

Widget _buildCompletedMaintenanceTasks() {
  List<Map<String, dynamic>> completedTasks = _maintenanceTasks
      .where((task) => task['status'] == 'مكتملة')
      .toList();
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'المهام المكتملة (${completedTasks.length})',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _textColor(),
        ),
      ),
      SizedBox(height: 12),
      
      if (completedTasks.isEmpty)
        _buildEmptyMaintenanceState('لا توجد مهام مكتملة', Icons.check_circle_rounded)
      else
        Column(
          children: completedTasks.map((task) => _buildCompletedTaskCard(task)).toList(),
        ),
    ],
  );
}

Widget _buildMaintenanceReportTabs() {
  return Column(
    children: [
      // شريط التبويبات
      Container(
        height: 50,
        decoration: BoxDecoration(
          color: _cardColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor()),
        ),
        child: Row(
          children: [
            _buildMaintenanceReportTabButton('طلبات التقارير', 0),
            _buildMaintenanceReportTabButton('التقارير الواردة', 1),
          ],
        ),
      ),
      
      SizedBox(height: 16),
      
      // محتوى التبويب المحدد
      _selectedMaintenanceTab == 0 
          ? _buildMaintenanceReportRequestsSection() 
          : _buildMaintenanceReceivedReportsSection(),
    ],
  );
}
Widget _buildMaintenanceReportTabButton(String title, int index) {
  bool isSelected = _selectedMaintenanceTab == index;
  return Expanded(
    child: GestureDetector(
      onTap: () {
        setState(() {
          _selectedMaintenanceTab = index;
        });
      },
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
Widget _buildMaintenanceReportRequestsSection() {
  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _borderColor()),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
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
                'طلب تقارير من فني الصيانة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textColor(),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // رسالة توضيحية
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
                    'سيتم إرسال طلب التقرير إلى فني الصيانة المسؤول لإنشائه',
                    style: TextStyle(
                      color: _textColor(),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          
          // أزرار طلب التقارير
          Row(
            children: [
              Expanded(
                child: _buildMaintenanceReportRequestButton(
                  'طلب تقرير يومي', 
                  Icons.today_rounded, 
                  _primaryColor, 
                  'يومي'
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildMaintenanceReportRequestButton(
                  'طلب تقرير أسبوعي', 
                  Icons.date_range_rounded, 
                  _accentColor, 
                  'أسبوعي'
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildMaintenanceReportRequestButton(
                  'طلب تقرير شهري', 
                  Icons.calendar_month_rounded, 
                  _secondaryColor, 
                  'شهري'
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // قائمة طلبات التقارير
          Text(
            'طلباتي الأخيرة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textColor(),
            ),
          ),
          SizedBox(height: 12),
          
          if (_maintenanceReportRequests.isEmpty)
            _buildMaintenanceEmptyRequests()
          else
            Column(
              children: _maintenanceReportRequests.map((request) => _buildMaintenanceRequestItem(request)).toList(),
            ),
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
            _getMaintenanceRequestIcon(request['status']),
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
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _textColor(),
                ),
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
          onPressed: () {
            _showMaintenanceRequestDetails(request);
          },
        ),
      ],
    ),
  );
}
Color _getMaintenanceRequestStatusColor(String status) {
  switch (status) {
    case 'معلق':
      return _warningColor;
    case 'قيد التنفيذ':
      return _accentColor;
    case 'مكتمل':
      return _successColor;
    default:
      return _textSecondaryColor();
  }
}

IconData _getMaintenanceRequestIcon(String status) {
  switch (status) {
    case 'معلق':
      return Icons.pending_rounded;
    case 'قيد التنفيذ':
      return Icons.hourglass_bottom_rounded;
    case 'مكتمل':
      return Icons.check_circle_rounded;
    default:
      return Icons.engineering_rounded;
  }
}



Widget _buildMaintenanceTaskCard(Map<String, dynamic> task) {
  Color statusColor = _getTaskStatusColor(task['status']);
  Color priorityColor = _getTaskPriorityColor(task['priority']);
  
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor()),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: ExpansionTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          _getTaskIcon(task['status']),
          color: statusColor,
          size: 20,
        ),
      ),
      title: Text(
        task['title'],
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: _textColor(),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text(
            'الفني: ${task['technician']}',
            style: TextStyle(
              fontSize: 12,
              color: _textSecondaryColor(),
            ),
          ),
          SizedBox(height: 2),
          Text(
            task['location'],
            style: TextStyle(
              fontSize: 11,
              color: _textSecondaryColor(),
            ),
          ),
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
              task['priority'],
              style: TextStyle(
                fontSize: 10,
                color: priorityColor,
                fontWeight: FontWeight.bold,
              ),
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
              task['status'],
              style: TextStyle(
                fontSize: 10,
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
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
              _buildTaskDetailRow('رقم المهمة:', task['id']),
              _buildTaskDetailRow('الفني:', task['technician']),
              _buildTaskDetailRow('الموقع:', task['location']),
              _buildTaskDetailRow('تاريخ البدء:', task['startDate']),
              
              if (task['estimatedTime'] != null)
                _buildTaskDetailRow('الوقت المقدر:', task['estimatedTime']),
              
              if (task['delayReason'] != null)
                _buildTaskDetailRow('سبب التأخير:', task['delayReason']),
              
              if (task['description'] != null)
                _buildTaskDetailRow('الوصف:', task['description']),
              
              SizedBox(height: 16),
              
              // أزرار التحكم
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _updateTaskStatus(task, 'قيد التنفيذ'),
                      icon: Icon(Icons.play_arrow_rounded, size: 18),
                      label: Text('بدء العمل'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _updateTaskStatus(task, 'مؤجلة'),
                      icon: Icon(Icons.schedule_rounded, size: 18),
                      label: Text('تأجيل'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _warningColor,
                        side: BorderSide(color: _warningColor),
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

Widget _buildCompletedTaskCard(Map<String, dynamic> task) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor()),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _successColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.check_circle_rounded, color: _successColor, size: 20),
      ),
      title: Text(
        task['title'],
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: _textColor(),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text(
            'الفني: ${task['technician']}',
            style: TextStyle(
              fontSize: 12,
              color: _textSecondaryColor(),
            ),
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.timer_rounded, size: 12, color: _textSecondaryColor()),
              SizedBox(width: 4),
              Text(
                task['duration'],
                style: TextStyle(fontSize: 11, color: _textSecondaryColor()),
              ),
              SizedBox(width: 12),
              if (task['rating'] != null)
                Row(
                  children: [
                    Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                    SizedBox(width: 2),
                    Text(
                      task['rating'].toString(),
                      style: TextStyle(fontSize: 11, color: Colors.amber),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.visibility_rounded, color: _primaryColor),
        onPressed: () => _showTaskDetails(task),
      ),
    ),
  );
}

Widget _buildMaintenanceReportCard(String title, String date, String status) {
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
        Icon(Icons.description_rounded, color: _primaryColor, size: 24),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _textColor(),
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 12, color: _textSecondaryColor()),
                  SizedBox(width: 4),
                  Text(
                    date,
                    style: TextStyle(fontSize: 11, color: _textSecondaryColor()),
                  ),
                  SizedBox(width: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 10,
                        color: _successColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.download_rounded, color: _primaryColor, size: 20),
          onPressed: () {
  _downloadMaintenanceReportFromCard(title, date, status);
},
        ),
      ],
    ),
  );
}
void _downloadMaintenanceReportFromCard(String title, String date, String status) {
  _showSuccessMessage('جاري تحميل التقرير: $title');
}
Widget _buildEmptyMaintenanceState(String message, IconData icon) {
  return Container(
    padding: EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: _backgroundColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor()),
    ),
    child: Column(
      children: [
        Icon(icon, size: 48, color: _textSecondaryColor()),
        SizedBox(height: 12),
        Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: _textSecondaryColor(),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _buildTaskDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _textColor(),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: _textSecondaryColor(),
            ),
          ),
        ),
      ],
    ),
  );
}

Color _getTaskStatusColor(String status) {
  switch (status) {
    case 'قيد التنفيذ':
      return _primaryColor;
    case 'معلقة':
      return _warningColor;
    case 'مكتملة':
      return _successColor;
    case 'متأخرة':
      return _errorColor;
    default:
      return _textSecondaryColor();
  }
}

Color _getTaskPriorityColor(String priority) {
  switch (priority) {
    case 'عاجل':
      return _errorColor;
    case 'عالي':
      return _warningColor;
    case 'متوسط':
      return _accentColor;
    case 'منخفض':
      return _successColor;
    default:
      return _textSecondaryColor();
  }
}

IconData _getTaskIcon(String status) {
  switch (status) {
    case 'قيد التنفيذ':
      return Icons.play_circle_filled_rounded;
    case 'معلقة':
      return Icons.pause_circle_filled_rounded;
    case 'مكتملة':
      return Icons.check_circle_rounded;
    case 'متأخرة':
      return Icons.warning_rounded;
    default:
      return Icons.engineering_rounded;
  }
}


Widget _buildMaintenanceReportRequestButton(String title, IconData icon, Color color, String reportType) {
  return ElevatedButton(
    onPressed: () {
      _showMaintenanceReportRequestConfirmation(reportType);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
Widget _buildMaintenanceEmptyRequests() {
  return Container(
    padding: EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: _backgroundColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: _borderColor().withOpacity(0.5),
        width: 1.5,
      ),
    ),
    child: Column(
      children: [
        Icon(Icons.send_rounded, size: 48, color: _textSecondaryColor()),
        SizedBox(height: 12),
        Text(
          'لا توجد طلبات تقارير',
          style: TextStyle(
            fontSize: 16,
            color: _textSecondaryColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'يمكنك إرسال طلب تقرير باستخدام الأزرار أعلاه',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _textSecondaryColor(),
          ),
        ),
      ],
    ),
  );
}

// ========== قسم التقارير الواردة للصيانة ==========

Widget _buildMaintenanceReceivedReportsSection() {
  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _borderColor()),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
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
                'التقارير الواردة من فني الصيانة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textColor(),
                ),
              ),
              Spacer(),
              Badge(
                label: Text('${_maintenanceReceivedReports.where((r) => !r['read']).length}'),
                backgroundColor: _primaryColor,
                child: Icon(Icons.notifications_rounded, color: _primaryColor),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // فلترة التقارير
          _buildMaintenanceReportFilter(),
          SizedBox(height: 20),
          
          // قائمة التقارير الواردة
          if (_maintenanceReceivedReports.isEmpty)
            _buildMaintenanceEmptyReports()
          else
            Column(
              children: _getFilteredMaintenanceReports().map((report) => _buildMaintenanceReceivedReportItem(report)).toList(),
            ),
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
            onSelected: (selected) {
              setState(() {
                _maintenanceReportFilter = filter;
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
              side: BorderSide(
                color: isSelected ? _primaryColor : _borderColor(),
              ),
            ),
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
                style: TextStyle(
                  fontSize: 10,
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 12),
        
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
            
            // التاريخ والوقت
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
        
        // نوع التقرير والأولوية
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
            
            // حجم الملف
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
        
        SizedBox(height: 16),
        
        // أزرار الإجراءات
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _viewMaintenanceReport(report);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primaryColor,
                  side: BorderSide(color: _primaryColor),
                ),
                icon: Icon(Icons.remove_red_eye_rounded, size: 16),
                label: Text('عرض التقرير'),
              ),
            ),
            
            SizedBox(width: 8),
            
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _downloadMaintenanceReport(report);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                ),
                icon: Icon(Icons.download_rounded, size: 16),
                label: Text('تحميل'),
              ),
            ),
            
            SizedBox(width: 8),
            
            IconButton(
              onPressed: () {
                _showMaintenanceReportOptions(report);
              },
              icon: Icon(Icons.more_vert_rounded, color: _primaryColor),
            ),
          ],
        ),
      ],
    ),
  );
}
Color _getMaintenanceReportStatusColor(String status) {
  switch (status) {
    case 'جديد':
      return _primaryColor;
    case 'مكتمل':
      return _successColor;
    case 'قيد المراجعة':
      return _warningColor;
    case 'مرفوض':
      return _errorColor;
    default:
      return _textSecondaryColor();
  }
}

Color _getMaintenancePriorityColor(String priority) {
  switch (priority) {
    case 'عالي':
      return _errorColor;
    case 'متوسط':
      return _warningColor;
    case 'عادي':
      return _successColor;
    default:
      return _textSecondaryColor();
  }
}
Widget _buildMaintenanceEmptyReports() {
  return Container(
    padding: EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: _backgroundColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor(), style: BorderStyle.solid),
    ),
    child: Column(
      children: [
        Icon(Icons.inbox_rounded, size: 48, color: _textSecondaryColor()),
        SizedBox(height: 12),
        Text(
          'لا توجد تقارير واردة',
          style: TextStyle(
            fontSize: 16,
            color: _textSecondaryColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'سيظهر هنا التقارير المرسلة من فني الصيانة',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _textSecondaryColor(),
          ),
        ),
      ],
    ),
  );
}
void _viewMaintenanceReport(Map<String, dynamic> report) {
  // تحديث حالة القراءة
  setState(() {
    report['read'] = true;
  });
  
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: _cardColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // رأس التقرير
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
                  Icon(Icons.engineering_rounded, color: Colors.white),
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
                    // معلومات التقرير
                    _buildViewDetail('المرسل', report['sender']),
                    _buildViewDetail('نوع التقرير', report['type']),
                    _buildViewDetail('التاريخ', '${report['date']} ${report['time']}'),
                    _buildViewDetail('الأولوية', report['priority']),
                    _buildViewDetail('حجم الملف', report['size']),
                    _buildViewDetail('الصيغة', report['format']),
                    
                    SizedBox(height: 16),
                    Divider(color: _borderColor()),
                    SizedBox(height: 16),
                    
                    // ملخص التقرير
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
            
            // أزرار الإجراءات
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
                        _downloadMaintenanceReport(report);
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


void _showMaintenanceRequestDetails(Map<String, dynamic> request) {
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: _textColor(),
              ),
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
void _showMaintenanceReportRequestConfirmation(String reportType) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
            style: TextStyle(
              color: _textColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'هل تريد إرسال طلب لتقرير $reportType إلى فني الصيانة المسؤول؟',
            style: TextStyle(
              color: _textColor(),
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          
          // تفاصيل الطلب
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _textColor(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                _buildRequestDetail('نوع التقرير', 'تقرير $reportType'),
                _buildRequestDetail('المستلم', 'فني الصيانة المسؤول'),
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
          child: Text(
            'إلغاء',
            style: TextStyle(color: _textSecondaryColor()),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _sendMaintenanceReportRequest(reportType);
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
void _sendMaintenanceReportRequest(String reportType) {
  // إضافة طلب جديد للقائمة
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
  
  // إظهار رسالة نجاح
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.white),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'تم إرسال طلب التقرير $reportType بنجاح',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      backgroundColor: _successColor,
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
Widget _buildSimpleDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _textColor(),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: _textSecondaryColor(),
            ),
          ),
        ),
      ],
    ),
  );
}
// ========== دوال التفاعل ==========

void _updateTaskStatus(Map<String, dynamic> task, String newStatus) {
  setState(() {
    task['status'] = newStatus;
  });
  
  _showSuccessMessage('تم تحديث حالة المهمة "${task['title']}" إلى "$newStatus"');
}

void _showTaskDetails(Map<String, dynamic> task) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(),
      title: Text('تفاصيل المهمة'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTaskDetailRow('عنوان المهمة:', task['title']),
            _buildTaskDetailRow('رقم المهمة:', task['id']),
            _buildTaskDetailRow('الفني:', task['technician']),
            _buildTaskDetailRow('الموقع:', task['location']),
            _buildTaskDetailRow('الحالة:', task['status']),
            _buildTaskDetailRow('الأولوية:', task['priority']),
            _buildTaskDetailRow('تاريخ البدء:', task['startDate']),
            
            if (task['endDate'] != null)
              _buildTaskDetailRow('تاريخ الانتهاء:', task['endDate']),
            
            if (task['duration'] != null)
              _buildTaskDetailRow('المدة:', task['duration']),
            
            if (task['estimatedTime'] != null)
              _buildTaskDetailRow('الوقت المقدر:', task['estimatedTime']),
            
            if (task['delayReason'] != null)
              _buildTaskDetailRow('سبب التأخير:', task['delayReason']),
            
            if (task['description'] != null)
              _buildTaskDetailRow('الوصف:', task['description']),
            
            if (task['rating'] != null)
              _buildTaskDetailRow('التقييم:', task['rating'].toString() + '/5'),
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

void _generateMaintenanceReport() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(),
      title: Text('إنشاء تقرير الصيانة'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('اختر نوع التقرير:'),
          SizedBox(height: 16),
          
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showMaintenanceReportDialog('يومي');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 45),
            ),
            child: Text('تقرير يومي'),
          ),
          SizedBox(height: 8),
          
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showMaintenanceReportDialog('أسبوعي');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentColor,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 45),
            ),
            child: Text('تقرير أسبوعي'),
          ),
          SizedBox(height: 8),
          
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showMaintenanceReportDialog('شهري');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _secondaryColor,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 45),
            ),
            child: Text('تقرير شهري'),
          ),
        ],
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
void _showMaintenanceReportOptions(Map<String, dynamic> report) {
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
              _shareMaintenanceReport(report);
            },
          ),
          ListTile(
            leading: Icon(Icons.archive_rounded, color: _primaryColor),
            title: Text('أرشفة التقرير'),
            onTap: () {
              Navigator.pop(context);
              _archiveMaintenanceReport(report);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_rounded, color: _errorColor),
            title: Text('حذف التقرير', style: TextStyle(color: _errorColor)),
            onTap: () {
              Navigator.pop(context);
              _deleteMaintenanceReport(report);
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

void _shareMaintenanceReport(Map<String, dynamic> report) {
  _showSuccessMessage('تم إعداد التقرير للمشاركة: ${report['title']}');
}

void _archiveMaintenanceReport(Map<String, dynamic> report) {
  setState(() {
    _maintenanceReceivedReports.remove(report);
  });
  _showSuccessMessage('تم أرشفة التقرير');
}

void _deleteMaintenanceReport(Map<String, dynamic> report) {
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
              _maintenanceReceivedReports.remove(report);
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
void _showMaintenanceReportDialog(String type) {
  String reportTitle = '';
  String reportDescription = '';
  
  switch (type) {
    case 'يومي':
      reportTitle = 'تقرير الصيانة اليومي';
      reportDescription = 'تقرير مفصل عن أعمال الصيانة التي تمت اليوم';
      break;
    case 'أسبوعي':
      reportTitle = 'تقرير الصيانة الأسبوعي';
      reportDescription = 'تقرير شامل عن أعمال الصيانة خلال الأسبوع';
      break;
    case 'شهري':
      reportTitle = 'تقرير الصيانة الشهري';
      reportDescription = 'تقرير تحليلي عن أداء الصيانة خلال الشهر';
      break;
  }
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(),
      title: Text(reportTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reportDescription),
            SizedBox(height: 20),
            Text('سيحتوي التقرير على:'),
            SizedBox(height: 12),
            _buildReportFeature('إحصائيات المهام'),
            _buildReportFeature('تحليل الأداء'),
            _buildReportFeature('المهام المتأخرة'),
            _buildReportFeature('تقارير الفنيين'),
            _buildReportFeature('التكاليف والإيرادات'),
            _buildReportFeature('التوصيات والمقترحات'),
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
            _createMaintenanceReport(type);
          },
          child: Text('إنشاء التقرير'),
        ),
      ],
    ),
  );
}
void _createMaintenanceReport(String type) {
  // هنا يمكنك إضافة منطق إنشاء التقرير الفعلي
  _showSuccessMessage('تم إنشاء تقرير الصيانة $type بنجاح');
}
void _downloadMaintenanceReport(Map<String, dynamic> report) {
  _showSuccessMessage('جاري تحميل التقرير: ${report['title']}');
}

void _showNewMaintenanceRequestDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(),
      title: Text('إضافة طلب صيانة جديد'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'عنوان الطلب',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'اسم مقدم الطلب',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'الموقع',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'وصف المشكلة',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'الأولوية',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 'عاجل', child: Text('عاجل')),
                DropdownMenuItem(value: 'عالي', child: Text('عالي')),
                DropdownMenuItem(value: 'متوسط', child: Text('متوسط')),
                DropdownMenuItem(value: 'منخفض', child: Text('منخفض')),
              ],
              onChanged: (value) {},
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
            _showSuccessMessage('تم إضافة طلب الصيانة بنجاح');
          },
          child: Text('إضافة'),
        ),
      ],
    ),
  );
}

void _assignMaintenanceRequest(String requestTitle) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(),
      title: Text('تعيين طلب الصيانة'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('تعيين "$requestTitle" إلى:'),
          SizedBox(height: 16),
          
          // قائمة الفنيين المتاحين (ستأتي من قاعدة البيانات)
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person_rounded),
            ),
            title: Text('حسن عبدالله'),
            subtitle: Text('فني كهرباء'),
            onTap: () {
              Navigator.pop(context);
              _assignToTechnician(requestTitle, 'حسن عبدالله');
            },
          ),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person_rounded),
            ),
            title: Text('علي محمد'),
            subtitle: Text('فني محطات'),
            onTap: () {
              Navigator.pop(context);
              _assignToTechnician(requestTitle, 'علي محمد');
            },
          ),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person_rounded),
            ),
            title: Text('محمد كريم'),
            subtitle: Text('فني عدادات'),
            onTap: () {
              Navigator.pop(context);
              _assignToTechnician(requestTitle, 'محمد كريم');
            },
          ),
        ],
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

void _assignToTechnician(String requestTitle, String technicianName) {
  _showSuccessMessage('تم تعيين "$requestTitle" إلى الفني "$technicianName"');
}
// ========== إحصائيات الجودة ==========
Widget _buildQualityStats() {
  int totalParameters = 8; // إجمالي المعاملات
  int normalParameters = 6; // المعاملات الطبيعية
  int warningParameters = 1; // معاملات تحت الإنذار
  int criticalParameters = 1; // معاملات حرجة
  double qualityRate = (normalParameters / totalParameters * 100);
  
  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _borderColor()),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // العنوان
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.analytics_rounded, color: _primaryColor, size: 24),
              ),
              SizedBox(width: 12),
              Text(
                'إحصائيات جودة الكهرباء',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // إحصائيات رئيسية
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQualityStatCard(
                'معدل الجودة',
                '${qualityRate.toStringAsFixed(1)}%',
                Icons.analytics_rounded,
                _primaryColor,
              ),
              _buildQualityStatCard(
                'إنذارات نشطة',
                criticalParameters.toString(),
                Icons.warning_rounded,
                _errorColor,
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // إحصائيات ثانوية
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSimpleQualityStat('طبيعية', normalParameters.toString(), _successColor),
              _buildSimpleQualityStat('تحت الإنذار', warningParameters.toString(), _warningColor),
              _buildSimpleQualityStat('حرجة', criticalParameters.toString(), _errorColor),
              _buildSimpleQualityStat('المجموع', totalParameters.toString(), _accentColor),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildQualityStatCard(String title, String value, IconData icon, Color color) {
  return Column(
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, color: color, size: 30),
      ),
      SizedBox(height: 12),
      Text(
        value,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _textColor(),
        ),
      ),
      SizedBox(height: 4),
      Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: _textSecondaryColor(),
        ),
      ),
    ],
  );
}

Widget _buildSimpleQualityStat(String title, String value, Color color) {
  return Column(
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
      SizedBox(height: 6),
      Text(
        title,
        style: TextStyle(
          fontSize: 11,
          color: _textSecondaryColor(),
        ),
      ),
    ],
  );
}

// ========== تبويبات التقارير ==========
int _selectedQualityTab = 0; // 0: طلبات التقارير، 1: التقارير الواردة

Widget _buildQualityReportTabs() {
  return Column(
    children: [
      // شريط التبويبات
      Container(
        height: 50,
        decoration: BoxDecoration(
          color: _cardColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderColor()),
        ),
        child: Row(
          children: [
            _buildQualityReportTabButton('طلبات التقارير', 0),
            _buildQualityReportTabButton('التقارير الواردة', 1),
          ],
        ),
      ),
      
      SizedBox(height: 16),
      
      // محتوى التبويب المحدد
      _selectedQualityTab == 0 
          ? _buildQualityReportRequestsSection() 
          : _buildQualityReceivedReportsSection(),
    ],
  );
}
Widget _buildQualityReportTabButton(String title, int index) {
  bool isSelected = _selectedQualityTab == index;
  return Expanded(
    child: GestureDetector(
      onTap: () {
        setState(() {
          _selectedQualityTab = index;
        });
      },
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
// قائمة طلبات التقارير للجودة
List<Map<String, dynamic>> _qualityReportRequests = [
  {
    'id': 'QUAL-REQ-001',
    'type': 'يومي',
    'title': 'طلب تقرير جودة يومي',
    'requestedBy': 'مسؤول المحطة',
    'date': '2024-03-20',
    'status': 'معلق',
    'priority': 'عادي',
    'dueDate': '2024-03-21',
    'description': 'تقرير مفصل عن معاملات الجودة اليومية لجميع المناطق',
  },
  {
    'id': 'QUAL-REQ-002',
    'type': 'أسبوعي',
    'title': 'طلب تقرير الإنذارات الأسبوعي',
    'requestedBy': 'مدير التشغيل',
    'date': '2024-03-19',
    'status': 'قيد التنفيذ',
    'priority': 'عالي',
    'dueDate': '2024-03-22',
    'description': 'تقرير عن جميع إنذارات الجودة وأسبابها خلال الأسبوع',
  },
  {
    'id': 'QUAL-REQ-003',
    'type': 'شهري',
    'title': 'طلب تحليل أداء الجودة الشهري',
    'requestedBy': 'المدير العام',
    'date': '2024-03-15',
    'status': 'مكتمل',
    'priority': 'عالي',
    'dueDate': '2024-03-25',
    'description': 'تحليل شامل لأداء الجودة ومعدل الاستقرار الشهري',
  },
];
Widget _buildQualityReportRequestsSection() {
  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _borderColor()),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
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
                'طلب تقارير من مراقب الجودة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textColor(),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // رسالة توضيحية
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
                    'سيتم إرسال طلب التقرير إلى مسؤول مراقبة جودة الكهرباء لإنشائه',
                    style: TextStyle(
                      color: _textColor(),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          
          // أزرار طلب التقارير
          Row(
            children: [
              Expanded(
                child: _buildQualityReportRequestButton(
                  'طلب تقرير يومي', 
                  Icons.today_rounded, 
                  _primaryColor, 
                  'يومي'
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildQualityReportRequestButton(
                  'طلب تقرير أسبوعي', 
                  Icons.date_range_rounded, 
                  _accentColor, 
                  'أسبوعي'
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildQualityReportRequestButton(
                  'طلب تقرير شهري', 
                  Icons.calendar_month_rounded, 
                  _secondaryColor, 
                  'شهري'
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // قائمة طلبات التقارير
          Text(
            'طلباتي الأخيرة',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textColor(),
            ),
          ),
          SizedBox(height: 12),
          
          if (_qualityReportRequests.isEmpty)
            _buildQualityEmptyRequests()
          else
            Column(
              children: _qualityReportRequests.map((request) => _buildQualityRequestItem(request)).toList(),
            ),
        ],
      ),
    ),
  );
}
Widget _buildQualityReportRequestButton(String title, IconData icon, Color color, String reportType) {
  return ElevatedButton(
    onPressed: () {
      _showQualityReportRequestConfirmation(reportType);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
Widget _buildQualityRequestItem(Map<String, dynamic> request) {
  Color statusColor = _getQualityRequestStatusColor(request['status']);
  
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
            _getQualityRequestIcon(request['status']),
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
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _textColor(),
                ),
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
          onPressed: () {
            _showQualityRequestDetails(request);
          },
        ),
      ],
    ),
  );
}
Color _getQualityRequestStatusColor(String status) {
  switch (status) {
    case 'معلق':
      return _warningColor;
    case 'قيد التنفيذ':
      return _accentColor;
    case 'مكتمل':
      return _successColor;
    default:
      return _textSecondaryColor();
  }
}

IconData _getQualityRequestIcon(String status) {
  switch (status) {
    case 'معلق':
      return Icons.pending_rounded;
    case 'قيد التنفيذ':
      return Icons.hourglass_bottom_rounded;
    case 'مكتمل':
      return Icons.check_circle_rounded;
    default:
      return Icons.analytics_rounded;
  }
}
Widget _buildQualityEmptyRequests() {
  return Container(
    padding: EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: _backgroundColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: _borderColor().withOpacity(0.5),
        width: 1.5,
      ),
    ),
    child: Column(
      children: [
        Icon(Icons.send_rounded, size: 48, color: _textSecondaryColor()),
        SizedBox(height: 12),
        Text(
          'لا توجد طلبات تقارير',
          style: TextStyle(
            fontSize: 16,
            color: _textSecondaryColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'يمكنك إرسال طلب تقرير باستخدام الأزرار أعلاه',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _textSecondaryColor(),
          ),
        ),
      ],
    ),
  );
}
// قائمة التقارير الواردة للجودة
List<Map<String, dynamic>> _qualityReceivedReports = [
  {
    'id': 'QUAL-REP-001',
    'title': 'تقرير الجودة اليومي - 20 مارس',
    'type': 'يومي',
    'sender': 'أحمد السعدون - مراقب جودة',
    'date': '2024-03-20',
    'time': '10:30 ص',
    'status': 'جديد',
    'read': false,
    'priority': 'عالي',
    'size': '2.4 MB',
    'format': 'PDF',
    'summary': 'تقرير مفصل عن معاملات الجودة اليومية لجميع المناطق مع تحليل للانحرافات',
    'attachments': 3,
  },
  {
    'id': 'QUAL-REP-002',
    'title': 'تحليل الإنذارات الأسبوعي',
    'type': 'أسبوعي',
    'sender': 'سارة العبيدي - مراقبة جودة',
    'date': '2024-03-19',
    'time': '02:15 م',
    'status': 'مكتمل',
    'read': true,
    'priority': 'متوسط',
    'size': '3.1 MB',
    'format': 'PDF',
    'summary': 'تحليل شامل للإنذارات والمخالفات خلال الأسبوع مع توصيات',
    'attachments': 5,
  },
  {
    'id': 'QUAL-REP-003',
    'title': 'تقرير الجودة الشهري - فبراير 2024',
    'type': 'شهري',
    'sender': 'محمد الحسين - رئيس المراقبة',
    'date': '2024-03-05',
    'time': '09:00 ص',
    'status': 'مكتمل',
    'read': true,
    'priority': 'عالي',
    'size': '4.8 MB',
    'format': 'PDF',
    'summary': 'تحليل كامل للجودة الشهرية ومقارنة مع الأشهر السابقة',
    'attachments': 7,
  },
  {
    'id': 'QUAL-REP-004',
    'title': 'تقرير جودة المناطق الشمالية',
    'type': 'خاص',
    'sender': 'خالد إبراهيم - مراقب منطقة',
    'date': '2024-03-18',
    'time': '11:45 ص',
    'status': 'جديد',
    'read': false,
    'priority': 'عالي',
    'size': '1.9 MB',
    'format': 'PDF',
    'summary': 'تقرير مفصل عن جودة المنطقة الشمالية مع إنذارات هامة',
    'attachments': 2,
  },
];
Widget _buildQualityReceivedReportsSection() {
  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _borderColor()),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
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
                'التقارير الواردة من مراقب الجودة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textColor(),
                ),
              ),
              Spacer(),
              Badge(
                label: Text('${_qualityReceivedReports.where((r) => !r['read']).length}'),
                backgroundColor: _primaryColor,
                child: Icon(Icons.notifications_rounded, color: _primaryColor),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // فلترة التقارير
          _buildQualityReportFilter(),
          SizedBox(height: 20),
          
          // قائمة التقارير الواردة
          if (_qualityReceivedReports.isEmpty)
            _buildQualityEmptyReports()
          else
            Column(
              children: _getFilteredQualityReports().map((report) => _buildQualityReceivedReportItem(report)).toList(),
            ),
        ],
      ),
    ),
  );
}
Widget _buildQualityReportFilter() {
  List<String> filters = ['الكل', 'يومي', 'أسبوعي', 'شهري', 'خاص'];
  
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: filters.map((filter) {
        bool isSelected = _qualityReportFilter == filter;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _qualityReportFilter = filter;
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
              side: BorderSide(
                color: isSelected ? _primaryColor : _borderColor(),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
List<Map<String, dynamic>> _getFilteredQualityReports() {
  if (_qualityReportFilter == 'الكل') return _qualityReceivedReports;
  return _qualityReceivedReports.where((report) => report['type'] == _qualityReportFilter).toList();
}
Widget _buildQualityReceivedReportItem(Map<String, dynamic> report) {
  Color statusColor = _getQualityReportStatusColor(report['status']);
  Color priorityColor = _getQualityPriorityColor(report['priority']);
  
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
                style: TextStyle(
                  fontSize: 10,
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 12),
        
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
            
            // التاريخ والوقت
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
        
        // نوع التقرير والأولوية
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
            
            // حجم الملف
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
        
        SizedBox(height: 16),
        
        // أزرار الإجراءات
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _viewQualityReport(report);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primaryColor,
                  side: BorderSide(color: _primaryColor),
                ),
                icon: Icon(Icons.remove_red_eye_rounded, size: 16),
                label: Text('عرض التقرير'),
              ),
            ),
            
            SizedBox(width: 8),
            
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _downloadQualityReport(report);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                ),
                icon: Icon(Icons.download_rounded, size: 16),
                label: Text('تحميل'),
              ),
            ),
            
            SizedBox(width: 8),
            
            IconButton(
              onPressed: () {
                _showQualityReportOptions(report);
              },
              icon: Icon(Icons.more_vert_rounded, color: _primaryColor),
            ),
          ],
        ),
      ],
    ),
  );
}
Color _getQualityReportStatusColor(String status) {
  switch (status) {
    case 'جديد':
      return _primaryColor;
    case 'مكتمل':
      return _successColor;
    case 'قيد المراجعة':
      return _warningColor;
    case 'مرفوض':
      return _errorColor;
    default:
      return _textSecondaryColor();
  }
}

Color _getQualityPriorityColor(String priority) {
  switch (priority) {
    case 'عالي':
      return _errorColor;
    case 'متوسط':
      return _warningColor;
    case 'عادي':
      return _successColor;
    default:
      return _textSecondaryColor();
  }
}
Widget _buildQualityEmptyReports() {
  return Container(
    padding: EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: _backgroundColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor(), style: BorderStyle.solid),
    ),
    child: Column(
      children: [
        Icon(Icons.inbox_rounded, size: 48, color: _textSecondaryColor()),
        SizedBox(height: 12),
        Text(
          'لا توجد تقارير واردة',
          style: TextStyle(
            fontSize: 16,
            color: _textSecondaryColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'سيظهر هنا التقارير المرسلة من مراقب الجودة',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _textSecondaryColor(),
          ),
        ),
      ],
    ),
  );
}
// ========== قسم المراقبة الفورية ==========
Widget _buildLiveMonitoringSection() {
  return Container(
    decoration: BoxDecoration(
      color: _cardColor(),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _borderColor()),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
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
                  color: _accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.monitor_heart_rounded, color: _accentColor, size: 24),
              ),
              SizedBox(width: 12),
              Text(
                'مراقبة جودة فورية',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textColor(),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          
          // معاملات الجودة الرئيسية
          Row(
            children: [
              Expanded(
                child: _buildLiveParameterCard('الجهد', '230V', 'طبيعي', Icons.bolt_rounded, _successColor),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildLiveParameterCard('التردد', '50.1 Hz', 'طبيعي', Icons.speed_rounded, _successColor),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildLiveParameterCard('الحرارة', '45°C', 'طبيعي', Icons.thermostat_rounded, _successColor),
              ),
            ],
          ),
          
          SizedBox(height: 20),
          
          // زر المراقبة المتقدمة
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _showAdvancedMonitoring();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.monitor_rounded),
              label: Text('المراقبة المتقدمة'),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildLiveParameterCard(String title, String value, String status, IconData icon, Color color) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _textColor(),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

// ========== دوال التفاعل مع تبويب الجودة ==========
void _showQualityReportRequestConfirmation(String reportType) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
            style: TextStyle(
              color: _textColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'هل تريد إرسال طلب لتقرير $reportType إلى مسؤول مراقبة جودة الكهرباء؟',
            style: TextStyle(
              color: _textColor(),
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          
          // تفاصيل الطلب
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _textColor(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                _buildQualityRequestDetail('نوع التقرير', 'تقرير $reportType'),
                _buildQualityRequestDetail('المستلم', 'مسؤول مراقبة جودة الكهرباء'),
                _buildQualityRequestDetail('حالة الطلب', 'سيكون معلق'),
                _buildQualityRequestDetail('وقت الاستجابة المتوقع', '24-48 ساعة'),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'إلغاء',
            style: TextStyle(color: _textSecondaryColor()),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _sendQualityReportRequest(reportType);
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
void _sendQualityReportRequest(String reportType) {
  // إضافة طلب جديد للقائمة
  setState(() {
    _qualityReportRequests.insert(0, {
      'id': 'QUAL-REQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(8, 12)}',
      'type': reportType,
      'title': 'طلب تقرير جودة $reportType',
      'requestedBy': 'مسؤول المحطة',
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'status': 'معلق',
      'priority': 'عادي',
      'dueDate': DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1))),
      'description': 'تقرير مفصل عن معاملات الجودة $reportType',
    });
  });
  
  // إظهار رسالة نجاح
  _showSuccessMessage('تم إرسال طلب التقرير $reportType بنجاح');
}
Widget _buildQualityRequestDetail(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _textColor(),
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: _textSecondaryColor(),
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
}
void _showQualityRequestDetails(Map<String, dynamic> request) {
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: _textColor(),
              ),
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
// دالة عامة لعرض التقرير مع أيقونة قابلة للتخصيص
void _showReportDialog(Map<String, dynamic> report, IconData icon) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: _cardColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // رأس التقرير
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
                  Icon(icon, color: Colors.white),
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
                    // معلومات التقرير
                    _buildViewDetail('المرسل', report['sender']),
                    _buildViewDetail('نوع التقرير', report['type']),
                    _buildViewDetail('التاريخ', '${report['date']} ${report['time']}'),
                    _buildViewDetail('الأولوية', report['priority']),
                    _buildViewDetail('حجم الملف', report['size']),
                    _buildViewDetail('الصيغة', report['format']),
                    
                    SizedBox(height: 16),
                    Divider(color: _borderColor()),
                    SizedBox(height: 16),
                    
                    // ملخص التقرير
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
            
            // أزرار الإجراءات
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
                        _downloadReport(report);
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
void _viewQualityReport(Map<String, dynamic> report) {
  setState(() {
    report['read'] = true;
  });
  _showQualityReportDialog(report);
}
void _downloadQualityReport(Map<String, dynamic> report) {
  _showSuccessMessage('جاري تحميل التقرير: ${report['title']}');
}
void _showQualityReportDialog(Map<String, dynamic> report) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: _cardColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // رأس التقرير
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
                  Icon(Icons.analytics_rounded, color: Colors.white),
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
                    // معلومات التقرير
                    _buildViewDetail('المرسل', report['sender']),
                    _buildViewDetail('نوع التقرير', report['type']),
                    _buildViewDetail('التاريخ', '${report['date']} ${report['time']}'),
                    _buildViewDetail('الأولوية', report['priority']),
                    _buildViewDetail('حجم الملف', report['size']),
                    _buildViewDetail('الصيغة', report['format']),
                    
                    SizedBox(height: 16),
                    Divider(color: _borderColor()),
                    SizedBox(height: 16),
                    
                    // ملخص التقرير
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
            
            // أزرار الإجراءات
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
                        _downloadQualityReport(report);
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
void _showQualityReportOptions(Map<String, dynamic> report) {
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
              _shareReport(report);
            },
          ),
          ListTile(
            leading: Icon(Icons.archive_rounded, color: _primaryColor),
            title: Text('أرشفة التقرير'),
            onTap: () {
              Navigator.pop(context);
              _archiveQualityReport(report);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_rounded, color: _errorColor),
            title: Text('حذف التقرير', style: TextStyle(color: _errorColor)),
            onTap: () {
              Navigator.pop(context);
              _deleteQualityReport(report);
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


void _shareQualityReport(Map<String, dynamic> report) {
  _showSuccessMessage('تم إعداد التقرير للمشاركة: ${report['title']}');
}

void _archiveQualityReport(Map<String, dynamic> report) {
  setState(() {
    _qualityReceivedReports.remove(report);
  });
  _showSuccessMessage('تم أرشفة التقرير');
}


void _deleteQualityReport(Map<String, dynamic> report) {
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
              _qualityReceivedReports.remove(report);
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
void _showAdvancedMonitoring() {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: _cardColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
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
                  Icon(Icons.monitor_heart_rounded, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    'المراقبة المتقدمة للجودة',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
                    Text(
                      'معاملات الجودة التفصيلية:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: _primaryColor,
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    _buildAdvancedParameter('الجهد الكهربائي', '230V', '220V - 240V', 'طبيعي'),
                    _buildAdvancedParameter('التردد', '50.1 Hz', '49.8 - 50.2 Hz', 'طبيعي'),
                    _buildAdvancedParameter('معامل القدرة', '0.95', '> 0.9', 'ممتاز'),
                    _buildAdvancedParameter('التيار', '150A', '< 200A', 'طبيعي'),
                    _buildAdvancedParameter('درجة الحرارة', '45°C', '< 60°C', 'طبيعي'),
                    _buildAdvancedParameter('الرطوبة', '35%', '< 50%', 'طبيعي'),
                    _buildAdvancedParameter('الاهتزازات', '2.5 mm/s', '< 5 mm/s', 'طبيعي'),
                    _buildAdvancedParameter('التوافقية', '3.2%', '< 5%', 'طبيعي'),
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
                        _generateAdvancedReport();
                      },
                      icon: Icon(Icons.summarize_rounded),
                      label: Text('تقرير متقدم'),
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

Widget _buildAdvancedParameter(String name, String value, String range, String status) {
  Color statusColor = status == 'طبيعي' || status == 'ممتاز' ? _successColor : _errorColor;
  
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _textColor(),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'النطاق: $range',
                style: TextStyle(
                  fontSize: 12,
                  color: _textSecondaryColor(),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
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
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void _generateAdvancedReport() {
  _showSuccessMessage('تم إنشاء تقرير المراقبة المتقدمة');
}
void _showSuccessMessage(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.white),
          SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: _successColor,
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
  Widget _buildReportsTab(isDarkMode) {
    // نفس الكود الأصلي
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // نفس الكود الأصلي
        ],
      ),
    );
  }

  // ========== الدوال المساعدة ==========

  List<Map<String, dynamic>> _getFilteredBills() {
    switch (_billFilter) {
      case 'مدفوعة':
        return bills.where((bill) => bill['status'] == 'paid').toList();
      case 'غير مدفوعة':
        return bills.where((bill) => bill['status'] == 'unpaid').toList();
      case 'متأخرة':
        return bills.where((bill) => bill['status'] == 'overdue').toList();
      case 'الكل':
      default:
        return bills;
    }
  }

  Color _getBillStatusColor(String status) {
    switch (status) {
      case 'paid':
        return _successColor;
      case 'unpaid':
        return _warningColor;
      case 'overdue':
        return _errorColor;
      default:
        return _textSecondaryColor();
    }
  }

  String _getBillStatusText(String status) {
    switch (status) {
      case 'paid':
        return 'مدفوعة';
      case 'unpaid':
        return 'غير مدفوعة';
      case 'overdue':
        return 'متأخرة';
      default:
        return 'غير معروف';
    }
  }

  void _showPaymentMethodDetails(Map<String, dynamic> method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(),
        title: Text('تفاصيل طريقة الدفع'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('اسم الطريقة:', method['name']),
              _buildDetailRow('إجمالي المبالغ:', '${_formatCurrency(method['totalAmount'])} دينار'),
              _buildDetailRow('عدد التحويلات:', method['totalTransfers'].toString()),
              SizedBox(height: 16),
              Text(
                'الحسابات البنكية:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...method['bankAccounts'].map<Widget>((account) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _backgroundColor(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account['bankName'],
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Text('اسم الحساب: ${account['accountName']}'),
                      Text('رقم الحساب: ${account['accountNumber']}'),
                    ],
                  ),
                );
              }).toList(),
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
              _buildDetailRow('إجمالي المبالغ:', '${_formatCurrency(citizen['totalAmount'])} دينار'),
              _buildDetailRow('آخر دفع:', citizen['lastPayment']),
              SizedBox(height: 16),
              
              if (citizenBills.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'فواتير المواطن:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ...citizenBills.map<Widget>((bill) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _backgroundColor(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  bill['id'],
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                            SizedBox(height: 4),
                            Text('المبلغ: ${_formatCurrency(bill['amountIQD'])} دينار'),
                            Text('الاستهلاك: ${bill['consumption']}'),
                            Text('طريقة الدفع: ${bill['paymentMethod']}'),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
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

  Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _textColor(),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: _textSecondaryColor(),
            ),
          ),
        ),
      ],
    ),
  );
}

  void _generateReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(),
        title: Text('إنشاء تقرير جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('سيتم إنشاء تقرير ${_selectedReportType} جديد'),
            SizedBox(height: 16),
            Text('هل تريد المتابعة؟'),
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
              _showSuccessMessage('تم إنشاء التقرير بنجاح');
            },
            child: Text('تأكيد'),
          ),
        ],
      ),
    );
  }
  Widget _buildQualityTab(isDarkMode) {
  return SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // إحصائيات الجودة
        _buildQualityStats(),
        SizedBox(height: 20),
        
        // تبويبات التقارير (طلبات التقارير والتقارير الواردة)
        _buildQualityReportTabs(),
        SizedBox(height: 20),
        
        // قسم المراقبة الفورية (اختياري - يمكن إزالته إذا لم ترده)
        _buildLiveMonitoringSection(),
      ],
    ),
  );
}
// دالة مساعدة لعنصر KPI الجودة
Widget _buildQualityKPI(String title, String value, IconData icon, Color color) {
  return Column(
    children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      SizedBox(height: 8),
      Text(
        value,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: _textColor(),
        ),
      ),
      SizedBox(height: 4),
      Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: _textSecondaryColor(),
        ),
      ),
    ],
  );
}

// دالة مساعدة لعنصر معامل الجودة
Widget _buildQualityParameterCard(Map<String, dynamic> parameter) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _backgroundColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor()),
    ),
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: parameter['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(parameter['icon'], color: parameter['color'], size: 24),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                parameter['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: _textColor(),
                ),
              ),
              SizedBox(height: 4),
              Text(
                parameter['value'],
                style: TextStyle(
                  fontSize: 14,
                  color: parameter['color'],
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'النطاق: ${parameter['range']}',
                style: TextStyle(
                  fontSize: 12,
                  color: _textSecondaryColor(),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: parameter['status'] == 'جيد' ? _successColor.withOpacity(0.1) : _errorColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: parameter['status'] == 'جيد' ? _successColor.withOpacity(0.3) : _errorColor.withOpacity(0.3),
            ),
          ),
          child: Text(
            parameter['status'],
            style: TextStyle(
              fontSize: 12,
              color: parameter['status'] == 'جيد' ? _successColor : _errorColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

// دالة مساعدة لعنصر إنذار الجودة
Widget _buildQualityAlarmCard(Map<String, dynamic> alarm) {
  Color severityColor = Colors.grey;
  switch (alarm['severity']) {
    case 'حرج':
      severityColor = Colors.red;
      break;
    case 'عالي':
      severityColor = Colors.orange;
      break;
    case 'متوسط':
      severityColor = Colors.yellow;
      break;
  }

  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: severityColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: severityColor.withOpacity(0.3)),
    ),
    child: Row(
      children: [
        Icon(Icons.warning_rounded, color: severityColor, size: 24),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alarm['type'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: severityColor,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on_rounded, size: 12, color: _textSecondaryColor()),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      alarm['location'],
                      style: TextStyle(fontSize: 12, color: _textSecondaryColor()),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.speed_rounded, size: 12, color: _textSecondaryColor()),
                  SizedBox(width: 4),
                  Text(
                    'القيمة: ${alarm['value']}',
                    style: TextStyle(fontSize: 12, color: _textSecondaryColor()),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.access_time_rounded, size: 12, color: _textSecondaryColor()),
                  SizedBox(width: 4),
                  Text(
                    alarm['time'],
                    style: TextStyle(fontSize: 12, color: _textSecondaryColor()),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: severityColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: severityColor.withOpacity(0.3)),
              ),
              child: Text(
                alarm['severity'],
                style: TextStyle(
                  fontSize: 12,
                  color: severityColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _handleQualityAlarm(alarm);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                minimumSize: Size.zero,
              ),
              child: Text(
                'معالجة',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// دالة مساعدة لعرض رسالة عدم وجود إنذارات
Widget _buildNoAlarmsMessage() {
  return Container(
    padding: EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: _backgroundColor(),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor()),
    ),
    child: Column(
      children: [
        Icon(Icons.check_circle_rounded, size: 48, color: _successColor),
        SizedBox(height: 12),
        Text(
          'لا توجد إنذارات حالية',
          style: TextStyle(
            fontSize: 16,
            color: _textColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'جميع معاملات الجودة تعمل ضمن النطاق الطبيعي',
          style: TextStyle(
            color: _textSecondaryColor(),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

// دالة مساعدة لزر الوصلات السريعة
Widget _buildQuickLinkButton(String title, IconData icon, Color color, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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

// ========== دوال التفاعل مع تبويب الجودة ==========

void _generateQualityReport(List<Map<String, dynamic>> parameters, List<Map<String, dynamic>> alarms) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(),
      title: Text('تقرير جودة الكهرباء'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ملخص تقرير الجودة:', style: TextStyle(fontWeight: FontWeight.bold, color: _primaryColor)),
            SizedBox(height: 12),
            Text('• عدد معاملات الجودة: ${parameters.length}'),
            Text('• عدد الإنذارات النشطة: ${alarms.length}'),
            Text('• معدل الجودة العام: 94.5%'),
            Text('• التاريخ: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}'),
            SizedBox(height: 20),
            
            if (alarms.isNotEmpty) ...[
              Text('الإنذارات الحرجة:', style: TextStyle(fontWeight: FontWeight.bold, color: _errorColor)),
              SizedBox(height: 8),
              ...alarms.take(3).map((alarm) => 
                Text('• ${alarm['type']} - ${alarm['location']}')
              ).toList(),
              SizedBox(height: 20),
            ],
            
            Text('معاملات الجودة:', style: TextStyle(fontWeight: FontWeight.bold, color: _successColor)),
            SizedBox(height: 8),
            ...parameters.map((param) => 
              Text('• ${param['name']}: ${param['value']} (${param['status']})')
            ).toList(),
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
          onPressed: () {
            Navigator.pop(context);
            _showSuccessMessage('تم إنشاء تقرير الجودة بنجاح');
            // هنا يمكنك إضافة منطق حفظ أو تصدير التقرير
          },
          child: Text('حفظ التقرير'),
        ),
      ],
    ),
  );
}

void _handleQualityAlarm(Map<String, dynamic> alarm) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(),
      title: Row(
        children: [
          Icon(Icons.warning_rounded, color: Colors.orange),
          SizedBox(width: 8),
          Text('معالجة الإنذار'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('نوع الإنذار: ${alarm['type']}', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('الموقع: ${alarm['location']}'),
          Text('القيمة: ${alarm['value']}'),
          Text('الحدة: ${alarm['severity']}'),
          SizedBox(height: 20),
          Text('اختر الإجراء المناسب:', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إلغاء'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            _showSuccessMessage('تم معالجة إنذار ${alarm['type']}');
            // هنا يمكنك إضافة منطق معالجة الإنذار
          },
          child: Text('تأكيد المعالجة'),
        ),
      ],
    ),
  );
}

void _showAlarmsHistory(List<Map<String, dynamic>> alarms) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: _cardColor(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
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
                  Icon(Icons.history_rounded, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    'سجل إنذارات الجودة',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: alarms.map((alarm) => _buildAlarmHistoryItem(alarm)).toList(),
                ),
              ),
            ),
            
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: _borderColor())),
              ),
              child: Text(
                'إجمالي الإنذارات: ${alarms.length}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _textColor(),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildAlarmHistoryItem(Map<String, dynamic> alarm) {
  Color severityColor = Colors.grey;
  switch (alarm['severity']) {
    case 'حرج':
      severityColor = Colors.red;
      break;
    case 'عالي':
      severityColor = Colors.orange;
      break;
    case 'متوسط':
      severityColor = Colors.yellow;
      break;
  }

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
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: severityColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alarm['type'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _textColor(),
                ),
              ),
              SizedBox(height: 4),
              Text(
                alarm['location'],
                style: TextStyle(
                  fontSize: 12,
                  color: _textSecondaryColor(),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              alarm['time'],
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor(),
              ),
            ),
            SizedBox(height: 4),
            Text(
              alarm['value'],
              style: TextStyle(
                fontSize: 12,
                color: severityColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void _showQualitySettings() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(),
      title: Text('إعدادات مراقبة الجودة'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingSwitch('مراقبة تلقائية', 'مراقبة معاملات الجودة تلقائياً', true),
            _buildSettingSwitch('إشعارات الإنذارات', 'إرسال إشعارات عند حدوث إنذارات', true),
            _buildSettingSwitch('التقارير اليومية', 'إنشاء تقارير جودة يومية تلقائياً', false),
            _buildSettingSwitch('نسخ احتياطي', 'حفظ بيانات الجودة تلقائياً', true),
            SizedBox(height: 20),
            Text('عتبات الإنذار:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildThresholdSetting('انخفاض الجهد', '< 210V'),
            _buildThresholdSetting('ارتفاع الجهد', '> 250V'),
            _buildThresholdSetting('انخفاض التردد', '< 49.5 Hz'),
            _buildThresholdSetting('ارتفاع التردد', '> 50.5 Hz'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إلغاء'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            _showSuccessMessage('تم حفظ إعدادات الجودة');
          },
          child: Text('حفظ الإعدادات'),
        ),
      ],
    ),
  );
}

Widget _buildSettingSwitch(String title, String subtitle, bool value) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
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
                  color: _textColor(),
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: _textSecondaryColor(),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: (newValue) {},
          activeColor: _primaryColor,
        ),
      ],
    ),
  );
}

Widget _buildThresholdSetting(String parameter, String threshold) {
  return Container(
    margin: EdgeInsets.only(bottom: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          parameter,
          style: TextStyle(
            color: _textColor(),
          ),
        ),
        Text(
          threshold,
          style: TextStyle(
            color: _accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
}
// شاشة الإعدادات الخاصة بمسؤول المحطة
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
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('تم حفظ الإعدادات بنجاح'),
      backgroundColor: widget.successColor,
    ),
  );
  
  Navigator.pop(context);
}
void _resetToDefaults() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('إعادة التعيين'),
      content: Text('هل أنت متأكد من إعادة جميع الإعدادات إلى القيم الافتراضية؟'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم إعادة التعيين إلى الإعدادات الافتراضية'),
                backgroundColor: widget.primaryColor,
              ),
            );
          },
          child: Text('تأكيد'),
        ),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
      final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode; // استخدم المتغير من Provider
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
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save_rounded, color: Colors.white),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: Container(
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
              _buildDarkModeSwitch(context),
            _buildSettingsSection('الإشعارات', Icons.notifications_rounded, isDarkMode),
              _buildSettingSwitch(
                'تفعيل الإشعارات',
                'استلام إشعارات حول الفواتير والتحديثات',
                _notificationsEnabled,
                (bool value) => setState(() => _notificationsEnabled = value),isDarkMode,
              ),
              _buildSettingSwitch(
                'الصوت',
                'تشغيل صوت للإشعارات الواردة',
                _soundEnabled,
              (bool value) => setState(() => _notificationsEnabled = value),isDarkMode,

              ),
              _buildSettingSwitch(
                'الاهتزاز',
                'اهتزاز الجهاز عند استلام الإشعارات',
                _vibrationEnabled,
                (bool value) => setState(() => _vibrationEnabled = value),isDarkMode,
              ),

              SizedBox(height: 24),
            _buildSettingsSection('المظهر', Icons.palette_rounded, isDarkMode),
              
              _buildDarkModeSwitch(context),
              
              _buildSettingDropdown(
                'اللغة',
                _language,
                _languages,
                (String? value) => setState(() => _language = value!),isDarkMode,
              ),
              
              SizedBox(height: 24),
              _buildSettingsSection('الأمان والبيانات', Icons.security_rounded,isDarkMode),
              
              _buildSettingSwitch(
                'النسخ الاحتياطي التلقائي',
                'نسخ احتياطي تلقائي للبيانات',
                _autoBackup,
                (bool value) => setState(() => _autoBackup = value),isDarkMode,
              ),
              
              _buildSettingSwitch(
                'المصادقة البيومترية',
                'استخدام بصمة الإصبع أو التعرف على الوجه',
                _biometricAuth,
                (bool value) => setState(() => _biometricAuth = value),isDarkMode,
              ),
              
              _buildSettingSwitch(
                'المزامنة التلقائية',
                'مزامنة البيانات تلقائياً مع السحابة',
                _autoSync,
                (bool value) => setState(() => _autoSync = value),isDarkMode,
              ),
              
              SizedBox(height: 24),
              _buildSettingsSection('حول التطبيق', Icons.info_rounded,isDarkMode),
              _buildAboutCard(isDarkMode),

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
                        style: TextStyle(color: widget.accentColor),
                      ),
                    ),
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
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ],
    ),
  );
}

Widget _buildDarkModeSwitch(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  final isDarkMode = themeProvider.isDarkMode;
  
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
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
            color: isDarkMode ? Colors.amber.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            color: isDarkMode ? Colors.amber : Colors.grey,
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
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                isDarkMode ? 'مفعل - استمتع بتجربة مريحة للعين' : 'معطل - استمتع بالمظهر الافتراضي',
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.white70 : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        
        Switch(
          value: isDarkMode,
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

Widget _buildSettingSwitch(String title, String subtitle, bool value, Function(bool) onChanged, bool isDarkMode) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
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
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.white70 : Colors.grey[600],
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

Widget _buildSettingDropdown(String title, String value, List<String> items, Function(String?) onChanged, bool isDarkMode) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
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
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ),
        SizedBox(width: 12),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white10 : Colors.grey[50],
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
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              );
            }).toList(),
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
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
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
        _buildAboutRow('الإصدار', '1.0.0', isDarkMode),
        _buildAboutRow('تاريخ البناء', '2024-03-20', isDarkMode),
        _buildAboutRow('المطور', 'وزارة الكهرباء - العراق', isDarkMode),
        _buildAboutRow('رقم الترخيص', 'MOE-SUP-2024-001', isDarkMode),
        _buildAboutRow('آخر تحديث', '2024-03-15', isDarkMode),
        _buildAboutRow('البريد الإلكتروني', 'supervisor@electric.gov.iq', isDarkMode),
      ],
    ),
  );
}

Widget _buildAboutRow(String title, String value, bool isDarkMode) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.grey[600],
          ),
        ),
      ],
    ),
  );
}
}
// شاشة المساعدة والدعم الخاصة بمسؤول المحطة
class SupervisorHelpSupportScreen extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;

  const SupervisorHelpSupportScreen({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.successColor,
    required this.warningColor,
    required this.errorColor,
  }) : super(key: key);

  void _makePhoneCall(String phoneNumber, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري الاتصال بـ $phoneNumber'),
        backgroundColor: primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
    // يمكنك إضافة launch('tel:$phoneNumber') إذا أردت
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'المساعدة والدعم',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
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
              _buildContactCard(context),

              SizedBox(height: 24),

              _buildSectionTitle('الأسئلة الشائعة'),
              ..._buildFAQItems(),

              SizedBox(height: 24),
              _buildSectionTitle('معلومات التطبيق'),
              _buildAppInfoCard(),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.support_agent_rounded, color: primaryColor, size: 28),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'مركز الدعم الفني',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildContactItem(Icons.phone_rounded, 'رقم الدعم الفني', '07725252103', true, context),
          _buildContactItem(Icons.phone_rounded, 'رقم الطوارئ', '07862268894', true, context),
          _buildContactItem(Icons.email_rounded, 'البريد الإلكتروني', 'supervisor@electric.gov.iq', false, context),
          _buildContactItem(Icons.access_time_rounded, 'ساعات العمل', '8:00 ص - 4:00 م', false, context),
          _buildContactItem(Icons.location_on_rounded, 'العنوان', 'بغداد - وزارة الكهرباء', false, context),
          SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _makePhoneCall('07725252103', context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(Icons.phone_rounded, size: 20),
                  label: Text('اتصال فوري'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _openSupportChat(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(Icons.chat_rounded, size: 20),
                  label: Text('مراسلة الدعم'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openSupportChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SupervisorSupportChatScreen(
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
          accentColor: accentColor,
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value, bool isPhone, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: isPhone ? () => _makePhoneCall(value, context) : null,
              child: Text(
                value,
                style: TextStyle(
                  color: isPhone ? primaryColor : Colors.grey[600],
                  decoration: isPhone ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  List<Widget> _buildFAQItems() {
    List<Map<String, String>> faqs = [
      {
        'question': 'كيف يمكنني مراقبة استهلاك الكهرباء؟',
        'answer': 'اذهب إلى قسم الاستهلاك → اختر المنطقة المطلوبة → استعرض الرسوم البيانية والإحصائيات'
      },
      {
        'question': 'كيف أطلع على تقارير الصيانة؟',
        'answer': 'انتقل إلى قسم الصيانة → اختر تبويب "التقارير الواردة" → اختر التقرير المطلوب'
      },
      {
        'question': 'كيف أتحقق من جودة الكهرباء؟',
        'answer': 'اذهب إلى قسم الجودة → استعرض معاملات الجودة الفورية → تحقق من الإنذارات والتنبيهات'
      },
      {
        'question': 'كيف أطلب تقريراً من المراقب؟',
        'answer': 'انتقل إلى قسم الاستهلاك → اختر "طلب تقرير" → اختر نوع التقرير → أرسل الطلب'
      },
      {
        'question': 'كيف أقوم بعمل نسخة احتياطية للبيانات؟',
        'answer': 'اذهب إلى الإعدادات → اختر "الأمان والبيانات" → انقر على "إنشاء نسخة احتياطية"'
      },
    ];

    return faqs.map((faq) {
      return _buildExpandableItem(faq['question']!, faq['answer']!);
    }).toList();
  }
  
  Widget _buildExpandableItem(String question, String answer) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: ExpansionTile(
        leading: Icon(Icons.help_outline_rounded, color: primaryColor),
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }  
  
  Widget _buildAppInfoCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        children: [
          _buildInfoRow('الإصدار', '1.0.0'),
          _buildInfoRow('تاريخ البناء', '2024-03-20'),
          _buildInfoRow('المطور', 'وزارة الكهرباء'),
          _buildInfoRow('رقم الترخيص', 'MOE-SUP-2024-002'),
          _buildInfoRow('آخر تحديث', '2024-03-15'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
// شاشة محادثة الدعم
class SupervisorSupportChatScreen extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;

  const SupervisorSupportChatScreen({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  _SupervisorSupportChatScreenState createState() => _SupervisorSupportChatScreenState();
}

class _SupervisorSupportChatScreenState extends State<SupervisorSupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'مرحباً! كيف يمكنني مساعدتك اليوم؟',
      'isUser': false,
      'time': 'الآن',
      'sender': 'موظف الدعم'
    }
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': _messageController.text,
        'isUser': true,
        'time': 'الآن',
        'sender': 'أنت'
      });
    });

    _messageController.clear();

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'text': 'شكراً لتواصلكم. سأقوم بمساعدتك في حل هذه المشكلة. هل يمكنك تقديم مزيد من التفاصيل؟',
            'isUser': false,
            'time': 'الآن',
            'sender': 'موظف الدعم'
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'محادثة الدعم الفني',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              'متصل الآن',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        backgroundColor: widget.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.primaryColor.withOpacity(0.05),
              border: Border(
                bottom: BorderSide(color: widget.primaryColor.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.support_agent_rounded, color: Colors.white, size: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'فاضل علي - موظف الدعم',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'متخصص في نظام مسؤول المحطة',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'متصل',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: widget.primaryColor.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالتك هنا...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: widget.primaryColor,
                  child: IconButton(
                    icon: Icon(Icons.send_rounded, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final bool isUser = message['isUser'] as bool;
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: widget.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.support_agent_rounded, color: Colors.white, size: 16),
            ),
          SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser 
                        ? widget.primaryColor 
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message['text'],
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message['time'],
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
