import 'package:flutter/material.dart';

import '../citizen/Shared Services Citizen/payment_process_screen.dart';

class EmployeeSelectionScreen extends StatefulWidget {
  final String serviceTitle;
  final Color primaryColor;
  final List<Color> primaryGradient;
  final Function(dynamic)
  onEmployeeSelected; // 🔥 تغيير من Employee إلى dynamic

  const EmployeeSelectionScreen({
    Key? key,
    required this.serviceTitle,
    required this.primaryColor,
    required this.primaryGradient,
    required this.onEmployeeSelected,
  }) : super(key: key);

  @override
  State<EmployeeSelectionScreen> createState() =>
      _EmployeeSelectionScreenState();
}

class _EmployeeSelectionScreenState extends State<EmployeeSelectionScreen> {
  String searchQuery = '';
  List<Employee> filteredEmployees = [];

  // بيانات الموظفين مع التقييمات
  final List<Employee> _employees = [
    Employee(
      id: '1',
      name: 'أحمد محمد',
      specialty: 'فني عدادات ذكية',
      rating: 4.8,
      completedJobs: 127,
      imageUrl: '',
      skills: ['تركيب عدادات', 'صيانة لوحات', 'تمديدات'],
      hourlyRate: 25.0,
    ),
    Employee(
      id: '2',
      name: 'علي حسن',
      specialty: 'خبير صيانة لوحات',
      rating: 4.6,
      completedJobs: 89,
      imageUrl: '',
      skills: ['صيانة لوحات كهرباء', 'إصلاح أعطال', 'فحص أنظمة'],
      hourlyRate: 30.0,
    ),
    Employee(
      id: '3',
      name: 'محمود خالد',
      specialty: 'فني تمديدات',
      rating: 4.9,
      completedJobs: 156,
      imageUrl: '',
      skills: ['تمديدات كهربائية', 'تركيب نقاط', 'أسلاك وأنظمة'],
      hourlyRate: 22.0,
    ),
    Employee(
      id: '4',
      name: 'سامي رضا',
      specialty: 'خبير أنظمة شمسية',
      rating: 4.7,
      completedJobs: 93,
      imageUrl: '',
      skills: ['أنظمة الطاقة الشمسية', 'التحكم الذكي', 'البطاريات'],
      hourlyRate: 35.0,
    ),
    Employee(
      id: '5',
      name: 'حسن كريم',
      specialty: 'فني عام',
      rating: 4.5,
      completedJobs: 67,
      imageUrl: '',
      skills: ['صيانة عامة', 'إصلاح أعطال', 'تركيب أجهزة'],
      hourlyRate: 20.0,
    ),
    Employee(
      id: '6',
      name: 'عمر ناصر',
      specialty: 'فني عدادات',
      rating: 4.8,
      completedJobs: 112,
      imageUrl: '',
      skills: ['عدادات كهرباء', 'فحص العدادات', 'معايرة الأجهزة'],
      hourlyRate: 28.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    filteredEmployees = List.from(_employees);
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  Widget _buildEmployeeCard(Employee employee) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: widget.primaryColor.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // الاختيار المباشر بدون تفاصيل
            widget.onEmployeeSelected(employee);
            Navigator.pop(context); // العودة للشاشة السابقة
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // صورة الموظف
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.primaryGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                ),
                const SizedBox(width: 16),
                // معلومات الموظف
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              employee.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: widget.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                _buildRatingStars(employee.rating),
                                const SizedBox(width: 4),
                                Text(
                                  employee.rating.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: widget.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        employee.specialty,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.work_outline,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${employee.completedJobs} مهمة',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.attach_money,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${employee.hourlyRate} د.ع/ساعة',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      // المهارات
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: employee.skills.take(2).map((skill) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: widget.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              skill,
                              style: TextStyle(
                                fontSize: 10,
                                color: widget.primaryColor,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // أضف هذه الدالة في class _EmployeeSelectionScreenState
  void _showMultiEmployeeSelectionDialog(String serviceTitle) {
    List<Employee> selectedEmployees = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: widget.primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.group, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'اختر فريق العمل',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'يمكنك اختيار حتى 5 فنيين',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Selected Employees Counter
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    border: Border(
                      bottom: BorderSide(color: Colors.blue[100]!),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الفنيين المختارين: ${selectedEmployees.length}/5',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.primaryColor,
                        ),
                      ),
                      if (selectedEmployees.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedEmployees.clear();
                            });
                          },
                          child: Text(
                            'مسح الكل',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),

                // Selected Employees Chips
                if (selectedEmployees.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedEmployees.map((employee) {
                        return Chip(
                          label: Text(employee.name),
                          deleteIcon: Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              selectedEmployees.remove(employee);
                            });
                          },
                          backgroundColor: widget.primaryColor.withOpacity(0.1),
                        );
                      }).toList(),
                    ),
                  ),

                // Employees List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _employees.length,
                    itemBuilder: (context, index) {
                      final employee = _employees[index];
                      final isSelected = selectedEmployees.contains(employee);
                      final isMaxSelected =
                          selectedEmployees.length >= 5 && !isSelected;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: isSelected
                            ? widget.primaryColor.withOpacity(0.1)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? widget.primaryColor
                                : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: widget.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            employee.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? widget.primaryColor
                                  : Colors.black,
                            ),
                          ),
                          subtitle: Text(employee.specialty),
                          trailing: isSelected
                              ? Icon(Icons.check_circle, color: Colors.green)
                              : isMaxSelected
                              ? Icon(Icons.block, color: Colors.grey)
                              : Icon(
                                  Icons.radio_button_unchecked,
                                  color: Colors.grey,
                                ),
                          onTap: () {
                            if (isSelected) {
                              setState(() {
                                selectedEmployees.remove(employee);
                              });
                            } else if (!isMaxSelected) {
                              setState(() {
                                selectedEmployees.add(employee);
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Confirm Button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide(color: widget.primaryColor),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'إلغاء',
                            style: TextStyle(
                              color: widget.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedEmployees.isNotEmpty
                                ? widget.primaryColor
                                : Colors.grey,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: selectedEmployees.isNotEmpty
                              ? () {
                                  // حفظ الموظفين المختارين للخدمة المخصصة
                                  widget.onEmployeeSelected(selectedEmployees);
                                  Navigator.pop(context);
                                }
                              : null,
                          child: Text(
                            'تأكيد الاختيار (${selectedEmployees.length})',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: widget.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: widget.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  filteredEmployees = _employees
                      .where(
                        (employee) =>
                            employee.name.contains(value) ||
                            employee.specialty.contains(value) ||
                            employee.skills.any(
                              (skill) => skill.contains(value),
                            ),
                      )
                      .toList();
                });
              },
              decoration: const InputDecoration(
                hintText: 'ابحث عن فني بالاسم أو التخصص...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          if (searchQuery.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: Colors.grey[500], size: 20),
              onPressed: () {
                setState(() {
                  searchQuery = '';
                  filteredEmployees = List.from(_employees);
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'حاول البحث باستخدام كلمات أخرى',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // تغيير من transparent إلى white
      appBar: AppBar(
        backgroundColor: widget.primaryColor,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'اختر الفني المتخصص - ${widget.serviceTitle}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.people_alt_outlined,
                  size: 16,
                  color: widget.primaryColor,
                ),
                const SizedBox(width: 6),
                Text(
                  '${filteredEmployees.length} فني متاح',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: widget.primaryColor,
                  ),
                ),
                const Spacer(),
                if (searchQuery.isNotEmpty)
                  Text(
                    'نتائج البحث عن "$searchQuery"',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredEmployees.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: filteredEmployees.length,
                    itemBuilder: (context, index) {
                      return _buildEmployeeCard(filteredEmployees[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// شاشة اختيار الموظفين المخصصة للخدمات المخصصة
class CustomEmployeeSelectionScreen extends StatefulWidget {
  final String serviceTitle;
  final Color primaryColor;
  final List<Color> primaryGradient;
  final List<Employee> initialSelection;
  final List<Employee> employees;
  final Function(List<Employee>) onEmployeesSelected;

  const CustomEmployeeSelectionScreen({
    Key? key,
    required this.serviceTitle,
    required this.primaryColor,
    required this.primaryGradient,
    required this.initialSelection,
    required this.employees,
    required this.onEmployeesSelected,
  }) : super(key: key);

  @override
  State<CustomEmployeeSelectionScreen> createState() => _CustomEmployeeSelectionScreenState();
}

class _CustomEmployeeSelectionScreenState extends State<CustomEmployeeSelectionScreen> {
  String searchQuery = '';
  List<Employee> filteredEmployees = [];
  List<Employee> selectedEmployees = [];

  @override
  void initState() {
    super.initState();
    // ✅ التصحيح: استخدام القائمة الممررة مباشرة
    filteredEmployees = List.from(widget.employees);
    selectedEmployees = List.from(widget.initialSelection);
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: widget.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: widget.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  // ✅ التصحيح: استخدام widget.employees بدلاً من filteredEmployees
                  filteredEmployees = widget.employees
                      .where((employee) =>
                          employee.name.contains(value) ||
                          employee.specialty.contains(value) ||
                          employee.skills.any((skill) => skill.contains(value)))
                      .toList();
                });
              },
              decoration: const InputDecoration(
                hintText: 'ابحث عن فني بالاسم أو التخصص...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          if (searchQuery.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.grey[500],
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  searchQuery = '';
                  // ✅ التصحيح: إعادة تعيين إلى القائمة الأصلية
                  filteredEmployees = List.from(widget.employees);
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  Widget _buildEmployeeCard(Employee employee) {
    final isSelected = selectedEmployees.contains(employee);
    final isMaxSelected = selectedEmployees.length >= 5 && !isSelected;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? widget.primaryColor.withOpacity(0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isSelected
              ? widget.primaryColor
              : Colors.grey.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedEmployees.remove(employee);
              } else if (!isMaxSelected) {
                selectedEmployees.add(employee);
              }
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // صورة الموظف
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.primaryGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // معلومات الموظف
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              employee.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? widget.primaryColor
                                    : Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: widget.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                _buildRatingStars(employee.rating),
                                const SizedBox(width: 4),
                                Text(
                                  employee.rating.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: widget.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        employee.specialty,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.work_outline,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${employee.completedJobs} مهمة',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.attach_money,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${employee.hourlyRate} د.ع/ساعة',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      // المهارات
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: employee.skills.take(2).map((skill) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: widget.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              skill,
                              style: TextStyle(
                                fontSize: 10,
                                color: widget.primaryColor,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                // أيقونة الاختيار
                Icon(
                  isSelected
                      ? Icons.check_circle
                      : isMaxSelected
                          ? Icons.block
                          : Icons.radio_button_unchecked,
                  color: isSelected
                      ? Colors.green
                      : isMaxSelected
                          ? Colors.grey
                          : Colors.grey[400],
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'حاول البحث باستخدام كلمات أخرى',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: widget.primaryColor,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اختر فريق العمل - ${widget.serviceTitle}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              'تم اختيار ${selectedEmployees.length}/5 فنيين',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (selectedEmployees.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: () {
                widget.onEmployeesSelected(selectedEmployees);
                Navigator.pop(context);
              },
              tooltip: 'تأكيد الاختيار',
            ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.people_alt_outlined,
                  size: 16,
                  color: widget.primaryColor,
                ),
                const SizedBox(width: 6),
                Text(
                  '${filteredEmployees.length} فني متاح',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: widget.primaryColor,
                  ),
                ),
                const Spacer(),
                if (searchQuery.isNotEmpty)
                  Text(
                    'نتائج البحث عن "$searchQuery"',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredEmployees.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: filteredEmployees.length,
                    itemBuilder: (context, index) {
                      return _buildEmployeeCard(filteredEmployees[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: selectedEmployees.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                widget.onEmployeesSelected(selectedEmployees);
                Navigator.pop(context);
              },
              backgroundColor: widget.primaryColor,
              icon: const Icon(Icons.check, color: Colors.white),
              label: Text(
                'تأكيد (${selectedEmployees.length})',
                style: const TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }
}
extension EmployeeSelectionExtension on Function {
  void call(List<Employee> employees) {
    if (this is Function(List<Employee>)) {
      this(employees);
    }
  }
}