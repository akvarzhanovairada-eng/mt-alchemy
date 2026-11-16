part of 'main.dart';

/// Educational DEMO checkout. No card data is collected and NO payment is made.
/// Only the workbook is a digital item. The other catalogue items are physical.
class MTCommerceService {
  static const workbookId = 'workbook';
  static const journalId = 'journal';
  static const cardsId = 'cards';

  static String idFor(ProductData product) {
    switch (product.title) {
      case 'Emotional Clarity Workbook': return workbookId;
      case 'Mindfulness Journal': return journalId;
      case 'Leadership Reflection Cards': return cardsId;
      default: throw StateError('Unknown product');
    }
  }

  static ProductData productFor(String id) {
    final title = switch (id) {
      workbookId => 'Emotional Clarity Workbook',
      journalId => 'Mindfulness Journal',
      cardsId => 'Leadership Reflection Cards',
      _ => '',
    };
    for (final product in demoProducts) {
      if (product.title == title) return product;
    }
    throw StateError('Product not found: $id');
  }

  static int priceFor(String id) => switch (id) {
    workbookId => 35,
    journalId => 45,
    cardsId => 55,
    _ => throw StateError('Unknown product'),
  };

  static bool isPhysical(String id) => id != workbookId;

  static User get _user {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('Please log in before shopping.');
    return user;
  }

  static CollectionReference<Map<String, dynamic>> get _cart =>
      FirebaseFirestore.instance.collection('carts').doc(_user.uid).collection('items');

  static CollectionReference<Map<String, dynamic>> get _orders =>
      FirebaseFirestore.instance.collection('orders').doc(_user.uid).collection('items');

  static Stream<QuerySnapshot<Map<String, dynamic>>> watchCart() => _cart.snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> watchOrders() => _orders.snapshots();

  static Future<void> add(ProductData product) async {
    final ref = _cart.doc(idFor(product));
    await FirebaseFirestore.instance.runTransaction<void>((tx) async {
      final current = await tx.get(ref);
      final quantity = ((current.data()?['quantity'] as int?) ?? 0) + 1;
      if (quantity > 10) throw StateError('Maximum 10 per product.');
      tx.set(ref, {
        'quantity': quantity,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  static Future<void> setQuantity(String id, int quantity) async {
    final ref = _cart.doc(id);
    if (quantity <= 0) {
      await ref.delete();
    } else if (quantity <= 10) {
      await ref.update({'quantity': quantity, 'updatedAt': FieldValue.serverTimestamp()});
    } else {
      throw StateError('Maximum 10 per product.');
    }
  }

  static int subtotal(QuerySnapshot<Map<String, dynamic>> snapshot) {
    var sum = 0;
    for (final item in snapshot.docs) {
      if (item.id == workbookId || item.id == journalId || item.id == cardsId) {
        final q = item.data()['quantity'];
        if (q is int) sum += q * priceFor(item.id);
      }
    }
    return sum;
  }

  static bool hasPhysical(QuerySnapshot<Map<String, dynamic>> snapshot) =>
      snapshot.docs.any((item) => isPhysical(item.id));

  static Future<String> placeDemoOrder({required String recipient,
    required String address, required String city, required String postcode}) async {
    final snapshot = await _cart.get();
    if (snapshot.docs.isEmpty) throw StateError('Your cart is empty.');
    final items = <Map<String, dynamic>>[];
    for (final item in snapshot.docs) {
      final qty = item.data()['quantity'];
      if (qty is! int || qty < 1 || qty > 10) throw StateError('Invalid cart quantity.');
      priceFor(item.id); // verifies product ID
      items.add({'id': item.id, 'quantity': qty, 'priceRm': priceFor(item.id)});
    }
    final physical = items.any((item) => isPhysical(item['id'] as String));
    if (physical && (address.trim().isEmpty || city.trim().isEmpty || postcode.trim().isEmpty)) {
      throw StateError('Shipping information is required for physical products.');
    }
    final orderRef = _orders.doc();
    final batch = FirebaseFirestore.instance.batch();
    final ship = physical ? 8 : 0;
    batch.set(orderRef, {
      'items': items,
      'subtotalRm': subtotal(snapshot),
      'shippingRm': ship,
      'totalRm': subtotal(snapshot) + ship,
      'shipping': {
        'recipient': recipient.trim(),
        'address': physical ? address.trim() : '',
        'city': physical ? city.trim() : '',
        'postcode': physical ? postcode.trim() : '',
      },
      'status': 'demo-confirmed',
      'paymentStatus': 'not-charged',
      'createdAt': FieldValue.serverTimestamp(),
    });
    for (final item in snapshot.docs) {
      batch.delete(item.reference);
    }
    await batch.commit();
    return orderRef.id;
  }
}

class MTCartPage extends StatelessWidget {
  const MTCartPage({super.key});

  Future<void> _change(BuildContext context, String id, int qty) async {
    try { await MTCommerceService.setQuantity(id, qty); }
    catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not update cart: $e')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const SiteHeader(),
    body: SingleChildScrollView(child: Column(children: [
      const SimplePageHero(eyebrow: 'MY CART', title: 'Your selected resources.',
          description: 'Cart items are saved to your Firebase account across devices.'),
      SectionWrapper(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: MTCommerceService.watchCart(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Text('Could not load cart. Check your connection and Firestore Rules.');
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final lines = snapshot.data!.docs;
          if (lines.isEmpty) return Column(children: [
            const Icon(Icons.shopping_bag_outlined, size: 54, color: AppColors.blue),
            const SizedBox(height: 12),
            const Text('Your cart is empty.'),
            const SizedBox(height: 15),
            FilledButton(onPressed: () => goTo(context, '/store'), child: const Text('Explore Store')),
          ]);
          final subtotal = MTCommerceService.subtotal(snapshot.data!);
          final shipping = MTCommerceService.hasPhysical(snapshot.data!) ? 8 : 0;
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ...lines.map((line) {
              final product = MTCommerceService.productFor(line.id);
              final quantity = line.data()['quantity'] as int? ?? 1;
              return Card(margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(padding: const EdgeInsets.all(16),
                      child: Row(children: [
                        ClipRRect(borderRadius: BorderRadius.circular(12),
                            child: Image.asset(product.image, width: 85, height: 85, fit: BoxFit.cover)),
                        const SizedBox(width: 16),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(product.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                          Text(product.type, style: const TextStyle(color: Colors.black54)),
                          Text('RM${MTCommerceService.priceFor(line.id)} each'),
                        ])),
                        IconButton(onPressed: () => _change(context, line.id, quantity - 1),
                            icon: const Icon(Icons.remove_circle_outline)),
                        Text('$quantity', style: const TextStyle(fontWeight: FontWeight.w900)),
                        IconButton(onPressed: quantity >= 10 ? null : () => _change(context, line.id, quantity + 1),
                            icon: const Icon(Icons.add_circle_outline)),
                      ])));
            }),
            const SizedBox(height: 12),
            Card(child: Padding(padding: const EdgeInsets.all(24),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Subtotal: RM$subtotal', style: const TextStyle(fontSize: 18)),
                  Text('Shipping: RM$shipping (demo)', style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 8),
                  Text('Demo total: RM${subtotal + shipping}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 14),
                  const Text('Demo only: no real payments or fulfillment.',
                      style: TextStyle(color: Colors.black54, fontSize: 12)),
                  const SizedBox(height: 14),
                  FilledButton(onPressed: () => goTo(context, '/checkout'),
                      child: const Text('Proceed to demo checkout')),
                ]))),
          ]);
        },
      )),
      const SiteFooter(),
    ])),
  );
}

