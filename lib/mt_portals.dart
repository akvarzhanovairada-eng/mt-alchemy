part of 'main.dart';

// Role-based access, employer workflows, trainer tools, admin operations and enquiries.
class MTPortalService {
  static FirebaseFirestore get db => FirebaseFirestore.instance;
  static User get user {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null) throw StateError('Please log in first.');
    return u;
  }

  static Future<String?> orgId() async {
    final s = await db.collection('users').doc(user.uid).get();
    return s.data()?['organizationId'] as String?;
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> myApplication() =>
      db.collection('roleApplications').doc(user.uid).snapshots();

  static Future<void> apply({required String role, String organization = '', String industry = '', String registration = '', String employees = '', String phone = '', String bio = ''}) async {
    if (role != 'employer' && role != 'trainer') throw StateError('Choose Employer or Trainer.');
    if (role == 'employer' && organization.trim().isEmpty) throw StateError('Organization name is required.');
    if (role == 'trainer' && bio.trim().isEmpty) throw StateError('Please describe your training experience.');
    final ref = db.collection('roleApplications').doc(user.uid);
    final old = await ref.get();
    if (old.data()?['status'] == 'pending') throw StateError('You already have a pending application.');
    final p = await db.collection('users').doc(user.uid).get();
    await ref.set({
      'userId': user.uid, 'name': p.data()?['name'] ?? user.displayName ?? '',
      'email': user.email ?? '', 'requestedRole': role,
      'organizationName': organization.trim(), 'industry': industry.trim(),
      'registrationNumber': registration.trim(), 'employeeCount': employees.trim(),
      'contactPhone': phone.trim(), 'trainerBio': bio.trim(),
      'status': 'pending', 'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> reviewApplication(String applicantUid, bool approve) async {
    final ref = db.collection('roleApplications').doc(applicantUid);
    final s = await ref.get();
    if (!s.exists) throw StateError('Application not found.');
    final d = s.data()!;
    final role = d['requestedRole'];
    final batch = db.batch();
    if (approve && role == 'employer') {
      final id = 'org_$applicantUid';
      batch.set(db.collection('organizations').doc(id), {
        'organizationId': id, 'name': d['organizationName'] ?? 'Organization',
        'industry': d['industry'] ?? '', 'registrationNumber': d['registrationNumber'] ?? '',
        'employeeCount': d['employeeCount'] ?? '', 'contactPhone': d['contactPhone'] ?? '',
        'ownerUid': applicantUid, 'status': 'active', 'createdAt': FieldValue.serverTimestamp(),
      });
      batch.update(db.collection('users').doc(applicantUid), {
        'role': 'employer', 'organizationId': id, 'organizationName': d['organizationName'] ?? '',
      });
    } else if (approve && role == 'trainer') {
      batch.update(db.collection('users').doc(applicantUid), {'role': 'trainer'});
    }
    batch.update(ref, {'status': approve ? 'approved' : 'rejected', 'reviewedAt': FieldValue.serverTimestamp(), 'reviewedBy': user.uid});
    await batch.commit();
  }

  static Future<void> inviteEmployee(String orgId, String email, String department) async {
    final e = email.trim().toLowerCase();
    if (!e.contains('@')) throw StateError('Enter a valid email address.');
    final org = await db.collection('organizations').doc(orgId).get();
    await db.collection('organizations').doc(orgId).collection('invitations').doc(e).set({
      'email': e, 'organizationId': orgId, 'organizationName': org.data()?['name'] ?? 'Organization',
      'department': department.trim().isEmpty ? 'General' : department.trim(),
      'status': 'pending', 'invitedBy': user.uid, 'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> invitations() =>
      db.collectionGroup('invitations').where('email', isEqualTo: (user.email ?? '').toLowerCase()).snapshots();

  static Future<void> respondToInvite(DocumentSnapshot<Map<String, dynamic>> invite, bool accept) async {
    final d = invite.data() ?? {};
    final orgId = d['organizationId'] as String?;
    if (orgId == null) throw StateError('Organization information is missing.');
    final batch = db.batch();
    if (accept) {
      final profile = await db.collection('users').doc(user.uid).get();
      batch.set(db.collection('organizations').doc(orgId).collection('members').doc(user.uid), {
        'uid': user.uid, 'email': (user.email ?? '').toLowerCase(),
        'name': profile.data()?['name'] ?? user.displayName ?? user.email,
        'department': d['department'] ?? 'General', 'joinedAt': FieldValue.serverTimestamp(),
      });
    }
    batch.update(invite.reference, {'status': accept ? 'accepted' : 'declined', 'respondedAt': FieldValue.serverTimestamp()});
    await batch.commit();
  }

  static Future<void> assignEqCourse(String orgId, Map<String, dynamic> member, DateTime? dueDate) async {
    await db.collection('organizations').doc(orgId).collection('assignments').add({
      'employeeUid': member['uid'], 'employeeName': member['name'] ?? 'Learner',
      'employeeEmail': member['email'] ?? '', 'courseId': MTProgressService.courseId,
      'courseTitle': MTProgressService.courseName, 'assignedBy': user.uid,
      'assignedAt': FieldValue.serverTimestamp(), 'dueAt': dueDate == null ? null : Timestamp.fromDate(dueDate),
      'status': 'assigned',
    });
  }

  static Future<void> assignTrainer(String trainerUid) async {
    await db.collection('trainerAssignments').doc(trainerUid).collection('courses').doc(MTProgressService.courseId).set({
      'courseId': MTProgressService.courseId, 'courseTitle': MTProgressService.courseName,
      'assignedBy': user.uid, 'assignedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> addMaterial(int module, String title, String url, String description) async {
    final uri = Uri.tryParse(url.trim());
    if (title.trim().isEmpty || uri == null || !['https', 'http'].contains(uri.scheme)) {
      throw StateError('Enter a title and valid http(s) URL.');
    }
    await db.collection('courseMaterials').doc(MTProgressService.courseId).collection('items').add({
      'moduleIndex': module, 'title': title.trim(), 'url': url.trim(),
      'description': description.trim(), 'createdBy': user.uid,
      'createdAt': FieldValue.serverTimestamp(), 'active': true,
    });
  }

  static Future<void> submitEnquiry(Map<String, String> values) async {
    await db.collection('enquiries').add({...values, 'status': 'new',
      'createdBy': FirebaseAuth.instance.currentUser?.uid, 'createdAt': FieldValue.serverTimestamp()});
  }

  static Future<void> setEnquiryStatus(String id, String status) async {
    await db.collection('enquiries').doc(id).update({'status': status, 'updatedAt': FieldValue.serverTimestamp(), 'updatedBy': user.uid});
  }

  static Future<void> setOrderStatus(String uid, String id, String status) async {
    await db.collection('orders').doc(uid).collection('items').doc(id).update({'status': status, 'updatedAt': FieldValue.serverTimestamp()});
  }
}

class MTRoleApplicationPage extends StatefulWidget {
  const MTRoleApplicationPage({super.key});
  @override State<MTRoleApplicationPage> createState() => _MTRoleApplicationPageState();
}
class _MTRoleApplicationPageState extends State<MTRoleApplicationPage> {
  final _key = GlobalKey<FormState>();
  final _org = TextEditingController(); final _industry = TextEditingController();
  final _reg = TextEditingController(); final _employees = TextEditingController();
  final _phone = TextEditingController(); final _bio = TextEditingController();
  String _role = 'employer'; bool _busy = false;
  @override void dispose() { _org.dispose(); _industry.dispose(); _reg.dispose(); _employees.dispose(); _phone.dispose(); _bio.dispose(); super.dispose(); }
  Future<void> _submit() async {
    if (!_key.currentState!.validate()) return;
    setState(() => _busy = true);
    try { await MTPortalService.apply(role: _role, organization: _org.text, industry: _industry.text, registration: _reg.text, employees: _employees.text, phone: _phone.text, bio: _bio.text);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Application submitted for administrator review.')));
    } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'))); }
    finally { if (mounted) setState(() => _busy = false); }
  }
  @override Widget build(BuildContext context) => Scaffold(appBar: const SiteHeader(), body: SingleChildScrollView(child: Column(children: [
    const SimplePageHero(eyebrow: 'ACCOUNT ACCESS', title: 'Request a platform role.', description: 'Employer and Trainer access is reviewed by an MT Alchemy administrator.'),
    SectionWrapper(child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(stream: MTPortalService.myApplication(), builder: (context, s) {
      final d = s.data?.data();
      if (d?['status'] == 'pending') return _MTPortalCard(child: Text('Your ${d?['requestedRole']} application is pending administrator review.'));
      if (d?['status'] == 'approved') return const _MTPortalCard(child: Text('Your role has been approved. Please sign out and sign in again to refresh your account menu.'));
      return _MTPortalCard(child: Form(key: _key, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        DropdownButtonFormField<String>(value: _role, decoration: const InputDecoration(labelText: 'Requested role'), items: const [DropdownMenuItem(value: 'employer', child: Text('Employer / Organization')), DropdownMenuItem(value: 'trainer', child: Text('Trainer'))], onChanged: (v) => setState(() => _role = v ?? 'employer')),
        if (_role == 'employer') ...[
          const SizedBox(height: 12), TextFormField(controller: _org, decoration: const InputDecoration(labelText: 'Organization name'), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
          const SizedBox(height: 10), TextFormField(controller: _industry, decoration: const InputDecoration(labelText: 'Industry')),
          const SizedBox(height: 10), TextFormField(controller: _reg, decoration: const InputDecoration(labelText: 'Company registration number (optional)')),
          const SizedBox(height: 10), TextFormField(controller: _employees, decoration: const InputDecoration(labelText: 'Number of employees')),
          const SizedBox(height: 10), TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'Contact phone')),
        ] else ...[
          const SizedBox(height: 12), TextFormField(controller: _bio, minLines: 3, maxLines: 5, decoration: const InputDecoration(labelText: 'Training experience'), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
        ],
        const SizedBox(height: 18), SizedBox(width: double.infinity, child: FilledButton(onPressed: _busy ? null : _submit, child: Text(_busy ? 'Submitting...' : 'Submit application'))),
      ])));
    })), const SiteFooter(),
  ])));
}

class MTMyInvitationsPage extends StatelessWidget {
  const MTMyInvitationsPage({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: const SiteHeader(), body: SingleChildScrollView(child: Column(children: [
    const SimplePageHero(eyebrow: 'ORGANIZATION INVITATIONS', title: 'Your team invitations.', description: 'Accept an invitation to join an organization.'),
    SectionWrapper(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: MTPortalService.invitations(), builder: (context, s) {
      if (s.hasError) return Text('Could not load invitations: ${s.error}');
      if (!s.hasData) return const Center(child: CircularProgressIndicator());
      final docs = s.data!.docs.where((d) => d.data()['status'] == 'pending').toList();
      if (docs.isEmpty) return const _MTPortalCard(child: Text('No pending invitations.'));
      return Column(children: docs.map((d) => _MTPortalCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(d.data()['organizationName'] ?? 'Organization', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        Text('Department: ${d.data()['department'] ?? 'General'}'), const SizedBox(height: 12),
        Wrap(spacing: 10, children: [
          FilledButton(onPressed: () async { try { await MTPortalService.respondToInvite(d, true); } catch (e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'))); } }, child: const Text('Accept')),
          OutlinedButton(onPressed: () async { try { await MTPortalService.respondToInvite(d, false); } catch (e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'))); } }, child: const Text('Decline')),
        ]),
      ]))).toList());
    })), const SiteFooter(),
  ])));
}

class MTEmployerDashboardPage extends StatelessWidget {
  const MTEmployerDashboardPage({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: const SiteHeader(), body: SingleChildScrollView(child: Column(children: [
    const SimplePageHero(eyebrow: 'EMPLOYER PORTAL', title: 'Develop your people.', description: 'Manage employees, assign learning and monitor organizational progress.'),
    SectionWrapper(child: FutureBuilder<String?>(future: MTPortalService.orgId(), builder: (context, org) {
      if (org.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
      final id = org.data; if (id == null) return _MTPortalCard(child: Column(children: [const Text('Organization access is not configured.'), FilledButton(onPressed: () => goTo(context, '/apply-role'), child: const Text('Apply for Employer access'))]));
      final ref = MTPortalService.db.collection('organizations').doc(id);
      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(stream: ref.snapshots(), builder: (context, o) {
        if (!o.hasData) return const Center(child: CircularProgressIndicator());
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _MTPortalCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(o.data!.data()?['name'] ?? 'Organization', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
            const Text('Approved organization account'), const SizedBox(height: 14),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: ref.collection('members').snapshots(), builder: (context, m) => _MTStatCard(value: '${m.data?.docs.length ?? 0}', label: 'Employees')),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: ref.collection('assignments').snapshots(), builder: (context, a) => _MTStatCard(value: '${a.data?.docs.length ?? 0}', label: 'Course assignments')),
          ])),
          Wrap(spacing: 10, runSpacing: 10, children: [
            _MTPortalAction('Manage employees', Icons.people, () => goTo(context, '/employees')),
            _MTPortalAction('Assign course', Icons.assignment, () => goTo(context, '/assign-course')),
            _MTPortalAction('Learning reports', Icons.analytics, () => goTo(context, '/reports')),
          ]),
        ]);
      });
    })), const SiteFooter(),
  ])));
}

class MTEmployeeManagementPage extends StatefulWidget {
  const MTEmployeeManagementPage({super.key});
  @override State<MTEmployeeManagementPage> createState() => _MTEmployeeManagementPageState();
}
class _MTEmployeeManagementPageState extends State<MTEmployeeManagementPage> {
  final _email = TextEditingController(); final _department = TextEditingController(text: 'General'); bool _busy = false;
  @override void dispose() { _email.dispose(); _department.dispose(); super.dispose(); }
  Future<void> _send(String id) async { setState(() => _busy = true); try { await MTPortalService.inviteEmployee(id, _email.text, _department.text); _email.clear(); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invitation sent. The learner can accept it in My Invitations.'))); } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'))); } finally { if (mounted) setState(() => _busy = false); } }
  @override Widget build(BuildContext context) => Scaffold(appBar: const SiteHeader(), body: SingleChildScrollView(child: Column(children: [
    const SimplePageHero(eyebrow: 'EMPLOYER PORTAL', title: 'Manage your employees.', description: 'Invite existing MT Alchemy learners by email and organize them by department.'),
    SectionWrapper(child: FutureBuilder<String?>(future: MTPortalService.orgId(), builder: (context, org) {
      if (org.connectionState != ConnectionState.done) return const CircularProgressIndicator(); final id = org.data; if (id == null) return const _MTPortalCard(child: Text('Organization profile not found.'));
      final ref = MTPortalService.db.collection('organizations').doc(id);
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _MTPortalCard(child: Column(children: [TextField(controller: _email, decoration: const InputDecoration(labelText: 'Employee email')), const SizedBox(height: 10), TextField(controller: _department, decoration: const InputDecoration(labelText: 'Department')), const SizedBox(height: 12), FilledButton(onPressed: _busy ? null : () => _send(id), child: Text(_busy ? 'Sending...' : 'Invite employee'))])),
        const Text('Team members', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: ref.collection('members').snapshots(), builder: (context, s) {
          if (!s.hasData) return const LinearProgressIndicator(); if (s.data!.docs.isEmpty) return const Text('No members yet.');
          return Column(children: s.data!.docs.map((d) => ListTile(title: Text(d.data()['name'] ?? d.id), subtitle: Text('${d.data()['email'] ?? ''} • ${d.data()['department'] ?? ''}'), trailing: IconButton(icon: const Icon(Icons.person_remove_outlined), onPressed: () => d.reference.delete()))).toList());
        }),
        const SizedBox(height: 16), const Text('Pending invitations', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: ref.collection('invitations').where('status', isEqualTo: 'pending').snapshots(), builder: (context, s) {
          if (!s.hasData || s.data!.docs.isEmpty) return const Text('No pending invitations.');
          return Column(children: s.data!.docs.map((d) => ListTile(title: Text(d.data()['email'] ?? d.id), subtitle: Text(d.data()['department'] ?? 'General'), trailing: TextButton(onPressed: () => d.reference.delete(), child: const Text('Cancel')))).toList());
        }),
      ]);
    })), const SiteFooter(),
  ])));
}

