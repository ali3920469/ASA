import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';
import 'package:mang_mu/screens/employee/Shared Services/esignin_screen.dart';
import 'package:table_calendar/table_calendar.dart';

// ========== نماذج البيانات الجديدة للمواطن والموظف ==========

class Citizen {
  final String id;
  final String name;
  final String nationalId; // رقم الهوية
  final String houseNumber; // رقم الدار
  final String phoneNumber;
  final String location; // الموقع أو العنوان
  final DateTime registrationDate;
  final String? profileImageUrl; // رابط صورة الحساب
  final String? notes;

  Citizen({
    required this.id,
    required this.name,
    required this.nationalId,
    required this.houseNumber,
    required this.phoneNumber,
    required this.location,
    required this.registrationDate,
    this.profileImageUrl,
    this.notes,
  });
}

class Employee {
  final String id;
  final String name;
  final String nationalId; // رقم الهوية
  final String email;
  final String? idFrontImageUrl; // صورة الهوية الأمامية
  final String? idBackImageUrl; // صورة الهوية الخلفية
  final DateTime registrationDate;
  final String? notes;

  Employee({
    required this.id,
    required this.name,
    required this.nationalId,
    required this.email,
    this.idFrontImageUrl,
    this.idBackImageUrl,
    required this.registrationDate,
    this.notes,
  });
}

// ========== مزود بيانات المواطنين ==========

class CitizensProvider extends ChangeNotifier {
  List<Citizen> _citizens = [];

  List<Citizen> get citizens => _citizens;

  CitizensProvider() {
    _loadSampleData();
  }

  void _loadSampleData() {
    _citizens = [
      Citizen(
        id: 'CIT-001',
        name: 'أحمد محمد حسن',
        nationalId: '123456789012',
        houseNumber: 'شارع الرشيد - 15',
        phoneNumber: '07701234567',
        location: 'منطقة الكرادة - بغداد',
        registrationDate: DateTime.now().subtract(Duration(days: 30)),
        profileImageUrl: null,
        notes: 'مواطن دائم، لديه حساب لدفع الفواتير',
      ),
      Citizen(
        id: 'CIT-002',
        name: 'فاطمة علي جاسم',
        nationalId: '234567890123',
        houseNumber: 'منطقة الزعفرانية - 22',
        phoneNumber: '07801234567',
        location: 'منطقة الزعفرانية - بغداد',
        registrationDate: DateTime.now().subtract(Duration(days: 15)),
        profileImageUrl: null,
        notes: 'مواطنة جديدة، تم التسجيل عبر التطبيق',
      ),
      Citizen(
        id: 'CIT-003',
        name: 'محمد كريم عبود',
        nationalId: '345678901234',
        houseNumber: 'منطقة البلديات - 8',
        phoneNumber: '07901234567',
        location: 'منطقة البلديات - بغداد',
        registrationDate: DateTime.now().subtract(Duration(days: 45)),
        profileImageUrl: null,
        notes: 'لديه عدة عقارات، يتابع فواتير متعددة',
      ),
      Citizen(
        id: 'CIT-004',
        name: 'زينب عبد الرزاق',
        nationalId: '456789012345',
        houseNumber: 'منطقة الكاظمية - 5',
        phoneNumber: '07712345678',
        location: 'منطقة الكاظمية - بغداد',
        registrationDate: DateTime.now().subtract(Duration(days: 7)),
        profileImageUrl: null,
        notes: 'مواطنة مسنة، تحتاج مساعدة في الدفع',
      ),
    ];
    notifyListeners();
  }

  void addCitizen(Citizen citizen) {
    _citizens.add(citizen);
    notifyListeners();
  }

  void updateCitizen(String id, Citizen updatedCitizen) {
    final index = _citizens.indexWhere((c) => c.id == id);
    if (index != -1) {
      _citizens[index] = updatedCitizen;
      notifyListeners();
    }
  }

  void deleteCitizen(String id) {
    _citizens.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}

// ========== مزود بيانات الموظفين ==========

class EmployeesProvider extends ChangeNotifier {
  List<Employee> _employees = [];

  List<Employee> get employees => _employees;

  EmployeesProvider() {
    _loadSampleData();
  }

  void _loadSampleData() {
    _employees = [
      Employee(
        id: 'EMP-001',
        name: 'سارة عبد الله',
        nationalId: '987654321012',
        email: 'sara@electric.gov.iq',
        idFrontImageUrl: null,
        idBackImageUrl: null,
        registrationDate: DateTime.now().subtract(Duration(days: 60)),
        notes: 'موظفة في قسم الموارد البشرية',
      ),
      Employee(
        id: 'EMP-002',
        name: 'علي كاظم',
        nationalId: '876543210123',
        email: 'ali@electric.gov.iq',
        idFrontImageUrl: null,
        idBackImageUrl: null,
        registrationDate: DateTime.now().subtract(Duration(days: 45)),
        notes: 'مهندس في قسم الصيانة',
      ),
      Employee(
        id: 'EMP-003',
        name: 'نور سليم',
        nationalId: '765432101234',
        email: 'nour@electric.gov.iq',
        idFrontImageUrl: null,
        idBackImageUrl: null,
        registrationDate: DateTime.now().subtract(Duration(days: 30)),
        notes: 'مبرمجة في قسم IT',
      ),
      Employee(
        id: 'EMP-004',
        name: 'حسن عبد الرحمن',
        nationalId: '654321012345',
        email: 'hassan@electric.gov.iq',
        idFrontImageUrl: null,
        idBackImageUrl: null,
        registrationDate: DateTime.now().subtract(Duration(days: 90)),
        notes: 'مدير قسم المشتريات',
      ),
    ];
    notifyListeners();
  }

  void addEmployee(Employee employee) {
    _employees.add(employee);
    notifyListeners();
  }

  void updateEmployee(String id, Employee updatedEmployee) {
    final index = _employees.indexWhere((e) => e.id == id);
    if (index != -1) {
      _employees[index] = updatedEmployee;
      notifyListeners();
    }
  }

  void deleteEmployee(String id) {
    _employees.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}

class AccountRequest {
  final String id;
  final String employeeName;
  final String employeeId;
  final String department;
  final String position;
  final String email;
  final String phone;
  final DateTime requestDate;
  final String status;
  final String? approvedBy;
  final DateTime? approvedDate;
  final String? rejectionReason;
  final List<String> requestedPermissions;
  final String? notes;

  AccountRequest({
    required this.id,
    required this.employeeName,
    required this.employeeId,
    required this.department,
    required this.position,
    required this.email,
    required this.phone,
    required this.requestDate,
    required this.status,
    this.approvedBy,
    this.approvedDate,
    this.rejectionReason,
    required this.requestedPermissions,
    this.notes,
  });
}

class SystemUser {
  final String id;
  final String username;
  final String fullName;
  final String employeeId;
  final String department;
  final String position;
  final String email;
  final String phone;
  final DateTime accountCreated;
  final String accountStatus;
  final List<String> permissions;
  final DateTime? lastLogin;
  final DateTime? passwordLastChanged;
  final String? createdBy;
  final String? notes;

  SystemUser({
    required this.id,
    required this.username,
    required this.fullName,
    required this.employeeId,
    required this.department,
    required this.position,
    required this.email,
    required this.phone,
    required this.accountCreated,
    required this.accountStatus,
    required this.permissions,
    this.lastLogin,
    this.passwordLastChanged,
    this.createdBy,
    this.notes,
  });
}

// ========== مزود بيانات طلبات الحسابات ==========

class AccountRequestsProvider extends ChangeNotifier {
  List<AccountRequest> _requests = [];

  List<AccountRequest> get requests => _requests;

  List<AccountRequest> get pendingRequests =>
      _requests.where((request) => request.status == 'pending').toList();

  List<AccountRequest> get approvedRequests =>
      _requests.where((request) => request.status == 'approved').toList();

  List<AccountRequest> get rejectedRequests =>
      _requests.where((request) => request.status == 'rejected').toList();

  AccountRequestsProvider() {
    _loadSampleData();
  }

  void _loadSampleData() {
    _requests = [
      AccountRequest(
        id: '1',
        employeeName: 'أحمد محمد',
        employeeId: 'EMP-2024-001',
        department: 'قسم المحاسبة',
        position: 'محاسب',
        email: 'ahmed@electric.gov.iq',
        phone: '07701234567',
        requestDate: DateTime.now().subtract(Duration(days: 2)),
        status: 'pending',
        requestedPermissions: ['قراءة الفواتير', 'إضافة سجلات', 'طباعة التقارير'],
        notes: 'موظف جديد في القسم',
      ),
      AccountRequest(
        id: '2',
        employeeName: 'سارة عبد الله',
        employeeId: 'EMP-2024-002',
        department: 'قسم الموارد البشرية',
        position: 'موظف شؤون موظفين',
        email: 'sara@electric.gov.iq',
        phone: '07701234568',
        requestDate: DateTime.now().subtract(Duration(days: 1)),
        status: 'approved',
        approvedBy: 'محرر الحسابات',
        approvedDate: DateTime.now().subtract(Duration(hours: 12)),
        requestedPermissions: ['قراءة السجلات', 'إضافة موظفين', 'تعديل البيانات'],
        notes: 'مطلوب لشغل وظيفة جديدة',
      ),
      AccountRequest(
        id: '3',
        employeeName: 'علي كاظم',
        employeeId: 'EMP-2024-003',
        department: 'قسم الصيانة',
        position: 'مهندس',
        email: 'ali@electric.gov.iq',
        phone: '07701234569',
        requestDate: DateTime.now().subtract(Duration(days: 3)),
        status: 'rejected',
        approvedBy: 'محرر الحسابات',
        rejectionReason: 'الصلاحيات المطلوبة غير مناسبة للوظيفة',
        requestedPermissions: ['صلاحيات إدارية كاملة', 'حذف سجلات', 'تعديل النظام'],
        notes: 'طلب صلاحيات غير مناسبة',
      ),
    ];
    notifyListeners();
  }

  void approveRequest(String requestId, String approvedBy) {
    final index = _requests.indexWhere((req) => req.id == requestId);
    if (index != -1) {
      _requests[index] = AccountRequest(
        id: _requests[index].id,
        employeeName: _requests[index].employeeName,
        employeeId: _requests[index].employeeId,
        department: _requests[index].department,
        position: _requests[index].position,
        email: _requests[index].email,
        phone: _requests[index].phone,
        requestDate: _requests[index].requestDate,
        status: 'approved',
        approvedBy: approvedBy,
        approvedDate: DateTime.now(),
        requestedPermissions: _requests[index].requestedPermissions,
        notes: _requests[index].notes,
      );
      notifyListeners();
    }
  }

  void rejectRequest(String requestId, String rejectedBy, String reason) {
    final index = _requests.indexWhere((req) => req.id == requestId);
    if (index != -1) {
      _requests[index] = AccountRequest(
        id: _requests[index].id,
        employeeName: _requests[index].employeeName,
        employeeId: _requests[index].employeeId,
        department: _requests[index].department,
        position: _requests[index].position,
        email: _requests[index].email,
        phone: _requests[index].phone,
        requestDate: _requests[index].requestDate,
        status: 'rejected',
        approvedBy: rejectedBy,
        rejectionReason: reason,
        requestedPermissions: _requests[index].requestedPermissions,
        notes: _requests[index].notes,
      );
      notifyListeners();
    }
  }
}

// ========== مزود بيانات المستخدمين ==========

class UsersProvider extends ChangeNotifier {
  List<SystemUser> _users = [];

  List<SystemUser> get users => _users;