class MTCheckoutPage extends StatefulWidget {
  const MTCheckoutPage({super.key});
  @override
  State<MTCheckoutPage> createState() => _MTCheckoutPageState();
}

class _MTCheckoutPageState extends State<MTCheckoutPage> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final address = TextEditingController();
  final city = TextEditingController();
  final postcode = TextEditingController();
  bool saving = false;
  String? error;

  @override
  void initState() {
    super.initState();
    name.text = FirebaseAuth.instance.currentUser?.displayName ?? '';
  }

  @override
  void dispose() {
    name.dispose(); address.dispose(); city.dispose(); postcode.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    setState(() { saving = true; error = null; });
    try {
      await MTCommerceService.placeDemoOrder(recipient: name.text,
          address: address.text, city: city.text, postcode: postcode.text);
      if (mounted) goTo(context, '/my-orders');
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const SiteHeader(),
    body: SingleChildScrollView(child: Column(children: [
      const SimplePageHero(eyebrow: 'DEMO CHECKOUT', title: 'Confirm your selection.',
          description: 'This is a simulated order. No card information is required and no money will be charged.'),
      SectionWrapper(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: MTCommerceService.watchCart(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Text('Could not load cart.');
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.data!.docs.isEmpty) return const Text('Your cart is empty.');
          final physical = MTCommerceService.hasPhysical(snapshot.data!);
          final subtotal = MTCommerceService.subtotal(snapshot.data!);
          final shipping = physical ? 8 : 0;
          return Form(key: formKey, child: Card(child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Demo total: RM${subtotal + shipping}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              const Text('Payment status: Not charged · Test checkout only',
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 20),
              TextFormField(controller: name, decoration: const InputDecoration(labelText: 'Full name'),
                  validator: (v) => (v?.trim().isEmpty ?? true) ? 'Enter your name' : null),
              if (physical) ...[
                const SizedBox(height: 14),
                TextFormField(controller: address, decoration: const InputDecoration(labelText: 'Shipping address'),
                    validator: (v) => (v?.trim().isEmpty ?? true) ? 'Enter your shipping address' : null),
                const SizedBox(height: 14),
                TextFormField(controller: city, decoration: const InputDecoration(labelText: 'City'),
                    validator: (v) => (v?.trim().isEmpty ?? true) ? 'Enter your city' : null),
                const SizedBox(height: 14),
                TextFormField(controller: postcode, decoration: const InputDecoration(labelText: 'Postcode'),
                    validator: (v) => (v?.trim().isEmpty ?? true) ? 'Enter your postcode' : null),
              ],
              const SizedBox(height: 20),
              if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
              FilledButton.icon(onPressed: saving ? null : _confirm,
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text(saving ? 'Saving order...' : 'Confirm test order')),
            ]),
          )));
        },
      )),
      const SiteFooter(),
    ])),
  );
}