class MTCourseAssignmentPage extends StatefulWidget {
  const MTCourseAssignmentPage({super.key});
  @override State<MTCourseAssignmentPage> createState() => _MTCourseAssignmentPageState();
}
class _MTCourseAssignmentPageState extends State<MTCourseAssignmentPage> {
  String? _uid; DateTime? _due; bool _busy = false;
  @override Widget build(BuildContext context) => Scaffold(appBar: const SiteHeader(), body: SingleChildScrollView(child: Column(children: [
    const SimplePageHero(eyebrow: 'EMPLOYER PORTAL', title: 'Assign learning to your team.', description: 'Select an employee and assign the active EQ programme.'),
    SectionWrapper(child: FutureBuilder<String?>(future: MTPortalService.orgId(), builder: (context, org) {
      if (org.connectionState != ConnectionState.done) return const CircularProgressIndicator(); final id = org.data; if (id == null) return const _MTPortalCard(child: Text('Organization profile not found.'));
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: MTPortalService.db.collection('organizations').doc(id).collection('members').snapshots(), builder: (context, s) {
        if (!s.hasData) return const CircularProgressIndicator(); final docs = s.data!.docs; if (docs.isEmpty) return const _MTPortalCard(child: Text('Invite employees before assigning a course.'));
        _uid ??= docs.first.id;
        return _MTPortalCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Emotional Intelligence Fundamentals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), const Text('5 modules • Final assessment • Certificate'),
          const SizedBox(height: 12), DropdownButtonFormField<String>(value: _uid, decoration: const InputDecoration(labelText: 'Employee'), items: docs.map((d) => DropdownMenuItem(value: d.id, child: Text(d.data()['name'] ?? d.data()['email'] ?? d.id))).toList(), onChanged: (v) => setState(() => _uid = v)),
          const SizedBox(height: 12), OutlinedButton.icon(onPressed: () async { final d = await showDatePicker(context: context, initialDate: DateTime.now().add(const Duration(days: 30)), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365))); if (d != null) setState(() => _due = d); }, icon: const Icon(Icons.calendar_month), label: Text(_due == null ? 'Optional due date' : 'Due ${_due!.day}/${_due!.month}/${_due!.year}')),
          const SizedBox(height: 12), FilledButton(onPressed: _busy ? null : () async { final m = docs.firstWhere((d) => d.id == _uid).data(); setState(() => _busy = true); try { await MTPortalService.assignEqCourse(id, {...m, 'uid': _uid}, _due); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Course assigned.'))); } catch (e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'))); } finally { if (mounted) setState(() => _busy = false); } }, child: Text(_busy ? 'Assigning...' : 'Assign course')),
        ]));
      });
    })), const SiteFooter(),
  ])));
}

