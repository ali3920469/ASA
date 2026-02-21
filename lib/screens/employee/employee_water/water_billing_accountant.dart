import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mang_mu/screens/employee/Employee_Shared%20Services/esignin_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';

class WaterBillingAccountantScreen extends StatefulWidget {
  static const String screenRoute = '/water-billing-accountant';
  
  const WaterBillingAccountantScreen({super.key});

  @override
  WaterBillingAccountantScreenState createState() => WaterBillingAccountantScreenState();
}

class WaterBillingAccountantScreenState extends State<WaterBillingAccountantScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentCitizenTab = 0;
  int _currentPaymentTab = 0;
  String _billFilter = 'الكل';
  String _selectedReportType = 'يومي';
  List<DateTime> _selectedDates = [];
  String? _selectedWeek;
  String? _selectedMonth;
  int _currentReportTab = 0;
  // إضافة متغيرات البحث
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  
  // إضافة متغيرات البحث للتحويلات
  String _transferSearchQuery = '';
  final TextEditingController _transferSearchController = TextEditingController();
  String _selectedPaymentMethodFilter = 'الكل'; // فلتر طريقة الدفع

  // ألوان وزارة المياه (أزرق)
  final Color _primaryColor = Color.fromARGB(255, 30, 136, 229); // أزرق وزارة المياه
  final Color _secondaryColor = Color(0xFF29B6F6); // أزرق فاتح
  final Color _accentColor = Color(0xFF0288D1); // أزرق داكن
  final Color _successColor = Color(0xFF2E7D32);
  final Color _warningColor = Color(0xFFF57C00);
  final Color _errorColor = Color(0xFFD32F2F);

  // ألوان الوضع المظلم
  final Color _darkPrimaryColor = Color(0xFF1565C0);
  
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

  // ألوان ديناميكية تعتمد على الوضع المظلم
  Color _backgroundColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Color(0xFF121212) : Color(0xFFF0F8FF);
  }
  
  Color _cardColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
  }
  
  Color _textColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Colors.white : Color(0xFF212121);
  }
  
  Color _textSecondaryColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Colors.white70 : Color(0xFF757575);
  }
  
  Color _borderColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Color(0xFF333333) : Color(0xFFE0E0E0);
  }

  // قوائم التقارير
  final List<String> _reportTypes = ['يومي', 'أسبوعي', 'شهري'];
  final List<String> _weeks = ['الأسبوع الأول', 'الأسبوع الثاني', 'الأسبوع الثالث', 'الأسبوع الرابع'];
  final List<String> _months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];

  // بيانات المشتركين (المواطنين)
  final List<Map<String, dynamic>> subscribers = [
    {
      'id': 'SUB-2024-001',
      'name': 'أحمد محمد',
      'nationalId': '1234567890',
      'phone': '077235477514',
      'address': 'حي الرياض - شارع الملك فهد',
      'subscriptionType': 'سكني',
      'meterNumber': 'WMTR-001234',
      'status': 'active',
      'joinDate': DateTime.now().subtract(Duration(days: 120)),
    },
    {
      'id': 'SUB-2024-002',
      'name': 'فاطمة علي',
      'nationalId': '0987654321',
      'phone': '07827534903',
      'address': 'حي النخيل - شارع الأمير محمد',
      'subscriptionType': 'سكني',
      'meterNumber': 'WMTR-001235',
      'status': 'active',
      'joinDate': DateTime.now().subtract(Duration(days: 90)),
    },
    {
      'id': 'SUB-2024-003',
      'name': 'خالد إبراهيم',
      'nationalId': '1122334455',
      'phone': '07758888999',
      'address': 'حي العليا - شارع العروبة',
      'subscriptionType': 'تجاري',
      'meterNumber': 'WMTR-001236',
      'status': 'active',
      'joinDate': DateTime.now().subtract(Duration(days: 60)),
    },
  ];

  // بيانات فواتير المياه
  final List<Map<String, dynamic>> waterBills = [
    {
      'id': 'WINV-2024-001',
      'subscriberId': 'SUB-2024-001',
      'subscriberName': 'أحمد محمد',
      'amount': 125.75,
      'amountIQD': 61518,
      'dueDate': DateTime.now().add(Duration(days: 5)),
      'status': 'unpaid',
      'consumption': '25 م³',
      'previousReading': '1250',
      'currentReading': '1275',
      'billingDate': DateTime.now().subtract(Duration(days: 5)),
    },
    {
      'id': 'WINV-2024-002',
      'subscriberId': 'SUB-2024-002',
      'subscriberName': 'فاطمة علي',
      'amount': 180.50,
      'amountIQD': 88945,
      'dueDate': DateTime.now().subtract(Duration(days: 3)),
      'status': 'overdue',
      'consumption': '32 م³',
      'previousReading': '2100',
      'currentReading': '2132',
      'billingDate': DateTime.now().subtract(Duration(days: 10)),
    },
    {
      'id': 'WINV-2024-003',
      'subscriberId': 'SUB-2024-003',
      'subscriberName': 'خالد إبراهيم',
      'amount': 245.25,
      'amountIQD': 120473,
      'dueDate': DateTime.now().add(Duration(days: 2)),
      'status': 'unpaid',
      'consumption': '28 م³',
      'previousReading': '3200',
      'currentReading': '3228',
      'billingDate': DateTime.now().subtract(Duration(days: 7)),
    },
    {
      'id': 'WINV-2024-004',
      'subscriberId': 'SUB-2024-001',
      'subscriberName': 'أحمد محمد',
      'amount': 135.50,
      'amountIQD': 66795,
      'dueDate': DateTime.now().subtract(Duration(days: 1)),
      'status': 'paid',
      'consumption': '26 م³',
      'previousReading': '1275',
      'currentReading': '1301',
      'billingDate': DateTime.now().subtract(Duration(days: 30)),
    },
  ];

   // بيانات طرق الدفع  
  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'visa',
      'name': 'بطاقة فيزا',
      'type': 'الكتروني',
      'status': 'active',
      'description': 'الدفع عبر البطاقات الإئتمانية والإنترنت',
      'icon': Icons.credit_card_rounded,
      'color': Colors.blue,
      'formFields': [
        {
          'label': 'رقم البطاقة',
          'type': 'number',
          'hint': '1234 5678 9012 3456',
        },
        {'label': 'اسم حامل البطاقة', 'type': 'text', 'hint': 'John Doe'},
        {'label': 'تاريخ الانتهاء', 'type': 'text', 'hint': 'MM/YY'},
        {'label': 'CVV', 'type': 'number', 'hint': '123'},
      ],
    },
    {
      'id': 'mastercard',
      'name': 'بطاقة ماستركارد',
      'type': 'الكتروني',
      'status': 'active',
      'description': 'الدفع عبر البطاقات الإئتمانية والإنترنت',
      'icon': Icons.credit_card_rounded,
      'color': Colors.red,
      'formFields': [
        {
          'label': 'رقم البطاقة',
          'type': 'number',
          'hint': '1234 5678 9012 3456',
        },
        {'label': 'اسم حامل البطاقة', 'type': 'text', 'hint': 'John Doe'},
        {'label': 'تاريخ الانتهاء', 'type': 'text', 'hint': 'MM/YY'},
        {'label': 'CVV', 'type': 'number', 'hint': '123'},
      ],
    },
    {
      'id': 'asiapay',
      'name': 'AsiaPay',
      'type': 'الكتروني',
      'status': 'active',
      'description': 'الدفع عبر تطبيقات المحافظ الإلكترونية',
      'icon': Icons.account_balance_wallet_rounded,
      'color': Colors.green,
      'formFields': [
        {'label': 'رقم الهاتف', 'type': 'phone', 'hint': '07XX XXX XXXX'},
        {
          'label': 'كلمة المرور',
          'type': 'password',
          'hint': 'أدخل كلمة المرور',
        },
      ],
    },
    {
      'id': 'zain_cash',
      'name': 'زين كاش',
      'type': 'الكتروني',
      'status': 'active',
      'description': 'الدفع عبر تطبيقات المحافظ الإلكترونية',
      'icon': Icons.phone_iphone_rounded,
      'color': Colors.purple,
      'formFields': [
        {'label': 'رقم الهاتف', 'type': 'phone', 'hint': '07XX XXX XXXX'},
        {'label': 'رقم PIN', 'type': 'password', 'hint': 'أدخل الرقم السري'},
      ],
    },
    {
      'id': 'bank_transfer',
      'name': 'التحويل البنكي',
      'type': 'بنكي',
      'status': 'active',
      'description': 'التحويل المباشر عبر فروع البنوك',
      'icon': Icons.account_balance_rounded,
      'color': Colors.blueGrey,
      'formFields': [
        {'label': 'اسم البنك', 'type': 'text', 'hint': 'اسم البنك المحول منه'},
        {'label': 'رقم الحساب', 'type': 'text', 'hint': 'رقم حسابك'},
        {'label': 'رقم المرجع', 'type': 'text', 'hint': 'رقم المرجع للتحويل'},
      ],
    },
    {
      'id': 'alrafidain',
      'name': 'الرافدين',
      'type': 'بنكي',
      'status': 'active',
      'description': 'الدفع عبر فروع بنك الرافدين',
      'icon': Icons.account_balance_rounded,
      'color': Colors.orange,
      'formFields': [
        {'label': 'رقم الحساب', 'type': 'text', 'hint': 'رقم حساب الرافدين'},
        {
          'label': 'اسم المستخدم',
          'type': 'text',
          'hint': 'اسم المستخدم للإنترنت البنكي',
        },
        {
          'label': 'كلمة المرور',
          'type': 'password',
          'hint': 'كلمة المرور للإنترنت البنكي',
        },
      ],
    },
    {
      'id': 'alrasheed',
      'name': 'الرشيد',
      'type': 'بنكي',
      'status': 'active',
      'description': 'الدفع عبر فروع بنك الرشيد',
      'icon': Icons.account_balance_rounded,
      'color': Colors.teal,
      'formFields': [
        {'label': 'رقم الحساب', 'type': 'text', 'hint': 'رقم حساب الرشيد'},
        {
          'label': 'اسم المستخدم',
          'type': 'text',
          'hint': 'اسم المستخدم للإنترنت البنكي',
        },
        {
          'label': 'كلمة المرور',
          'type': 'password',
          'hint': 'كلمة المرور للإنترنت البنكي',
        },
      ],
    },
  ];
  
  // بيانات الحسابات البنكية الرسمية للوزارة
  final List<Map<String, dynamic>> bankAccounts = [
    {
      'id': 'ACC-001',
      'bankName': 'البنك المركزي العراقي',
      'accountNumber': 'IQ100100100100100100',
      'accountName': 'وزارة الموارد المائية - الإيرادات',
      'branch': 'بغداد - الرصافة',
      'currency': 'دينار عراقي',
      'status': 'active',
      'paymentMethods': ['visa', 'mastercard', 'bank_transfer']
    },
    {
      'id': 'ACC-002',
      'bankName': 'بنك الرافدين',
      'accountNumber': '123456789012',
      'accountName': 'وزارة الموارد المائية - فواتير',
      'branch': 'بغداد - الكرخ',
      'currency': 'دينار عراقي',
      'status': 'active',
      'paymentMethods': ['alrafidain', 'bank_transfer']
    },
    {
      'id': 'ACC-003', 
      'bankName': 'بنك الرشيد',
      'accountNumber': '987654321098',
      'accountName': 'وزارة الموارد المائية - خدمات',
      'branch': 'بغداد - المنصور',
      'currency': 'دينار عراقي',
      'status': 'active',
      'paymentMethods': ['alrasheed', 'bank_transfer']
    },
    {
      'id': 'ACC-004',
      'bankName': 'زين كاش',
      'accountNumber': '9647901234567',
      'accountName': 'وزارة الموارد المائية',
      'branch': 'الخدمة الإلكترونية',
      'currency': 'دينار عراقي', 
      'status': 'active',
      'paymentMethods': ['zain_cash']
    },
    {
      'id': 'ACC-005',
      'bankName': 'AsiaPay',
      'accountNumber': 'MWR-WATER-001',
      'accountName': 'Ministry of Water Resources',
      'branch': 'Electronic Payment',
      'currency': 'دينار عراقي',
      'status': 'active',
      'paymentMethods': ['asiapay']
    },
    {
      'id': 'ACC-006',
      'bankName': 'الخزينة العامة',
      'accountNumber': 'CASH-001',
      'accountName': 'وزارة الموارد المائية - المبالغ النقدية',
      'branch': 'مكاتب الخدمة',
      'currency': 'دينار عراقي',
      'status': 'active',
      'paymentMethods': ['cash']
    }
  ];
  
  // بيانات التحويلات لكل طريقة دفع
  final List<Map<String, dynamic>> paymentTransfers = [
    {
      'id': 'WTRF-2024-001',
      'paymentMethodId': 'visa',
      'subscriberName': 'أحمد محمد',
      'amount': 61518,
      'currency': 'دينار عراقي',
      'transferDate': DateTime.now().subtract(Duration(days: 2)),
      'status': 'مكتمل',
      'referenceNumber': 'REF-001234',
      'bankName': 'البنك المركزي العراقي',
      'accountNumber': '1234567890',
    },
    {
      'id': 'WTRF-2024-002', 
      'paymentMethodId': 'mastercard',
      'subscriberName': 'فاطمة علي',
      'amount': 88945,
      'currency': 'دينار عراقي',
      'transferDate': DateTime.now().subtract(Duration(days: 1)),
      'status': 'مكتمل',
      'referenceNumber': 'REF-001235',
      'bankName': 'الرشيد',
      'accountNumber': '0987654321',
    },
    {
      'id': 'WTRF-2024-003',
      'paymentMethodId': 'asiapay',
      'subscriberName': 'خالد إبراهيم', 
      'amount': 120473,
      'currency': 'دينار عراقي',
      'transferDate': DateTime.now().subtract(Duration(days: 3)),
      'status': 'معلق',
      'referenceNumber': 'REF-001236',
      'bankName': 'البلاد',
      'accountNumber': '1122334455',
    },
    {
      'id': 'WTRF-2024-004',
      'paymentMethodId': 'zain_cash',
      'subscriberName': 'سارة عبدالله',
      'amount': 75000,
      'currency': 'دينار عراقي',
      'transferDate': DateTime.now().subtract(Duration(hours: 5)),
      'status': 'مكتمل',
      'referenceNumber': 'REF-001237',
      'paymentLocation': 'فرع الوزارة - بغداد',
    },
    {
      'id': 'WTRF-2024-005',
      'paymentMethodId': 'alrafidain',
      'subscriberName': 'محمد حسن',
      'amount': 95000,
      'currency': 'دينار عراقي',
      'transferDate': DateTime.now().subtract(Duration(days: 4)),
      'status': 'مكتمل',
      'referenceNumber': 'REF-001238',
      'bankName': 'الرافدين',
      'accountNumber': '5566778899',
    },
    {
      'id': 'WTRF-2024-006',
      'paymentMethodId': 'alrasheed',
      'subscriberName': 'ليلى أحمد',
      'amount': 89000,
      'currency': 'دينار عراقي',
      'transferDate': DateTime.now().subtract(Duration(days: 2)),
      'status': 'معلق',
      'referenceNumber': 'REF-001239',
      'bankName': 'الرشيد',
      'accountNumber': '3344556677',
    },
    {
      'id': 'WTRF-2024-007',
      'paymentMethodId': 'cash',
      'subscriberName': 'علي كريم',
      'amount': 45000,
      'currency': 'دينار عراقي',
      'transferDate': DateTime.now().subtract(Duration(hours: 2)),
      'status': 'مكتمل',
      'referenceNumber': 'REF-001240',
      'paymentLocation': 'مكتب الخدمة - الكرخ',
    },
  ];

  // دالة للبحث في المشتركين
  List<Map<String, dynamic>> get filteredSubscribers {
    if (_searchQuery.isEmpty) {
      return subscribers;
    }
    
    return subscribers.where((subscriber) {
      return subscriber['name'].contains(_searchQuery) ||
             subscriber['nationalId'].contains(_searchQuery) ||
             subscriber['phone'].contains(_searchQuery) ||
             subscriber['address'].contains(_searchQuery) ||
             subscriber['meterNumber'].contains(_searchQuery);
    }).toList();
  }
  
  // دالة للبحث في التحويلات
  List<Map<String, dynamic>> get filteredTransfers {
    List<Map<String, dynamic>> allTransfers = paymentTransfers;
    
    // تطبيق فلتر طريقة الدفع أولاً
    if (_selectedPaymentMethodFilter != 'الكل') {
      String methodId = paymentMethods.firstWhere(
        (method) => method['name'] == _selectedPaymentMethodFilter,
        orElse: () => {'id': ''}
      )['id'];
      
      allTransfers = allTransfers.where((transfer) => transfer['paymentMethodId'] == methodId).toList();
    }
    
    // ثم تطبيق البحث النصي
    if (_transferSearchQuery.isEmpty) {
      return allTransfers;
    }
    
    return allTransfers.where((transfer) {
      return transfer['subscriberName'].contains(_transferSearchQuery) ||
             transfer['referenceNumber'].contains(_transferSearchQuery) ||
             transfer['bankName']?.contains(_transferSearchQuery) == true ||
             transfer['paymentLocation']?.contains(_transferSearchQuery) == true ||
             transfer['status'].contains(_transferSearchQuery) ||
             _formatCurrency(transfer['amount']).contains(_transferSearchQuery);
    }).toList();
  }

  // دالة لتصفية الفواتير حسب التبويب المختار
  List<Map<String, dynamic>> _getFilteredWaterBills() {
    switch (_billFilter) {
      case 'مدفوعة':
        return waterBills.where((bill) => bill['status'] == 'paid').toList();
      case 'غير مدفوعة':
        return waterBills.where((bill) => bill['status'] == 'unpaid').toList();
      case 'متأخرة':
        return waterBills.where((bill) => bill['status'] == 'overdue').toList();
      case 'الكل':
      default:
        return waterBills;
    }
  }

  // دالة للحصول على التحويلات حسب طريقة الدفع
  List<Map<String, dynamic>> _getTransfersByPaymentMethod(String paymentMethodId) {
    return paymentTransfers.where((transfer) => transfer['paymentMethodId'] == paymentMethodId).toList();
  }

  // دالة لحساب إجمالي المبالغ المحولة
  double _getTotalTransfersAmount(List<Map<String, dynamic>> transfers) {
    return transfers.fold(0.0, (sum, transfer) => sum + (transfer['amount'] ?? 0));
  }

  // دالة لتحديث البحث
  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  // دالة لمسح البحث
  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  // دالة لتحديث بحث التحويلات
  void _updateTransferSearchQuery(String query) {
    setState(() {
      _transferSearchQuery = query;
    });
  }

  // دالة لمسح بحث التحويلات
  void _clearTransferSearch() {
    setState(() {
      _transferSearchQuery = '';
      _transferSearchController.clear();
    });
  }

  // دالة لتغيير فلتر طريقة الدفع
  void _changePaymentMethodFilter(String method) {
    setState(() {
      _selectedPaymentMethodFilter = method;
    });
  }

  // دالة للحصول على الحسابات البنكية المرتبطة بطريقة دفع معينة
  List<Map<String, dynamic>> _getBankAccountsForPaymentMethod(String paymentMethodId) {
    return bankAccounts.where((account) => 
      account['paymentMethods'].contains(paymentMethodId)
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _transferSearchController.dispose();
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
            child: Icon(Icons.water_drop_rounded, color: _primaryColor, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'وزارة الموارد المائية - نظام فواتير المياه',
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsScreen()),
            );
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? _darkPrimaryColor : _primaryColor,
            border: Border(
              bottom: BorderSide(color: _secondaryColor, width: 2),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left:0, right:0),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 4, color: _secondaryColor),
                ),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              labelStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              padding: EdgeInsets.zero,
              labelPadding: EdgeInsets.symmetric(horizontal:5),
              tabs: [
                Tab(
                  icon: Icon(Icons.people_alt_rounded, size: 22),
                  text: 'المشتركين',
                ),
                Tab(
                  icon: Icon(Icons.receipt_long_rounded, size: 22),
                  text: 'فواتير المياه',
                ),
                Tab(
                  icon: Icon(Icons.summarize_rounded, size: 22),
                  text: 'التقارير',
                ),
                Tab(
                  icon: Icon(Icons.payment_rounded, size: 22),
                  text: 'طرق الدفع',
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
                  colors: [Color(0xFF121212), Color(0xFF1A1A1A)],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF5F5F5), Color(0xFFE3F2FD)],
                ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            
            return TabBarView(
              controller: _tabController,
              children: [
                _buildSubscribersView(isDarkMode, screenWidth, screenHeight),
                _buildWaterBillsView(isDarkMode, screenWidth, screenHeight),
                _buildReportsView(isDarkMode, screenWidth, screenHeight),
                _buildPaymentMethodsView(isDarkMode, screenWidth, screenHeight),
              ],
            );
          },
        ),
      ),
      drawer: _buildWaterMinistryDrawer(context, isDarkMode),
    );
  }

  Widget _buildSubscribersView(bool isDarkMode, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      height: screenHeight,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            _buildSearchBar(isDarkMode, 'ابحث عن مشترك...'),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                'سجل المشتركين',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? _textColor(context) : _primaryColor,
                ),
              ),
            ),
            SizedBox(height: 12),
            if (filteredSubscribers.isEmpty && _searchQuery.isNotEmpty)
              _buildNoResults(isDarkMode)
            else
              ...filteredSubscribers.map((subscriber) => _buildSubscriberCard(subscriber, isDarkMode)),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterBillsView(bool isDarkMode, double screenWidth, double screenHeight) {
    List<Map<String, dynamic>> filteredBills = _getFilteredWaterBills();

    return Container(
      width: screenWidth,
      height: screenHeight,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWaterBillsStatsCard(isDarkMode),
            SizedBox(height: 20),
            _buildWaterBillsFilterRow(isDarkMode),
            SizedBox(height: 20),
            Text(
              'فواتير المياه الحالية',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? _textColor(context) : _primaryColor,
              ),
            ),
            SizedBox(height: 16),
            if (filteredBills.isEmpty)
              _buildNoWaterBillsMessage(isDarkMode)
            else
              ...filteredBills.map((bill) => _buildWaterBillCard(bill, isDarkMode)),
          ],
        ),
      ),
    );
  }
  // ⬅️ تعديل شاشة التقارير في محاسب المياه لتصبح مثل محاسب الكهرباء
