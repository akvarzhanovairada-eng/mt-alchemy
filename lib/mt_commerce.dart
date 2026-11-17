part of 'main.dart';

/// MT Alchemy coursework: DEMONSTRATION transactions only.
/// No bank, payment provider or card vault is connected. The number and CVC typed
/// into the demo payment form are never stored in Firestore or analytics.
class MTCommerceService {
  static const workbookId = 'workbook';
  static const journalId = 'journal';
  static const cardsId = 'cards';
  static const eqCourseId = 'eq-fundamentals';
  static const demoEqPriceRm = 99;

  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static User get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('Please sign in to continue.');
    return user;
  }

  static CollectionReference<Map<String, dynamic>> get cart =>
      db.collection('carts').doc(currentUser.uid).collection('items');
  static CollectionReference<Map<String, dynamic>> get orders =>
      db.collection('orders').doc(currentUser.uid).collection('items');
  static DocumentReference<Map<String, dynamic>> accessRef([String courseId = eqCourseId]) =>
      db.collection('courseAccess').doc(currentUser.uid).collection('courses').doc(courseId);

  static String idFor(ProductData product) {
    if (product.id.isNotEmpty) return product.id;
    switch (product.title) {
      case 'Emotional Clarity Workbook': return workbookId;
      case 'Mindfulness Journal': return journalId;
      case 'Leadership Reflection Cards': return cardsId;
      default: throw StateError('Product has not been added to the catalogue.');
    }
  }

  static ProductData productFor(String id) {
    final titles = {workbookId: 'Emotional Clarity Workbook', journalId: 'Mindfulness Journal', cardsId: 'Leadership Reflection Cards'};
    for (final product in demoProducts) {
      if (product.title == titles[id]) return product;
    }
    throw StateError('Unknown catalogue item: $id');
  }

  static int priceFor(String id) => switch (id) {
    workbookId => 35,
    journalId => 45,
    cardsId => 55,
    _ => throw StateError('Price requires a catalogue lookup.'),
  };

  static Future<ProductData> loadProduct(String id) async {
    final snap = await db.collection('products').doc(id).get();
    if (snap.exists && snap.data() != null) {
      return ProductData.fromDocument(id, snap.data()!);
    }
    return productFor(id); // Legacy example items until Admin imports the demo catalogue.
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> watchProducts() =>
      db.collection('products').snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> watchCart() => cart.snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> watchOrders() => orders.snapshots();
  static Stream<DocumentSnapshot<Map<String, dynamic>>> watchCourseAccess() =>
      accessRef().snapshots();

  static Future<bool> canStartEq() async {
    if (FirebaseAuth.instance.currentUser == null) return false;
    final priorEnrolment = await db.collection('enrollments')
        .doc(currentUser.uid).collection('courses').doc(eqCourseId).get();
    if (priorEnrolment.exists) return true; // Keep previously completed work.
    final access = await accessRef().get();
    return access.exists;
  }

  static Future<void> add(ProductData product) async {
    final id = idFor(product);
    final productData = await loadProduct(id);
    if (!productData.published) throw StateError('This product is not available.');
    if (productData.type.startsWith('Physical') && productData.stock <= 0) {
      throw StateError('This product is currently out of stock.');
    }
    final ref = cart.doc(id);
    await db.runTransaction<void>((transaction) async {
      final existing = await transaction.get(ref);
      final count = (existing.data()?['quantity'] as int? ?? 0) + 1;
      if (count > 10) throw StateError('Maximum 10 items per product.');
      transaction.set(ref, {'quantity': count, 'updatedAt': FieldValue.serverTimestamp()});
    });
  }

  static Future<void> setQuantity(String id, int quantity) async {
    final ref = cart.doc(id);
    if (quantity < 1) {
      await ref.delete();
      return;
    }
    if (quantity > 10) throw StateError('Maximum quantity is 10.');
    await ref.update({'quantity': quantity, 'updatedAt': FieldValue.serverTimestamp()});
  }

  static Future<List<MTPurchaseLine>> getCartLines() async {
    final snapshot = await cart.get();
    return linesForSnapshot(snapshot);
  }

  static Future<List<MTPurchaseLine>> linesForSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot,
      ) async {
    final results = await Future.wait(snapshot.docs.map((doc) async {
      final product = await loadProduct(doc.id);
      final q = doc.data()['quantity'];
      if (q is! int || q < 1 || q > 10) throw StateError('Invalid quantity in cart.');
      if (!product.published) throw StateError('${product.title} is unavailable.');
      if (product.type.startsWith('Physical') && product.stock < q) {
        throw StateError('${product.title} has insufficient demo stock.');
      }
      return MTPurchaseLine(
        id: doc.id, title: product.title, quantity: q,
        priceRm: product.unitPriceRm, kind: product.type.startsWith('Digital') ? 'digital' : 'physical',
        image: product.image,
      );
    }));
    return results;
  }

  static Future<int> eqPriceRm() async {
    final doc = await db.collection('courseCatalog').doc(eqCourseId).get();
    final raw = doc.data()?['priceRm'];
    return raw is int && raw >= 0 ? raw : demoEqPriceRm;
  }

  static Future<String> placePendingCartOrder({
    required String recipient, required String address,
    required String city, required String postcode,
  }) async {
    final items = await getCartLines();
    if (items.isEmpty) throw StateError('Your cart is empty.');
    final physical = items.any((x) => x.kind == 'physical');
    if (physical && (address.trim().isEmpty || city.trim().isEmpty || postcode.trim().isEmpty)) {
      throw StateError('Please enter your delivery address.');
    }
    final subtotal = items.fold<int>(0, (s, x) => s + x.priceRm * x.quantity);
    final shipping = physical ? 8 : 0;
    final ref = orders.doc();
    await ref.set({
      'userId': currentUser.uid,
      'kind': 'products',
      'items': items.map((x) => x.toMap()).toList(),
      'subtotalRm': subtotal, 'shippingRm': shipping, 'totalRm': subtotal + shipping,
      'currency': 'MYR', 'paymentMode': 'demo',
      'paymentStatus': 'pending', 'status': 'awaiting_payment',
      'shipping': {
        'recipient': recipient.trim(),
        'address': physical ? address.trim() : '',
        'city': physical ? city.trim() : '',
        'postcode': physical ? postcode.trim() : '',
      },
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  static Future<String> placePendingCourseOrder() async {
    final access = await canStartEq();
    if (access) throw StateError('You already have access to this course.');
    final price = await eqPriceRm();
    final ref = orders.doc();
    await ref.set({
      'userId': currentUser.uid, 'kind': 'course',
      'items': [MTPurchaseLine(id: eqCourseId, title: MTProgressService.courseName,
          quantity: 1, priceRm: price, kind: 'course', image: 'assets/images/course_eq.jpg').toMap()],
      'subtotalRm': price, 'shippingRm': 0, 'totalRm': price,
      'currency': 'MYR', 'paymentMode': 'demo',
      'paymentStatus': 'pending', 'status': 'awaiting_payment',
      'shipping': <String, String>{'recipient': currentUser.displayName ?? '', 'address': '', 'city': '', 'postcode': ''},
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  /// These sample values are NOT credit cards. They are intentionally fixed test
  /// sequences interpreted locally; no number/expiry/CVC is transmitted anywhere.
  static String simulatedOutcome(String digits) {
    switch (digits.replaceAll(RegExp(r'\D'), '')) {
      case '4242424242424242': return 'paid';
      case '4000000000000002': return 'failed';
      case '4000000000009995': return 'pending';
      default: throw StateError('Use one of the three DEMO card numbers shown below.');
    }
  }

  static Future<void> finishDemoPayment(String id, String demoNumber) async {
    final result = simulatedOutcome(demoNumber);
    final ref = orders.doc(id);
    final doc = await ref.get();
    if (!doc.exists || doc.data()?['paymentMode'] != 'demo') {
      throw StateError('This demo order is not available.');
    }
    if (doc.data()?['paymentStatus'] != 'pending') {
      throw StateError('This order is already processed.');
    }
    await ref.update({
      'paymentStatus': result,
      'status': result == 'paid' ? 'processing' : result == 'failed' ? 'payment_failed' : 'awaiting_payment',
      'processedAt': FieldValue.serverTimestamp(),
    });
    if (result == 'paid') {
      if (doc.data()?['kind'] == 'course') {
        await activateCourseFromOrder(id);
      } else if (doc.data()?['kind'] == 'corporate') {
        await activateEmployerSeatsFromOrder(id);
      } else {
        final raw = doc.data()?['items'] as List<dynamic>? ?? [];
        final batch = db.batch();
        for (final item in raw) {
          if (item is Map && item['id'] is String) {
            batch.delete(cart.doc(item['id'] as String));
          }
        }
        await batch.commit();
      }
    }
  }

  static Future<String> placePendingEmployerOrder(String orgId, int seats) async {
    if (seats < 1 || seats > 25) throw StateError('Choose 1 to 25 course seats.');
    final profile = await db.collection('users').doc(currentUser.uid).get();
    if (profile.data()?['role'] != 'employer' || profile.data()?['organizationId'] != orgId) {
      throw StateError('An approved employer account is required.');
    }
    final unitPrice = await eqPriceRm();
    final ref = orders.doc();
    await ref.set({
      'userId': currentUser.uid, 'kind': 'corporate', 'organizationId': orgId,
      'items': [MTPurchaseLine(id: eqCourseId, title: 'Corporate EQ training seats',
          quantity: seats, priceRm: unitPrice, kind: 'course',
          image: 'assets/images/course_eq.jpg').toMap()],
      'subtotalRm': unitPrice * seats, 'shippingRm': 0, 'totalRm': unitPrice * seats,
      'currency': 'MYR', 'paymentMode': 'demo',
      'paymentStatus': 'pending', 'status': 'awaiting_payment',
      'shipping': <String, String>{'recipient': '', 'address': '', 'city': '', 'postcode': ''},
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  static Future<void> activateEmployerSeatsFromOrder(String id) async {
    final doc = await orders.doc(id).get();
    final data = doc.data();
    if (data == null || data['kind'] != 'corporate' ||
        data['paymentMode'] != 'demo' || data['paymentStatus'] != 'paid') {
      throw StateError('The corporate demo order is not paid.');
    }
    final orgId = data['organizationId'] as String;
    final items = data['items'] as List<dynamic>? ?? [];
    if (items.isEmpty || items.first is! Map) throw StateError('No course seats found.');
    final seats = (items.first as Map)['quantity'];
    if (seats is! int || seats < 1) throw StateError('Invalid seat count.');
    final ref = db.collection('organizations').doc(orgId).collection('purchases').doc(id);
    if ((await ref.get()).exists) return;
    await ref.set({
      'orderId': id, 'courseId': eqCourseId,
      'seatsPurchased': seats, 'seatsUsed': 0,
      'purchasedBy': currentUser.uid, 'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> activateCourseFromOrder(String id) async {
    final doc = await orders.doc(id).get();
    final data = doc.data();
    if (data == null || data['kind'] != 'course' || data['paymentMode'] != 'demo' || data['paymentStatus'] != 'paid') {
      throw StateError('No successful course demo payment found.');
    }
    await accessRef().set({
      'courseId': eqCourseId,
      'source': 'demo-purchase',
      'purchaseOrderId': id,
      'grantedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> claimEmployerAssignment(String orgId, String assignmentId) async {
    final doc = await db.collection('organizations').doc(orgId)
        .collection('assignments').doc(assignmentId).get();
    if (doc.data()?['employeeUid'] != currentUser.uid || doc.data()?['courseId'] != eqCourseId) {
      throw StateError('No course assignment is linked to your account.');
    }
    if ((await accessRef().get()).exists) return;
    await accessRef().set({
      'courseId': eqCourseId, 'source': 'employer',
      'organizationId': orgId, 'assignmentId': assignmentId,
      'grantedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> importDemoProducts() async {
    final batch = db.batch();
    var changed = 0;
    for (final item in demoProducts) {
      final id = idFor(item);
      final existing = await db.collection('products').doc(id).get();
      if (existing.exists) continue;
      changed++;
      batch.set(db.collection('products').doc(id), {
        'title': item.title, 'description': item.description,
        'type': item.type, 'category': item.type.startsWith('Digital') ? 'Digital' : 'Physical',
        'priceRm': priceFor(id), 'image': item.image,
        'stock': id == workbookId ? 999 : 30,
        'published': true, 'isDemo': true,
        'about': item.about, 'features': item.features,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    if (changed > 0) await batch.commit();
    final courseRef = db.collection('courseCatalog').doc(eqCourseId);
    if (!(await courseRef.get()).exists) {
      await courseRef.set({
        'title': MTProgressService.courseName,
        'category': 'Emotional Intelligence',
        'priceRm': demoEqPriceRm, 'published': true, 'isDemo': true,
        'description': 'Five modules, video lessons, reflection activities, final quiz and certificate.',
        'image': 'assets/images/course_eq.jpg',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }
}

class MTPurchaseLine {
  const MTPurchaseLine({required this.id, required this.title,
    required this.quantity, required this.priceRm, required this.kind, required this.image});
  final String id, title, kind, image;
  final int quantity, priceRm;
  Map<String, dynamic> toMap() => {
    'id': id, 'title': title, 'quantity': quantity,
    'priceRm': priceRm, 'kind': kind, 'image': image,
  };
}

class MTCartPage extends StatefulWidget {
  const MTCartPage({super.key});
  @override State<MTCartPage> createState() => _MTCartPageState();
}

class _MTCartPageState extends State<MTCartPage> {
  Future<void> _set(String id, int quantity) async {
    try { await MTCommerceService.setQuantity(id, quantity); }
    catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'))); }
  }

  @override Widget build(BuildContext context) => Scaffold(
    appBar: const SiteHeader(),
    body: SingleChildScrollView(child: Column(children: [
      const SimplePageHero(eyebrow: 'YOUR CART', title: 'Ready for your next step?',
          description: 'Cart contents are linked to your account. Checkout uses DEMO payments only.'),
      SectionWrapper(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: MTCommerceService.watchCart(),
        builder: (context, snap) {
          if (snap.hasError) return Text('Unable to load cart: ${snap.error}');
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          return FutureBuilder<List<MTPurchaseLine>>(
            future: MTCommerceService.linesForSnapshot(snap.data!),
            builder: (context, linesSnap) {
              if (linesSnap.hasError) return Text('Cart problem: ${linesSnap.error}');
              if (!linesSnap.hasData) return const Center(child: CircularProgressIndicator());
              final lines = linesSnap.data!;
              if (lines.isEmpty) return Column(children: [
                const Icon(Icons.shopping_bag_outlined, size: 54, color: AppColors.blue),
                const SizedBox(height: 12), const Text('Your cart is empty.'),
                FilledButton(onPressed: () => goTo(context, '/store'), child: const Text('Explore Store')),
              ]);
              final subtotal = lines.fold<int>(0, (s, v) => s + v.priceRm * v.quantity);
              final shipping = lines.any((v) => v.kind == 'physical') ? 8 : 0;
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ...lines.map((line) => Card(margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
                      ClipRRect(borderRadius: BorderRadius.circular(12),
                          child: Image.asset(line.image, width: 70, height: 70, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.shopping_bag, size: 60))),
                      const SizedBox(width: 15),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(line.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                        Text('${line.kind.toUpperCase()} · RM${line.priceRm} each'),
                      ])),
                      IconButton(onPressed: () => _set(line.id, line.quantity - 1), icon: const Icon(Icons.remove_circle_outline)),
                      Text('${line.quantity}', style: const TextStyle(fontWeight: FontWeight.w800)),
                      IconButton(onPressed: () => _set(line.id, line.quantity + 1), icon: const Icon(Icons.add_circle_outline)),
                    ])))),
                Card(child: Padding(padding: const EdgeInsets.all(22), child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text('Subtotal: RM$subtotal'), Text('Shipping: RM$shipping'),
                  const SizedBox(height: 8),
                  Text('Total: RM${subtotal + shipping}',
                      style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  const Text('DEMO checkout · No real money is charged.',
                      style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 12),
                  FilledButton.icon(onPressed: () => goTo(context, '/checkout'),
                      icon: const Icon(Icons.lock_outline), label: const Text('Proceed to Demo Checkout')),
                ]))),
              ]);
            },
          );
        },
      )),
      const SiteFooter(),
    ])),
  );
}

class MTCheckoutPage extends StatefulWidget {
  const MTCheckoutPage({super.key});
  @override State<MTCheckoutPage> createState() => _MTCheckoutPageState();
}

class _MTCheckoutPageState extends State<MTCheckoutPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _post = TextEditingController();
  bool _saving = false;
  String? _error;
  @override void initState() { super.initState(); _name.text = FirebaseAuth.instance.currentUser?.displayName ?? ''; }
  @override void dispose() { _name.dispose(); _address.dispose(); _city.dispose(); _post.dispose(); super.dispose(); }

  Future<void> _next() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() { _saving = true; _error = null; });
    try {
      final id = await MTCommerceService.placePendingCartOrder(
        recipient: _name.text, address: _address.text,
        city: _city.text, postcode: _post.text,
      );
      if (mounted) Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => MTDemoPaymentPage(orderId: id)));
    } catch (e) { if (mounted) setState(() => _error = '$e'); }
    finally { if (mounted) setState(() => _saving = false); }
  }

  @override Widget build(BuildContext context) => Scaffold(
    appBar: const SiteHeader(),
    body: SingleChildScrollView(child: Column(children: [
      const SimplePageHero(eyebrow: 'CHECKOUT', title: 'One step closer.',
          description: 'Your order is created as PENDING in Firebase before the demo payment.'),
      SectionWrapper(child: FutureBuilder<List<MTPurchaseLine>>(
        future: MTCommerceService.getCartLines(),
        builder: (context, snap) {
          if (snap.hasError) return Text('Could not load cart: ${snap.error}');
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final lines = snap.data!;
          if (lines.isEmpty) return const Text('Your cart is empty.');
          final physical = lines.any((x) => x.kind == 'physical');
          final subtotal = lines.fold<int>(0, (s, v) => s + v.priceRm * v.quantity);
          return Form(key: _form, child: Card(child: Padding(padding: const EdgeInsets.all(24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Text('Order summary', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
                ...lines.map((x) => Padding(padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text('${x.title} × ${x.quantity} · RM${x.priceRm * x.quantity}'))),
                Text('Shipping: RM${physical ? 8 : 0}'), const SizedBox(height: 12),
                Text('Total: RM${subtotal + (physical ? 8 : 0)}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.blue)),
                const SizedBox(height: 16),
                TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Full name'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Please enter your name.' : null),
                if (physical) ...[
                  const SizedBox(height: 12),
                  TextFormField(controller: _address, decoration: const InputDecoration(labelText: 'Delivery address'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Delivery address required.' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _city, decoration: const InputDecoration(labelText: 'City'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'City required.' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _post, decoration: const InputDecoration(labelText: 'Postcode'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Postcode required.' : null),
                ],
                if (_error != null) Padding(padding: const EdgeInsets.only(top: 12),
                    child: Text(_error!, style: const TextStyle(color: Colors.red))),
                const SizedBox(height: 20),
                FilledButton.icon(onPressed: _saving ? null : _next,
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(_saving ? 'Creating pending order...' : 'Continue to Demo Payment')),
              ]))),
          );
        },
      )), const SiteFooter(),
    ])),
  );
}

class MTDemoPaymentPage extends StatefulWidget {
  const MTDemoPaymentPage({super.key, required this.orderId});
  final String orderId;
  @override State<MTDemoPaymentPage> createState() => _MTDemoPaymentPageState();
}

class _MTDemoPaymentPageState extends State<MTDemoPaymentPage> {
  final _key = GlobalKey<FormState>();
  final _number = TextEditingController(text: '4242 4242 4242 4242');
  final _expiry = TextEditingController(text: '12/28');
  final _cvc = TextEditingController(text: '123');
  String _state = 'pending';
  bool _wasProcessed = false;
  bool _processing = false;
  String? _error;
  @override void dispose() { _number.dispose(); _expiry.dispose(); _cvc.dispose(); super.dispose(); }

  Future<void> _pay() async {
    if (!(_key.currentState?.validate() ?? false)) return;
    setState(() { _processing = true; _error = null; });
    try {
      await Future<void>.delayed(const Duration(milliseconds: 850));
      final outcome = MTCommerceService.simulatedOutcome(_number.text);
      await MTCommerceService.finishDemoPayment(widget.orderId, _number.text);
      if (mounted) setState(() { _state = outcome; _wasProcessed = true; });
    } catch (e) { if (mounted) setState(() => _error = '$e'); }
    finally { if (mounted) setState(() => _processing = false); }
  }

  @override Widget build(BuildContext context) => Scaffold(
    appBar: const SiteHeader(),
    body: SingleChildScrollView(child: Column(children: [
      const SimplePageHero(eyebrow: 'DEMO PAYMENT', title: 'Test the checkout experience.',
          description: 'For coursework demonstration only. NEVER enter a real bank card.'),
      SectionWrapper(child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: MTCommerceService.orders.doc(widget.orderId).get(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final order = snap.data!.data();
          if (order == null) return const Text('Order not found.');
          final status = _state == 'pending' ? (order['paymentStatus'] as String? ?? 'pending') : _state;
          return Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 700),
            child: Card(child: Padding(padding: const EdgeInsets.all(25), child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(children: [const Icon(Icons.lock_outline, color: AppColors.blue),
                const SizedBox(width: 10), const Expanded(child: Text('MT Alchemy · Demo Checkout',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20))),
                Text('RM${order['totalRm']}')]),
              const SizedBox(height: 10),
              const Text('TEST MODE · no real payments, card processing, or bank connection.',
                  style: TextStyle(color: Colors.black54)),
              const Divider(height: 32),
              if (status != 'pending' || _wasProcessed) ...[
                Icon(status == 'paid' ? Icons.check_circle
                    : status == 'failed' ? Icons.cancel : Icons.schedule,
                    size: 60, color: status == 'paid' ? Colors.green
                        : status == 'failed' ? Colors.red : Colors.orange),
                const SizedBox(height: 10),
                Text(status == 'paid' ? 'Demo Payment Successful'
                    : status == 'failed' ? 'Demo Payment Failed' : 'Demo Payment Pending',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                const Text('The result is stored in Cloud Firestore.', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(onPressed: () => goTo(context, '/my-orders'), child: const Text('View My Orders')),
                if (status == 'paid' && order['kind'] == 'course')
                  FilledButton.tonal(onPressed: () => goTo(context, '/dashboard'), child: const Text('Open My Learning')),
                if (status == 'paid' && order['kind'] == 'corporate')
                  FilledButton.tonal(onPressed: () => goTo(context, '/employer'), child: const Text('Open Employer Dashboard')),
              ] else ...[
                Form(key: _key, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  TextFormField(controller: _number,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'DEMO card number',
                          prefixIcon: Icon(Icons.credit_card)),
                      validator: (v) {
                        if (v == null) return 'Choose a demo number.';
                        try { MTCommerceService.simulatedOutcome(v); return null; }
                        catch (_) { return 'Use one of the demo card numbers below.'; }
                      }),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: TextFormField(controller: _expiry,
                        decoration: const InputDecoration(labelText: 'Test expiry (MM/YY)'),
                        validator: (v) => RegExp(r'^\d{2}/\d{2}$').hasMatch(v ?? '') ? null : 'Use MM/YY')),
                    const SizedBox(width: 12),
                    Expanded(child: TextFormField(controller: _cvc,
                        decoration: const InputDecoration(labelText: 'Test CVC'),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        validator: (v) => RegExp(r'^\d{3}$').hasMatch(v ?? '') ? null : 'Enter three demo digits')),
                  ]),
                  const SizedBox(height: 14),
                  const Text('Use only these fixed demo numbers:', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SelectableText('4242 4242 4242 4242  →  PAID\n4000 0000 0000 0002  →  FAILED\n4000 0000 0000 9995  →  PENDING'),
                  if (_error != null) Padding(padding: const EdgeInsets.only(top: 12),
                      child: Text(_error!, style: const TextStyle(color: Colors.red))),
                  const SizedBox(height: 15),
                  FilledButton.icon(onPressed: _processing ? null : _pay,
                      icon: const Icon(Icons.credit_card),
                      label: Text(_processing ? 'Processing demo payment...' : 'Pay in Demo Mode')),
                  const SizedBox(height: 10),
                  TextButton(onPressed: () => goTo(context, '/my-orders'),
                      child: const Text('Leave Pending and view My Orders')),
                ])),
              ],
            ]))),
          ));
        },
      )), const SiteFooter(),
    ])),
  );
}

