import 'package:flutter/material.dart';

class AccountAuditorHome extends StatefulWidget {
  const AccountAuditorHome({super.key});

  @override
  State<AccountAuditorHome> createState() => _AccountAuditorHomeState();
}

class _AccountAuditorHomeState extends State<AccountAuditorHome> {
  // قائمة محاكاة لطلبات إنشاء الحسابات
  List<AccountRequest> requests = [
    AccountRequest(
      id: 'REQ-001', 
      employeeName: 'أحمد محمد العلي',
      employeeId: 'EMP-2023-001',
      department: 'هندسة الصيانة',
      position: 'مهندس كهرباء',
      requestedBy: 'مدير الموارد البشرية',
      requestDate: DateTime.now().subtract(const Duration(days: 2)),
      status: 'pending',
    ),
    AccountRequest(
      id: 'REQ-002',
      employeeName: 'سارة خالد الحربي',
      employeeId: 'EMP-2023-002',
      department: 'المحاسبة',
      position: 'محاسب أول',
      requestedBy: 'رئيس قسم المحاسبة',
      requestDate: DateTime.now().subtract(const Duration(days: 1)),
      status: 'pending',
      notes: 'تحتاج صلاحيات خاصة للوصول إلى التقارير المالية',
    ), 
      AccountRequest(
      id: 'REQ-003',
      employeeName: 'فهد عبدالله القحطاني',
      employeeId: 'EMP-2023-003',
      department: 'التشغيل',
      position: 'فني تشغيل',
      requestedBy: 'مدير قسم التشغيل',
      requestDate: DateTime.now().subtract(const Duration(hours: 5)),
      status: 'approved',
    ),
    AccountRequest(
      id: 'REQ-004',
      employeeName: 'نورة سعد السعد',
      employeeId: 'EMP-2023-004',
      department: 'خدمة العملاء',
      position: 'ممثل خدمة عملاء',
      requestedBy: 'رئيس قسم خدمة العملاء',
      requestDate: DateTime.now().subtract(const Duration(days: 3)),
      status: 'rejected',
      notes: 'الموظف لم يكمل أوراق التوثيق المطلوبة',
    ),
  ];

  List<AccountRequest> filteredRequests = [];
  String filterStatus = 'all'; // all, pending, approved, rejected

  @override
  void initState() {
    super.initState();
    filteredRequests = requests;
  }

  void filterRequests(String status) {
    setState(() {
      filterStatus = status;
      if (status == 'all') {
        filteredRequests = requests;
      } else {
        filteredRequests =
            requests.where((request) => request.status == status).toList();
      }
    });
  }

