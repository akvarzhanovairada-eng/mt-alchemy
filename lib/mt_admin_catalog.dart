part of 'main.dart';

/// The admin edits Firestore documents; prices are not hard-coded in widgets.
/// Existing example products are imported only by an explicit admin action.
class MTAdminCatalogPanel extends StatelessWidget {
  const MTAdminCatalogPanel({super.key});
  static final db = FirebaseFirestore.instance;

  Future<void> _productDialog(BuildContext context, [DocumentSnapshot<Map<String, dynamic>>? current]) async {
    final data = current?.data() ?? {};
    final title = TextEditingController(text: data['title'] as String? ?? '');
    final description = TextEditingController(text: data['description'] as String? ?? '');
    final price = TextEditingController(text: '${data['priceRm'] ?? 0}');
    final stock = TextEditingController(text: '${data['stock'] ?? 20}');
    var type = data['type'] as String? ?? 'Physical Product';
    var image = data['image'] as String? ?? 'assets/images/product_workbook.jpg';
    var published = data['published'] as bool? ?? false;
    final key = GlobalKey<FormState>();
    try {
      await showDialog<void>(context: context, builder: (dialogContext) => StatefulBuilder(
          builder: (dialogContext, update) => AlertDialog(
            title: Text(current == null ? 'Add product' : 'Edit product'),
            content: SizedBox(width: 520, child: SingleChildScrollView(child: Form(key: key, child:
            Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(controller: title, decoration: const InputDecoration(labelText: 'Product name'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              TextFormField(controller: description, maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: type,
                  decoration: const InputDecoration(labelText: 'Product type'),
                  items: const [DropdownMenuItem(value: 'Digital Product', child: Text('Digital Product')),
                    DropdownMenuItem(value: 'Physical Product', child: Text('Physical Product'))],
                  onChanged: (v) => update(() => type = v ?? type)),
              const SizedBox(height: 12),
              TextFormField(controller: price, keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Demo price (RM)'),
                  validator: (v) => (int.tryParse(v ?? '') ?? -1) < 0 ? 'Enter a positive whole number' : null),
              const SizedBox(height: 12),
              TextFormField(controller: stock, keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Demo stock quantity'),
                  validator: (v) => (int.tryParse(v ?? '') ?? -1) < 0 ? 'Enter zero or more' : null),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: image,
                  decoration: const InputDecoration(labelText: 'Image (existing site asset)'),
                  items: const [
                    DropdownMenuItem(value: 'assets/images/product_workbook.jpg', child: Text('Workbook image')),
                    DropdownMenuItem(value: 'assets/images/product_journal.jpg', child: Text('Journal image')),
                    DropdownMenuItem(value: 'assets/images/product_cards.png', child: Text('Reflection cards image'))],
                  onChanged: (v) => update(() => image = v ?? image)),
              SwitchListTile(title: const Text('Publish in Store'), value: published,
                  onChanged: (v) => update(() => published = v)),
            ])))),
            actions: [
              TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
              FilledButton(onPressed: () async {
                if (!(key.currentState?.validate() ?? false)) return;
                try {
                  final ref = current?.reference ?? db.collection('products').doc();
                  await ref.set({
                    'title': title.text.trim(), 'description': description.text.trim(),
                    'type': type, 'category': type.startsWith('Digital') ? 'Digital' : 'Physical',
                    'priceRm': int.parse(price.text), 'stock': int.parse(stock.text),
                    'image': image, 'published': published, 'isDemo': true,
                    if (current == null) 'createdAt': FieldValue.serverTimestamp(),
                    'updatedAt': FieldValue.serverTimestamp(),
                  }, SetOptions(merge: true));
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                } catch (e) {
                  if (dialogContext.mounted) ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(content: Text('Save failed: $e')));
                }
              }, child: const Text('Save product')),
            ],
          )),
      );
    } finally {
      title.dispose(); description.dispose(); price.dispose(); stock.dispose();
    }
  }

  Future<void> _deleteProduct(BuildContext context, DocumentSnapshot<Map<String,dynamic>> doc) async {
    final confirm = await showDialog<bool>(context: context, builder: (c) => AlertDialog(
        title: const Text('Remove product?'),
        content: const Text('Existing orders are kept. This product will disappear from the Store.'),
        actions: [TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Remove'))]));
    if (confirm == true) {
      try { await doc.reference.delete(); }
      catch (e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'))); }
    }
  }

  @override Widget build(BuildContext context) => _MTPortalCard(child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    const Text('Products · Firestore catalogue', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
    const SizedBox(height: 6),
    const Text('Demo prices until the company confirms its real catalogue.',
        style: TextStyle(color: Colors.black54)),
    const SizedBox(height: 12),
    Wrap(spacing: 8, runSpacing: 8, children: [
      FilledButton.icon(onPressed: () => _productDialog(context),
          icon: const Icon(Icons.add), label: const Text('Add product')),
      OutlinedButton.icon(onPressed: () async {
        try {
          await MTCommerceService.importDemoProducts();
          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Example catalogue imported to Firebase.')));
        } catch (e) {
          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
        }
      }, icon: const Icon(Icons.cloud_upload_outlined), label: const Text('Import example catalogue')),
    ]),
    const SizedBox(height: 14),
    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: db.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Cannot load products: ${snapshot.error}');
        if (!snapshot.hasData) return const LinearProgressIndicator();
        if (snapshot.data!.docs.isEmpty) return const Text('No Firestore products yet. Import examples or add a product.');
        return Column(children: snapshot.data!.docs.map((doc) {
          final d = doc.data();
          return ListTile(
            leading: Icon(d['type'] == 'Digital Product' ? Icons.file_download_outlined : Icons.inventory_2_outlined,
                color: AppColors.blue),
            title: Text(d['title'] as String? ?? doc.id),
            subtitle: Text('RM${d['priceRm'] ?? 0} · Stock ${d['stock'] ?? 0} · ${d['published'] == true ? 'Published' : 'Draft'}'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(tooltip: 'Edit', icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _productDialog(context, doc)),
              IconButton(tooltip: 'Remove', icon: const Icon(Icons.delete_outline),
                  onPressed: () => _deleteProduct(context, doc)),
            ]),
          );
        }).toList());
      },
    ),
  ],
  ));
}

