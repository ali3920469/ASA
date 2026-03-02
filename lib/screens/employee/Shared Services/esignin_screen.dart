import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

// شاشات قسم الكهرباء
import 'package:mang_mu/screens/employee/employee_electricity/billing_accountant_electrity.dart';
import 'package:mang_mu/screens/employee/employee_electricity/maintenance_technician_electrity.dart';
import 'package:mang_mu/screens/employee/employee_electricity/system_supervisor_electrity.dart';
import 'package:mang_mu/screens/employee/employee_electricity/reporting_officer_electricity.dart';

// شاشات قسم المياه
import 'package:mang_mu/screens/employee/employee_water/reporting_officer_water.dart';
import 'package:mang_mu/screens/employee/employee_water/water_billing_accountant.dart';
import 'package:mang_mu/screens/employee/employee_water/water_maintenance_technician.dart';
import 'package:mang_mu/screens/employee/employee_water/water_supervisor.dart';

// شاشات قسم النفايات
import 'package:mang_mu/screens/employee/employee_wast/reporting_officer_wast.dart';
import 'package:mang_mu/screens/employee/employee_wast/system_supervisor_waste.dart';
import 'package:mang_mu/screens/employee/employee_wast/waste_billing_officer.dart';
import 'package:mang_mu/screens/employee/employee_wast/waste_cleaning_worker.dart';
import 'package:mang_mu/screens/employee/employee_wast/waste_scheduler.dart';

// الشاشات الجديدة للأقسام المضافة
import 'package:mang_mu/screens/employee/Shared Services/account_auditor.dart';
import 'package:mang_mu/screens/employee/Shared Services/app_developer.dart';
import 'package:mang_mu/screens/employee/Shared Services/event_employee.dart';
import 'package:mang_mu/screens/employee/Shared Services/system_administrator.dart';
import 'package:mang_mu/screens/employee/Shared Services/offers_gifts_specialist.dart';
class EsigninScreen extends StatefulWidget {
  static const String screenroot = 'esignin_screen';

  const EsigninScreen({super.key});

  @override
  State<EsigninScreen> createState() => _EsigninScreenState();
}

class _EsigninScreenState extends State<EsigninScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _selectedSection;
  String? _selectedSpecialization;

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  int _currentBackground = 0;
  final List<String> _backgrounds = [
    'assets/bg1.svg',
    'assets/bg2.svg',
    'assets/bg3.svg',
  ];

  // قائمة الأقسام الرئيسية (تمت إضافة أقسام جديدة)
  final List<String> _sections = ['كهرباء', 'ماء', 'نفايات', 'المالية', 'التقنية'];

  // قائمة التخصصات لكل قسم (تمت إضافة التخصصات الجديدة)