  List<SystemUser> get activeUsers =>
      _users.where((user) => user.accountStatus == 'active').toList();

  List<SystemUser> get inactiveUsers =>
      _users.where((user) => user.accountStatus == 'inactive').toList();

  List<SystemUser> get suspendedUsers =>
      _users.where((user) => user.accountStatus == 'suspended').toList();

  UsersProvider() {
    _loadSampleData();
  }

  void _loadSampleData() {
    _users = [
      SystemUser(
        id: 'USR-001',
        username: 'ahmed.mohammed',
        fullName: 'أحمد محمد',
        employeeId: 'EMP-2024-001',
        department: 'قسم المحاسبة',
        position: 'محاسب',
        email: 'ahmed@electric.gov.iq',
        phone: '07701234567',
        accountCreated: DateTime.now().subtract(Duration(days: 30)),
        accountStatus: 'active',
        permissions: ['قراءة الفواتير', 'إضافة سجلات', 'طباعة التقارير'],
        lastLogin: DateTime.now().subtract(Duration(hours: 2)),
        passwordLastChanged: DateTime.now().subtract(Duration(days: 15)),
        createdBy: 'محرر الحسابات',
        notes: 'موظف نشط - أداء ممتاز',
      ),
      SystemUser(
        id: 'USR-002',
        username: 'sara.abdullah',
        fullName: 'سارة عبد الله',
        employeeId: 'EMP-2024-002',
        department: 'قسم الموارد البشرية',
        position: 'موظف شؤون موظفين',
        email: 'sara@electric.gov.iq',
        phone: '07701234568',
        accountCreated: DateTime.now().subtract(Duration(days: 25)),
        accountStatus: 'active',
        permissions: ['قراءة السجلات', 'إضافة موظفين', 'تعديل البيانات'],
        lastLogin: DateTime.now().subtract(Duration(days: 1)),
        passwordLastChanged: DateTime.now().subtract(Duration(days: 10)),
        createdBy: 'محرر الحسابات',
        notes: 'موظف جديد - يحتاج تدريب',
      ),
      SystemUser(
        id: 'USR-003',
        username: 'ali.kadhim',
        fullName: 'علي كاظم',
        employeeId: 'EMP-2024-003',
        department: 'قسم الصيانة',
        position: 'مهندس',
        email: 'ali@electric.gov.iq',
        phone: '07701234569',
        accountCreated: DateTime.now().subtract(Duration(days: 60)),
        accountStatus: 'suspended',
        permissions: ['صلاحيات إدارية', 'تقارير الصيانة'],
        lastLogin: DateTime.now().subtract(Duration(days: 15)),
        passwordLastChanged: DateTime.now().subtract(Duration(days: 30)),
        createdBy: 'محرر الحسابات',
        notes: 'حساب موقوف مؤقتاً - إجازة مرضية',
      ),
      SystemUser(
        id: 'USR-004',
        username: 'lama.hassan',
        fullName: 'لمى حسن',
        employeeId: 'EMP-2024-004',
        department: 'قسم الأرشيف',
        position: 'أمين أرشيف',
        email: 'lama@electric.gov.iq',
        phone: '07701234570',
        accountCreated: DateTime.now().subtract(Duration(days: 20)),
        accountStatus: 'active',
        permissions: ['قراءة الوثائق', 'بحث في الأرشيف'],
        lastLogin: DateTime.now().subtract(Duration(hours: 5)),
        passwordLastChanged: DateTime.now().subtract(Duration(days: 5)),
        createdBy: 'محرر الحسابات',
        notes: 'موظفة مجتهدة',
      ),
      SystemUser(
        id: 'USR-005',
        username: 'hassan.abdulrahman',
        fullName: 'حسن عبد الرحمن',
        employeeId: 'EMP-2024-005',
        department: 'قسم المشتريات',
        position: 'مدير مشتريات',
        email: 'hassan@electric.gov.iq',
        phone: '07701234571',
        accountCreated: DateTime.now().subtract(Duration(days: 45)),
        accountStatus: 'active',
        permissions: ['إدارة المشتريات', 'اعتماد الفواتير', 'تقارير الميزانية'],
        lastLogin: DateTime.now().subtract(Duration(hours: 1)),
        passwordLastChanged: DateTime.now().subtract(Duration(days: 20)),
        createdBy: 'محرر الحسابات',
        notes: 'مدير قسم - صلاحيات متقدمة',
      ),
      SystemUser(
        id: 'USR-006',
        username: 'nour.saleem',
        fullName: 'نور سليم',
        employeeId: 'EMP-2024-006',
        department: 'قسم IT',
        position: 'مبرمج',
        email: 'nour@electric.gov.iq',
        phone: '07701234572',
        accountCreated: DateTime.now().subtract(Duration(days: 10)),
        accountStatus: 'active',
        permissions: ['صلاحيات النظام', 'إدارة قواعد البيانات'],
        lastLogin: DateTime.now().subtract(Duration(hours: 3)),
        passwordLastChanged: DateTime.now().subtract(Duration(days: 2)),
        createdBy: 'محرر الحسابات',
        notes: 'موظف دعم فني',
      ),
      SystemUser(
        id: 'USR-007',
        username: 'mahmoud.kamel',
        fullName: 'محمود كامل',
        employeeId: 'EMP-2024-007',
        department: 'قسم المالية',
        position: 'مراجع مالي',
        email: 'mahmoud@electric.gov.iq',
        phone: '07701234573',
        accountCreated: DateTime.now().subtract(Duration(days: 15)),
        accountStatus: 'inactive',
        permissions: ['مراجعة الحسابات', 'تقارير مالية'],
        lastLogin: DateTime.now().subtract(Duration(days: 30)),
        passwordLastChanged: DateTime.now().subtract(Duration(days: 15)),
        createdBy: 'محرر الحسابات',
        notes: 'حساب غير نشط - إجازة طويلة',
      ),
    ];
    notifyListeners();
  }

  void activateUser(String userId) {
    final index = _users.indexWhere((user) => user.id == userId);
    if (index != -1) {
      _users[index] = SystemUser(
        id: _users[index].id,
        username: _users[index].username,
        fullName: _users[index].fullName,
        employeeId: _users[index].employeeId,
        department: _users[index].department,
        position: _users[index].position,
        email: _users[index].email,
        phone: _users[index].phone,
        accountCreated: _users[index].accountCreated,
        accountStatus: 'active',
        permissions: _users[index].permissions,
        lastLogin: _users[index].lastLogin,
        passwordLastChanged: _users[index].passwordLastChanged,
        createdBy: _users[index].createdBy,
        notes: _users[index].notes,
      );
      notifyListeners();
    }
  }

  void suspendUser(String userId) {
    final index = _users.indexWhere((user) => user.id == userId);
    if (index != -1) {
      _users[index] = SystemUser(
        id: _users[index].id,
        username: _users[index].username,
        fullName: _users[index].fullName,
        employeeId: _users[index].employeeId,
        department: _users[index].department,
        position: _users[index].position,
        email: _users[index].email,
        phone: _users[index].phone,
        accountCreated: _users[index].accountCreated,
        accountStatus: 'suspended',
        permissions: _users[index].permissions,
        lastLogin: _users[index].lastLogin,
        passwordLastChanged: _users[index].passwordLastChanged,
        createdBy: _users[index].createdBy,
        notes: _users[index].notes,
      );
      notifyListeners();
    }
  }

  void deactivateUser(String userId) {
    final index = _users.indexWhere((user) => user.id == userId);
    if (index != -1) {
      _users[index] = SystemUser(
        id: _users[index].id,
        username: _users[index].username,
        fullName: _users[index].fullName,
        employeeId: _users[index].employeeId,
        department: _users[index].department,
        position: _users[index].position,
        email: _users[index].email,
        phone: _users[index].phone,
        accountCreated: _users[index].accountCreated,
        accountStatus: 'inactive',
        permissions: _users[index].permissions,
        lastLogin: _users[index].lastLogin,
        passwordLastChanged: _users[index].passwordLastChanged,
        createdBy: _users[index].createdBy,
        notes: _users[index].notes,
      );
      notifyListeners();
    }
  }

  void deleteUser(String userId) {
    _users.removeWhere((user) => user.id == userId);
    notifyListeners();
  }

  void updateUserPermissions(String userId, List<String> newPermissions) {
    final index = _users.indexWhere((user) => user.id == userId);
    if (index != -1) {
      _users[index] = SystemUser(
        id: _users[index].id,
        username: _users[index].username,
        fullName: _users[index].fullName,
        employeeId: _users[index].employeeId,
        department: _users[index].department,
        position: _users[index].position,
        email: _users[index].email,
        phone: _users[index].phone,
        accountCreated: _users[index].accountCreated,
        accountStatus: _users[index].accountStatus,
        permissions: newPermissions,
        lastLogin: _users[index].lastLogin,
        passwordLastChanged: _users[index].passwordLastChanged,
        createdBy: _users[index].createdBy,
        notes: _users[index].notes,
      );
      notifyListeners();
    }
  }

  void resetUserPassword(String userId) {
    final index = _users.indexWhere((user) => user.id == userId);
    if (index != -1) {
      _users[index] = SystemUser(
        id: _users[index].id,
        username: _users[index].username,
        fullName: _users[index].fullName,
        employeeId: _users[index].employeeId,
        department: _users[index].department,
        position: _users[index].position,
        email: _users[index].email,
        phone: _users[index].phone,
        accountCreated: _users[index].accountCreated,
        accountStatus: _users[index].accountStatus,
        permissions: _users[index].permissions,
        lastLogin: _users[index].lastLogin,
        passwordLastChanged: DateTime.now(),
        createdBy: _users[index].createdBy,
        notes: _users[index].notes,
      );
      notifyListeners();
    }
  }
}

class AccountAuditorHome extends StatefulWidget {
  static const String screenRoute = '/account-editor';

  const AccountAuditorHome({super.key});

  @override
  AccountAuditorHomeState createState() => AccountAuditorHomeState();
}

class AccountAuditorHomeState extends State<AccountAuditorHome>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _requestsSubTabController;
  late TabController _usersSubTabController;
  late TabController _reportsSubTabController;
  
  // Scroll controllers لكل قسم
  final ScrollController _mainScrollController = ScrollController();
  
  final Color _primaryColor = Color(0xFF1976D2);
  final Color _secondaryColor = Color(0xFF42A5F5);
  final Color _accentColor = Color(0xFF0D47A1);
  final Color _successColor = Color(0xFF4CAF50);
  final Color _warningColor = Color(0xFFFF9800);
  final Color _errorColor = Color(0xFFF44336);
  final Color _infoColor = Color(0xFF2196F3);
  final Color _darkColor = Color(0xFF1A237E);

  final Color _darkPrimaryColor = Color(0xFF1565C0);
  final Color _darkBackgroundColor = Color(0xFF121212);
  final Color _darkCardColor = Color(0xFF1E1E1E);

  late AccountRequestsProvider _requestsProvider;
  late UsersProvider _usersProvider;
  late CitizensProvider _citizensProvider;
  late EmployeesProvider _employeesProvider;

  // متغيرات التقارير
  String _selectedReportTypeSystem = 'يومي';
  List<DateTime> _selectedDates = [];
  String? _selectedWeek;
  String? _selectedMonth;
  final List<String> _reportTypes = ['يومي', 'أسبوعي', 'شهري'];
  final List<String> _weeks = ['الأسبوع الأول', 'الأسبوع الثاني', 'الأسبوع الثالث', 'الأسبوع الرابع'];
  final List<String> _months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _requestsSubTabController = TabController(length: 3, vsync: this);
    _usersSubTabController = TabController(length: 3, vsync: this);
    _reportsSubTabController = TabController(length: 2, vsync: this);
    
