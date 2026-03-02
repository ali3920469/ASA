import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mang_mu/providers/theme_provider.dart';
import 'package:mang_mu/screens/employee/Shared Services/esignin_screen.dart';

class OffersGiftsSpecialist extends StatefulWidget {
  static const String screenRoute = '/offers-gifts-specialist';

  const OffersGiftsSpecialist({super.key});

  @override
  State<OffersGiftsSpecialist> createState() => _OffersGiftsSpecialistState();
}

class _OffersGiftsSpecialistState extends State<OffersGiftsSpecialist>
     with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _offersSubTabController;
  late TabController _giftsSubTabController;
  
  // الألوان (يمكنك استخدام نفس الألوان من واجهة المحاسب)
  final Color _primaryColor = Color.fromARGB(255, 46, 30, 169);
  final Color _secondaryColor = Color(0xFFD4AF37);
  final Color _accentColor = Color(0xFF8D6E63);
  final Color _successColor = Color(0xFF2E7D32);
  final Color _warningColor = Color(0xFFF57C00);
  final Color _errorColor = Color(0xFFD32F2F);
  final Color _darkPrimaryColor = Color(0xFF1B5E20);

  // متغيرات البحث والتصفية
  String _searchQuery = '';
  int get _unreadNotificationsCount => _notifications.where((n) => !n['isRead']).length;
  final TextEditingController _searchController = TextEditingController();
  
  // بيانات تجريبية للعروض - مع إضافة منطقة قلعة سكر
  final List<Map<String, dynamic>> _offers = [
    {
      'id': 'OFR-001',
      'title': 'خصم 15% على الفاتورة القادمة - قلعة سكر',
      'description': 'احصل على خصم 15% عند سداد الفاتورة قبل تاريخ الاستحقاق في منطقة قلعة سكر',
      'type': 'discount',
      'status': 'active',
      'startDate': DateTime.now().subtract(Duration(days: 5)),
      'endDate': DateTime.now().add(Duration(days: 25)),
      'targetAudience': 'سكان قلعة سكر',
      'location': 'قضاء قلعة سكر - الناصرية',
      'usageCount': 145,
      'maxUsage': 500,
      'icon': Icons.percent_rounded,
      'color': Colors.green,
    },
    {
      'id': 'OFR-002',
      'title': 'نقاط مضاعفة لأهالي الناصرية',
      'description': 'احصل على نقاط ولاء مضاعفة عند دفع فاتورتك عبر التطبيق في مدينة الناصرية',
      'type': 'loyalty',
      'status': 'active',
      'startDate': DateTime.now().subtract(Duration(days: 2)),
      'endDate': DateTime.now().add(Duration(days: 12)),
      'targetAudience': 'سكان الناصرية',
      'location': 'مركز مدينة الناصرية',
      'usageCount': 89,
      'maxUsage': 300,
      'icon': Icons.stars_rounded,
      'color': Colors.orange,
    },
    {
      'id': 'OFR-003',
      'title': 'هدية عيد الأضحى - قلعة سكر',
      'description': 'احصل على مروحة مجانية عند دفع فاتورتين متتاليتين في منطقة قلعة سكر',
      'type': 'gift',
      'status': 'inactive',
      'startDate': DateTime.now().add(Duration(days: 20)),
      'endDate': DateTime.now().add(Duration(days: 50)),
      'targetAudience': 'سكان قلعة سكر',
      'location': 'قضاء قلعة سكر',
      'usageCount': 0,
      'maxUsage': 200,
      'icon': Icons.card_giftcard_rounded,
      'color': Colors.red,
    },
    {
      'id': 'OFR-004',
      'title': 'برنامج الولاء الجديد - ذي قار',
      'description': 'انضم لبرنامج الولاء واجمع النقاط لاستبدالها بهدايا حصرية في محافظة ذي قار',
      'type': 'loyalty',
      'status': 'active',
      'startDate': DateTime.now().subtract(Duration(days: 30)),
      'endDate': DateTime.now().add(Duration(days: 335)),
      'targetAudience': 'جميع سكان ذي قار',
      'location': 'محافظة ذي قار',
      'usageCount': 567,
      'maxUsage': 1000,
      'icon': Icons.loyalty_rounded,
      'color': Colors.purple,
    },
  ];

  // بيانات تجريبية للهدايا - مع إضافة منطقة قلعة سكر
  final List<Map<String, dynamic>> _gifts = [
    {
      'id': 'GFT-001',
      'name': 'مروحة سقف - صناعة عراقية',
      'pointsRequired': 1500,
      'quantity': 25,
      'description': 'مروحة سقف بقوة 50 واط - صناعة عراقية متوفرة في قلعة سكر',
      'status': 'available',
      'location': 'قلعة سكر',
      'icon': Icons.toys_rounded,
      'color': Colors.blue,
    },
    {
      'id': 'GFT-002',
      'name': 'لمبة LED موفرة - الناصرية',
      'pointsRequired': 300,
      'quantity': 150,
      'description': 'لمبة LED بقدرة 9 واط تدوم طويلاً - متوفرة في مركز الناصرية',
      'status': 'available',
      'location': 'الناصرية',
      'icon': Icons.emoji_objects_rounded,
      'color': Colors.amber,
    },
    {
      'id': 'GFT-003',
      'name': 'سماعة بلوتوث - قلعة سكر',
      'pointsRequired': 800,
      'quantity': 10,
      'description': 'سماعة لاسلكية مقاومة للماء - متوفرة في قلعة سكر',
      'status': 'limited',
      'location': 'قلعة سكر',
      'icon': Icons.headphones_rounded,
      'color': Colors.green,
    },
    {
      'id': 'GFT-004',
      'name': 'كوبون خصم 10,000 دينار - ذي قار',
      'pointsRequired': 500,
      'quantity': 0,
      'description': 'خصم على قيمة الفاتورة القادمة - صالح في جميع فروع ذي قار',
      'status': 'out_of_stock',
      'location': 'محافظة ذي قار',
      'icon': Icons.discount_rounded,
      'color': Colors.grey,
    },
    {
      'id': 'GFT-005',
      'name': 'جراب موبايل - قلعة سكر',
      'pointsRequired': 400,
      'quantity': 30,
      'description': 'جراب موبايل بكفالة شهر - متوفر في قلعة سكر',
      'status': 'available',
      'location': 'قلعة سكر',
      'icon': Icons.phone_android_rounded,
      'color': Colors.teal,
    },
  ];

  // بيانات تجريبية لنقاط المواطنين - مع إضافة منطقة قلعة سكر
  final List<Map<String, dynamic>> _citizenPoints = [
    {
      'citizenId': 'CIT-001',
      'citizenName': 'أحمد محمد الجبوري',
      'totalPoints': 2340,
      'usedPoints': 500,
      'availablePoints': 1840,
      'location': 'قلعة سكر',
      'lastUpdated': DateTime.now().subtract(Duration(days: 2)),
    },
    {
      'citizenId': 'CIT-002',
      'citizenName': 'فاطمة علي الخفاجي',
      'totalPoints': 890,
      'usedPoints': 300,
      'availablePoints': 590,
      'location': 'الناصرية',
      'lastUpdated': DateTime.now().subtract(Duration(days: 1)),
    },
    {
      'citizenId': 'CIT-003',
      'citizenName': 'خالد إبراهيم السعيدي',
      'totalPoints': 3450,
      'usedPoints': 2000,
      'availablePoints': 1450,
      'location': 'قلعة سكر',
      'lastUpdated': DateTime.now().subtract(Duration(hours: 5)),
    },
    {
      'citizenId': 'CIT-004',
      'citizenName': 'زينب حسن العبودي',
      'totalPoints': 1200,
      'usedPoints': 400,
      'availablePoints': 800,
      'location': 'قلعة سكر',
      'lastUpdated': DateTime.now().subtract(Duration(days: 3)),
    },
  ];
  // بيانات الإشعارات