final Map<String, List<String>> _specializations = {
  'كهرباء': [
    'محاسب الفواتير',
    'فني الصيانة',
    'مسؤول الإبلاغ',
    'مسؤول محطة الكهرباء',
  ],
  'ماء': [
    'مسؤول الإبلاغ عن المياه',
    'محاسب الفواتير',
    'فني الصيانة',
    'مسؤول محطة الماء',
  ],
  'نفايات': [
    'مسؤول الابلاغ',
    'مشرف النظام',
    'موظف الفواتير',
    'عامل النظافة',
    'جدولة النفايات',
  ],
  'المالية': [
    'محرر الحسابات',
  ],
  'التقنية': [
    'مطور البرنامج',
    'موظف الأحداث',
    'مدير النظام',
    'أخصائي تقديم الهدايا',  // تم إضافة هذا التخصص الجديد
  ],
};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuint),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          _currentBackground = (_currentBackground + 1) % _backgrounds.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 1), () {
        setState(() => _isLoading = false);

        // التحقق من القسم والتخصص والتوجيه للشاشات المناسبة
        print('تم تسجيل الدخول كـ: $_selectedSection - $_selectedSpecialization');
        
        // توجيه للشاشات الجديدة
        if (_selectedSection == 'المالية' && _selectedSpecialization == 'محرر الحسابات') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AccountAuditorHome()),
          );
        } else if (_selectedSection == 'التقنية' && _selectedSpecialization == 'مطور البرنامج') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AppDeveloper()),
          );
        } else if (_selectedSection == 'التقنية' && _selectedSpecialization == 'موظف الأحداث') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const EventEmployee()),
          );
        } else if (_selectedSection == 'التقنية' && _selectedSpecialization == 'مدير النظام') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SystemAdministrator()),
          );
        }else if (_selectedSection == 'التقنية' && _selectedSpecialization == 'أخصائي تقديم الهدايا') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OffersGiftsSpecialist()), // تأكد من إنشاء هذه الشاشة
        );
      }

        else if (_selectedSection == 'كهرباء' && _selectedSpecialization == 'محاسب الفواتير') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BillingAccountantScreen()),
          );
        } else if (_selectedSection == 'كهرباء' && _selectedSpecialization == 'فني الصيانة') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MaintenanceTechnicianScreen()),
          );
        } else if (_selectedSection == 'كهرباء' && _selectedSpecialization == 'مسؤول محطة الكهرباء') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SystemSupervisorScreen()),
          );
        } else if (_selectedSection == 'كهرباء' && _selectedSpecialization == 'مسؤول الإبلاغ') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  ReportingOfficerElectricityScreen()),
          );
        } else if (_selectedSection == 'ماء' && _selectedSpecialization == 'محاسب الفواتير') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WaterBillingAccountantScreen()),
          );
        } else if (_selectedSection == 'ماء' && _selectedSpecialization == 'فني الصيانة') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WaterMaintenanceTechnicianScreen()),
          );
        } else if (_selectedSection == 'ماء' && _selectedSpecialization == 'مسؤول محطة الماء') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WaterSupervisorScreen()),
          );
        } else if (_selectedSection == 'ماء' && _selectedSpecialization == 'مسؤول الإبلاغ عن المياه') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  ReportingOfficerWaterScreen()),
          );
        }else if (_selectedSection == 'نفايات' && _selectedSpecialization == 'مسؤول الابلاغ') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  ReportingOfficerWasteScreen()),
          );
        } else if (_selectedSection == 'نفايات' && _selectedSpecialization == 'مشرف النظام') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SystemSupervisorWasteScreen()),
          );
        } else if (_selectedSection == 'نفايات' && _selectedSpecialization == 'موظف الفواتير') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WasteBillingOfficerScreen()),
          );
        } else if (_selectedSection == 'نفايات' && _selectedSpecialization == 'عامل النظافة') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WasteCleaningWorkerScreen()),
          );
        }else if (_selectedSection == 'نفايات' && _selectedSpecialization == 'جدولة النفايات') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WasteSchedulerApp()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // الخلفية المتدرجة مع SVG
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Container(
              key: ValueKey(_currentBackground),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.5,
                  colors: isDarkMode
                      ? [const Color(0xFF0A0E21), const Color(0xFF1D1E33)]
                      : [const Color(0xFFF5F7FA), const Color(0xFFE4E7EB)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SvgPicture.asset(
                      _backgrounds[_currentBackground],
                      fit: BoxFit.cover,
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.03)
                          : Colors.black.withOpacity(0.03),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          theme.scaffoldBackgroundColor.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // تأثير ضبابي
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(color: Colors.transparent),
          ),

          // المحتوى الرئيسي
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width > 800 ? size.width * 0.15 : 24,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.only(bottom: 30),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 8, 93, 99),
                                    Color.fromARGB(255, 1, 17, 27),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDarkMode
                                        ? const Color.fromARGB(255, 185, 37, 37).withOpacity(0.4)
                                        : Colors.grey.withOpacity(0.2),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 20),
                                  ),
                                ],
                                border: Border.all(
                                  color: isDarkMode
                                      ? Colors.blueGrey.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Image.asset(
                                      'images/lbbb.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 300),
                                    style: theme.textTheme.headlineMedium!.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Tajawal',
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: theme.primaryColor.withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Text('تسجيل دخول الموظفين'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // حقل اختيار القسم
                                _buildSectionDropdown(),
                                const SizedBox(height: 20),

                                // حقل اختيار التخصص (يظهر فقط عند اختيار قسم)
                                if (_selectedSection != null)
                                  _buildSpecializationDropdown(),
                                if (_selectedSection != null)
                                  const SizedBox(height: 20),

                                // حقل البريد الإلكتروني
                                _buildTextField(
                                  controller: _emailController,
                                  hintText: 'البريد الإلكتروني',
                                  icon: Icons.email,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال البريد الإلكتروني';
                                    }
                                    if (!value.contains('@')) {
                                      return 'بريد إلكتروني غير صالح';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                // حقل كلمة المرور
                                _buildTextField(
                                  controller: _passwordController,
                                  hintText: 'كلمة المرور',
                                  icon: Icons.lock,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال كلمة المرور';
                                    }
                                    if (value.length < 6) {
                                      return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),

                                // رابط نسيت كلمة المرور
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'نسيت كلمة المرور؟',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),

                                // زر تسجيل الدخول
                                _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : _buildEnhancedAuthButton(
                                        context,
                                        icon: Icons.login,
                                        label: 'تسجيل الدخول',
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 17, 126, 117),
                                            Color.fromARGB(255, 16, 78, 88),
                                          ],
                                        ),
                                        onPressed: _signIn,
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
            ),
          ),

          // تذييل الصفحة
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      theme.scaffoldBackgroundColor.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'بلدية المدينة الذكية © ${DateTime.now().year}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 14,
                        color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedSection,
        decoration: InputDecoration(
          hintText: 'اختر القسم',
          hintStyle: const TextStyle(
            color: Colors.white70,
            fontFamily: 'Tajawal',
          ),
          prefixIcon: const Icon(Icons.category, color: Colors.white70),
          filled: true,
          fillColor: const Color.fromARGB(255, 17, 126, 117).withOpacity(0.7),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
        ),
        style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
        dropdownColor: const Color.fromARGB(255, 17, 126, 117),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        items: _sections.map((String section) {
          return DropdownMenuItem<String>(value: section, child: Text(section));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedSection = newValue;
            _selectedSpecialization = null;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'الرجاء اختيار القسم';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSpecializationDropdown() {
    final specializations = _specializations[_selectedSection] ?? [];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedSpecialization,
        decoration: InputDecoration(
          hintText: 'اختر التخصص',
          hintStyle: const TextStyle(
            color: Colors.white70,
            fontFamily: 'Tajawal',
          ),
          prefixIcon: const Icon(Icons.work, color: Colors.white70),
          filled: true,
          fillColor: const Color.fromARGB(255, 17, 126, 117).withOpacity(0.7),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
        ),
        style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
        dropdownColor: const Color.fromARGB(255, 17, 126, 117),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        items: specializations.map((String specialization) {
          return DropdownMenuItem<String>(
            value: specialization,
            child: Text(specialization),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedSpecialization = newValue;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'الرجاء اختيار التخصص';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.right,
        style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white70,
            fontFamily: 'Tajawal',
          ),
          prefixIcon: Icon(icon, color: Colors.white70),
          filled: true,
          fillColor: const Color.fromARGB(255, 17, 126, 117).withOpacity(0.7),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedAuthButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: gradient,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 26),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Tajawal',
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