Widget _buildReportsView(bool isDarkMode, double screenWidth, double screenHeight) {
  return SingleChildScrollView(
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
              child: Icon(Icons.summarize_rounded, color: _primaryColor, size: 24),
            ),
            const SizedBox(width: 8),
            Text(
              'نظام التقارير المالية للمياه',
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
                child: _buildWaterReportInnerTabButton('إنشاء التقارير', 0, isDarkMode),
              ),
              Expanded(
                child: _buildWaterReportInnerTabButton('التقارير الواردة', 1, isDarkMode),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        
        // عرض المحتوى حسب التبويب المختار
        _currentReportTab == 0 
            ? _buildWaterCreateReportSection(isDarkMode)
            : _buildWaterReceivedReportsSection(isDarkMode),
      ],
    ),
  );
}

Widget _buildWaterReportInnerTabButton(String title, int tabIndex, bool isDarkMode) {
  bool isSelected = _currentReportTab == tabIndex;
  return GestureDetector(
    onTap: () {
      setState(() {
        _currentReportTab = tabIndex;
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

// قسم إنشاء التقارير للمياه (نفس الوظيفة الحالية ولكن مع إضافة الإحصائيات)
Widget _buildWaterCreateReportSection(bool isDarkMode) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'إنشاء تقرير جديد للمياه',
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
      
      // إضافة إحصائيات سريعة للمياه
      _buildWaterQuickStats(isDarkMode),
    ],
  );
}

// قسم التقارير الواردة للمياه
Widget _buildWaterReceivedReportsSection(bool isDarkMode) {
  // بيانات تجريبية للتقارير الواردة الخاصة بالمياه
  final List<Map<String, dynamic>> waterReceivedReports = [
    {
      'id': 'WREP-2024-001',
      'title': 'تقرير إيرادات المياه الشهري',
      'sender': 'قسم محاسبة المياه',
      'date': DateTime.now().subtract(Duration(days: 2)),
      'type': 'شهري',
      'size': '1.5 MB',
      'status': 'مستلم',
      'fileType': 'PDF',
    },
    {
      'id': 'WREP-2024-002',
      'title': 'تقرير فواتير المياه المتأخرة',
      'sender': 'مكتب المدير العام للمياه',
      'date': DateTime.now().subtract(Duration(days: 5)),
      'type': 'أسبوعي',
      'size': '920 KB',
      'status': 'مستلم',
      'fileType': 'PDF',
    },
    {
      'id': 'WREP-2024-003',
      'title': 'تقرير التحصيل اليومي للمياه',
      'sender': 'فرع بغداد للمياه',
      'date': DateTime.now().subtract(Duration(days: 1)),
      'type': 'يومي',
      'size': '520 KB',
      'status': 'غير مقروء',
      'fileType': 'Excel',
    },
    {
      'id': 'WREP-2024-004',
      'title': 'تقرير استهلاك المياه',
      'sender': 'شؤون المشتركين',
      'date': DateTime.now().subtract(Duration(days: 7)),
      'type': 'شهري',
      'size': '2.3 MB',
      'status': 'مستلم',
      'fileType': 'PDF',
    },
    {
      'id': 'WREP-2024-005',
      'title': 'تقرير إيرادات المياه السنوي',
      'sender': 'الإدارة العليا للموارد المائية',
      'date': DateTime.now().subtract(Duration(days: 10)),
      'type': 'سنوي',
      'size': '4.1 MB',
      'status': 'مستلم',
      'fileType': 'PDF',
    },
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'التقارير المستلمة - المياه',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _textColor(context),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'عرض وإدارة جميع التقارير التي تم استلامها في قسم المياه',
        style: TextStyle(
          color: _textSecondaryColor(context),
        ),
      ),
      const SizedBox(height: 20),
      
      // إحصائيات سريعة للمياه
      Container(
        padding: EdgeInsets.all(16),
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
                  waterReceivedReports.length.toString(),
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
                  waterReceivedReports.where((r) => r['status'] == 'غير مقروء').length.toString(),
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
                  '${_calculateWaterTotalSize(waterReceivedReports)} MB',
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
      
      // قائمة التقارير الخاصة بالمياه
      ...waterReceivedReports.map((report) => _buildWaterReceivedReportCard(report, isDarkMode)),
    ],
  );
}

// بناء بطاقة تقرير واردة للمياه
Widget _buildWaterReceivedReportCard(Map<String, dynamic> report, bool isDarkMode) {
  bool isUnread = report['status'] == 'غير مقروء';
  
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: _cardColor(context),
      border: Border.all(color: _borderColor(context)),
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
          color: _getWaterReportColor(report['fileType']).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _getWaterReportIcon(report['fileType']),
          color: _getWaterReportColor(report['fileType']),
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
          SizedBox(height: 4),
          Text(
            'من: ${report['sender']}',
            style: TextStyle(
              fontSize: 12,
              color: _textSecondaryColor(context),
            ),
          ),
          SizedBox(height: 2),
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
          _handleWaterReportAction(value, report);
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<String>(
            value: 'view',
            child: Row(
              children: [
                Icon(Icons.visibility_rounded, size: 18, color: _primaryColor),
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
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_rounded, size: 18, color: _errorColor),
                SizedBox(width: 8),
                Text('حذف'),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        _viewWaterReceivedReport(report);
      },
    ),
  );
}