    _requestsProvider = AccountRequestsProvider();
    _usersProvider = UsersProvider();
    _citizensProvider = CitizensProvider();
    _employeesProvider = EmployeesProvider();
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _requestsSubTabController.dispose();
    _usersSubTabController.dispose();
    _reportsSubTabController.dispose();
    _mainScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _requestsProvider),
        ChangeNotifierProvider.value(value: _usersProvider),
        ChangeNotifierProvider.value(value: _citizensProvider),
        ChangeNotifierProvider.value(value: _employeesProvider),
      ],
      child: Scaffold(
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
                child: Icon(Icons.account_balance_rounded, color: _primaryColor, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'وزارة الكهرباء - نظام محرر الحسابات',
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
                  Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsScreen()),
                );
              },
            ),
          ],
        ),
        drawer: _buildAccountEditorDrawer(context, isDarkMode),
        body: CustomScrollView(
          controller: _mainScrollController,
          slivers: [
            // SliverAppBar للتبويب الرئيسي - يختفي عند التمرير
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              backgroundColor: isDarkMode ? _darkPrimaryColor : _primaryColor,
              elevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
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
                      controller: _mainTabController,
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
                        fontSize: 14,
                      ),
                      padding: EdgeInsets.zero,
                      labelPadding: EdgeInsets.symmetric(horizontal: 10),
                      tabs: [
                        Tab(
                          icon: Icon(Icons.people_rounded, size: 22),
                          text: 'المواطنين',
                        ),
                        Tab(
                          icon: Icon(Icons.badge_rounded, size: 22),
                          text: 'الموظفين',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // المحتوى الرئيسي
            SliverFillRemaining(
              child: Container(
                decoration: BoxDecoration(
                  gradient: isDarkMode
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [_darkBackgroundColor, Color(0xFF1A1A1A)],
                        )
                      : LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFF5F5F5), Color(0xFFE3F2FD)],
                        ),
                ),
                child: TabBarView(
                  controller: _mainTabController,
                  children: [
                    // تبويب المواطنين
                    _buildCitizensTab(isDarkMode),
                    
                    // تبويب الموظفين
                    _buildEmployeesTab(isDarkMode),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== تبويب المواطنين ==========
  Widget _buildCitizensTab(bool isDarkMode) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            // SliverAppBar للتبويبات الفرعية للمواطنين
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              backgroundColor: isDarkMode ? _darkPrimaryColor.withOpacity(0.95) : _primaryColor.withOpacity(0.95),
              elevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: TabBar(
                  controller: _mainTabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.7),
                  labelStyle: TextStyle(fontWeight: FontWeight.w600),
                  tabs: [
                    Tab(
                      icon: Icon(Icons.person_add_rounded, size: 20),
                      text:'طلبات الحسابات',
                    ),
                    Tab(
                      icon: Icon(Icons.people_alt_rounded, size: 20),
                      text:'المستخدمين',
                    ),
                    Tab(
                      icon: Icon(Icons.summarize_rounded, size: 20),
                      text: 'التقارير',
                    ),
                  ],
                ),
              ),
            ),
            
            // المحتوى
            SliverFillRemaining(
              child: TabBarView(
                controller: _mainTabController,
                children: [
                  _buildRequestsTab(isDarkMode),
                  _buildUsersTab(isDarkMode),
                  _buildReportsTab(isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== تبويب الموظفين ==========
  Widget _buildEmployeesTab(bool isDarkMode) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            // SliverAppBar للتبويبات الفرعية للموظفين
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              backgroundColor: isDarkMode ? _darkPrimaryColor.withOpacity(0.95) : _primaryColor.withOpacity(0.95),
              elevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: TabBar(
                  controller: _mainTabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.7),
                  labelStyle: TextStyle(fontWeight: FontWeight.w600),
                  tabs: [
                    Tab(
                      icon: Icon(Icons.person_add_rounded, size: 20),
                      text:'طلبات الحسابات',
                    ),
                    Tab(
                      icon: Icon(Icons.people_alt_rounded, size: 20),
                      text:'المستخدمين',
                    ),
                    Tab(
                      icon: Icon(Icons.summarize_rounded, size: 20),
                      text: 'التقارير',
                    ),
                  ],
                ),
              ),
            ),
            
            // المحتوى
            SliverFillRemaining(
              child: TabBarView(
                controller: _mainTabController,
                children: [
                  _buildRequestsTab(isDarkMode),
                  _buildUsersTab(isDarkMode),
                  _buildReportsTab(isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageDialog(String title, String? imageUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: imageUrl != null
              ? Image.network(imageUrl, fit: BoxFit.cover)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_not_supported_rounded, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('لا توجد صورة متاحة'),
                    ],
                  ),
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

  void _showAddCitizenDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إضافة مواطن جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: InputDecoration(labelText: 'الاسم الكامل')),
              TextField(decoration: InputDecoration(labelText: 'رقم الهوية')),
              TextField(decoration: InputDecoration(labelText: 'رقم الدار')),
              TextField(decoration: InputDecoration(labelText: 'رقم الهاتف')),
              TextField(decoration: InputDecoration(labelText: 'الموقع')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('تمت إضافة المواطن بنجاح');
            },
            child: Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showAddEmployeeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إضافة موظف جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: InputDecoration(labelText: 'الاسم الكامل')),
              TextField(decoration: InputDecoration(labelText: 'رقم الهوية')),
              TextField(decoration: InputDecoration(labelText: 'البريد الإلكتروني')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('تمت إضافة الموظف بنجاح');
            },
            child: Text('إضافة'),
          ),
        ],
      ),
    );
  }

  // ========== تبويب طلبات الحسابات ==========
  Widget _buildRequestsTab(bool isDarkMode) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            // SliverAppBar للتبويبات الفرعية لطلبات الحسابات
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              backgroundColor: isDarkMode ? _darkPrimaryColor.withOpacity(0.95) : _primaryColor.withOpacity(0.95),
              elevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: TabBar(
                  controller: _requestsSubTabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.7),
                  labelStyle: TextStyle(fontWeight: FontWeight.w600),
                  tabs: [
                    Tab(
                      icon: Consumer<AccountRequestsProvider>(
                        builder: (context, provider, child) {
                          return Badge(
                            label: Text(provider.pendingRequests.length.toString()),
                            backgroundColor: _warningColor,
                            textColor: Colors.white,
                            smallSize: 18,
                          );
                        },
                      ),
                      text: 'جديدة',
                    ),
                    Tab(
                      icon: Icon(Icons.check_circle_rounded),
                      text: 'موافق عليها',
                    ),
                    Tab(
                      icon: Icon(Icons.cancel_rounded),
                      text: 'ملغية',
                    ),
                  ],
                ),
              ),
            ),
            
            // المحتوى
            SliverFillRemaining(
              child: TabBarView(
                controller: _requestsSubTabController,
                children: [
                  _buildPendingRequestsTab(isDarkMode),
                  _buildApprovedRequestsTab(isDarkMode),
                  _buildRejectedRequestsTab(isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== تبويب الطلبات الجديدة ==========
  Widget _buildPendingRequestsTab(bool isDarkMode) {
    return Consumer<AccountRequestsProvider>(
      builder: (context, provider, child) {
        final pendingRequests = provider.pendingRequests;

        if (pendingRequests.isEmpty) {
          return _buildEmptyState(
            Icons.inbox_rounded,
            'لا توجد طلبات جديدة',
            'جميع الطلبات تمت معالجتها',
            isDarkMode,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1));
            provider._loadSampleData();
          },
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: pendingRequests.length,
            itemBuilder: (context, index) {
              final request = pendingRequests[index];
              return _buildRequestCard(request, isDarkMode, true);
            },
          ),
        );
      },
    );
  }

  // ========== تبويب الطلبات الموافق عليها ==========
  Widget _buildApprovedRequestsTab(bool isDarkMode) {
    return Consumer<AccountRequestsProvider>(
      builder: (context, provider, child) {
        final approvedRequests = provider.approvedRequests;

        if (approvedRequests.isEmpty) {
          return _buildEmptyState(
            Icons.check_circle_outline_rounded,
            'لا توجد طلبات موافق عليها',
            '',
            isDarkMode,
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: approvedRequests.length,
          itemBuilder: (context, index) {
            final request = approvedRequests[index];
            return _buildRequestCard(request, isDarkMode, false);
          },
        );
      },
    );
  }

  // ========== تبويب الطلبات الملغية ==========
  Widget _buildRejectedRequestsTab(bool isDarkMode) {
    return Consumer<AccountRequestsProvider>(
      builder: (context, provider, child) {
        final rejectedRequests = provider.rejectedRequests;

        if (rejectedRequests.isEmpty) {
          return _buildEmptyState(
            Icons.cancel_outlined,
            'لا توجد طلبات ملغية',
            '',
            isDarkMode,
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: rejectedRequests.length,
          itemBuilder: (context, index) {
            final request = rejectedRequests[index];
            return _buildRequestCard(request, isDarkMode, false);
          },
        );
      },
    );
  }

  // ========== حالة فارغة ==========
  Widget _buildEmptyState(IconData icon, String title, String subtitle, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: isDarkMode ? Colors.white38 : Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: isDarkMode ? Colors.white : Colors.grey[600],
            ),
          ),
          if (subtitle.isNotEmpty) SizedBox(height: 8),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white54 : Colors.grey[500],
              ),
            ),
        ],
      ),
    );
  }

  // ========== بناء بطاقة الطلب ==========
  Widget _buildRequestCard(AccountRequest request, bool isDarkMode, bool isPending) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (request.status) {
      case 'pending':
        statusColor = _warningColor;
        statusIcon = Icons.pending_actions_rounded;
        statusText = 'قيد المراجعة';
        break;
      case 'approved':
        statusColor = _successColor;
        statusIcon = Icons.check_circle_rounded;
        statusText = 'موافق عليه';
        break;
      case 'rejected':
        statusColor = _errorColor;
        statusIcon = Icons.cancel_rounded;
        statusText = 'مرفوض';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.question_mark_rounded;
        statusText = 'غير معروف';
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      color: isDarkMode ? _darkCardColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.withOpacity(0.2), width: 1),
      ),
      child: InkWell(
        onTap: () => _showRequestDetails(request, isDarkMode),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: statusColor,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.employeeName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${request.position} - ${request.department}',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.white70 : Colors.grey[600],
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
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 14, color: statusColor),
                        SizedBox(width: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Divider(
                height: 1,
                color: isDarkMode ? Colors.white12 : Colors.grey[200],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem(
                    Icons.email_rounded,
                    request.email,
                    isDarkMode,
                  ),
                  _buildInfoItem(
                    Icons.phone_rounded,
                    request.phone,
                    isDarkMode,
                  ),
                  _buildInfoItem(
                    Icons.badge_rounded,
                    request.employeeId,
                    isDarkMode,
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: isDarkMode ? Colors.white54 : Colors.grey[500],
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${_formatDate(request.requestDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white54 : Colors.grey[500],
                    ),
                  ),
                ],
              ),
              if (isPending)
                SizedBox(height: 16),
              if (isPending)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _approveRequest(request.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _successColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        icon: Icon(Icons.check_rounded, size: 18, color: Colors.white),
                        label: Text('موافقة', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _rejectRequestDialog(request.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _errorColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        icon: Icon(Icons.close_rounded, size: 18, color: Colors.white),
                        label: Text('رفض', style: TextStyle(color: Colors.white)),
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

  // ========== عنصر معلومات ==========
  Widget _buildInfoItem(IconData icon, String text, bool isDarkMode) {
    return Column(
      children: [
        Icon(icon, size: 16, color: isDarkMode ? Colors.white54 : Colors.grey[500]),
        SizedBox(height: 4),
        SizedBox(
          width: 80,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: isDarkMode ? Colors.white54 : Colors.grey[500],
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ========== عرض تفاصيل الطلب ==========
  void _showRequestDetails(AccountRequest request, bool isDarkMode) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (request.status) {
      case 'pending':
        statusColor = _warningColor;
        statusIcon = Icons.pending_actions_rounded;
        statusText = 'قيد المراجعة';
        break;
      case 'approved':
        statusColor = _successColor;
        statusIcon = Icons.check_circle_rounded;
        statusText = 'موافق عليه';
        break;
      case 'rejected':
        statusColor = _errorColor;
        statusIcon = Icons.cancel_rounded;
        statusText = 'مرفوض';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.question_mark_rounded;
        statusText = 'غير معروف';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: isDarkMode ? _darkCardColor : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'تفاصيل طلب الحساب',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor),
                      ),
                      child: Row(
                        children: [
                          Icon(statusIcon, size: 16, color: statusColor),
                          SizedBox(width: 6),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
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
                      _buildDetailSection('معلومات الموظف', Icons.person_rounded, [
                        _buildDetailItem('الاسم الكامل', request.employeeName, isDarkMode),
                        _buildDetailItem('رقم الموظف', request.employeeId, isDarkMode),
                        _buildDetailItem('القسم', request.department, isDarkMode),
                        _buildDetailItem('الوظيفة', request.position, isDarkMode),
                        _buildDetailItem('البريد الإلكتروني', request.email, isDarkMode),
                        _buildDetailItem('رقم الهاتف', request.phone, isDarkMode),
                      ]),
                      _buildDetailSection('معلومات الطلب', Icons.description_rounded, [
                        _buildDetailItem('تاريخ الطلب', _formatDateTime(request.requestDate), isDarkMode),
                        _buildDetailItem('رقم الطلب', request.id, isDarkMode),
                        if (request.notes != null)
                          _buildDetailItem('ملاحظات', request.notes!, isDarkMode),
                      ]),
                      _buildDetailSection('الصلاحيات المطلوبة', Icons.security_rounded, [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: request.requestedPermissions.map((permission) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle_rounded, size: 16, color: _successColor),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      permission,
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.white70 : Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ]),
                      if (request.status != 'pending')
                        _buildDetailSection('معلومات القرار', Icons.assignment_turned_in_rounded, [
                          if (request.approvedBy != null)
                            _buildDetailItem('تمت المعالجة بواسطة', request.approvedBy!, isDarkMode),
                          if (request.approvedDate != null)
                            _buildDetailItem('تاريخ المعالجة', _formatDateTime(request.approvedDate!), isDarkMode),
                          if (request.status == 'rejected' && request.rejectionReason != null)
                            _buildDetailItem('سبب الرفض', request.rejectionReason!, isDarkMode),
                        ]),
                      SizedBox(height: 24),
                      if (request.status == 'pending')
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _approveRequest(request.id);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _successColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: Icon(Icons.check_rounded),
                                label: Text('موافقة'),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _rejectRequestDialog(request.id);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _errorColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: Icon(Icons.close_rounded),
                                label: Text('رفض'),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ========== قسم التفاصيل ==========
  Widget _buildDetailSection(String title, IconData icon, List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: _primaryColor),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  // ========== عنصر تفاصيل ==========
  Widget _buildDetailItem(String label, String value, bool isDarkMode) {
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
                color: isDarkMode ? Colors.white70 : Colors.grey[700],
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== نافذة الموافقة ==========
  void _approveRequest(String requestId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: _successColor),
            SizedBox(width: 8),
            Text('تأكيد الموافقة'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('هل أنت متأكد من الموافقة على هذا الطلب؟'),
            SizedBox(height: 8),
            Text(
              'سيتم إنشاء حساب للموظف وإرسال بيانات الدخول إليه.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
              _requestsProvider.approveRequest(requestId, 'محرر الحسابات');
              Navigator.pop(context);
              _showSuccessMessage('تمت الموافقة على الطلب بنجاح');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _successColor,
              foregroundColor: Colors.white,
            ),
            child: Text('تأكيد الموافقة'),
          ),
        ],
      ),
    );
  }

  // ========== نافذة الرفض ==========
  void _rejectRequestDialog(String requestId) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.cancel_rounded, color: _errorColor),
            SizedBox(width: 8),
            Text('رفض الطلب'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الرجاء إدخال سبب الرفض:'),
            SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'أدخل سبب الرفض...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
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
              if (reasonController.text.trim().isEmpty) {
                _showErrorMessage('الرجاء إدخال سبب الرفض');
                return;
              }
              _requestsProvider.rejectRequest(requestId, 'محرر الحسابات', reasonController.text);
              Navigator.pop(context);
              _showSuccessMessage('تم رفض الطلب بنجاح');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _errorColor,
              foregroundColor: Colors.white,
            ),
            child: Text('تأكيد الرفض'),
          ),
        ],
      ),
    );
  }

  // ========== تبويب المستخدمين ==========
  Widget _buildUsersTab(bool isDarkMode) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            // SliverAppBar للتبويبات الفرعية للمستخدمين
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              backgroundColor: isDarkMode ? _darkPrimaryColor.withOpacity(0.95) : _primaryColor.withOpacity(0.95),
              elevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: TabBar(
                  controller: _usersSubTabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.7),
                  labelStyle: TextStyle(fontWeight: FontWeight.w600),
                  tabs: [
                    Tab(
                      icon: Consumer<UsersProvider>(
                        builder: (context, provider, child) {
                          return Badge(
                            label: Text(provider.activeUsers.length.toString()),
                            backgroundColor: _successColor,
                            textColor: Colors.white,
                            smallSize: 18,
                          );
                        },
                      ),
                      text: 'نشطين',
                    ),
                    Tab(
                      icon: Consumer<UsersProvider>(
                        builder: (context, provider, child) {
                          return Badge(
                            label: Text(provider.inactiveUsers.length.toString()),
                            backgroundColor: _warningColor,
                            textColor: Colors.white,
                            smallSize: 18,
                          );
                        },
                      ),
                      text: 'غير نشطين',
                    ),
                    Tab(
                      icon: Consumer<UsersProvider>(
                        builder: (context, provider, child) {
                          return Badge(
                            label: Text(provider.suspendedUsers.length.toString()),
                            backgroundColor: _errorColor,
                            textColor: Colors.white,
                            smallSize: 18,
                          );
                        },
                      ),
                      text: 'موقوفين',
                    ),
                  ],
                ),
              ),
            ),
            
            // المحتوى
            SliverFillRemaining(
              child: TabBarView(
                controller: _usersSubTabController,
                children: [
                  _buildActiveUsersTab(isDarkMode),
                  _buildInactiveUsersTab(isDarkMode),
                  _buildSuspendedUsersTab(isDarkMode),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddUserDialog(context),
          backgroundColor: _secondaryColor,
          foregroundColor: Colors.white,
          child: Icon(Icons.person_add_rounded),
          tooltip: 'إضافة مستخدم جديد',
        ),
      ),
    );
  }

  // ========== تبويب المستخدمين النشطين ==========
  Widget _buildActiveUsersTab(bool isDarkMode) {
    return Consumer<UsersProvider>(
      builder: (context, provider, child) {
        final activeUsers = provider.activeUsers;

        if (activeUsers.isEmpty) {
          return _buildUsersEmptyState(
            Icons.people_alt_rounded,
            'لا يوجد مستخدمين نشطين',
            'جميع المستخدمين غير نشطين أو موقوفين',
            isDarkMode,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1));
            provider._loadSampleData();
          },
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: activeUsers.length,
            itemBuilder: (context, index) {
              final user = activeUsers[index];
              return _buildUserCard(user, context, provider, isDarkMode, 'active');
            },
          ),
        );
      },
    );
  }

  // ========== تبويب المستخدمين غير النشطين ==========
  Widget _buildInactiveUsersTab(bool isDarkMode) {
    return Consumer<UsersProvider>(
      builder: (context, provider, child) {
        final inactiveUsers = provider.inactiveUsers;

        if (inactiveUsers.isEmpty) {
          return _buildUsersEmptyState(
            Icons.people_outline_rounded,
            'لا يوجد مستخدمين غير نشطين',
            'جميع المستخدمين نشطين أو موقوفين',
            isDarkMode,
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: inactiveUsers.length,
          itemBuilder: (context, index) {
            final user = inactiveUsers[index];
            return _buildUserCard(user, context, provider, isDarkMode, 'inactive');
          },
        );
      },
    );
  }

  // ========== تبويب المستخدمين الموقوفين ==========
  Widget _buildSuspendedUsersTab(bool isDarkMode) {
    return Consumer<UsersProvider>(
      builder: (context, provider, child) {
        final suspendedUsers = provider.suspendedUsers;

        if (suspendedUsers.isEmpty) {
          return _buildUsersEmptyState(
            Icons.person_off_rounded,
            'لا يوجد مستخدمين موقوفين',
            'جميع المستخدمين نشطين أو غير نشطين',
            isDarkMode,
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: suspendedUsers.length,
          itemBuilder: (context, index) {
            final user = suspendedUsers[index];
            return _buildUserCard(user, context, provider, isDarkMode, 'suspended');
          },
        );
      },
    );
  }

  // ========== حالة فارغة للمستخدمين ==========
  Widget _buildUsersEmptyState(IconData icon, String title, String subtitle, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: isDarkMode ? Colors.white38 : Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: isDarkMode ? Colors.white : Colors.grey[600],
            ),
          ),
          if (subtitle.isNotEmpty) SizedBox(height: 8),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white54 : Colors.grey[500],
              ),
            ),
        ],
      ),
    );
  }

  // ========== بناء بطاقة المستخدم ==========
  Widget _buildUserCard(SystemUser user, BuildContext context, UsersProvider provider, bool isDarkMode, String currentTab) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (user.accountStatus) {
      case 'active':
        statusColor = _successColor;
        statusIcon = Icons.check_circle_rounded;
        statusText = 'نشط';
        break;
      case 'inactive':
        statusColor = _warningColor;
        statusIcon = Icons.pause_circle_rounded;
        statusText = 'غير نشط';
        break;
      case 'suspended':
        statusColor = _errorColor;
        statusIcon = Icons.block_rounded;
        statusText = 'موقوف';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.question_mark_rounded;
        statusText = 'غير معروف';
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      color: isDarkMode ? _darkCardColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.withOpacity(0.2), width: 1),
      ),
      child: InkWell(
        onTap: () => _showUserDetails(user, context, provider, isDarkMode),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
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
                child: Icon(
                  Icons.person_rounded,
                  color: statusColor,
                  size: 28,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${user.position} - ${user.department}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '@${user.username}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white54 : Colors.grey[500],
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
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
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

  // ========== عرض تفاصيل المستخدم ==========
  void _showUserDetails(SystemUser user, BuildContext context, UsersProvider provider, bool isDarkMode) {
    Color statusColor;
    String statusText;

    switch (user.accountStatus) {
      case 'active':
        statusColor = _successColor;
        statusText = 'نشط';
        break;
      case 'inactive':
        statusColor = _warningColor;
        statusText = 'غير نشط';
        break;
      case 'suspended':
        statusColor = _errorColor;
        statusText = 'موقوف';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'غير معروف';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: isDarkMode ? _darkCardColor : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: statusColor,
                        size: 32,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '@${user.username} • ${user.position}',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
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
                      _buildUserDetailSection('معلومات الحساب', Icons.account_circle_rounded, [
                        _buildUserDetailItem('اسم المستخدم', '@${user.username}', isDarkMode),
                        _buildUserDetailItem('البريد الإلكتروني', user.email, isDarkMode),
                        _buildUserDetailItem('رقم الهاتف', user.phone, isDarkMode),
                        _buildUserDetailItem('حالة الحساب', statusText, isDarkMode, valueColor: statusColor),
                        _buildUserDetailItem('تاريخ الإنشاء', _formatDateTime(user.accountCreated), isDarkMode),
                        if (user.createdBy != null)
                          _buildUserDetailItem('تم الإنشاء بواسطة', user.createdBy!, isDarkMode),
                      ]),
                      _buildUserDetailSection('معلومات الموظف', Icons.work_rounded, [
                        _buildUserDetailItem('الاسم الكامل', user.fullName, isDarkMode),
                        _buildUserDetailItem('رقم الموظف', user.employeeId, isDarkMode),
                        _buildUserDetailItem('القسم', user.department, isDarkMode),
                        _buildUserDetailItem('الوظيفة', user.position, isDarkMode),
                      ]),
                      _buildUserDetailSection('نشاط الحساب', Icons.timeline_rounded, [
                        if (user.lastLogin != null)
                          _buildUserDetailItem('آخر دخول', _formatDateTime(user.lastLogin!), isDarkMode),
                        if (user.passwordLastChanged != null)
                          _buildUserDetailItem('آخر تغيير لكلمة المرور',
                              _formatDate(user.passwordLastChanged!), isDarkMode),
                        _buildUserDetailItem('مدة وجود الحساب',
                            '${DateTime.now().difference(user.accountCreated).inDays} يوم', isDarkMode),
                      ]),
                      if (user.notes != null && user.notes!.isNotEmpty)
                        _buildUserDetailSection('ملاحظات', Icons.note_rounded, [
                          Text(
                            user.notes!,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ]),
                      SizedBox(height: 24),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _resetUserPasswordDialog(user.id, user.fullName, provider);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _secondaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: Icon(Icons.vpn_key_rounded, color: Colors.white),
                              label: Text('إعادة تعيين كلمة المرور', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _sendMessageToUser(user.email, user.fullName);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: Icon(Icons.message_rounded, color: Colors.white),
                              label: Text('إرسال رسالة', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _deleteUserDialog(user.id, user.fullName, provider);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _errorColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: Icon(Icons.delete_rounded, color: Colors.white),
                              label: Text('حذف الحساب', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ========== قسم تفاصيل المستخدم ==========
  Widget _buildUserDetailSection(String title, IconData icon, List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: _primaryColor),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  // ========== عنصر تفاصيل المستخدم ==========
  Widget _buildUserDetailItem(String label, String value, bool isDarkMode, {Color? valueColor}) {
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
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.grey[700],
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: valueColor ?? (isDarkMode ? Colors.white : Colors.black87),
                fontWeight: valueColor != null ? FontWeight.w600 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetUserPasswordDialog(String userId, String userName, UsersProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.vpn_key_rounded, color: _secondaryColor),
            SizedBox(width: 8),
            Text('إعادة تعيين كلمة المرور'),
          ],
        ),
        content: Text('سيتم إرسال رابط إعادة تعيين كلمة المرور إلى بريد $userName. هل تريد المتابعة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.resetUserPassword(userId);
              Navigator.pop(context);
              _showSuccessMessage('تم إرسال رابط إعادة التعيين بنجاح');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _secondaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('تأكيد الإرسال', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteUserDialog(String userId, String userName, UsersProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.delete_rounded, color: _errorColor),
            SizedBox(width: 8),
            Text('حذف الحساب'),
          ],
        ),
        content: Text('هل أنت متأكد من حذف حساب $userName؟ هذه العملية لا يمكن التراجع عنها.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteUser(userId);
              Navigator.pop(context);
              _showSuccessMessage('تم حذف الحساب بنجاح');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _errorColor,
              foregroundColor: Colors.white,
            ),
            child: Text('حذف الحساب', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _sendMessageToUser(String email, String userName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.message_rounded, color: Colors.blue),
            SizedBox(width: 8),
            Text('إرسال رسالة'),
          ],
        ),
        content: Text('سيتم فتح بريد إلكتروني موجه إلى $userName على العنوان: $email'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('جاري فتح البريد الإلكتروني...');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text('فتح البريد', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ========== إضافة مستخدم جديد ==========
  void _showAddUserDialog(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController employeeIdController = TextEditingController();
    final TextEditingController departmentController = TextEditingController();
    final TextEditingController positionController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.person_add_rounded, color: _primaryColor),
              SizedBox(width: 8),
              Text('إضافة مستخدم جديد'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'اسم المستخدم',
                    prefixIcon: Icon(Icons.person_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    labelText: 'الاسم الكامل',
                    prefixIcon: Icon(Icons.badge_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: employeeIdController,
                  decoration: InputDecoration(
                    labelText: 'رقم الموظف',
                    prefixIcon: Icon(Icons.numbers_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: departmentController,
                  decoration: InputDecoration(
                    labelText: 'القسم',
                    prefixIcon: Icon(Icons.business_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: positionController,
                  decoration: InputDecoration(
                    labelText: 'الوظيفة',
                    prefixIcon: Icon(Icons.work_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: Icon(Icons.email_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف',
                    prefixIcon: Icon(Icons.phone_rounded),
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
                if (usernameController.text.isEmpty ||
                    fullNameController.text.isEmpty ||
                    emailController.text.isEmpty) {
                  _showErrorMessage('الرجاء ملء الحقول المطلوبة');
                  return;
                }

                _showSuccessMessage('تم إضافة المستخدم بنجاح');
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text('إضافة مستخدم', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // ========== بحث المستخدمين ==========
  void _showUserSearchDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.search_rounded, color: _primaryColor),
            SizedBox(width: 8),
            Text('بحث عن مستخدم'),
          ],
        ),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'ابحث بالاسم، اسم المستخدم، البريد الإلكتروني...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search_rounded),
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
              _showSuccessMessage('جاري البحث عن: ${searchController.text}');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('بحث', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ========== تصفية المستخدمين ==========
  void _showUserFilterDialog(BuildContext context) {
    String? selectedDepartment;
    String? selectedStatus;

    List<String> departments = [
      'الكل',
      'قسم المحاسبة',
      'قسم الموارد البشرية',
      'قسم الصيانة',
      'قسم الأرشيف',
      'قسم المشتريات',
      'قسم المالية',
      'قسم IT',
      'قسم المشاريع'
    ];

    List<String> statuses = ['الكل', 'نشط', 'غير نشط', 'موقوف'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.filter_alt_rounded, color: _primaryColor),
                  SizedBox(width: 8),
                  Text('تصفية المستخدمين'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedDepartment ?? 'الكل',
                    decoration: InputDecoration(
                      labelText: 'القسم',
                      border: OutlineInputBorder(),
                    ),
                    items: departments.map((dept) {
                      return DropdownMenuItem(
                        value: dept,
                        child: Text(dept),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDepartment = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedStatus ?? 'الكل',
                    decoration: InputDecoration(
                      labelText: 'حالة الحساب',
                      border: OutlineInputBorder(),
                    ),
                    items: statuses.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('إلغاء'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedDepartment = null;
                      selectedStatus = null;
                    });
                  },
                  child: Text('إعادة تعيين'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showSuccessMessage('تم تطبيق التصفية');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('تطبيق التصفية', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPermissionStat(String title, String value, IconData icon, bool isDarkMode) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16,
            color: _primaryColor,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: isDarkMode ? Colors.white54 : Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildLogDetail(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupDetailSection(String title, IconData icon, List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: _primaryColor),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupDetailItem(String label, String value, bool isDarkMode) {
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
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.grey[700],
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogDetailSection(String title, IconData icon, List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: _primaryColor),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogDetailItem(String label, String value, bool isDarkMode) {
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
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.grey[700],
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== تبويب التقارير ==========
  Widget _buildReportsTab(bool isDarkMode) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            // SliverAppBar للتبويبات الفرعية للتقارير
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              backgroundColor: isDarkMode ? _darkPrimaryColor.withOpacity(0.95) : _primaryColor.withOpacity(0.95),
              elevation: 0,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: TabBar(
                  controller: _reportsSubTabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.7),
                  labelStyle: TextStyle(fontWeight: FontWeight.w600),
                  tabs: [
                    Tab(
                      icon: Icon(Icons.bar_chart_rounded),
                      text: 'إنشاء التقارير',
                    ),
                    Tab(
                      icon: Icon(Icons.inbox_rounded),
                      text: 'التقارير الواردة',
                    ),
                  ],
                ),
              ),
            ),
            
            // المحتوى
            SliverFillRemaining(
              child: TabBarView(
                controller: _reportsSubTabController,
                children: [
                  _buildCreateReportsView(isDarkMode),
                  _buildReceivedReportsView(isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateReportsView(bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDarkMode ? Colors.white24 : Colors.grey[300]!),
            ),
            color: isDarkMode ? _darkCardColor : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.filter_alt_rounded, color: _primaryColor, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'فلترة التقارير',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
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
              side: BorderSide(color: isDarkMode ? Colors.white24 : Colors.grey[300]!),
            ),
            color: isDarkMode ? _darkCardColor : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildReportOptions(isDarkMode),
            ),
          ),
          SizedBox(height: 20),
          _buildGenerateReportButton(isDarkMode),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildReceivedReportsView(bool isDarkMode) {
    final List<Map<String, dynamic>> receivedReports = [
      {
        'id': 'REP-ACC-2024-001',
        'title': 'تقرير المستخدمين الشهري',
        'sender': 'نظام المستخدمين',
        'date': DateTime.now().subtract(Duration(days: 2)),
        'type': 'شهري',
        'size': '1.2 MB',
        'status': 'مستلم',
        'fileType': 'PDF',
        'description': 'تقرير شامل عن جميع المستخدمين في النظام',
        'icon': Icons.people_alt_rounded,
        'color': _primaryColor,
      },
      {
        'id': 'REP-ACC-2024-002',
        'title': 'تقرير طلبات الحسابات',
        'sender': 'نظام الطلبات',
        'date': DateTime.now().subtract(Duration(days: 5)),
        'type': 'أسبوعي',
        'size': '850 KB',
        'status': 'غير مقروء',
        'fileType': 'PDF',
        'description': 'تقرير عن طلبات إنشاء الحسابات والموافقات',
        'icon': Icons.person_add_rounded,
        'color': _warningColor,
      },
      {
        'id': 'REP-ACC-2024-003',
        'title': 'تقرير الصلاحيات',
        'sender': 'نظام الأمان',
        'date': DateTime.now().subtract(Duration(days: 1)),
        'type': 'يومي',
        'size': '650 KB',
        'status': 'غير مقروء',
        'fileType': 'PDF',
        'description': 'تقرير عن مجموعات الصلاحيات والتعديلات',
        'icon': Icons.security_rounded,
        'color': _accentColor,
      },
      {
        'id': 'REP-ACC-2024-004',
        'title': 'تقرير سجل التعديلات',
        'sender': 'نظام المراجعة',
        'date': DateTime.now().subtract(Duration(days: 3)),
        'type': 'شهري',
        'size': '1.5 MB',
        'status': 'مستلم',
        'fileType': 'PDF',
        'description': 'سجل كامل لجميع التعديلات على الحسابات والصلاحيات',
        'icon': Icons.history_rounded,
        'color': _infoColor,
      },
      {
        'id': 'REP-ACC-2024-005',
        'title': 'تقرير أداء النظام',
        'sender': 'النظام',
        'date': DateTime.now().subtract(Duration(days: 7)),
        'type': 'أسبوعي',
        'size': '2.1 MB',
        'status': 'مستلم',
        'fileType': 'PDF',
        'description': 'تقرير أداء النظام وسرعة الاستجابة',
        'icon': Icons.speed_rounded,
        'color': _successColor,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? _darkCardColor : Colors.white,
            border: Border(bottom: BorderSide(color: isDarkMode ? Colors.white24 : Colors.grey[300]!)),
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
                      color: _primaryColor,
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
                    'غير مقروءة',
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
                    '${receivedReports.length * 1.2} MB',
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
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? _darkCardColor : Colors.white,
            border: Border(bottom: BorderSide(color: isDarkMode ? Colors.white24 : Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'بحث في التقارير...',
                    hintStyle: TextStyle(color: isDarkMode ? Colors.white54 : Colors.grey[500]),
                    prefixIcon: Icon(Icons.search_rounded, color: _primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: isDarkMode ? Colors.white24 : Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: isDarkMode ? Colors.white24 : Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: _primaryColor),
                    ),
                  ),
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                ),
              ),
              SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _primaryColor.withOpacity(0.3)),
                ),
                child: IconButton(
                  icon: Icon(Icons.filter_list_rounded, color: _primaryColor),
                  onPressed: () => _showReportFilterDialog(isDarkMode),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: receivedReports.isEmpty
              ? _buildEmptyReportsState(isDarkMode)
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: receivedReports.length,
                  itemBuilder: (context, index) {
                    final report = receivedReports[index];
                    return _buildReceivedReportCard(report, isDarkMode);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildReceivedReportCard(Map<String, dynamic> report, bool isDarkMode) {
    bool isUnread = report['status'] == 'غير مقروء';

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: isUnread ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isUnread ? report['color'].withOpacity(0.3) : (isDarkMode ? Colors.white24 : Colors.grey[200]!),
          width: isUnread ? 2 : 1,
        ),
      ),
      color: isDarkMode ? _darkCardColor : Colors.white,
      child: InkWell(
        onTap: () => _showReportDetails(report, isDarkMode),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: report['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: report['color'].withOpacity(0.3)),
                    ),
                    child: Icon(
                      report['icon'],
                      color: report['color'],
                      size: 24,
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
                                report['title'],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                                  color: isDarkMode ? Colors.white : Colors.black87,
                                ),
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
                        SizedBox(height: 4),
                        Text(
                          'من: ${report['sender']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Divider(height: 1, color: isDarkMode ? Colors.white24 : Colors.grey[200]),
              SizedBox(height: 12),
              Text(
                report['description'],
                style: TextStyle(
                  fontSize: 13,
                  color: isDarkMode ? Colors.white70 : Colors.grey[700],
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
                      color: report['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      report['type'],
                      style: TextStyle(
                        fontSize: 11,
                        color: report['color'],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _infoColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      report['fileType'],
                      style: TextStyle(
                        fontSize: 11,
                        color: _infoColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    report['size'],
                    style: TextStyle(
                      fontSize: 11,
                      color: isDarkMode ? Colors.white54 : Colors.grey[500],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 14, color: isDarkMode ? Colors.white54 : Colors.grey[500]),
                  SizedBox(width: 4),
                  Text(
                    _formatDate(report['date']),
                    style: TextStyle(
                      fontSize: 11,
                      color: isDarkMode ? Colors.white54 : Colors.grey[500],
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.access_time_rounded, size: 14, color: isDarkMode ? Colors.white54 : Colors.grey[500]),
                  SizedBox(width: 4),
                  Text(
                    '${report['date'].hour}:${report['date'].minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDarkMode ? Colors.white54 : Colors.grey[500],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _downloadReport(report, isDarkMode),
                    icon: Icon(Icons.download_rounded, size: 14, color: _successColor),
                    label: Text(
                      'تحميل',
                      style: TextStyle(color: _successColor, fontSize: 12),
                    ),
                  ),
                  SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _shareReport(report, isDarkMode),
                    icon: Icon(Icons.share_rounded, size: 18, color: _accentColor),
                    label: Text(
                      'مشاركة',
                      style: TextStyle(color: _accentColor, fontSize: 12),
                    ),
                  ),
                  if (isUnread)
                    SizedBox(width: 8),
                  if (isUnread)
                    TextButton.icon(
                      onPressed: () => _markReportAsRead(report),
                      icon: Icon(Icons.mark_email_read_rounded, size: 18, color: _primaryColor),
                      label: Text(
                        'تمييز كمقروء',
                        style: TextStyle(color: _primaryColor, fontSize: 12),
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

  Widget _buildReportTypeFilter(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع التقرير',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
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
              backgroundColor: isDarkMode ? Colors.white10 : Colors.grey[100],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : (isDarkMode ? Colors.white70 : Colors.black87),
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : (isDarkMode ? Colors.white24 : Colors.grey[300]!)),
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
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        if (_selectedReportTypeSystem == 'يومي') _buildDailyOptions(isDarkMode),
        if (_selectedReportTypeSystem == 'أسبوعي') _buildWeeklyOptions(isDarkMode),
        if (_selectedReportTypeSystem == 'شهري') _buildMonthlyOptions(isDarkMode),
      ],
    );
  }

  Widget _buildDailyOptions(bool isDarkMode) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _showMultiDatePicker,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDarkMode ? _darkCardColor : Colors.white,
            foregroundColor: _primaryColor,
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: _primaryColor),
            ),
            elevation: 0,
          ),
          icon: Icon(Icons.calendar_today_rounded, size: 20),
          label: Text('فتح التقويم واختيار التواريخ'),
        ),
        SizedBox(height: 16),
        if (_selectedDates.isNotEmpty) ...[
          Row(
            children: [
              Icon(Icons.check_circle_rounded, color: _successColor, size: 20),
              SizedBox(width: 8),
              Text(
                'التواريخ المختارة:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
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
                label: Text(
                  _formatDate(date),
                  style: TextStyle(color: _primaryColor),
                ),
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
                _buildStatItem('${_selectedDates.length}', 'يوم', Icons.today, isDarkMode),
                Container(height: 30, width: 1, color: isDarkMode ? Colors.white24 : Colors.grey[300]),
                _buildStatItem(_formatDate(_selectedDates.first), 'التاريخ الأول', Icons.calendar_today, isDarkMode),
                Container(height: 30, width: 1, color: isDarkMode ? Colors.white24 : Colors.grey[300]),
                _buildStatItem(_formatDate(_selectedDates.last), 'التاريخ الأخير', Icons.calendar_today, isDarkMode),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white10 : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDarkMode ? Colors.white24 : Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Icon(Icons.calendar_today_rounded, color: isDarkMode ? Colors.white38 : Colors.grey[400], size: 48),
                SizedBox(height: 8),
                Text(
                  'لم يتم اختيار أي تواريخ',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white54 : Colors.grey[600],
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'انقر على الزر أعلاه لفتح التقويم واختيار التواريخ',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white38 : Colors.grey[500],
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

  Widget _buildWeeklyOptions(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر الأسبوع',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
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
              backgroundColor: isDarkMode ? Colors.white10 : Colors.grey[100],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : (isDarkMode ? Colors.white70 : Colors.black87),
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : (isDarkMode ? Colors.white24 : Colors.grey[300]!)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMonthlyOptions(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر الشهر',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
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
              backgroundColor: isDarkMode ? Colors.white10 : Colors.grey[100],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : (isDarkMode ? Colors.white70 : Colors.black87),
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? _primaryColor : (isDarkMode ? Colors.white24 : Colors.grey[300]!)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGenerateReportButton(bool isDarkMode) {
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
                Icon(Icons.summarize_rounded, color: Colors.white, size: 24),
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
                      'وزارة الكهرباء - نظام محرر الحسابات',
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

  Widget _buildStatItem(String value, String label, IconData icon, bool isDarkMode) {
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
            color: isDarkMode ? Colors.white54 : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showMultiDatePicker() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'اختر التواريخ',
              style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
            ),
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
                        todayDecoration: BoxDecoration(color: _secondaryColor, shape: BoxShape.circle),
                        weekendTextStyle: TextStyle(color: _errorColor),
                        defaultTextStyle: TextStyle(color: _darkColor),
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
                            label: Text(_formatDate(date), style: TextStyle(color: _primaryColor)),
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
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
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
                    this.setState(() {});
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
      _showErrorMessage('الرجاء اختيار تواريخ أولاً');
      return;
    }

    String reportPeriod = '';

    if (_selectedReportTypeSystem == 'يومي' && _selectedDates.isNotEmpty) {
      final sortedDates = List<DateTime>.from(_selectedDates)..sort();
      if (_selectedDates.length == 1) {
        reportPeriod = _formatDate(sortedDates.first);
      } else {
        reportPeriod = '${_formatDate(sortedDates.first)} إلى ${_formatDate(sortedDates.last)}';
      }
    } else if (_selectedReportTypeSystem == 'أسبوعي') {
      reportPeriod = _selectedWeek ?? 'غير محدد';
    } else if (_selectedReportTypeSystem == 'شهري') {
      reportPeriod = _selectedMonth ?? 'غير محدد';
    }

    _showSuccessMessage('تم إنشاء التقرير ${_selectedDates.length > 0 ? 'لـ ${_selectedDates.length} يوم' : ''} بنجاح');
    _showGeneratedReport(reportPeriod);
  }

  void _showGeneratedReport(String period) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'التقرير $period',
          style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
        ),
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
              Text(
                'ملخص التقرير:',
                style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
              ),
              Text('- إجمالي المستخدمين: ${_usersProvider.users.length}', style: TextStyle(color: _darkColor)),
              Text('- المستخدمين النشطين: ${_usersProvider.activeUsers.length}', style: TextStyle(color: _darkColor)),
              Text('- المستخدمين غير النشطين: ${_usersProvider.inactiveUsers.length}', style: TextStyle(color: _darkColor)),
              Text('- المستخدمين الموقوفين: ${_usersProvider.suspendedUsers.length}', style: TextStyle(color: _darkColor)),
              Text('- طلبات الحسابات المعلقة: ${_requestsProvider.pendingRequests.length}', style: TextStyle(color: _darkColor)),
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
              _exportReport(period);
            },
            child: Text('تصدير PDF'),
          ),
        ],
      ),
    );
  }

  void _exportReport(String period) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text('جاري تصدير التقرير...')),
          ],
        ),
        backgroundColor: _primaryColor,
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      _showSuccessMessage('تم تصدير التقرير بنجاح');
    });
  }

  void _showReportFilterDialog(bool isDarkMode) {
    String? selectedType;
    String? selectedPeriod;

    List<String> types = ['الكل', 'PDF', 'Excel', 'Word'];
    List<String> periods = ['الكل', 'اليوم', 'الأسبوع', 'الشهر'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: isDarkMode ? _darkCardColor : Colors.white,
              title: Row(
                children: [
                  Icon(Icons.filter_alt_rounded, color: _primaryColor),
                  SizedBox(width: 8),
                  Text(
                    'تصفية التقارير',
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedType ?? 'الكل',
                    decoration: InputDecoration(
                      labelText: 'نوع الملف',
                      labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey[600]),
                      border: OutlineInputBorder(),
                    ),
                    dropdownColor: isDarkMode ? _darkCardColor : Colors.white,
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                    items: types.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedPeriod ?? 'الكل',
                    decoration: InputDecoration(
                      labelText: 'الفترة',
                      labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey[600]),
                      border: OutlineInputBorder(),
                    ),
                    dropdownColor: isDarkMode ? _darkCardColor : Colors.white,
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                    items: periods.map((period) {
                      return DropdownMenuItem(
                        value: period,
                        child: Text(period),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPeriod = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('إلغاء'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedType = null;
                      selectedPeriod = null;
                    });
                  },
                  child: Text('إعادة تعيين'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showSuccessMessage('تم تطبيق التصفية');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('تطبيق'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showReportDetails(Map<String, dynamic> report, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: isDarkMode ? _darkCardColor : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: report['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: report['color'].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        report['icon'],
                        color: report['color'],
                        size: 32,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'ID: ${report['id']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: isDarkMode ? Colors.white : Colors.grey[600]),
                      onPressed: () => Navigator.pop(context),
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
                      _buildReportDetailSection('معلومات التقرير', Icons.info_rounded, [
                        _buildReportDetailItem('المرسل', report['sender'], isDarkMode),
                        _buildReportDetailItem('نوع التقرير', report['type'], isDarkMode),
                        _buildReportDetailItem('صيغة الملف', report['fileType'], isDarkMode),
                        _buildReportDetailItem('حجم الملف', report['size'], isDarkMode),
                        _buildReportDetailItem('تاريخ الإرسال', _formatDateTime(report['date']), isDarkMode),
                        _buildReportDetailItem('الحالة', report['status'], isDarkMode,
                            valueColor: report['status'] == 'غير مقروء' ? _warningColor : _successColor),
                      ]),
                      _buildReportDetailSection('وصف التقرير', Icons.description_rounded, [
                        Text(
                          report['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.white70 : Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ]),
                      _buildReportDetailSection('ملخص التقرير', Icons.summarize_rounded, [
                        Text(
                          'يحتوي هذا التقرير على إحصائيات وتحليلات شاملة حول المستخدمين والصلاحيات في النظام.',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDarkMode ? Colors.white70 : Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• إجمالي المستخدمين: ${_usersProvider.users.length}',
                          style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey[700]),
                        ),
                        Text(
                          '• المستخدمين النشطين: ${_usersProvider.activeUsers.length}',
                          style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey[700]),
                        ),
                        Text(
                          '• الطلبات المعلقة: ${_requestsProvider.pendingRequests.length}',
                          style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey[700]),
                        ),
                      ]),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _downloadReport(report, isDarkMode);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _successColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: Icon(Icons.download_rounded, color: Colors.white),
                              label: Text('تحميل التقرير', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _shareReport(report, isDarkMode);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _accentColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: Icon(Icons.share_rounded, color: Colors.white),
                              label: Text('مشاركة', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportDetailSection(String title, IconData icon, List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: _primaryColor),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportDetailItem(String label, String value, bool isDarkMode, {Color? valueColor}) {
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
                fontSize: 13,
                color: isDarkMode ? Colors.white70 : Colors.grey[700],
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: valueColor ?? (isDarkMode ? Colors.white : Colors.black87),
                fontWeight: valueColor != null ? FontWeight.w600 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _downloadReport(Map<String, dynamic> report, bool isDarkMode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.download_rounded, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text('جاري تحميل التقرير: ${report['title']}')),
          ],
        ),
        backgroundColor: _successColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareReport(Map<String, dynamic> report, bool isDarkMode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.share_rounded, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text('جاري مشاركة التقرير: ${report['title']}')),
          ],
        ),
        backgroundColor: _accentColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _markReportAsRead(Map<String, dynamic> report) {
    setState(() {
      report['status'] = 'مستلم';
    });
    _showSuccessMessage('تم تمييز التقرير كمقروء');
  }

  Widget _buildEmptyReportsState(bool isDarkMode) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 80,
              color: isDarkMode ? Colors.white38 : Colors.grey[300],
            ),
            SizedBox(height: 16),
            Text(
              'لا توجد تقارير واردة',
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'سيتم عرض التقارير هنا عند استلامها',
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

  // ========== القائمة المنسدلة الرئيسية ==========
  Widget _buildAccountEditorDrawer(BuildContext context, bool isDarkMode) {
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
                      Icons.admin_panel_settings_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "محرر الحسابات",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "مراجع حسابات - قسم المحاسبة",
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
                      "الإدارة المركزية",
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
                    _buildAccountEditorMenuItem(
                      icon: Icons.settings_rounded,
                      title: 'إعدادات النظام',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(
                              primaryColor: _primaryColor,
                              secondaryColor: _secondaryColor,
                              accentColor: _accentColor,
                              successColor: _successColor,
                              warningColor: _warningColor,
                              errorColor: _errorColor,
                            ),
                          ),
                        );
                      },
                      isDarkMode: isDarkMode,
                    ),
                    _buildAccountEditorMenuItem(
                      icon: Icons.help_rounded,
                      title: 'المساعدة والدعم',
                      onTap: () {
                        Navigator.pop(context);
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
                      },
                      isDarkMode: isDarkMode,
                    ),
                    SizedBox(height: 30),
                    _buildAccountEditorMenuItem(
                      icon: Icons.logout_rounded,
                      title: 'تسجيل الخروج',
                      onTap: () {
                        _showLogoutConfirmation();
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
                            'وزارة الكهرباء - نظام محرر الحسابات',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.grey[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'الإصدار 2.0.0',
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

  Widget _buildAccountEditorMenuItem({
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

  void _showLogoutConfirmation() {
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
              _performLogout();
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

  void _performLogout() {
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

    Navigator.pushReplacementNamed(context, EsigninScreen.screenroot);
  }

  // ========== دوال مساعدة ==========
  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }

  String _formatDateTime(DateTime date) {
    return '${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
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
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_rounded, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: _errorColor,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
class SettingsScreen extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;

  const SettingsScreen({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.successColor,
    required this.warningColor,
    required this.errorColor,
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
    final isDarkMode = themeProvider.isDarkMode;
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
              (bool value) => setState(() => _soundEnabled = value),isDarkMode,
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
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
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
                  colors: [Color(0xFFF5F5F5), Color(0xFFE8F5E8)],
                ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContactCard(context, isDarkMode),

              SizedBox(height: 24),

              _buildEditorGuidelinesCard(isDarkMode),

               SizedBox(height: 16),

              _buildSectionTitle('الأسئلة الشائعة', isDarkMode),
              ..._buildFAQItems(isDarkMode),

              SizedBox(height: 24),
              _buildSectionTitle('معلومات التطبيق', isDarkMode),
              _buildAppInfoCard(isDarkMode),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
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
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildContactItem(Icons.phone_rounded, 'رقم الدعم الفني', '07725252103', true, context, isDarkMode),
          _buildContactItem(Icons.phone_rounded, 'رقم الطوارئ', '07862268894', true, context, isDarkMode),
          _buildContactItem(Icons.email_rounded, 'البريد الإلكتروني', 'supervisor@electric.gov.iq', false, context, isDarkMode),
          _buildContactItem(Icons.access_time_rounded, 'ساعات العمل', '8:00 ص - 4:00 م', false, context, isDarkMode),
          _buildContactItem(Icons.location_on_rounded, 'العنوان', 'بغداد - وزارة الكهرباء', false, context, isDarkMode),
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

  Widget _buildContactItem(IconData icon, String title, String value, bool isPhone, BuildContext context, bool isDarkMode) {
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
                color: isDarkMode ? Colors.white : Colors.black87,
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
                  color: isPhone ? primaryColor : (isDarkMode ? Colors.white70 : Colors.grey[600]),
                  decoration: isPhone ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12, top: 8),
    child: Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
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

  List<Widget> _buildFAQItems(bool isDarkMode) {
  List<Map<String, String>> faqs = [
    {
      'question': 'كيف يمكنني إنشاء حساب جديد للمستخدم؟',
      'answer': 'انتقل إلى تبويب "طلبات الحسابات" → اختر "إنشاء حساب جديد" → املأ بيانات المستخدم → ارسل الطلب للموافقة'
    },
    {
      'question': 'ما هي الخطوات لمراجعة طلبات إنشاء الحسابات؟',
      'answer': 'اذهب إلى تبويب "طلبات الحسابات" → استعرض الطلبات الجديدة → انقر على الطلب لمراجعته → اقرأ البيانات → إما الموافقة أو الرفض مع ذكر السبب'
    },
    {
      'question': 'كيف أقوم بتعديل صلاحيات مستخدم موجود؟',
      'answer': 'انتقل إلى تبويب "المستخدمين" → ابحث عن المستخدم → انقر على "تعديل الصلاحيات" → عدل الصلاحيات المطلوبة → احفظ التغييرات'
    },
    {
      'question': 'ما هي أنواع الصلاحيات المتاحة في النظام؟',
      'answer': '1. صلاحيات القراءة فقط\n2. صلاحيات الإضافة\n3. صلاحيات التعديل\n4. صلاحيات الحذف\n5. صلاحيات الإشراف\n6. صلاحيات التقارير'
    },
    {
      'question': 'كيف أطلع على تقرير نشاط المستخدمين؟',
      'answer': 'انتقل إلى تبويب "التقارير" → اختر "نشاط المستخدمين" → حدد الفترة الزمنية → اضغط على "إنشاء التقرير"'
    },
    {
      'question': 'ماذا أفعل إذا نسى مستخدم كلمة المرور؟',
      'answer': 'اذهب إلى تبويب "المستخدمين" → ابحث عن المستخدم → انقر على "إعادة تعيين كلمة المرور" → سيتم إرسال رابط إعادة التعيين إلى بريده الإلكتروني'
    },
    {
      'question': 'كيف أعطل حساب مستخدم مؤقتاً؟',
      'answer': 'انتقل إلى تبويب "المستخدمين" → ابحث عن المستخدم → انقر على "تعطيل الحساب" → حدد المدة → اذكر السبب → احفظ التغييرات'
    },
    {
      'question': 'ما هي إجراءات الأمان المتبعة في إنشاء الحسابات؟',
      'answer': '1. التحقق من الهوية\n2. التوقيع الإلكتروني\n3. تسجيل السجل الزمني\n4. إرسال إشعارات\n5. التوثيق الثنائي للعمليات المهمة'
    },
    {
      'question': 'كيف أقوم بتصدير بيانات المستخدمين؟',
      'answer': 'اذهب إلى تبويب "التقارير" → اختر "تصدير البيانات" → حدد نوع التصدير (Excel, PDF, CSV) → اضغط على "تصدير"'
    },
    {
      'question': 'ما هي الفترة الزمنية لحفظ سجلات التعديلات؟',
      'answer': 'يتم حفظ سجلات التعديلات لمدة 5 سنوات وفقاً لسياسات أمان البيانات المعتمدة في الوزارة'
    },
  ];

  return faqs.map((faq) {
    return _buildExpandableItem(faq['question']!, faq['answer']!, isDarkMode);
  }).toList();
}

Widget _buildEditorGuidelinesCard(bool isDarkMode) {
  return Container(
    margin: EdgeInsets.only(bottom: 16),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.security_rounded, color: primaryColor, size: 22),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'إرشادات أمنية لمحرر الحسابات',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildGuidelineItem('التحقق من هوية المستخدم قبل إنشاء الحساب', isDarkMode),
        _buildGuidelineItem('تحديد الصلاحيات وفقاً لمبدأ أقل امتياز', isDarkMode),
        _buildGuidelineItem('تسجيل كافة التعديلات في سجل المراجعة', isDarkMode),
        _buildGuidelineItem('عدم مشاركة بيانات الدخول مع أي شخص', isDarkMode),
        _buildGuidelineItem('تحديث كلمة المرور كل 90 يوم', isDarkMode),
      ],
    ),
  );
}

Widget _buildGuidelineItem(String text, bool isDarkMode) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_rounded, color: successColor, size: 16),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );
}
  
  Widget _buildExpandableItem(String question, String answer, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
      ),
      child: ExpansionTile(
        leading: Icon(Icons.help_outline_rounded, color: primaryColor),
        title: Text(
          question,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }  
  
  Widget _buildAppInfoCard(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
      ),
      child: Column(
        children: [
          _buildInfoRow('الإصدار', '1.0.0', isDarkMode),
          _buildInfoRow('تاريخ البناء', '2024-03-20', isDarkMode),
          _buildInfoRow('المطور', 'وزارة الكهرباء', isDarkMode),
          _buildInfoRow('رقم الترخيص', 'MOE-SUP-2024-002', isDarkMode),
          _buildInfoRow('آخر تحديث', '2024-03-15', isDarkMode),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, bool isDarkMode) {
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
// شاشة الاشعارات المعاد تصميمها (بتصميم المحاسب)
class NotificationsScreen extends StatefulWidget {
  static const String routeName = '/notifications';

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  // ألوان المحاسب
  late final Color _primaryColor;
  late final Color _secondaryColor;
  late final Color _successColor;
  late final Color _warningColor;
  late final Color _errorColor;
  late final Color _accentColor;
  late final Color _backgroundColor;
  late final Color _textColor;
  late final Color _textSecondaryColor;
  late final Color _borderColor;

  late TabController _tabController;
  int _selectedTab = 0;
  final List<String> _tabs = ['الكل', 'الوسائل', 'الطلبات', 'الفواتير'];
  
  // قائمة الإشعارات - سيتم تهيئتها لاحقاً
  late List<Map<String, dynamic>> _allNotifications;

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedTab == 0) { // الكل
      return _allNotifications;
    }
    return _allNotifications.where((notification) => notification['tab'] == _selectedTab).toList();
  }

  int get _unreadCount {
    return _allNotifications.where((notification) => !notification['read']).length;
  }

  @override
  void initState() {
    super.initState();
    
    // تهيئة الألوان في initState
    _initializeColors();
    
    // تهيئة قائمة الإشعارات بعد الألوان
    _initializeNotifications();
    
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
  }
  
  void _initializeColors() {
    _primaryColor = Color(0xFF2E7D32);
    _secondaryColor = Color(0xFFD4AF37);
    _successColor = Color(0xFF2E7D32);
    _warningColor = Color(0xFFF57C00);
    _errorColor = Color(0xFFD32F2F);
    _accentColor = Color(0xFF8D6E63); // إضافة اللون المفقود
    _backgroundColor = Color(0xFFF5F5F5);
    _textColor = Color(0xFF212121);
    _textSecondaryColor = Color(0xFF757575);
    _borderColor = Color(0xFFE0E0E0);
  }
  
  void _initializeNotifications() {
    _allNotifications = [
      // الوسائل (Tab 1)
      {
        'id': '1',
        'type': 'message',
        'icon': Icons.message_rounded,
        'iconColor': Color(0xFF2196F3), // أزرق
        'title': 'رسالة جديدة',
        'description': 'لديك رسالة من الإدارة بخصوص تحديث نظام الفواتير',
        'time': 'منذ 3 ساعات',
        'read': true,
        'tab': 1,
      },
      {
        'id': '2',
        'type': 'system',
        'icon': Icons.system_update_rounded,
        'iconColor': Color(0xFF9C27B0), // بنفسجي
        'title': 'تحديث النظام',
        'description': 'تم تحديث نظام الفواتير إلى الإصدار 2.1.0',
        'time': 'منذ يوم',
        'read': true,
        'tab': 1,
      },
      {
        'id': '3',
        'type': 'announcement',
        'icon': Icons.campaign_rounded,
        'iconColor': Color(0xFFFF9800), // برتقالي
        'title': 'إعلان هام',
        'description': 'اجتماع طارئ لموظفي قسم المحاسبة يوم الخميس القادم',
        'time': 'منذ يومين',
        'read': true,
        'tab': 1,
      },
      // الطلبات (Tab 2)
      {
        'id': '4',
        'type': 'payment',
        'icon': Icons.payment_rounded,
        'iconColor': _successColor, // الآن يمكن استخدامه بأمان
        'title': 'طلب دفع جديد',
        'description': 'طلب دفع جديد من المواطن أحمد محمد بقيمة 185,750 دينار',
        'time': 'منذ 5 دقائق',
        'read': false,
        'tab': 2,
      },
      {
        'id': '5',
        'type': 'complaint',
        'icon': Icons.feedback_rounded,
        'iconColor': _warningColor,
        'title': 'شكوى جديدة',
        'description': 'شكوى من المواطن فاطمة علي بخصوص فاتورة الكهرباء',
        'time': 'منذ ساعة',
        'read': false,
        'tab': 2,
      },
      {
        'id': '6',
        'type': 'service',
        'icon': Icons.build_rounded,
        'iconColor': _accentColor,
        'title': 'طلب خدمة جديد',
        'description': 'طلب تركيب عداد جديد من المواطن خالد إبراهيم',
        'time': 'منذ ساعتين',
        'read': false,
        'tab': 2,
      },
      // الفواتير (Tab 3)
      {
        'id': '7',
        'type': 'bill',
        'icon': Icons.receipt_rounded,
        'iconColor': _primaryColor,
        'title': 'فاتورة جديدة',
        'description': 'تم إنشاء فاتورة جديدة للمواطن سارة عبدالله بقيمة 150,000 دينار',
        'time': 'منذ 10 دقائق',
        'read': false,
        'tab': 3,
      },
      {
        'id': '8',
        'type': 'overdue',
        'icon': Icons.warning_rounded,
        'iconColor': _errorColor,
        'title': 'فاتورة متأخرة',
        'description': 'فاتورة رقم INV-2024-002 للمواطن فاطنة علي متأخرة الدفع',
        'time': 'منذ 3 أيام',
        'read': true,
        'tab': 3,
      },
      {
        'id': '9',
        'type': 'payment_success',
        'icon': Icons.check_circle_rounded,
        'iconColor': _successColor,
        'title': 'دفع ناجح',
        'description': 'تم دفع فاتورة رقم INV-2024-003 بنجاح من المواطن خالد إبراهيم',
        'time': 'منذ 30 دقيقة',
        'read': true,
        'tab': 3,
      },
      {
        'id': '10',
        'type': 'reading',
        'icon': Icons.speed_rounded,
        'iconColor': _secondaryColor,
        'title': 'قراءة عداد جديدة',
        'description': 'تم تسجيل قراءة عداد جديدة للمواطن أحمد محمد',
        'time': 'منذ ساعة',
        'read': true,
        'tab': 3,
      },
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _allNotifications.indexWhere((n) => n['id'] == id);
      if (index != -1) {
        _allNotifications[index]['read'] = true;
      }
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      _allNotifications.removeWhere((n) => n['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حذف الإشعار'),
        backgroundColor: _successColor,
        duration: Duration(seconds: 2),
      ),
    );
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _secondaryColor,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          labelStyle: TextStyle(fontWeight: FontWeight.w600),
          tabs: _tabs.map((tabName) => Tab(text: tabName)).toList(),
        ),
      ),
      body: Column(
        children: [
          // شريط الإحصائيات
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'الإجمالي',
                  _filteredNotifications.length.toString(),
                  Icons.notifications_rounded,
                  _primaryColor,
                ),
                Container(
                  height: 30,
                  width: 1,
                  color: _borderColor,
                ),
                _buildStatItem(
                  'غير مقروء',
                  _filteredNotifications.where((n) => !n['read']).length.toString(),
                  Icons.mark_chat_unread_rounded,
                  _warningColor,
                ),
              ],
            ),
          ),

          // قائمة الإشعارات
          Expanded(
            child: _filteredNotifications.isEmpty
                ? _buildEmptyState()
                : TabBarView(
                    controller: _tabController,
                    children: _tabs.map((tab) {
                      return _buildNotificationsList(_filteredNotifications);
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationsList(List<Map<String, dynamic>> notifications) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 8, bottom: 16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildDismissibleNotificationCard(notification);
      },
    );
  }

  Widget _buildDismissibleNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['read'] as bool;
    
    return Dismissible(
      key: Key(notification['id']),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: _errorColor,
        child: Icon(Icons.delete_rounded, color: Colors.white),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        color: !isRead ? _warningColor : Colors.grey,
        child: Icon(
          !isRead ? Icons.mark_email_read_rounded : Icons.delete_rounded,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // السحب لليمين: حذف
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('تأكيد الحذف'),
                content: Text('هل أنت متأكد من حذف هذا الإشعار؟'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('إلغاء'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('حذف'),
                  ),
                ],
              );
            },
          );
        } else if (direction == DismissDirection.endToStart) {
          // السحب لليسار: تعيين كمقروء (إذا لم يكن مقروءاً) أو حذف (إذا كان مقروءاً)
          if (!isRead) {
            _markAsRead(notification['id']);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم تعيين الإشعار كمقروء'),
                backgroundColor: _warningColor,
                duration: Duration(seconds: 2),
              ),
            );
            return false; // لا نحذف، فقط نعيد تحميل الـUI
          } else {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('تأكيد الحذف'),
                  content: Text('هل أنت متأكد من حذف هذا الإشعار؟'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('حذف'),
                    ),
                  ],
                );
              },
            );
          }
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          _deleteNotification(notification['id']);
        } else if (direction == DismissDirection.endToStart && isRead) {
          _deleteNotification(notification['id']);
        }
      },
      child: _buildNotificationCard(notification),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['read'] as bool;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : _primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRead ? _borderColor : _primaryColor.withOpacity(0.2),
          width: isRead ? 1 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: (notification['iconColor'] as Color).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            notification['icon'],
            color: notification['iconColor'],
            size: 24,
          ),
        ),
        title: Text(
          notification['title'],
          style: TextStyle(
            fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
            fontSize: 16,
            color: _textColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              notification['description'],
              style: TextStyle(
                fontSize: 13,
                color: _textSecondaryColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: _textSecondaryColor.withOpacity(0.7),
                ),
                SizedBox(width: 4),
                Text(
                  notification['time'],
                  style: TextStyle(
                    fontSize: 11,
                    color: _textSecondaryColor.withOpacity(0.7),
                  ),
                ),
                if (!isRead) ...[
                  SizedBox(width: 12),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _warningColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded, color: _textSecondaryColor),
          onSelected: (value) {
            if (value == 'read' && !isRead) {
              _markAsRead(notification['id']);
            } else if (value == 'delete') {
              _deleteNotification(notification['id']);
            }
          },
          itemBuilder: (BuildContext context) => [
            if (!isRead)
              PopupMenuItem<String>(
                value: 'read',
                child: Row(
                  children: [
                    Icon(Icons.mark_email_read_rounded, size: 18, color: _warningColor),
                    SizedBox(width: 8),
                    Text('تعيين كمقروء'),
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_rounded,
            size: 80,
            color: _textSecondaryColor.withOpacity(0.3),
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _textSecondaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'ليس لديك أي إشعارات في هذا التبويب',
            style: TextStyle(
              fontSize: 14,
              color: _textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}