class MTAdminCoursesPanel extends StatelessWidget {
  const MTAdminCoursesPanel({super.key});
  static final db = FirebaseFirestore.instance;

  Future<void> _edit(BuildContext context, [DocumentSnapshot<Map<String,dynamic>>? doc]) async {
    final data = doc?.data() ?? {};
    final name = TextEditingController(text: data['title'] as String? ?? '');
    final description = TextEditingController(text: data['description'] as String? ?? '');
    final price = TextEditingController(text: '${data['priceRm'] ?? 99}');
    var published = data['published'] as bool? ?? false;
    final key = GlobalKey<FormState>();
    try {
      await showDialog<void>(context: context, builder: (ctx) => StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            title: Text(doc == null ? 'Add course' : 'Edit course'),
            content: SizedBox(width: 500, child: SingleChildScrollView(child: Form(key: key,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextFormField(controller: name, decoration: const InputDecoration(labelText: 'Course title'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: description, maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Description')),
                  const SizedBox(height: 12),
                  TextFormField(controller: price, keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Demo course price (RM)'),
                      validator: (v) => (int.tryParse(v ?? '') ?? -1) < 0 ? 'Use a positive whole number' : null),
                  SwitchListTile(value: published,
                      title: const Text('Published'),
                      subtitle: const Text('Only EQ Fundamentals currently has a complete course player.'),
                      onChanged: (v) => setState(() => published = v)),
                ])))),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              FilledButton(onPressed: () async {
                if (!(key.currentState?.validate() ?? false)) return;
                try {
                  final ref = doc?.reference ?? db.collection('courseCatalog').doc();
                  await ref.set({
                    'title': name.text.trim(), 'description': description.text.trim(),
                    'category': 'Emotional Intelligence',
                    'priceRm': int.parse(price.text),
                    'published': published, 'isDemo': true,
                    'image': 'assets/images/course_eq.jpg',
                    if (doc == null) 'createdAt': FieldValue.serverTimestamp(),
                    'updatedAt': FieldValue.serverTimestamp(),
                  }, SetOptions(merge: true));
                  if (ctx.mounted) Navigator.pop(ctx);
                } catch (e) {
                  if (ctx.mounted) ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('$e')));
                }
              }, child: const Text('Save course')),
            ],
          )),
      );
    } finally { name.dispose(); description.dispose(); price.dispose(); }
  }

  @override Widget build(BuildContext context) => _MTPortalCard(child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    const Text('Courses · Firestore catalogue', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
    const SizedBox(height: 8),
    const Text('Only EQ Fundamentals includes the full player, assessment and certificate. New courses can be drafted for later development.',
        style: TextStyle(color: Colors.black54)),
    const SizedBox(height: 12),
    Align(alignment: Alignment.centerLeft,
        child: FilledButton.icon(onPressed: () => _edit(context), icon: const Icon(Icons.add),
            label: const Text('Create draft course'))),
    StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
      stream: db.collection('courseCatalog').snapshots(),
      builder: (context, snap) {
        if (snap.hasError) return Text('Courses unavailable: ${snap.error}');
        if (!snap.hasData) return const LinearProgressIndicator();
        if (snap.data!.docs.isEmpty) return const Text('No Firestore courses yet. Use Import example catalogue above for EQ Fundamentals.');
        return Column(children: snap.data!.docs.map((doc) {
          final d = doc.data();
          return ListTile(
            title: Text(d['title'] as String? ?? doc.id),
            subtitle: Text('Demo RM${d['priceRm']} · ${d['published'] == true ? 'Published' : 'Draft'}'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(onPressed: () => _edit(context, doc), icon: const Icon(Icons.edit_outlined)),
              if (doc.id != MTProgressService.courseId)
                IconButton(onPressed: () async {
                  final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
                      title: const Text('Delete draft course?'),
                      actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete'))]));
                  if (ok == true) await doc.reference.delete();
                }, icon: const Icon(Icons.delete_outline)),
            ]),
          );
        }).toList());
      },
    ),
  ],
  ));
}

