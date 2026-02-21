import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WastePremiumSpecialistScreen extends StatefulWidget {
  const WastePremiumSpecialistScreen({super.key});

  @override
  State<WastePremiumSpecialistScreen> createState() => _WastePremiumSpecialistScreenState();
}

class _WastePremiumSpecialistScreenState extends State<WastePremiumSpecialistScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  
  // الألوان المخصصة لموظف النفايات المميزة (تم التعديل)
  final Color _primaryColor = const Color.fromARGB(255, 28, 195, 167); // أخضر نيلي داكن
  final Color _secondaryColor = const Color.fromARGB(255, 0, 137, 89); // أخضر نيلي
  final Color _accentColor = const Color(0xFF4DB6AC); // أخضر نيلي فاتح
  final Color _backgroundColor = const Color(0xFFE0F2F1); // أخضر فاتح جداً
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color.fromARGB(255, 38, 53, 56);
  final Color _textSecondaryColor = const Color.fromARGB(255, 120, 156, 140);
  
  // البيانات الوهمية
  final List<Map<String, dynamic>> _premiumRequests = [
    {
      'id': 'PR001',
      'customer': 'أحمد محمد',
      'service': 'تنظيف مميز',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'معلق',
      'priority': 'عالي',
    },
    {
      'id': 'PR002',
      'customer': 'سارة عبدالله',
      'service': 'إعادة تدوير',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'قيد التنفيذ',
      'priority': 'متوسط',
    },
    {
      'id': 'PR003',
      'customer': 'خالد السعدي',
      'service': 'جمع نفايات خطرة',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'مكتمل',
      'priority': 'عالي',
    },
    {
      'id': 'PR004',
      'customer': 'فاطمة الزهراء',
      'service': 'تدوير إلكتروني',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'status': 'مكتمل',
      'priority': 'منخفض',
    },
  ];
  
  final List<Map<String, dynamic>> _services = [
    {
      'title': 'الطلبات المميزة',
      'icon': Icons.workspace_premium,
      'count': 12,
      'color': Color(0xFFFFD700), // ذهبي
    },
    {
      'title': 'المهام اليومية',
      'icon': Icons.task_alt,
      'count': 8,
      'color': Color(0xFF42A5F5), // أزرق
    },
    {
      'title': 'التقارير',
      'icon': Icons.analytics,
      'count': 5,
      'color': Color(0xFFAB47BC), // بنفسجي
    },
    {
      'title': 'العملاء المميزين',
      'icon': Icons.people_alt,
      'count': 15,
      'color': Color(0xFF66BB6A), // أخضر
    },
  ];

  // ========== نظام التقارير من الكود الأول ==========
  // بيانات التقارير - محدثة لمجال النفايات
  final List<Map<String, dynamic>> reports = [
    {
      'id': 'REP-2024-001',
      'title': 'تقرير الإيرادات الشهري للنفايات',
      'type': 'مالي',
      'period': 'يناير 2024',
      'generatedDate': DateTime.now().subtract(Duration(days: 2)),
      'totalRevenue': 5000000, // الإيراد الكلي
      'totalBills': 200, // إجمالي الفواتير
      'paidBills': 180, // الفواتير المدفوعة
    },
    {
      'id': 'REP-2024-002',
      'title': 'تقرير الفواتير المستلمة',
      'type': 'مالي',
      'period': 'يناير 2024', // نفس الفترة
      'generatedDate': DateTime.now().subtract(Duration(days: 5)),
      'receivedInvoices': '180 فاتورة', // نفس paidBills من التقرير الأول
      'totalReceivedAmount': '4,500,000 درهم', // جزء من الإيراد الكلي
      'averageReceivedAmount': '25,000 درهم/فاتورة'
    },
    {
      'id': 'REP-2024-003',
      'title': 'تقرير المدفوعات المتأخرة',
      'type': 'متابعة',
      'period': 'يناير 2024', // نفس الفترة
      'generatedDate': DateTime.now().subtract(Duration(days: 1)),
      'overdueAmount': 500000, // المتبقي ليكمل الإيراد الكلي
      'overdueBills': 20, // نفس (totalBills - paidBills)
    },
  ];

  String _formatCurrency(dynamic amount) {
    double numericAmount = 0.0;
    if (amount is int) {
      numericAmount = amount.toDouble();
    } else if (amount is double) {
      numericAmount = amount;
    } else if (amount is String) {
      numericAmount = double.tryParse(amount) ?? 0.0;
    }
    
    return '${NumberFormat('#,##0').format(numericAmount)} ';
  }

  String _getBillStatusText(String status) {
    switch (status) {
      case 'paid':
        return 'مدفوعة';
      case 'unpaid':
        return 'غير مدفوعة';
      case 'overdue':
        return 'متأخرة';
      default:
        return 'غير معروف';
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text(
          'خدمات النفايات المميزة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          unselectedLabelStyle: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7)),
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'لوحة التحكم'),
            Tab(icon: Icon(Icons.list_alt), text: 'الطلبات'),
            Tab(icon: Icon(Icons.bar_chart), text: 'التقارير'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildRequestsTab(),
          _buildReportsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewRequestDialog(context);
        },
        backgroundColor: _primaryColor,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بطاقة الترحيب
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor, _secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'مرحباً بك،',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'موظف خدمات النفايات المميزة',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.notifications_active, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildStatCard('مهمة اليوم', 5, Icons.today, Colors.amber),
                      const SizedBox(width: 12),
                      _buildStatCard('مكتملة', 23, Icons.check_circle, Colors.green),
                      const SizedBox(width: 12),
                      _buildStatCard('معلقة', 7, Icons.pending_actions, Colors.orange),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // الخدمات السريعة
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'الخدمات السريعة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor),
            ),
          ),
          const SizedBox(height: 16),
          
          // استخدام GridView بمقاسات محسنة
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2, // نسبة محسنة
            ),
            itemCount: _services.length,
            itemBuilder: (context, index) {
              final service = _services[index];
              return _buildServiceCard(service);
            },
          ),
          
          const SizedBox(height: 24),
          
          // الطلبات الحديثة
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الطلبات الحديثة',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor),
                ),
                TextButton(
                  onPressed: () {
                    _tabController.animateTo(1);
                  },
                  child: Text(
                    'عرض الكل',
                    style: TextStyle(color: _primaryColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _premiumRequests.take(3).length,
            itemBuilder: (context, index) {
              final request = _premiumRequests[index];
              return _buildRequestItem(request, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // الحل الأساسي للمشكلة
            children: [
              // الأيقونة - بحجم مناسب
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: service['color'].withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(service['icon'], color: service['color'], size: 22),
              ),
              const SizedBox(height: 8),
              // العنوان - بحجم مناسب
              Text(
                service['title'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              // العدد - بحجم بارز
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${service['count']}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'ابحث في الطلبات...',
              prefixIcon: Icon(Icons.search, color: _textSecondaryColor),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _premiumRequests.length,
            itemBuilder: (context, index) {
              final request = _premiumRequests[index];
              return _buildRequestItem(request, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRequestItem(Map<String, dynamic> request, int index) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.info;
    
    if (request['status'] == 'معلق') {
      statusColor = Colors.orange;
      statusIcon = Icons.pending;
    } else if (request['status'] == 'قيد التنفيذ') {
      statusColor = Colors.blue;
      statusIcon = Icons.schedule;
    } else if (request['status'] == 'مكتمل') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    }
    
    Color priorityColor = Colors.grey;
    if (request['priority'] == 'عالي') {
      priorityColor = Colors.red;
    } else if (request['priority'] == 'متوسط') {
      priorityColor = Colors.orange;
    } else if (request['priority'] == 'منخفض') {
      priorityColor = Colors.green;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.work_outline, color: _primaryColor, size: 26),
        ),
        title: Text(
          request['customer'],
          style: TextStyle(fontWeight: FontWeight.bold, color: _textColor, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(request['service'], style: TextStyle(fontSize: 14)),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: _textSecondaryColor),
                const SizedBox(width: 4),
                Text(
                  DateFormat('yyyy-MM-dd').format(request['date']),
                  style: TextStyle(fontSize: 12, color: _textSecondaryColor),
                ),
              ],
            ),
          ],
        ),
        trailing: SizedBox(
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, color: statusColor, size: 12),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        request['status'],
                        style: TextStyle(
                          color: statusColor, 
                          fontSize: 10, 
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  request['priority'],
                  style: TextStyle(
                    color: priorityColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          _showRequestDetails(request);
        },
      ),
    );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تقارير أداء خدمات النفايات المميزة',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor),
          ),
          const SizedBox(height: 8),
          Text(
            'تحليل شامل لأداء الخدمات المميزة',
            style: TextStyle(fontSize: 14, color: _textSecondaryColor),
          ),
          const SizedBox(height: 24),
          
          // إحصائيات سريعة
          Row(
            children: [
              Expanded(
                child: _buildReportStatCard('إجمالي الطلبات', '142', Icons.request_page, _primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildReportStatCard('طلبات هذا الشهر', '24', Icons.calendar_month, _secondaryColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildReportStatCard('معدل الإنجاز', '87%', Icons.trending_up, Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildReportStatCard('رضا العملاء', '4.8/5', Icons.star, Colors.amber),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // تقارير نوعية
          Text(
            'التقارير النوعية',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor),
          ),
          const SizedBox(height: 12),
          
          _buildReportItem('تقرير الأداء الشهري', Icons.description, 'يحتوي على إحصائيات الأداء للشهر الحالي'),
          _buildReportItem('تقرير رضا العملاء', Icons.sentiment_satisfied_alt, 'تحليل لاستبيانات رضا العملاء'),
          _buildReportItem('تقرير الطلبات المعلقة', Icons.pending_actions, 'الطلبات التي تحتاج لمتابعة'),
          _buildReportItem('تقرير التكاليف', Icons.attach_money, 'تحليل للتكاليف والإيرادات'),
          
          // عرض التقارير من النظام الأول
          const SizedBox(height: 24),
          Text(
            'تقارير النظام المالي للنفايات',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor),
          ),
          const SizedBox(height: 12),
          
          ...reports.map((report) => _buildReportListItem(report)).toList(),
          
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: Icon(Icons.add_chart, color: Colors.white),
              label: const Text('إنشاء تقرير جديد', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  
  Widget _buildReportStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
                Icon(Icons.more_vert, color: _textSecondaryColor, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: _textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildReportItem(String title, IconData icon, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: _primaryColor),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: _textColor)),
        subtitle: Text(description, style: TextStyle(fontSize: 12, color: _textSecondaryColor)),
        trailing: Icon(Icons.arrow_forward_ios, color: _textSecondaryColor, size: 16),
        onTap: () {},
      ),
    );
  }

  Widget _buildReportListItem(Map<String, dynamic> report) {
    Color typeColor = report['type'] == 'مالي' ? Colors.green : Colors.orange;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: typeColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            report['type'] == 'مالي' ? Icons.attach_money : Icons.timeline,
            color: typeColor,
          ),
        ),
        title: Text(
          report['title'],
          style: TextStyle(fontWeight: FontWeight.bold, color: _textColor),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: _textSecondaryColor),
                const SizedBox(width: 4),
                Text(
                  report['period'],
                  style: TextStyle(fontSize: 12, color: _textSecondaryColor),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'رقم التقرير: ${report['id']}',
              style: TextStyle(fontSize: 11, color: _textSecondaryColor),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: typeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            report['type'],
            style: TextStyle(
              color: typeColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          _showReportDetails(report);
        },
      ),
    );
  }

  void _showReportDetails(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              report['type'] == 'مالي' ? Icons.attach_money : Icons.timeline,
              color: report['type'] == 'مالي' ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            Text('تفاصيل التقرير: ${report['id']}'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('العنوان:', report['title']),
              _buildDetailRow('النوع:', report['type']),
              _buildDetailRow('الفترة:', report['period']),
              _buildDetailRow('تاريخ الإنشاء:', DateFormat('yyyy-MM-dd').format(report['generatedDate'])),
              
              const SizedBox(height: 16),
              
              // عرض البيانات المالية الإضافية
              if (report['totalRevenue'] != null)
                _buildDetailRow('الإيراد الكلي:', '${_formatCurrency(report['totalRevenue'])}درهم'),
              if (report['totalBills'] != null)
                _buildDetailRow('إجمالي الفواتير:', '${report['totalBills']} فاتورة'),
              if (report['paidBills'] != null)
                _buildDetailRow('الفواتير المدفوعة:', '${report['paidBills']} فاتورة'),
              if (report['receivedInvoices'] != null)
                _buildDetailRow('الفواتير المستلمة:', report['receivedInvoices']),
              if (report['totalReceivedAmount'] != null)
                _buildDetailRow('إجمالي المبلغ المستلم:', report['totalReceivedAmount']),
              if (report['averageReceivedAmount'] != null)
                _buildDetailRow('متوسط المبلغ المستلم:', report['averageReceivedAmount']),
              if (report['overdueAmount'] != null)
                _buildDetailRow('المبلغ المتأخر:', '${_formatCurrency(report['overdueAmount'])}درهم'),
              if (report['overdueBills'] != null)
                _buildDetailRow('الفواتير المتأخرة:', '${report['overdueBills']} فاتورة'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم تحميل التقرير: ${report['title']}'),
                  backgroundColor: _primaryColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
            child: const Text('تحميل PDF'),
          ),
        ],
      ),
    );
  }

  void _showRequestDetails(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.request_page, color: _primaryColor),
            const SizedBox(width: 8),
            Text('تفاصيل الطلب: ${request['id']}'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('العميل:', request['customer']),
              _buildDetailRow('الخدمة:', request['service']),
              _buildDetailRow('الحالة:', request['status']),
              _buildDetailRow('الأولوية:', request['priority']),
              _buildDetailRow('التاريخ:', DateFormat('yyyy-MM-dd HH:mm').format(request['date'])),
              const SizedBox(height: 16),
              const Text(
                'ملاحظات إضافية:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق.',
                style: TextStyle(fontSize: 14, color: _textSecondaryColor),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
            child: const Text('تحديث الحالة'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: _textColor),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showNewRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.add_circle, color: _primaryColor, size: 28),
                  const SizedBox(width: 8),
                  const Text(
                    'طلب خدمة جديدة',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'اسم العميل',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'نوع الخدمة',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'الأولوية',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                ),
                items: ['منخفض', 'متوسط', 'عالي']
                    .map((priority) => DropdownMenuItem(value: priority, child: Text(priority)))
                    .toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('تم إنشاء الطلب بنجاح'),
                          backgroundColor: _primaryColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('إنشاء'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