class MTLearningReportsPage extends StatelessWidget {
  const MTLearningReportsPage({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: const SiteHeader(), body: SingleChildScrollView(child: Column(children: [
    const SimplePageHero(eyebrow: 'EMPLOYER REPORTS', title: 'Monitor team learning.', description: 'Review individual course progress and assessment results.'),
    SectionWrapper(child: FutureBuilder<String?>(future: MTPortalService.orgId(), builder: (context, org) {
      if (org.connectionState != ConnectionState.done) return const CircularProgressIndicator(); final id = org.data; if (id == null) return const Text('Organization profile not found.');
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: MTPortalService.db.collection('organizations').doc(id).collection('members').snapshots(), builder: (context, s) {
        if (!s.hasData) return const CircularProgressIndicator();
        final docs = s.data!.docs;
        if (docs.isEmpty) return const Text('No team members yet.');
        return Column(children: [
          Align(alignment: Alignment.centerRight, child: OutlinedButton.icon(
            icon: const Icon(Icons.download_outlined), label: const Text('Export CSV'),
            onPressed: () async {
              final csv = StringBuffer('Name,Email,Department,Completed Modules,Progress,Best Quiz,Passed\n');
              for (final member in docs) {
                final progress = await MTPortalService.db.collection('enrollments').doc(member.id).collection('courses').doc(MTProgressService.courseId).get();
                final assessment = await MTPortalService.db.collection('assessments').doc(member.id).collection('courses').doc(MTProgressService.courseId).get();
                final completed = (progress.data()?['completedModules'] as List?)?.length ?? 0;
                final best = assessment.data()?['bestScore'] ?? '';
                final passed = assessment.data()?['passed'] == true ? 'Yes' : 'No';
                final m = member.data();
                csv.writeln('"${m['name'] ?? ''}","${m['email'] ?? ''}","${m['department'] ?? ''}",$completed,${(completed / 5 * 100).round()},$best,$passed');
              }
              await Clipboard.setData(ClipboardData(text: csv.toString()));
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CSV report copied to clipboard.')));
            },
          )),
          ...docs.map((m) => _MTEmployeeProgressCard(member: m)),
        ]);
      });
    })), const SiteFooter(),
  ])));
}
class _MTEmployeeProgressCard extends StatelessWidget {
  const _MTEmployeeProgressCard({required this.member}); final QueryDocumentSnapshot<Map<String, dynamic>> member;
  @override Widget build(BuildContext context) => StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(stream: MTPortalService.db.collection('enrollments').doc(member.id).collection('courses').doc(MTProgressService.courseId).snapshots(), builder: (context, p) {
    final d = p.data?.data() ?? {}; final count = (d['completedModules'] as List?)?.length ?? 0; final percent = (count / 5 * 100).round();
    return _MTPortalCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: Text(member.data()['name'] ?? member.data()['email'] ?? member.id, style: const TextStyle(fontWeight: FontWeight.w800))), Text('$percent%', style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w900))]),
      Text('${member.data()['email'] ?? ''} • ${member.data()['department'] ?? 'General'}'), const SizedBox(height: 8), LinearProgressIndicator(value: percent / 100), Text('$count / 5 modules completed'),
      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(stream: MTPortalService.db.collection('assessments').doc(member.id).collection('courses').doc(MTProgressService.courseId).snapshots(), builder: (context, a) { final x = a.data?.data(); return Text(x == null ? 'Quiz: not attempted' : 'Best score: ${x['bestScore']}/8 • ${x['passed'] == true ? 'Passed' : 'Not passed'}'); }),
    ]));
  });
}

