import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mang_mu/screens/citizen/Shared%20Services%20Citizen/regesyer_screen.dart';
import 'dart:ui'; // تغيير الاستيراد ليكون باسم ui
import 'package:mang_mu/screens/citizen/Shared Services Citizen/user_main_screen.dart';

class SigninScreen extends StatefulWidget {
  static const String screenroot = 'signin_screen';
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;
  bool _isHovering = false;
  int _currentBackground = 0;
  final List<String> _backgrounds = [
    'assets/bg1.svg',
    'assets/bg2.svg',
    'assets/bg3.svg',
  ];

  // الألوان مطابقة تماماً للموظفين
  final Color _gradientStart = const Color.fromARGB(255, 8, 93, 99);
  final Color _gradientEnd = const Color.fromARGB(255, 1, 17, 27);
  final Color _buttonGradientStart = const Color.fromARGB(255, 17, 126, 117);
  final Color _buttonGradientEnd = const Color.fromARGB(255, 16, 78, 88);

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

    // تغيير الخلفية كل 8 ثواني
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

  // دالة تسجيل الدخول
  // دالة تسجيل الدخول
  // دالة تسجيل الدخول
  void _signIn() {
    if (_formKey.currentState!.validate()) {
      _performSignIn();
    }
  }

  Future<void> _performSignIn() async {
    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final AuthResponse response = await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: password);

