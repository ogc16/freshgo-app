import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/products.dart';
import '../i18n/strings.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../utils/formatters.dart';
import '../widgets/app_image.dart';
import '../widgets/ui.dart';

final _promoBanners = [
  {'title': 'Fresh Produce & Essentials', 'sub': 'Delivered in 30 mins', 'badge': '30% OFF', 'color': green, 'image': 'assets/images/banners/groceries.jpg'},
  {'title': 'Gas Cylinder Refills', 'sub': 'Book now, delivered today', 'badge': 'Book Now', 'color': const Color(0xFFD84315), 'image': 'assets/images/banners/gas.jpg'},
  {'title': 'Pure Water Refills', 'sub': '20L from UGX 2,000', 'badge': 'Order Now', 'color': info, 'image': 'assets/images/banners/water.jpg'},
];

class HomeScreen extends StatefulWidget {
  final ValueChanged<String> onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _category = 'groceries';
  String _search = '';
  int _bannerIdx = 0;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _products {
    if (_search.isEmpty) return products[_category]!;
    return allProducts.where((p) => p.name.toLowerCase().contains(_search.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final locale = context.watch<LocaleProvider>().locale;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          color: green,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('FreshGo', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 1),
                      Text('\u{1F4CD} ${tr('home.location', locale)}', style: const TextStyle(color: Color(0xB3FFFFFF), fontSize: 12)),
                    ],
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 22),
                        onPressed: () => cart.openCart(),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.15),
                          shape: const CircleBorder(),
                        ),
                      ),
                      if (cart.itemCount > 0)
                        Positioned(
                          right: 4, top: 4,
                          child: Container(
                            width: 18, height: 18,
                            decoration: const BoxDecoration(color: amber, shape: BoxShape.circle),
                            child: Center(
                              child: Text('${cart.itemCount}',
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const Icon(Icons.search, size: 18, color: txt3),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _search = v),
                        decoration: InputDecoration(
                          hintText: tr('home.searchHint', locale),
                          hintStyle: const TextStyle(fontSize: 14, color: txt3),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        style: const TextStyle(fontSize: 14, color: txt),
                      ),
                    ),
                    if (_search.isNotEmpty)
                      GestureDetector(
                        onTap: () { _searchController.clear(); setState(() => _search = ''); },
                        child: const Icon(Icons.close, size: 16, color: txt3),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.only(bottom: 72),
                children: [
                  if (_search.isEmpty) ...[
                    GestureDetector(
                      onTap: () => setState(() => _bannerIdx = (_bannerIdx + 1) % _promoBanners.length),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(rad),
                        ),
                        child: Stack(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 130,
                              child: AppImage(
                                assetPath: _promoBanners[_bannerIdx]['image'] as String?,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    (_promoBanners[_bannerIdx]['color'] as Color).withValues(alpha: 0.85),
                                    (_promoBanners[_bannerIdx]['color'] as Color).withValues(alpha: 0.4),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('\u26A1 Limited Offer',
                                          style: TextStyle(color: amber, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
                                      const SizedBox(height: 5),
                                      Text(_promoBanners[_bannerIdx]['title'] as String,
                                          style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800, height: 1.25)),
                                      const SizedBox(height: 5),
                                      Text(_promoBanners[_bannerIdx]['sub'] as String,
                                          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(color: amber, borderRadius: BorderRadius.circular(20)),
                                    child: Text(_promoBanners[_bannerIdx]['badge'] as String,
                                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_promoBanners.length, (i) {
                        final active = i == _bannerIdx;
                        return GestureDetector(
                          onTap: () => setState(() => _bannerIdx = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: active ? 18 : 6, height: 6,
                            decoration: BoxDecoration(
                              color: active ? green : const Color(0xFFD0C8BE),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(tr('home.categories', locale), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                          Text(tr('home.seeAll', locale), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: green)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 86,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        children: [
                          CategoryIcon(
                            icon: Icons.egg_outlined, label: 'Groceries',
                            color: const Color(0xFF66BB6A), isActive: _category == 'groceries',
                            onTap: () => setState(() => _category = 'groceries'),
                          ),
                          const SizedBox(width: 10),
                          CategoryIcon(
                            icon: Icons.restaurant_outlined, label: 'Food',
                            color: const Color(0xFFFF7043), isActive: _category == 'food',
                            onTap: () => setState(() => _category = 'food'),
                          ),
                          const SizedBox(width: 10),
                          CategoryIcon(
                            icon: Icons.local_fire_department_outlined, label: 'Gas',
                            color: const Color(0xFFEF5350), isActive: _category == 'gas',
                            onTap: () => setState(() => _category = 'gas'),
                          ),
                          const SizedBox(width: 10),
                          CategoryIcon(
                            icon: Icons.water_drop_outlined, label: 'Water',
                            color: const Color(0xFF42A5F5), isActive: _category == 'water',
                            onTap: () => setState(() => _category = 'water'),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _search.isNotEmpty ? '${tr('home.resultsFor', locale)} "$_search"' : '${categoryMeta[_category]!['label']} ${tr('home.items', locale)}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        Text(tr('home.seeAll', locale), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: green)),
                      ],
                    ),
                  ),
                  if (_products.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      child: Column(
                        children: [
                          const Text('\u{1F50D}', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 12),
                          Text(tr('home.noItemsFound', locale), style: const TextStyle(fontWeight: FontWeight.w600, color: txt3)),
                          const SizedBox(height: 6),
                          Text(tr('home.tryDifferentSearch', locale), style: const TextStyle(fontSize: 13, color: txt3)),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: _products.length,
                        itemBuilder: (_, i) => _ProductCard(
                          product: _products[i],
                          qty: cart.cart[_products[i].id] ?? 0,
                          onAdd: () => cart.addItem(_products[i].id),
                          onRemove: () => cart.removeItem(_products[i].id),
                        ),
                      ),
                    ),
                ],
              ),
              if (cart.cartOpen) _CartOverlay(onCheckout: () { cart.closeCart(); widget.onNavigate('checkout'); }),
            ],
          ),
        ),
        BottomNav(active: 'home', onNavigate: widget.onNavigate),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final int qty;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  const _ProductCard({required this.product, required this.qty, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final bgColor = parseColor(product.bg);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(rad),
        border: Border.all(color: const Color(0xFFE8E4DF), width: 0.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            color: bgColor,
            child: AppImage(
              assetPath: product.localImage,
              networkUrl: product.imageUrl,
              emoji: product.emoji,
              width: double.infinity,
              height: 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: parseColor(product.tagColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(product.tag, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: parseColor(product.tagTxt))),
                ),
                const SizedBox(height: 4),
                Text(product.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(product.unit, style: const TextStyle(fontSize: 11, color: txt3)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(fmt(product.price), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: green)),
                    QtyControl(qty: qty, onAdd: onAdd, onRemove: onRemove),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartOverlay extends StatelessWidget {
  final VoidCallback onCheckout;
  const _CartOverlay({required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return GestureDetector(
      onTap: () => cart.closeCart(),
      child: Container(
        color: Colors.black.withValues(alpha: 0.45),
        child: GestureDetector(
          onTap: () {},
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: border, borderRadius: BorderRadius.circular(2)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: 'My Cart \u{1F6D2}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                            children: [
                              if (cart.itemCount > 0)
                                TextSpan(
                                  text: ' (${cart.itemCount} items)',
                                  style: const TextStyle(fontSize: 13, color: txt3, fontWeight: FontWeight.w500),
                                ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => cart.closeCart(),
                          child: const Text('\u00D7', style: TextStyle(fontSize: 22, color: txt2)),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: borderLight),
                  Flexible(
                    child: cart.cartItems.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                            child: Column(
                              children: [
                                Text('\u{1F6D2}', style: TextStyle(fontSize: 52)),
                                SizedBox(height: 12),
                                Text('Your cart is empty', style: TextStyle(fontWeight: FontWeight.w600, color: txt3)),
                                SizedBox(height: 4),
                                Text('Add items from the store to get started', style: TextStyle(fontSize: 13, color: txt3)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: cart.cartItems.length,
                            itemBuilder: (_, i) {
                              final item = cart.cartItems[i];
                              return _CartItemRow(item: item);
                            },
                          ),
                  ),
                  if (cart.cartItems.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Subtotal', style: TextStyle(fontSize: 14, color: txt2)),
                              Text(fmt(cart.cartTotal), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: green)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Delivery fee', style: TextStyle(fontSize: 12, color: txt3)),
                              Text('Free \u{1F389}', style: TextStyle(fontSize: 13, color: green, fontWeight: FontWeight.w700)),
                            ],
                          ),
                          const SizedBox(height: 14),
                          PrimaryButton(text: 'Proceed to Checkout \u2192', onPressed: onCheckout),
                        ],
                      ),
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

class _CartItemRow extends StatelessWidget {
  final MapEntry<Product, int> item;
  const _CartItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final p = item.key;
    final qty = item.value;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF5F2EE), width: 0.5))),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 46, height: 46,
              color: parseColor(p.bg),
              child: AppImage(
                assetPath: p.localImage,
                networkUrl: p.imageUrl,
                emoji: p.emoji,
                width: 46,
                height: 46,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12, color: txt2),
                    children: [
                      TextSpan(text: '${fmt(p.price)} \u00D7 $qty = '),
                      TextSpan(text: fmt(p.price * qty), style: const TextStyle(color: green, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          QtyControl(qty: qty, onAdd: () => cart.addItem(p.id), onRemove: () => cart.removeItem(p.id), small: true),
        ],
      ),
    );
  }
}
