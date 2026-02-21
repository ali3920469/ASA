import 'package:flutter/material.dart';

class AppDeveloper extends StatelessWidget {
  const AppDeveloper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مطور البرنامج'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // بطاقة نظرة عامة
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'نظرة عامة على النظام',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      children: [
                        _buildStatCard('الإصدار', '2.5.1', Icons.code),
                        _buildStatCard('المستخدمين', '1,234', Icons.people),
                        _buildStatCard('الميزات', '48', Icons.featured_play_list),
                        _buildStatCard('التقييم', '4.8', Icons.star),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // تطوير الميزات
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'الميزات قيد التطوير',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(Icons.developer_mode, color: Colors.blue),
                      title: const Text('لوحة تحكم متقدمة'),
                      subtitle: const Text('تحسين واجهة التحكم'),
                      trailing: Chip(
                        label: const Text('قيد التطوير'),
                        backgroundColor: Colors.orange[100],
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.analytics, color: Colors.green),
                      title: const Text('تقارير تفاعلية'),
                      subtitle: const Text('إضافة مخططات تفاعلية'),
                      trailing: Chip(
                        label: const Text('قيد التطوير'),
                        backgroundColor: Colors.orange[100],
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.notifications, color: Colors.purple),
                      title: const Text('نظام إشعارات متقدم'),
                      subtitle: const Text('إشعارات في الوقت الحقيقي'),
                      trailing: Chip(
                        label: const Text('جاهز'),
                        backgroundColor: Colors.green[100],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // سجلات الأخطاء
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'سجلات الأخطاء',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(Icons.error, color: Colors.red),
                      title: const Text('خطأ في الواجهة'),
                      subtitle: const Text('مشكلة في عرض القوائم'),
                      trailing: Text(
                        'منذ 2 يوم',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.warning, color: Colors.orange),
                      title: const Text('تحسين الأداء'),
                      subtitle: const Text('تحسين سرعة التحميل'),
                      trailing: Text(
                        'منذ 5 أيام',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.bug_report, color: Colors.blue),
                      title: const Text('إصلاح الخلل'),
                      subtitle: const Text('تحميل البيانات'),
                      trailing: Text(
                        'منذ أسبوع',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // أدوات التطوير
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'أدوات التطوير',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildToolButton('تحليل الكود', Icons.analytics, Colors.blue),
                        _buildToolButton('اختبار الواجهة', Icons.play_arrow, Colors.green),
                        _buildToolButton('تتبع الأخطاء', Icons.bug_report, Colors.red),
                        _buildToolButton('مراجعة الأمان', Icons.security, Colors.purple),
                        _buildToolButton('تحسين الأداء', Icons.speed, Colors.orange),
                        _buildToolButton('نسخ احتياطي', Icons.backup, Colors.teal),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // إحصائيات التطوير
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'إحصائيات التطوير',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDevStat('سطور الكود', '15,432'),
                        ),
                        Expanded(
                          child: _buildDevStat('الواجهات', '32'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDevStat('المساهمين', '4'),
                        ),
                        Expanded(
                          child: _buildDevStat('ساعات التطوير', '240'),
                        ),
                      ],
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

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      color: Colors.teal.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.teal, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolButton(String label, IconData icon, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDevStat(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