 if (response.user != null && mounted) {
  // التحقق من وجود المستخدم في جدول profiles داخل schema shared
  final profileResponse = await Supabase.instance.client
      .schema('shared')  // أضف هذا السطر
      .from('profiles')
      .select()
      .eq('id', response.user!.id)
      .maybeSingle();

  if (profileResponse != null) {
    // المستخدم موجود في قاعدة البيانات
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const UserMainScreen()),
    );
  } else {
    // المستخدم غير موجود في قاعدة البيانات - تسجيل خروج
    await Supabase.instance.client.auth.signOut();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'هذا الحساب غير مسجل في النظام. يرجى إنشاء حساب جديد',
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
    } on AuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'حدث خطأ أثناء تسجيل الدخول: ${e.toString()}',
              style: const TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleAuthError(AuthException e) {
    String errorMessage = 'حدث خطأ أثناء تسجيل الدخول';

    if (e.message.contains('Invalid login credentials')) {
      errorMessage = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
    } else {
      errorMessage = 'خطأ في المصادقة: ${e.message}';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          errorMessage,
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // الخلفية المتدرجة مع SVG - نفس تصميم الموظفين
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
                      // الشعار والعنوان - نفس تصميم الموظفين
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: MouseRegion(
                              onEnter: (_) =>
                                  setState(() => _isHovering = true),
                              onExit: (_) =>
                                  setState(() => _isHovering = false),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                padding: const EdgeInsets.all(20),
                                margin: const EdgeInsets.only(bottom: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [_gradientStart, _gradientEnd],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isDarkMode
                                          ? const Color.fromARGB(
                                              255,
                                              185,
                                              37,
                                              37,
                                            ).withOpacity(0.4)
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
                                    Transform(
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, 0.001)
                                        ..rotateX(_isHovering ? 0.1 : 0.0)
                                        ..rotateY(_isHovering ? 0.05 : 0.0),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 150,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Image.asset(
                                              'images/lbbb.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          const SizedBox(height: 1),
                                          AnimatedDefaultTextStyle(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            style: theme
                                                .textTheme
                                                .headlineMedium!
                                                .copyWith(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: 'Tajawal',
                                                  color: Colors.white,
                                                  shadows: [
                                                    Shadow(
                                                      color: _gradientStart
                                                          .withOpacity(0.3),
                                                      blurRadius: 12,
                                                      offset: const Offset(
                                                        0,
                                                        4,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            child: const Text('تسجيل الدخول'),
                                          ),
                                          const SizedBox(height: 1),
                                          AnimatedOpacity(
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            opacity: _isHovering ? 1 : 0.8,
                                            child: Text(
                                              'مرحباً بعودتك',
                                              style: theme
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontFamily: 'Tajawal',
                                                    fontSize: 16,
                                                  ),
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
                        ),
                      ),

                      // نموذج التسجيل
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: MouseRegion(
                            onEnter: (_) => setState(() {}),
                            onExit: (_) => setState(() {}),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(24),
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(
                                      isDarkMode ? 0.1 : 0.9,
                                    ),
                                    Colors.white.withOpacity(
                                      isDarkMode ? 0.05 : 0.7,
                                    ),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _buttonGradientStart.withOpacity(
                                      0.1,
                                    ),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                                border: Border.all(
                                  color: _buttonGradientStart.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    // حقل البريد الإلكتروني
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: TextFormField(
                                        controller: _emailController,
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontFamily: 'Tajawal',
                                          color: Colors.black87,
                                          fontSize: 16,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'البريد الإلكتروني',
                                          hintStyle: const TextStyle(
                                            fontFamily: 'Tajawal',
                                            color: Colors.grey,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.email_outlined,
                                            color: _buttonGradientStart,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                vertical: 18,
                                                horizontal: 20,
                                              ),
                                          filled: true,
                                          fillColor: Colors.white.withOpacity(
                                            0.9,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            borderSide: BorderSide(
                                              color: _buttonGradientStart
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            borderSide: BorderSide(
                                              color: _buttonGradientStart
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            borderSide: BorderSide(
                                              color: _buttonGradientStart,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'الرجاء إدخال البريد الإلكتروني';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),

                                    // حقل كلمة المرور
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        obscureText: true,
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontFamily: 'Tajawal',
                                          color: Colors.black87,
                                          fontSize: 16,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'كلمة المرور',
                                          hintStyle: const TextStyle(
                                            fontFamily: 'Tajawal',
                                            color: Colors.grey,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                            color: _buttonGradientStart,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                vertical: 18,
                                                horizontal: 20,
                                              ),
                                          filled: true,
                                          fillColor: Colors.white.withOpacity(
                                            0.9,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            borderSide: BorderSide(
                                              color: _buttonGradientStart
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            borderSide: BorderSide(
                                              color: _buttonGradientStart
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            borderSide: BorderSide(
                                              color: _buttonGradientStart,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'الرجاء إدخال كلمة المرور';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),

                                    // نسيت كلمة المرور
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton(
                                        onPressed: () {
                                          // إضافة وظيفة استعادة كلمة المرور هنا
                                        },
                                        child: Text(
                                          'نسيت كلمة المرور؟',
                                          style: TextStyle(
                                            color: _buttonGradientStart,
                                            fontFamily: 'Tajawal',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 1),

                                    // زر تسجيل الدخول
                                    // زر تسجيل الدخول
                                    _buildEnhancedAuthButton(
                                      context,
                                      icon: _isLoading
                                          ? Icons.hourglass_empty
                                          : Icons.security,
                                      label: _isLoading
                                          ? 'جاري تسجيل الدخول...'
                                          : 'تسجيل الدخول',
                                      gradient: LinearGradient(
                                        colors: [
                                          _buttonGradientStart,
                                          _buttonGradientEnd,
                                        ],
                                      ),
                                      onPressed: _isLoading
                                          ? () {} // دالة فارغة بدلاً من null
                                          : _signIn,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // رابط إنشاء حساب جديد
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ليس لديك حساب؟',
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.grey[700],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // الانتقال لشاشة إنشاء حساب جديد
                                  Navigator.pushNamed(
                                    context,
                                    RegesyerScreen.screenRoot,
                                  );
                                },
                                child: Text(
                                  'إنشاء حساب',
                                  style: TextStyle(
                                    color: _buttonGradientStart,
                                    fontFamily: 'Tajawal',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // مؤشر التحميل
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _buttonGradientStart,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // دالة لإنشاء أزرار مصممة بشكل مطابق للموظفين
  Widget _buildEnhancedAuthButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Gradient gradient,
    required VoidCallback onPressed,
  }) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 300),
      scale: _isHovering ? 1.03 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: _isHovering ? 20 : 12,
              spreadRadius: _isHovering ? 2 : 1,
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
            onHover: (hovering) => setState(() {}),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
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
      ),
    );
  }
}
