import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const [
          _Body(),
          _BottomNav(),
        ],
      ),
      floatingActionButton: const _Fab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: const [
          _TopBar(),
          SizedBox(height: AppSpacing.stackLG),
          _TrendingTopics(),
          SizedBox(height: AppSpacing.gutter),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
            child: _PostFeed(),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.surface.withAlpha(153),
        border: Border(
          bottom: BorderSide(color: AppColors.onSurfaceVariant.withAlpha(25)),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.full),
                color: Colors.transparent,
              ),
              child: const Icon(Icons.menu, color: AppColors.onSurface),
            ),
          ),
          const Spacer(),
          Text(
            'نواة',
            style: AppTypography.headlineLG.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.full),
                color: Colors.transparent,
              ),
              child: const Icon(Icons.notifications_outlined, color: AppColors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendingTopics extends StatelessWidget {
  const _TrendingTopics();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
          child: Text(
            'المواضيع الشائعة',
            style: AppTypography.headlineMD,
          ),
        ),
        const SizedBox(height: AppSpacing.stackSM),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
          child: Row(
            children: [
              _TopicChip(label: '#React_Native'),
              const SizedBox(width: AppSpacing.stackSM),
              _TopicChip(label: '#Python_AI'),
              const SizedBox(width: AppSpacing.stackSM),
              _TopicChip(label: '#Vercel_Deploy'),
              const SizedBox(width: AppSpacing.stackSM),
              _TopicChip(label: '#Rust_WASM'),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopicChip extends StatelessWidget {
  final String label;

  const _TopicChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withAlpha(38),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTypography.labelMD.copyWith(
          color: AppColors.primaryFixed,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _PostFeed extends StatelessWidget {
  const _PostFeed();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PostCard(
          name: 'أحمد عبد الله',
          role: 'مطور واجهات أمامية',
          time: 'منذ ساعتين',
          avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBF3Lj-E608JbgYnX4DQ6rA3gMGPDXFbnQaB-7yK-tL7iKSrFCwGhRI3lC5yA7TNzxpQCW99sgag9SiPdY2OLJOJ-DYTjUUwsUxl07lz9ZujmzZfUjdOkJdzxkhi3hetOZ5vVOoidVhWeP1swH4zBH0OKgk3dbZQN1zEzbJp8zVfWH6aIFVMVplAjpRp3uLoQ3-rDvuTOWOJP5ZLTW2HVlz7ZHVaIfu1mad4-JeJOjMNuFqIbpreeuv1e5FQ1iNUwPP1Cg0oMPBBg',
          avatarBorder: AppColors.primaryContainer,
          content:
              'لقد كنت أجرب استخدام `Suspense` مع React 18 مؤخراً، النتائج مذهلة في تحسين تجربة المستخدم أثناء تحميل البيانات. هل لاحظ أحدكم أي مشاكل في الأداء عند استخدامه مع قوائم كبيرة؟',
          codeSnippet: '<Suspense fallback={<LoadingSpinner />}>\n  <HeavyDataList />\n</Suspense>',
          likes: '24',
          comments: '8',
        ),
        const SizedBox(height: AppSpacing.gutter),
        _PostCard(
          name: 'سارة محمد',
          role: 'مهندسة نظم',
          time: 'منذ 5 ساعات',
          avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCRwpt550h_IfP-yrEdqgSN9iao9Nt2LI_mEA_rcax2h1EnTCw4xXI6zFbLXf5Lz4GzSxRMItXiUxk6-MUEExu5Q23RbeK6W_VxSnfbbcv-82oapdxuCgIa20b6moQoI5DWFmq7PsQGDwAPz-Dy2dZo2RqXsY_XVD_v0aaIHDSTeqrEdKlTkRdh6mBBAsplV9MtNIfvvJ1kvjeCo2m3BZ4X9qpAobh_MEWVkBgkbil7zmyPwUYoKhpf7_QQnJCMsm_BhpW5XMbTXA',
          avatarBorder: AppColors.surfaceVariant,
          content:
              'نبحث عن مطورين لمشروع مفتوح المصدر يهدف إلى توفير أدوات تحليل بيانات باللغة العربية. إذا كنت مهتماً بالمساهمة، تواصل معي. التقنيات: Python, Pandas, FastAPI.',
          codeSnippet: null,
          likes: '56',
          comments: '12',
        ),
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  final String name;
  final String role;
  final String time;
  final String? avatarUrl;
  final Color avatarBorder;
  final String content;
  final String? codeSnippet;
  final String likes;
  final String comments;

  const _PostCard({
    required this.name,
    required this.role,
    required this.time,
    this.avatarUrl,
    required this.avatarBorder,
    required this.content,
    this.codeSnippet,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        color: AppColors.surfaceContainerHigh.withAlpha(153),
        border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(25)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceContainerHigh.withAlpha(204),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.surfaceVariant,
                    backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                    child: avatarUrl == null
                        ? const Icon(Icons.person, color: AppColors.onSurfaceVariant, size: 28)
                        : null,
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: avatarBorder, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTypography.headlineMD),
                    const SizedBox(height: 2),
                    Text(
                      '$role • $time',
                      style: AppTypography.labelMD.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(content, style: AppTypography.bodyMD),
          if (codeSnippet != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                color: AppColors.surfaceContainerHighest,
              ),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  codeSnippet!,
                  style: AppTypography.codeSM.copyWith(color: AppColors.primaryFixed),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Divider(color: AppColors.onSurfaceVariant.withAlpha(25), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              _ActionButton(icon: Icons.thumb_up_outlined, label: likes),
              const SizedBox(width: 24),
              _ActionButton(icon: Icons.chat_bubble_outline, label: comments),
              const Spacer(),
              _ActionButton(icon: Icons.share_outlined, label: 'مشاركة'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelMD.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _Fab extends StatelessWidget {
  const _Fab();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withAlpha(77),
            blurRadius: 20,
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: AppColors.surfaceContainerLowest, size: 32),
        onPressed: () {},
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.containerMargin,
          0,
          AppSpacing.containerMargin,
          16,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.onSurfaceVariant.withAlpha(25)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withAlpha(30),
                blurRadius: 20,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: BottomAppBar(
              color: AppColors.surface.withAlpha(153),
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  _NavItem(
                    icon: Icons.person_outline,
                    label: 'الملف الشخصي',
                    isActive: false,
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.emoji_events_outlined,
                    label: 'التحديات',
                    isActive: false,
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.groups,
                    label: 'المجتمع',
                    isActive: true,
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.search,
                    label: 'الاستكشاف',
                    isActive: false,
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'الرئيسية',
                    isActive: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTypography.fontArabic,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(128),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
