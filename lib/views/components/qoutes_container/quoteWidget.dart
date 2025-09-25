import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/model/quote_model/Quote_Model.dart';
import 'package:shoe_app_assigment/provider/quote_provider.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class QuoteWidget extends ConsumerWidget {
  const QuoteWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = HelperFunctions.isDarkMode(context);
    final quoteState = ref.watch(quoteProvider);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultSpace,
        vertical: TSizes.spaceBtwItems,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: dark
                ? [
                    TColors.darkContainer,
                    TColors.darkContainer.withOpacity(0.8),
                  ]
                : [TColors.white, TColors.lightContainer.withOpacity(0.5)],
          ),
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
                  : TColors.darkGrey.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          child: Stack(
            children: [
              // Background Pattern
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: TColors.newBlue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),

              // Main Content
              Padding(
                padding: const EdgeInsets.all(TSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(TSizes.sm),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                TColors.newBlue.withOpacity(0.1),
                                TColors.primary.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              TSizes.cardRadiusMd,
                            ),
                          ),
                          child: Icon(
                            Iconsax.quote_up,
                            color: TColors.newBlue,
                            size: TSizes.iconMd,
                          ),
                        ),
                        const SizedBox(width: TSizes.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quote of the Day',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: dark
                                          ? TColors.textDarkPrimary
                                          : TColors.textPrimary,
                                    ),
                              ),
                              Text(
                                'Get inspired while shopping',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: TColors.textSecondary,
                                      fontSize: 12,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        // Refresh Button
                        Container(
                          decoration: BoxDecoration(
                            color: dark
                                ? TColors.darkContainer
                                : TColors.lightContainer,
                            borderRadius: BorderRadius.circular(
                              TSizes.cardRadiusMd,
                            ),
                          ),
                          child: IconButton(
                            onPressed: quoteState.isLoading
                                ? null
                                : () {
                                    ref
                                        .read(quoteProvider.notifier)
                                        .refreshQuote();
                                  },
                            icon: AnimatedRotation(
                              turns: quoteState.isLoading ? 1 : 0,
                              duration: const Duration(seconds: 1),
                              child: Icon(
                                Iconsax.refresh,
                                color: quoteState.isLoading
                                    ? TColors.darkGrey
                                    : TColors.newBlue,
                                size: TSizes.iconMd,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: TSizes.lg),

                    // Quote Content
                    _buildQuoteContent(context, quoteState, dark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteContent(
    BuildContext context,
    QuoteState quoteState,
    bool dark,
  ) {
    if (quoteState.isLoading) {
      return _buildLoadingState(context, dark);
    }

    if (quoteState.error != null) {
      return _buildErrorState(context, quoteState.error!, dark);
    }

    if (quoteState.quote != null) {
      return _buildQuoteDisplay(context, quoteState.quote!, dark);
    }

    return _buildLoadingState(context, dark);
  }

  Widget _buildLoadingState(BuildContext context, bool dark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shimmer effect for quote
        Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: dark
                ? TColors.darkGrey.withOpacity(0.1)
                : TColors.lightGrey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(TColors.newBlue),
                  ),
                ),
                const SizedBox(width: TSizes.sm),
                Text(
                  'Loading inspiration...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: TColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String error, bool dark) {
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        color: TColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TSizes.cardRadiusSm),
        border: Border.all(color: TColors.error.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Icon(Iconsax.warning_2, color: TColors.error, size: TSizes.iconMd),
          const SizedBox(width: TSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unable to load quote',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: TColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Tap refresh to try again',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: TColors.error.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteDisplay(BuildContext context, QuoteModel quote, bool dark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quote Content
        Container(
          padding: const EdgeInsets.all(TSizes.md),
          decoration: BoxDecoration(
            color: dark
                ? TColors.darkContainer.withOpacity(0.3)
                : TColors.newBlue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
            border: Border.all(
              color: TColors.newBlue.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Opening Quote Mark
              Icon(
                Iconsax.quote_up,
                color: TColors.newBlue.withOpacity(0.6),
                size: 24,
              ),
              const SizedBox(height: TSizes.xs),

              // Quote Text
              Text(
                quote.content,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: dark ? TColors.textDarkPrimary : TColors.textPrimary,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: TSizes.sm),

              // Author
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 2,
                    decoration: BoxDecoration(
                      color: TColors.newBlue.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  const SizedBox(width: TSizes.xs),
                  Expanded(
                    child: Text(
                      quote.author,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: TColors.newBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // Closing Quote Mark
              const SizedBox(height: TSizes.xs),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Iconsax.quote_down,
                  color: TColors.newBlue.withOpacity(0.6),
                  size: 24,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: TSizes.sm),

        // Tags (if available)
        if (quote.tags.isNotEmpty)
          Wrap(
            spacing: TSizes.xs,
            runSpacing: TSizes.xs,
            children: quote.tags.take(3).map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.sm,
                  vertical: TSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: TColors.newBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusXs),
                  border: Border.all(
                    color: TColors.newBlue.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  '#$tag',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: TColors.newBlue,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