class MTTrainerDashboardPage extends StatelessWidget {
  const MTTrainerDashboardPage({super.key});
  Future<void> _addMaterial(BuildContext context) async {
    final title = TextEditingController(), url = TextEditingController(), description = TextEditingController(); int module = 0;
    await showDialog<void>(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setD) => AlertDialog(title: const Text('Add learning material'), content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(controller: title, decoration: const InputDecoration(labelText: 'Title')), TextField(controller: url, decoration: const InputDecoration(labelText: 'URL')), TextField(controller: description, decoration: const InputDecoration(labelText: 'Description')),
      DropdownButtonFormField<int>(value: module, decoration: const InputDecoration(labelText: 'Module'), items: List.generate(5, (i) => DropdownMenuItem(value: i, child: Text('Module ${i + 1}'))), onChanged: (v) => setD(() => module = v ?? 0)),
    ])), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')), FilledButton(onPressed: () async { try { await MTPortalService.addMaterial(module, title.text, url.text, description.text); if (ctx.mounted) Navigator.pop(ctx); } catch (e) { if (ctx.mounted) ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('$e'))); } }, child: const Text('Save'))])));
    title.dispose(); url.dispose(); description.dispose();
  }
  @override Widget build(BuildContext context) { final uid = FirebaseAuth.instance.currentUser?.uid; if (uid == null) return const MTAccessMessage(title: 'Please log in', icon: Icons.lock_outline);
  return Scaffold(appBar: const SiteHeader(), body: SingleChildScrollView(child: Column(children: [
    const SimplePageHero(eyebrow: 'TRAINER PORTAL', title: 'Support learning delivery.', description: 'View assigned courses, add learning resources and monitor learners.'),
    SectionWrapper(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: MTPortalService.db.collection('trainerAssignments').doc(uid).collection('courses').snapshots(), builder: (context, assigned) {
      if (assigned.hasError) return Text('Could not load assignments: ${assigned.error}'); if (!assigned.hasData) return const CircularProgressIndicator();
      if (assigned.data!.docs.isEmpty) return const _MTPortalCard(child: Text('No courses assigned yet. Contact the administrator.'));
      return Column(children: [
        ...assigned.data!.docs.map((d) => _MTPortalCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(d.data()['courseTitle'] ?? MTProgressService.courseName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), const SizedBox(height: 10), FilledButton.icon(onPressed: () => _addMaterial(context), icon: const Icon(Icons.add_link), label: const Text('Add material')), OutlinedButton(onPressed: () => goTo(context, '/learning'), child: const Text('View course catalogue'))]))),
        const SizedBox(height: 12), const Text('Learner monitoring', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: MTPortalService.db.collection('courseRoster').doc(MTProgressService.courseId).collection('learners').snapshots(), builder: (context, learners) {
          if (!learners.hasData) return const CircularProgressIndicator(); if (learners.data!.docs.isEmpty) return const Text('No learners enrolled yet.');
          return Column(children: learners.data!.docs.map((d) { final x = d.data(); final n = (x['completedModules'] as List?)?.length ?? 0; return _MTPortalCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(x['name'] ?? x['email'] ?? d.id, style: const TextStyle(fontWeight: FontWeight.w800)), Text(x['email'] ?? ''), LinearProgressIndicator(value: n / 5), Text('$n/5 modules • Quiz ${x['bestScore'] ?? '—'}/8 • ${x['passed'] == true ? 'Passed' : 'Not passed'}') ])); }).toList());
        }),
      ]);
    })), const SiteFooter(),
  ])));
  }
}

