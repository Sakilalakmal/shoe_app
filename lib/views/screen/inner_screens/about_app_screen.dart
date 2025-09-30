import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/model/app_about_info/about_us_info.dart';
import 'package:shoe_app_assigment/provider/app_info_provider.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class AboutAppScreen extends ConsumerStatefulWidget {
  const AboutAppScreen({super.key});

  @override
  ConsumerState<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends ConsumerState<AboutAppScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final appInfoState = ref.watch(appInfoProvider);

    return Scaffold(
      backgroundColor: dark ? TColors.darkBackground : TColors.lightBackground,
      appBar: _buildModernAppBar(context, dark),
      body: _buildBody(context, appInfoState, dark),
    );
  }

  PreferredSizeWidget _buildModernAppBar(BuildContext context, bool dark) {
    return AppBar(
      backgroundColor: dark ? TColors.darkBackground : TColors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(TSizes.sm),
        decoration: BoxDecoration(
          color: dark ? TColors.darkContainer : TColors.lightContainer,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
          border: Border.all(
            color: dark 
                ? TColors.borderDark.withOpacity(0.1)
                : TColors.borderLight.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Iconsax.arrow_left,
            color: dark ? TColors.textDarkPrimary : TColors.textPrimary,
            size: TSizes.iconMd,
          ),
        ),
      ),
      title: FadeTransition(
        opacity: _fadeAnimation,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(TSizes.xs),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    TColors.newBlue.withOpacity(0.15),
                    TColors.accent.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
              ),
              child: Icon(
                Iconsax.info_circle,
                color: TColors.newBlue,
                size: TSizes.iconMd,
              ),
            ),
            const SizedBox(width: TSizes.sm),
            Flexible(
              child: Text(
                'About App',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: dark ? TColors.textDarkPrimary : TColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context, AppInfoState appInfoState, bool dark) {
    if (appInfoState.isLoading) {
      return _buildLoadingState(context, dark);
    }

    if (appInfoState.error != null) {
      return _buildErrorState(context, appInfoState.error!, dark);
    }

    if (appInfoState.appInfo != null) {
      return _buildAppInfoDisplay(context, appInfoState.appInfo!, dark);
    }

    return _buildLoadingState(context, dark);
  }

  Widget _buildLoadingState(BuildContext context, bool dark) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(TSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    TColors.newBlue.withOpacity(0.15),
                    TColors.accent.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: TColors.newBlue.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(TColors.newBlue),
                  strokeWidth: 3,
                ),
              ),
            ),
            const SizedBox(height: TSizes.xl),
            Text(
              'Loading app information...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: dark ? TColors.textDarkPrimary : TColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TSizes.sm),
            Text(
              'Please wait while we gather the details',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error, bool dark) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(TSizes.lg),
        padding: const EdgeInsets.all(TSizes.xl),
        decoration: BoxDecoration(
          color: dark ? TColors.darkContainer : TColors.white,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          border: Border.all(
            color: TColors.error.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: TColors.error.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: TColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Iconsax.warning_2,
                color: TColors.error,
                size: TSizes.iconLg,
              ),
            ),
            const SizedBox(height: TSizes.lg),
            Text(
              'Unable to load app information',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: TColors.error,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TSizes.sm),
            Text(
              'Please check your connection and try again',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TSizes.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(appInfoProvider.notifier).refreshAppInfo();
                },
                icon: Icon(Iconsax.refresh, color: TColors.white),
                label: Text(
                  'Retry',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: TColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.newBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.xl,
                    vertical: TSizes.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoDisplay(BuildContext context, AppInfoModel appInfo, bool dark) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Hero Section
              _buildAppHeroSection(context, appInfo.appInfo, dark),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Vision & Mission Section
              _buildVisionSection(context, appInfo.vision, dark),
              const SizedBox(height: TSizes.spaceBtwSections),

              // User Features Section
              _buildFeaturesSection(
                context,
                'Features for Users',
                'Discover what makes our app special',
                appInfo.userFeatures,
                Iconsax.user,
                TColors.success,
                dark,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Vendor Features Section
              _buildFeaturesSection(
                context,
                'Features for Vendors',
                'Powerful business management tools',
                appInfo.vendorFeatures,
                Iconsax.shop,
                TColors.info,
                dark,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Technology Stack Section
              _buildTechnologySection(context, appInfo.technologies, dark),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Company Information Section
              _buildCompanySection(context, appInfo.company, dark),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Legal Information Section
              _buildLegalSection(context, appInfo.legal, dark),
              const SizedBox(height: TSizes.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeroSection(BuildContext context, AppInfo appInfo, bool dark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TColors.newBlue.withOpacity(0.1),
            TColors.accent.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        border: Border.all(
          color: TColors.newBlue.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: dark 
                ? TColors.black.withOpacity(0.3)
                : TColors.darkGrey.withOpacity(0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(TSizes.xl),
      child: Column(
        children: [
          // App Icon/Logo with Hero Animation
          Hero(
            tag: 'app_logo',
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [TColors.newBlue, TColors.accent],
                ),
                borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                boxShadow: [
                  BoxShadow(
                    color: TColors.newBlue.withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Icon(
                Iconsax.bag_2,
                color: TColors.white,
                size: 48,
              ),
            ),
          ),
          const SizedBox(height: TSizes.lg),

          // App Name
          Text(
            appInfo.appName,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: dark ? TColors.textDarkPrimary : TColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          const SizedBox(height: TSizes.md),

          // Version Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.lg,
              vertical: TSizes.sm,
            ),
            decoration: BoxDecoration(
              color: TColors.newBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
              border: Border.all(
                color: TColors.newBlue.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              'Version ${appInfo.version}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: TColors.newBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: TSizes.lg),

          // Tagline
          Text(
            appInfo.tagline,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: TColors.newBlue,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: TSizes.md),

          // Description
          Text(
            appInfo.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: TColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildVisionSection(BuildContext context, Vision vision, bool dark) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? TColors.darkContainer : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        border: Border.all(
          color: dark 
              ? TColors.borderDark.withOpacity(0.1)
              : TColors.borderLight.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: dark 
                ? TColors.black.withOpacity(0.2)
                : TColors.darkGrey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(TSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(TSizes.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      TColors.success.withOpacity(0.15),
                      TColors.success.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                ),
                child: Icon(
                  Iconsax.eye,
                  color: TColors.success,
                  size: TSizes.iconLg,
                ),
              ),
              const SizedBox(width: TSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vision.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: dark ? TColors.textDarkPrimary : TColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: TSizes.xs),
                    Text(
                      'Building the future of shoe shopping',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: TColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.lg),

          Text(
            vision.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: TColors.textSecondary,
              height: 1.6,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: TSizes.lg),

          Container(
            padding: const EdgeInsets.all(TSizes.lg),
            decoration: BoxDecoration(
              color: TColors.success.withOpacity(0.05),
              borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
              border: Border.all(
                color: TColors.success.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(TSizes.xs),
                  decoration: BoxDecoration(
                    color: TColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusXs),
                  ),
                  child: Icon(
                    Iconsax.flag,
                    color: TColors.success,
                    size: TSizes.iconMd,
                  ),
                ),
                const SizedBox(width: TSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Our Mission',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: TColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: TSizes.xs),
                      Text(
                        vision.mission,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TColors.success.withOpacity(0.8),
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(
    BuildContext context,
    String title,
    String subtitle,
    List<Feature> features,
    IconData icon,
    Color accentColor,
    bool dark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? TColors.darkContainer : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        border: Border.all(
          color: dark 
              ? TColors.borderDark.withOpacity(0.1)
              : TColors.borderLight.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: dark 
                ? TColors.black.withOpacity(0.2)
                : TColors.darkGrey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(TSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(TSizes.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withOpacity(0.15),
                      accentColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: TSizes.iconLg,
                ),
              ),
              const SizedBox(width: TSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: dark ? TColors.textDarkPrimary : TColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: TSizes.xs),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: TColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.lg),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            separatorBuilder: (context, index) => const SizedBox(height: TSizes.md),
            itemBuilder: (context, index) {
              final feature = features[index];
              return Container(
                padding: const EdgeInsets.all(TSizes.lg),
                decoration: BoxDecoration(
                  color: dark 
                      ? TColors.darkContainer.withOpacity(0.4)
                      : TColors.lightContainer.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                  border: Border.all(
                    color: accentColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                      ),
                      child: Icon(
                        _getIconFromString(feature.icon),
                        color: accentColor,
                        size: TSizes.iconMd,
                      ),
                    ),
                    const SizedBox(width: TSizes.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feature.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: dark ? TColors.textDarkPrimary : TColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: TSizes.xs),
                          Text(
                            feature.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: TColors.textSecondary,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTechnologySection(BuildContext context, Technologies technologies, bool dark) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? TColors.darkContainer : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        border: Border.all(
          color: dark 
              ? TColors.borderDark.withOpacity(0.1)
              : TColors.borderLight.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: dark 
                ? TColors.black.withOpacity(0.2)
                : TColors.darkGrey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(TSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(TSizes.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      TColors.warning.withOpacity(0.15),
                      TColors.warning.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                ),
                child: Icon(
                  Iconsax.code,
                  color: TColors.warning,
                  size: TSizes.iconLg,
                ),
              ),
              const SizedBox(width: TSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      technologies.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: dark ? TColors.textDarkPrimary : TColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: TSizes.xs),
                    Text(
                      technologies.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: TColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.lg),

          LayoutBuilder(
            builder: (context, constraints) {
              // Responsive grid based on screen width
              int crossAxisCount = 2;
              if (constraints.maxWidth < 400) {
                crossAxisCount = 1;
              } else if (constraints.maxWidth > 600) {
                crossAxisCount = 3;
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: TSizes.md,
                  mainAxisSpacing: TSizes.md,
                  childAspectRatio: 1.3,
                ),
                itemCount: technologies.stack.length,
                itemBuilder: (context, index) {
                  final tech = technologies.stack[index];
                  return Container(
                    padding: const EdgeInsets.all(TSizes.md),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          TColors.warning.withOpacity(0.1),
                          TColors.warning.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                      border: Border.all(
                        color: TColors.warning.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tech.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: TColors.warning,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: TSizes.xs),
                        Text(
                          tech.description,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: TColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: TSizes.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TSizes.sm,
                            vertical: TSizes.xs,
                          ),
                          decoration: BoxDecoration(
                            color: TColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                          ),
                          child: Text(
                            tech.version,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: TColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCompanySection(BuildContext context, Company company, bool dark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TColors.accent.withOpacity(0.1),
            TColors.newBlue.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        border: Border.all(
          color: TColors.accent.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: TColors.accent.withOpacity(0.1),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(TSizes.xl),
      child: Column(
        children: [
          // Company Logo/Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [TColors.accent, TColors.newBlue],
              ),
              borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
              boxShadow: [
                BoxShadow(
                  color: TColors.accent.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Iconsax.buildings,
              color: TColors.white,
              size: TSizes.iconLg,
            ),
          ),
          const SizedBox(height: TSizes.lg),

          // Powered By
          Text(
            'Powered by',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: TColors.textSecondary,
            ),
          ),
          const SizedBox(height: TSizes.sm),

          // Company Name
          Text(
            company.name,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: TColors.accent,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: TSizes.xs),

          // Tagline
          Text(
            company.tagline,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: TColors.newBlue,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: TSizes.lg),

          // Description
          Text(
            company.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: TColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: TSizes.xl),

          // Contact Information
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(TSizes.lg),
            decoration: BoxDecoration(
              color: dark 
                  ? TColors.darkContainer.withOpacity(0.4)
                  : TColors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
              border: Border.all(
                color: TColors.accent.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Get in Touch',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? TColors.textDarkPrimary : TColors.textPrimary,
                  ),
                ),
                const SizedBox(height: TSizes.md),
                _buildContactRow(
                  context,
                  Iconsax.sms,
                  company.contact.email,
                  dark,
                ),
                const SizedBox(height: TSizes.sm),
                _buildContactRow(
                  context,
                  Iconsax.global,
                  company.contact.website,
                  dark,
                ),
                const SizedBox(height: TSizes.sm),
                _buildContactRow(
                  context,
                  Iconsax.call,
                  company.contact.phone,
                  dark,
                ),
              ],
            ),
          ),
          const SizedBox(height: TSizes.xl),

          // Copyright
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.lg,
              vertical: TSizes.md,
            ),
            decoration: BoxDecoration(
              color: TColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
              border: Border.all(
                color: TColors.accent.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              company.copyright,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TColors.accent,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(BuildContext context, IconData icon, String text, bool dark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.md,
        vertical: TSizes.sm,
      ),
      decoration: BoxDecoration(
        color: TColors.accent.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(TSizes.xs),
            decoration: BoxDecoration(
              color: TColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TSizes.cardRadiusXs),
            ),
            child: Icon(
              icon,
              color: TColors.accent,
              size: TSizes.iconSm,
            ),
          ),
          const SizedBox(width: TSizes.md),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: dark ? TColors.textDarkPrimary : TColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalSection(BuildContext context, Legal legal, bool dark) {
    return Container(
      decoration: BoxDecoration(
        color: dark ? TColors.darkContainer : TColors.white,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        border: Border.all(
          color: dark 
              ? TColors.borderDark.withOpacity(0.1)
              : TColors.borderLight.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: dark 
                ? TColors.black.withOpacity(0.2)
                : TColors.darkGrey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(TSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(TSizes.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      TColors.info.withOpacity(0.15),
                      TColors.info.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                ),
                child: Icon(
                  Iconsax.shield_tick,
                  color: TColors.info,
                  size: TSizes.iconLg,
                ),
              ),
              const SizedBox(width: TSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Legal Information',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: dark ? TColors.textDarkPrimary : TColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: TSizes.xs),
                    Text(
                      'Your rights and our responsibilities',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: TColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.lg),

          _buildLegalItem(
            context,
            'Privacy Policy',
            legal.privacyPolicy,
            Iconsax.lock,
            dark,
          ),
          const SizedBox(height: TSizes.md),
          
          _buildLegalItem(
            context,
            'Terms of Service',
            legal.termsOfService,
            Iconsax.document_text,
            dark,
          ),
          const SizedBox(height: TSizes.md),
          
          _buildLegalItem(
            context,
            'Disclaimer',
            legal.disclaimer,
            Iconsax.info_circle,
            dark,
          ),
        ],
      ),
    );
  }

  Widget _buildLegalItem(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    bool dark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TSizes.lg),
      decoration: BoxDecoration(
        color: TColors.info.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
        border: Border.all(
          color: TColors.info.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(TSizes.sm),
                decoration: BoxDecoration(
                  color: TColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                ),
                child: Icon(
                  icon,
                  color: TColors.info,
                  size: TSizes.iconMd,
                ),
              ),
              const SizedBox(width: TSizes.md),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TColors.info,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.md),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: TColors.textSecondary,
              height: 1.5,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'shopping_bag':
        return Iconsax.shopping_bag;
      case 'favorite':
        return Iconsax.heart;
      case 'shopping_cart':
        return Iconsax.shopping_cart;
      case 'location_on':
        return Iconsax.location;
      case 'security':
        return Iconsax.security;
      case 'palette':
        return Iconsax.colorfilter;
      case 'dashboard':
        return Iconsax.element_4;
      case 'inventory':
        return Iconsax.box;
      case 'receipt_long':
        return Iconsax.receipt_2;
      case 'analytics':
        return Iconsax.chart;
      case 'chat':
        return Iconsax.message;
      default:
        return Iconsax.star;
    }
  }
}