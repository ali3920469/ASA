import 'package:flutter/material.dart';
import 'points_service.dart';
import 'transaction_history_screen.dart';
import 'package:mang_mu/screens/zemp_and_citizen/mainscren.dart';
import 'edit_profile_screen.dart';
import 'api_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  static const String screen = 'profile_screen';

  final Map<String, dynamic>? userProfile;
  final Future<void> Function() onSignOut;
  final Color primaryColor;
  final Color textColor;
  final Color textSecondaryColor;
  final Color errorColor;
  final VoidCallback? onClose;
  final Function(Map<String, dynamic>)? onProfileUpdated;

  const ProfileScreen({
    super.key,
    required this.userProfile,
    required this.onSignOut,
    required this.primaryColor,
    required this.textColor,
    required this.textSecondaryColor,
    required this.errorColor,
    this.onClose,
    this.onProfileUpdated,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PointsService _pointsService = PointsService();
  int _userPoints = 0;
  bool _isLoadingPoints = true;
  bool _isLoadingProfile = true;
  Map<String, dynamic>? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserPoints();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoadingProfile = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        setState(() => _isLoadingProfile = false);
        return;
      }

      // جلب البيانات من shared schema
      final response = await Supabase.instance.client
          .schema('shared')
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      print('✅ تم جلب البيانات من shared schema: $response');

      if (mounted) {
        setState(() {
          _userProfile = response;
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      print('❌ خطأ في تحميل الملف الشخصي: $e');
      if (mounted) {
        setState(() => _isLoadingProfile = false);
      }
    }
  }

  Future<void> _loadUserPoints() async {
    try {
      final points = await _pointsService.getUserPoints();
      setState(() {
        _userPoints = points;
        _isLoadingPoints = false;
      });
    } catch (e) {
      print('Error loading points: $e');
      setState(() {
        _isLoadingPoints = false;
      });
    }
  }

  void _handleProfileUpdated(Map<String, dynamic> updatedProfile) {
    setState(() {
      _userProfile = updatedProfile;
    });
    // تحديث البيانات في الـ parent إذا كان موجوداً
    if (widget.onProfileUpdated != null) {
      widget.onProfileUpdated!(updatedProfile);
    }
  }

  // دالة للحصول على البيانات الحالية (من _userProfile أو widget.userProfile)
  Map<String, dynamic> get _currentProfile {
    return _userProfile ?? widget.userProfile ?? {};
  }

  Widget _buildProfileAvatar() {
    final profile = _currentProfile;
    final selfieImage = profile['selfie_image'];

    if (selfieImage != null && selfieImage.toString().isNotEmpty) {
      final selfieString = selfieImage.toString();
      if (selfieString.startsWith('http')) {
        return Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: widget.primaryColor, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              selfieString,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: widget.primaryColor,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return _buildDefaultAvatar();
              },
            ),
          ),
        );
      }
    }

    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.primaryColor.withOpacity(0.1),
        border: Border.all(
          color: widget.primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(Icons.person, size: 35, color: widget.primaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProfile) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: widget.primaryColor,
          ),
        ),
      );
    }

    final profile = _currentProfile;
    final phone = profile['phone']?.toString() ?? '';
    final hasPhone = phone.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with close button
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
                const Icon(Icons.person, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'الملف الشخصي',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: widget.onClose ?? () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Profile Header مع صورة السيلفي
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: widget.primaryColor.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildProfileAvatar(),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile['full_name'] ?? 'غير معروف',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: widget.textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile['email'] ?? 'غير معروف',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: widget.textSecondaryColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (hasPhone)
                                Text(
                                  phone,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: widget.textSecondaryColor,
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                    profile['status'],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _getStatusText(profile['status']),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Personal Information Section
                  _buildSectionHeader('المعلومات الشخصية'),
                  const SizedBox(height: 16),

                  _buildProfileInfoItem(
                    Icons.credit_card,
                    'رقم الهوية',
                    profile['id_number']?.toString() ?? 'غير معروف',
                  ),
                  _buildProfileInfoItem(
                    Icons.home,
                    'رقم الدار/المنزل',
                    profile['house_number']?.toString() ?? 'غير معروف',
                  ),
                  _buildProfileInfoItem(
                    Icons.phone,
                    'رقم الهاتف',
                    profile['phone']?.toString() ?? 'غير معروف',
                  ),
                  _buildProfileInfoItem(
                    Icons.location_on,
                    'الموقع',
                    profile['location']?.toString() ?? 'غير معروف',
                  ),
                  _buildProfileInfoItem(
                    Icons.calendar_today,
                    'تاريخ التسجيل',
                    _formatDate(profile['created_at']),
                  ),

                  const SizedBox(height: 24),

                  // Account Information Section
                  _buildSectionHeader('معلومات الحساب'),
                  const SizedBox(height: 16),

                  _buildAccountInfoItem(
                    Icons.star,
                    'نقاط المكافآت',
                    _isLoadingPoints ? 'جاري التحميل...' : '$_userPoints نقطة',
                    const Color(0xFFFF9800),
                  ),
                  _buildAccountInfoItem(
                    Icons.history,
                    'سجل المعاملات',
                    'عرض السجل',
                    const Color(0xFF607D8B),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionHistoryScreen(
                            primaryColor: widget.primaryColor,
                            primaryGradient: [
                              widget.primaryColor,
                              widget.primaryColor,
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Quick Actions
                  _buildSectionHeader('الإجراءات السريعة'),
                  const SizedBox(height: 16),

                  _buildQuickActionItem(
                    Icons.edit,
                    'تعديل الملف الشخصي',
                    widget.primaryColor,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            userProfile: profile,
                            primaryColor: widget.primaryColor,
                            textColor: widget.textColor,
                            textSecondaryColor: widget.textSecondaryColor,
                            onProfileUpdated: _handleProfileUpdated,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        bool confirm = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('تأكيد تسجيل الخروج'),
                                content: const Text(
                                  'هل أنت متأكد من تسجيل الخروج؟',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('إلغاء'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    style: TextButton.styleFrom(
                                      backgroundColor: widget.errorColor,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('تسجيل الخروج'),
                                  ),
                                ],
                              ),
                            ) ??
                            false;

                        if (confirm && context.mounted) {
                          await widget.onSignOut();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Mainscren.screenroot,
                            (route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.errorColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, size: 20),
                          SizedBox(width: 8),
                          Text('تسجيل الخروج', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(height: 1, width: 20, color: widget.primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: widget.primaryColor,
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: widget.primaryColor.withOpacity(0.3),
            margin: const EdgeInsets.only(right: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfoItem(
    IconData icon,
    String title,
    String value, {
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: widget.primaryColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                color: widget.primaryColor,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfoItem(
    IconData icon,
    String title,
    String value,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: widget.textColor,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: widget.textSecondaryColor,
          size: 16,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'approved':
        return const Color(0xFF4CAF50);
      case 'under_review':
        return const Color(0xFFFF9800);
      case 'rejected':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'approved':
        return 'معتمد';
      case 'under_review':
        return 'قيد المراجعة';
      case 'rejected':
        return 'مرفوض';
      default:
        return 'غير معروف';
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'غير معروف';

    try {
      if (date is String) {
        DateTime parsedDate = DateTime.parse(date);
        return '${parsedDate.year}-${parsedDate.month}-${parsedDate.day}';
      } else if (date is DateTime) {
        return '${date.year}-${date.month}-${date.day}';
      }
      return 'غير معروف';
    } catch (e) {
      return 'غير معروف';
    }
  }
}