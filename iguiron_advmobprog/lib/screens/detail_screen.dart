import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../widgets/custom_text.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.product});

  final Product product;

  static final Color _priceColor = Colors.amber.shade800;

  // enhancement 3: add this product to the current user's cart by passing its id and quantity to POST /carts/add, per https://dummyjson.com/carts/add
  Future<void> _addToCart(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final cart = await CartService().addToCart(kCurrentUserId, [
        {'id': product.id, 'quantity': 1},
      ]);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Added "${product.title}" to cart. Cart total: \$${cart.total.toStringAsFixed(2)}',
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Failed to add to cart: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Product Details'),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroImage(thumbnail: product.thumbnail),

            // Content sheet, overlapping the hero image with rounded top
            // corners for a clearer visual break from the image.
            Transform.translate(
              offset: Offset(0, -20.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20.r, 24.r, 20.r, 20.r),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: CustomText(
                        text: product.category.toUpperCase(),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        fontColor: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    if (product.brand != null && product.brand!.isNotEmpty) ...[
                      CustomText(
                        text: product.brand!.toUpperCase(),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        fontColor: colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(height: 4.h),
                    ],
                    CustomText(
                      text: product.title,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      fontColor: colorScheme.onSurface,
                    ),
                    SizedBox(height: 8.h),

                    // Star Rating Row
                    Row(
                      children: [
                        _StarRating(rating: product.rating),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: product.rating.toStringAsFixed(1),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          fontColor: colorScheme.onSurface,
                        ),
                        CustomText(
                          text: ' / 5.0',
                          fontSize: 12.sp,
                          fontColor: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    CustomText(
                      text: '\$${product.price.toStringAsFixed(2)}',
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      fontColor: _priceColor,
                    ),
                    SizedBox(height: 16.h),

                    // Metadata Badges (Stock, Status)
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        _MetaChip(
                          icon: Icons.inventory_2_outlined,
                          label: '${product.stock} in stock',
                        ),
                        _MetaChip(
                          icon: Icons.check_circle_outline,
                          label: product.availabilityStatus,
                          iconColor: Colors.green,
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),
                    Divider(color: colorScheme.outlineVariant, height: 1),
                    SizedBox(height: 20.h),

                    // Description
                    CustomText(
                      text: 'Description',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontColor: colorScheme.onSurface,
                    ),
                    SizedBox(height: 8.h),
                    CustomText(
                      text: product.description,
                      fontSize: 14.sp,
                      fontColor: colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Enhancement 3: Add to Cart action, wired to CartService.addToCart
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton.icon(
              onPressed: () => _addToCart(context),
              icon: const Icon(Icons.add_shopping_cart),
              label: const CustomText(
                text: 'Add to Cart',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.thumbnail});

  final String thumbnail;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: 300.h,
      color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.r, 24.r, 24.r, 44.r),
          child: Image.network(
            thumbnail,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(
              Icons.image_not_supported_outlined,
              size: 64.sp,
              color: colorScheme.outline,
            ),
          ),
        ),
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  const _StarRating({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final threshold = index + 1;
        final IconData icon;
        if (rating >= threshold) {
          icon = Icons.star_rounded;
        } else if (rating >= threshold - 0.5) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_border_rounded;
        }
        return Icon(icon, size: 16.sp, color: Colors.amber.shade700);
      }),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16.sp,
            color: iconColor ?? colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 6.w),
          CustomText(
            text: label,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            fontColor: colorScheme.onSurface,
          ),
        ],
      ),
    );
  }
}
