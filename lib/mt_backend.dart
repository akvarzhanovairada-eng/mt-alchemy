part of 'main.dart';

/// Phase 1: authenticated profiles, guarded portals, and private course progress.
/// This file belongs in lib/ next to main.dart and is included with `part`.
class MTUserProfile {
  const MTUserProfile({required this.name, required this.email, required this.role});

  final String name;
  final String email;
  final String role;

  factory MTUserProfile.fromMap(Map<String, dynamic> data) {
    return MTUserProfile(
      name: (data['name'] as String?)?.trim() ?? '',
      email: (data['email'] as String?)?.trim() ?? '',
      role: (data['role'] as String?)?.toLowerCase().trim() ?? 'individual',
    );
  }

  String get initials {
    final parts = name.split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return 'MT';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class MTUserService {
  static final _users = FirebaseFirestore.instance.collection('users');

  static Stream<DocumentSnapshot<Map<String, dynamic>>> profileStream(String uid) =>
      _users.doc(uid).snapshots();

  /// Backfills older Firebase Auth users that predate the Firestore integration.
  /// NEVER overwrites a role; newly created documents are always `individual`.
  static Future<void> ensureIndividualProfile(User user) async {
    final ref = _users.doc(user.uid);
    final existing = await ref.get();
    if (existing.exists) return;
    final email = user.email;
    if (email == null || email.isEmpty) {
      throw StateError('An email address is required to create a profile.');
    }
    final name = user.displayName?.trim().isNotEmpty == true
        ? user.displayName!.trim()
        : email.split('@').first;
    await ref.set({
      'name': name,
      'email': email,
      'role': 'individual',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

/// Route checks are UX. Firestore Security Rules enforce the real data boundary.
class MTAuthGate extends StatelessWidget {
  const MTAuthGate({super.key, required this.route, required this.child});

  final String route;
  final Widget child;

  bool _canAccess(String role) {
    switch (route) {
      case '/admin':
        return role == 'admin';
      case '/trainer':
        return role == 'trainer' || role == 'admin';
      case '/employer':
      case '/employees':
      case '/assign-course':
      case '/reports':
        return role == 'employer' || role == 'admin';
      default:
        return true; // Learning routes require login but not a privileged role.
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const MTAccessMessage(title: 'Checking your account...', icon: Icons.hourglass_top_rounded);
        }
        final user = authSnapshot.data;
        if (user == null) {
          return MTAccessMessage(
            title: 'Please log in to continue',
            message: 'Your learning and account data are private. Sign in to access this page.',
            icon: Icons.lock_outline_rounded,
            actionLabel: 'Log in / Sign up',
            onAction: () => Navigator.pushReplacementNamed(context, '/register'),
          );
        }
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: MTUserService.profileStream(user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const MTAccessMessage(
                title: 'Cannot load your profile',
                message: 'Please check your connection and Firestore Rules, then try again.',
                icon: Icons.wifi_off_rounded,
              );
            }
            if (!snapshot.hasData) {
              return const MTAccessMessage(title: 'Loading your profile...', icon: Icons.hourglass_top_rounded);
            }
            if (!snapshot.data!.exists) {
              return MTAccessMessage(
                title: 'Your profile needs a one-time setup',
                message: 'This account was created before we enabled Firestore profiles.',
                icon: Icons.person_add_alt_1_rounded,
                actionLabel: 'Create my learner profile',
                onAction: () async {
                  try {
                    await MTUserService.ensureIndividualProfile(user);
                  } catch (error) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not create profile: $error')),
                      );
                    }
                  }
                },
              );
            }
            final profile = MTUserProfile.fromMap(snapshot.data!.data() ?? {});
            if (!_canAccess(profile.role)) {
              return const MTAccessMessage(
                title: 'Access restricted',
                message: 'This page is only available to an approved account role.',
                icon: Icons.shield_outlined,
              );
            }
            return child;
          },
        );
      },
    );
  }
}