class MTOrdersPage extends StatelessWidget {
  const MTOrdersPage({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: const SiteHeader(),
    body: SingleChildScrollView(child: Column(children: [
      const SimplePageHero(eyebrow: 'MY ORDERS', title: 'All your purchases in one place.',
          description: 'Demo payments and order status updates are saved in Firebase.'),
      SectionWrapper(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: MTCommerceService.watchOrders(),
        builder: (context, snap) {
          if (snap.hasError) return Text('Could not load orders: ${snap.error}');
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final orders = [...snap.data!.docs];
          orders.sort((a,b) => ((b.data()['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0)
              .compareTo((a.data()['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0));
          if (orders.isEmpty) return const Text('No orders yet. Your checkout history will appear here.');
          return Column(children: [
            Wrap(spacing: 10, runSpacing: 10, children: [
              _MTOrderStat(label: 'Total', count: orders.length, icon: Icons.receipt_long),
              _MTOrderStat(label: 'Paid', count: orders.where((d) => d.data()['paymentStatus'] == 'paid').length,
                  icon: Icons.check_circle_outline),
              _MTOrderStat(label: 'Pending', count: orders.where((d) => d.data()['paymentStatus'] == 'pending').length,
                  icon: Icons.schedule),
              _MTOrderStat(label: 'Failed', count: orders.where((d) => d.data()['paymentStatus'] == 'failed').length,
                  icon: Icons.cancel_outlined),
            ]),
            const SizedBox(height: 12),
            ...orders.map((order) {
              final data = order.data();
              final items = data['items'] as List<dynamic>? ?? [];
              final status = data['paymentStatus'] as String? ?? 'unknown';
              final kind = data['kind'] as String? ?? 'legacy';
              return Card(margin: const EdgeInsets.symmetric(vertical: 7), child: Padding(
                  padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text('Order ${order.id.substring(0, 7).toUpperCase()}',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18))),
                  _MTStatusBadge(status: status),
                ]),
                const SizedBox(height: 9),
                ...items.map((raw) {
                  final item = Map<String, dynamic>.from(raw as Map);
                  final title = item['title'] as String? ?? (item['id'] == eqCourseIdAlias ? MTProgressService.courseName : '${item['id']}');
                  return Text('$title × ${item['quantity'] ?? 1}');
                }),
                const SizedBox(height: 10),
                Text('RM${data['totalRm'] ?? '—'} • ${data['status'] ?? '—'}',
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                if (status == 'pending' && data['paymentMode'] == 'demo')
                  Align(alignment: Alignment.centerRight, child: TextButton.icon(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => MTDemoPaymentPage(orderId: order.id))),
                      icon: const Icon(Icons.payment), label: const Text('Continue demo payment'))),
                if (status == 'paid' && kind == 'corporate')
                  Align(alignment: Alignment.centerRight, child: TextButton.icon(
                      onPressed: () async {
                        try { await MTCommerceService.activateEmployerSeatsFromOrder(order.id);
                        if (context.mounted) goTo(context, '/employer'); }
                        catch (e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'))); }
                      }, icon: const Icon(Icons.groups), label: const Text('Activate company seats'))),
                if (status == 'paid' && kind == 'course')
                  Align(alignment: Alignment.centerRight, child: TextButton.icon(
                      onPressed: () async {
                        try { await MTCommerceService.activateCourseFromOrder(order.id);
                        if (context.mounted) goTo(context, '/dashboard');
                        } catch (e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'))); }
                      }, icon: const Icon(Icons.school), label: const Text('Access course'))),
              ])));
            }),
            const SizedBox(height: 14),
            FilledButton.tonal(onPressed: () => goTo(context, '/my-digital-products'),
                child: const Text('My Digital Products')),
          ]);
        },
      )), const SiteFooter(),
    ])),
  );
}

const eqCourseIdAlias = 'eq-fundamentals';

class _MTOrderStat extends StatelessWidget {
  const _MTOrderStat({required this.label, required this.count, required this.icon});
  final String label; final int count; final IconData icon;
  @override Widget build(BuildContext context) => Container(
    width: 150, padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 6),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE3EAF9))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: AppColors.blue), const SizedBox(height: 7),
      Text('$count', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 23)),
      Text(label, style: const TextStyle(color: Colors.black54)),
    ]),
  );
}