final List<Map<String, dynamic>> _notifications = [
  {
    'id': 'NOT-001',
    'title': 'عرض جديد مضاف',
    'message': 'تم إضافة عرض "خصم 15% على الفاتورة القادمة" بنجاح',
    'type': 'offer_added',
    'isRead': false,
    'date': DateTime.now().subtract(const Duration(minutes: 5)),
    'icon': Icons.local_offer_rounded,
    'color': Colors.green,
    'action': 'offer',
    'actionId': 'OFR-001',
  },
  {
    'id': 'NOT-002',
    'title': 'هدية جديدة',
    'message': 'تم إضافة هدية "مروحة سقف - صناعة عراقية" إلى المخزون',
    'type': 'gift_added',
    'isRead': false,
    'date': DateTime.now().subtract(const Duration(hours: 1)),
    'icon': Icons.card_giftcard_rounded,
    'color': Colors.blue,
    'action': 'gift',
    'actionId': 'GFT-001',
  },
  {
    'id': 'NOT-003',
    'title': 'نفاذ كمية هدية',
    'message': 'هدية "كوبون خصم 10,000 دينار" نفذت من المخزون',
    'type': 'out_of_stock',
    'isRead': false,
    'date': DateTime.now().subtract(const Duration(hours: 3)),
    'icon': Icons.inventory_rounded,
    'color': Colors.red,
    'action': 'gift',
    'actionId': 'GFT-004',
  },
  {
    'id': 'NOT-004',
    'title': 'طلب استبدال نقاط جديد',
    'message': 'أحمد محمد الجبوري قام بطلب استبدال 800 نقطة مقابل سماعة بلوتوث',
    'type': 'redemption_request',
    'isRead': true,
    'date': DateTime.now().subtract(const Duration(days: 1)),
    'icon': Icons.swap_horiz_rounded,
    'color': Colors.orange,
    'action': 'redemption',
    'actionId': 'RDM-003',
  },
  {
    'id': 'NOT-005',
    'title': 'اكتمال طلب استبدال',
    'message': 'تم اكتمال طلب استبدال النقاط لـ فاطمة علي الخفاجي',
    'type': 'redemption_completed',
    'isRead': true,
    'date': DateTime.now().subtract(const Duration(days: 2)),
    'icon': Icons.check_circle_rounded,
    'color': Colors.green,
    'action': 'redemption',
    'actionId': 'RDM-001',
  },
  {
    'id': 'NOT-006',
    'title': 'اقتراب انتهاء عرض',
    'message': 'عرض "نقاط مضاعفة لأهالي الناصرية" سينتهي بعد 3 أيام',
    'type': 'offer_expiring',
    'isRead': false,
    'date': DateTime.now().subtract(const Duration(hours: 12)),
    'icon': Icons.timer_rounded,
    'color': Colors.amber,
    'action': 'offer',
    'actionId': 'OFR-002',
  },
  {
    'id': 'NOT-007',
    'title': 'تحديث نقاط المواطنين',
    'message': 'تم تحديث نقاط 15 مواطن في قلعة سكر',
    'type': 'points_updated',
    'isRead': true,
    'date': DateTime.now().subtract(const Duration(days: 3)),
    'icon': Icons.emoji_events_rounded,
    'color': Colors.purple,
    'action': 'points',
    'actionId': null,
  },
];

  final List<Map<String, dynamic>> _redemptionHistory = [
    {
      'id': 'RDM-001',
      'citizenName': 'فاطمة علي الخفاجي',
      'giftName': 'لمبة LED موفرة - الناصرية',
      'pointsUsed': 300,
      'date': DateTime.now().subtract(Duration(days: 3)),
      'status': 'completed',
      'location': 'الناصرية',
    },
    {
      'id': 'RDM-002',
      'citizenName': 'خالد إبراهيم السعيدي',
      'giftName': 'مروحة سقف - صناعة عراقية',
      'pointsUsed': 1500,
      'date': DateTime.now().subtract(Duration(days: 10)),
      'status': 'completed',
      'location': 'قلعة سكر',
    },
    {
      'id': 'RDM-003',
      'citizenName': 'أحمد محمد الجبوري',
      'giftName': 'سماعة بلوتوث - قلعة سكر',
      'pointsUsed': 800,
      'date': DateTime.now().subtract(Duration(days: 1)),
      'status': 'pending',
      'location': 'قلعة سكر',
    },
    {
      'id': 'RDM-004',
      'citizenName': 'سارة عبدالله الزهيري',
      'giftName': 'جراب موبايل - قلعة سكر',
      'pointsUsed': 400,
      'date': DateTime.now().subtract(Duration(hours: 2)),
      'status': 'completed',
      'location': 'قلعة سكر',
    },
  ];

  // دوال مساعدة للألوان
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

  String _formatPoints(int points) {
    return NumberFormat('#,##0').format(points);
  }

  // فلترة العروض حسب حالة البحث
  List<Map<String, dynamic>> get _filteredOffers {
    if (_searchQuery.isEmpty) return _offers;
    return _offers.where((offer) {
      return offer['title'].toString().contains(_searchQuery) ||
             offer['description'].toString().contains(_searchQuery) ||
             offer['location'].toString().contains(_searchQuery);
    }).toList();
  }

  // فلترة الهدايا حسب حالة البحث
  List<Map<String, dynamic>> get _filteredGifts {
    if (_searchQuery.isEmpty) return _gifts;
    return _gifts.where((gift) {
      return gift['name'].toString().contains(_searchQuery) ||
             gift['description'].toString().contains(_searchQuery) ||
             gift['location'].toString().contains(_searchQuery);
    }).toList();

  }
  // فلترة العروض حسب النوع (جديدة/قديمة)
List<Map<String, dynamic>> get _newOffers {
  // العروض الجديدة: التي لم تبدأ بعد أو بدأت حديثاً (خلال آخر 7 أيام)
  DateTime sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
  return _filteredOffers.where((offer) {
    return offer['startDate'].isAfter(sevenDaysAgo) || 
           (offer['startDate'].isAfter(DateTime.now().subtract(const Duration(days: 30))) && 
            offer['status'] == 'active');
  }).toList();
}

List<Map<String, dynamic>> get _oldOffers {
  // العروض القديمة: التي مضى على بدايتها أكثر من 7 أيام أو منتهية
  DateTime sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
  return _filteredOffers.where((offer) {
    return offer['startDate'].isBefore(sevenDaysAgo) || offer['status'] == 'inactive';
  }).toList();
}

// فلترة الهدايا حسب النوع (جديدة/قديمة)
List<Map<String, dynamic>> get _newGifts {
  // الهدايا الجديدة: التي تم إضافتها خلال آخر 30 يوم أو تكون متوفرة بكمية جيدة
  return _filteredGifts.where((gift) {
    return gift['status'] == 'available' || gift['status'] == 'limited';
  }).toList();
}

List<Map<String, dynamic>> get _oldGifts {
  // الهدايا القديمة: غير متوفرة أو الكمية منخفضة جداً
  return _filteredGifts.where((gift) {
    return gift['status'] == 'out_of_stock' || gift['quantity'] < 5;
  }).toList();
}

 @override
void initState() {
  super.initState();
  _tabController = TabController(length: 4, vsync: this);
  _offersSubTabController = TabController(length: 2, vsync: this);
  _giftsSubTabController = TabController(length: 2, vsync: this);
}

  @override
