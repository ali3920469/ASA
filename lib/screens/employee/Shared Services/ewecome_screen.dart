import 'package:flutter/material.dart';
import 'package:mang_mu/widgets/my_buttn.dart';
import 'package:mang_mu/screens/employee/Shared%20Services/esignin_screen.dart';
import 'package:mang_mu/screens/employee/Shared%20Services/eregesyer_screen.dart';
import 'package:mang_mu/screens/zemp_and_citizen/mainscren.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

class EwecomeScreen extends StatefulWidget {
  static const String screenroot = 'ewcome_screen';
  const EwecomeScreen({super.key});

  @override
  State<EwecomeScreen> createState() => _EwecomeScreenState();
}

class _EwecomeScreenState extends State<EwecomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isHovering = false;
  int _currentBackground = 0;
  final List<String> _backgrounds = [
    'assets/bg1.svg',
    'assets/bg2.svg',
    'assets/bg3.svg',
  ];

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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, Mainscren.screenroot);
        return false;
      },
      child: Scaffold(
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
                              child: MouseRegion(
                                onEnter: (_) => setState(() => _isHovering = true),
                                onExit: (_) => setState(() => _isHovering = false),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
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
                                              width: 120,
                                              height: 120,
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
                                              child: const Text('النظام الإداري'),
                                            ),
                                            const SizedBox(height: 10),
                                            AnimatedOpacity(
                                              duration: const Duration(milliseconds: 500),
                                              opacity: _isHovering ? 1 : 0.8,
                                              child: Text(
                                                'واجهة دخول الموظفين',
                                                style: theme.textTheme.titleMedium!.copyWith(
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

                        // أزرار الدخول والتسجيل
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _opacityAnimation,
                            child: Column(
                              children: [
                                _buildEnhancedAuthButton(
                                  context,
                                  icon: Icons.security,
                                  label: 'تسجيل الدخول',
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 17, 126, 117),
                                      Color.fromARGB(255, 16, 78, 88),
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, EsigninScreen.screenroot);
                                  },
                                ),
                                const SizedBox(height: 20),
                                _buildEnhancedAuthButton(
                                  context,
                                  icon: Icons.person_add_alt_1,
                                  label: 'إنشاء حساب جديد',
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 17, 126, 117),
                                      Color.fromARGB(255, 16, 78, 88),
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, EregesyerScreen.screenroot);
                                  },
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