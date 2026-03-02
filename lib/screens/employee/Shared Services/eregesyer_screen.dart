import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

class EregesyerScreen extends StatefulWidget {
  static const String screenroot = 'eregesyer_screen';

  const EregesyerScreen({super.key});

  @override
  State<EregesyerScreen> createState() => _EregesyerScreenState();
}

class _EregesyerScreenState extends State<EregesyerScreen>
    with SingleTickerProviderStateMixin {
  File? _frontIdentityImage;
  File? _backIdentityImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  int _currentStep = 0;
  bool _isLoading = false;

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
    _accountController.dispose();
    _codeController.dispose();
    _fullNameController.dispose();
    _idNumberController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isFront) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 90,
    );

    if (image != null) {
      setState(() {
        if (isFront) {
          _frontIdentityImage = File(image.path);
        } else {
          _backIdentityImage = File(image.path);
        }
      });
    }
  }

  void _removeImage(bool isFront) {
    setState(() {
      if (isFront) {
        _frontIdentityImage = null;
      } else {
        _backIdentityImage = null;
      }
    });
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color.fromARGB(255, 17, 126, 117),
          title: Text(
            "تأكيد معلومات الموظف",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Tajawal',
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "الرجاء مراجعة المعلومات قبل الإنشاء:",
                  style: TextStyle(
                    color: Colors.white70,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 16),
                _buildDialogInfoRow("الاسم الرباعي", _fullNameController.text),
                const SizedBox(height: 8),
                _buildDialogInfoRow("رقم الهوية", _idNumberController.text),
                const SizedBox(height: 8),
                _buildDialogInfoRow("الحساب", _accountController.text),
                const SizedBox(height: 8),
                _buildDialogInfoRow("الرمز", _codeController.text),
                const SizedBox(height: 16),
                if (_frontIdentityImage != null)
                  _buildDialogInfoRow("صورة الهوية من الأمام", "تم التحميل"),
                if (_backIdentityImage != null)
                  _buildDialogInfoRow("صورة الهوية من الخلف", "تم التحميل"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("إلغاء", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                setState(() => _isLoading = true);
                Navigator.pop(context);
                await Future.delayed(const Duration(seconds: 1));
                if (!mounted) return;
              },
              child: Text(
                "تأكيد وإنشاء الحساب",
                style: TextStyle(
                  color: const Color.fromARGB(255, 17, 126, 117),
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Tajawal',
            ),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.white70, fontFamily: 'Tajawal'),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(File? image, bool isFront) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color.fromARGB(255, 17, 126, 117).withOpacity(0.3),
            border: Border.all(
              color: const Color.fromARGB(255, 17, 126, 117),
              width: 2,
            ),
            image: image != null
                ? DecorationImage(image: FileImage(image), fit: BoxFit.cover)
                : null,
          ),
          child: image == null
              ? Icon(Icons.photo_camera, size: 50, color: Colors.white70)
              : null,
        ),
        if (image != null)
          Positioned(
            top: 5,
            left: 5,
            child: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeImage(isFront),
            ),
          ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(1, _currentStep >= 0),
        _buildStepLine(),
        _buildStepCircle(2, _currentStep >= 1),
        _buildStepLine(),
        _buildStepCircle(3, _currentStep >= 2),
        _buildStepLine(),
        _buildStepCircle(4, _currentStep >= 3),
      ],
    );
  }

  Widget _buildStepCircle(int step, bool isActive) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? const Color.fromARGB(255, 17, 126, 117)
            : Colors.grey[400],
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildStepLine() {
    return Container(width: 50, height: 2, color: Colors.grey[300]);
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
                    vertical: 20,
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
                              margin: const EdgeInsets.only(bottom: 20),
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
                                    style: theme.textTheme.headlineMedium!
                                        .copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'Tajawal',
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: theme.primaryColor
                                                  .withOpacity(0.3),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                    child: const Text('إنشاء حساب موظف'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      _buildStepIndicator(),

                      const SizedBox(height: 30),

                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: Column(
                            children: [
                              if (_currentStep == 0) ...[
                                _buildPersonalInfoStep(),
                              ] else if (_currentStep == 1) ...[
                                _buildAccountInfoStep(),
                              ] else if (_currentStep == 2) ...[
                                _buildIdPhotosStep(),
                              ] else if (_currentStep == 3) ...[
                                _buildReviewStep(),
                              ],
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
                        color: theme.textTheme.bodyLarge?.color?.withOpacity(
                          0.7,
                        ),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),

          // مؤشر التحميل
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color.fromARGB(255, 17, 126, 117),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      children: [
        Text(
          "المعلومات الشخصية",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 30),
        _buildTextField(
          controller: _fullNameController,
          hintText: 'الاسم الرباعي',
          icon: Icons.person,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _idNumberController,
          hintText: 'رقم الهوية',
          icon: Icons.credit_card,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 30),
        _buildEnhancedAuthButton(
          context,
          icon: Icons.arrow_forward,
          label: 'التالي',
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 17, 126, 117),
              Color.fromARGB(255, 16, 78, 88),
            ],
          ),
          onPressed: () {
            if (_fullNameController.text.isEmpty ||
                _idNumberController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('الرجاء إدخال الاسم الرباعي ورقم الهوية'),
                ),
              );
            } else {
              setState(() => _currentStep = 1);
            }
          },
        ),
      ],
    );
  }

  Widget _buildAccountInfoStep() {
    return Column(
      children: [
        Text(
          "معلومات الحساب",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 30),
        _buildTextField(
          controller: _accountController,
          hintText: 'ادخل الحساب الخاص بك',
          icon: Icons.account_circle,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _codeController,
          hintText: 'ادخل الرمز الخاص بك',
          icon: Icons.lock,
          obscureText: true,
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: _buildEnhancedAuthButton(
                context,
                icon: Icons.arrow_back,
                label: 'السابق',
                gradient: const LinearGradient(
                  colors: [Colors.grey, Colors.grey],
                ),
                onPressed: () => setState(() => _currentStep = 0),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildEnhancedAuthButton(
                context,
                icon: Icons.arrow_forward,
                label: 'التالي',
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 17, 126, 117),
                    Color.fromARGB(255, 16, 78, 88),
                  ],
                ),
                onPressed: () {
                  if (_accountController.text.isEmpty ||
                      _codeController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('الرجاء إدخال جميع البيانات المطلوبة'),
                      ),
                    );
                  } else {
                    setState(() => _currentStep = 2);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIdPhotosStep() {
    return Column(
      children: [
        Text(
          "صور الهوية",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 30),
        Text(
          'صورة الهوية من الأمام',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 10),
        _buildImagePreview(_frontIdentityImage, true),
        const SizedBox(height: 20),
        _buildEnhancedAuthButton(
          context,
          icon: Icons.camera_alt,
          label: 'اختر صورة الهوية من الأمام',
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 17, 126, 117),
              Color.fromARGB(255, 16, 78, 88),
            ],
          ),
          onPressed: () => _pickImage(true),
        ),
        const SizedBox(height: 30),
        Text(
          'صورة الهوية من الخلف',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 10),
        _buildImagePreview(_backIdentityImage, false),
        const SizedBox(height: 20),
        _buildEnhancedAuthButton(
          context,
          icon: Icons.camera_alt,
          label: 'اختر صورة الهوية من الخلف',
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 17, 126, 117),
              Color.fromARGB(255, 16, 78, 88),
            ],
          ),
          onPressed: () => _pickImage(false),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: _buildEnhancedAuthButton(
                context,
                icon: Icons.arrow_back,
                label: 'السابق',
                gradient: const LinearGradient(
                  colors: [Colors.grey, Colors.grey],
                ),
                onPressed: () => setState(() => _currentStep = 1),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildEnhancedAuthButton(
                context,
                icon: Icons.arrow_forward,
                label: 'التالي',
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 17, 126, 117),
                    Color.fromARGB(255, 16, 78, 88),
                  ],
                ),
                onPressed: () {
                  if (_frontIdentityImage == null ||
                      _backIdentityImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('الرجاء تحميل صور الهوية')),
                    );
                  } else {
                    setState(() => _currentStep = 3);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      children: [
        Text(
          "مراجعة المعلومات",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color.fromARGB(255, 17, 126, 117).withOpacity(0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildReviewRow("الاسم الرباعي", _fullNameController.text),
              const Divider(height: 30, color: Colors.white30),
              _buildReviewRow("رقم الهوية", _idNumberController.text),
              const Divider(height: 30, color: Colors.white30),
              _buildReviewRow("الحساب", _accountController.text),
              const Divider(height: 30, color: Colors.white30),
              _buildReviewRow("الرمز", _codeController.text),
              const Divider(height: 30, color: Colors.white30),
              _buildReviewRow(
                "صورة الهوية من الأمام",
                _frontIdentityImage != null ? "تم التحميل" : "غير محملة",
              ),
              const SizedBox(height: 15),
              _buildReviewRow(
                "صورة الهوية من الخلف",
                _backIdentityImage != null ? "تم التحميل" : "غير محملة",
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: _buildEnhancedAuthButton(
                context,
                icon: Icons.arrow_back,
                label: 'السابق',
                gradient: const LinearGradient(
                  colors: [Colors.grey, Colors.grey],
                ),
                onPressed: () => setState(() => _currentStep = 2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildEnhancedAuthButton(
                context,
                icon: Icons.check,
                label: 'إنشاء الحساب',
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 17, 126, 117),
                    Color.fromARGB(255, 16, 78, 88),
                  ],
                ),
                onPressed: () => _showConfirmationDialog(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Tajawal',
          ),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.white70, fontFamily: 'Tajawal'),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
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
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: gradient,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Tajawal',
                    fontSize: 16,
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
