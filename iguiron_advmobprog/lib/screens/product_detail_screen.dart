import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/product.dart';
import '../widgets/custom_text.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

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
            // Product Hero Image Showcase
            Container(
              width: double.infinity,
              height: 320.h,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: Image.network(
                    product.thumbnail,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.image_not_supported_outlined,
                      size: 64.sp,
                      color: colorScheme.outline,
                    ),
                  ),
                ),
              ),
            ),

            // Content Section
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
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
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber.shade700,
                            size: 20.sp,
                          ),
                          SizedBox(width: 4.w),
                          CustomText(
                            text: product.rating.toStringAsFixed(1),
                            fontSize: 14.sp,
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
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Title & Price Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: product.title,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          fontColor: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      CustomText(
                        text: '\$${product.price.toStringAsFixed(2)}',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        fontColor: colorScheme.primary,
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Metadata Badges (Brand, Stock, Status)
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      if (product.brand != null && product.brand!.isNotEmpty)
                        _MetaChip(
                          icon: Icons.storefront_outlined,
                          label: product.brand!,
                        ),
                      _MetaChip(
                        icon: Icons.inventory_2_outlined,
                        label: '${product.stock} left',
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
          ],
        ),
      ),
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