class MTAdminDashboardPage extends StatelessWidget {
  const MTAdminDashboardPage({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: const SiteHeader(), body: SingleChildScrollView(child: Column(children: [
    const SimplePageHero(eyebrow: 'ADMIN PORTAL', title: 'Manage the MT Alchemy platform.', description: 'Review applications, manage users and organizations, assign trainers, process enquiries and update orders.'),
    SectionWrapper(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const _MTPortalCard(child: Text('The first administrator account must be approved once in Firebase Console. After that, role approvals and platform operations can be managed here.')),
      _MTAdminApplications(), _MTAdminUsers(), _MTAdminOrganizations(), _MTAdminTrainerAssignments(), _MTAdminEnquiries(), _MTAdminOrders(), _MTAdminProducts(),
    ])), const SiteFooter(),
  ])));
}
class _MTAdminApplications extends StatelessWidget {
  @override Widget build(BuildContext context) => _MTPortalCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Pending role applications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: MTPortalService.db.collection('roleApplications').orderBy('createdAt', descending: true).limit(50).snapshots(), builder: (context, s) {
      if (s.hasError) return Text('Error: ${s.error}'); if (!s.hasData) return const LinearProgressIndicator(); final docs = s.data!.docs.where((d) => d.data()['status'] == 'pending').toList(); if (docs.isEmpty) return const Text('No pending applications.');
      return Column(children: docs.map((d) => ListTile(contentPadding: EdgeInsets.zero, title: Text('${d.data()['name'] ?? d.id} • ${d.data()['requestedRole']}'), subtitle: Text(d.data()['organizationName'] ?? d.data()['trainerBio'] ?? ''), trailing: Wrap(children: [IconButton(icon: const Icon(Icons.check_circle, color: Colors.green), onPressed: () => MTPortalService.reviewApplication(d.id, true)), IconButton(icon: const Icon(Icons.cancel, color: Colors.red), onPressed: () => MTPortalService.reviewApplication(d.id, false))]))).toList());
    }),
  ]));
}
class _MTAdminUsers extends StatelessWidget {
  @override Widget build(BuildContext context) => _MTPortalCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Users', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: MTPortalService.db.collection('users').orderBy('createdAt', descending: true).limit(100).snapshots(), builder: (context, s) { if (s.hasError) return Text('Error: ${s.error}'); if (!s.hasData) return const LinearProgressIndicator(); return Column(children: s.data!.docs.map((d) => ListTile(title: Text(d.data()['name'] ?? 'User'), subtitle: Text('${d.data()['email'] ?? ''} • ${d.data()['role'] ?? 'individual'}'), trailing: Text(d.id.substring(0, d.id.length > 7 ? 7 : d.id.length), style: const TextStyle(fontSize: 10)))).toList()); }),
  ]));
}
class _MTAdminOrganizations extends StatelessWidget {
  @override Widget build(BuildContext context) => _MTPortalCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Organizations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: MTPortalService.db.collection('organizations').limit(50).snapshots(), builder: (context, s) { if (s.hasError) return Text('Error: ${s.error}'); if (!s.hasData) return const LinearProgressIndicator(); return Column(children: s.data!.docs.map((d) => ListTile(title: Text(d.data()['name'] ?? d.id), subtitle: Text('${d.data()['industry'] ?? ''} • ${d.data()['status'] ?? ''}'))).toList()); }),
  ]));
}
class _MTAdminTrainerAssignments extends StatelessWidget {
  @override Widget build(BuildContext context) => _MTPortalCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Assign EQ course to trainers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: MTPortalService.db.collection('users').where('role', isEqualTo: 'trainer').snapshots(), builder: (context, s) { if (!s.hasData) return const LinearProgressIndicator(); if (s.data!.docs.isEmpty) return const Text('No approved trainers yet.'); return Column(children: s.data!.docs.map((d) => ListTile(title: Text(d.data()['name'] ?? d.id), subtitle: Text(d.data()['email'] ?? ''), trailing: FilledButton.tonal(onPressed: () => MTPortalService.assignTrainer(d.id), child: const Text('Assign EQ')))).toList()); }),
  ]));
}
class _MTAdminLearners extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _MTPortalCard(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Learner progress and assessments',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: MTPortalService.db.collection('courseRoster')
            .doc(MTProgressService.courseId).collection('learners').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Could not load learner records: ${snapshot.error}');
          if (!snapshot.hasData) return const LinearProgressIndicator();
          if (snapshot.data!.docs.isEmpty) return const Text('No learner records yet.');
          return Column(children: snapshot.data!.docs.map((doc) {
            final d = doc.data();
            final completed = (d['completedModules'] as List?)?.length ?? 0;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(d['name'] ?? d['email'] ?? doc.id),
              subtitle: Text('${d['email'] ?? ''} • $completed/5 modules • Quiz ${d['bestScore'] ?? '—'}/8'),
              trailing: Text('${(completed / 5 * 100).round()}%',
                  style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w800)),
            );
          }).toList());
        },
      ),
    ]),
  );
}

