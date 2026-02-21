import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../citizen/Shared Services Citizen/welcome_screen.dart';
import 'package:mang_mu/screens/employee/Employee_Shared%20Services/ewecome_screen.dart';
import 'dart:ui';
import 'dart:math';

class Mainscren extends StatefulWidget {
  static const String screenroot = '/mainscren';
  const Mainscren({super.key});

  @override
  State<Mainscren> createState() => _MainscrenState();
}

class _MainscrenState extends State<Mainscren>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  
  // الألوان مطابقة تماماً لتسجيل الدخول
  final Color _gradientStart = const Color.fromARGB(255, 8, 93, 99);
  final Color _gradientEnd = const Color.fromARGB(255, 1, 17, 27);
  final Color _buttonGradientStart = const Color.fromARGB(255, 17, 126, 117);
  final Color _buttonGradientEnd = const Color.fromARGB(255, 16, 78, 88);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF212121);
  final Color _textSecondaryColor = const Color(0xFF757575);

  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Map<String, dynamic>> _features = [
    {
      'icon': Icons.connected_tv,
      'title': 'خدمات ذكية',
      'description': 'وصول سريع لجميع الخدمات عبر المنصة',
    },
    {
      'icon': Icons.verified_user,
      'title': 'أمان وحماية',
      'description': 'نظام آمن ومحمي لحماية بياناتك',
    },
    {
      'icon': Icons.access_time_filled,
      'title': 'توفير الوقت',
      'description': 'إنجاز المعاملات في دقائق بدون عناء',
    },
  ];

  @override
  void initState() {
    super.initState();
  
    Future.delayed(const Duration(seconds: 5), _nextFeature);
  }

  void _nextFeature() {
    if (!mounted) return;
    if (_currentPage < _features.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
      _currentPage++;
    } else {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
      _currentPage = 0;
    }
    Future.delayed(const Duration(seconds: 5), _nextFeature);
  }

 

@override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  return Scaffold(
    body: Stack(
      children: [
        // الخلفية المتدرجة مع SVG - نفس تصميم تسجيل الدخول
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.5,
              colors: isDarkMode
                  ? [const Color(0xFF0A0E21), const Color(0xFF1D1E33)]
                  : [const Color(0xFFF5F7FA), const Color(0xFFE4E7EB)],
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
                  horizontal: size.width > 800 ? size.width * 0.2 : 24,
                  vertical: 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // الشعار والعنوان - نفس تصميم تسجيل الدخول
                    Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [_gradientStart, _gradientEnd],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _gradientStart.withOpacity(0.3),
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
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              'images/lbbb.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            'مدينتي الذكية',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Tajawal',
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: _gradientStart.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'نحو مستقبل رقمي متكامل',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontFamily: 'Tajawal',
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // أزرار الدخول
                    Column(
                      children: [
                        // زر دخول المواطنين
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: _buttonGradientStart.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  WecomeScreen.screenroot,
                                );
                              },
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: [_buttonGradientStart, _buttonGradientEnd],
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.people_alt_rounded, 
                                      color: Colors.white, 
                                      size: 24),
                                    const SizedBox(width: 12),
                                    Text(
                                      'دخول المواطنين',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Tajawal',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // زر دخول الموظفين
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _buttonGradientStart.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  EwecomeScreen.screenroot,
                                );
                              },
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.badge_rounded, 
                                      color: _buttonGradientStart, 
                                      size: 24),
                                    const SizedBox(width: 12),
                                    Text(
                                      'دخول الموظفين',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Tajawal',
                                        color: _buttonGradientStart,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // الميزات
                    SizedBox(height: size.height * 0.05),

                    Container(
                      height: 120,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _features.length,
                        itemBuilder: (context, index) {
                          return _buildFeatureCard(
                            _features[index]['icon'],
                            _features[index]['title'],
                            _features[index]['description'],
                          );
                        },
                      ),
                    ),

                    // مؤشر الصفحات
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _features.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: _currentPage == index
                                ? LinearGradient(
                                    colors: [_buttonGradientStart, _buttonGradientEnd],
                                  )
                                : null,
                            color: _currentPage == index
                                ? null
                                : _buttonGradientStart.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),

                    // معلومات إضافية
                    const SizedBox(height: 30),
                  
                  ],
                ),
              ),
            ),
          ),
        ),

        // تذييل الصفحة
     
      ],
    ),
  );
}

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String description,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: _buttonGradientStart.withOpacity(0.1),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [_buttonGradientStart, _buttonGradientEnd],
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Tajawal',
                    color: _gradientEnd,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    color: _buttonGradientStart,
                    fontSize: 14,
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