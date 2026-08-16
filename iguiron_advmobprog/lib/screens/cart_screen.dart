import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';
import '../services/product_service.dart';
import '../widgets/custom_text.dart';
import 'detail_screen.dart';

// enhancement 1: renders the cart API endpoint. enhancement 3: only the current user's cart is loaded, via CartService.getCartByUserId.  
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<Cart?> _cartFuture;

  List<CartProduct> _products = [];

  @override
  void initState() {
    super.initState();
    _cartFuture = CartService().getCartByUserId(kCurrentUserId);
  }

  void _changeQuantity(int index, int delta) {
    setState(() {
      final product = _products[index];
      final newQuantity = product.quantity + delta;
      if (newQuantity < 1) return;

      final discountedUnitPrice =
          product.price * (1 - product.discountPercentage / 100);

      _products[index] = CartProduct(
        id: product.id,
        title: product.title,
        price: product.price,
        quantity: newQuantity,
        total: product.price * newQuantity,
        discountPercentage: product.discountPercentage,
        discountedTotal: discountedUnitPrice * newQuantity,
        thumbnail: product.thumbnail,
      );
    });
  }

  double get _subtotal =>
      _products.fold(0.0, (sum, p) => sum + p.discountedTotal);

  // Enhancement 1: cart items are clickable and reuse detail_screen. A cart
  // product only carries a product id, so the matching product is fetched by
  // id and the same DetailScreen widget used by product_screen is pushed.
  Future<void> _openProductDetail(BuildContext context, int productId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final product = await ProductService().getProductById(productId);
      if (!context.mounted) return;
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => DetailScreen(product: product)),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to open product: $e')));
    }
  }

  void _confirmOrder() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order confirmed! Total: \$${_subtotal.toStringAsFixed(2)}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<Cart?>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: CustomText(text: 'Error: ${snapshot.error}', fontSize: 14.sp),
            );
          }

          final cart = snapshot.data;
          if (cart == null || cart.products.isEmpty) {
            return Center(
              child: CustomText(text: 'Your cart is empty.', fontSize: 14.sp),
            );
          }

          if (_products.isEmpty) {
            _products = List.of(cart.products);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(16.r),
                  itemCount: _products.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) =>
                      _CartItemCard(
                        product: _products[index],
                        onTap: () =>
                            _openProductDetail(context, _products[index].id),
                        onIncrement: () => _changeQuantity(index, 1),
                        onDecrement: () => _changeQuantity(index, -1),
                      ),
                ),
              ),
              _CartSummary(subtotal: _subtotal, onConfirm: _confirmOrder),
            ],
          );
        },
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.product,
    required this.onTap,
    required this.onIncrement,
    required this.onDecrement,
  });

  final CartProduct product;
  final VoidCallback onTap;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Padding(
          padding: EdgeInsets.all(10.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  product.thumbnail,
                  width: 64.w,
                  height: 64.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(Icons.image, size: 32.sp),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: product.title,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text: '\$${product.price.toStringAsFixed(2)}',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      fontColor: colorScheme.primary,
                    ),
                    if (product.discountPercentage > 0)
                      CustomText(
                        text:
                            '${product.discountPercentage.toStringAsFixed(0)}% off · \$${product.discountedTotal.toStringAsFixed(2)} total',
                        fontSize: 11.sp,
                        fontColor: Colors.green.shade700,
                      ),
                  ],
                ),
              ),
              Column(
                children: [
                  _StepperButton(icon: Icons.add, onPressed: onIncrement),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: '${product.quantity}',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  _StepperButton(icon: Icons.remove, onPressed: onDecrement),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: Colors.amber.shade600,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Icon(icon, size: 14.sp, color: Colors.white),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.subtotal, required this.onConfirm});

  final double subtotal;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: 'Subtotal', fontSize: 14.sp),
              CustomText(
                text: '\$${subtotal.toStringAsFixed(2)}',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade700,
              ),
              onPressed: onConfirm,
              child: const CustomText(
                text: 'Confirm Order',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