class _MTAdminEnquiries extends StatelessWidget {
  @override Widget build(BuildContext context) => _MTPortalCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Contact and corporate enquiries', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: MTPortalService.db.collection('enquiries').orderBy('createdAt', descending: true).limit(50).snapshots(), builder: (context, s) { if (s.hasError) return Text('Error: ${s.error}'); if (!s.hasData) return const LinearProgressIndicator(); if (s.data!.docs.isEmpty) return const Text('No enquiries received.'); return Column(children: s.data!.docs.map((d) => ExpansionTile(title: Text('${d.data()['name'] ?? 'Visitor'} • ${d.data()['enquiryType'] ?? ''}'), subtitle: Text('${d.data()['email'] ?? ''} • ${d.data()['status'] ?? 'new'}'), children: [Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(d.data()['message'] ?? ''), Wrap(children: ['contacted','in-progress','closed'].map((status) => TextButton(onPressed: () => MTPortalService.setEnquiryStatus(d.id, status), child: Text(status))).toList())]))])).toList()); }),
  ]));
}
class _MTAdminOrders extends StatelessWidget {
  @override Widget build(BuildContext context) => _MTPortalCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Order management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: MTPortalService.db.collection('users').limit(100).snapshots(), builder: (context, users) { if (!users.hasData) return const LinearProgressIndicator(); return Column(children: users.data!.docs.map((u) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: MTPortalService.db.collection('orders').doc(u.id).collection('items').limit(20).snapshots(), builder: (context, orders) { if (!orders.hasData || orders.data!.docs.isEmpty) return const SizedBox.shrink(); return Column(children: orders.data!.docs.map((o) => ListTile(title: Text('RM${o.data()['totalRm'] ?? 0} • ${o.data()['status'] ?? 'demo-confirmed'}'), subtitle: Text(u.data()['email'] ?? u.id), trailing: PopupMenuButton<String>(onSelected: (v) => MTPortalService.setOrderStatus(u.id, o.id, v), itemBuilder: (_) => const [PopupMenuItem(value: 'processing', child: Text('Processing')), PopupMenuItem(value: 'shipped', child: Text('Shipped')), PopupMenuItem(value: 'delivered', child: Text('Delivered'))]))).toList()); })).toList()); }),
  ]));
}
class _MTAdminProducts extends StatelessWidget {
  @override Widget build(BuildContext context) => _MTPortalCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Store product availability', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), const Text('Publish or hide existing prototype products. Prices are maintained in the catalogue.'),
    ...['workbook','journal','cards'].map((id) { final product = MTCommerceService.productFor(id); return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(stream: MTPortalService.db.collection('storeProductSettings').doc(id).snapshots(), builder: (context, s) { final data = s.data?.data() ?? {}; final published = data['published'] as bool? ?? true; return SwitchListTile(title: Text(product.title), subtitle: Text(published ? 'Published' : 'Hidden'), value: published, onChanged: (v) => MTPortalService.db.collection('storeProductSettings').doc(id).set({'productId': id, 'title': product.title, 'published': v, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true))); }); }),
  ]));
}

