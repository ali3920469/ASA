import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class WaterEmergencyScreen extends StatefulWidget {
  static const String screenRoute = '/water-emergency';
  final String serviceName;
  final Color serviceColor;
  final List<Color> serviceGradient;
  final String serviceTitle;

  const WaterEmergencyScreen({
    super.key,
    required this.serviceName,
    required this.serviceColor,
    required this.serviceGradient,
    required this.serviceTitle,
  });
  
  @override
  State<WaterEmergencyScreen> createState() => _WaterEmergencyScreenState();
}

class _WaterEmergencyScreenState extends State<WaterEmergencyScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  String _problemDescription = '';
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: widget.serviceColor,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.serviceGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.serviceColor.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        title: Text(
          widget.serviceName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            shadows: [
              Shadow(
                blurRadius: 2,
                color: Colors.black12,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: buildContent(),
      ),
    );
  }

  Widget buildContent() {
    if (widget.serviceName.contains('طارئ') || widget.serviceName.contains('إبلاغ')) {
      return _buildEmergencyReportContent();
    } else {
      return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 3,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: widget.serviceColor,
              size: 50,
            ),
            const SizedBox(height: 15),
            const Text(
              'تفاصيل الخدمة ستظهر هنا مع إمكانية تنفيذ الإجراء المطلوب مباشرة',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: widget.serviceColor,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildEmergencyReportContent() {
    String serviceType = widget.serviceTitle;
    String instructions = '';

    if (serviceType == 'الكهرباء') {
      instructions = 'يمكنك الإبلاغ عن:\n\n'
          '• كابلات كهرباء ساقطة أو تالفة\n'
          '• محولات عاطلة أو معطوبة\n'
          '• أعمدة إنارة مكسورة\n'
          '• أي خطر كهربائي في الشارع';
    } else if (serviceType == 'الماء') {
      instructions = 'يمكنك الإبلاغ عن:\n\n'
          '• تسرب مياه من الأنابيب في الشارع\n'
          '• أنابيب مياه مكسورة أو متضررة\n'
          '• فيضانات أو تجمعات مياه غير طبيعية\n'
          '• أي مشكلة في شبكة المياه العامة';
    } else if (serviceType == 'النفايات') {
      instructions = 'يمكنك الإبلاغ عن:\n\n'
          '• تراكم النفايات في الأماكن العامة\n'
          '• حاويات نفايات ممتلئة أو متضررة\n'
          '• نفايات متسربة أو مبعثرة\n'
          '• أي مشكلة تتعلق بالنظافة العامة';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('الإبلاغ عن مشكلة في $serviceType'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 3,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.report_problem_rounded, color: Colors.orange, size: 60),
              const SizedBox(height: 16),
              Text(
                instructions,
                style: const TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildReportForm(),
      ],
    );
  }

  Widget _buildReportForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionTitle('أرفق صورة للمشكلة'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: _selectedImage == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_rounded, 
                            color: Colors.grey[400], size: 50),
                        const SizedBox(height: 8),
                        Text(
                          'انقر لالتقاط صورة',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_selectedImage!.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('وصف المشكلة'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: 'أدخل وصفاً مفصلاً للمشكلة وموقعها...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال وصف للمشكلة';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                _problemDescription = value;
              });
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitReport,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.serviceColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'إرسال التقرير',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'ملاحظة: سيتم إرسال التقرير إلى الجهة المختصة للمعالجة في أقرب وقت',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء التقاط الصورة'),
        ),
      );
    }
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى التقاط صورة للمشكلة'),
          ),
        );
        return;
      }

      // هنا سيتم إضافة كود إرسال التقرير مع الصورة إلى الخادم
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تم إرسال التقرير'),
          content: const Text('شكراً لك على مساهمتك في تحسين خدمات المدينة. تم إرسال تقريرك وسيتم معالجته قريباً.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // إعادة تعيين الحقول بعد الإرسال
                setState(() {
                  _selectedImage = null;
                  _descriptionController.clear();
                  _problemDescription = '';
                });
              },
              child: const Text('موافق'),
            ),
          ],
        ),
      );
    }
  }
}