class _MTStatusBadge extends StatelessWidget {
  const _MTStatusBadge({required this.status});
  final String status;
  @override Widget build(BuildContext context) {
    final color = status == 'paid' ? Colors.green.shade700
        : status == 'failed' ? Colors.red.shade700 : Colors.orange.shade800;
    final title = status.toUpperCase().replaceAll('_', ' ');
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(color: color.withOpacity(.10), borderRadius: BorderRadius.circular(18)),
        child: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 11)));
  }
}

class MTDigitalLibraryPage extends StatelessWidget {
  const MTDigitalLibraryPage({super.key});
  Future<void> _download(BuildContext context) async {
    try {
      final file = await rootBundle.load('assets/images/eq_workbook.pdf');
      await Printing.sharePdf(bytes: file.buffer.asUint8List(file.offsetInBytes, file.lengthInBytes),
          filename: 'MT_Alchemy_EQ_Workbook.pdf');
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override Widget build(BuildContext context) => Scaffold(
    appBar: const SiteHeader(), body: SingleChildScrollView(child: Column(children: [
    const SimplePageHero(eyebrow: 'DIGITAL LIBRARY', title: 'Your purchased digital materials.',
        description: 'Downloads are available after successful demo payment.'),
    SectionWrapper(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: MTCommerceService.watchOrders(),
      builder: (context, snap) {
        if (snap.hasError) return Text('Unable to load library: ${snap.error}');
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final purchased = <String, String>{};
        for (final order in snap.data!.docs) {
          final d = order.data();
          final legacyDemo = d['status'] == 'demo-confirmed' && d['paymentStatus'] == 'not-charged';
          if (d['paymentStatus'] != 'paid' && !legacyDemo) continue;
          final items = d['items'] as List<dynamic>? ?? [];
          for (final item in items) {
            if (item is! Map) continue;
            final id = '${item['id'] ?? ''}';
            final kind = '${item['kind'] ?? (id == MTCommerceService.workbookId ? 'digital' : '')}';
            if (kind == 'digital') purchased[id] = item['title'] as String? ??
                (id == MTCommerceService.workbookId ? 'Emotional Clarity Workbook' : id);
          }
        }
        if (purchased.isEmpty) return Column(children: [
          const Text('No purchased digital resources yet.'),
          const SizedBox(height: 12),
          FilledButton(onPressed: () => goTo(context, '/store'), child: const Text('Browse Store')),
        ]);
        return Column(children: purchased.entries.map((entry) => Card(child: Padding(
            padding: const EdgeInsets.all(20), child: Row(children: [
          const Icon(Icons.picture_as_pdf_outlined, size: 42, color: AppColors.blue),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(entry.value, style: const TextStyle(fontWeight: FontWeight.w800)),
            Text(entry.key == MTCommerceService.workbookId
                ? 'PDF · Purchased demo resource' : 'Digital file pending upload by MT Alchemy',
                style: const TextStyle(color: Colors.black54)),
          ])),
          if (entry.key == MTCommerceService.workbookId)
            FilledButton(onPressed: () => _download(context), child: const Text('Download')),
        ])))).toList());
      },
    )), const SiteFooter(),
  ])),
  );
}