void dispose() {
  _tabController.dispose();
  _offersSubTabController.dispose();
  _giftsSubTabController.dispose();
  _searchController.dispose();
  super.dispose();
}

  void _showAddOfferFullScreen() {
  DateTime now = DateTime.now();
  DateTime defaultStartDate = now;
  DateTime defaultEndDate = now.add(const Duration(days: 30));
  
  // متغيرات للتحكم
  String selectedType = 'discount';
  String selectedStatus = 'active';
  
  // متغيرات للنصوص
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController targetAudienceController = TextEditingController(text: 'سكان قلعة سكر');
  TextEditingController locationController = TextEditingController(text: 'قضاء قلعة سكر - الناصرية');
  TextEditingController usageCountController = TextEditingController(text: '0');
  TextEditingController maxUsageController = TextEditingController(text: '500');

  Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Scaffold(
            backgroundColor: _cardColor(context),
            appBar: AppBar(
              backgroundColor: _primaryColor,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'إضافة عرض جديد',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // التحقق من صحة المدخلات
                    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('الرجاء ملء جميع الحقول المطلوبة'),
                          backgroundColor: Color(0xFFD32F2F),
                        ),
                      );
                      return;
                    }

                    // إنشاء عرض جديد
                    Map<String, dynamic> newOffer = {
                      'id': 'OFR-${DateTime.now().millisecondsSinceEpoch}',
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'type': selectedType,
                      'status': selectedStatus,
                      'startDate': DateTime(defaultStartDate.year, defaultStartDate.month, defaultStartDate.day),
                      'endDate': DateTime(defaultEndDate.year, defaultEndDate.month, defaultEndDate.day),
                      'targetAudience': targetAudienceController.text,
                      'location': locationController.text,
                      'usageCount': int.tryParse(usageCountController.text) ?? 0,
                      'maxUsage': int.tryParse(maxUsageController.text) ?? 500,
                      'icon': _getIconForType(selectedType),
                      'color': _getColorForType(selectedType),
                    };

                    setState(() {
                      _offers.add(newOffer);
                    });

                    Navigator.pop(context);
                    _showSuccessSnackbar('تم إضافة العرض بنجاح');
                    
                    // تحديث التبويب إلى العروض الجديدة
                    _tabController.animateTo(0);
                    _offersSubTabController.animateTo(0);
                  },
                  child: const Text(
                    'إضافة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // رأس الصفحة
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _primaryColor,
                          _primaryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.local_offer_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'إضافة عرض جديد',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'قضاء قلعة سكر - الناصرية',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // المعلومات الأساسية
                  const Text(
                    'المعلومات الأساسية',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // عنوان العرض
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _borderColor(context)),
                    ),
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'عنوان العرض *',
                        hintText: 'أدخل عنوان العرض',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                        prefixIcon: Icon(Icons.title_rounded, color: _primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // وصف العرض
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _borderColor(context)),
                    ),
                    child: TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'وصف العرض *',
                        hintText: 'أدخل وصف تفصيلي للعرض',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                        prefixIcon: Icon(Icons.description_rounded, color: _primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // نوع العرض
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _borderColor(context)),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'نوع العرض',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        prefixIcon: Icon(Icons.category_rounded),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'discount', child: Text('خصم')),
                        DropdownMenuItem(value: 'loyalty', child: Text('نقاط مضاعفة')),
                        DropdownMenuItem(value: 'gift', child: Text('هدية')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedType = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // التاريخ
                  const Text(
                    'مدة العرض',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: defaultStartDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                            );
                            if (picked != null) {
                              setState(() {
                                defaultStartDate = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _borderColor(context)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today_rounded, color: _primaryColor),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'تاريخ البداية',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _textSecondaryColor(context),
                                        ),
                                      ),
                                      Text(
                                        DateFormat('yyyy/MM/dd').format(defaultStartDate),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _textColor(context),
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
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: defaultEndDate,
                              firstDate: defaultStartDate,
                              lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                            );
                            if (picked != null) {
                              setState(() {
                                defaultEndDate = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _borderColor(context)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today_rounded, color: _primaryColor),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'تاريخ النهاية',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _textSecondaryColor(context),
                                        ),
                                      ),
                                      Text(
                                        DateFormat('yyyy/MM/dd').format(defaultEndDate),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: _textColor(context),
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
                    ],
                  ),
                  const SizedBox(height: 16),

                  // الجمهور المستهدف
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _borderColor(context)),
                    ),
                    child: TextField(
                      controller: targetAudienceController,
                      decoration: InputDecoration(
                        labelText: 'الجمهور المستهدف',
                        hintText: 'مثال: سكان قلعة سكر',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                        prefixIcon: Icon(Icons.people_alt_rounded, color: _primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // الموقع
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _borderColor(context)),
                    ),
                    child: TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        labelText: 'الموقع',
                        hintText: 'مثال: قضاء قلعة سكر',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                        prefixIcon: Icon(Icons.location_on_rounded, color: _primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // الحالة
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _borderColor(context)),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'الحالة',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        prefixIcon: Icon(Icons.circle_rounded),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'active', child: Text('نشط')),
                        DropdownMenuItem(value: 'inactive', child: Text('غير نشط')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // إحصائيات الاستخدام
                  const Text(
                    'إحصائيات الاستخدام',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _borderColor(context)),
                          ),
                          child: TextField(
                            controller: usageCountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'مرات الاستخدام',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                              prefixIcon: Icon(Icons.trending_up_rounded, color: _primaryColor),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _borderColor(context)),
                          ),
                          child: TextField(
                            controller: maxUsageController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'الحد الأقصى',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                              prefixIcon: Icon(Icons.data_usage_rounded, color: _primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // أزرار الإجراءات في الأسفل
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _textSecondaryColor(context),
                            side: BorderSide(color: _borderColor(context)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('إلغاء'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // التحقق من صحة المدخلات
                            if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('الرجاء ملء جميع الحقول المطلوبة'),
                                  backgroundColor: Color(0xFFD32F2F),
                                ),
                              );
                              return;
                            }

                            // إنشاء عرض جديد
                            Map<String, dynamic> newOffer = {
                              'id': 'OFR-${DateTime.now().millisecondsSinceEpoch}',
                              'title': titleController.text,
                              'description': descriptionController.text,
                              'type': selectedType,
                              'status': selectedStatus,
                              'startDate': DateTime(defaultStartDate.year, defaultStartDate.month, defaultStartDate.day),
                              'endDate': DateTime(defaultEndDate.year, defaultEndDate.month, defaultEndDate.day),
                              'targetAudience': targetAudienceController.text,
                              'location': locationController.text,
                              'usageCount': int.tryParse(usageCountController.text) ?? 0,
                              'maxUsage': int.tryParse(maxUsageController.text) ?? 500,
                              'icon': _getIconForType(selectedType),
                              'color': _getColorForType(selectedType),
                            };

                            setState(() {
                              _offers.add(newOffer);
                            });

                            Navigator.pop(context);
                            _showSuccessSnackbar('تم إضافة العرض بنجاح');
                            
                            // تحديث التبويب إلى العروض الجديدة
                            _tabController.animateTo(0);
                            _offersSubTabController.animateTo(0);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('إضافة العرض'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
IconData _getIconForType(String type) {
  switch (type) {
    case 'discount':
      return Icons.percent_rounded;
    case 'loyalty':
      return Icons.stars_rounded;
    case 'gift':
      return Icons.card_giftcard_rounded;
    default:
      return Icons.local_offer_rounded;
  }
}

Color _getColorForType(String type) {
  switch (type) {
    case 'discount':
      return Colors.green;
    case 'loyalty':
      return Colors.orange;
    case 'gift':
      return Colors.red;
    default:
      return _primaryColor;
  }
}
  void _showAddGiftFullScreen() {
  // متغيرات للتحكم
  String selectedStatus = 'available';
  
  // متغيرات للنصوص
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController pointsController = TextEditingController(text: '500');
  TextEditingController quantityController = TextEditingController(text: '10');
  TextEditingController locationController = TextEditingController(text: 'قضاء قلعة سكر - الناصرية');

  // قائمة الألوان والأيقونات المتاحة
  List<Map<String, dynamic>> giftStyles = [
    {'icon': Icons.toys_rounded, 'color': Colors.blue, 'name': 'لعبة'},
    {'icon': Icons.emoji_objects_rounded, 'color': Colors.amber, 'name': 'لمبة'},
    {'icon': Icons.headphones_rounded, 'color': Colors.green, 'name': 'سماعة'},
    {'icon': Icons.discount_rounded, 'color': Colors.grey, 'name': 'كوبون'},
    {'icon': Icons.phone_android_rounded, 'color': Colors.teal, 'name': 'جراب'},
    {'icon': Icons.watch_rounded, 'color': Colors.purple, 'name': 'ساعة'},
    {'icon': Icons.speaker_rounded, 'color': Colors.orange, 'name': 'سماعة'},
    {'icon': Icons.kitchen_rounded, 'color': Colors.brown, 'name': 'أدوات مطبخ'},
  ];
  
  int selectedStyleIndex = 0;

  Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Scaffold(
            backgroundColor: _cardColor(context),
            appBar: AppBar(
              backgroundColor: _primaryColor,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'إضافة هدية جديدة',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // التحقق من صحة المدخلات
                    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('الرجاء ملء جميع الحقول المطلوبة'),
                          backgroundColor: Color(0xFFD32F2F),
                        ),
                      );
                      return;
                    }

                    // إنشاء هدية جديدة
                    Map<String, dynamic> newGift = {
                      'id': 'GFT-${DateTime.now().millisecondsSinceEpoch}',
                      'name': nameController.text,
                      'description': descriptionController.text,
                      'pointsRequired': int.tryParse(pointsController.text) ?? 500,
                      'quantity': int.tryParse(quantityController.text) ?? 10,
                      'status': selectedStatus,
                      'location': locationController.text,
                      'icon': giftStyles[selectedStyleIndex]['icon'],
                      'color': giftStyles[selectedStyleIndex]['color'],
                    };

                    setState(() {
                      _gifts.add(newGift);
                    });

                    Navigator.pop(context);
                    _showSuccessSnackbar('تم إضافة الهدية بنجاح');
                    
                    // تحديث التبويب إلى الهدايا الجديدة
                    _tabController.animateTo(1);
                    _giftsSubTabController.animateTo(0);
                  },
                  child: const Text(
                    'إضافة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // رأس الصفحة
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _primaryColor,
                          _primaryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.card_giftcard_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'إضافة هدية جديدة',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'برنامج الولاء - قضاء قلعة سكر',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // اختيار نوع الهدية (أيقونة ولون)
                  const Text(
                    'اختر نوع الهدية',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: giftStyles.length,
                      itemBuilder: (context, index) {
                        final style = giftStyles[index];
                        final isSelected = index == selectedStyleIndex;
                        
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedStyleIndex = index;
                            });
                          },
                          child: Container(
                            width: 70,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? (style['color'] as Color).withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected 
                                    ? style['color'] as Color
                                    : _borderColor(context),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  style['icon'] as IconData,
                                  color: isSelected 
                                      ? style['color'] as Color
                                      : _textSecondaryColor(context),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  style['name'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isSelected 
                                        ? style['color'] as Color
                                        : _textSecondaryColor(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // اسم الهدية
                  const Text(
                    'المعلومات الأساسية',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _borderColor(context)),
                    ),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'اسم الهدية *',
                        hintText: 'أدخل اسم الهدية',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                        prefixIcon: Icon(Icons.card_giftcard_rounded, color: _primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // وصف الهدية
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _borderColor(context)),
                    ),
                    child: TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'وصف الهدية *',
                        hintText: 'أدخل وصف تفصيلي للهدية',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                        prefixIcon: Icon(Icons.description_rounded, color: _primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // النقاط والكمية
                  const Text(
                    'تفاصيل الهدية',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _borderColor(context)),
                          ),
                          child: TextField(
                            controller: pointsController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'النقاط المطلوبة',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                              prefixIcon: Icon(Icons.stars_rounded, color: _secondaryColor),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _borderColor(context)),
                          ),
                          child: TextField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'الكمية',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                              prefixIcon: Icon(Icons.inventory_rounded, color: _primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // الموقع
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _borderColor(context)),
                    ),
                    child: TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        labelText: 'الموقع',
                        hintText: 'مثال: قضاء قلعة سكر',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                        prefixIcon: Icon(Icons.location_on_rounded, color: _primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // الحالة
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _borderColor(context)),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'حالة التوفر',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        prefixIcon: Icon(Icons.circle_rounded),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'available', child: Text('متوفر')),
                        DropdownMenuItem(value: 'limited', child: Text('محدود')),
                        DropdownMenuItem(value: 'out_of_stock', child: Text('غير متوفر')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // أزرار الإجراءات في الأسفل
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _textSecondaryColor(context),
                            side: BorderSide(color: _borderColor(context)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('إلغاء'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // التحقق من صحة المدخلات
                            if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('الرجاء ملء جميع الحقول المطلوبة'),
                                  backgroundColor: Color(0xFFD32F2F),
                                ),
                              );
                              return;
                            }

                            // إنشاء هدية جديدة
                            Map<String, dynamic> newGift = {
                              'id': 'GFT-${DateTime.now().millisecondsSinceEpoch}',
                              'name': nameController.text,
                              'description': descriptionController.text,
                              'pointsRequired': int.tryParse(pointsController.text) ?? 500,
                              'quantity': int.tryParse(quantityController.text) ?? 10,
                              'status': selectedStatus,
                              'location': locationController.text,
                              'icon': giftStyles[selectedStyleIndex]['icon'],
                              'color': giftStyles[selectedStyleIndex]['color'],
                            };

                            setState(() {
                              _gifts.add(newGift);
                            });

                            Navigator.pop(context);
                            _showSuccessSnackbar('تم إضافة الهدية بنجاح');
                            
                            // تحديث التبويب إلى الهدايا الجديدة
                            _tabController.animateTo(1);
                            _giftsSubTabController.animateTo(0);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('إضافة الهدية'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
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
            child: Icon(Icons.card_giftcard_rounded, color: _primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'أخصائي الهدايا والعروض',
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
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        // زر الإشعارات مع عداد
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: _showNotificationsScreen,
            ),
            if (_unreadNotificationsCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: _errorColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$_unreadNotificationsCount',
                    style: const TextStyle(
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
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: _secondaryColor,
        indicatorWeight: 4,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.7),
        onTap: (index) {
    // تأكد من تحديث الـ state عند تغيير التبويب
    setState(() {});
  },
        tabs: const [
          Tab(icon: Icon(Icons.local_offer_rounded), text: 'العروض'),
          Tab(icon: Icon(Icons.card_giftcard_rounded), text: 'الهدايا'),
          Tab(icon: Icon(Icons.emoji_events_rounded), text: 'النقاط'),
          Tab(icon: Icon(Icons.history_rounded), text: 'السجل'),
        ],
      ),
    ),
    drawer: _buildOffersDrawer(context, isDarkMode),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [Color(0xFF121212), Color(0xFF1A1A1A)]
                : [Color(0xFFF5F5F5), Color(0xFFE8F5E8)],
          ),
        ),
        child: Column(
          children: [
            // شريط البحث
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: _cardColor(context),
                  border: Border.all(color: _borderColor(context)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: 'بحث عن عروض أو هدايا في قلعة سكر...',
                    prefixIcon: Icon(Icons.search_rounded, color: _textSecondaryColor(context)),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear_rounded, color: _textSecondaryColor(context)),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
            
            // أزرار الإضافة حسب التبويب النشط
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _tabController.index == 0 ? 'العروض المتاحة' : 
                    _tabController.index == 1 ? 'الهدايا المتاحة' :
                    _tabController.index == 2 ? 'نقاط المواطنين' : 'سجل الاستبدال',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _primaryColor,
                    ),
                  ),