  void approveRequest(String requestId) {
    setState(() {
      int index = requests.indexWhere((req) => req.id == requestId);
      if (index != -1) {
        requests[index] = AccountRequest(
          id: requests[index].id,
          employeeName: requests[index].employeeName,
          employeeId: requests[index].employeeId,
          department: requests[index].department,
          position: requests[index].position,
          requestedBy: requests[index].requestedBy,
          requestDate: requests[index].requestDate,
          status: 'approved',
          notes: requests[index].notes,
        );
        filterRequests(filterStatus);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تمت الموافقة على إنشاء الحساب بنجاح'),
            backgroundColor: Colors.green[700],
          ),
        );
      }
    });
  }

  void rejectRequest(String requestId) {
    showDialog(
      context: context,
      builder: (context) => RejectDialog(
        onReject: (reason) {
          setState(() {
            int index = requests.indexWhere((req) => req.id == requestId);
            if (index != -1) {
              requests[index] = AccountRequest(
                id: requests[index].id,
                employeeName: requests[index].employeeName,
                employeeId: requests[index].employeeId,
                department: requests[index].department,
                position: requests[index].position,
                requestedBy: requests[index].requestedBy,
                requestDate: requests[index].requestDate,
                status: 'rejected',
                notes: reason,
              );
              filterRequests(filterStatus);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('تم رفض طلب إنشاء الحساب'),
                  backgroundColor: Colors.red[700],
                ),
              );
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'لوحة تحكم محرر الحسابات',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تحديث البيانات'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // بطاقة إحصائية
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('الطلبات المعلقة', 
                      requests.where((r) => r.status == 'pending').length,
                      Colors.orange),
                    _buildStatCard('الطلبات المقبولة', 
                      requests.where((r) => r.status == 'approved').length,
                      Colors.green),
                    _buildStatCard('الطلبات المرفوضة', 
                      requests.where((r) => r.status == 'rejected').length,
                      Colors.red),
                    _buildStatCard('إجمالي الطلبات', 
                      requests.length,
                      Colors.blue),
                  ],
                ),
              ),
            ),
          ),

          // فلترة الطلبات
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilterChip(
                      label: const Text('الكل'),
                      selected: filterStatus == 'all',
                      onSelected: (_) => filterRequests('all'),
                    ),
                    FilterChip(
                      label: const Text('معلق'),
                      selected: filterStatus == 'pending',
                      onSelected: (_) => filterRequests('pending'),
                      selectedColor: Colors.orange[100],
                    ),
                    FilterChip(
                      label: const Text('مقبول'),
                      selected: filterStatus == 'approved',
                      onSelected: (_) => filterRequests('approved'),
                      selectedColor: Colors.green[100],
                    ),
                    FilterChip(
                      label: const Text('مرفوض'),
                      selected: filterStatus == 'rejected',
                      onSelected: (_) => filterRequests('rejected'),
                      selectedColor: Colors.red[100],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // عنوان القائمة
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'طلبات إنشاء الحسابات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  'عدد النتائج: ${filteredRequests.length}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // قائمة الطلبات
          Expanded(
            child: filteredRequests.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'لا توجد طلبات لعرضها',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: filteredRequests.length,
                    itemBuilder: (context, index) {
                      return _buildRequestCard(filteredRequests[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, int count, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getStatIcon(title),
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
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
    );
  }

  IconData _getStatIcon(String title) {
    switch (title) {
      case 'الطلبات المعلقة':
        return Icons.pending_actions;
      case 'الطلبات المقبولة':
        return Icons.check_circle;
      case 'الطلبات المرفوضة':
        return Icons.cancel;
      default:
        return Icons.list_alt;
    }
  }

  Widget _buildRequestCard(AccountRequest request) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (request.status) {
      case 'approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'مقبول';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'مرفوض';
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        statusText = 'معلق';
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(request.id),
                  backgroundColor: Colors.blue[50],
                ),
                Chip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 4),
                      Text(statusText),
                    ],
                  ),
                  backgroundColor: statusColor.withOpacity(0.1),
                  labelStyle: TextStyle(color: statusColor),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow('اسم الموظف:', request.employeeName),
            _buildDetailRow('رقم الموظف:', request.employeeId),
            _buildDetailRow('القسم:', request.department),
            _buildDetailRow('الوظيفة:', request.position),
            _buildDetailRow('مقدم الطلب:', request.requestedBy),
            _buildDetailRow('تاريخ الطلب:', 
              '${request.requestDate.year}/${request.requestDate.month}/${request.requestDate.day}'),
            
            if (request.notes != null) ...[
              const SizedBox(height: 8),
              _buildDetailRow('ملاحظات:', request.notes!),
            ],
            
            if (request.status == 'pending') ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => approveRequest(request.id),
                      icon: const Icon(Icons.check),
                      label: const Text('موافقة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => rejectRequest(request.id),
                      icon: const Icon(Icons.close),
                      label: const Text('رفض'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red.shade300),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RejectDialog extends StatefulWidget {
  final Function(String) onReject;

  const RejectDialog({super.key, required this.onReject});

  @override
  State<RejectDialog> createState() => _RejectDialogState();
}

class _RejectDialogState extends State<RejectDialog> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.warning, color: Colors.orange),
          SizedBox(width: 8),
          Text('سبب الرفض'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('الرجاء إدخال سبب رفض طلب إنشاء الحساب:'),
          const SizedBox(height: 16),
          TextField(
            controller: _reasonController,
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'أدخل سبب الرفض هنا...',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_reasonController.text.trim().isNotEmpty) {
              widget.onReject(_reasonController.text);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('الرجاء إدخال سبب الرفض'),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('رفض الطلب'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}

// نموذج بيانات طلب إنشاء حساب
class AccountRequest {
  final String id;
  final String employeeName;
  final String employeeId;
  final String department;
  final String position;
  final String requestedBy;
  final DateTime requestDate;
  final String status; // 'pending', 'approved', 'rejected'
  final String? notes;

  AccountRequest({
    required this.id,
    required this.employeeName,
    required this.employeeId,
    required this.department,
    required this.position,
    required this.requestedBy,
    required this.requestDate,
    required this.status,
    this.notes,
  });
}
