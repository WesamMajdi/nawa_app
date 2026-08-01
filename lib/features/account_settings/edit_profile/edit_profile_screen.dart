import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nawa_flutter/core/constants/constants.dart';
import 'package:nawa_flutter/core/repositories/user_repository.dart';
import 'package:nawa_flutter/core/network/api_exceptions.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _handleController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isAvailableForHire = false;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  bool _loadFailed = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await context.read<UserRepository>().getMe();
      if (!mounted) return;
      setState(() {
        _nameController.text = user.name;
        _handleController.text = user.handle ?? '';
        _jobTitleController.text = user.jobTitle ?? '';
        _bioController.text = user.bio ?? '';
        _isAvailableForHire = user.isAvailableForHire;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadFailed = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'الاسم مطلوب');
      return;
    }
    setState(() {
      _isSaving = true;
      _error = null;
    });
    try {
      await context.read<UserRepository>().updateProfile(
            name: name,
            handle: _handleController.text.trim().isEmpty
                ? null
                : _handleController.text.trim(),
            jobTitle: _jobTitleController.text.trim().isEmpty
                ? null
                : _jobTitleController.text.trim(),
            bio: _bioController.text.trim().isEmpty
                ? null
                : _bioController.text.trim(),
            isAvailableForHire: _isAvailableForHire,
          );
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ التعديلات بنجاح'),
          backgroundColor: AppColors.primaryContainer,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      final message = e is ApiException
          ? e.toUserMessage()
          : 'حدث خطأ غير متوقع';
      setState(() {
        _error = message;
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: const Text('تعديل الملف الشخصي'),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _loadFailed
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'تعذر تحميل الملف الشخصي',
                          style: AppTypography.bodyMD,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadUser,
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(AppSpacing.containerMargin),
                    children: [
                      _Field(
                        controller: _nameController,
                        label: 'الاسم',
                        hint: 'اسمك الكامل',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: AppSpacing.gutter),
                      _Field(
                        controller: _handleController,
                        label: 'المعرف (اختياري)',
                        hint: 'handle',
                        icon: Icons.alternate_email,
                        ltr: true,
                      ),
                      const SizedBox(height: AppSpacing.gutter),
                      _Field(
                        controller: _jobTitleController,
                        label: 'المسمى الوظيفي (اختياري)',
                        hint: 'مثال: مطور فلاتر',
                        icon: Icons.work_outline,
                      ),
                      const SizedBox(height: AppSpacing.gutter),
                      Text(
                        'نبذة عنك (اختياري)',
                        style: AppTypography.labelMD.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.unit),
                      TextField(
                        controller: _bioController,
                        maxLines: 4,
                        maxLength: 280,
                        style: AppTypography.bodyMD.copyWith(
                          color: AppColors.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'اكتب نبذة قصيرة عنك...',
                          hintStyle: AppTypography.bodyMD.copyWith(
                            color: AppColors.onSurfaceVariant.withAlpha(128),
                          ),
                          filled: true,
                          fillColor: AppColors.surfaceContainerHighest,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            borderSide: const BorderSide(
                              color: AppColors.outlineVariant,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            borderSide: const BorderSide(
                              color: AppColors.outlineVariant,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.gutter),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          color: AppColors.surfaceContainerHigh.withAlpha(153),
                          border: Border.all(
                            color: AppColors.onSurfaceVariant.withAlpha(12),
                          ),
                        ),
                        child: SwitchListTile(
                          value: _isAvailableForHire,
                          onChanged: (v) =>
                              setState(() => _isAvailableForHire = v),
                          activeTrackColor: AppColors.primary,
                          title: Text(
                            'متاح للتوظيف',
                            style: AppTypography.bodyLG,
                          ),
                          subtitle: Text(
                            'اظهر لفرق التوظيف أنك تبحث عن فرصة',
                            style: AppTypography.labelMD.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: AppSpacing.stackMD),
                        Text(
                          _error!,
                          style: AppTypography.bodyMD.copyWith(
                            color: AppColors.error,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.stackLG),
                      ElevatedButton(
                        onPressed: _isSaving ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.background,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          elevation: 0,
                          textStyle: AppTypography.headlineMD,
                        ).copyWith(
                          shadowColor:
                              WidgetStateProperty.all(Colors.transparent),
                          surfaceTintColor:
                              WidgetStateProperty.all(Colors.transparent),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.background,
                                ),
                              )
                            : const Text('حفظ التعديلات'),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool ltr;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.ltr = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMD.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.unit),
        TextField(
          controller: controller,
          textDirection: ltr ? TextDirection.ltr : TextDirection.rtl,
          style: AppTypography.bodyMD.copyWith(
            color: AppColors.onSurface,
            fontFamily: ltr ? AppTypography.fontMono : null,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMD.copyWith(
              color: AppColors.onSurfaceVariant.withAlpha(128),
            ),
            prefixIcon: Icon(icon, color: AppColors.onSurfaceVariant),
            filled: true,
            fillColor: AppColors.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              borderSide: const BorderSide(color: AppColors.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              borderSide: const BorderSide(color: AppColors.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