// إحصائيات سريعة للمياه
Widget _buildWaterQuickStats(bool isDarkMode) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _backgroundColor(context),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor(context)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إحصائيات سريعة - المياه',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildWaterQuickStatItem('تقارير هذا الشهر', '8', Icons.calendar_today_rounded, _primaryColor),
            _buildWaterQuickStatItem('تقارير معلقة', '2', Icons.pending_rounded, _warningColor),
            _buildWaterQuickStatItem('مقاسمة هذا الشهر', '5', Icons.share_rounded, _successColor),
          ],
        ),
      ],
    ),
  );
}

Widget _buildWaterQuickStatItem(String title, String value, IconData icon, Color color) {
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
      SizedBox(height: 8),
      Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: color,
        ),
      ),
      SizedBox(height: 4),
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

// دوال مساعدة للتقارير الواردة للمياه
Color _getWaterReportColor(String fileType) {
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

IconData _getWaterReportIcon(String fileType) {
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

String _calculateWaterTotalSize(List<Map<String, dynamic>> reports) {
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

void _handleWaterReportAction(String action, Map<String, dynamic> report) {
  switch (action) {
    case 'view':
      _viewWaterReceivedReport(report);
      break;
    case 'download':
      _downloadWaterReport(report);
      break;
    case 'share':
      _shareWaterReport(report);
      break;
    case 'delete':
      _deleteWaterReport(report);
      break;
  }
}

void _viewWaterReceivedReport(Map<String, dynamic> report) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(context),
      title: Row(
        children: [
          Icon(_getWaterReportIcon(report['fileType']), color: _getWaterReportColor(report['fileType'])),
          SizedBox(width: 8),
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
            _buildWaterReportDetailRow('المرسل:', report['sender']),
            _buildWaterReportDetailRow('النوع:', report['type']),
            _buildWaterReportDetailRow('الحجم:', report['size']),
            _buildWaterReportDetailRow('صيغة الملف:', report['fileType']),
            _buildWaterReportDetailRow('التاريخ:', DateFormat('yyyy-MM-dd HH:mm').format(report['date'])),
            _buildWaterReportDetailRow('الحالة:', report['status']),
            SizedBox(height: 16),
            Text(
              'ملخص التقرير:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'هذا التقرير يحتوي على البيانات المالية والشهرية الخاصة بفواتير المياه التي تم جمعها من مختلف الأقسام. يشمل إيرادات المياه، الفواتير المعلقة والمدفوعة، واستهلاك المياه.',
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
          child: Text('إغلاق'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () => _downloadWaterReport(report),
          child: Text('تحميل'),
        ),
      ],
    ),
  );
}

Widget _buildWaterReportDetailRow(String label, String value) {
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

void _downloadWaterReport(Map<String, dynamic> report) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('جاري تحميل: ${report['title']}'),
      backgroundColor: _successColor,
    ),
  );
}

void _shareWaterReport(Map<String, dynamic> report) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('مشاركة: ${report['title']}'),
      backgroundColor: _primaryColor,
    ),
  );
}