class MTMyAssignedCoursesPanel extends StatelessWidget {
  const MTMyAssignedCoursesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return const SizedBox.shrink();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: MTPortalService.db
          .collectionGroup('assignments')
          .where('employeeUid', isEqualTo: currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }
        return _MTPortalCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Assigned by your organization',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
              ...snapshot.data!.docs.map((doc) {
                final data = doc.data();
                return ListTile(
                  title: Text(data['courseTitle'] ?? MTProgressService.courseName),
                  subtitle: Text('Status: ${data['status'] ?? 'assigned'}'),
                  trailing: TextButton(
                    onPressed: () async {
                      try {
                        await MTProgressService.enroll();
                        if (context.mounted) goTo(context, '/course-player');
                      } catch (error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$error')),
                          );
                        }
                      }
                    },
                    child: const Text('Start'),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class MTTrainerMaterialsForModule extends StatelessWidget {
  const MTTrainerMaterialsForModule({super.key, required this.moduleIndex});
  final int moduleIndex;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: MTPortalService.db
          .collection('courseMaterials')
          .doc(MTProgressService.courseId)
          .collection('items')
          .where('moduleIndex', isEqualTo: moduleIndex)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.where((doc) => doc.data()['active'] != false).isEmpty) {
          return const SizedBox.shrink();
        }
        final activeDocs = snapshot.data!.docs.where((doc) => doc.data()['active'] != false);
        return _MTPortalCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Additional trainer materials',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ...activeDocs.map((doc) {
                final data = doc.data();
                return ListTile(
                  title: Text(data['title'] ?? 'Resource'),
                  subtitle: Text(data['description'] ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: () async {
                      final uri = Uri.tryParse(data['url'] ?? '');
                      if (uri != null) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class MTContactEnquiryPage extends StatefulWidget {
  const MTContactEnquiryPage({super.key});
  @override State<MTContactEnquiryPage> createState() => _MTContactEnquiryPageState();
}
class _MTContactEnquiryPageState extends State<MTContactEnquiryPage> {
  final _key = GlobalKey<FormState>(); final _name = TextEditingController(); final _email = TextEditingController(); final _phone = TextEditingController(); final _org = TextEditingController(); final _message = TextEditingController();
  String _type = 'Corporate Training'; bool _busy = false;
  @override void dispose() { _name.dispose(); _email.dispose(); _phone.dispose(); _org.dispose(); _message.dispose(); super.dispose(); }
  Future<void> _send() async { if (!_key.currentState!.validate()) return; setState(() => _busy = true); try { await MTPortalService.submitEnquiry({'name':_name.text.trim(),'email':_email.text.trim(),'phone':_phone.text.trim(),'organization':_org.text.trim(),'enquiryType':_type,'message':_message.text.trim()}); _name.clear(); _email.clear(); _phone.clear(); _org.clear(); _message.clear(); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enquiry sent successfully.'))); } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'))); } finally { if (mounted) setState(() => _busy = false); } }
  @override Widget build(BuildContext context) => Scaffold(appBar: const SiteHeader(), body: SingleChildScrollView(child: Column(children: [
    const SimplePageHero(eyebrow: 'CONTACT MT ALCHEMY', title: 'Let’s build a thriving workplace together.', description: 'Tell us about your people development goals.'),
    SectionWrapper(child: _MTPortalCard(child: Form(key: _key, child: Column(children: [
      TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null), const SizedBox(height: 10),
      TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email' : null), const SizedBox(height: 10),
      TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone')), const SizedBox(height: 10),
      TextFormField(controller: _org, decoration: const InputDecoration(labelText: 'Organization')), const SizedBox(height: 10),
      DropdownButtonFormField<String>(value: _type, decoration: const InputDecoration(labelText: 'Enquiry type'), items: const ['Individual Coaching','Corporate Training','Leadership Development','Team Development','Products','Partnership','Other'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) => setState(() => _type = v ?? _type)), const SizedBox(height: 10),
      TextFormField(controller: _message, minLines: 4, maxLines: 6, decoration: const InputDecoration(labelText: 'Message'), validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null), const SizedBox(height: 16),
      SizedBox(width: double.infinity, child: FilledButton(onPressed: _busy ? null : _send, child: Text(_busy ? 'Sending...' : 'Submit enquiry'))),
    ])))), const SiteFooter(),
  ])));
}

class _MTPortalCard extends StatelessWidget {
  const _MTPortalCard({required this.child}); final Widget child;
  @override Widget build(BuildContext context) => Container(width: double.infinity, margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFFE5EBF9))), child: child);
}
class _MTStatCard extends StatelessWidget {
  const _MTStatCard({required this.value, required this.label}); final String value; final String label;
  @override Widget build(BuildContext context) => Container(width: 150, margin: const EdgeInsets.only(right: 10, bottom: 10), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.iceBlue, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.deepBlue)), Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54))]));
}
class _MTPortalAction extends StatelessWidget {
  const _MTPortalAction(this.title, this.icon, this.onTap); final String title; final IconData icon; final VoidCallback onTap;
  @override Widget build(BuildContext context) => OutlinedButton.icon(onPressed: onTap, icon: Icon(icon), label: Text(title));
}