if (_tabController.index == 0 || _tabController.index == 1)
  ElevatedButton.icon(
    onPressed: _tabController.index == 0 
        ? _showAddOfferFullScreen   // دالة إضافة العرض Full Screen
        : _showAddGiftFullScreen,   // دالة إضافة الهدية Full Screen
    icon: const Icon(Icons.add_rounded, color: Colors.white),
    label: Text(
      _tabController.index == 0 ? 'إضافة عرض' : 'إضافة هدية',
      style: const TextStyle(color: Colors.white),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: _primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),                ],
              ),
            ),
            SizedBox(height: 8),
            
            // محتوى التبويبات
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOffersTab(context, isDarkMode),
                  _buildGiftsTab(context, isDarkMode),
                  _buildPointsTab(context, isDarkMode),
                  _buildHistoryTab(context, isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // ================ القائمة المنسدلة (Drawer) ================
Widget _buildOffersDrawer(BuildContext context, bool isDarkMode) {
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
                    Icons.card_giftcard_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "أخصائي الهدايا والعروض",
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
                    "عدد العروض: 4 | عدد الهدايا: 5",
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
                      _showOffersSettings(context, isDarkMode);
                    },
                    isDarkMode: isDarkMode,
                  ),
                  
                  _buildDrawerMenuItem(
                    icon: Icons.help_rounded,
                    title: 'المساعدة والدعم',
                    onTap: () {
                      Navigator.pop(context);
                      _showOffersHelpSupport(context, isDarkMode);
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
                          'برنامج الولاء - قضاء قلعة سكر',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.grey[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'نظام إدارة الهدايا والعروض',
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

// إحصائيات سريعة في القائمة
Widget _buildDrawerStats(bool isDarkMode) {
  // حساب الإحصائيات
  int totalOffers = _offers.length;
  int totalGifts = _gifts.length;
  int totalPoints = _citizenPoints.fold(0, (sum, item) => sum + (item['totalPoints'] as int));
  int activeOffers = _offers.where((o) => o['status'] == 'active').length;

  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إحصائيات سريعة',
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.grey[700],
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                icon: Icons.local_offer_rounded,
                label: 'العروض',
                value: '$totalOffers',
                color: Colors.green,
                isDarkMode: isDarkMode,
              ),
            ),
            Expanded(
              child: _buildStatItem(
                icon: Icons.card_giftcard_rounded,
                label: 'الهدايا',
                value: '$totalGifts',
                color: Colors.orange,
                isDarkMode: isDarkMode,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                icon: Icons.emoji_events_rounded,
                label: 'النقاط',
                value: '${_formatPoints(totalPoints)}',
                color: Colors.amber,
                isDarkMode: isDarkMode,
              ),
            ),
            Expanded(
              child: _buildStatItem(
                icon: Icons.check_circle_rounded,
                label: 'نشط',
                value: '$activeOffers',
                color: Colors.blue,
                isDarkMode: isDarkMode,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildStatItem({
  required IconData icon,
  required String label,
  required String value,
  required Color color,
  required bool isDarkMode,
}) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isDarkMode ? Colors.white70 : Colors.grey[700],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildDashboardStatRow(String label, String value, IconData icon, Color color) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
      Text(
        value,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    ],
  );
}

void _showActiveOffersReport(BuildContext context, bool isDarkMode) {
  int active = _offers.where((o) => o['status'] == 'active').length;
  int inactive = _offers.where((o) => o['status'] == 'inactive').length;
  
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: _cardColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'تقرير العروض النشطة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildReportProgress('نشط', active, _offers.length, Colors.green),
            const SizedBox(height: 16),
            _buildReportProgress('غير نشط', inactive, _offers.length, Colors.red),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showTopGiftsReport(BuildContext context, bool isDarkMode) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: _cardColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'أكثر الهدايا استبدالاً',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._gifts.map((gift) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: (gift['color'] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(gift['icon'] as IconData, color: gift['color'], size: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(gift['name'])),
                  Text(
                    '${gift['pointsRequired']} نقطة',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _secondaryColor,
                    ),
                  ),
                ],
              ),
            )).toList(),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showCitizenPointsReport(BuildContext context, bool isDarkMode) {
  // ترتيب المواطنين حسب النقاط
  var sorted = List<Map<String, dynamic>>.from(_citizenPoints)
    ..sort((a, b) => b['totalPoints'].compareTo(a['totalPoints']));
  
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: _cardColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'أعلى المواطنين في النقاط',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...sorted.take(3).map((citizen) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person_rounded, color: _primaryColor, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(citizen['citizenName']),
                        Text(
                          citizen['location'] ?? 'قلعة سكر',
                          style: TextStyle(
                            fontSize: 10,
                            color: _textSecondaryColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${_formatPoints(citizen['totalPoints'])} نقطة',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _secondaryColor,
                    ),
                  ),
                ],
              ),
            )).toList(),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showMonthlyRedemptionReport(BuildContext context, bool isDarkMode) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: _cardColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'تقرير الاستبدال الشهري',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildReportProgress('مكتمل', 
                _redemptionHistory.where((r) => r['status'] == 'completed').length,
                _redemptionHistory.length, Colors.green),
            const SizedBox(height: 16),
            _buildReportProgress('قيد الانتظار', 
                _redemptionHistory.where((r) => r['status'] == 'pending').length,
                _redemptionHistory.length, Colors.orange),
            const SizedBox(height: 20),
            Text(
              'إجمالي النقاط المستبدلة: ${_formatPoints(_redemptionHistory.fold(0, (sum, item) => sum + (item['pointsUsed'] as int)))}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _secondaryColor,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildReportProgress(String label, int value, int total, Color color) {
  double percentage = total > 0 ? value / total : 0;
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label: $value'),
          Text('${(percentage * 100).toStringAsFixed(0)}%'),
        ],
      ),
      const SizedBox(height: 4),
      Container(
        height: 8,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerRight,
          widthFactor: percentage,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    ],
  );
}
void _showOfferDetailsFullScreen(Map<String, dynamic> offer) {
  Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => Scaffold(
        backgroundColor: _cardColor(context),
        appBar: AppBar(
          backgroundColor: _primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'تفاصيل العرض',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_rounded, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                _showEditOfferFullScreen(offer);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس العرض
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _primaryColor,
                      _primaryColor.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        offer['icon'] as IconData,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            offer['location'] ?? 'قضاء قلعة سكر - الناصرية',
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

              const SizedBox(height: 24),

              // معلومات العرض
              _buildFullScreenSection(
                'وصف العرض',
                Icons.description_rounded,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer['description'],
                      style: TextStyle(
                        fontSize: 16,
                        color: _textColor(context),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // تفاصيل العرض
              _buildFullScreenSection(
                'تفاصيل العرض',
                Icons.info_rounded,
                Column(
                  children: [
                    _buildFullScreenInfoRow('نوع العرض', _getOfferTypeName(offer['type']), Icons.category_rounded),
                    const Divider(),
                    _buildFullScreenInfoRow('تاريخ البداية', DateFormat('yyyy/MM/dd').format(offer['startDate']), Icons.calendar_today_rounded),
                    const Divider(),
                    _buildFullScreenInfoRow('تاريخ النهاية', DateFormat('yyyy/MM/dd').format(offer['endDate']), Icons.calendar_today_rounded),
                    const Divider(),
                    _buildFullScreenInfoRow('الجمهور المستهدف', offer['targetAudience'], Icons.people_alt_rounded),
                    const Divider(),
                    _buildFullScreenInfoRow('الموقع', offer['location'] ?? 'قلعة سكر', Icons.location_on_rounded),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // إحصائيات الاستخدام
              _buildFullScreenSection(
                'إحصائيات الاستخدام',
                Icons.bar_chart_rounded,
                Column(
                  children: [
                    _buildFullScreenInfoRow('مرات الاستخدام', '${offer['usageCount']}', Icons.trending_up_rounded),
                    const Divider(),
                    _buildFullScreenInfoRow('الحد الأقصى', '${offer['maxUsage']}', Icons.data_usage_rounded),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: (offer['usageCount'] / offer['maxUsage']).clamp(0.0, 1.0),
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'نسبة الاستخدام: ${((offer['usageCount'] / offer['maxUsage']) * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: _primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // الحالة
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (offer['status'] == 'active' ? _successColor : _errorColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (offer['status'] == 'active' ? _successColor : _errorColor).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      offer['status'] == 'active' ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      color: offer['status'] == 'active' ? _successColor : _errorColor,
                      size: 30,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'حالة العرض',
                            style: TextStyle(
                              fontSize: 12,
                              color: _textSecondaryColor(context),
                            ),
                          ),
                          Text(
                            offer['status'] == 'active' ? 'نشط' : 'غير نشط',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: offer['status'] == 'active' ? _successColor : _errorColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // أزرار الإجراءات
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showEditOfferFullScreen(offer);
                      },
                      icon: const Icon(Icons.edit_rounded),
                      label: const Text('تعديل العرض'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showDeleteOfferConfirmation(offer);
                      },
                      icon: const Icon(Icons.delete_rounded),
                      label: const Text('حذف العرض'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _errorColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
}
void _showEditOfferFullScreen(Map<String, dynamic> offer) {
  // متغيرات للتحكم
  String selectedType = offer['type'];
  String selectedStatus = offer['status'];
  DateTime startDate = offer['startDate'];
  DateTime endDate = offer['endDate'];
  
  // متغيرات للنصوص
  TextEditingController titleController = TextEditingController(text: offer['title']);
  TextEditingController descriptionController = TextEditingController(text: offer['description']);
  TextEditingController targetAudienceController = TextEditingController(text: offer['targetAudience']);
  TextEditingController locationController = TextEditingController(text: offer['location']);
  TextEditingController usageCountController = TextEditingController(text: offer['usageCount'].toString());
  TextEditingController maxUsageController = TextEditingController(text: offer['maxUsage'].toString());

  Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              backgroundColor: _cardColor(context),
              appBar: AppBar(
                backgroundColor: _primaryColor,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text(
                  'تعديل العرض',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // حفظ التعديلات
                      final updatedOffer = {
                        ...offer,
                        'title': titleController.text,
                        'description': descriptionController.text,
                        'type': selectedType,
                        'status': selectedStatus,
                        'startDate': startDate,
                        'endDate': endDate,
                        'targetAudience': targetAudienceController.text,
                        'location': locationController.text,
                        'usageCount': int.tryParse(usageCountController.text) ?? offer['usageCount'],
                        'maxUsage': int.tryParse(maxUsageController.text) ?? offer['maxUsage'],
                      };

                      // تحديث في القائمة الرئيسية
                      setState(() {
                        final index = _offers.indexWhere((o) => o['id'] == offer['id']);
                        if (index != -1) {
                          _offers[index] = updatedOffer;
                        }
                      });

                      Navigator.pop(context);
                      _showSuccessSnackbar('تم تعديل العرض بنجاح');
                    },
                    child: const Text(
                      'حفظ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان
                    const Text(
                      'المعلومات الأساسية',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'عنوان العرض',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.title_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'وصف العرض',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.description_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // نوع العرض
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: 'نوع العرض',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.category_rounded),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'discount', child: Text('خصم')),
                        DropdownMenuItem(value: 'loyalty', child: Text('نقاط مضاعفة')),
                        DropdownMenuItem(value: 'gift', child: Text('هدية')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // التاريخ
                    const Text(
                      'مدة العرض',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: startDate,
                                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                              );
                              if (picked != null) {
                                setState(() {
                                  startDate = picked;
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'تاريخ البداية',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: const Icon(Icons.calendar_today_rounded),
                              ),
                              child: Text(DateFormat('yyyy/MM/dd').format(startDate)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: endDate,
                                firstDate: startDate,
                                lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                              );
                              if (picked != null) {
                                setState(() {
                                  endDate = picked;
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'تاريخ النهاية',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: const Icon(Icons.calendar_today_rounded),
                              ),
                              child: Text(DateFormat('yyyy/MM/dd').format(endDate)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // الجمهور المستهدف
                    TextField(
                      controller: targetAudienceController,
                      decoration: InputDecoration(
                        labelText: 'الجمهور المستهدف',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.people_alt_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),

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
                    const SizedBox(height: 16),

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
                      items: const [
                        DropdownMenuItem(value: 'active', child: Text('نشط')),
                        DropdownMenuItem(value: 'inactive', child: Text('غير نشط')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // الاستخدام
                    const Text(
                      'إحصائيات الاستخدام',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: usageCountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'مرات الاستخدام',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: maxUsageController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'الحد الأقصى',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // أزرار الإجراءات في الأسفل
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _textSecondaryColor(context),
                              side: BorderSide(color: _borderColor(context)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('إلغاء'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // حفظ التعديلات
                              final updatedOffer = {
                                ...offer,
                                'title': titleController.text,
                                'description': descriptionController.text,
                                'type': selectedType,
                                'status': selectedStatus,
                                'startDate': startDate,
                                'endDate': endDate,
                                'targetAudience': targetAudienceController.text,
                                'location': locationController.text,
                                'usageCount': int.tryParse(usageCountController.text) ?? offer['usageCount'],
                                'maxUsage': int.tryParse(maxUsageController.text) ?? offer['maxUsage'],
                              };

                              // تحديث في القائمة الرئيسية
                              this.setState(() {
                                final index = _offers.indexWhere((o) => o['id'] == offer['id']);
                                if (index != -1) {
                                  _offers[index] = updatedOffer;
                                }
                              });

                              Navigator.pop(context);
                              _showSuccessSnackbar('تم تعديل العرض بنجاح');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('حفظ التغييرات'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
Widget _buildDetailItem(String label, String value, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: _primaryColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: _textSecondaryColor(context),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: _textColor(context),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

String _getOfferTypeName(String type) {
  switch (type) {
    case 'discount':
      return 'خصم';
    case 'loyalty':
      return 'نقاط مضاعفة';
    case 'gift':
      return 'هدية';
    default:
      return type;
  }
}
void _showSuccessSnackbar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: _successColor,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
void _showDeleteOfferConfirmation(Map<String, dynamic> offer) {
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
        'هل أنت متأكد من حذف العرض "${offer['title']}"؟',
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
              _offers.removeWhere((e) => e['id'] == offer['id']);
            });
            Navigator.pop(context);
            _showSuccessSnackbar('تم حذف العرض بنجاح');
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

// ========== دوال عرض التفاصيل والتعديل للهدايا ==========
void _showGiftDetails(Map<String, dynamic> gift) {
  Color statusColor;
  String statusText;
  
  switch (gift['status']) {
    case 'available':
      statusColor = _successColor;
      statusText = 'متوفر';
      break;
    case 'limited':
      statusColor = _warningColor;
      statusText = 'محدود';
      break;
    case 'out_of_stock':
      statusColor = _errorColor;
      statusText = 'غير متوفر';
      break;
    default:
      statusColor = _successColor;
      statusText = 'متوفر';
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // شريط العنوان
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _primaryColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(gift['icon'] as IconData, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    gift['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          // المحتوى القابل للتمرير
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // معلومات قضاء قلعة سكر
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _secondaryColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_city_rounded, color: _secondaryColor, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'قضاء قلعة سكر - الناصرية',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _secondaryColor,
                                ),
                              ),
                              Text(
                                gift['location'] ?? 'محافظة ذي قار',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _secondaryColor.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // صورة الهدية (افتراضية)
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: (gift['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: NetworkImage('https://via.placeholder.com/400x200'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        gift['icon'] as IconData,
                        size: 80,
                        color: (gift['color'] as Color).withOpacity(0.5),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // تفاصيل الهدية
                  const Text(
                    'تفاصيل الهدية',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 16),
                  
                  _buildDetailItem('الوصف', gift['description'], Icons.description_rounded),
                  
                  const SizedBox(height: 16),
                  
                  // بطاقة النقاط والكمية
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _secondaryColor.withOpacity(0.2),
                          _primaryColor.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Icon(Icons.stars_rounded, color: _secondaryColor, size: 32),
                              const SizedBox(height: 8),
                              Text(
                                'النقاط المطلوبة',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _textSecondaryColor(context),
                                ),
                              ),
                              Text(
                                _formatPoints(gift['pointsRequired']),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _secondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 1,
                          color: _borderColor(context),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Icon(Icons.inventory_rounded, color: _primaryColor, size: 32),
                              const SizedBox(height: 8),
                              Text(
                                'الكمية المتوفرة',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _textSecondaryColor(context),
                                ),
                              ),
                              Text(
                                '${gift['quantity']}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: _primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // الحالة
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          gift['status'] == 'available' ? Icons.check_circle_rounded :
                          gift['status'] == 'limited' ? Icons.warning_rounded : Icons.cancel_rounded,
                          color: statusColor,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'حالة التوفر',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _textSecondaryColor(context),
                                ),
                              ),
                              Text(
                                statusText,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // الأزرار
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _showEditGiftFullScreen(gift);
                          },
                          icon: const Icon(Icons.edit_rounded),
                          label: const Text('تعديل الهدية'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _primaryColor,
                            side: BorderSide(color: _primaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _showDeleteGiftConfirmation(gift);
                          },
                          icon: const Icon(Icons.delete_rounded),
                          label: const Text('حذف الهدية'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _errorColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
void _showDeleteGiftConfirmation(Map<String, dynamic> gift) {
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
        'هل أنت متأكد من حذف الهدية "${gift['name']}"؟',
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
              _gifts.removeWhere((e) => e['id'] == gift['id']);
            });
            Navigator.pop(context);
            _showSuccessSnackbar('تم حذف الهدية بنجاح');
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
// ================ نظام الإشعارات ================
void _showNotificationsScreen() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => OffersNotificationsScreen(
        primaryColor: _primaryColor,
        secondaryColor: _secondaryColor,
        accentColor: _accentColor,
        successColor: _successColor,
        warningColor: _warningColor,
        errorColor: _errorColor,
        notifications: _notifications,
        onNotificationTap: _handleNotificationTap,
        onMarkAsRead: _markNotificationAsRead,
        onMarkAllAsRead: _markAllNotificationsAsRead,
        onDeleteNotification: _deleteNotification,
      ),
    ),
  );
}

void _handleNotificationTap(Map<String, dynamic> notification) {
  // تحديث حالة القراءة
  _markNotificationAsRead(notification['id']);
  
  // التنقل حسب نوع الإشعار
  switch (notification['action']) {
    case 'offer':
      final offer = _offers.firstWhere(
        (o) => o['id'] == notification['actionId'],
        orElse: () => _offers.first,
      );
      _showOfferDetailsFullScreen(offer);
      break;
      
    case 'gift':
      final gift = _gifts.firstWhere(
        (g) => g['id'] == notification['actionId'],
        orElse: () => _gifts.first,
      );
      _showGiftDetailsFullScreen(gift);
      break;
      
    case 'redemption':
      final redemption = _redemptionHistory.firstWhere(
        (r) => r['id'] == notification['actionId'],
        orElse: () => _redemptionHistory.first,
      );
      _showRedemptionDetails(redemption);
      break;
      
    case 'points':
      _tabController.animateTo(2); // الانتقال لتبويب النقاط
      break;
  }
}
void _showGiftDetailsFullScreen(Map<String, dynamic> gift) {
  Color statusColor;
  String statusText;
  
  switch (gift['status']) {
    case 'available':
      statusColor = _successColor;
      statusText = 'متوفر';
      break;
    case 'limited':
      statusColor = _warningColor;
      statusText = 'محدود';
      break;
    case 'out_of_stock':
      statusColor = _errorColor;
      statusText = 'غير متوفر';
      break;
    default:
      statusColor = _successColor;
      statusText = 'متوفر';
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => Scaffold(
        backgroundColor: _cardColor(context),
        appBar: AppBar(
          backgroundColor: _primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'تفاصيل الهدية',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_rounded, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                _showEditGiftFullScreen(gift);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس الهدية
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _primaryColor,
                      _primaryColor.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        gift['icon'] as IconData,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            gift['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            gift['location'] ?? 'قضاء قلعة سكر - الناصرية',
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

              const SizedBox(height: 24),

              // صورة الهدية
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: (gift['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/400x200'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Icon(
                    gift['icon'] as IconData,
                    size: 80,
                    color: (gift['color'] as Color).withOpacity(0.5),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // وصف الهدية
              _buildFullScreenSection(
                'وصف الهدية',
                Icons.description_rounded,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gift['description'],
                      style: TextStyle(
                        fontSize: 16,
                        color: _textColor(context),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // تفاصيل الهدية
              _buildFullScreenSection(
                'تفاصيل الهدية',
                Icons.info_rounded,
                Column(
                  children: [
                    _buildFullScreenInfoRow('النقاط المطلوبة', '${_formatPoints(gift['pointsRequired'])} نقطة', Icons.stars_rounded),
                    const Divider(),
                    _buildFullScreenInfoRow('الكمية المتوفرة', '${gift['quantity']}', Icons.inventory_rounded),
                    const Divider(),
                    _buildFullScreenInfoRow('الموقع', gift['location'] ?? 'قلعة سكر', Icons.location_on_rounded),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // حالة التوفر
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      gift['status'] == 'available' ? Icons.check_circle_rounded :
                      gift['status'] == 'limited' ? Icons.warning_rounded : Icons.cancel_rounded,
                      color: statusColor,
                      size: 30,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'حالة التوفر',
                            style: TextStyle(
                              fontSize: 12,
                              color: _textSecondaryColor(context),
                            ),
                          ),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // أزرار الإجراءات
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showEditGiftFullScreen(gift);
                      },
                      icon: const Icon(Icons.edit_rounded),
                      label: const Text('تعديل الهدية'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showDeleteGiftConfirmation(gift);
                      },
                      icon: const Icon(Icons.delete_rounded),
                      label: const Text('حذف الهدية'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _errorColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
}
void _showEditGiftFullScreen(Map<String, dynamic> gift) {
  // متغيرات للتحكم
  String selectedStatus = gift['status'];
  
  // متغيرات للنصوص
  TextEditingController nameController = TextEditingController(text: gift['name']);
  TextEditingController descriptionController = TextEditingController(text: gift['description']);
  TextEditingController pointsController = TextEditingController(text: gift['pointsRequired'].toString());
  TextEditingController quantityController = TextEditingController(text: gift['quantity'].toString());
  TextEditingController locationController = TextEditingController(text: gift['location']);

  Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              backgroundColor: _cardColor(context),
              appBar: AppBar(
                backgroundColor: _primaryColor,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text(
                  'تعديل الهدية',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // حفظ التعديلات
                      final updatedGift = {
                        ...gift,
                        'name': nameController.text,
                        'description': descriptionController.text,
                        'pointsRequired': int.tryParse(pointsController.text) ?? gift['pointsRequired'],
                        'quantity': int.tryParse(quantityController.text) ?? gift['quantity'],
                        'location': locationController.text,
                        'status': selectedStatus,
                      };

                      // تحديث في القائمة الرئيسية
                      this.setState(() {
                        final index = _gifts.indexWhere((g) => g['id'] == gift['id']);
                        if (index != -1) {
                          _gifts[index] = updatedGift;
                        }
                      });

                      Navigator.pop(context);
                      _showSuccessSnackbar('تم تعديل الهدية بنجاح');
                    },
                    child: const Text(
                      'حفظ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم الهدية
                    const Text(
                      'المعلومات الأساسية',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'اسم الهدية',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.card_giftcard_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // الوصف
                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'وصف الهدية',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.description_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // النقاط والكمية
                    const Text(
                      'تفاصيل الهدية',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: pointsController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'النقاط المطلوبة',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.stars_rounded),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'الكمية',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.inventory_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

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
                    const SizedBox(height: 16),

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
                      items: const [
                        DropdownMenuItem(value: 'available', child: Text('متوفر')),
                        DropdownMenuItem(value: 'limited', child: Text('محدود')),
                        DropdownMenuItem(value: 'out_of_stock', child: Text('غير متوفر')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 30),

                    // أزرار الإجراءات في الأسفل
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _textSecondaryColor(context),
                              side: BorderSide(color: _borderColor(context)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('إلغاء'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // حفظ التعديلات
                              final updatedGift = {
                                ...gift,
                                'name': nameController.text,
                                'description': descriptionController.text,
                                'pointsRequired': int.tryParse(pointsController.text) ?? gift['pointsRequired'],
                                'quantity': int.tryParse(quantityController.text) ?? gift['quantity'],
                                'location': locationController.text,
                                'status': selectedStatus,
                              };

                              // تحديث في القائمة الرئيسية
                              this.setState(() {
                                final index = _gifts.indexWhere((g) => g['id'] == gift['id']);
                                if (index != -1) {
                                  _gifts[index] = updatedGift;
                                }
                              });

                              Navigator.pop(context);
                              _showSuccessSnackbar('تم تعديل الهدية بنجاح');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('حفظ التغييرات'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
void _markNotificationAsRead(String notificationId) {
  setState(() {
    final index = _notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      _notifications[index]['isRead'] = true;
    }
  });
}

void _markAllNotificationsAsRead() {
  setState(() {
    for (var notification in _notifications) {
      notification['isRead'] = true;
    }
  });
  _showSuccessSnackbar('تم تحديد الكل كمقروء');
}

void _deleteNotification(String notificationId) {
  setState(() {
    _notifications.removeWhere((n) => n['id'] == notificationId);
  });
  _showSuccessSnackbar('تم حذف الإشعار');
}

void _showRedemptionDetails(Map<String, dynamic> redemption) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: _cardColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.swap_horiz_rounded, color: _secondaryColor),
                ),
                const SizedBox(width: 12),
                const Text(
                  'تفاصيل طلب الاستبدال',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            _buildDetailRow('المواطن', redemption['citizenName'], Icons.person_rounded, context),
            _buildDetailRow('الهدية', redemption['giftName'], Icons.card_giftcard_rounded, context),
            _buildDetailRow('النقاط', '${_formatPoints(redemption['pointsUsed'])} نقطة', Icons.stars_rounded, context),
            _buildDetailRow('التاريخ', DateFormat('yyyy/MM/dd').format(redemption['date']), Icons.calendar_today_rounded, context),
            _buildDetailRow('الموقع', redemption['location'] ?? 'قلعة سكر', Icons.location_on_rounded, context),
            
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (redemption['status'] == 'completed' ? _successColor : _warningColor).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (redemption['status'] == 'completed' ? _successColor : _warningColor).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    redemption['status'] == 'completed' ? Icons.check_circle_rounded : Icons.access_time_rounded,
                    color: redemption['status'] == 'completed' ? _successColor : _warningColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'الحالة: ${redemption['status'] == 'completed' ? 'مكتمل' : 'قيد الانتظار'}',
                    style: TextStyle(
                      color: redemption['status'] == 'completed' ? _successColor : _warningColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
          ],
        ),
      ),
    ),
  );
}
// دالة مساعدة لعرض التفاصيل
Widget _buildDetailRow(String label, String value, IconData icon, BuildContext context, {int maxLines = 1}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _primaryColor, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: _textColor(context),
              ),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: value,
                ),
              ],
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
// ========== إعدادات أخصائي الهدايا والعروض ==========
void _showOffersSettings(BuildContext context, bool isDarkMode) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => OffersSettingsScreen(
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

// ========== المساعدة والدعم لأخصائي الهدايا والعروض ==========
void _showOffersHelpSupport(BuildContext context, bool isDarkMode) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => OffersHelpSupportScreen(
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
  // ==================== تبويب العروض مع تبويبات فرعية ====================
Widget _buildOffersTab(BuildContext context, bool isDarkMode) {
  return Column(
    children: [
      // التبويبات الفرعية للعروض
      Container(
        decoration: BoxDecoration(
          color: _cardColor(context),
          border: Border(
            bottom: BorderSide(color: _borderColor(context), width: 1),
          ),
        ),
        child: TabBar(
          controller: _offersSubTabController,
          indicatorColor: _secondaryColor,
          indicatorWeight: 3,
          labelColor: _primaryColor,
          unselectedLabelColor: _textSecondaryColor(context),
          tabs: const [
            Tab(
              icon: Icon(Icons.fiber_new_rounded),
              text: 'عروض جديدة',
            ),
            Tab(
              icon: Icon(Icons.history_rounded),
              text: 'عروض سابقة',
            ),
          ],
        ),
      ),
      
      // محتوى التبويبات الفرعية
      Expanded(
        child: TabBarView(
          controller: _offersSubTabController,
          children: [
            // العروض الجديدة
            _buildOffersList(_newOffers, context, isDarkMode, isNew: true),
            // العروض القديمة
            _buildOffersList(_oldOffers, context, isDarkMode, isNew: false),
          ],
        ),
      ),
    ],
  );
}

Widget _buildOffersList(List<Map<String, dynamic>> offers, BuildContext context, bool isDarkMode, {required bool isNew}) {
  if (offers.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isNew ? Icons.fiber_new_rounded : Icons.history_rounded,
            size: 64,
            color: _textSecondaryColor(context),
          ),
          const SizedBox(height: 16),
          Text(
            isNew ? 'لا توجد عروض جديدة' : 'لا توجد عروض سابقة',
            style: TextStyle(
              fontSize: 18,
              color: _textSecondaryColor(context),
            ),
          ),
          const SizedBox(height: 8),
          if (isNew)
            ElevatedButton(
              onPressed: _showAddOfferFullScreen   ,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('إضافة عرض جديد'),
            ),
        ],
      ),
    );
  }

  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: offers.length,
    itemBuilder: (context, index) {
      final offer = offers[index];
      return _buildOfferCard(offer, context, isDarkMode, isNew: isNew);
    },
  );
}
  Widget _buildOfferCard(Map<String, dynamic> offer, BuildContext context, bool isDarkMode, {bool isNew = false}) {
  bool isActive = offer['status'] == 'active';
  Color statusColor = isActive ? _successColor : _errorColor;
  String statusText = isActive ? 'نشط' : 'غير نشط';
  
  // حساب نسبة الاستخدام
  double usagePercentage = (offer['usageCount'] / offer['maxUsage']).clamp(0.0, 1.0);
  
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: _cardColor(context),
      border: Border.all(color: _borderColor(context)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Stack(
      children: [
        // علامة "جديد" للعروض الجديدة
        if (isNew)
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _secondaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.fiber_new_rounded, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'جديد',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (offer['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(offer['icon'] as IconData, color: offer['color'], size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: _textColor(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        offer['description'],
                        style: TextStyle(
                          fontSize: 12,
                          color: _textSecondaryColor(context),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              ],
            ),
            const SizedBox(height: 12),
            
            // معلومات الموقع
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on_rounded, size: 14, color: _primaryColor),
                  const SizedBox(width: 4),
                  Text(
                    offer['location'] ?? 'قضاء قلعة سكر - الناصرية',
                    style: TextStyle(
                      fontSize: 11,
                      color: _primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // شريط التقدم للاستخدام
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الاستخدام: ${offer['usageCount']}/${offer['maxUsage']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondaryColor(context),
                      ),
                    ),
                    Text(
                      '${(usagePercentage * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  height: 8,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _borderColor(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerRight,
                    widthFactor: usagePercentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // تواريخ العرض
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 14, color: _textSecondaryColor(context)),
                const SizedBox(width: 4),
                Text(
                  'من: ${DateFormat('yyyy-MM-dd').format(offer['startDate'])}',
                  style: TextStyle(fontSize: 11, color: _textSecondaryColor(context)),
                ),
                const SizedBox(width: 12),
                Icon(Icons.calendar_today_rounded, size: 14, color: _textSecondaryColor(context)),
                const SizedBox(width: 4),
                Text(
                  'إلى: ${DateFormat('yyyy-MM-dd').format(offer['endDate'])}',
                  style: TextStyle(fontSize: 11, color: _textSecondaryColor(context)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // الجمهور المستهدف
            Row(
              children: [
                Icon(Icons.people_alt_rounded, size: 14, color: _textSecondaryColor(context)),
                const SizedBox(width: 4),
                Text(
                  'الجمهور: ${offer['targetAudience']}',
                  style: TextStyle(fontSize: 12, color: _textSecondaryColor(context)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // أزرار الإجراءات
Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    OutlinedButton(
      onPressed: () => _showEditOfferFullScreen(offer),
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryColor,
        side: BorderSide(color: _primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: const Text('تعديل'),
    ),
    const SizedBox(width: 8),
    ElevatedButton(
      onPressed: () => _showOfferDetailsFullScreen(offer),
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: const Text('عرض التفاصيل'),
    ),
  ],
),
          ],
        ),
      ],
    ),
  );
}
Widget _buildFullScreenSection(String title, IconData icon, Widget content) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _cardColor(context),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _borderColor(context)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: _primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        content,
      ],
    ),
  );
}

Widget _buildFullScreenInfoRow(String label, String value, IconData icon) {
  return Row(
    children: [
      Icon(icon, color: _primaryColor, size: 20),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            color: _textSecondaryColor(context),
          ),
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: _textColor(context),
        ),
      ),
    ],
  );
}
  // ==================== تبويب الهدايا مع تبويبات فرعية ====================
Widget _buildGiftsTab(BuildContext context, bool isDarkMode) {
  return Column(
    children: [
      // التبويبات الفرعية للهدايا
      Container(
        decoration: BoxDecoration(
          color: _cardColor(context),
          border: Border(
            bottom: BorderSide(color: _borderColor(context), width: 1),
          ),
        ),
        child: TabBar(
          controller: _giftsSubTabController,
          indicatorColor: _secondaryColor,
          indicatorWeight: 3,
          labelColor: _primaryColor,
          unselectedLabelColor: _textSecondaryColor(context),
          tabs: const [
            Tab(
              icon: Icon(Icons.card_giftcard_rounded),
              text: 'هدايا جديدة',
            ),
            Tab(
              icon: Icon(Icons.inventory_rounded),
              text: 'هدايا سابقة',
            ),
          ],
        ),
      ),
      
      // محتوى التبويبات الفرعية
      Expanded(
        child: TabBarView(
          controller: _giftsSubTabController,
          children: [
            // الهدايا الجديدة
            _buildGiftsList(_newGifts, context, isDarkMode, isNew: true),
            // الهدايا القديمة
            _buildGiftsList(_oldGifts, context, isDarkMode, isNew: false),
          ],
        ),
      ),
    ],
  );
}

Widget _buildGiftsList(List<Map<String, dynamic>> gifts, BuildContext context, bool isDarkMode, {required bool isNew}) {
  if (gifts.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isNew ? Icons.card_giftcard_rounded : Icons.inventory_rounded,
            size: 64,
            color: _textSecondaryColor(context),
          ),
          const SizedBox(height: 16),
          Text(
            isNew ? 'لا توجد هدايا جديدة' : 'لا توجد هدايا سابقة',
            style: TextStyle(
              fontSize: 18,
              color: _textSecondaryColor(context),
            ),
          ),
          const SizedBox(height: 8),
          if (isNew)
            ElevatedButton(
              onPressed: _showAddGiftFullScreen,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('إضافة هدية جديدة'),
            ),
        ],
      ),
    );
  }

  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: gifts.length,
    itemBuilder: (context, index) {
      final gift = gifts[index];
      return _buildGiftCard(gift, context, isDarkMode, isNew: isNew);
    },
  );
}
  Widget _buildGiftCard(Map<String, dynamic> gift, BuildContext context, bool isDarkMode, {bool isNew = false}) {
  Color statusColor;
  String statusText;
  
  switch (gift['status']) {
    case 'available':
      statusColor = _successColor;
      statusText = 'متوفر';
      break;
    case 'limited':
      statusColor = _warningColor;
      statusText = 'محدود';
      break;
    case 'out_of_stock':
      statusColor = _errorColor;
      statusText = 'غير متوفر';
      break;
    default:
      statusColor = _successColor;
      statusText = 'متوفر';
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: _cardColor(context),
      border: Border.all(color: _borderColor(context)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Stack(
      children: [
        // علامة "جديد" للهدايا الجديدة
        if (isNew)
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _secondaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.fiber_new_rounded, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'جديد',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (gift['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(gift['icon'] as IconData, color: gift['color'], size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gift['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: _textColor(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        gift['description'],
                        style: TextStyle(
                          fontSize: 12,
                          color: _textSecondaryColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              ],
            ),
            const SizedBox(height: 12),
            
            // معلومات الموقع
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on_rounded, size: 14, color: _primaryColor),
                  const SizedBox(width: 4),
                  Text(
                    gift['location'] ?? 'قضاء قلعة سكر - الناصرية',
                    style: TextStyle(
                      fontSize: 11,
                      color: _primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // تفاصيل الهدية
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.stars_rounded, color: _secondaryColor, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'النقاط المطلوبة: ${_formatPoints(gift['pointsRequired'])}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _secondaryColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.inventory_rounded, color: _primaryColor, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'الكمية: ${gift['quantity']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // أزرار الإجراءات
Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    OutlinedButton(
      onPressed: () => _showEditGiftFullScreen(gift),
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryColor,
        side: BorderSide(color: _primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: const Text('تعديل'),
    ),
    const SizedBox(width: 8),
    ElevatedButton(
      onPressed: () => _showGiftDetails(gift),
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: const Text('عرض التفاصيل'),
    ),
  ],
),
          ],
        ),
      ],
    ),
  );
}

  // ==================== تبويب النقاط ====================
  Widget _buildPointsTab(BuildContext context, bool isDarkMode) {
    // حساب إحصائيات النقاط
    int totalPoints = _citizenPoints.fold(0, (sum, item) => sum + (item['totalPoints'] as int));
    int usedPoints = _citizenPoints.fold(0, (sum, item) => sum + (item['usedPoints'] as int));
    int availablePoints = _citizenPoints.fold(0, (sum, item) => sum + (item['availablePoints'] as int));
    return Column(
      children: [
        // بطاقة إحصائيات النقاط
        Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _cardColor(context),
            border: Border.all(color: _borderColor(context)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPointsStat(_formatPoints(totalPoints), 'إجمالي النقاط', Icons.emoji_events_rounded, _secondaryColor),
              _buildPointsStat(_formatPoints(usedPoints), 'النقاط المستخدمة', Icons.remove_circle_rounded, _warningColor),
              _buildPointsStat(_formatPoints(availablePoints), 'النقاط المتاحة', Icons.check_circle_rounded, _successColor),
            ],
          ),
        ),
        
        // قائمة نقاط المواطنين
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _citizenPoints.length,
            itemBuilder: (context, index) {
              final citizen = _citizenPoints[index];
              return _buildCitizenPointsCard(citizen, context, isDarkMode);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPointsStat(String value, String title, IconData icon, Color color) {
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

  Widget _buildCitizenPointsCard(Map<String, dynamic> citizen, BuildContext context, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        border: Border.all(color: _borderColor(context)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_rounded, color: _primaryColor, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      citizen['citizenName'],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: _textColor(context),
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 12, color: _textSecondaryColor(context)),
                        SizedBox(width: 2),
                        Text(
                          citizen['location'] ?? 'قلعة سكر',
                          style: TextStyle(
                            fontSize: 11,
                            color: _textSecondaryColor(context),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'آخر تحديث: ${DateFormat('yyyy-MM-dd').format(citizen['lastUpdated'])}',
                          style: TextStyle(
                            fontSize: 11,
                            color: _textSecondaryColor(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          
          // شريط تقدم النقاط
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'النقاط المتاحة: ${_formatPoints(citizen['availablePoints'])}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _successColor,
                ),
              ),
              Text(
                'إجمالي: ${_formatPoints(citizen['totalPoints'])}',
                style: TextStyle(
                  color: _textSecondaryColor(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          
          // شريط التقدم
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _borderColor(context),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerRight,
              widthFactor: citizen['availablePoints'] / citizen['totalPoints'],
              child: Container(
                decoration: BoxDecoration(
                  color: _successColor,
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
                'النقاط المستخدمة: ${_formatPoints(citizen['usedPoints'])}',
                style: TextStyle(
                  fontSize: 11,
                  color: _warningColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== تبويب السجل ====================
  Widget _buildHistoryTab(BuildContext context, bool isDarkMode) {
    if (_redemptionHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_rounded, size: 64, color: _textSecondaryColor(context)),
            SizedBox(height: 16),
            Text(
              'لا يوجد سجل استبدال',
              style: TextStyle(
                fontSize: 18,
                color: _textSecondaryColor(context),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _redemptionHistory.length,
      itemBuilder: (context, index) {
        final record = _redemptionHistory[index];
        return _buildHistoryCard(record, context, isDarkMode);
      },
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> record, BuildContext context, bool isDarkMode) {
    bool isPending = record['status'] == 'pending';
    Color statusColor = isPending ? _warningColor : _successColor;
    String statusText = isPending ? 'قيد الانتظار' : 'مكتمل';

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _cardColor(context),
        border: Border.all(color: _borderColor(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isPending ? _warningColor.withOpacity(0.1) : _successColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPending ? Icons.access_time_rounded : Icons.check_circle_rounded,
              color: isPending ? _warningColor : _successColor,
              size: 24,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record['citizenName'],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: _textColor(context),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  record['giftName'],
                  style: TextStyle(
                    fontSize: 12,
                    color: _textSecondaryColor(context),
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.stars_rounded, size: 14, color: _secondaryColor),
                    SizedBox(width: 4),
                    Text(
                      '${_formatPoints(record['pointsUsed'])} نقطة',
                      style: TextStyle(
                        fontSize: 12,
                        color: _secondaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.location_on_rounded, size: 12, color: _textSecondaryColor(context)),
                    SizedBox(width: 2),
                    Text(
                      record['location'] ?? 'قلعة سكر',
                      style: TextStyle(
                        fontSize: 11,
                        color: _textSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 12, color: _textSecondaryColor(context)),
                    SizedBox(width: 4),
                    Text(
                      DateFormat('yyyy-MM-dd').format(record['date']),
                      style: TextStyle(
                        fontSize: 11,
                        color: _textSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
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
        ],
      ),
    );
  }
}
// ========== شاشة إعدادات أخصائي الهدايا والعروض ==========
class OffersSettingsScreen extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;

  const OffersSettingsScreen({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.successColor,
    required this.warningColor,
    required this.errorColor,
  }) : super(key: key);

  @override
  State<OffersSettingsScreen> createState() => _OffersSettingsScreenState();
}

class _OffersSettingsScreenState extends State<OffersSettingsScreen> {
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
          'الإعدادات - برنامج الولاء',
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
                'استلام إشعارات حول العروض والهدايا الجديدة',
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
                'نسخ احتياطي تلقائي لبيانات العروض والهدايا',
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
          _buildAboutRow('المطور', 'برنامج الولاء - قضاء قلعة سكر', isDarkMode),
          _buildAboutRow('رقم الترخيص', 'LP-QSS-2024-001', isDarkMode),
          _buildAboutRow('آخر تحديث', '2024-03-15', isDarkMode),
          _buildAboutRow('البريد الإلكتروني', 'loyalty.qss@electric.gov.iq', isDarkMode),
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

// ========== شاشة المساعدة والدعم لأخصائي الهدايا والعروض ==========
class OffersHelpSupportScreen extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;

  const OffersHelpSupportScreen({
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
          'المساعدة والدعم - برنامج الولاء',
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
              _buildSectionTitle('معلومات البرنامج', isDarkMode),
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
                  'دعم برنامج الولاء - قلعة سكر',
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
          _buildContactItem(Icons.phone_rounded, 'استفسارات النقاط', '07862268895', true, context, isDarkMode),
          _buildContactItem(Icons.email_rounded, 'البريد الإلكتروني', 'loyalty.qss@electric.gov.iq', false, context, isDarkMode),
          _buildContactItem(Icons.access_time_rounded, 'ساعات العمل', '8:00 ص - 4:00 م', false, context, isDarkMode),
          _buildContactItem(Icons.location_on_rounded, 'العنوان', 'قضاء قلعة سكر - مبنى البلدية', false, context, isDarkMode),
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
        builder: (context) => OffersSupportChatScreen(
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
        'question': 'كيف يمكنني إضافة عرض جديد في قلعة سكر؟',
        'answer': 'من الشاشة الرئيسية، انقر على زر + أو اختر "إضافة عرض" من قائمة العروض، ثم املأ بيانات العرض (العنوان، الوصف، نوع العرض، التاريخ، الجمهور المستهدف) واضغط على إضافة.'
      },
      {
        'question': 'كيف تعمل نقاط الولاء؟',
        'answer': 'يكتسب المواطنون نقاطاً عند دفع الفواتير. كل 1000 دينار = نقطة واحدة. يمكن استبدال النقاط بالهدايا المتوفرة في برنامج الولاء.'
      },
      {
        'question': 'ما هي الهدايا المتوفرة في قلعة سكر؟',
        'answer': 'يتوفر لدينا هدايا متنوعة: مروحة سقف (1500 نقطة)، لمبة LED (300 نقطة)، سماعة بلوتوث (800 نقطة)، جراب موبايل (400 نقطة)، وكوبونات خصم.'
      },
      {
        'question': 'كيف يمكنني متابعة استبدال النقاط؟',
        'answer': 'يمكنك متابعة طلبات الاستبدال من خلال تبويب "السجل" حيث تظهر حالة كل طلب (مكتمل أو قيد الانتظار).'
      },
      {
        'question': 'ماذا أفعل إذا نفدت كمية هدية معينة؟',
        'answer': 'يمكنك تحديث المخزون من خلال قسم "إدارة المخزون" في القائمة الرئيسية، أو إضافة هدية جديدة بنفس المواصفات.'
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
          _buildInfoRow('المطور', 'برنامج الولاء - قضاء قلعة سكر', isDarkMode),
          _buildInfoRow('رقم الترخيص', 'LP-QSS-2024-001', isDarkMode),
          _buildInfoRow('آخر تحديث', '2024-03-15', isDarkMode),
          _buildInfoRow('عدد العروض', '4 عروض', isDarkMode),
          _buildInfoRow('عدد الهدايا', '5 هدايا', isDarkMode),
          _buildInfoRow('إجمالي النقاط', '6,680 نقطة', isDarkMode),
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

// ========== شاشة محادثة الدعم لأخصائي الهدايا والعروض ==========
class OffersSupportChatScreen extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;

  const OffersSupportChatScreen({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  _OffersSupportChatScreenState createState() => _OffersSupportChatScreenState();
}

class _OffersSupportChatScreenState extends State<OffersSupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'مرحباً! مركز دعم برنامج الولاء - قلعة سكر. كيف يمكنني مساعدتك اليوم؟',
      'isUser': false,
      'time': 'الآن',
      'sender': 'فريق دعم الولاء'
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
            'text': 'شكراً لتواصلك مع دعم برنامج الولاء. سيتم الرد على استفسارك حول العروض والهدايا في أقرب وقت ممكن.',
            'isUser': false,
            'time': 'الآن',
            'sender': 'فريق دعم الولاء'
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
              'دعم برنامج الولاء',
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
                  child: Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'فريق دعم الولاء',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'متخصصون في العروض والهدايا',
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
                        hintText: 'اكتب استفسارك عن العروض والهدايا...',
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
              child: Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 16),
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
// ========== شاشة الإشعارات لأخصائي الهدايا والعروض ==========
class OffersNotificationsScreen extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;
  final List<Map<String, dynamic>> notifications;
  final Function(Map<String, dynamic>) onNotificationTap;
  final Function(String) onMarkAsRead;
  final Function() onMarkAllAsRead;
  final Function(String) onDeleteNotification;

  const OffersNotificationsScreen({
    Key? key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.successColor,
    required this.warningColor,
    required this.errorColor,
    required this.notifications,
    required this.onNotificationTap,
    required this.onMarkAsRead,
    required this.onMarkAllAsRead,
    required this.onDeleteNotification,
  }) : super(key: key);

  @override
  State<OffersNotificationsScreen> createState() => _OffersNotificationsScreenState();
}

class _OffersNotificationsScreenState extends State<OffersNotificationsScreen> {
  String _filterType = 'الكل';
  final List<String> _filterTypes = ['الكل', 'غير مقروء', 'عروض', 'هدايا', 'نقاط', 'استبدال'];

  List<Map<String, dynamic>> get _filteredNotifications {
    return widget.notifications.where((notification) {
      switch (_filterType) {
        case 'غير مقروء':
          return !notification['isRead'];
        case 'عروض':
          return notification['type'].contains('offer');
        case 'هدايا':
          return notification['type'].contains('gift');
        case 'نقاط':
          return notification['type'].contains('points');
        case 'استبدال':
          return notification['type'].contains('redemption');
        default:
          return true;
      }
    }).toList();
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return DateFormat('yyyy/MM/dd').format(date);
    }
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
                border: Border.all(color: widget.secondaryColor, width: 2),
              ),
              child: Icon(Icons.notifications_rounded, color: widget.primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'الإشعارات',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: widget.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded, color: Colors.white),
            onPressed: widget.onMarkAllAsRead,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [const Color(0xFF121212), const Color(0xFF1A1A1A)]
                : [const Color(0xFFF5F5F5), const Color(0xFFE8F5E8)],
          ),
        ),
        child: Column(
          children: [
            // شريط التصفية
            Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filterTypes.map((type) {
                    final isSelected = type == _filterType;
                    return Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: FilterChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            _filterType = type;
                          });
                        },
                        selectedColor: widget.primaryColor.withOpacity(0.2),
                        checkmarkColor: widget.primaryColor,
                        labelStyle: TextStyle(
                          color: isSelected ? widget.primaryColor : (isDarkMode ? Colors.white70 : Colors.black87),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // قائمة الإشعارات
            Expanded(
              child: _filteredNotifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_rounded,
                            size: 80,
                            color: isDarkMode ? Colors.white24 : Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لا توجد إشعارات',
                            style: TextStyle(
                              fontSize: 18,
                              color: isDarkMode ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ستظهر هنا الإشعارات الجديدة',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white38 : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = _filteredNotifications[index];
                        return _buildNotificationCard(notification, isDarkMode);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, bool isDarkMode) {
    final isRead = notification['isRead'] as bool;
    final timeAgo = _getTimeAgo(notification['date']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isRead 
            ? (isDarkMode ? const Color(0xFF1E1E1E) : Colors.white)
            : widget.primaryColor.withOpacity(0.05),
        border: Border.all(
          color: isRead 
              ? (isDarkMode ? Colors.white24 : Colors.grey[300]!)
              : widget.primaryColor.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: (notification['color'] as Color).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            notification['icon'] as IconData,
            color: notification['color'],
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification['title'],
                style: TextStyle(
                  fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ),
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: widget.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification['message'],
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 12,
                  color: isDarkMode ? Colors.white38 : Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  timeAgo,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDarkMode ? Colors.white38 : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded, color: isDarkMode ? Colors.white70 : Colors.grey[600]),
          onSelected: (value) {
            if (value == 'mark_read' && !isRead) {
              widget.onMarkAsRead(notification['id']);
            } else if (value == 'delete') {
              widget.onDeleteNotification(notification['id']);
            }
          },
          itemBuilder: (context) => [
            if (!isRead)
              PopupMenuItem(
                value: 'mark_read',
                child: Row(
                  children: [
                    Icon(Icons.mark_chat_read_rounded, color: widget.primaryColor),
                    const SizedBox(width: 8),
                    const Text('تحديد كمقروء'),
                  ],
                ),
              ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_rounded, color: widget.errorColor),
                  const SizedBox(width: 8),
                  const Text('حذف'),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          if (!isRead) {
            widget.onMarkAsRead(notification['id']);
          }
          widget.onNotificationTap(notification);
          Navigator.pop(context);
        },
      ),
    );
  }
}