class MTAdminPaymentOrders extends StatelessWidget {
  const MTAdminPaymentOrders({super.key});
  @override Widget build(BuildContext context) => _MTPortalCard(child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    const Text('Orders & Demo Payments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
    const Text('Pending, Paid and Failed are stored in Firestore. Fulfilment is managed separately.',
        style: TextStyle(color: Colors.black54)),
    StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').limit(100).snapshots(),
      builder: (context, users) {
        if (users.hasError) return Text('Users unavailable: ${users.error}');
        if (!users.hasData) return const LinearProgressIndicator();
        return Column(children: users.data!.docs.map((u) => StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
          stream: FirebaseFirestore.instance.collection('orders').doc(u.id).collection('items').limit(30).snapshots(),
          builder: (context, orders) {
            if (orders.hasError) return Text('Orders unavailable: ${orders.error}');
            if (!orders.hasData || orders.data!.docs.isEmpty) return const SizedBox.shrink();
            return Column(children: orders.data!.docs.map((order) {
              final d = order.data();
              final pay = d['paymentStatus'] as String? ?? 'legacy';
              final status = d['status'] as String? ?? 'unknown';
              final canShip = pay == 'paid' && d['kind'] == 'products' &&
                  ((d['items'] as List<dynamic>? ?? []).any((i) => i is Map && i['kind'] == 'physical'));
              return ListTile(
                leading: _MTStatusBadge(status: pay),
                title: Text('RM${d['totalRm'] ?? '—'} · ${u.data()['email'] ?? u.id}'),
                subtitle: Text('${d['kind'] ?? 'legacy'} · $status · ${order.id.substring(0, 7)}'),
                trailing: canShip ? PopupMenuButton<String>(
                  tooltip: 'Update delivery status',
                  onSelected: (value) async {
                    try { await MTPortalService.setOrderStatus(u.id, order.id, value); }
                    catch (e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'))); }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'processing', child: Text('Processing')),
                    PopupMenuItem(value: 'shipped', child: Text('Shipped')),
                    PopupMenuItem(value: 'delivered', child: Text('Delivered')),
                  ],
                ) : null,
              );
            }).toList());
          },
        )).toList());
      },
    ),
  ],
  ));
}