void _deleteWaterReport(Map<String, dynamic> report) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(context),
      title: Row(
        children: [
          Icon(Icons.delete_rounded, color: _errorColor),
          SizedBox(width: 8),
          Text('حذف التقرير'),
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
          child: Text('إلغاء'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _errorColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم حذف التقرير: ${report['title']}'),
                backgroundColor: _errorColor,
              ),
            );
          },
          child: Text('حذف'),
        ),
      ],
    ),
  );
}
  Widget _buildPaymentMethodsView(bool isDarkMode, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth,
      height: screenHeight,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPaymentMethodsSummaryCard(isDarkMode),
            SizedBox(height: 20),
            Text(
              'طرق الدفع المتاحة',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDarkMode ? _textColor(context) : _primaryColor,
              ), 
            ),
            SizedBox(height: 16),
            ...paymentMethods.map((method) => _buildPaymentMethodCard(method, isDarkMode)),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, 
               size: 64, 
               color: _textSecondaryColor(context)),
          SizedBox(height: 16),
          Text(
            'لا توجد نتائج للبحث',
            style: TextStyle(
              fontSize: 18,
              color: _textSecondaryColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'لم نتمكن من العثور على أي مشترك يطابق "$_searchQuery"',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textSecondaryColor(context),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _clearSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('مسح البحث'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoWaterBillsMessage(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, 
               size: 64, 
               color: _textSecondaryColor(context)),
          SizedBox(height: 16),
          Text(
            'لا توجد فواتير',
            style: TextStyle(
              fontSize: 18,
              color: _textSecondaryColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'لا توجد فواتير تطابق التصفية المختارة',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textSecondaryColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterBillsStatsCard(bool isDarkMode) {
    int paidBills = waterBills.where((bill) => bill['status'] == 'paid').length;
    int unpaidBills = waterBills.where((bill) => bill['status'] == 'unpaid').length;
    int overdueBills = waterBills.where((bill) => bill['status'] == 'overdue').length;
    double totalRevenue = waterBills.fold(0.0, (sum, bill) => sum + (bill['amountIQD'] ?? 0));
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _borderColor(context),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWaterBillStat('إجمالي الفواتير', waterBills.length.toString(), Icons.receipt_rounded, _primaryColor),
                _buildWaterBillStat('إجمالي الإيرادات', _formatCurrency(totalRevenue), Icons.attach_money_rounded, _successColor),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWaterBillStat('مدفوعة', paidBills.toString(), Icons.check_circle_rounded, _successColor),
                _buildWaterBillStat('غير مدفوعة', unpaidBills.toString(), Icons.pending_rounded, _warningColor),
                _buildWaterBillStat('متأخرة', overdueBills.toString(), Icons.warning_rounded, _errorColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsSummaryCard(bool isDarkMode) {
    int activeMethods = paymentMethods.where((method) => method['status'] == 'active').length;
    int inactiveMethods = paymentMethods.where((method) => method['status'] == 'inactive').length;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _borderColor(context),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildPaymentMethodStat('طرق الدفع', paymentMethods.length.toString(), Icons.payment_rounded, _primaryColor),
            _buildPaymentMethodStat('نشطة', activeMethods.toString(), Icons.check_circle_rounded, _successColor),
            _buildPaymentMethodStat('غير نشطة', inactiveMethods.toString(), Icons.pause_circle_rounded, _warningColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriberCard(Map<String, dynamic> subscriber, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _borderColor(context),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: _primaryColor, width: 1),
          ),
          child: Icon(Icons.person_rounded, color: _primaryColor, size: 24),
        ),
        title: Text(
          subscriber['name'],
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: _textColor(context),
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              'الرقم الوطني: ${subscriber['nationalId']}',
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor(context),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 2),
            Text(
              'رقم عداد المياه: ${subscriber['meterNumber']}',
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor(context),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          constraints: BoxConstraints(
            minWidth: 50,
            maxWidth: 70,
          ),
          decoration: BoxDecoration(
            color: _successColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _successColor.withOpacity(0.3)),
          ),
          child: Text(
            'نشط',
            style: TextStyle(
              fontSize: 12,
              color: _successColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        onTap: () {
          _showSubscriberDetails(subscriber, isDarkMode);
        },
      ),
    );
  }

  Widget _buildWaterBillCard(Map<String, dynamic> bill, bool isDarkMode) {
    Color statusColor = _getBillStatusColor(bill['status']);
    String statusText = _getBillStatusText(bill['status']);
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _borderColor(context),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.receipt_long_rounded, color: statusColor, size: 24),
        ),
        title: Text(
          'فاتورة مياه #${bill['id']}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: _textColor(context),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              bill['subscriberName'],
              style: TextStyle(
                fontSize: 14,
                color: _textSecondaryColor(context),
              ),
            ),
            SizedBox(height: 2),
            Text(
              '${_formatCurrency(bill['amountIQD'])} - ${bill['consumption']}',
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        onTap: () {
          _showWaterBillDetails(bill, isDarkMode);
        },
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method, bool isDarkMode) {
    bool isActive = method['status'] == 'active';
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _borderColor(context),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isActive ? _primaryColor.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(method['icon'], color: isActive ? _primaryColor : Colors.grey, size: 24),
        ),
        title: Text(
          method['name'],
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: _textColor(context),
          ),
        ),
        subtitle: Text(
          method['description'],
          style: TextStyle(
            fontSize: 14,
            color: _textSecondaryColor(context),
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? _successColor.withOpacity(0.1) : _warningColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isActive ? _successColor.withOpacity(0.3) : _warningColor.withOpacity(0.3)),
          ),
          child: Text(
            isActive ? 'نشط' : 'غير نشط',
            style: TextStyle(
              fontSize: 12,
              color: isActive ? _successColor : _warningColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () {
          _showPaymentMethodDetails(method, isDarkMode);
        },
      ),
    );
  }

  Widget _buildWaterBillStat(String title, String value, IconData icon, Color color) {
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

  Widget _buildPaymentMethodStat(String title, String value, IconData icon, Color color) {
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

  Widget _buildSearchBar(bool isDarkMode, String hintText) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _borderColor(context),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _updateSearchQuery,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(Icons.search_rounded, color: _textSecondaryColor(context)),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, color: _textSecondaryColor(context)),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  // دوال التقارير
  Widget _buildReportTypeFilter(bool isDarkMode) {
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
                        side: BorderSide(color: isSelected ? _primaryColor : _borderColor(context)),
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

  Widget _buildReportOptions(bool isDarkMode) {
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
            if (_selectedReportType == 'أسبوعي') _buildWeeklyOptions(),
            if (_selectedReportType == 'شهري') _buildMonthlyOptions(),
          ],
        ),
      ),
    );
  }

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
        Container(
          padding: EdgeInsets.all(12),
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
                  SizedBox(width: 8),
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
              SizedBox(height: 8),
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
        SizedBox(height: 16),
        
        Text(
          'التواريخ المحددة:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _textColor(context),
          ),
        ),
        SizedBox(height: 8),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 120),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedDates.map((date) {
                return Chip(
                  backgroundColor: _primaryColor,
                  label: Text(
                    DateFormat('yyyy-MM-dd').format(date),
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  deleteIcon: Icon(Icons.close, color: Colors.white, size: 16),
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
            color: _backgroundColor(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor(context)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today_outlined, color: _textSecondaryColor(context), size: 48),
              SizedBox(height: 12),
              Text(
                'لم يتم اختيار أي تواريخ',
                style: TextStyle(
                  color: _textSecondaryColor(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
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
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _weeks.map((week) {
            final isSelected = _selectedWeek == week;
            return FilterChip(
              label: Text(
                week,
                style: TextStyle(fontSize: 12),
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
                color: isSelected ? _primaryColor : _textColor(context),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : _borderColor(context)),
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
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _months.map((month) {
            final isSelected = _selectedMonth == month;
            return FilterChip(
              label: Text(
                month,
                style: TextStyle(fontSize: 12),
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
                color: isSelected ? _primaryColor : _textColor(context),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : _borderColor(context)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGenerateReportButton(bool isDarkMode) {
    bool isFormValid = false;
    
    switch (_selectedReportType) {
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

   void _showMultiDatePicker() {
  List<DateTime> tempSelectedDates = List.from(_selectedDates);

  showDialog(
    context: context,
    builder: (context) {
      DateTime focusedDay = DateTime.now();
      
      return Dialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
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
                    Icon(Icons.calendar_today, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'اختر التواريخ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Spacer(),
                    if (tempSelectedDates.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                              focusedDay = focused;
                              
                              if (tempSelectedDates.any((date) => isSameDay(date, selectedDay))) {
                                tempSelectedDates.removeWhere((date) => isSameDay(date, selectedDay));
                              } else {
                                tempSelectedDates.add(DateTime(selectedDay.year, selectedDay.month, selectedDay.day));
                              }
                              
                              tempSelectedDates.sort((a, b) => a.compareTo(b));
                              
                              (context as Element).markNeedsBuild();
                            },
                            
                            calendarStyle: CalendarStyle(
                              defaultTextStyle: TextStyle(color: _textColor(context)),
                              todayTextStyle: TextStyle(
                                color: _textColor(context),
                                fontWeight: FontWeight.bold,
                              ),
                              selectedTextStyle: TextStyle(
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
                              leftChevronIcon: Icon(Icons.chevron_left, color: _primaryColor),
                              rightChevronIcon: Icon(Icons.chevron_right, color: _primaryColor),
                              headerPadding: EdgeInsets.symmetric(vertical: 8),
                              headerMargin: EdgeInsets.only(bottom: 8),
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
                            weekendDays: [DateTime.friday, DateTime.saturday],
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        if (tempSelectedDates.isNotEmpty)
                          Container(
                            padding: EdgeInsets.all(16),
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
                                    Icon(Icons.date_range_rounded, color: _primaryColor, size: 20),
                                    SizedBox(width: 8),
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
                                SizedBox(height: 12),
                                
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: tempSelectedDates.map((date) {
                                    return Chip(
                                      backgroundColor: _primaryColor,
                                      label: Text(
                                        DateFormat('yyyy-MM-dd').format(date),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      deleteIcon: Icon(Icons.close, color: Colors.white, size: 16),
                                      onDeleted: () {
                                        tempSelectedDates.remove(date);
                                        (context as Element).markNeedsBuild();
                                      },
                                    );
                                  }).toList(),
                                ),
                                
                                SizedBox(height: 12),
                                
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
                        
                        if (tempSelectedDates.isEmpty)
                          Container(
                            padding: EdgeInsets.all(16),
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
                                SizedBox(height: 12),
                                Text(
                                  'انقر على الأيام في التقويم',
                                  style: TextStyle(
                                    color: _textColor(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8),
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
              
              Container(
                padding: EdgeInsets.all(16),
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
                          side: BorderSide(color: _errorColor),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('إلغاء'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedDates = List.from(tempSelectedDates);
                          });
                          Navigator.pop(context);
                          _showSuccessSnackbar('تم اختيار ${_selectedDates.length} يوم');
                        },
                        child: Text('تم الاختيار'),
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

  Widget _buildMonthCalendar(DateTime month, List<DateTime> tempSelectedDates, StateSetter setStateDialog) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor(context)),
      ),
      child: Column(
        children: [
          Text(
            DateFormat('MMMM yyyy').format(month),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: 35,
            itemBuilder: (context, index) {
              DateTime day = DateTime(month.year, month.month, 1).add(Duration(days: index - DateTime(month.year, month.month, 1).weekday));
              bool isSelected = tempSelectedDates.any((d) => 
                  d.year == day.year && d.month == day.month && d.day == day.day);
              bool isCurrentMonth = day.month == month.month;
              
              if (!isCurrentMonth) return SizedBox.shrink();
              
              return GestureDetector(
                onTap: () {
                  setStateDialog(() {
                    if (isSelected) {
                      tempSelectedDates.removeWhere((d) => 
                          d.year == day.year && d.month == day.month && d.day == day.day);
                    } else {
                      tempSelectedDates.add(DateTime(day.year, day.month, day.day));
                    }
                    tempSelectedDates.sort((a, b) => a.compareTo(b));
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? _primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? _primaryColor : Colors.transparent,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : _textColor(context),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        title: Text('التقرير $period', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('نوع التقرير: $_selectedReportType', style: TextStyle(color: _textColor(context))),
              if (_selectedReportType == 'يومي' && _selectedDates.isNotEmpty)
                Text('عدد الأيام: ${_selectedDates.length}', style: TextStyle(color: _textColor(context))),
              if (_selectedWeek != null)
                Text('الأسبوع: $_selectedWeek', style: TextStyle(color: _textColor(context))),
              if (_selectedMonth != null)
                Text('الشهر: $_selectedMonth', style: TextStyle(color: _textColor(context))),
              const SizedBox(height: 16),
              Text('ملخص التقرير المالي:', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
              Text('- إجمالي الفواتير: ${waterBills.length}', style: TextStyle(color: _textColor(context))),
              Text('- إجمالي الإيرادات: ${_formatCurrency(waterBills.fold(0.0, (sum, bill) => sum + (bill['amountIQD'] ?? 0)))}', style: TextStyle(color: _textColor(context))),
              Text('- الفواتير المدفوعة: ${waterBills.where((b) => b['status'] == 'paid').length}', style: TextStyle(color: _textColor(context))),
              Text('- الفواتير غير المدفوعة: ${waterBills.where((b) => b['status'] == 'unpaid').length}', style: TextStyle(color: _textColor(context))),
              Text('- الفواتير المتأخرة: ${waterBills.where((b) => b['status'] == 'overdue').length}', style: TextStyle(color: _textColor(context))),
              Text('- عدد المشتركين: ${subscribers.length}', style: TextStyle(color: _textColor(context))),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: TextStyle(color: _textSecondaryColor(context))),
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

  // دوال PDF للتقارير المالية
  Future<void> _generatePdfReport(String period) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              _buildWaterPdfHeader(period),
              pw.SizedBox(height: 20),
              _buildWaterPdfFinancialSummary(),
              pw.SizedBox(height: 20),
              _buildWaterPdfBillsDetails(),
              pw.SizedBox(height: 20),
              _buildWaterPdfSubscribersSummary(),
              pw.SizedBox(height: 20),
              _buildWaterPdfPaymentMethodsSummary(),
            ];
          },
        ),
      );

      final Uint8List pdfBytes = await pdf.save();
      await _shareWaterPdfFile(pdfBytes, period);

    } catch (e) {
      _showErrorSnackbar('خطأ في تصدير التقرير: $e');
    }
  }

  Future<void> _shareWaterPdfFile(Uint8List pdfBytes, String period) async {
    try {
      final fileName = 'تقرير_مالي_المياه_${DateTime.now().millisecondsSinceEpoch}.pdf';
      
      await Share.shareXFiles(
        [
          XFile.fromData(
            pdfBytes,
            name: fileName,
            mimeType: 'application/pdf',
          )
        ],
        subject: 'تقرير مالي المياه - $period',
        text: 'مرفق التقرير المالي لفواتير المياه للفترة $period',
      );

      _showSuccessSnackbar('تم تصدير التقرير بنجاح');
    } catch (e) {
      _showErrorSnackbar('خطأ في مشاركة الملف: $e');
    }
  }

  pw.Widget _buildWaterPdfHeader(String period) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'وزارة الموارد المائية - العراق',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
              ),
            ),
            pw.Text(
              'التقرير المالي لفواتير المياه',
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

  pw.Widget _buildWaterPdfFinancialSummary() {
    int totalBills = waterBills.length;
    int paidBills = waterBills.where((bill) => bill['status'] == 'paid').length;
    int unpaidBills = waterBills.where((bill) => bill['status'] == 'unpaid').length;
    int overdueBills = waterBills.where((bill) => bill['status'] == 'overdue').length;
    double totalRevenue = waterBills.fold(0.0, (sum, bill) => sum + (bill['amountIQD'] ?? 0));
    double paidRevenue = waterBills.where((bill) => bill['status'] == 'paid').fold(0.0, (sum, bill) => sum + (bill['amountIQD'] ?? 0));
    
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blue),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      padding: const pw.EdgeInsets.all(15),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'ملخص التقرير المالي',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('إجمالي الفواتير:'),
              pw.Text('$totalBills'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('إجمالي الإيرادات:'),
              pw.Text('${_formatCurrency(totalRevenue)} دينار'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('الإيرادات المحصلة:'),
              pw.Text('${_formatCurrency(paidRevenue)} دينار'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('الفواتير المدفوعة:'),
              pw.Text('$paidBills'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('الفواتير غير المدفوعة:'),
              pw.Text('$unpaidBills'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('الفواتير المتأخرة:'),
              pw.Text('$overdueBills'),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildWaterPdfBillsDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'تفاصيل فواتير المياه',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.blue100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('رقم الفاتورة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('المشترك', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('المبلغ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الحالة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('تاريخ الاستحقاق', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            ...waterBills.map((bill) => pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(bill['id']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(bill['subscriberName']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('${_formatCurrency(bill['amountIQD'])} دينار'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    _getBillStatusText(bill['status']),
                    style: pw.TextStyle(
                      color: _getWaterPdfBillStatusColor(bill['status']),
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(DateFormat('yyyy-MM-dd').format(bill['dueDate'])),
                ),
              ],
            )).toList(),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildWaterPdfSubscribersSummary() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'ملخص المشتركين',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.blue100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('اسم المشترك', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('رقم عداد المياه', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('نوع الاشتراك', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('رقم الهاتف', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            ...subscribers.map((subscriber) => pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(subscriber['name']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(subscriber['meterNumber']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(subscriber['subscriptionType']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(subscriber['phone']),
                ),
              ],
            )).toList(),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildWaterPdfPaymentMethodsSummary() {
    int activeMethods = paymentMethods.where((method) => method['status'] == 'active').length;
    int inactiveMethods = paymentMethods.where((method) => method['status'] == 'inactive').length;
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'طرق الدفع المتاحة',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.blue100),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('اسم طريقة الدفع', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('النوع', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('الحالة', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            ...paymentMethods.map((method) => pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(method['name']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(method['type']),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    method['status'] == 'active' ? 'نشط' : 'غير نشط',
                    style: pw.TextStyle(
                      color: method['status'] == 'active' ? PdfColors.green : PdfColors.red,
                    ),
                  ),
                ),
              ],
            )).toList(),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('إجمالي طرق الدفع:'),
            pw.Text('${paymentMethods.length}'),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('الطرق النشطة:'),
            pw.Text('$activeMethods'),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('الطرق غير النشطة:'),
            pw.Text('$inactiveMethods'),
          ],
        ),
      ],
    );
  }

  PdfColor _getWaterPdfBillStatusColor(String status) {
    switch (status) {
      case 'paid':
        return PdfColors.green;
      case 'unpaid':
        return PdfColors.orange;
      case 'overdue':
        return PdfColors.red;
      default:
        return PdfColors.grey;
    }
  }

  Widget _buildWaterBillsFilterRow(bool isDarkMode) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildWaterBillFilterChip('الكل', 'الكل', isDarkMode),
          SizedBox(width: 8),
          _buildWaterBillFilterChip('مدفوعة', 'مدفوعة', isDarkMode),
          SizedBox(width: 8),
          _buildWaterBillFilterChip('غير مدفوعة', 'غير مدفوعة', isDarkMode),
          SizedBox(width: 8),
          _buildWaterBillFilterChip('متأخرة', 'متأخرة', isDarkMode),
        ],
      ),
    );
  }

  Widget _buildWaterBillFilterChip(String label, String filter, bool isDarkMode) {
    bool isSelected = _billFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          _billFilter = filter;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : _cardColor(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _primaryColor : _borderColor(context),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : _textColor(context),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
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
        return _textSecondaryColor(context);
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

  // بناء القائمة المنسدلة
Widget _buildWaterMinistryDrawer(BuildContext context, bool isDarkMode) {
  return Drawer(
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode 
              ? [_darkPrimaryColor, Color(0xFF0D1B2A)]
              : [_primaryColor, Color(0xFF29B6F6)],
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
                colors: isDarkMode 
                    ? [_darkPrimaryColor, Color(0xFF1565C0)]
                    : [_primaryColor, Color(0xFF0288D1)],
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(
                    Icons.water_drop_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "محاسب فواتير المياه",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  "محاسب - قسم محاسبة المياه",
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
              color: isDarkMode ? Color(0xFF0D1B2A) : Color(0xFFE3F2FD),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(height: 20),
                  _buildWaterDrawerMenuItem(
                    icon: Icons.settings_rounded,
                    title: 'الإعدادات',
                    onTap: () {
                      Navigator.pop(context);
                      _showSettingsScreen(context, isDarkMode);
                    },
                    isDarkMode: isDarkMode,
                  ),
                  
                  _buildWaterDrawerMenuItem(
                    icon: Icons.help_rounded,
                    title: 'المساعدة والدعم',
                    onTap: () {
                      Navigator.pop(context);
                      _showHelpSupportScreen(context, isDarkMode);
                    },
                    isDarkMode: isDarkMode,
                  ),

                  SizedBox(height: 30),
                  
                  _buildWaterDrawerMenuItem(
                    icon: Icons.logout_rounded,
                    title: 'تسجيل الخروج',
                    onTap: () {
                      _showLogoutConfirmation(context, isDarkMode);
                    },
                    isDarkMode: isDarkMode,
                    isLogout: true,
                  ),

                  SizedBox(height: 40),
                  
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
                          'وزارة الموارد المائية - نظام فواتير المياه',
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

Widget _buildWaterDrawerMenuItem({
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

void _showLogoutConfirmation(BuildContext context, bool isDarkMode) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _cardColor(context),
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
          child: Text('تسجيل الخروج'),
        ),
      ],
    ),
  );
}

 // دوال العرض التفصيلي
  void _showSubscriberDetails(Map<String, dynamic> subscriber, bool isDarkMode) {
  List<Map<String, dynamic>> subscriberBills = waterBills.where((bill) => bill['subscriberId'] == subscriber['id']).toList();
  
  List<Map<String, dynamic>> paidBills = subscriberBills.where((bill) => bill['status'] == 'paid').toList();
  List<Map<String, dynamic>> unpaidBills = subscriberBills.where((bill) => bill['status'] == 'unpaid').toList();
  List<Map<String, dynamic>> completedBills = subscriberBills.where((bill) => bill['status'] == 'paid').toList();
  List<Map<String, dynamic>> earlyPaymentBills = subscriberBills.where((bill) => bill['status'] == 'paid' && bill['paidDate'] != null && bill['paidDate'].isBefore(bill['dueDate'])).toList();
  List<Map<String, dynamic>> onTimePaymentBills = subscriberBills.where((bill) => bill['status'] == 'paid' && bill['paidDate'] != null && _isSameDay(bill['paidDate'], bill['dueDate'])).toList();
  List<Map<String, dynamic>> latePaymentBills = subscriberBills.where((bill) => bill['status'] == 'overdue').toList();

  List<Map<String, dynamic>> subscriberServices = [
    {
      'id': 'WSRV-001',
      'name': 'تركيب عداد مياه ذكي',
      'purchaseDate': DateTime.now().subtract(Duration(days: 30)),
      'amount': 100000.0,
      'status': 'مكتمل',
      'paymentMethod': 'الدفع الإلكتروني',
      'paymentDate': DateTime.now().subtract(Duration(days: 30)),
    },
    {
      'id': 'WSRV-002', 
      'name': 'صيانة شبكة المياه',
      'purchaseDate': DateTime.now().subtract(Duration(days: 15)),
      'amount': 50000.0,
      'status': 'مكتمل',
      'paymentMethod': 'التحويل البنكي',
      'paymentDate': DateTime.now().subtract(Duration(days: 15)),
    }
  ];

  paidBills = paidBills.map((bill) {
    return {
      ...bill,
      'paidDate': bill['dueDate']?.subtract(Duration(days: 2)) ?? DateTime.now().subtract(Duration(days: 2)),
      'paymentMethod': 'الدفع الإلكتروني'
    };
  }).toList();

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'تفاصيل المشترك - ${subscriber['name']}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Container(
                  height: 50,
                  color: _cardColor(context),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildWaterTabButton('المعلومات', 0, setState, isDarkMode),
                      _buildWaterTabButton('المدفوعة', 1, setState, isDarkMode),
                      _buildWaterTabButton('غير المدفوعة', 2, setState, isDarkMode),
                      _buildWaterTabButton('المكتملة', 3, setState, isDarkMode),
                      _buildWaterTabButton('الدفع المبكر', 4, setState, isDarkMode),
                      _buildWaterTabButton('الدفع بالموعد', 5, setState, isDarkMode),
                      _buildWaterTabButton('المتأخرة', 6, setState, isDarkMode),
                      _buildWaterTabButton('الخدمات', 7, setState, isDarkMode),
                    ],
                  ),
                ),
                
                Expanded(
                  child: Container(
                    color: _backgroundColor(context),
                    child: _buildWaterTabContent(_currentCitizenTab, subscriber, subscriberBills, paidBills, unpaidBills, completedBills, earlyPaymentBills, onTimePaymentBills, latePaymentBills, subscriberServices, isDarkMode, setState),
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

Widget _buildWaterTabButton(String title, int tabIndex, StateSetter setState, bool isDarkMode) {
  bool isSelected = _currentCitizenTab == tabIndex;
  return GestureDetector(
    onTap: () {
      setState(() {
        _currentCitizenTab = tabIndex;
      });
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          color: isSelected ? Colors.white : _textColor(context),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    ),
  );
}

Widget _buildWaterTabContent(
  int tabIndex, 
  Map<String, dynamic> subscriber, 
  List<Map<String, dynamic>> allBills,
  List<Map<String, dynamic>> paidBills,
  List<Map<String, dynamic>> unpaidBills,
  List<Map<String, dynamic>> completedBills,
  List<Map<String, dynamic>> earlyPaymentBills,
  List<Map<String, dynamic>> onTimePaymentBills,
  List<Map<String, dynamic>> latePaymentBills,
  List<Map<String, dynamic>> services,
  bool isDarkMode,
  StateSetter setState,
) {
  switch (tabIndex) {
    case 0:
      return _buildWaterInfoTab(subscriber, isDarkMode);
    case 1:
      return _buildWaterBillsTab(paidBills, 'فواتير المياه المدفوعة', _successColor, isDarkMode, true);
    case 2:
      return _buildWaterBillsTab(unpaidBills, 'فواتير المياه غير المدفوعة', _warningColor, isDarkMode, false);
    case 3:
      return _buildWaterBillsTab(completedBills, 'فواتير المياه المكتملة', _successColor, isDarkMode, true);
    case 4:
      return _buildWaterBillsTab(earlyPaymentBills, 'الدفع المبكر للمياه', _successColor, isDarkMode, true);
    case 5:
      return _buildWaterBillsTab(onTimePaymentBills, 'الدفع بالموعد للمياه', _primaryColor, isDarkMode, true);
    case 6:
      return _buildWaterBillsTab(latePaymentBills, 'فواتير المياه المتأخرة', _errorColor, isDarkMode, false);
    case 7:
      return _buildWaterServicesTab(services, isDarkMode);
    default:
      return _buildWaterInfoTab(subscriber, isDarkMode);
  }
}

Widget _buildWaterInfoTab(Map<String, dynamic> subscriber, bool isDarkMode) {
  return SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المعلومات الأساسية',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _primaryColor,
          ),
        ),
        SizedBox(height: 16),
        _buildWaterInfoRow('الاسم:', subscriber['name'], isDarkMode),
        _buildWaterInfoRow('الرقم الوطني:', subscriber['nationalId'], isDarkMode),
        _buildWaterInfoRow('رقم الهاتف:', subscriber['phone'], isDarkMode),
        _buildWaterInfoRow('العنوان:', subscriber['address'], isDarkMode),
        _buildWaterInfoRow('نوع الاشتراك:', subscriber['subscriptionType'], isDarkMode),
        _buildWaterInfoRow('رقم عداد المياه:', subscriber['meterNumber'], isDarkMode),
        _buildWaterInfoRow('الحالة:', 'نشط', isDarkMode),
        _buildWaterInfoRow('تاريخ الانضمام:', DateFormat('yyyy-MM-dd').format(subscriber['joinDate']), isDarkMode),
      ],
    ),
  );
}

Widget _buildWaterBillsTab(List<Map<String, dynamic>> bills, String title, Color color, bool isDarkMode, bool isPaid) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border(bottom: BorderSide(color: color.withOpacity(0.3))),
        ),
        child: Row(
          children: [
            Icon(Icons.receipt_long_rounded, color: color),
            SizedBox(width: 8),
            Text(
              '$title (${bills.length})',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
      
      Expanded(
        child: bills.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 64, color: _textSecondaryColor(context)),
                    SizedBox(height: 16),
                    Text(
                      'لا توجد فواتير',
                      style: TextStyle(
                        fontSize: 16,
                        color: _textSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: bills.length,
                itemBuilder: (context, index) {
                  return _buildWaterBillItem(bills[index], isDarkMode, isPaid, color);
                },
              ),
      ),
    ],
  );
}

Widget _buildWaterServicesTab(List<Map<String, dynamic>> services, bool isDarkMode) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _accentColor.withOpacity(0.1),
          border: Border(bottom: BorderSide(color: _accentColor.withOpacity(0.3))),
        ),
        child: Row(
          children: [
            Icon(Icons.build_rounded, color: _accentColor),
            SizedBox(width: 8),
            Text(
              'خدمات المياه المشتراة (${services.length})',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _accentColor,
              ),
            ),
          ],
        ),
      ),
      
      Expanded(
        child: services.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.build_outlined, size: 64, color: _textSecondaryColor(context)),
                    SizedBox(height: 16),
                    Text(
                      'لا توجد خدمات مشتراة',
                      style: TextStyle(
                        fontSize: 16,
                        color: _textSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  return _buildWaterServiceItem(services[index], isDarkMode);
                },
              ),
      ),
    ],
  );
}

Widget _buildWaterBillItem(Map<String, dynamic> bill, bool isDarkMode, bool isPaid, Color color) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: _cardColor(context),
      border: Border.all(color: color.withOpacity(0.2)),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'فاتورة مياه #${bill['id']}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: _textColor(context),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isPaid ? 'مدفوعة' : 'غير مدفوعة',
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildWaterBillDetailRow('الاستهلاك:', bill['consumption'], isDarkMode),
        _buildWaterBillDetailRow('المبلغ:', _formatCurrency(bill['amountIQD']), isDarkMode),
        _buildWaterBillDetailRow('القراءة السابقة:', bill['previousReading'], isDarkMode),
        _buildWaterBillDetailRow('القراءة الحالية:', bill['currentReading'], isDarkMode),
        _buildWaterBillDetailRow('تاريخ الفاتورة:', DateFormat('yyyy-MM-dd').format(bill['billingDate']), isDarkMode),
        _buildWaterBillDetailRow('تاريخ الاستحقاق:', DateFormat('yyyy-MM-dd').format(bill['dueDate']), isDarkMode),
        if (isPaid) ...[
          _buildWaterBillDetailRow('طريقة الدفع:', bill['paymentMethod'] ?? 'غير محدد', isDarkMode),
          _buildWaterBillDetailRow('تاريخ الدفع:', DateFormat('yyyy-MM-dd').format(bill['paidDate'] ?? DateTime.now()), isDarkMode),
        ],
      ],
    ),
  );
}

Widget _buildWaterServiceItem(Map<String, dynamic> service, bool isDarkMode) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: _cardColor(context),
      border: Border.all(color: _accentColor.withOpacity(0.2)),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              service['name'],
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: _textColor(context),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                service['status'],
                style: TextStyle(
                  fontSize: 12,
                  color: _successColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildWaterBillDetailRow('المبلغ:', _formatCurrency(service['amount']), isDarkMode),
        _buildWaterBillDetailRow('طريقة الدفع:', service['paymentMethod'], isDarkMode),
        _buildWaterBillDetailRow('تاريخ الشراء:', DateFormat('yyyy-MM-dd').format(service['purchaseDate']), isDarkMode),
        _buildWaterBillDetailRow('تاريخ الدفع:', DateFormat('yyyy-MM-dd').format(service['paymentDate']), isDarkMode),
      ],
    ),
  );
}

Widget _buildWaterInfoRow(String label, String value, bool isDarkMode) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
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
              color: _textColor(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildWaterBillDetailRow(String label, String value, bool isDarkMode) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
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
              fontSize: 12,
              color: _textColor(context),
            ),
          ),
        ),
      ],
    ),
  );
}

bool _isSameDay(DateTime? date1, DateTime? date2) {
  if (date1 == null || date2 == null) return false;
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}

  void _showWaterBillDetails(Map<String, dynamic> bill, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.receipt_long_rounded, color: _primaryColor),
            SizedBox(width: 8),
            Text('تفاصيل فاتورة المياه'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWaterDetailRow('رقم الفاتورة:', bill['id']),
              _buildWaterDetailRow('المشترك:', bill['subscriberName']),
              _buildWaterDetailRow('المبلغ:', _formatCurrency(bill['amountIQD'])),
              _buildWaterDetailRow('الاستهلاك:', bill['consumption']),
              _buildWaterDetailRow('القراءة السابقة:', bill['previousReading']),
              _buildWaterDetailRow('القراءة الحالية:', bill['currentReading']),
              _buildWaterDetailRow('تاريخ الفاتورة:', DateFormat('yyyy-MM-dd').format(bill['billingDate'])),
              _buildWaterDetailRow('تاريخ الاستحقاق:', DateFormat('yyyy-MM-dd').format(bill['dueDate'])),
              _buildWaterDetailRow('الحالة:', _getBillStatusText(bill['status'])),
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

  void _showPaymentMethodDetails(Map<String, dynamic> method, bool isDarkMode) {
  List<Map<String, dynamic>> methodTransfers = _getTransfersByPaymentMethod(method['id']);
  double totalAmount = _getTotalTransfersAmount(methodTransfers);
  List<Map<String, dynamic>> methodBankAccounts = _getBankAccountsForPaymentMethod(method['id']);

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: _cardColor(context),
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        right: 5,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                       ),
                       Center(
                         child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                             SizedBox(height: MediaQuery.of(context).padding.top + 2),
                             Text(
                               'تفاصيل ${method['name']}',
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 22,
                                 fontWeight: FontWeight.w700,
                               ),
                             ),
                             SizedBox(height: 8),
                             Text(
                               '${methodTransfers.length} تحويل - ${_formatCurrency(totalAmount)}',
                               style: TextStyle(
                                 color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                               ),
                             ),
                           ],
                         ),
                       ),
                     ],
                   ),
                 ),
 
                 Container(
                   height: 50,
                   decoration: BoxDecoration(
                     border: Border(bottom: BorderSide(color: _borderColor(context))),
                   ),
                   child: Row(
                     children: [
                       _buildWaterPaymentTabButton('المعلومات', 0, setState, isDarkMode),
                       _buildWaterPaymentTabButton('الحسابات', 1, setState, isDarkMode),
                       _buildWaterPaymentTabButton('التحويلات', 2, setState, isDarkMode),
                       _buildWaterPaymentTabButton('الإحصائيات', 3, setState, isDarkMode),
                     ],
                   ),
                 ),
 
                 Expanded(
                   child: _buildWaterPaymentTabContent(_currentPaymentTab, method, methodTransfers, totalAmount, methodBankAccounts, isDarkMode),
                 ),
               ],
             ),
           ),
         );
       },
     ),
   );
 }

 Widget _buildWaterPaymentTabButton(String title, int tabIndex, StateSetter setState, bool isDarkMode) {
    bool isSelected = _currentPaymentTab == tabIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentPaymentTab = tabIndex;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? _primaryColor : Colors.transparent,
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
                color: isSelected ? Colors.white : _textColor(context),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWaterPaymentTabContent(int tabIndex, Map<String, dynamic> method, List<Map<String, dynamic>> transfers, double totalAmount, List<Map<String, dynamic>> bankAccounts, bool isDarkMode) {
    switch (tabIndex) {
     case 0:
       return _buildWaterPaymentInfoTab(method, isDarkMode);
     case 1:
       return _buildWaterBankAccountsTab(bankAccounts, method['name'], isDarkMode);
     case 2:
       return _buildWaterPaymentTransfersTab(transfers, isDarkMode, method['name']);
     case 3:
       return _buildWaterPaymentStatsTab(method, transfers, totalAmount, isDarkMode);
     default:
       return _buildWaterPaymentInfoTab(method, isDarkMode);
   }
 }

  Widget _buildWaterPaymentInfoTab(Map<String, dynamic> method, bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(method['icon'], color: _primaryColor, size: 40),
            ),
          ),
          SizedBox(height: 20),
          _buildWaterPaymentInfoRow('اسم طريقة الدفع:', method['name'], isDarkMode),
          _buildWaterPaymentInfoRow('النوع:', method['type'], isDarkMode),
          _buildWaterPaymentInfoRow('الوصف:', method['description'], isDarkMode),
          _buildWaterPaymentInfoRow('الحالة:', method['status'] == 'active' ? 'نشط' : 'غير نشط', isDarkMode),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWaterBankAccountsTab(List<Map<String, dynamic>> accounts, String methodName, bool isDarkMode) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.05),
            border: Border(bottom: BorderSide(color: _primaryColor.withOpacity(0.2))),
          ),
          child: Row(
            children: [
              Icon(Icons.account_balance_rounded, color: _primaryColor),
              SizedBox(width: 8),
              Text(
                'الحسابات البنكية الرسمية - $methodName',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _primaryColor,
                ),
              ),
              Spacer(),
              Text(
                '${accounts.length} حساب',
                style: TextStyle(
                  color: _textSecondaryColor(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: accounts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance_outlined, size: 64, color: _textSecondaryColor(context)),
                      SizedBox(height: 16),
                      Text(
                        'لا توجد حسابات بنكية',
                        style: TextStyle(
                          fontSize: 18,
                          color: _textSecondaryColor(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'لم يتم العثور على حسابات بنكية رسمية\nلطريقة الدفع $methodName',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _textSecondaryColor(context),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    return _buildWaterBankAccountItem(accounts[index], isDarkMode);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildWaterBankAccountItem(Map<String, dynamic> account, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        border: Border.all(color: _primaryColor.withOpacity(0.2)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  account['bankName'],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: _textColor(context),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'نشط',
                  style: TextStyle(
                    fontSize: 12,
                    color: _successColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildWaterBankAccountDetailRow('اسم الحساب:', account['accountName'], isDarkMode),
          _buildWaterBankAccountDetailRow('رقم الحساب:', account['accountNumber'], isDarkMode),
          _buildWaterBankAccountDetailRow('الفرع:', account['branch'], isDarkMode),
          _buildWaterBankAccountDetailRow('العملة:', account['currency'], isDarkMode),
        ],
      ),
    );
  }

  Widget _buildWaterBankAccountDetailRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
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
                fontSize: 12,
                color: _textColor(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterPaymentTransfersTab(List<Map<String, dynamic>> transfers, bool isDarkMode, String methodName) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _primaryColor.withOpacity(0.05),
          border: Border(bottom: BorderSide(color: _primaryColor.withOpacity(0.2))),
        ),
        child: Row(
          children: [
            Icon(Icons.filter_alt_rounded, color: _primaryColor),
            SizedBox(width: 8),
            Text(
              'تحويلات $methodName',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _primaryColor,
              ),
            ),
            Spacer(),
            Text(
              '${transfers.length} تحويل',
              style: TextStyle(
                color: _textSecondaryColor(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      
      if (transfers.isNotEmpty)
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _backgroundColor(context),
            border: Border(bottom: BorderSide(color: _borderColor(context))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWaterTransferMiniStat('الإجمالي', transfers.length.toString(), _primaryColor),
              _buildWaterTransferMiniStat('المبلغ', _formatCurrency(_getTotalTransfersAmount(transfers)), _successColor),
              _buildWaterTransferMiniStat('مكتمل', '${transfers.where((t) => t['status'] == 'مكتمل').length}', _successColor),
              _buildWaterTransferMiniStat('معلق', '${transfers.where((t) => t['status'] == 'معلق').length}', _warningColor),
            ],
          ),
        ),
      
      Expanded(
        child: transfers.isEmpty
            ? _buildWaterNoTransfersMessageForMethod(isDarkMode, methodName)
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: transfers.length,
                itemBuilder: (context, index) {
                  return _buildWaterTransferItem(transfers[index], isDarkMode);
                },
              ),
      ),
    ],
  );
}

  Widget _buildWaterPaymentStatsTab(Map<String, dynamic> method, List<Map<String, dynamic>> transfers, double totalAmount, bool isDarkMode) {
  int completedTransfers = transfers.where((t) => t['status'] == 'مكتمل').length;
  int pendingTransfers = transfers.where((t) => t['status'] == 'معلق').length;
  int totalTransfers = transfers.length;
  
  Map<String, Map<String, double>> monthlyData = {
    '2024': {
      'يناير': 2500000,
      'فبراير': 3200000,
      'مارس': 2800000,
      'أبريل': 3200000,
      'مايو': 3800000,
      'يونيو': 4100000,
      'يوليو': 3700000,
      'أغسطس': 4300000,
      'سبتمبر': 3900000,
      'أكتوبر': 4500000,
      'نوفمبر': 4100000,
      'ديسمبر': 4800000,
    },
    '2023': {
      'يناير': 2200000,
      'فبراير': 2800000,
      'مارس': 2500000,
      'أبريل': 3100000,
      'مايو': 2900000,
      'يونيو': 3200000,
      'يوليو': 3000000,
      'أغسطس': 3500000,
      'سبتمبر': 3300000,
      'أكتوبر': 3700000,
      'نوفمبر': 3400000,
      'ديسمبر': 4000000,
    },
    '2022': {
      'يناير': 1800000,
      'فبراير': 2200000,
      'مارس': 2000000,
      'أبريل': 2500000,
      'مايو': 2300000,
      'يونيو': 2600000,
      'يوليو': 2400000,
      'أغسطس': 2800000,
      'سبتمبر': 2700000,
      'أكتوبر': 3000000,
      'نوفمبر': 2900000,
      'ديسمبر': 3200000,
    },
  };
  
  List<String> years = monthlyData.keys.toList()..sort((a, b) => b.compareTo(a));
  String selectedYear = years.first;

  return SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نظرة عامة على تحويلات المياه',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _primaryColor,
          ),
        ),
        SizedBox(height: 16),
        
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _backgroundColor(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _borderColor(context)),
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
              Row(
                children: [
                  Expanded(
                    child: _buildWaterVerticalStatCard(
                      title: 'إجمالي التحويلات',
                      value: totalTransfers.toString(),
                      icon: Icons.list_alt_rounded,
                      color: _primaryColor,
                      iconSize: 28,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildWaterVerticalStatCard(
                      title: 'المبلغ الإجمالي',
                      value: _formatCurrency(totalAmount),
                      icon: Icons.attach_money_rounded,
                      color: _successColor,
                      iconSize: 28,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildWaterVerticalStatCard(
                      title: 'تحويلات مكتملة',
                      value: completedTransfers.toString(),
                      icon: Icons.check_circle_rounded,
                      color: _successColor,
                      iconSize: 28,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildWaterVerticalStatCard(
                      title: 'تحويلات معلقة',
                      value: pendingTransfers.toString(),
                      icon: Icons.pending_rounded,
                      color: _warningColor,
                      iconSize: 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        SizedBox(height: 24),
        
        StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _backgroundColor(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderColor(context)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'التوزيع الشهري لتحويلات المياه',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _primaryColor,
                        ),
                      ),
                      
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: _cardColor(context),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _primaryColor.withOpacity(0.3)),
                        ),
                        child: DropdownButton<String>(
                          value: selectedYear,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedYear = newValue;
                              });
                            }
                          },
                          items: years.map<DropdownMenuItem<String>>((String year) {
                            return DropdownMenuItem<String>(
                              value: year,
                              child: Text(
                                'سنة $year',
                                style: TextStyle(
                                  color: _textColor(context),
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList(),
                          underline: SizedBox(),
                          icon: Icon(Icons.arrow_drop_down_rounded, color: _primaryColor, size: 20),
                          dropdownColor: _cardColor(context),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'إجمالي السنة',
                              style: TextStyle(
                                fontSize: 12,
                                color: _textSecondaryColor(context),
                              ),
                            ),
                            Text(
                              _formatCurrency(_calculateWaterYearTotal(monthlyData[selectedYear]!)),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: _primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'المعدل الشهري',
                              style: TextStyle(
                                fontSize: 12,
                                color: _textSecondaryColor(context),
                              ),
                            ),
                            Text(
                              _formatCurrency(_calculateWaterMonthlyAverage(monthlyData[selectedYear]!)),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _successColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  Column(
                    children: monthlyData[selectedYear]!.entries.map((entry) {
                      String month = entry.key;
                      double amount = entry.value;
                      double maxAmount = monthlyData[selectedYear]!.values.reduce((a, b) => a > b ? a : b);
                      double percentage = (amount / maxAmount).clamp(0.0, 1.0);
                      
                      return _buildWaterMonthlyStatItem(
                        month: month,
                        year: selectedYear,
                        amount: amount,
                        maxAmount: maxAmount,
                        percentage: percentage,
                        isDarkMode: isDarkMode,
                      );
                    }).toList(),
                  ),
                  
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _accentColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _accentColor.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مقارنة السنوات',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _accentColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        ...years.map((year) {
                          double yearTotal = _calculateWaterYearTotal(monthlyData[year]!);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'سنة $year',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _textColor(context),
                                  ),
                                ),
                                Text(
                                  _formatCurrency(yearTotal),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _successColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
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
            children: [
              Icon(Icons.info_outline_rounded, color: _primaryColor, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'جميع الإحصائيات تعكس أداء ${method['name']} خلال جميع السنوات',
                  style: TextStyle(
                    fontSize: 12,
                    color: _textSecondaryColor(context),
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

double _calculateWaterYearTotal(Map<String, double> monthlyData) {
  return monthlyData.values.fold(0.0, (sum, amount) => sum + amount);
}

double _calculateWaterMonthlyAverage(Map<String, double> monthlyData) {
  return _calculateWaterYearTotal(monthlyData) / monthlyData.length;
}

Widget _buildWaterMonthlyStatItem({
  required String month,
  required String year,
  required double amount,
  required double maxAmount,
  required double percentage,
  required bool isDarkMode,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '$month $year',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textColor(context),
                ),
              ),
            ),
            Text(
              _formatCurrency(amount),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _successColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _borderColor(context),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerRight,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor, _secondaryColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        
        SizedBox(height: 4),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(percentage * 100).toStringAsFixed(0)}% من أعلى شهر',
              style: TextStyle(
                fontSize: 10,
                color: _textSecondaryColor(context),
              ),
            ),
            Text(
              '${_getWaterMonthRank(month, year)} من 12 شهر',
              style: TextStyle(
                fontSize: 10,
                color: _textSecondaryColor(context),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

String _getWaterMonthRank(String month, String year) {
  Map<String, int> monthOrder = {
    'يناير': 1, 'فبراير': 2, 'مارس': 3, 'أبريل': 4,
    'مايو': 5, 'يونيو': 6, 'يوليو': 7, 'أغسطس': 8,
    'سبتمبر': 9, 'أكتوبر': 10, 'نوفمبر': 11, 'ديسمبر': 12,
  };
  
  int rank = monthOrder[month] ?? 0;
  return rank.toString();
}

Widget _buildWaterVerticalStatCard({
  required String title,
  required String value,
  required IconData icon,
  required Color color,
  double iconSize = 24,
}) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: _cardColor(context),
      border: Border.all(color: color.withOpacity(0.2)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(icon, color: color, size: iconSize),
        ),
        SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: _textSecondaryColor(context),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

  Widget _buildWaterTransferItem(Map<String, dynamic> transfer, bool isDarkMode) {
  Color statusColor = transfer['status'] == 'مكتمل' ? _successColor : _warningColor;
  
  return Container(
    margin: EdgeInsets.only(bottom: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: _cardColor(context),
      border: Border.all(color: statusColor.withOpacity(0.2)),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'تحويل مياه #${transfer['id']}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: _textColor(context),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                transfer['status'],
                style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildWaterTransferDetailRow('المشترك:', transfer['subscriberName'], isDarkMode),
        _buildWaterTransferDetailRow('المبلغ:', _formatCurrency(transfer['amount']), isDarkMode),
        _buildWaterTransferDetailRow('رقم المرجع:', transfer['referenceNumber'], isDarkMode),
        _buildWaterTransferDetailRow('التاريخ:', DateFormat('yyyy-MM-dd').format(transfer['transferDate']), isDarkMode),
        if (transfer['bankName'] != null)
          _buildWaterTransferDetailRow('اسم البنك:', transfer['bankName'], isDarkMode),
        if (transfer['accountNumber'] != null)
          _buildWaterTransferDetailRow('رقم الحساب:', transfer['accountNumber'], isDarkMode),
        if (transfer['paymentLocation'] != null)
          _buildWaterTransferDetailRow('موقع الدفع:', transfer['paymentLocation'], isDarkMode),
      ],
    ),
  );
}

  // دوال مساعدة
  Widget _buildWaterTransferStat(String title, String value, Color color) {
    return Column(
      children: [
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

  Widget _buildWaterPaymentInfoRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
                color: _textColor(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterTransferDetailRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
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
                fontSize: 12,
                color: _textColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildWaterStatItem(String title, String value, IconData icon, Color color, bool isDarkMode) {
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: _cardColor(context),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: _textSecondaryColor(context),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

  Widget _buildWaterMonthStat(String month, double amount, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            month,
            style: TextStyle(
              color: _textColor(context),
            ),
          ),
          Text(
            _formatCurrency(amount),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: _successColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _textSecondaryColor(context),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterTransferMiniStat(String title, String value, Color color) {
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
            color: _textSecondaryColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildWaterNoTransfersMessageForMethod(bool isDarkMode, String methodName) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.payment_rounded, 
             size: 64, 
             color: _textSecondaryColor(context)),
        SizedBox(height: 16),
        Text(
          'لا توجد تحويلات',
          style: TextStyle(
            fontSize: 18,
            color: _textSecondaryColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'لم يتم العثور على أي تحويلات لطريقة الدفع\n$methodName',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _textSecondaryColor(context),
          ),
        ),
      ],
    ),
  );
}

  void _downloadReport(Map<String, dynamic> report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تحميل التقرير: ${report['title']}'),
        backgroundColor: _successColor,
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
        darkCardColor: Color(0xFF1E1E1E),
        cardColor: Colors.white,
        darkTextColor: Colors.white,
        textColor: Color(0xFF212121),
        darkTextSecondaryColor: Colors.white70,
        textSecondaryColor: Color(0xFF757575),
        onSettingsChanged: (settings) {
          print('الإعدادات المحدثة: $settings');
        },
      ),
    ),
  );
}

// شاشة المساعدة والدعم
void _showHelpSupportScreen(BuildContext context, bool isDarkMode) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => HelpSupportScreen(
        isDarkMode: isDarkMode,
        primaryColor: _primaryColor,
        secondaryColor: _secondaryColor,
        accentColor: _accentColor,
        darkCardColor: Color(0xFF1E1E1E),
        cardColor: Colors.white,
        darkTextColor: Colors.white,
        textColor: Color(0xFF212121),
        darkTextSecondaryColor: Colors.white70,
        textSecondaryColor: Color(0xFF757575),
      ),
    ),
  );
}

// ⬅️ دوال الرسائل
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
}
// إضافة إلى نفس الملف أو ملف منفصل
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
                      colors: [Color(0xFFF5F5F5), Color(0xFFE3F2FD)],
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
                    'استلام إشعارات حول فواتير المياه والتحديثات',
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
          _buildAboutRow('المطور', 'وزارة الموارد المائية - العراق', themeProvider),
          _buildAboutRow('رقم الترخيص', 'MWR-2024-001', themeProvider),
          _buildAboutRow('آخر تحديث', '2024-03-15', themeProvider),
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
class NotificationsScreen extends StatefulWidget {
  static const String routeName = '/notifications';

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final Color _primaryColor = Color.fromARGB(255, 30, 136, 229);
  final Color _secondaryColor = Color(0xFF29B6F6);
  final Color _backgroundColor = Color(0xFFF5F5F5);
  final Color _cardColor = Color(0xFFFFFFFF);
  final Color _textColor = Color(0xFF212121);
  final Color _textSecondaryColor = Color(0xFF757575);
  final Color _borderColor = Color(0xFFE0E0E0);

  int _selectedTab = 0;
  final List<String> _tabs = ['الوسائل', 'الطلبات', 'الفواتير', 'الكل'];
  
  final List<Map<String, dynamic>> _allNotifications = [
    {
      'id': '1',
      'type': 'message',
      'title': 'رسالة جديدة',
      'description': 'لديك رسالة من الإدارة بخصوص تحديث نظام فواتير المياه',
      'time': 'منذ 3 ساعات',
      'read': true,
      'tab': 0,
    },
    {
      'id': '2',
      'type': 'system',
      'title': 'تحديث النظام',
      'description': 'تم تحديث نظام فواتير المياه إلى الإصدار 2.1.0',
      'time': 'منذ يوم',
      'read': true,
      'tab': 0,
    },
    {
      'id': '3',
      'type': 'announcement',
      'title': 'إعلان هام',
      'description': 'اجتماع طارئ لموظفي قسم محاسبة المياه يوم الخميس القادم',
      'time': 'منذ يومين',
      'read': true,
      'tab': 0,
    },
    {
      'id': '4',
      'type': 'payment',
      'title': 'طلب دفع جديد',
      'description': 'طلب دفع جديد من المشترك أحمد محمد بقيمة 61,518 دينار',
      'time': 'منذ 5 دقائق',
      'read': false,
      'tab': 1,
    },
    {
      'id': '5',
      'type': 'complaint',
      'title': 'شكوى جديدة',
      'description': 'شكوى من المشترك فاطمة علي بخصوص فاتورة المياه',
      'time': 'منذ ساعة',
      'read': false,
      'tab': 1,
    },
    {
      'id': '6',
      'type': 'service',
      'title': 'طلب خدمة جديد',
      'description': 'طلب تركيب عداد مياه جديد من المشترك خالد إبراهيم',
      'time': 'منذ ساعتين',
      'read': false,
      'tab': 1,
    },
    {
      'id': '7',
      'type': 'bill',
      'title': 'فاتورة مياه جديدة',
      'description': 'تم إنشاء فاتورة مياه جديدة للمشترك سارة عبدالله بقيمة 75,000 دينار',
      'time': 'منذ 10 دقائق',
      'read': false,
      'tab': 2,
    },
    {
      'id': '8',
      'type': 'overdue',
      'title': 'فاتورة مياه متأخرة',
      'description': 'فاتورة مياه رقم WINV-2024-002 للمشترك فاطمة علي متأخرة الدفع',
      'time': 'منذ 3 أيام',
      'read': true,
      'tab': 2,
    },
    {
      'id': '9',
      'type': 'payment_success',
      'title': 'دفع ناجح',
      'description': 'تم دفع فاتورة مياه رقم WINV-2024-003 بنجاح من المشترك خالد إبراهيم',
      'time': 'منذ 30 دقيقة',
      'read': true,
      'tab': 2,
    },
    {
      'id': '10',
      'type': 'reading',
      'title': 'قراءة عداد مياه جديدة',
      'description': 'تم تسجيل قراءة عداد مياه جديدة للمشترك أحمد محمد',
      'time': 'منذ ساعة',
      'read': true,
      'tab': 2,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedTab == 3) {
      return _allNotifications;
    }
    return _allNotifications.where((notification) => notification['tab'] == _selectedTab).toList();
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
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
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
            child: _filteredNotifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = _filteredNotifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ],
      ),
    );
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
          padding: EdgeInsets.all(16),
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
              SizedBox(height: 8),
              Text(
                notification['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: _textSecondaryColor,
                ),
              ),
              SizedBox(height: 8),
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
          margin: EdgeInsets.symmetric(horizontal: 16),
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
          SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 18,
              color: _textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
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

  const HelpSupportScreen({
    Key? key,
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
  }) : super(key: key);

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
          gradient: isDarkMode
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF121212), Color(0xFF1A1A1A)],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF5F5F5), Color(0xFFE3F2FD)],
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
      color: isDarkMode ? darkCardColor : cardColor,
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
                'مركز الدعم الفني للمياه',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? darkTextColor : textColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        _buildContactItem(Icons.phone_rounded, 'رقم الدعم الفني', '07701234567', true, context),
        _buildContactItem(Icons.phone_rounded, 'رقم الطوارئ', '07809876543', true, context),
        _buildContactItem(Icons.email_rounded, 'البريد الإلكتروني', 'support@water.gov.iq', false, context),
        _buildContactItem(Icons.access_time_rounded, 'ساعات العمل', '8:00 ص - 4:00 م', false, context),
        _buildContactItem(Icons.location_on_rounded, 'العنوان', 'بغداد - وزارة الموارد المائية', false, context),
        SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _makePhoneCall('07701234567', context),
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
      builder: (context) => SupportChatScreen(
        isDarkMode: isDarkMode,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        accentColor: accentColor,
        darkCardColor: darkCardColor,
        cardColor: cardColor,
        darkTextColor: darkTextColor,
        textColor: textColor,
        darkTextSecondaryColor: darkTextSecondaryColor,
        textSecondaryColor: textSecondaryColor,
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
                color: isDarkMode ? darkTextColor : textColor,
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
                  color: isPhone ? primaryColor : (isDarkMode ? darkTextSecondaryColor : textSecondaryColor),
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
          color: isDarkMode ? darkTextColor : textColor,
        ),
      ),
    );
  }

  List<Widget> _buildFAQItems() {
    List<Map<String, String>> faqs = [
      {
        'question': 'كيف يمكنني إضافة فاتورة مياه جديدة؟',
        'answer': 'اذهب إلى قسم فواتير المياه → انقر على زر "إضافة فاتورة" → املأ البيانات المطلوبة (اسم المشترك، المبلغ، الاستهلاك) → اضغط على زر "حفظ"'
      },
      {
        'question': 'كيف أعرض تقرير إيرادات المياه الشهري؟',
        'answer': 'انتقل إلى قسم التقارير → اختر "تقرير الإيرادات" → حدد الفترة الزمنية المطلوبة → انقر على "عرض التقرير"'
      },
      {
        'question': 'كيف أعدل بيانات مشترك مسجل؟',
        'answer': 'اذهب إلى قسم المشتركين → انقر على المشترك المطلوب → اختر "تعديل البيانات" → قم بالتعديلات المطلوبة → اضغط على "حفظ التغييرات"'
      },
      {
        'question': 'كيف أتحقق من حالة الدفع لفواتير المياه؟',
        'answer': 'انتقل إلى قسم فواتير المياه → استخدم فلتر الحالة → اختر "مدفوعة" أو "غير مدفوعة" أو "متأخرة" → سيتم عرض الفواتير حسب الحالة المختارة'
      },
      {
        'question': 'كيف أقوم بعمل نسخة احتياطية لبيانات فواتير المياه؟',
        'answer': 'اذهب إلى الإعدادات → اختر "التخزين والبيانات" → انقر على "إنشاء نسخة احتياطية" → اختر موقع الحفظ → اضغط على "تأكيد"'
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
        color: isDarkMode ? darkCardColor : cardColor,
      ),
      child: ExpansionTile(
        leading: Icon(Icons.help_outline_rounded, color: primaryColor),
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isDarkMode ? darkTextColor : textColor,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(
                color: isDarkMode ? darkTextSecondaryColor : textSecondaryColor,
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
        color: isDarkMode ? darkCardColor : cardColor,
      ),
      child: Column(
        children: [
          _buildInfoRow('الإصدار', '1.0.0'),
          _buildInfoRow('تاريخ البناء', '2024-03-20'),
          _buildInfoRow('المطور', 'وزارة الموارد المائية'),
          _buildInfoRow('رقم الترخيص', 'MWR-2024-001'),
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
              color: isDarkMode ? darkTextColor : textColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDarkMode ? darkTextSecondaryColor : textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _makePhoneCall(String phoneNumber, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري الاتصال بـ $phoneNumber'),
        backgroundColor: primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
    launch('tel:$phoneNumber');
  }
}
class SupportChatScreen extends StatefulWidget {
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

  const SupportChatScreen({
    Key? key,
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
  }) : super(key: key);

  @override
  _SupportChatScreenState createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'مرحباً! أنا موظف دعم فواتير المياه، كيف يمكنني مساعدتك اليوم؟',
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
            'text': 'شكراً لتواصلكم مع دعم فواتير المياه. سأقوم بمساعدتك في حل هذه المشكلة. هل يمكنك تقديم مزيد من التفاصيل؟',
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
              'محادثة الدعم الفني للمياه',
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
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: Colors.white),
            onSelected: (value) {
              if (value == 'end_chat') {
                _endChat(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'end_chat',
                child: Row(
                  children: [
                    Icon(Icons.close_rounded, color: Colors.red),
                    SizedBox(width: 8),
                    Text('إنهاء المحادثة'),
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
                        'علي حسن - موظف دعم المياه',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: widget.isDarkMode ? widget.darkTextColor : widget.textColor,
                        ),
                      ),
                      Text(
                        'متخصص في نظام فواتير المياه والمحاسبة',
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
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
              color: widget.isDarkMode ? widget.darkCardColor : widget.cardColor,
              border: Border(
                top: BorderSide(color: widget.primaryColor.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.isDarkMode ? Colors.white10 : Colors.grey[50],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالتك هنا...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.attach_file_rounded, color: widget.primaryColor),
                          onPressed: () => _showAttachmentOptions(context),
                        ),
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
                if (!isUser)
                  Text(
                    message['sender'],
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser 
                        ? widget.primaryColor 
                        : (widget.isDarkMode ? Colors.white10 : Colors.grey[100]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message['text'],
                    style: TextStyle(
                      color: isUser ? Colors.white : (widget.isDarkMode ? widget.darkTextColor : widget.textColor),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message['time'],
                  style: TextStyle(
                    fontSize: 10,
                    color: widget.isDarkMode ? widget.darkTextSecondaryColor : widget.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          if (isUser)
            SizedBox(width: 8),
          if (isUser)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: widget.secondaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_rounded, color: Colors.white, size: 16),
            ),
        ],
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.isDarkMode ? widget.darkCardColor : widget.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'إرفاق ملف',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: widget.isDarkMode ? widget.darkTextColor : widget.textColor,
              ),
            ),
            SizedBox(height: 16),
            _buildAttachmentOption(Icons.photo_rounded, 'صورة', () {}),
            _buildAttachmentOption(Icons.description_rounded, 'ملف', () {}),
            _buildAttachmentOption(Icons.receipt_rounded, 'فاتورة مياه', () {}),
            _buildAttachmentOption(Icons.location_on_rounded, 'موقع', () {}),
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

  Widget _buildAttachmentOption(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: widget.primaryColor),
      title: Text(text),
      onTap: onTap,
    );
  }

  void _endChat(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDarkMode ? widget.darkCardColor : widget.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.close_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('إنهاء المحادثة'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من أنك تريد إنهاء المحادثة؟',
          style: TextStyle(
            color: widget.isDarkMode ? widget.darkTextColor : widget.textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('البقاء في المحادثة'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إنهاء المحادثة بنجاح'),
                  backgroundColor: widget.primaryColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('إنهاء المحادثة'),
          ),
        ],
      ),
    );
  }
}
