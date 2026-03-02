import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';
import 'package:mang_mu/screens/employee/Shared Services/esignin_screen.dart';

class EventEmployee extends StatefulWidget {
  static const String screenRoute = '/event-employee';

  const EventEmployee({super.key});

  @override
  State<EventEmployee> createState() => _EventEmployeeState();
}

class _EventEmployeeState extends State<EventEmployee>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // إضافة ScrollController للتحكم في التمرير
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarVisible = true;

  // متغيرات البحث والتصفية
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  String _selectedDepartmentFilter = 'الكل';
  String _selectedStatusFilter = 'الكل';

  // الألوان (منسقة مع شاشة المحاسب)
  final Color _primaryColor = const Color.fromARGB(255, 46, 30, 169);
  final Color _secondaryColor = const Color(0xFFD4AF37);
  final Color _accentColor = const Color(0xFF8D6E63);
  final Color _successColor = const Color(0xFF2E7D32);
  final Color _warningColor = const Color(0xFFF57C00);
  final Color _errorColor = const Color(0xFFD32F2F);
  final Color _infoColor = const Color(0xFF1976D2);

  // قوائم البيانات التجريبية للأحداث - مخصصة لقضاء قلعة سكر - الناصرية
  final List<Map<String, dynamic>> _allEvents = [
    {
      'id': 'EVT-001',
      'title': 'صيانة محولات كهرباء مركز قضاء قلعة سكر',
      'description': 'صيانة دورية للمحولات الكهربائية في مركز القضاء وإصلاح الأعطال في شبكة الكهرباء.',
      'department': 'الكهرباء',
      'date': DateTime.now().add(const Duration(days: 2)),
      'time': '9:00 صباحاً',
      'status': 'قادم',
      'priority': 'عالية',
      'assignedTo': 'فريق صيانة الكهرباء - قلعة سكر',
      'location': 'مركز قضاء قلعة سكر',
      'district': 'قلعة سكر',
      'city': 'الناصرية',
    },
    {
      'id': 'EVT-002',
      'title': 'قطع المياه عن أحياء قلعة سكر الشمالية',
      'description': 'أعمال صيانة عاجلة للخط الرئيسي المغذي للأحياء الشمالية. سيتم قطع المياه لمدة 8 ساعات.',
      'department': 'الماء',
      'date': DateTime.now().add(const Duration(days: 1)),
      'time': '8:00 صباحاً',
      'status': 'قادم',
      'priority': 'عاجلة',
      'assignedTo': 'فريق الطوارئ - دائرة ماء قلعة سكر',
      'location': 'الأحياء الشمالية - قلعة سكر',
      'district': 'قلعة سكر',
      'city': 'الناصرية',
    },
    {
      'id': 'EVT-003',
      'title': 'حملة نظافة شاملة في أسواق قلعة سكر',
      'description': 'حملة لإزالة النفايات وتحسين المظهر العام في الأسواق المركزية بالقضاء.',
      'department': 'البلدية',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'time': '7:30 صباحاً',
      'status': 'مكتمل',
      'priority': 'متوسطة',
      'assignedTo': 'عمال النظافة - بلدية قلعة سكر',
      'location': 'الأسواق المركزية - قلعة سكر',
      'district': 'قلعة سكر',
      'city': 'الناصرية',
    },
    {
      'id': 'EVT-004',
      'title': 'ندوة توعوية عن ترشيد استهلاك الكهرباء',
      'description': 'ندوة توعوية لأهالي قضاء قلعة سكر بالتعاون مع قسم الإعلام في المجلس المحلي.',
      'department': 'الكهرباء',
      'date': DateTime.now().add(const Duration(days: 5)),
      'time': '10:00 صباحاً',
      'status': 'قادم',
      'priority': 'منخفضة',
      'assignedTo': 'قسم الإعلام - قلعة سكر',
      'location': 'قاعة المجلس البلدي - قلعة سكر',
      'district': 'قلعة سكر',
      'city': 'الناصرية',
    },
    {
      'id': 'EVT-005',
      'title': 'مشروع تأهيل شبكة المجاري في حي الزهراء',
      'description': 'تأهيل شامل لشبكة المجاري القديمة في حي الزهراء بسبب تكرار مشاكل الطفحان.',
      'department': 'البلدية',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'time': '8:00 صباحاً',
      'status': 'معلق',
      'priority': 'عالية',
      'assignedTo': 'المقاول العام - مشاريع قلعة سكر',
      'location': 'حي الزهراء - قلعة سكر',
      'district': 'قلعة سكر',
      'city': 'الناصرية',
    },
    {
      'id': 'EVT-006',
      'title': 'اختبار جودة مياه الشرب في قضاء قلعة سكر',
      'description': 'أخذ عينات من مياه الشرب من عدة مناطق في القضاء لفحص الجودة والمطابقة للمواصفات.',
      'department': 'الماء',
      'date': DateTime.now().add(const Duration(days: 3)),
      'time': '7:30 صباحاً',
      'status': 'قيد التنفيذ',
      'priority': 'متوسطة',
      'assignedTo': 'مختبر الجودة - دائرة ماء ذي قار',
      'location': 'مناطق متفرقة - قلعة سكر',
      'district': 'قلعة سكر',
      'city': 'الناصرية',
    },
    {
      'id': 'EVT-007',
      'title': 'تأهيل الطريق الرابط بين قلعة سكر والناصرية',
      'description': 'أعمال صيانة وتأهيل للطريق الرئيسي الذي يربط القضاء بمركز المحافظة.',
      'department': 'البلدية',
      'date': DateTime.now().add(const Duration(days: 7)),
      'time': '8:00 صباحاً',
      'status': 'قادم',
      'priority': 'عالية',
      'assignedTo': 'كادر الطرق - بلدية قلعة سكر',
      'location': 'طريق قلعة سكر - الناصرية',
      'district': 'قلعة سكر',
      'city': 'الناصرية',
    },
    {
      'id': 'EVT-008',
      'title': 'توزيع وجبات إفطار صائم في شهر رمضان',
      'description': 'توزيع وجبات إفطار على العوائل المتعففة في قضاء قلعة سكر بالتعاون مع المتطوعين.',
      'department': 'البلدية',
      'date': DateTime.now().add(const Duration(days: 10)),
      'time': '4:00 مساءً',
      'status': 'قادم',
      'priority': 'متوسطة',
      'assignedTo': 'فريق العمل التطوعي - قلعة سكر',
      'location': 'مناطق متفرقة - قلعة سكر',
      'district': 'قلعة سكر',
      'city': 'الناصرية',
    },
    {
      'id': 'EVT-009',
      'title': 'صيانة مضخات ماء الإسالة في محطة قلعة سكر الرئيسية',
      'description': 'صيانة دورية للمضخات واستبدال القطع التالفة لضخ المياه للأحياء السكنية.',
      'department': 'الماء',
      'date': DateTime.now().add(const Duration(days: 4)),
      'time': '9:00 صباحاً',
      'status': 'قيد التنفيذ',
      'priority': 'عاجلة',
      'assignedTo': 'فريق الصيانة - دائرة ماء قلعة سكر',
      'location': 'محطة ضخ الماء - قلعة سكر',
      'district': 'قلعة سكر',
      'city': 'الناصرية',
    },
  ];

  // قائمة الدوائر المتاحة
  final List<String> _departments = ['الكل', 'الكهرباء', 'الماء', 'البلدية'];
  final List<String> _statuses = ['الكل', 'قادم', 'قيد التنفيذ', 'مكتمل', 'معلق'];

  // دوال المساعدة للألوان حسب الحالة
  Color _getStatusColor(String status) {
    switch (status) {
      case 'قادم':
        return _infoColor;
      case 'قيد التنفيذ':
        return _warningColor;
      case 'مكتمل':
        return _successColor;
      case 'معلق':
        return _errorColor;
      default:
        return _textSecondaryColor(context);
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'عاجلة':
      case 'عالية':
        return _errorColor;
      case 'متوسطة':
        return _warningColor;
      case 'منخفضة':
        return _successColor;
      default:
        return _textSecondaryColor(context);
    }
  }

  // دالة لجلب الأحداث المفلترة
  List<Map<String, dynamic>> get _filteredEvents {
    return _allEvents.where((event) {
      // فلتر البحث
      final matchesSearch = _searchQuery.isEmpty ||
          event['title'].contains(_searchQuery) ||
          event['description'].contains(_searchQuery) ||
          event['location'].contains(_searchQuery) ||
          event['district'].contains(_searchQuery);

      // فلتر الدائرة
      final matchesDepartment = _selectedDepartmentFilter == 'الكل' ||
          event['department'] == _selectedDepartmentFilter;

      // فلتر الحالة
      final matchesStatus = _selectedStatusFilter == 'الكل' ||
          event['status'] == _selectedStatusFilter;

      return matchesSearch && matchesDepartment && matchesStatus;
    }).toList();
  }

  // دوال للألوان
  Color _backgroundColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? const Color(0xFF121212) : const Color(0xFFF0F8FF);
  }

  Color _cardColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  }

  Color _textColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Colors.white : const Color(0xFF212121);
  }

  Color _textSecondaryColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? Colors.white70 : const Color(0xFF757575);
  }

  Color _borderColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return themeProvider.isDarkMode ? const Color(0xFF333333) : const Color(0xFFE0E0E0);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _departments.length, vsync: this);
    
    // إضافة مستمع للتمرير
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // دالة للتحكم في ظهور/اختفاء الـ AppBar السفلي
  void _onScroll() {
    if (_scrollController.position.pixels > 100 && _isAppBarVisible) {
      setState(() {
        _isAppBarVisible = false;
      });
    } else if (_scrollController.position.pixels <= 100 && !_isAppBarVisible) {
      setState(() {
        _isAppBarVisible = true;
      });
    }
  }

  // ================ دوال عرض النوافذ المنبثقة (Dialog) ================
  void _showAddEditEventDialog({Map<String, dynamic>? eventToEdit}) {
    bool isEditing = eventToEdit != null;
    // قوائم منسدلة
    final List<String> departments = ['الكهرباء', 'الماء', 'البلدية'];
    final List<String> statuses = ['قادم', 'قيد التنفيذ', 'مكتمل', 'معلق'];
    final List<String> priorities = ['عاجلة', 'عالية', 'متوسطة', 'منخفضة'];

    // متغيرات للتحكم
    String selectedDepartment = isEditing ? eventToEdit['department'] : departments.first;
    String selectedStatus = isEditing ? eventToEdit['status'] : statuses.first;
    String selectedPriority = isEditing ? eventToEdit['priority'] : priorities.first;

    // متغيرات للتاريخ والوقت
    DateTime selectedDate = isEditing ? eventToEdit['date'] : DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = isEditing
        ? _parseTimeString(eventToEdit['time'])
        : const TimeOfDay(hour: 9, minute: 0);

    // متغيرات للنصوص
    TextEditingController titleController =
        TextEditingController(text: isEditing ? eventToEdit['title'] : '');
    TextEditingController descriptionController =
        TextEditingController(text: isEditing ? eventToEdit['description'] : '');
    TextEditingController assignedToController =
        TextEditingController(text: isEditing ? eventToEdit['assignedTo'] : '');
    TextEditingController locationController =
        TextEditingController(text: isEditing ? eventToEdit['location'] : '');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (stateContext, setState) {
            return AlertDialog(
              backgroundColor: _cardColor(context),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Icon(isEditing ? Icons.edit_rounded : Icons.add_rounded,
                      color: _primaryColor),
                  const SizedBox(width: 8),
                  Text(isEditing ? 'تعديل الحدث' : 'إضافة حدث جديد'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // العنوان
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'عنوان الحدث',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.title_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // الوصف
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'الوصف',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.description_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // الدائرة
                    DropdownButtonFormField<String>(
                      value: selectedDepartment,
                      decoration: InputDecoration(
                        labelText: 'الدائرة',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.business_rounded),
                      ),
                      items: departments.map((dept) {
                        return DropdownMenuItem(
                          value: dept,
                          child: Text(dept),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDepartment = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // التاريخ والوقت في صف واحد
                    Row(
                      children: [
                        // التاريخ
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                              );
                              if (picked != null && picked != selectedDate) {
                                setState(() {
                                  selectedDate = picked;
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'التاريخ',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: const Icon(Icons.calendar_today_rounded),
                              ),
                              child: Text(DateFormat('yyyy/MM/dd').format(selectedDate)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // الوقت
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              TimeOfDay? picked = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                              );
                              if (picked != null && picked != selectedTime) {
                                setState(() {
                                  selectedTime = picked;
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'الوقت',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: const Icon(Icons.access_time_rounded),
                              ),
                              child: Text(selectedTime.format(context)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // الحالة
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: InputDecoration(
                        labelText: 'الحالة',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.circle_rounded),
                      ),
                      items: statuses.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // الأولوية
                    DropdownButtonFormField<String>(
                      value: selectedPriority,
                      decoration: InputDecoration(
                        labelText: 'الأولوية',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.flag_rounded),
                      ),
                      items: priorities.map((priority) {
                        return DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPriority = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // المسؤول
                    TextField(
                      controller: assignedToController,
                      decoration: InputDecoration(
                        labelText: 'المسؤول / الفريق',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.person_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // الموقع
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        labelText: 'الموقع',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.location_on_rounded),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor(context))),
                ),
                ElevatedButton(
                  onPressed: () {
                    // التحقق من صحة المدخلات الأساسية
                    if (titleController.text.isEmpty ||
                        descriptionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('الرجاء ملء جميع الحقول المطلوبة'),
                          backgroundColor: Color(0xFFD32F2F),
                        ),
                      );
                      return;
                    }

                    // إنشاء كائن الحدث الجديد أو المحدث
                    Map<String, dynamic> newEvent = {
                      'id': isEditing ? eventToEdit['id'] : 'EVT-${DateTime.now().millisecondsSinceEpoch}',
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'department': selectedDepartment,
                      'date': DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
                      'time': selectedTime.format(context),
                      'status': selectedStatus,
                      'priority': selectedPriority,
                      'assignedTo': assignedToController.text,
                      'location': locationController.text,
                      'district': 'قلعة سكر',
                      'city': 'الناصرية',
                    };

                    setState(() {
                      if (isEditing) {
                        // تعديل الحدث الموجود
                        int index = _allEvents.indexWhere((e) => e['id'] == eventToEdit['id']);
                        if (index != -1) {
                          _allEvents[index] = newEvent;
                        }
                        _showSuccessSnackbar('تم تعديل الحدث بنجاح');
                      } else {
                        // إضافة حدث جديد
                        _allEvents.add(newEvent);
                        _showSuccessSnackbar('تم إضافة الحدث بنجاح');
                      }
                    });

                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(isEditing ? 'تعديل' : 'إضافة'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // دالة مساعدة لتحويل نص الوقت إلى TimeOfDay
  TimeOfDay _parseTimeString(String timeString) {
    try {
      if (timeString.contains(':')) {
        List<String> parts = timeString.replaceAll('صباحاً', '').replaceAll('مساءً', '').trim().split(':');
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1].split(' ')[0]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      // ignore: avoid_print
      print('خطأ في تحويل الوقت: $e');
    }
    return const TimeOfDay(hour: 9, minute: 0); // قيمة افتراضية
  }

  void _showEventDetails(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العنوان
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.event_rounded, color: _primaryColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        event['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _textColor(context),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // معلومات القضاء
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _secondaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_city_rounded, color: _secondaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'قضاء قلعة سكر - محافظة ذي قار',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // التفاصيل
                _buildDetailRow('الدائرة', event['department'], Icons.business_rounded, context),
                _buildDetailRow('التاريخ', DateFormat('yyyy/MM/dd').format(event['date']), Icons.calendar_today_rounded, context),
                _buildDetailRow('الوقت', event['time'], Icons.access_time_rounded, context),
                _buildDetailRow('الموقع', event['location'], Icons.location_on_rounded, context),
                _buildDetailRow('المسؤول', event['assignedTo'], Icons.person_rounded, context),
                _buildDetailRow('الوصف', event['description'], Icons.description_rounded, context, maxLines: 3),

                const SizedBox(height: 16),

                // الحالة والأولوية
                Column(
                  children: [
                    // الحالة
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: _getStatusColor(event['status']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _getStatusColor(event['status']).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.circle_rounded, color: _getStatusColor(event['status']), size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'الحالة: ${event['status']}',
                              style: TextStyle(
                                color: _getStatusColor(event['status']),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // الأولوية
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(event['priority']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _getPriorityColor(event['priority']).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.flag_rounded, color: _getPriorityColor(event['priority']), size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'الأولوية: ${event['priority']}',
                              style: TextStyle(
                                color: _getPriorityColor(event['priority']),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // الأزرار
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showAddEditEventDialog(eventToEdit: event);
                        },
                        icon: const Icon(Icons.edit_rounded, size: 18),
                        label: const Text('تعديل'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _primaryColor,
                          side: BorderSide(color: _primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showDeleteConfirmation(event);
                        },
                        icon: const Icon(Icons.delete_rounded, size: 18),
                        label: const Text('حذف'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _errorColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('إغلاق', style: TextStyle(color: _textSecondaryColor(context))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, BuildContext context, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _primaryColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label: $value',
              style: TextStyle(
                fontSize: 14,
                color: _textColor(context),
              ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: _errorColor),
            const SizedBox(width: 8),
            const Text('تأكيد الحذف'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من حذف الحدث "${event['title']}"؟',
          style: TextStyle(color: _textColor(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: _textSecondaryColor(context))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allEvents.removeWhere((e) => e['id'] == event['id']);
              });
              Navigator.pop(context);
              _showSuccessSnackbar('تم حذف الحدث بنجاح');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _successColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  // ================ القائمة المنسدلة (Drawer) ================
  Widget _buildEventDrawer(BuildContext context, bool isDarkMode) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode 
                ? [const Color(0xFF1B5E20), const Color(0xFF0D1B0E)]
                : [_primaryColor, const Color(0xFF4CAF50)],
          ),
        ),
        child: Column(
          children: [
            // رأس الملف الشخصي مع معلومات قلعة سكر
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDarkMode 
                      ? [const Color(0xFF1B5E20), const Color(0xFF0D4715)]
                      : [_primaryColor, const Color(0xFF388E3C)],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(
                      Icons.event_available_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "موظف الأحداث - قلعة سكر",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "قضاء قلعة سكر - محافظة ذي قار",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "السكان: ~150,000 نسمة | المساحة: 400 كم²",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // القائمة الرئيسية
            Expanded(
              child: Container(
                color: isDarkMode ? const Color(0xFF0D1B0E) : const Color(0xFFE8F5E9),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerMenuItem(
                      icon: Icons.settings_rounded,
                      title: 'الإعدادات',
                      onTap: () {
                        Navigator.pop(context);
                        _showEventSettings(context, isDarkMode);
                      },
                      isDarkMode: isDarkMode,
                    ),
                    
                    _buildDrawerMenuItem(
                      icon: Icons.help_rounded,
                      title: 'المساعدة والدعم',
                      onTap: () {
                        Navigator.pop(context);
                        _showEventHelpSupport(context, isDarkMode);
                      },
                      isDarkMode: isDarkMode,
                    ),

                    const SizedBox(height: 30),
                    
                    // تسجيل الخروج
                    _buildDrawerMenuItem(
                      icon: Icons.logout_rounded,
                      title: 'تسجيل الخروج',
                      onTap: () {
                        _showLogoutConfirmation();
                      },
                      isDarkMode: isDarkMode,
                      isLogout: true,
                    ),

                    const SizedBox(height: 40),
                    
                    // معلومات النسخة
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Divider(
                            color: isDarkMode ? Colors.white24 : Colors.grey[400],
                            height: 1,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'وزارة الكهرباء - قضاء قلعة سكر',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.grey[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'نظام إدارة الأحداث - قلعة سكر',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white54 : Colors.grey[600],
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'الإصدار 1.0.0',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white54 : Colors.grey[600],
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'آخر تحديث: ${DateFormat('yyyy/MM/dd').format(DateTime.now())}',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white38 : Colors.grey[500],
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
  // عنصر القائمة
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_left_rounded,
          color: isLogout ? Colors.red : (isDarkMode ? Colors.white54 : Colors.grey[500]),
          size: 24,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
  Widget _buildInfoRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
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

  void _filterEventsByStatus(String status) {
    setState(() {
      _selectedStatusFilter = status;
      // تحديث التبويب إلى "الكل" لعرض جميع الدوائر مع التصفية
      _tabController.animateTo(0); // الذهاب إلى تبويب "الكل"
    });
    _showSuccessSnackbar('تم تصفية الأحداث حسب الحالة: $status');
  }

  void _filterEventsByDepartment(String department) {
    setState(() {
      _selectedDepartmentFilter = department;
      // الذهاب إلى تبويب الدائرة المحددة
      int index = _departments.indexOf(department);
      if (index != -1) {
        _tabController.animateTo(index);
      }
    });
    _showSuccessSnackbar('تم عرض أحداث دائرة: $department');
  }

  Widget _buildStatRow(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(label),
            ],
          ),
          Text(
            count.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _textColor(context),
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  void _showDayEvents(DateTime day, List<Map<String, dynamic>> events) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.event_rounded, color: _primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'أحداث ${DateFormat('yyyy/MM/dd').format(day)} - قلعة سكر',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return ListTile(
                      leading: Container(
                        width: 8,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getStatusColor(event['status']),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      title: Text(event['title']),
                      subtitle: Text('${event['time']} - ${event['department']}'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(event['status']).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          event['status'],
                          style: TextStyle(
                            fontSize: 10,
                            color: _getStatusColor(event['status']),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _showEventDetails(event);
                      },
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('إغلاق', style: TextStyle(color: _primaryColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDepartmentExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('اختر الدائرة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.bolt_rounded, color: Colors.amber),
              title: const Text('دائرة الكهرباء - قلعة سكر'),
              onTap: () {
                Navigator.pop(context);
                _showSuccessSnackbar('جاري تصدير تقرير دائرة الكهرباء...');
              },
            ),
            ListTile(
              leading: const Icon(Icons.water_drop_rounded, color: Colors.blue),
              title: const Text('دائرة الماء - قلعة سكر'),
              onTap: () {
                Navigator.pop(context);
                _showSuccessSnackbar('جاري تصدير تقرير دائرة الماء...');
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_city_rounded, color: Colors.brown),
              title: const Text('دائرة البلدية - قلعة سكر'),
              onTap: () {
                Navigator.pop(context);
                _showSuccessSnackbar('جاري تصدير تقرير دائرة البلدية...');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('اختر الحالة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.info_rounded, color: _infoColor),
              title: const Text('قادم'),
              onTap: () {
                Navigator.pop(context);
                _showSuccessSnackbar('جاري تصدير تقرير الأحداث القادمة...');
              },
            ),
            ListTile(
              leading: Icon(Icons.play_circle_rounded, color: _warningColor),
              title: const Text('قيد التنفيذ'),
              onTap: () {
                Navigator.pop(context);
                _showSuccessSnackbar('جاري تصدير تقرير الأحداث الجارية...');
              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle_rounded, color: _successColor),
              title: const Text('مكتمل'),
              onTap: () {
                Navigator.pop(context);
                _showSuccessSnackbar('جاري تصدير تقرير الأحداث المكتملة...');
              },
            ),
            ListTile(
              leading: Icon(Icons.pending_rounded, color: _errorColor),
              title: const Text('معلق'),
              onTap: () {
                Navigator.pop(context);
                _showSuccessSnackbar('جاري تصدير تقرير الأحداث المعلقة...');
              },
            ),
          ],
        ),
      ),
    );
  }

  // ========== إعدادات موظف الأحداث ==========
  void _showEventSettings(BuildContext context, bool isDarkMode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventSettingsScreen(
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

  // ========== المساعدة والدعم ==========
  void _showEventHelpSupport(BuildContext context, bool isDarkMode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventEmployeeHelpSupportScreen(
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

  // دالة مساعدة للتحقق من تطابق التاريخ
  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // ================ بناء الواجهة الرئيسية مع التعديل ================
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

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
              child: Icon(Icons.event_available_rounded, color: _primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'نظام إدارة الأحداث - قضاء قلعة سكر',
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
        backgroundColor: themeProvider.isDarkMode ? const Color(0xFF1B5E20) : _primaryColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // زر الإضافة
          IconButton(
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
            onPressed: () => _showAddEditEventDialog(),
          ),
        ],
      ),
      drawer: _buildEventDrawer(context, themeProvider.isDarkMode),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: themeProvider.isDarkMode
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF121212), Color(0xFF1A1A1A)],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF5F5F5), Color(0xFFE8F5E8)],
                ),
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // شريط البحث والتصفية - يظهر/يختفي مع التمرير
            SliverVisibility(
              visible: _isAppBarVisible,
              sliver: SliverToBoxAdapter(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: _isAppBarVisible ? null : 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildSearchBar(context),
                        const SizedBox(height: 12),
                        _buildFilterRow(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // تبويبات الدوائر - تظهر/تختفي مع التمرير
            SliverVisibility(
              visible: _isAppBarVisible,
              sliver: SliverToBoxAdapter(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: _isAppBarVisible ? null : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _cardColor(context),
                      border: Border(
                        bottom: BorderSide(color: _borderColor(context), width: 1),
                        top: BorderSide(color: _borderColor(context), width: 1),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorColor: _secondaryColor,
                      indicatorWeight: 3,
                      labelColor: _primaryColor,
                      unselectedLabelColor: _textSecondaryColor(context),
                      tabs: _departments.map((dept) => Tab(text: dept)).toList(),
                    ),
                  ),
                ),
              ),
            ),

            // محتوى التبويبات (قائمة الأحداث) - تبقى دائماً مرئية
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: _departments.map((dept) {
                  // تصفية الأحداث حسب الدائرة المختارة
                  List<Map<String, dynamic>> eventsToShow = dept == 'الكل'
                      ? _filteredEvents
                      : _filteredEvents.where((e) => e['department'] == dept).toList();

                  return eventsToShow.isEmpty
                      ? _buildEmptyState(context, dept)
                      : _buildEventsList(eventsToShow, context);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: _borderColor(context), width: 1),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'ابحث عن حدث في قلعة سكر...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.filter_alt_rounded, color: _primaryColor, size: 18),
                const SizedBox(width: 4),
                const Text('تصفية:'),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ..._statuses.map((status) => _buildFilterChip(status, _selectedStatusFilter, (value) {
                setState(() => _selectedStatusFilter = value);
              }, context)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String selectedValue, Function(String) onSelected, BuildContext context) {
    bool isSelected = selectedValue == label;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(label),
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
  }

  Widget _buildEventsList(List<Map<String, dynamic>> events, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildEventCard(event, context);
      },
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event, BuildContext context) {
    Color statusColor = _getStatusColor(event['status']);
    _getPriorityColor(event['priority']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: _borderColor(context), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Icon(
            event['department'] == 'الكهرباء'
                ? Icons.bolt_rounded
                : (event['department'] == 'الماء' ? Icons.water_drop_rounded : Icons.location_city_rounded),
            color: statusColor,
            size: 24,
          ),
        ),
        title: Text(
          event['title'],
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: _textColor(context),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              event['description'],
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor(context),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // معلومات الموقع
            Row(
              children: [
                Icon(Icons.location_on_rounded, color: _secondaryColor, size: 12),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'قلعة سكر - ${event['location']}',
                    style: TextStyle(
                      fontSize: 10,
                      color: _secondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // التاريخ والوقت والأولوية
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                // التاريخ
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _infoColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today_rounded, color: _infoColor, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('yyyy/MM/dd').format(event['date']),
                        style: TextStyle(
                          fontSize: 10,
                          color: _infoColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // الوقت
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time_rounded, color: _accentColor, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        event['time'],
                        style: TextStyle(
                          fontSize: 10,
                          color: _accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // الأولوية إذا كانت عالية أو عاجلة
                if (event['priority'] == 'عاجلة' || event['priority'] == 'عالية')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.priority_high_rounded, color: _errorColor, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          event['priority'],
                          style: TextStyle(
                            fontSize: 10,
                            color: _errorColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded, color: _textSecondaryColor(context)),
          onSelected: (value) {
            if (value == 'edit') {
              _showAddEditEventDialog(eventToEdit: event);
            } else if (value == 'delete') {
              _showDeleteConfirmation(event);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_rounded, color: Color(0xFF2E7D32)),
                  SizedBox(width: 8),
                  Text('تعديل'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_rounded, color: Color(0xFFD32F2F)),
                  SizedBox(width: 8),
                  Text('حذف'),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _showEventDetails(event),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String department) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_busy_rounded,
              size: 60,
              color: _primaryColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            department == 'الكل' 
                ? 'لا توجد أحداث في قلعة سكر' 
                : 'لا توجد أحداث لدائرة $department في قلعة سكر',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _textSecondaryColor(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'يمكنك إضافة حدث جديد باستخدام زر +',
            style: TextStyle(
              color: _textSecondaryColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ========== شاشة إعدادات موظف الأحداث ==========
class EventSettingsScreen extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;

  const EventSettingsScreen({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.successColor,
    required this.warningColor,
    required this.errorColor,
  }) : super(key: key);

  @override
  State<EventSettingsScreen> createState() => _EventSettingsScreenState();
}

class _EventSettingsScreenState extends State<EventSettingsScreen> {
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
                'استلام إشعارات حول الأحداث في قلعة سكر',
                _notificationsEnabled,
                (bool value) => setState(() => _notificationsEnabled = value),
                isDarkMode,
              ),
              _buildSettingSwitch(
                'الصوت',
                'تشغيل صوت للإشعارات الواردة',
                _soundEnabled,
                (bool value) => setState(() => _soundEnabled = value),
                isDarkMode,
              ),
              _buildSettingSwitch(
                'الاهتزاز',
                'اهتزاز الجهاز عند استلام الإشعارات',
                _vibrationEnabled,
                (bool value) => setState(() => _vibrationEnabled = value),
                isDarkMode,
              ),

              SizedBox(height: 24),
              _buildSettingsSection('المظهر', Icons.palette_rounded, isDarkMode),
              
              _buildDarkModeSwitch(context),
              
              _buildSettingDropdown(
                'اللغة',
                _language,
                _languages,
                (String? value) => setState(() => _language = value!),
                isDarkMode,
              ),
              
              SizedBox(height: 24),
              _buildSettingsSection('الأمان والبيانات', Icons.security_rounded, isDarkMode),
              
              _buildSettingSwitch(
                'النسخ الاحتياطي التلقائي',
                'نسخ احتياطي تلقائي لبيانات الأحداث',
                _autoBackup,
                (bool value) => setState(() => _autoBackup = value),
                isDarkMode,
              ),
              
              _buildSettingSwitch(
                'المصادقة البيومترية',
                'استخدام بصمة الإصبع أو التعرف على الوجه',
                _biometricAuth,
                (bool value) => setState(() => _biometricAuth = value),
                isDarkMode,
              ),
              
              _buildSettingSwitch(
                'المزامنة التلقائية',
                'مزامنة البيانات تلقائياً مع السحابة',
                _autoSync,
                (bool value) => setState(() => _autoSync = value),
                isDarkMode,
              ),
              
              SizedBox(height: 24),
              _buildSettingsSection('حول التطبيق', Icons.info_rounded, isDarkMode),
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
          _buildAboutRow('المطور', 'وزارة الكهرباء - قضاء قلعة سكر', isDarkMode),
          _buildAboutRow('رقم الترخيص', 'MOE-QSS-2024-001', isDarkMode),
          _buildAboutRow('آخر تحديث', '2024-03-15', isDarkMode),
          _buildAboutRow('البريد الإلكتروني', 'qalatsukkar@electric.gov.iq', isDarkMode),
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

// ========== شاشة المساعدة والدعم لموظف الأحداث ==========
class EventEmployeeHelpSupportScreen extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;

  const EventEmployeeHelpSupportScreen({
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
          'المساعدة والدعم - قلعة سكر',
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
                  'مركز الدعم الفني - قلعة سكر',
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
          _buildContactItem(Icons.phone_rounded, 'رقم الدعم الفني', '07725252104', true, context, isDarkMode),
          _buildContactItem(Icons.phone_rounded, 'رقم الطوارئ للأحداث', '07862268895', true, context, isDarkMode),
          _buildContactItem(Icons.email_rounded, 'البريد الإلكتروني', 'support.qss@electric.gov.iq', false, context, isDarkMode),
          _buildContactItem(Icons.access_time_rounded, 'ساعات العمل', '8:00 ص - 4:00 م', false, context, isDarkMode),
          _buildContactItem(Icons.location_on_rounded, 'العنوان', 'قضاء قلعة سكر - مجمع الدوائر البلدية', false, context, isDarkMode),
          SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _makePhoneCall('07725252104', context),
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
        builder: (context) => EventSupportChatScreen(
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
        'question': 'كيف يمكنني إضافة حدث جديد في قلعة سكر؟',
        'answer': 'من الشاشة الرئيسية، انقر على زر + في شريط العنوان العلوي، ثم املأ بيانات الحدث (العنوان، الوصف، الدائرة، التاريخ، الوقت، الحالة، الأولوية، المسؤول، الموقع) واضغط على إضافة.'
      },
      {
        'question': 'ما هي الدوائر المتاحة في قضاء قلعة سكر؟',
        'answer': 'الدوائر المتاحة هي: الكهرباء، الماء، البلدية. يمكنك تصفية الأحداث حسب كل دائرة باستخدام التبويبات العلوية.'
      },
      {
        'question': 'كيف أبلغ عن مشكلة في الكهرباء أو الماء؟',
        'answer': 'يمكنك إضافة حدث جديد واختيار الدائرة المناسبة (كهرباء أو ماء) مع وصف المشكلة، وسيتم تحويلها للفريق المختص.'
      },
      {
        'question': 'ما هي المناطق التابعة لقضاء قلعة سكر؟',
        'answer': 'يشمل قضاء قلعة سكر عدة مناطق سكنية منها: مركز القضاء، حي الزهراء، الأحياء الشمالية، والمناطق الريفية المحيطة.'
      },
      {
        'question': 'كيف أتابع حالة الطلب المقدم؟',
        'answer': 'يمكنك متابعة حالة الحدث من خلال قائمة الأحداث، حيث تظهر الحالة (قادم، قيد التنفيذ، مكتمل، معلق) مع لون مميز لكل حالة.'
      },
    ];

    return faqs.map((faq) {
      return _buildExpandableItem(faq['question']!, faq['answer']!, isDarkMode);
    }).toList();
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
          _buildInfoRow('المطور', 'وزارة الكهرباء - قضاء قلعة سكر', isDarkMode),
          _buildInfoRow('رقم الترخيص', 'MOE-QSS-2024-001', isDarkMode),
          _buildInfoRow('آخر تحديث', '2024-03-15', isDarkMode),
          _buildInfoRow('الدوائر المدعومة', 'الكهرباء - الماء - البلدية', isDarkMode),
          _buildInfoRow('إجمالي الأحداث', '9 أحداث في قلعة سكر', isDarkMode),
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

// ========== شاشة محادثة الدعم لموظف الأحداث ==========
class EventSupportChatScreen extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;

  const EventSupportChatScreen({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  _EventSupportChatScreenState createState() => _EventSupportChatScreenState();
}

class _EventSupportChatScreenState extends State<EventSupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'مرحباً! مركز دعم قضاء قلعة سكر. كيف يمكنني مساعدتك اليوم؟',
      'isUser': false,
      'time': 'الآن',
      'sender': 'فريق دعم قلعة سكر'
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
            'text': 'شكراً لتواصلك مع دعم قلعة سكر. سيتم الرد على استفسارك في أقرب وقت ممكن.',
            'isUser': false,
            'time': 'الآن',
            'sender': 'فريق دعم قلعة سكر'
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
              'دعم قلعة سكر',
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
                        'فريق دعم قلعة سكر',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'متخصصون في خدمات القضاء',
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
                        hintText: 'اكتب استفسارك عن خدمات قلعة سكر...',
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