/// Reuses the existing course-detail card; keeps previously enrolled learners' work.
class MTCoursePurchaseAction extends StatelessWidget {
  const MTCoursePurchaseAction({super.key});

  Future<void> _open(BuildContext context, bool hasAccess) async {
    if (FirebaseAuth.instance.currentUser == null) {
      goTo(context, '/register');
      return;
    }
    try {
      if (hasAccess) {
        await MTProgressService.enroll();
        if (context.mounted) goTo(context, '/course-player');
      } else {
        final orderId = await MTCommerceService.placePendingCourseOrder();
        if (context.mounted) Navigator.push(context, MaterialPageRoute(
            builder: (_) => MTDemoPaymentPage(orderId: orderId)));
      }
    } catch (error) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not continue: $error')));
    }
  }

  @override Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return FilledButton.icon(onPressed: () => goTo(context, '/register'),
          icon: const Icon(Icons.login), label: const Text('Log in to purchase course'));
    }
    return FutureBuilder<bool>(
      future: MTCommerceService.canStartEq(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        return FilledButton.icon(
            onPressed: () => _open(context, snapshot.data!),
            icon: Icon(snapshot.data! ? Icons.play_arrow_rounded : Icons.shopping_cart_checkout),
            label: Text(snapshot.data! ? 'Continue Learning' : 'Purchase Course · Demo Payment'));
      },
    );
  }
}