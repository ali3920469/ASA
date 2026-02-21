import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mang_mu/screens/citizen/Shared%20Services%20Citizen/user_main_screen.dart';
import 'signin_screen.dart';
class RegesyerScreen extends StatefulWidget {
  static const String screenRoot = 'Regesyer_screen';

  const RegesyerScreen({super.key});

  @override
  State<RegesyerScreen> createState() => _RegesyerScreenState();
}

class _RegesyerScreenState extends State<RegesyerScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  File? _frontIdentityImage;
  File? _backIdentityImage;
  File? _selfieImage;
  bool _isCapturingSelfie = false;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late AnimationController _flashController;
  late Animation<double> _flashAnimation;

  // الألوان مطابقة تماماً لتسجيل الدخول
  final Color _gradientStart = const Color.fromARGB(255, 8, 93, 99);
  final Color _gradientEnd = const Color.fromARGB(255, 1, 17, 27);
  final Color _buttonGradientStart = const Color.fromARGB(255, 17, 126, 117);
  final Color _buttonGradientEnd = const Color.fromARGB(255, 16, 78, 88);
  final Color _cardBackground = const Color.fromARGB(255, 255, 255, 255);
  final Color _errorColor = const Color(0xFFD32F2F);
  final Color _successColor = const Color(0xFF2E7D32);

  // قائمة المناطق
  final List<String> _regions = [
    'حي القادسية',
    'حي النصر',
    'حي الحرية',
    'حي البصرة',
    'حي الصحة',
    'حي الجامعة',
    'حي العمال',
    'محلة البو عبيد',
    'محلة البو غرغور (الغرغور)',
    'محلة البو محمد عيسى',
    'محلة البو ناصر',
    'محلة البو شهيل',
    'محلة الحسينية',
    'محلة السادة',
    'محلة البو عبود',
    'محلة البو حمد',
    'المنطقة المركزية (السوق الكبير)',
    'منطقة السدة',
    'محلة البو شهب',
    'محلة البو نجم',
    'محلة البو درويش',
    'حي الزهور',
    'حي الأمل',
    'منطقة القضاء (حول مركز الناحية)',
    'شارع المستشفى',
    'الشنافية',
    'أبو حمزة (البو حمزة)',
    'الكرادة',
    'الدلمج (ومشروع الدلمج الزراعي)',
    'الخضر',
    'أبو جميجمة',
    'النصرية الصغيرة',
    'البدعة',
    'الجرن',
    'الهرامة',
    'الجعافرة',
    'الطاهرية',
    'الطليعة',
    'كريزة',
    'الخرابة',
    'الشحيمية',
    'الطرف',
    'النهير',
    'المجر الكبير',
    'المجر الصغير',
    'السلام',
    'أبو عطيوي (البو عطيوي)',
    'الزوية',
    'أبو حلوفة (البو حلوفة)',
    'الشارع',
    'المنصورية',
    'البرك',
    'الحدادة',
    'الهرم',
    'الهرية',
    'الزيدية',
    'الرفاعية',
    'المكورة',
    'الرشيدية',
    'السودان',
    'العلوة',
    'المالحية',
    'أبو صخير (البو صخير)',
    'الشحنة',
    'الجديدة',
    'العكيكة',
    'أبو غريب (البو غريب) - محلي',
    'السلمان',
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _flashController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _flashAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flashController, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _accountController.dispose();
    _codeController.dispose();
    _fullNameController.dispose();
    _idNumberController.dispose();
    _houseNumberController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _controller.dispose();
    _flashController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isFront) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 90,
      );

      if (image != null && mounted) {
        setState(() {
          if (isFront) {
            _frontIdentityImage = File(image.path);
          } else {
            _backIdentityImage = File(image.path);
          }
        });
      }
    } catch (e) {
      print('خطأ في اختيار الصورة: $e');
    }
  }

  void _removeImage(bool isFront) {
    if (mounted) {
      setState(() {
        if (isFront) {
          _frontIdentityImage = null;
        } else {
          _backIdentityImage = null;
        }
      });
    }
  }

  Future<void> _captureSelfie() async {
    if (mounted) {
      setState(() => _isCapturingSelfie = true);
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 90,
      );

      if (mounted) {
        setState(() => _isCapturingSelfie = false);
      }

      if (image != null) {
        _flashController.forward(from: 0);
        await Future.delayed(Duration(milliseconds: 300));
        _flashController.reverse();

        if (mounted) {
          setState(() {
            _selfieImage = File(image.path);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCapturingSelfie = false);
      }
      print('خطأ في التقاط السيلفي: $e');
    }
  }

  void _removeSelfie() {
    if (mounted) {
      setState(() {
        _selfieImage = null;
      });
    }
  }

  void _showRegionSelectionDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_gradientStart, _gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'اختر المنطقة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    SizedBox(width: 40),
                  ],
                ),
              ),
              Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: _regions.length,
                  itemBuilder: (context, index) {
                    final region = _regions[index];
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text(
                          region,
                          style: TextStyle(fontFamily: 'Tajawal', fontSize: 14),
                        ),
                        trailing: _locationController.text == region
                            ? Icon(Icons.check, color: _buttonGradientStart)
                            : null,
                        tileColor: _locationController.text == region
                            ? _buttonGradientStart.withOpacity(0.1)
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onTap: () {
                          setState(() {
                            _locationController.text = region;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
Future<bool> _createAccount() async {
  try {
    print('بدء إنشاء الحساب...');

    final email = _accountController.text.trim();
    final password = _codeController.text.trim();
    final fullName = _fullNameController.text.trim();
    final idNumber = _idNumberController.text.trim();
    final houseNumber = _houseNumberController.text.trim();
    final location = _locationController.text.trim();
    final phone = _phoneController.text.trim();

    // التحقق من الحقول
    if (phone.isEmpty) {
      _showError('الرجاء إدخال رقم الموبايل');
      return false;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showError('البريد الإلكتروني غير صحيح');
      return false;
    }

    if (password.length < 6) {
      _showError('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return false;
    }

    if (location.isEmpty) {
      _showError('الرجاء اختيار المنطقة');
      return false;
    }

    // التحقق من عدم وجود البريد الإلكتروني في جدول profiles داخل schema shared
    try {
      final existingProfile = await Supabase.instance.client
          .schema('shared')  // تحديد schema
          .from('profiles')
          .select('email')
          .eq('email', email)
          .maybeSingle();
      
      if (existingProfile != null) {
        _showError('البريد الإلكتروني مستخدم بالفعل');
        return false;
      }
    } catch (e) {
      print('خطأ في التحقق من البريد الإلكتروني: $e');
      // إذا كان الخطأ بسبب عدم وجود الجدول، نكمل على أي حال
    }

    // التحقق من عدم وجود رقم الهوية
    try {
      final existingId = await Supabase.instance.client
          .schema('shared')  // تحديد schema
          .from('profiles')
          .select('id_number')
          .eq('id_number', idNumber)
          .maybeSingle();
      
      if (existingId != null) {
        _showError('رقم الهوية مستخدم بالفعل');
        return false;
      }
    } catch (e) {
      print('خطأ في التحقق من رقم الهوية: $e');
    }

    // 1. تسجيل الخروج أولاً للتأكد من عدم وجود مستخدم مسجل
    await Supabase.instance.client.auth.signOut();

    // 2. إنشاء المستخدم في auth
    late AuthResponse authResponse;
    try {
      authResponse = await Supabase.instance.client.auth
          .signUp(email: email, password: password);
    } on AuthException catch (e) {
      if (e.message.contains('User already registered')) {
        _showError('البريد الإلكتروني مسجل بالفعل. الرجاء استخدام بريد آخر أو تسجيل الدخول');
        return false;
      } else {
        _showError('خطأ في إنشاء الحساب: ${e.message}');
        return false;
      }
    }

    final user = authResponse.user;
    if (user == null) {
      _showError('فشل في إنشاء المستخدم');
      return false;
    }

    // انتظار قليل للتأكد من إنشاء المستخدم
    await Future.delayed(Duration(milliseconds: 1000));

    // 3. رفع الصور إذا وجدت
    String frontImageUrl = '';
    String backImageUrl = '';
    String selfieImageUrl = '';

    if (_frontIdentityImage != null) {
      try {
        frontImageUrl = await _uploadImageToSupabase(
          _frontIdentityImage!,
          'front',
          user.id,
        );
      } catch (e) {
        print('خطأ في رفع الصورة الأمامية: $e');
      }
    }

    if (_backIdentityImage != null) {
      try {
        backImageUrl = await _uploadImageToSupabase(
          _backIdentityImage!,
          'back',
          user.id,
        );
      } catch (e) {
        print('خطأ في رفع الصورة الخلفية: $e');
      }
    }

    if (_selfieImage != null) {
      try {
        selfieImageUrl = await _uploadImageToSupabase(
          _selfieImage!,
          'selfie',
          user.id,
        );
      } catch (e) {
        print('خطأ في رفع صورة السيلفي: $e');
      }
    }

    // 4. إدراج بيانات المستخدم في جدول profiles داخل schema shared
 // 4. إدراج بيانات المستخدم في جدول profiles داخل schema shared
// 4. إدراج بيانات المستخدم في جدول profiles داخل schema shared
final insertData = {
  'id': user.id,
  'full_name': fullName,
  'id_number': idNumber,
  'email': email,
  'phone': phone,
  'house_number': houseNumber,
  'location': location,
  'front_id_image': frontImageUrl,
  'back_id_image': backImageUrl,
  'selfie_image': selfieImageUrl,
  'user_type': 'citizen',
  'status': 'under_review',
  'created_at': DateTime.now().toIso8601String(),
};

try {
  await Supabase.instance.client
      .schema('shared')  // تحديد schema
      .from('profiles')
      .insert(insertData);
      
  print('تم إدراج البيانات بنجاح');
} catch (e) {
  print('خطأ في إدراج البيانات: $e');
  
  // محاولة إنشاء الجدول إذا لم يكن موجوداً (اختياري)
  
  
  // محاولة إدراج البيانات مرة أخرى
  try {
    await Supabase.instance.client
        .schema('shared')
        .from('profiles')
        .insert(insertData);
    print('تم إدراج البيانات بعد المحاولة الثانية');
  } catch (retryError) {
    print('فشل في إدراج البيانات بعد المحاولة الثانية: $retryError');
    _showError('فشل في حفظ البيانات. الرجاء المحاولة مرة أخرى');
    return false;
  }
}

// 5. تسجيل الخروج بعد إنشاء الحساب
await Supabase.instance.client.auth.signOut();

// 6. عرض رسالة نجاح والتوجيه لشاشة تسجيل الدخول
if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'تم إنشاء الحساب بنجاح. يرجى تسجيل الدخول للمتابعة',
        style: TextStyle(fontFamily: 'Tajawal'),
      ),
      backgroundColor: _successColor,
      duration: Duration(seconds: 3),
    ),
  );
  
  // العودة لشاشة تسجيل الدخول
  Navigator.pushReplacementNamed(context, SigninScreen.screenroot);
}

return true;
  } catch (e) {
    print('خطأ عام: $e');
    _showError('حدث خطأ: ${e.toString()}');
    return false;
  }
}

 Future<String> _uploadImageToSupabase(
  File image,
  String fileType,
  String userId,
) async {
  try {
    // استخدام نفس اتصال Supabase مع تحديد bucket
    final String fileName =
        '$userId/${DateTime.now().millisecondsSinceEpoch}_$fileType.jpg';
    final bytes = await image.readAsBytes();

    // رفع الصورة إلى bucket
    await Supabase.instance.client.storage
        .from('employee_documents')
        .uploadBinary(
          fileName,
          bytes,
          fileOptions: FileOptions(contentType: 'image/jpeg', upsert: true),
        );

    // الحصول على الرابط العام
    final String publicUrl = Supabase.instance.client.storage
        .from('employee_documents')
        .getPublicUrl(fileName);

    return publicUrl;
  } catch (e) {
    throw Exception('فشل في رفع الصورة: $e');
  }
}

  void _navigateToNextScreen() {
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        UserMainScreen.screenRoot,
        (route) => false,
        arguments: {
          'showSuccessMessage': true,
          'message': 'تم إنشاء الحساب بنجاح. انتظر حتى يتم التأكد منه',
        },
      );
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(fontFamily: 'Tajawal')),
          backgroundColor: _errorColor,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildImagePreview(File? image, bool isFront) {
    return Container(
      height: 140,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: _buttonGradientStart.withOpacity(0.1),
        border: Border.all(color: _buttonGradientStart, width: 1.5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            )
          else
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_camera, size: 40, color: _buttonGradientStart),
                SizedBox(height: 8),
                Text(
                  isFront ? 'الصورة الأمامية' : 'الصورة الخلفية',
                  style: TextStyle(
                    fontSize: 12,
                    color: _buttonGradientStart,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),

          if (image != null)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _removeImage(isFront),
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(Icons.close, size: 16, color: _errorColor),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSelfiePreview() {
    return Container(
      height: 220,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: _buttonGradientStart.withOpacity(0.05),
        border: Border.all(color: _buttonGradientStart, width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_selfieImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(
                _selfieImage!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            )
          else
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _buttonGradientStart.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.face,
                    size: 40,
                    color: _buttonGradientStart.withOpacity(0.5),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'لم يتم التقاط صورة سيلفي بعد',
                  style: TextStyle(
                    fontSize: 13,
                    color: _buttonGradientStart,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),

          AnimatedBuilder(
            animation: _flashAnimation,
            builder: (context, child) {
              return Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white.withOpacity(_flashAnimation.value * 0.7),
                ),
              );
            },
          ),

          if (_selfieImage != null)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: _removeSelfie,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(Icons.close, size: 18, color: _errorColor),
                ),
              ),
            ),
        ],
      ),
    );
  }

 Widget _buildStepIndicator() {
    final List<String> stepTitles = [
      'البيانات',
      'الحساب',
      'الهوية',
      'السيلفي',
      'المراجعة',
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 0), // تقليل المسافة العلوية أكثر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return Container(
                width: 56,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(0, -3), // رفع الأرقام للأعلى بمقدار 3 بكسل
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentStep >= index
                              ? _buttonGradientStart
                              : Colors.grey[300],
                          border: Border.all(
                            color: _currentStep >= index
                                ? _buttonGradientStart
                                : const Color.fromARGB(255, 197, 196, 196),
                            width: 2,
                          ),
                          boxShadow: _currentStep >= index
                              ? [
                                  BoxShadow(
                                    color: _buttonGradientStart.withOpacity(0.3),
                                    blurRadius: 4,
                                    spreadRadius: 0.5,
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              color: _currentStep >= index
                                  ? Colors.white
                                  : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 6), // إزالة المسافة بين الرقم والكلمة
                    Transform.translate(
                      offset: Offset(0, -2), // رفع الكلمات مع الأرقام
                      child: Text(
                        stepTitles[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          height: 1.0, // تقليل ارتفاع السطر أكثر
                          color: _currentStep >= index
                              ? _buttonGradientStart
                              : Colors.grey[600],
                          fontFamily: 'Tajawal',
                          fontWeight: _currentStep >= index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تحديد الموقع',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _gradientEnd,
            fontFamily: 'Tajawal',
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _buttonGradientStart.withOpacity(0.3)),
            color: Colors.white,
          ),
          child: InkWell(
            onTap: () => _showRegionSelectionDialog(),
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _locationController.text.isEmpty
                                ? 'انقر لاختيار المنطقة'
                                : _locationController.text,
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              color: _locationController.text.isEmpty
                                  ? Colors.grey
                                  : _gradientEnd,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: _locationController.text.isEmpty
                              ? Colors.grey
                              : _buttonGradientStart,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        if (_locationController.text.isNotEmpty)
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _successColor.withOpacity(0.1),
              border: Border.all(color: _successColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: _successColor, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _locationController.text,
                    style: TextStyle(
                      fontSize: 12,
                      color: _gradientEnd,
                      fontFamily: 'Tajawal',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _locationController.clear();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _errorColor.withOpacity(0.1),
                    ),
                    child: Icon(Icons.close, size: 16, color: _errorColor),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: isDarkMode ? _gradientEnd : Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // الشعار والعنوان - نفس تصميم تسجيل الدخول
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 10),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_gradientStart, _gradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: _gradientStart.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'إنشاء حساب جديد',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      color: _gradientEnd,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'املأ البيانات التالية',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Tajawal',
                      color: _buttonGradientStart,
                    ),
                  ),
                ],
              ),
            ),

            // مؤشر الخطوات
            _buildStepIndicator(),

            // المحتوى الرئيسي
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (_currentStep == 0) ...[
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _opacityAnimation,
                            child: Column(
                              children: [
                                _buildTextField(
                                  controller: _fullNameController,
                                  label: 'الاسم الرباعي',
                                  icon: Icons.person_outline,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال الاسم الرباعي';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  controller: _idNumberController,
                                  label: 'رقم الهوية',
                                  icon: Icons.credit_card_outlined,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال رقم الهوية';
                                    }
                                    if (value.length != 10) {
                                      return 'رقم الهوية يجب أن يكون 10 أرقام';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  controller: _houseNumberController,
                                  label: 'رقم الدار/المنزل',
                                  icon: Icons.home_outlined,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال رقم الدار';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  controller: _phoneController,
                                  label: 'رقم الموبايل',
                                  icon: Icons.phone_android_outlined,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال رقم الموبايل';
                                    }
                                    if (value.length < 10 || value.length > 15) {
                                      return 'رقم الموبايل غير صحيح';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                _buildLocationField(),
                                SizedBox(height: 24),
                                _buildEnhancedAuthButton(
                                  icon: Icons.arrow_forward,
                                  label: 'التالي',
                                  gradient: LinearGradient(
                                    colors: [_buttonGradientStart, _buttonGradientEnd],
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (_locationController.text.isEmpty) {
                                        _showError('الرجاء اختيار المنطقة');
                                      } else {
                                        setState(() => _currentStep = 1);
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else if (_currentStep == 1) ...[
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _opacityAnimation,
                            child: Column(
                              children: [
                                _buildTextField(
                                  controller: _accountController,
                                  label: 'البريد الإلكتروني',
                                  icon: Icons.email_outlined,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال البريد الإلكتروني';
                                    }
                                    if (!RegExp(
                                      r'^[^@]+@[^@]+\.[^@]+',
                                    ).hasMatch(value)) {
                                      return 'البريد الإلكتروني غير صحيح';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                _buildTextField(
                                  controller: _codeController,
                                  label: 'كلمة المرور',
                                  icon: Icons.lock_outline,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال كلمة المرور';
                                    }
                                    if (value.length < 6) {
                                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSecondaryButton(
                                        icon: Icons.arrow_back,
                                        label: 'السابق',
                                        onPressed: () =>
                                            setState(() => _currentStep = 0),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: _buildEnhancedAuthButton(
                                        icon: Icons.arrow_forward,
                                        label: 'التالي',
                                        gradient: LinearGradient(
                                          colors: [_buttonGradientStart, _buttonGradientEnd],
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            setState(() => _currentStep = 2);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else if (_currentStep == 2) ...[
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _opacityAnimation,
                            child: Column(
                              children: [
                                Text(
                                  'رفع صور الهوية',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _gradientEnd,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'يرجى رفع صورتين للهوية (أمامية وخلفية)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _buttonGradientStart,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                                SizedBox(height: 20),

                                Text(
                                  'الصورة الأمامية',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _gradientEnd,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                                SizedBox(height: 8),
                                _buildImagePreview(_frontIdentityImage, true),
                                SizedBox(height: 12),
                                _buildEnhancedAuthButton(
                                  icon: Icons.camera_alt,
                                  label: 'اختر الصورة الأمامية',
                                  gradient: LinearGradient(
                                    colors: [_buttonGradientStart, _buttonGradientEnd],
                                  ),
                                  onPressed: () => _pickImage(true),
                                ),

                                SizedBox(height: 24),

                                Text(
                                  'الصورة الخلفية',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _gradientEnd,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                                SizedBox(height: 8),
                                _buildImagePreview(_backIdentityImage, false),
                                SizedBox(height: 12),
                                _buildEnhancedAuthButton(
                                  icon: Icons.camera_alt,
                                  label: 'اختر الصورة الخلفية',
                                  gradient: LinearGradient(
                                    colors: [_buttonGradientStart, _buttonGradientEnd],
                                  ),
                                  onPressed: () => _pickImage(false),
                                ),

                                SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSecondaryButton(
                                        icon: Icons.arrow_back,
                                        label: 'السابق',
                                        onPressed: () =>
                                            setState(() => _currentStep = 1),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: _buildEnhancedAuthButton(
                                        icon: Icons.arrow_forward,
                                        label: 'التالي',
                                        gradient: LinearGradient(
                                          colors: [_buttonGradientStart, _buttonGradientEnd],
                                        ),
                                        onPressed: () {
                                          if (_frontIdentityImage == null ||
                                              _backIdentityImage == null) {
                                            _showError(
                                              'الرجاء رفع صور الهوية الأمامية والخلفية',
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
                            ),
                          ),
                        ),
                      ] else if (_currentStep == 3) ...[
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _opacityAnimation,
                            child: Column(
                              children: [
                                Text(
                                  'التقاط صورة سيلفي',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _gradientEnd,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'يرجى التقاط صورة سيلفي واضحة',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _buttonGradientStart,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                                SizedBox(height: 20),

                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: _buttonGradientStart.withOpacity(0.1),
                                    border: Border.all(
                                      color: _buttonGradientStart.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: _buttonGradientStart,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'تأكد من وضوح الوجه والإضاءة الجيدة',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _gradientEnd,
                                            fontFamily: 'Tajawal',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 20),
                                _buildSelfiePreview(),
                                SizedBox(height: 20),

                                _isCapturingSelfie
                                    ? Center(
                                        child: Column(
                                          children: [
                                            CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                _buttonGradientStart,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'جارٍ التقاط الصورة...',
                                              style: TextStyle(
                                                fontFamily: 'Tajawal',
                                                color: _buttonGradientStart,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : _buildEnhancedAuthButton(
                                        icon: Icons.camera_alt,
                                        label: 'التقاط صورة سيلفي',
                                        gradient: LinearGradient(
                                          colors: [_buttonGradientStart, _buttonGradientEnd],
                                        ),
                                        onPressed: _captureSelfie,
                                      ),

                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSecondaryButton(
                                        icon: Icons.arrow_back,
                                        label: 'السابق',
                                        onPressed: () =>
                                            setState(() => _currentStep = 2),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: _buildEnhancedAuthButton(
                                        icon: _selfieImage != null
                                            ? Icons.check
                                            : Icons.skip_next,
                                        label: _selfieImage != null ? 'التالي' : 'تخطي',
                                        gradient: LinearGradient(
                                          colors: [_buttonGradientStart, _buttonGradientEnd],
                                        ),
                                        onPressed: () {
                                          setState(() => _currentStep = 4);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else if (_currentStep == 4) ...[
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _opacityAnimation,
                            child: Column(
                              children: [
                                Text(
                                  'مراجعة المعلومات',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _gradientEnd,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'راجع المعلومات قبل إنشاء الحساب',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _buttonGradientStart,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                                SizedBox(height: 20),

                                Container(
                                  height: 420,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: _buttonGradientStart.withOpacity(0.2),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _buttonGradientStart.withOpacity(0.1),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ListView(
                                    padding: EdgeInsets.all(16),
                                    children: [
                                      _buildReviewItem(
                                        'الاسم الرباعي',
                                        _fullNameController.text,
                                        Icons.person,
                                      ),
                                      SizedBox(height: 12),
                                      _buildReviewItem(
                                        'رقم الهوية',
                                        _idNumberController.text,
                                        Icons.credit_card,
                                      ),
                                      SizedBox(height: 12),
                                      _buildReviewItem(
                                        'رقم الدار/المنزل',
                                        _houseNumberController.text,
                                        Icons.home,
                                      ),
                                      SizedBox(height: 12),
                                      _buildReviewItem(
                                        'رقم الموبايل',
                                        _phoneController.text,
                                        Icons.phone_android,
                                      ),
                                      SizedBox(height: 12),
                                      _buildReviewItem(
                                        'المنطقة',
                                        _locationController.text,
                                        Icons.location_on,
                                      ),
                                      SizedBox(height: 12),
                                      _buildReviewItem(
                                        'البريد الإلكتروني',
                                        _accountController.text,
                                        Icons.email,
                                      ),
                                      SizedBox(height: 12),
                                      _buildReviewItem(
                                        'كلمة المرور',
                                        '••••••••',
                                        Icons.lock,
                                      ),
                                      SizedBox(height: 12),
                                      _buildReviewStatus(
                                        'صورة الهوية الأمامية',
                                        _frontIdentityImage != null,
                                        Icons.photo_camera_front,
                                      ),
                                      SizedBox(height: 12),
                                      _buildReviewStatus(
                                        'صورة الهوية الخلفية',
                                        _backIdentityImage != null,
                                        Icons.photo_camera_back,
                                      ),
                                      SizedBox(height: 12),
                                      _buildReviewStatus(
                                        'صورة السيلفي',
                                        _selfieImage != null,
                                        Icons.face,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSecondaryButton(
                                        icon: Icons.arrow_back,
                                        label: 'السابق',
                                        onPressed: () =>
                                            setState(() => _currentStep = 3),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: _isLoading
                                          ? Container(
                                              height: 48,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(16),
                                                color: _buttonGradientStart.withOpacity(0.1),
                                              ),
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<Color>(
                                                        _buttonGradientStart,
                                                      ),
                                                ),
                                              ),
                                            )
                                          : _buildEnhancedAuthButton(
                                              icon: Icons.check,
                                              label: 'إنشاء الحساب',
                                              gradient: LinearGradient(
                                                colors: [_buttonGradientStart, _buttonGradientEnd],
                                              ),
                                              onPressed: () async {
                                                if (_formKey.currentState!.validate()) {
                                                  setState(() => _isLoading = true);
                                                  try {
                                                    final success =
                                                        await _createAccount();
                                                    if (!success && mounted) {
                                                      setState(
                                                        () => _isLoading = false,
                                                      );
                                                    }
                                                  } catch (e) {
                                                    if (mounted) {
                                                      setState(
                                                        () => _isLoading = false,
                                                      );
                                                    }
                                                    _showError('حدث خطأ: $e');
                                                  }
                                                }
                                              },
                                            ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'لديك حساب بالفعل؟',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              color: _buttonGradientStart,
                              fontSize: 12,
                            ),
                          ),
                          TextButton(
                            
                          
  onPressed: () {
    Navigator.pushNamed(context,SigninScreen .screenroot);
  },
  child: Text(
                              'تسجيل الدخول',
    style: TextStyle(
      color: _buttonGradientStart,
      fontFamily: 'Tajawal',
      fontWeight: FontWeight.bold,
    ),
  ),

                          ),
                        ],
                      ),
                      SizedBox(height: 20),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      style: TextStyle(fontFamily: 'Tajawal', color: _gradientEnd, fontSize: 14),
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(
          fontFamily: 'Tajawal',
          color: Colors.grey,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: _buttonGradientStart, size: 20),
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: _buttonGradientStart.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: _buttonGradientStart.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: _buttonGradientStart,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewItem(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _buttonGradientStart.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _buttonGradientStart.withOpacity(0.1),
            ),
            child: Icon(icon, size: 18, color: _buttonGradientStart),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: _buttonGradientStart,
                    fontFamily: 'Tajawal',
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : 'غير محدد',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: value.isNotEmpty ? _gradientEnd : Colors.grey,
                    fontFamily: 'Tajawal',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStatus(String label, bool isCompleted, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _buttonGradientStart.withOpacity(0.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _buttonGradientStart.withOpacity(0.1),
                ),
                child: Icon(icon, size: 18, color: _buttonGradientStart),
              ),
              SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _gradientEnd,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? _successColor.withOpacity(0.1)
                  : _errorColor.withOpacity(0.1),
            ),
            child: Icon(
              isCompleted ? Icons.check : Icons.close,
              size: 14,
              color: isCompleted ? _successColor : _errorColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedAuthButton({
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
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: gradient,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Tajawal',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _buttonGradientStart.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: _buttonGradientStart, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _buttonGradientStart,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Tajawal',
                    fontSize: 14,
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