class MTAccessMessage extends StatelessWidget {
  const MTAccessMessage({
    super.key,
    required this.title,
    this.message = '',
    required this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFFE1E8F5)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 42, color: AppColors.blue),
                  const SizedBox(height: 15),
                  Text(title, textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                  if (message.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(message, textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black54, height: 1.5)),
                  ],
                  const SizedBox(height: 20),
                  if (onAction != null && actionLabel != null)
                    FilledButton(onPressed: onAction, child: Text(actionLabel!)),
                  TextButton(onPressed: () => goTo(context, '/'), child: const Text('Back to Home')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows a real profile and routes based on the role stored in Firestore.
class MTAccountMenuButton extends StatelessWidget {
  const MTAccountMenuButton({super.key, this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        final user = authSnapshot.data;
        if (user == null) {
          if (compact) {
            return IconButton(
              tooltip: 'Log in / Sign up',
              icon: const Icon(Icons.account_circle_outlined),
              onPressed: () => goTo(context, '/register'),
            );
          }
          return OutlinedButton.icon(
            onPressed: () => goTo(context, '/register'),
            icon: const Icon(Icons.person_outline_rounded, size: 18),
            label: const Text('Log in / Sign up'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.deepBlue,
              side: const BorderSide(color: Color(0xFFDCE5FC)),
              backgroundColor: AppColors.iceBlue,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
          );
        }
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: MTUserService.profileStream(user.uid),
          builder: (context, profileSnapshot) {
            final data = profileSnapshot.data?.data() ?? {};
            final profile = MTUserProfile.fromMap(data);
            final displayName = profile.name.isNotEmpty
                ? profile.name
                : (user.displayName?.trim().isNotEmpty == true
                ? user.displayName!.trim()
                : user.email?.split('@').first ?? 'My Account');
            final role = profile.role;
            final portalRoute = role == 'admin'
                ? '/admin'
                : role == 'trainer'
                ? '/trainer'
                : role == 'employer'
                ? '/employer'
                : '/dashboard';
            final portalLabel = role == 'admin'
                ? 'Admin Dashboard'
                : role == 'trainer'
                ? 'Trainer Dashboard'
                : role == 'employer'
                ? 'Employer Dashboard'
                : 'My Learning';
            return PopupMenuButton<String>(
              tooltip: 'My account',
              onSelected: (value) async {
                if (value == 'logout') {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                  }
                } else {
                  if (context.mounted) goTo(context, value);
                }
              },
              offset: const Offset(0, 50),
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  enabled: false,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(displayName, style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 3),
                    Text(user.email ?? '', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    Text(role.toUpperCase(), style: const TextStyle(fontSize: 10, color: AppColors.blue)),
                  ]),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(value: portalRoute, child: Text(portalLabel)),
                if (portalRoute != '/dashboard')
                  const PopupMenuItem(value: '/dashboard', child: Text('My Learning')),
                const PopupMenuItem(value: '/my-orders', child: Text('My Orders')),
                const PopupMenuItem(value: '/my-digital-products', child: Text('My Digital Products')),
                if (role == 'individual') ...[
                  const PopupMenuItem(value: '/my-invitations', child: Text('My Invitations')),
                  const PopupMenuItem(value: '/apply-role', child: Text('Request Employer / Trainer access')),
                ],
                if (role == 'employer') ...[
                  const PopupMenuItem(value: '/employees', child: Text('Manage Employees')),
                  const PopupMenuItem(value: '/assign-course', child: Text('Assign Course')),
                  const PopupMenuItem(value: '/reports', child: Text('Learning Reports')),
                ],
                const PopupMenuItem(value: 'logout', child: Text('Log out')),
              ],
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.iceBlue,
                  border: Border.all(color: const Color(0xFFDCE5FC)),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.blue,
                    child: Text(profile.initials, style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white,
                    )),
                  ),
                  if (!compact) ...[
                    const SizedBox(width: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 100),
                      child: Text(displayName, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    const Icon(Icons.arrow_drop_down_rounded),
                  ],
                ]),
              ),
            );
          },
        );
      },
    );
  }
}

class MTProgress {
  const MTProgress({
    required this.completedModules,
    required this.lastModule,
    required this.enrolledAt,
  });

  final Set<int> completedModules;
  final int lastModule;
  final DateTime? enrolledAt;

  double get fraction => completedModules.length / MTProgressService.moduleTitles.length;
  int get percent => (fraction * 100).round();
  bool get lessonsFinished => completedModules.length == MTProgressService.moduleTitles.length;