class MTOrdersPage extends StatelessWidget {
  const MTOrdersPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const SiteHeader(),
    body: SingleChildScrollView(child: Column(children: [
      const SimplePageHero(eyebrow: 'MY ORDERS', title: 'Your order history.',
          description: 'Orders are saved to your Firebase account. All payments are simulated.'),
      SectionWrapper(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: MTCommerceService.watchOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Text('Could not load orders.');
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.data!.docs.isEmpty) return const Text('No orders yet. Explore our Store!');
          final orders = [...snapshot.data!.docs];
          orders.sort((a, b) {
            final aTs = a.data()['createdAt'] as Timestamp?;
            final bTs = b.data()['createdAt'] as Timestamp?;
            return (bTs?.millisecondsSinceEpoch ?? 0).compareTo(aTs?.millisecondsSinceEpoch ?? 0);
          });
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ...orders.map((order) {
              final data = order.data();
              final items = data['items'] as List<dynamic>? ?? [];
              return Card(margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(padding: const EdgeInsets.all(22),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Order ${order.id.substring(0, 7).toUpperCase()}',
                            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        Text('Status: ${data['status']}  ·  Payment: ${data['paymentStatus']}',
                            style: const TextStyle(color: Colors.black54)),
                        const SizedBox(height: 8),
                        ...items.map((raw) {
                          final item = Map<String, dynamic>.from(raw as Map);
                          final product = MTCommerceService.productFor('${item['id']}');
                          return Text('${product.title} × ${item['quantity']}');
                        }),
                        const SizedBox(height: 8),
                        Text('Total: RM${data['totalRm']}',
                            style: const TextStyle(fontWeight: FontWeight.w800)),
                      ])));
            }),
            const SizedBox(height: 10),
            FilledButton(onPressed: () => goTo(context, '/my-digital-products'),
                child: const Text('My Digital Products')),
          ]);
        },
      )),
      const SiteFooter(),
    ])),
  );
}

class MTDigitalLibraryPage extends StatelessWidget {
  const MTDigitalLibraryPage({super.key});

  Future<void> _download(BuildContext context) async {
    try {
      final file = await rootBundle.load('assets/images/eq_workbook.pdf');
      await Printing.sharePdf(
        bytes: file.buffer.asUint8List(file.offsetInBytes, file.lengthInBytes),
        filename: 'MT_Alchemy_EQ_Workbook.pdf',
      );
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to open workbook: $e')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const SiteHeader(),
    body: SingleChildScrollView(child: Column(children: [
      const SimplePageHero(eyebrow: 'MY DIGITAL PRODUCTS', title: 'Your digital resources.',
          description: 'Access the workbook linked to your completed test orders.'),
      SectionWrapper(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: MTCommerceService.watchOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Text('Could not load orders.');
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final owned = snapshot.data!.docs.any((order) {
            final items = order.data()['items'] as List<dynamic>? ?? [];
            return items.any((raw) => raw is Map && raw['id'] == MTCommerceService.workbookId);
          });
          if (!owned) return Column(children: [
            const Text('You have no digital products from a test checkout yet.'),
            const SizedBox(height: 12),
            FilledButton(onPressed: () => goTo(context, '/store'), child: const Text('Explore Store')),
          ]);
          return Card(child: Padding(padding: const EdgeInsets.all(20),
              child: Row(children: [
                const Icon(Icons.picture_as_pdf_outlined, size: 37, color: AppColors.blue),
                const SizedBox(width: 15),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Emotional Clarity Workbook', style: TextStyle(fontWeight: FontWeight.w800)),
                  Text('PDF download · Educational demo resource'),
                ])),
                FilledButton(onPressed: () => _download(context), child: const Text('Download')),
              ])));
        },
      )),
      const SiteFooter(),
    ])),
  );
}
