import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('جاري الإعداد...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            _buildHeader(),
            const Spacer(flex: 2),
            Expanded(flex: 5, child: _buildCarousel()),
            const SizedBox(height: AppSpacing.stackMD),
            _buildIndicators(),
            const Spacer(flex: 2),
            _buildActions(),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(
              color: Colors.white.withAlpha(25),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withAlpha(25),
                Colors.white.withAlpha(0),
              ],
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.terminal_rounded,
              color: AppColors.primary,
              size: 64,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.stackMD - 8),
        const Text(
          'نواة',
          style: AppTypography.headlineXL,
        ),
        const SizedBox(height: AppSpacing.stackSM - 4),
        Text(
          'حاضنة المبرمجين العرب',
          style: AppTypography.bodyMD.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildCarousel() {
    const slides = [
      _OnboardingSlide(
        icon: Icons.school_rounded,
        title: 'تعلم من الخبراء',
        description: 'دورات متقدمة وإرشاد مباشر من نخبة المطورين في العالم العربي لبناء أساس برمجي صلب.',
      ),
      _OnboardingSlide(
        icon: Icons.code_rounded,
        title: 'تحديات برمجية حقيقية',
        description: 'اختبر مهاراتك من خلال مشاريع وتحديات تحاكي بيئة العمل الواقعية في الشركات التقنية.',
      ),
      _OnboardingSlide(
        icon: Icons.hub_rounded,
        title: 'انضم لمجتمع المبدعين',
        description: 'تواصل، شارك أفكارك، وابنِ شبكة علاقات قوية مع مبرمجين شغوفين يشاركونك نفس الرؤية.',
      ),
    ];

    return PageView(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      children: slides,
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.full),
            color: isActive ? AppColors.primary : AppColors.surfaceVariant,
          ),
        );
      }),
    );
  }

  Widget _buildActions() {
    final isLast = _currentPage == 2;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerMargin,
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryContainer.withAlpha(30),
                    blurRadius: 30,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: AppColors.onPrimaryContainer,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  elevation: 0,
                ).copyWith(
                  shadowColor: WidgetStateProperty.all(Colors.transparent),
                  surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isLast ? 'ابدأ' : 'التالي',
                      style: AppTypography.headlineMD,
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_back_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.stackSM),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('جاري الإعداد...')),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  side: BorderSide(
                    color: AppColors.primary.withAlpha(77),
                  ),
                ),
              ),
              child: const Text(
                'لدي حساب بالفعل',
                style: AppTypography.bodyMD,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: Colors.white.withAlpha(25),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withAlpha(25),
              Colors.white.withAlpha(0),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppColors.primary, size: 48),
                const SizedBox(height: AppSpacing.stackMD),
                Text(
                  title,
                  style: AppTypography.headlineLG,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.stackSM),
                Text(
                  description,
                  style: AppTypography.bodyMD.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
