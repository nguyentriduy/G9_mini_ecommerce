import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/cart_badge_button.dart';
import '../widgets/category_section.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'order_history_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadInitial();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final provider = context.read<ProductProvider>();
    final scrolled = _scrollController.offset > 12;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400) {
      provider.loadMore();
    }
  }

  Future<void> _openCart() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CartScreen()));
  }

  Future<void> _openOrders() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const OrderHistoryScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Consumer<ProductProvider>(
        builder: (context, products, child) {
          if (_searchController.text != products.searchQuery) {
            _searchController.value = TextEditingValue(
              text: products.searchQuery,
              selection: TextSelection.collapsed(
                offset: products.searchQuery.length,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: products.refresh,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 138,
                  backgroundColor: _isScrolled
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  elevation: _isScrolled ? 2 : 0,
                  title: const Text(
                    'TH4 - Nhóm 9',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                  flexibleSpace: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isScrolled
                            ? [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary,
                              ]
                            : [
                                const Color(0xFFF97316),
                                const Color(0xFFFB7185),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: _openOrders,
                      icon: const Icon(Icons.receipt_long_outlined),
                    ),
                    CartBadgeButton(onPressed: _openCart),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(72),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: TextField(
                        controller: _searchController,
                        onChanged: products.updateSearchQuery,
                        decoration: InputDecoration(
                          hintText: 'Tìm sản phẩm, danh mục...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: products.searchQuery.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () =>
                                      products.updateSearchQuery(''),
                                  icon: const Icon(Icons.close_rounded),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                    child: BannerCarousel(images: products.bannerImages),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFF3E7), Color(0xFFFFE3C7)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_fire_department_rounded,
                              color: Color(0xFFEA580C),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Flash Sale 12h-14h: Voucher giảm đến 50% toàn sàn',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF9A3412),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 18, 16, 12),
                    child: Text(
                      'Danh mục nổi bật',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CategorySection(
                    categories: products.availableCategories,
                    selectedCategory: products.selectedCategory,
                    onSelected: products.updateCategory,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 18, 16, 12),
                    child: Text(
                      'Gợi ý hôm nay',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                if (products.isLoading && products.products.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (products.error != null && products.products.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Không tải được dữ liệu sản phẩm.'),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: products.refresh,
                              child: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else if (products.displayedProducts.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('Không có sản phẩm phù hợp.')),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final product = products.displayedProducts[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailScreen(product: product),
                              ),
                            );
                          },
                        );
                      }, childCount: products.displayedProducts.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.62,
                          ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Center(
                      child: products.isLoadingMore
                          ? const CircularProgressIndicator()
                          : products.hasMore
                          ? const SizedBox.shrink()
                          : const Text(
                              'Bạn đã xem hết gợi ý hôm nay.',
                              style: TextStyle(color: Color(0xFF6B7280)),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