  factory MTProgress.fromMap(Map<String, dynamic> data) {
    final rawCompleted = data['completedModules'];
    final completed = <int>{};
    if (rawCompleted is List) {
      for (final value in rawCompleted) {
        if (value is int && value >= 0 && value < MTProgressService.moduleTitles.length) {
          completed.add(value);
        }
      }
    }
    final stored = data['lastModule'];
    final index = stored is int ? stored.clamp(0, 4).toInt() : 0;
    final date = data['enrolledAt'];
    return MTProgress(
      completedModules: completed,
      lastModule: index,
      enrolledAt: date is Timestamp ? date.toDate() : null,
    );
  }
}

class MTProgressService {
  static const courseId = 'eq-fundamentals';
  static const courseName = 'Emotional Intelligence Fundamentals';
  static const moduleTitles = <String>[
    'Understanding Emotional Intelligence',
    'Self-Awareness & Emotional Patterns',
    'Emotional Regulation in Practice',
    'Empathy & Effective Communication',
    'Applying EQ at Work',
  ];

  static User get _user {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('You must log in first.');
    return user;
  }
  static String get _uid => _user.uid;
  static DocumentReference<Map<String, dynamic>> get _document =>
      FirebaseFirestore.instance.collection('enrollments').doc(_uid)
          .collection('courses').doc(courseId);
  static DocumentReference<Map<String, dynamic>> get _rosterDocument =>
      FirebaseFirestore.instance.collection('courseRoster').doc(courseId)
          .collection('learners').doc(_uid);

  static Stream<MTProgress?> watch() => _document.snapshots().map((snapshot) =>
  snapshot.exists ? MTProgress.fromMap(snapshot.data() ?? {}) : null);
  static Future<MTProgress?> fetch() async {
    final snapshot = await _document.get();
    return snapshot.exists ? MTProgress.fromMap(snapshot.data() ?? {}) : null;
  }

  static Future<Map<String, dynamic>> _rosterBase() async {
    final profile = await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    return {
      'userId': _uid,
      'name': profile.data()?['name'] ?? _user.displayName ?? 'Learner',
      'email': _user.email ?? '',
      'courseId': courseId,
      'courseTitle': courseName,
    };
  }

  static Future<void> enroll() async {
    final ref = _document;
    final roster = _rosterDocument;
    final base = await _rosterBase();
    await FirebaseFirestore.instance.runTransaction<void>((tx) async {
      final snapshot = await tx.get(ref);
      final rosterSnapshot = await tx.get(roster);
      if (!snapshot.exists) {
        tx.set(ref, {
          'courseId': courseId, 'courseTitle': courseName,
          'completedModules': <int>[], 'lastModule': 0,
          'enrolledAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      final current = snapshot.data() ?? {'completedModules': <int>[], 'lastModule': 0};
      tx.set(roster, {
        ...base,
        'completedModules': current['completedModules'] ?? <int>[],
        'lastModule': current['lastModule'] ?? 0,
        'updatedAt': FieldValue.serverTimestamp(),
        if (rosterSnapshot.exists && rosterSnapshot.data()?['bestScore'] != null)
          'bestScore': rosterSnapshot.data()!['bestScore'],
        if (rosterSnapshot.exists && rosterSnapshot.data()?['passed'] != null)
          'passed': rosterSnapshot.data()!['passed'],
      }, SetOptions(merge: true));
    });
  }

  static Future<void> openModule(int index) async {
    if (index < 0 || index >= moduleTitles.length) throw RangeError.index(index, moduleTitles);
    final progress = await fetch();
    if (progress == null) throw StateError('Enrol in the course first.');
    final base = await _rosterBase();
    final batch = FirebaseFirestore.instance.batch();
    batch.update(_document, {'lastModule': index, 'updatedAt': FieldValue.serverTimestamp()});
    batch.set(_rosterDocument, {...base, 'completedModules': progress.completedModules.toList(),
      'lastModule': index, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    await batch.commit();
  }

  static Future<void> markComplete(int index) async {
    if (index < 0 || index >= moduleTitles.length) throw RangeError.index(index, moduleTitles);
    final progress = await fetch();
    if (progress == null) throw StateError('Enrol in the course first.');
    final completed = {...progress.completedModules, index}.toList()..sort();
    final base = await _rosterBase();
    final batch = FirebaseFirestore.instance.batch();
    batch.update(_document, {'completedModules': FieldValue.arrayUnion([index]),
      'lastModule': index, 'updatedAt': FieldValue.serverTimestamp()});
    batch.set(_rosterDocument, {...base, 'completedModules': completed,
      'lastModule': index, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    await batch.commit();
  }
}

