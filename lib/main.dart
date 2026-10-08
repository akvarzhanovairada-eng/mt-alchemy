import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

part 'extra_pages.dart';

void main() {
  runApp(const MTAlchemyApp());
}

// ============================================================
// COLORS
// ============================================================

class AppColors {
  static const blue = Color(0xFF3670FF);
  static const deepBlue = Color(0xFF101B8F);
  static const yellow = Color(0xFFFFD601);
  static const background = Color(0xFFF7F7F8);
  static const softGray = Color(0xFFEFEFEF);
  static const dark = Color(0xFF171717);
  static const purple = Color(0xFF7467E8);
  static const iceBlue = Color(0xFFEAF2FF);
  static const mistBlue = Color(0xFFF3F7FF);
  static const white = Colors.white;
}

// ============================================================
// APP
// ============================================================

class MTAlchemyApp extends StatelessWidget {
  const MTAlchemyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();

    return MaterialApp(
      title: 'MT Alchemy',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.blue,
          primary: AppColors.blue,
        ),
        textTheme: baseTextTheme,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFE2E2E2),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFE2E2E2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.blue,
              width: 1.5,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),

      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
          case '/':
            page = const HomePage();
            break;
          case '/about':
            page = const AboutPage();
            break;
          case '/services':
            page = const ServicesPage();
            break;
          case '/learning':
            page = const LearningPage();
            break;
          case '/store':
            page = const StorePage();
            break;
          case '/insights':
            page = const InsightsPage();
            break;
          case '/contact':
            page = const ContactPage();
            break;
          case '/register':
            page = const RegisterPage();
            break;
          case '/cart':
            page = const CartPage();
            break;
          case '/checkout':
            page = const CheckoutPage();
            break;
          case '/employer':
            page = const EmployerDashboard();
            break;
          case '/dashboard':
            page = const LearnerDashboardPage();
            break;
          case '/course-player':
            page = const CoursePlayerPage();
            break;
          case '/learning-quiz':
            page = const LearningQuizPage();
            break;
          case '/certificate':
            page = const CertificatePage();
            break;
          case '/course-finder':
            page = const CourseFinderPage();
            break;
          case '/organizations':
            page = const OrganizationsPage();
            break;
          case '/coaching':
            page = const IndividualCoachingPage();
            break;
          case '/corporate-programmes':
            page = const CorporateProgrammesPage();
            break;
          case '/employees':
            page = const EmployeeManagementPage();
            break;
          case '/assign-course':
            page = const CourseAssignmentPage();
            break;
          case '/reports':
            page = const LearningReportsPage();
            break;
          case '/trainer':
            page = const TrainerDashboardPage();
            break;
          case '/admin':
            page = const AdminDashboardPage();
            break;
          default:
            page = const HomePage();
        }

        return PageRouteBuilder(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 350),
          pageBuilder: (_, animation, __) => page,
          transitionsBuilder: (_, animation, __, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );

            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.025, 0.02),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}

// ============================================================
// NAVIGATION
// ============================================================

void goTo(BuildContext context, String route) {
  if (ModalRoute.of(context)?.settings.name == route) {
    return;
  }

  Navigator.pushNamed(context, route);
}

// ============================================================
// HEADER
// ============================================================

class SiteHeader extends StatelessWidget implements PreferredSizeWidget {
  const SiteHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(84);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final desktop = width > 1180;

    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      toolbarHeight: 84,
      automaticallyImplyLeading: false,
      titleSpacing: 28,
      title: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: () => goTo(context, '/'),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Image.asset(
                'assets/images/logo.png',
                height: 56,
              ),
            ),
          ),
          const Spacer(),
          if (desktop) ...[
            const HeaderLink(title: 'Home', route: '/'),
            const HeaderLink(title: 'About', route: '/about'),
            const HeaderLink(title: 'Services', route: '/services'),
            const HeaderLink(title: 'Upskilling', route: '/learning'),
            const HeaderLink(title: 'Store', route: '/store'),
            const HeaderLink(title: 'Insights', route: '/insights'),
            const HeaderLink(title: 'Contact', route: '/contact'),
            const SizedBox(width: 8),
            const AssistantPulseButton(),
            const SizedBox(width: 4),
            IconButton(
              tooltip: 'Cart',
              onPressed: () => goTo(context, '/cart'),
              icon: const Icon(Icons.shopping_bag_outlined),
            ),
            const SizedBox(width: 4),
            const ProfileMenuButton(),
          ] else ...[
            const AssistantPulseButton(compact: true),
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu_rounded),
              onSelected: (route) => goTo(context, route),
              itemBuilder: (_) => const [
                PopupMenuItem(value: '/', child: Text('Home')),
                PopupMenuItem(value: '/about', child: Text('About')),
                PopupMenuItem(value: '/services', child: Text('Services')),
                PopupMenuItem(value: '/learning', child: Text('Upskilling')),
                PopupMenuItem(value: '/store', child: Text('Store')),
                PopupMenuItem(value: '/insights', child: Text('Insights')),
                PopupMenuItem(value: '/contact', child: Text('Contact')),
                PopupMenuDivider(),
                PopupMenuItem(value: '/dashboard', child: Text('My Learning')),
                PopupMenuItem(value: '/register', child: Text('Login / Register')),
                PopupMenuItem(value: '/cart', child: Text('Cart')),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class HeaderLink extends StatelessWidget {
  final String title;
  final String route;

  const HeaderLink({
    super.key,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => goTo(context, route),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.dark,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class ProfileMenuButton extends StatelessWidget {
  const ProfileMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Demo learner profile',
      onSelected: (value) => goTo(context, value),
      offset: const Offset(0, 54),
      color: Colors.white,
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      itemBuilder: (_) => const [
        PopupMenuItem(
          enabled: false,
          child: Row(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: AppColors.blue,
                child: Text(
                  'DL',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Demo Learner',
                    style: TextStyle(
                      color: AppColors.dark,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Individual account',
                    style: TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ],
              ),
            ],
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(value: '/dashboard', child: Text('My Learning')),
        PopupMenuItem(value: '/certificate', child: Text('Certificates')),
        PopupMenuItem(value: '/register', child: Text('Login / Register')),
        PopupMenuDivider(),
        PopupMenuItem(value: '/employer', child: Text('Employer Preview')),
        PopupMenuItem(value: '/trainer', child: Text('Trainer Preview')),
        PopupMenuItem(value: '/admin', child: Text('Admin Preview')),
      ],
      child: Container(
        padding: const EdgeInsets.fromLTRB(9, 7, 12, 7),
        decoration: BoxDecoration(
          color: AppColors.iceBlue,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.blue.withOpacity(0.16)),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.blue,
              child: Text(
                'DL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(width: 9),
            Text(
              'My Learning',
              style: TextStyle(
                color: AppColors.deepBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 3),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.blue,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class AssistantPulseButton extends StatefulWidget {
  final bool compact;

  const AssistantPulseButton({
    super.key,
    this.compact = false,
  });

  @override
  State<AssistantPulseButton> createState() => _AssistantPulseButtonState();
}

class _AssistantPulseButtonState extends State<AssistantPulseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> glow;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    glow = Tween<double>(begin: 0.15, end: 0.5).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glow,
      builder: (_, __) {
        return Tooltip(
          message: 'Virtual Assistant',
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => showVirtualAssistant(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.compact ? 10 : 13,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F0FF),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.purple.withOpacity(0.28)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purple.withOpacity(glow.value),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: AppColors.purple, size: 21),
                  if (!widget.compact) ...[
                    const SizedBox(width: 7),
                    const Text(
                      'Assistant',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

void showVirtualAssistant(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        alignment: Alignment.topRight,
        insetPadding: const EdgeInsets.only(top: 92, right: 24, left: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.purple,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MT Alchemy Assistant',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                          ),
                          Text(
                            'Prototype conversation',
                            style: TextStyle(fontSize: 12, color: Colors.black45),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.softGray,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Text(
                    'Hi! I can help you explore courses, corporate services and MT Alchemy resources.',
                    style: TextStyle(height: 1.55),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AssistantQuickAction(
                      label: 'Find a course',
                      onTap: () {
                        Navigator.pop(dialogContext);
                        goTo(context, '/course-finder');
                      },
                    ),
                    AssistantQuickAction(
                      label: 'Explore services',
                      onTap: () {
                        Navigator.pop(dialogContext);
                        goTo(context, '/services');
                      },
                    ),
                    AssistantQuickAction(
                      label: 'Contact us',
                      onTap: () {
                        Navigator.pop(dialogContext);
                        goTo(context, '/contact');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    suffixIcon: IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Virtual assistant is visual-only in this prototype.'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.send_rounded, color: AppColors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Prototype only — no AI or live chat backend is connected yet.',
                  style: TextStyle(fontSize: 11, color: Colors.black45),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class AssistantQuickAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const AssistantQuickAction({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      backgroundColor: Colors.white,
      side: BorderSide(color: AppColors.blue.withOpacity(0.18)),
      label: Text(
        label,
        style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w700),
      ),
    );
  }
}

// ============================================================
// LIGHT ANIMATION
// ============================================================

class FadeSlideIn extends StatelessWidget {
  final Widget child;
  final double beginY;
  final int milliseconds;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.beginY = 22,
    this.milliseconds = 650,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: milliseconds),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              beginY * (1 - value),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

class ScrollReveal extends StatefulWidget {
  final ScrollController controller;
  final Widget child;
  final int delayMs;
  final double beginY;

  const ScrollReveal({
    super.key,
    required this.controller,
    required this.child,
    this.delayMs = 0,
    this.beginY = 26,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> {
  bool visible = false;
  bool queued = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_checkVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void didUpdateWidget(covariant ScrollReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_checkVisibility);
      widget.controller.addListener(_checkVisibility);
    }
  }

  void _checkVisibility() {
    if (!mounted || visible || queued) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;
    final top = renderObject.localToGlobal(Offset.zero).dy;
    final screenHeight = MediaQuery.of(context).size.height;
    if (top < screenHeight * 0.92) {
      queued = true;
      Future.delayed(Duration(milliseconds: widget.delayMs), () {
        if (mounted) setState(() => visible = true);
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkVisibility);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 620),
      curve: Curves.easeOutCubic,
      opacity: visible ? 1 : 0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 680),
        curve: Curves.easeOutCubic,
        offset: visible ? Offset.zero : Offset(0, widget.beginY / 100),
        child: widget.child,
      ),
    );
  }
}

// ============================================================
// HOVER EFFECT
// ============================================================

class HoverLift extends StatefulWidget {
  final Widget child;

  const HoverLift({
    super.key,
    required this.child,
  });

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          hovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          hovering = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          0,
          hovering ? -7 : 0,
          0,
        ),
        child: widget.child,
      ),
    );
  }
}

// ============================================================
// HOME
// ============================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();
  bool showQuizPrompt = false;
  bool quizDismissed = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final shouldShow =
        !quizDismissed && scrollController.hasClients && scrollController.offset > 720;
    if (shouldShow != showQuizPrompt && mounted) {
      setState(() => showQuizPrompt = shouldShow);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_handleScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            ScrollReveal(
              controller: scrollController,
              child: const HomeHero(),
            ),
            ScrollReveal(
              controller: scrollController,
              delayMs: 30,
              child: const HomePathSection(),
            ),
            ScrollReveal(
              controller: scrollController,
              delayMs: 55,
              child: const ImpactStrip(),
            ),
            ScrollReveal(
              controller: scrollController,
              delayMs: 65,
              child: const HomeServicesSection(),
            ),
            ScrollReveal(
              controller: scrollController,
              delayMs: 70,
              child: const HomeAboutSection(),
            ),
            ScrollReveal(
              controller: scrollController,
              delayMs: 75,
              child: const HomeApproachSection(),
            ),
            ScrollReveal(
              controller: scrollController,
              delayMs: 80,
              child: const LearningPreviewSection(),
            ),
            ScrollReveal(
              controller: scrollController,
              delayMs: 85,
              child: const HomeLearningSnapshotSection(),
            ),
            ScrollReveal(
              controller: scrollController,
              delayMs: 90,
              child: const HomeTestimonialsSection(),
            ),
            ScrollReveal(
              controller: scrollController,
              delayMs: 95,
              child: const HomeStorePreviewSection(),
            ),
            ScrollReveal(
              controller: scrollController,
              delayMs: 100,
              child: const CorporateSection(),
            ),
            ScrollReveal(
              controller: scrollController,
              delayMs: 105,
              child: const ImpactStorySection(),
            ),
            ScrollReveal(
              controller: scrollController,
              delayMs: 110,
              child: const FinalContactCTA(),
            ),
            const SiteFooter(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: IgnorePointer(
        ignoring: !showQuizPrompt,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 360),
          curve: Curves.easeOutCubic,
          offset: showQuizPrompt ? Offset.zero : const Offset(0, 1.15),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 280),
            opacity: showQuizPrompt ? 1 : 0,
            child: QuizPromptCard(
              onDismiss: () {
                setState(() {
                  quizDismissed = true;
                  showQuizPrompt = false;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

class QuizPromptCard extends StatelessWidget {
  final VoidCallback onDismiss;

  const QuizPromptCard({
    super.key,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 8, bottom: 6),
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blue.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepBlue.withOpacity(0.13),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.blue, AppColors.purple],
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Find your best-fit course',
                  style: TextStyle(
                    color: AppColors.dark,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Take a quick learning quiz.',
                  style: TextStyle(color: Colors.black54, fontSize: 11.5),
                ),
                const SizedBox(height: 6),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => goTo(context, '/course-finder'),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      'Take the quiz →',
                      style: TextStyle(
                        color: AppColors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Close',
            onPressed: onDismiss,
            visualDensity: VisualDensity.compact,
            iconSize: 17,
            color: Colors.black38,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HOME HERO
// ============================================================

class HomeHero extends StatefulWidget {
  const HomeHero({super.key});

  @override
  State<HomeHero> createState() => _HomeHeroState();
}

class _HomeHeroState extends State<HomeHero> with SingleTickerProviderStateMixin {
  late final AnimationController gradientController;
  Timer? ideaTimer;
  int ideaIndex = 0;

  final List<(IconData, String, String)> ideas = const [
    (Icons.psychology_alt_rounded, 'Self-awareness', 'Understand patterns before reacting.'),
    (Icons.forum_rounded, 'Better communication', 'Listen, understand and connect.'),
    (Icons.workspace_premium_rounded, 'Authentic leadership', 'Lead with clarity, empathy and trust.'),
    (Icons.groups_2_rounded, 'Stronger teams', 'Turn human connection into performance.'),
  ];

  @override
  void initState() {
    super.initState();
    gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);
    ideaTimer = Timer.periodic(const Duration(milliseconds: 3200), (_) {
      if (mounted) {
        setState(() => ideaIndex = (ideaIndex + 1) % ideas.length);
      }
    });
  }

  @override
  void dispose() {
    ideaTimer?.cancel();
    gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 35),
      child: AnimatedBuilder(
        animation: gradientController,
        builder: (context, _) {
          final t = gradientController.value;
          return Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 1500),
            padding: const EdgeInsets.all(34),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1 + (t * 0.55), -1),
                end: Alignment(1 - (t * 0.35), 1),
                colors: const [
                  Color(0xFF2E63F6),
                  AppColors.blue,
                  Color(0xFF527BFF),
                ],
              ),
              borderRadius: BorderRadius.circular(34),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blue.withOpacity(0.12),
                  blurRadius: 38,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final desktop = constraints.maxWidth > 900;

                final copy = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'PEOPLE • SKILLS • POTENTIAL',
                        style: TextStyle(
                          color: AppColors.dark,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Elevate your value.\nMaster human intelligence.',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: desktop ? 54 : 38,
                        height: 1.03,
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Develop emotional intelligence, leadership, communication and stronger human connections in a rapidly evolving AI-driven world.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.65,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton(
                          onPressed: () => goTo(context, '/learning'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.yellow,
                            foregroundColor: AppColors.dark,
                          ),
                          child: const Text(
                            'Explore Learning',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () => goTo(context, '/organizations'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text('For Employers'),
                        ),
                      ],
                    ),
                  ],
                );

                final currentIdea = ideas[ideaIndex];
                final heroVisual = Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: Image.asset(
                        'assets/images/home_page.png',
                        width: double.infinity,
                        height: desktop ? 490 : 340,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: desktop ? 20 : 14,
                      top: desktop ? 22 : 16,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 550),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          final slide = Tween<Offset>(
                            begin: const Offset(0.08, 0.12),
                            end: Offset.zero,
                          ).animate(animation);
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(position: slide, child: child),
                          );
                        },
                        child: Container(
                          key: ValueKey(ideaIndex),
                          width: desktop ? 255 : 220,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white.withOpacity(0.75)),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.deepBlue.withOpacity(0.16),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.iceBlue,
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: Icon(currentIdea.$1, color: AppColors.blue, size: 19),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      currentIdea.$2,
                                      style: const TextStyle(
                                        color: AppColors.dark,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      currentIdea.$3,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 10.5,
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );

                if (desktop) {
                  return Row(
                    children: [
                      Expanded(flex: 9, child: copy),
                      const SizedBox(width: 42),
                      Expanded(flex: 11, child: heroVisual),
                    ],
                  );
                }

                return Column(
                  children: [
                    copy,
                    const SizedBox(height: 30),
                    heroVisual,
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// THREE MAIN PATHS
// ============================================================

class HomePathSection extends StatelessWidget {
  const HomePathSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Column(
        children: [
          const CenteredSectionTitle(
            eyebrow: 'START YOUR JOURNEY',
            title: 'Choose how you want to grow.',
            description:
            'Explore MT Alchemy through corporate development, learning or practical resources.',
          ),

          const SizedBox(height: 35),

          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              PathCard(
                icon: Icons.groups_rounded,
                title: 'Work With Us',
                description:
                'Training and development solutions for organizations and teams.',
                button: 'Explore Services',
                onPressed: () => goTo(
                  context,
                  '/services',
                ),
              ),
              PathCard(
                icon: Icons.school_rounded,
                title: 'Upskill With Us',
                description:
                'Learn emotional intelligence, leadership and communication skills.',
                button: 'Learning Hub',
                onPressed: () => goTo(
                  context,
                  '/learning',
                ),
              ),
              PathCard(
                icon: Icons.shopping_bag_rounded,
                title: 'Shop',
                description:
                'Explore practical learning resources, workbooks and development tools.',
                button: 'Visit Store',
                onPressed: () => goTo(
                  context,
                  '/store',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PathCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String button;
  final VoidCallback onPressed;

  const PathCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.button,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(27),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              title,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                color: Colors.black54,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onPressed,
              child: Text(
                '$button →',
                style: const TextStyle(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// IMPACT
// ============================================================

class ImpactStrip extends StatelessWidget {
  const ImpactStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            eyebrow: 'OUR IMPACT',
            title: 'Human development that moves from people to culture.',
            description:
            'MT Alchemy has positively impacted more than 1,100 participants across education, corporate teams, youth, NGOs and community programmes.',
          ),
          const SizedBox(height: 34),
          LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth > 980;
              final cardWidth = desktop ? 235.0 : constraints.maxWidth < 620 ? constraints.maxWidth : 260.0;
              final featureWidth = desktop ? 350.0 : constraints.maxWidth < 620 ? constraints.maxWidth : 330.0;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  ImpactEditorialCard(
                    width: featureWidth,
                    height: 210,
                    background: AppColors.blue,
                    foreground: Colors.white,
                    accent: AppColors.yellow,
                    icon: Icons.diversity_3_rounded,
                    value: '1,100+',
                    label: 'Participants impacted',
                    note: 'Across learning, leadership, mindfulness and team development programmes.',
                    featured: true,
                  ),
                  ImpactEditorialCard(
                    width: cardWidth,
                    height: 210,
                    background: AppColors.iceBlue,
                    foreground: AppColors.deepBlue,
                    accent: AppColors.blue,
                    icon: Icons.person_rounded,
                    value: 'People',
                    label: 'Human-centered development',
                    note: 'Self-awareness and emotional intelligence first.',
                  ),
                  ImpactEditorialCard(
                    width: cardWidth,
                    height: 210,
                    background: AppColors.yellow,
                    foreground: AppColors.dark,
                    accent: AppColors.blue,
                    icon: Icons.groups_rounded,
                    value: 'Teams',
                    label: 'Connection & resilience',
                    note: 'Better communication, trust and collaboration.',
                  ),
                  ImpactEditorialCard(
                    width: cardWidth,
                    height: 210,
                    background: AppColors.dark,
                    foreground: Colors.white,
                    accent: AppColors.yellow,
                    icon: Icons.trending_up_rounded,
                    value: 'Growth',
                    label: 'Sustainable workplace impact',
                    note: 'Stronger leaders and healthier cultures.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ImpactEditorialCard extends StatelessWidget {
  final double width;
  final double height;
  final Color background;
  final Color foreground;
  final Color accent;
  final IconData icon;
  final String value;
  final String label;
  final String note;
  final bool featured;

  const ImpactEditorialCard({
    super.key,
    required this.width,
    required this.height,
    required this.background,
    required this.foreground,
    required this.accent,
    required this.icon,
    required this.value,
    required this.label,
    required this.note,
    this.featured = false,
  });

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(26),
          border: background == Colors.white
              ? Border.all(color: const Color(0xFFE7E7E7))
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(background == AppColors.yellow ? 0.12 : 0.18),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(icon, color: accent, size: 20),
                ),
                if (featured)
                  Text(
                    'MT ALCHEMY',
                    style: TextStyle(
                      color: foreground.withOpacity(0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                color: foreground,
                fontSize: featured ? 38 : 29,
                height: 1,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.2,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              label,
              style: TextStyle(
                color: foreground,
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              note,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foreground.withOpacity(0.66),
                fontSize: 11,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HOME SERVICES
// ============================================================

class HomeServicesSection extends StatelessWidget {
  const HomeServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final services = getServices();

    return SectionWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            eyebrow: 'WHAT WE DO',
            title: 'Human skills that create stronger workplaces.',
            description:
            'MT Alchemy develops emotional intelligence, leadership, communication, team effectiveness and workplace well-being.',
          ),

          const SizedBox(height: 38),

          LayoutBuilder(
            builder: (context, constraints) {
              int count = 3;

              if (constraints.maxWidth < 720) {
                count = 1;
              } else if (constraints.maxWidth < 1050) {
                count = 2;
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: count,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: count == 1 ? 1.15 : 0.88,
                ),
                itemBuilder: (_, index) {
                  final service = services[index];

                  return ServiceCard(
                    service: service,
                  );
                },
              );
            },
          ),

          const SizedBox(height: 24),

          TextButton(
            onPressed: () => goTo(
              context,
              '/services',
            ),
            child: const Text(
              'Explore all services →',
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ABOUT PREVIEW
// ============================================================

class HomeAboutSection extends StatelessWidget {
  const HomeAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: AppColors.deepBlue,
          borderRadius: BorderRadius.circular(34),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final desktop = constraints.maxWidth > 850;

            final image = ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                'assets/images/about.png',
                height: 430,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );

            final content = Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'ABOUT MT ALCHEMY',
                    style: TextStyle(
                      color: AppColors.yellow,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Growth begins with people.',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 39,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'MT Alchemy is a people-development consultancy helping individuals, '
                        'teams and organizations strengthen emotional intelligence, leadership, '
                        'team effectiveness and workplace well-being.',
                    style: TextStyle(
                      color: Colors.white70,
                      height: 1.7,
                      fontSize: 15.5,
                    ),
                  ),
                  const SizedBox(height: 26),
                  ElevatedButton(
                    onPressed: () => goTo(
                      context,
                      '/about',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      foregroundColor: AppColors.dark,
                    ),
                    child: const Text(
                      'Discover Our Story',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            );

            if (desktop) {
              return Row(
                children: [
                  Expanded(child: image),
                  const SizedBox(width: 20),
                  Expanded(child: content),
                ],
              );
            }

            return Column(
              children: [
                image,
                content,
              ],
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// APPROACH PREVIEW
// ============================================================

class HomeApproachSection extends StatelessWidget {
  const HomeApproachSection({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = [
      'Self-Awareness',
      'Emotional Intelligence',
      'Effective Communication',
      'Authentic Leadership',
      'Resilient Culture',
    ];

    return SectionWrapper(
      child: Column(
        children: [
          const CenteredSectionTitle(
            eyebrow: 'THE MT ALCHEMY APPROACH',
            title: 'Transformation from the inside out.',
            description:
            'Lasting development begins with the individual and expands into stronger teams and healthier organizational cultures.',
          ),

          const SizedBox(height: 38),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 12,
            children: List.generate(
              steps.length,
                  (index) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 195,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 23,
                      ),
                      decoration: BoxDecoration(
                        color: index == 1
                            ? AppColors.yellow
                            : index == 3
                            ? AppColors.blue
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${index + 1}\n${steps[index]}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: index == 3
                              ? Colors.white
                              : AppColors.dark,
                          height: 1.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (index != steps.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.blue,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// LEARNING PREVIEW
// ============================================================

class LearningPreviewSection extends StatelessWidget {
  const LearningPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = getCourses();

    return SectionWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            eyebrow: 'UPSKILL WITH US',
            title: 'Learn. Apply. Grow.',
            description:
            'Flexible learning experiences built around practical human skills and real-world application.',
          ),

          const SizedBox(height: 36),

          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: courses
                .map(
                  (course) => CourseCard(
                course: course,
              ),
            )
                .toList(),
          ),

          const SizedBox(height: 20),

          TextButton(
            onPressed: () => goTo(
              context,
              '/learning',
            ),
            child: const Text(
              'View Learning Hub →',
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CORPORATE CTA
// ============================================================

class CorporateSection extends StatelessWidget {
  const CorporateSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 45,
          vertical: 65,
        ),
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(34),
        ),
        child: Column(
          children: [
            const Text(
              'FOR ORGANIZATIONS',
              style: TextStyle(
                color: AppColors.yellow,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Develop your people.\nStrengthen your organization.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w800,
                height: 1.08,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Support leadership, communication, team effectiveness '
                  'and workplace well-being through customized development programmes.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () => goTo(
                context,
                '/organizations',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: AppColors.dark,
              ),
              child: const Text(
                'For Organizations',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// IMPACT STORY
// ============================================================

class ImpactStorySection extends StatelessWidget {
  const ImpactStorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            eyebrow: 'IMPACT STORIES',
            title: 'Learning that creates real connections.',
            description:
            'MT Alchemy programmes use experiential learning, reflection and practical application to support lasting behavioural change.',
          ),

          const SizedBox(height: 32),

          HoverLift(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final desktop = constraints.maxWidth > 760;

                  final image = ClipRRect(
                    borderRadius: BorderRadius.circular(23),
                    child: Image.asset(
                      'assets/images/event.jpg',
                      height: 360,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  );

                  final content = const Padding(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'EXPERIENTIAL LEARNING',
                          style: TextStyle(
                            color: AppColors.blue,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          'People learn better when they experience, reflect and apply.',
                          style: TextStyle(
                            fontSize: 26,
                            height: 1.2,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Workshops combine practical activities, communication, '
                              'reflection and human connection to create meaningful development.',
                          style: TextStyle(
                            color: Colors.black54,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  );

                  if (desktop) {
                    return Row(
                      children: [
                        Expanded(child: image),
                        const SizedBox(width: 15),
                        Expanded(child: content),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      image,
                      content,
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HOME - LEARNING SNAPSHOT
// ============================================================

class HomeLearningSnapshotSection extends StatelessWidget {
  const HomeLearningSnapshotSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Container(
        padding: const EdgeInsets.all(34),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4FF),
          borderRadius: BorderRadius.circular(34),
          border: Border.all(color: AppColors.blue.withOpacity(0.1)),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final desktop = constraints.maxWidth > 850;
            final intro = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YOUR LEARNING SPACE',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Pick up where you left off.',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.dark,
                    fontSize: 35,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'This prototype opens as a demo learner account, so you can immediately see learning progress, modules, quiz results and certificates.',
                  style: TextStyle(color: Colors.black54, height: 1.65),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => goTo(context, '/dashboard'),
                  icon: const Icon(Icons.dashboard_rounded),
                  label: const Text('Open My Learning'),
                ),
              ],
            );

            final progress = Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(27),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          'assets/images/course_eq.jpg',
                          width: 92,
                          height: 82,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Emotional Intelligence Fundamentals',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Module 3 of 5 • In progress',
                              style: TextStyle(color: Colors.black45, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Course progress', style: TextStyle(fontWeight: FontWeight.w700)),
                      Text('65%', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const LinearProgressIndicator(
                    value: 0.65,
                    minHeight: 10,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  const SizedBox(height: 18),
                  const Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SnapshotChip(icon: Icons.check_circle_rounded, text: '2 modules completed'),
                      SnapshotChip(icon: Icons.schedule_rounded, text: '7 learning hours'),
                      SnapshotChip(icon: Icons.emoji_events_rounded, text: '1 certificate'),
                    ],
                  ),
                ],
              ),
            );

            if (desktop) {
              return Row(
                children: [
                  Expanded(child: intro),
                  const SizedBox(width: 35),
                  Expanded(child: progress),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [intro, const SizedBox(height: 28), progress],
            );
          },
        ),
      ),
    );
  }
}

class SnapshotChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const SnapshotChip({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.softGray,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.blue),
          const SizedBox(width: 7),
          Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ============================================================
// HOME - TESTIMONIALS
// ============================================================

class HomeTestimonialsSection extends StatefulWidget {
  const HomeTestimonialsSection({super.key});

  @override
  State<HomeTestimonialsSection> createState() => _HomeTestimonialsSectionState();
}

class _HomeTestimonialsSectionState extends State<HomeTestimonialsSection> {
  final ScrollController controller = ScrollController();

  final List<(String, String)> testimonials = const [
    ('Well organized and engaging throughout the session.', 'Workshop Experience'),
    ('The activities helped me understand the importance of empathic communication.', 'Communication'),
    ('I learned useful ideas about active listening and how I communicate with others.', 'Emotional Intelligence'),
    ('Overall, the session was enjoyable, interactive and well planned.', 'Experiential Learning'),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void scrollCards(double direction) {
    if (!controller.hasClients) return;
    final target = (controller.offset + (direction * 350)).clamp(
      0.0,
      controller.position.maxScrollExtent,
    );
    controller.animateTo(
      target,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth > 760;
              final heading = const SectionTitle(
                eyebrow: 'PARTICIPANT FEEDBACK',
                title: 'What our participants say.',
                description:
                'Genuine feedback themes from MT Alchemy programme materials, presented anonymously because participant names and companies are not verified.',
              );
              final arrows = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TestimonialArrow(
                    icon: Icons.arrow_back_rounded,
                    onPressed: () => scrollCards(-1),
                  ),
                  const SizedBox(width: 10),
                  TestimonialArrow(
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () => scrollCards(1),
                  ),
                ],
              );
              if (desktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: heading),
                    const SizedBox(width: 24),
                    arrows,
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [heading, const SizedBox(height: 20), arrows],
              );
            },
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 330,
            child: ListView.separated(
              controller: controller,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: testimonials.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, itemIndex) {
                final item = testimonials[itemIndex];
                return TestimonialEditorialCard(
                  text: item.$1,
                  tag: item.$2,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TestimonialArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const TestimonialArrow({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: onPressed,
      child: Container(
        width: 46,
        height: 46,
        decoration: const BoxDecoration(
          color: AppColors.dark,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class TestimonialEditorialCard extends StatelessWidget {
  final String text;
  final String tag;

  const TestimonialEditorialCard({
    super.key,
    required this.text,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width < 600 ? 285.0 : 330.0;
    return Container(
      width: width,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F6),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE8EAEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.format_quote_rounded,
                  color: AppColors.blue,
                  size: 25,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFE2E4E8)),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Text(
              '“$text”',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.dark,
                fontSize: 21,
                height: 1.28,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
            ),
          ),
          const Divider(height: 28, color: Color(0xFFD9DCE1)),
          const Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.iceBlue,
                child: Icon(Icons.person_rounded, color: AppColors.blue, size: 18),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Workshop Participant',
                    style: TextStyle(
                      color: AppColors.dark,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'MT Alchemy programme feedback',
                    style: TextStyle(color: Colors.black45, fontSize: 10.5),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeStorePreviewSection extends StatelessWidget {
  const HomeStorePreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            eyebrow: 'SHOP',
            title: 'Resources that continue the learning.',
            description:
            'Preview digital and physical resources for reflection, mindfulness and leadership development.',
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: demoProducts
                .map(
                  (product) => SizedBox(
                width: 350,
                child: ProductCard(product: product),
              ),
            )
                .toList(),
          ),
          const SizedBox(height: 18),
          TextButton(
            onPressed: () => goTo(context, '/store'),
            child: const Text(
              'Visit the Store →',
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FinalContactCTA extends StatelessWidget {
  const FinalContactCTA({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 55),
        decoration: BoxDecoration(
          color: AppColors.yellow,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Wrap(
          spacing: 30,
          runSpacing: 20,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 700,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LET’S BUILD A THRIVING WORKPLACE TOGETHER',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Start with a conversation about your people, teams or learning goals.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 30,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => goTo(context, '/contact'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dark,
                foregroundColor: Colors.white,
              ),
              child: const Text('Contact MT Alchemy'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ABOUT PAGE
// ============================================================

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),

      body: SingleChildScrollView(
        child: Column(
          children: const [
            FadeSlideIn(
              child: PageHero(
                eyebrow: 'ABOUT MT ALCHEMY',
                title:
                'Building emotionally intelligent leaders and resilient workplace cultures.',
                description:
                'Human-centered development for individuals, teams and organizations.',
                image: 'assets/images/about.png',
              ),
            ),

            FadeSlideIn(
              child: WhoWeAreSection(),
            ),

            FadeSlideIn(
              child: VisionMissionSection(),
            ),

            FadeSlideIn(
              child: FullApproachSection(),
            ),

            FadeSlideIn(
              child: WhyEQSection(),
            ),

            FadeSlideIn(
              child: WhyClientsChooseSection(),
            ),

            FadeSlideIn(
              child: TransformationStatement(),
            ),

            FadeSlideIn(
              child: FullImpactSection(),
            ),

            FadeSlideIn(
              child: FounderSection(),
            ),

            FadeSlideIn(
              child: TeamSection(),
            ),

            SiteFooter(),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// WHO WE ARE
// ============================================================

class WhoWeAreSection extends StatelessWidget {
  const WhoWeAreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            eyebrow: 'WHO WE ARE',
            title: 'When people grow, teams flourish.',
            description:
            'MT Alchemy is a people-development consultancy that helps individuals, teams and organizations thrive by strengthening emotional intelligence, leadership capability, team effectiveness and workplace well-being.',
          ),

          const SizedBox(height: 36),

          Wrap(
            spacing: 18,
            runSpacing: 18,
            children: const [
              MiniValueCard(
                icon: Icons.self_improvement_rounded,
                title: 'Self-Awareness',
              ),
              MiniValueCard(
                icon: Icons.handshake_rounded,
                title: 'Collaborative Relationships',
              ),
              MiniValueCard(
                icon: Icons.groups_rounded,
                title: 'Resilient Teams',
              ),
              MiniValueCard(
                icon: Icons.trending_up_rounded,
                title: 'Sustainable Success',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MiniValueCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const MiniValueCard({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        width: 265,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// VISION MISSION
// ============================================================

class VisionMissionSection extends StatelessWidget {
  const VisionMissionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Wrap(
        spacing: 22,
        runSpacing: 22,
        children: const [
          VisionMissionCard(
            label: 'OUR VISION',
            title:
            'Build emotional intelligence and resilient cultures.',
            description:
            'To help individuals and organizations build emotional intelligence and resilient cultures through experiential learning, creating fulfilling and sustainable work environments in today’s technology-driven world.',
            background: AppColors.yellow,
            textColor: AppColors.dark,
          ),

          VisionMissionCard(
            label: 'OUR MISSION',
            title:
            'Develop authentic leaders with emotional strength.',
            description:
            'To develop authentic leaders with emotional strength who can navigate personal and professional relationships with clarity and confidence in today’s technology-driven world.',
            background: AppColors.deepBlue,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class VisionMissionCard extends StatelessWidget {
  final String label;
  final String title;
  final String description;
  final Color background;
  final Color textColor;

  const VisionMissionCard({
    super.key,
    required this.label,
    required this.title,
    required this.description,
    required this.background,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        width: 550,
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: textColor.withOpacity(0.75),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 27,
                height: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              description,
              style: TextStyle(
                color: textColor.withOpacity(0.82),
                height: 1.65,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// FULL APPROACH
// ============================================================

class FullApproachSection extends StatelessWidget {
  const FullApproachSection({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      (
      '01',
      'Self-Awareness',
      'Understanding thoughts, emotions, behaviours and personal patterns.'
      ),
      (
      '02',
      'Emotional Intelligence',
      'Managing emotions and responding to others with greater awareness and empathy.'
      ),
      (
      '03',
      'Effective Communication',
      'Expressing ideas clearly, listening actively and building meaningful relationships.'
      ),
      (
      '04',
      'Authentic Leadership',
      'Leading with confidence, empathy, clarity and emotional strength.'
      ),
      (
      '05',
      'Resilient Culture',
      'Building healthy, collaborative and sustainable high-performance environments.'
      ),
    ];

    return SectionWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            eyebrow: 'OUR APPROACH',
            title: 'Transformation from the inside out.',
            description:
            'MT Alchemy creates lasting behavioural change through experiential learning, practical tools and application.',
          ),

          const SizedBox(height: 36),

          ...items.map(
                (item) => Container(
              margin: const EdgeInsets.only(
                bottom: 12,
              ),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      item.$1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.$2,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.$3,
                          style: const TextStyle(
                            color: Colors.black54,
                            height: 1.55,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WHY EQ
// ============================================================

class WhyEQSection extends StatelessWidget {
  const WhyEQSection({super.key});

  @override
  Widget build(BuildContext context) {
    const challenges = [
      'Employee burnout',
      'Rising stress',
      'Communication breakdowns',
      'Team conflicts',
      'Leadership gaps',
      'Low employee engagement',
      'High turnover',
    ];

    return SectionWrapper(
      child: Container(
        padding: const EdgeInsets.all(38),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final desktop = constraints.maxWidth > 800;

            final left = const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WHY EMOTIONAL INTELLIGENCE MATTERS',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  'Technical skills are not enough.',
                  style: TextStyle(
                    fontSize: 34,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  'Many workplace challenges are influenced by emotional and interpersonal factors rather than technical capability alone.',
                  style: TextStyle(
                    color: Colors.black54,
                    height: 1.65,
                  ),
                ),
              ],
            );

            final right = Wrap(
              spacing: 10,
              runSpacing: 10,
              children: challenges
                  .map(
                    (challenge) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.softGray,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    challenge,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
                  .toList(),
            );

            if (desktop) {
              return Row(
                children: [
                  Expanded(child: left),
                  const SizedBox(width: 45),
                  Expanded(child: right),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                left,
                const SizedBox(height: 30),
                right,
              ],
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// WHY CLIENTS CHOOSE MT ALCHEMY
// ============================================================

class WhyClientsChooseSection extends StatelessWidget {
  const WhyClientsChooseSection({super.key});

  @override
  Widget build(BuildContext context) {
    const benefits = [
      ('Open communication', Icons.forum_rounded),
      ('Resilient leadership', Icons.psychology_alt_rounded),
      ('Higher engagement', Icons.favorite_rounded),
      ('Improved collaboration', Icons.groups_rounded),
      ('Workplace well-being', Icons.spa_rounded),
      ('Sustainable performance', Icons.trending_up_rounded),
    ];

    return SectionWrapper(
      child: Container(
        padding: const EdgeInsets.all(38),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4FF),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              eyebrow: 'WHY MT ALCHEMY',
              title: 'Development designed around people, not just content.',
              description:
              'MT Alchemy uses human-centered, experiential learning to help teams build healthier communication, stronger leadership and more resilient workplace cultures.',
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: benefits
                  .map(
                    (benefit) => Container(
                  width: 335,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.yellow,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(benefit.$2, color: AppColors.dark),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          benefit.$1,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// TRANSFORMATION STATEMENT
// ============================================================

class TransformationStatement extends StatelessWidget {
  const TransformationStatement({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 45,
          vertical: 70,
        ),
        decoration: BoxDecoration(
          color: AppColors.dark,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          children: [
            Text(
              '“We don’t just run activities.\nWe shift mindsets, behaviours, and team culture.”',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 34,
                height: 1.25,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Experiential learning • Emotional intelligence • Practical application',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.yellow,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// FULL IMPACT
// ============================================================

class FullImpactSection extends StatelessWidget {
  const FullImpactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Column(
        children: [
          Text(
            '1,100+',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.blue,
              fontSize: 76,
              fontWeight: FontWeight.w900,
              letterSpacing: -3,
            ),
          ),
          const Text(
            'participants impacted',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 30),

          const Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ImpactChip(
                text: 'Educational Institutions',
              ),
              ImpactChip(
                text: 'Corporate Teams',
              ),
              ImpactChip(
                text: 'Youth Leadership Programmes',
              ),
              ImpactChip(
                text: 'NGOs & Community Groups',
              ),
              ImpactChip(
                text: 'Educators & Social Services',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ImpactChip extends StatelessWidget {
  final String text;

  const ImpactChip({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 19,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ============================================================
// FOUNDER
// ============================================================

class FounderSection extends StatelessWidget {
  const FounderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Container(
        padding: const EdgeInsets.all(34),
        decoration: BoxDecoration(
          color: AppColors.deepBlue,
          borderRadius: BorderRadius.circular(32),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final desktop = constraints.maxWidth > 800;

            final portrait = Container(
              height: 360,
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.deepBlue,
                      size: 82,
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Founder Photo',
                      style: TextStyle(
                        color: AppColors.deepBlue,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Placeholder — replace when official photo is available',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.deepBlue,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            );

            final content = const Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OUR FOUNDER',
                    style: TextStyle(
                      color: AppColors.yellow,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Mabel Tan KH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 33,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Founder | EQ Coach | HRDC Certified Trainer',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 22),
                  Text(
                    'Mabel believes that lasting organizational transformation happens when people and systems are understood and developed together.',
                    style: TextStyle(
                      color: Colors.white70,
                      height: 1.7,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Through experiential learning and practical application, she supports greater self-awareness, emotional intelligence, resilience and authentic leadership.',
                    style: TextStyle(
                      color: Colors.white70,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            );

            if (desktop) {
              return Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: portrait,
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    flex: 6,
                    child: content,
                  ),
                ],
              );
            }

            return Column(
              children: [
                portrait,
                content,
              ],
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// TEAM
// ============================================================

class TeamSection extends StatelessWidget {
  const TeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Column(
        children: [
          const CenteredSectionTitle(
            eyebrow: 'OUR TEAM',
            title: 'People behind the development.',
            description:
            'A team combining people development, coaching, operations and organizational experience.',
          ),

          const SizedBox(height: 35),

          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: const [
              TeamCard(
                initials: 'MT',
                name: 'Mabel Tan KH',
                role: 'Founder • EQ Coach • HRDC Certified Trainer',
              ),
              TeamCard(
                initials: 'EN',
                name: 'Esther Ng',
                role: 'Consultant & Operation Advisor',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  final String initials;
  final String name;
  final String role;

  const TeamCard({
    super.key,
    required this.initials,
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4FF),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.blue.withOpacity(0.15)),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline_rounded, color: AppColors.blue, size: 26),
                  SizedBox(height: 3),
                  Text(
                    'Photo',
                    style: TextStyle(
                      color: AppColors.blue,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    role,
                    style: const TextStyle(
                      color: Colors.black54,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SERVICES DATA
// ============================================================

class ServiceData {
  final String title;
  final String shortDescription;
  final String details;
  final String audience;
  final String objective;
  final String image;

  const ServiceData({
    required this.title,
    required this.shortDescription,
    required this.details,
    required this.audience,
    required this.objective,
    required this.image,
  });
}

List<ServiceData> getServices() {
  return const [
    ServiceData(
      title: 'Emotional Intelligence & Mindfulness',
      shortDescription:
      'Move from reactive stress toward greater awareness, focus and emotional balance.',
      details:
      'Experiential learning designed to strengthen emotional awareness, mindfulness and healthier responses to workplace pressure.',
      audience:
      'Individuals, teams and organizations seeking greater emotional awareness and workplace well-being.',
      objective:
      'Strengthen self-awareness, emotional regulation, empathy and mindful decision-making.',
      image: 'assets/images/communication.jpg',
    ),
    ServiceData(
      title: 'Leadership & Communication',
      shortDescription:
      'Develop empathetic leaders who communicate with clarity and confidence.',
      details:
      'Leadership and communication programmes support authentic leadership, empathy and stronger interpersonal relationships.',
      audience:
      'Emerging leaders, managers, supervisors and teams.',
      objective:
      'Improve communication, leadership confidence, empathy and team influence.',
      image: 'assets/images/leadership.jpg',
    ),
    ServiceData(
      title: 'Organization Well-being Assessment',
      shortDescription:
      'Support healthier cultures with higher engagement and reduced burnout.',
      details:
      'A people-centered approach to understanding workplace well-being and identifying opportunities for healthier organizational culture.',
      audience:
      'Organizations looking to understand employee experience, stress and engagement.',
      objective:
      'Identify well-being priorities and support stronger, healthier workplace cultures.',
      image: 'assets/images/wellbeing.jpg',
    ),
    ServiceData(
      title: 'Team Building & Team Effectiveness',
      shortDescription:
      'Build trust, social connection and collective resilience.',
      details:
      'Interactive team experiences designed to strengthen collaboration, trust, communication and team connection.',
      audience:
      'Corporate teams, project teams, youth groups and organizations.',
      objective:
      'Strengthen teamwork, mutual trust, problem-solving and collaboration.',
      image: 'assets/images/teamwork.jpg',
    ),
    ServiceData(
      title: 'CSR & ESG',
      shortDescription:
      'Connect people with meaningful community engagement aligned with organizational values.',
      details:
      'Programmes connect organizations and communities through meaningful engagement initiatives.',
      audience:
      'Organizations planning community, social responsibility and engagement initiatives.',
      objective:
      'Create meaningful community engagement that supports organizational values.',
      image: 'assets/images/event.jpg',
    ),
    ServiceData(
      title: 'Customized Programmes',
      shortDescription:
      'Learning experiences adapted to different teams, needs and workforce demographics.',
      details:
      'Customized programmes can be adapted according to organizational challenges, team demographics and learning goals.',
      audience:
      'Organizations requiring tailored development programmes.',
      objective:
      'Design relevant learning experiences around specific organizational needs.',
      image: 'assets/images/creative_activity.jpg',
    ),
  ];
}

// ============================================================
// SERVICES PAGE
// ============================================================

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final services = getServices();

    return Scaffold(
      appBar: const SiteHeader(),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const FadeSlideIn(
              child: SimplePageHero(
                eyebrow: 'SERVICES',
                title: 'Human development that creates lasting change.',
                description:
                'Explore programmes in emotional intelligence, leadership, team effectiveness, workplace well-being and customized learning.',
              ),
            ),

            SectionWrapper(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int count = 3;

                  if (constraints.maxWidth < 720) {
                    count = 1;
                  } else if (constraints.maxWidth < 1050) {
                    count = 2;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    itemCount: services.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: count,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio:
                      count == 1 ? 1.15 : 0.88,
                    ),
                    itemBuilder: (_, index) {
                      return ServiceCard(
                        service: services[index],
                      );
                    },
                  );
                },
              ),
            ),

            const SectionWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                    eyebrow: 'CHOOSE YOUR PATH',
                    title: 'Corporate development or individual support.',
                    description:
                    'The broader MT Alchemy platform also includes individual coaching and organization-focused programme journeys.',
                  ),
                  SizedBox(height: 28),
                  Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: [
                      ServicePathCard(
                        icon: Icons.business_center_rounded,
                        title: 'For Organizations',
                        text: 'Explore organizational challenges, corporate solutions and customized programme pathways.',
                        route: '/organizations',
                      ),
                      ServicePathCard(
                        icon: Icons.support_agent_rounded,
                        title: 'Individual Coaching',
                        text: 'Explore one-to-one coaching focus areas for career, relationships and personal development.',
                        route: '/coaching',
                      ),
                      ServicePathCard(
                        icon: Icons.view_agenda_rounded,
                        title: 'Corporate Programmes',
                        text: 'Preview programme cards with audience, objectives, format and request-a-quote actions.',
                        route: '/corporate-programmes',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SectionWrapper(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(45),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Not sure which programme fits your organization?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () => goTo(
                        context,
                        '/contact',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dark,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Get a Free Consultation',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

class ServicePathCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final String route;

  const ServicePathCard({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        width: 355,
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.blue),
            ),
            const SizedBox(height: 17),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 9),
            Text(
              text,
              style: const TextStyle(color: Colors.black54, height: 1.55),
            ),
            const SizedBox(height: 14),
            TextButton(
              onPressed: () => goTo(context, route),
              child: const Text('Explore →'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SERVICE CARD
// ============================================================

class ServiceCard extends StatelessWidget {
  final ServiceData service;

  const ServiceCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  service.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 17),
            Text(
              service.title,
              style: const TextStyle(
                fontSize: 18,
                height: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              service.shortDescription,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black54,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration:
                    const Duration(milliseconds: 320),
                    pageBuilder: (_, animation, __) =>
                        ServiceDetailPage(
                          service: service,
                        ),
                    transitionsBuilder:
                        (_, animation, __, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: const Text(
                'Learn more →',
                style: TextStyle(
                  color: AppColors.blue,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SERVICE DETAIL
// ============================================================

class ServiceDetailPage extends StatelessWidget {
  final ServiceData service;

  const ServiceDetailPage({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SectionWrapper(
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final desktop =
                        constraints.maxWidth > 800;

                    final image = ClipRRect(
                      borderRadius:
                      BorderRadius.circular(24),
                      child: Image.asset(
                        service.image,
                        height: 400,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    );

                    final copy = Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'MT ALCHEMY SERVICE',
                            style: TextStyle(
                              color: AppColors.yellow,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            service.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            service.details,
                            style: const TextStyle(
                              color: Colors.white70,
                              height: 1.7,
                            ),
                          ),
                        ],
                      ),
                    );

                    if (desktop) {
                      return Row(
                        children: [
                          Expanded(child: image),
                          const SizedBox(width: 20),
                          Expanded(child: copy),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        image,
                        copy,
                      ],
                    );
                  },
                ),
              ),
            ),

            SectionWrapper(
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  InfoBox(
                    title: 'Who It’s For',
                    text: service.audience,
                  ),
                  InfoBox(
                    title: 'Key Objective',
                    text: service.objective,
                  ),
                ],
              ),
            ),

            SectionWrapper(
              child: Center(
                child: ElevatedButton(
                  onPressed: () => goTo(
                    context,
                    '/contact',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.dark,
                  ),
                  child: const Text(
                    'Enquire About This Programme',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),

            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// COURSES
// ============================================================

class CourseData {
  final String title;
  final String category;
  final String description;
  final String image;
  final String modules;
  final String level;
  final String duration;
  final String price;
  final String about;
  final String audience;
  final List<String> learningObjectives;
  final List<String> curriculum;
  final List<String> outcomes;
  final List<String> reviews;

  const CourseData({
    required this.title,
    required this.category,
    required this.description,
    required this.image,
    required this.modules,
    required this.level,
    required this.duration,
    required this.price,
    required this.about,
    required this.audience,
    required this.learningObjectives,
    required this.curriculum,
    required this.outcomes,
    required this.reviews,
  });
}

List<CourseData> getCourses() {
  return const [
    CourseData(
      title: 'Emotional Intelligence Fundamentals',
      category: 'Emotional Intelligence',
      description:
      'Build self-awareness, emotional regulation and empathy through practical learning.',
      image: 'assets/images/course_eq.jpg',
      modules: '5 Modules',
      level: 'Beginner',
      duration: '4 Weeks',
      price: 'Demo price • RM99',
      about:
      'This introductory course explores how emotions influence behaviour, communication and decision-making. Learners develop practical ways to notice emotional patterns, regulate reactions and respond to other people with greater awareness and empathy. The prototype curriculum combines short learning content, reflection activities and simple workplace examples.',
      audience:
      'Professionals, university learners, emerging leaders and anyone interested in strengthening self-awareness, communication and interpersonal relationships.',
      learningObjectives: [
        'Recognize emotional triggers and personal response patterns.',
        'Use practical strategies for emotional regulation.',
        'Strengthen empathy and perspective-taking.',
        'Communicate more intentionally in difficult situations.',
      ],
      curriculum: [
        'Module 1 — Understanding Emotional Intelligence',
        'Module 2 — Self-Awareness & Emotional Patterns',
        'Module 3 — Emotional Regulation in Practice',
        'Module 4 — Empathy & Effective Communication',
        'Module 5 — Applying EQ at Work and in Daily Life',
      ],
      outcomes: [
        'Greater awareness of emotions and behaviour',
        'More thoughtful responses under pressure',
        'Stronger listening and communication habits',
        'A practical personal EQ development plan',
      ],
      reviews: [
        'The activities helped me understand the importance of empathic communication.',
        'I learned useful ideas about active listening and how I communicate with others.',
        'Overall, the session was enjoyable, interactive and well planned.',
      ],
    ),
    CourseData(
      title: 'Leadership & Communication',
      category: 'Leadership',
      description:
      'Develop clearer communication and more authentic leadership practices.',
      image: 'assets/images/course_leadership.jpg',
      modules: '6 Modules',
      level: 'Intermediate',
      duration: '5 Weeks',
      price: 'Demo price • RM129',
      about:
      'Leadership is not only about giving direction. This course focuses on how leaders build trust, communicate expectations, listen to people and navigate challenging conversations. Learners explore authentic leadership, feedback, empathy and practical communication habits that support stronger teams.',
      audience:
      'Emerging leaders, supervisors, managers, team leads and professionals preparing for greater leadership responsibility.',
      learningObjectives: [
        'Communicate goals and expectations with greater clarity.',
        'Build trust through consistent and authentic leadership behaviour.',
        'Use active listening and constructive feedback.',
        'Handle disagreement and difficult conversations more effectively.',
      ],
      curriculum: [
        'Module 1 — Authentic Leadership Foundations',
        'Module 2 — Leadership Self-Awareness',
        'Module 3 — Communication with Clarity',
        'Module 4 — Listening, Feedback & Trust',
        'Module 5 — Conflict and Difficult Conversations',
        'Module 6 — Leading Teams Through Change',
      ],
      outcomes: [
        'Clearer leadership communication',
        'Greater confidence in people conversations',
        'More consistent feedback practices',
        'Improved team trust and collaboration',
      ],
      reviews: [
        'The session was well organized and easy to follow.',
        'The interaction helped me reflect on how I communicate as a leader.',
        'The activities were practical and created useful discussion with the group.',
      ],
    ),
    CourseData(
      title: 'Mindfulness at Work',
      category: 'Workplace Well-being',
      description:
      'Explore practical mindfulness, reflection and healthier responses to stress.',
      image: 'assets/images/course_mindfulness.jpg',
      modules: '4 Modules',
      level: 'Beginner',
      duration: '3 Weeks',
      price: 'Demo price • RM89',
      about:
      'This course introduces simple mindfulness practices that can support attention, reflection and healthier responses to daily workplace pressure. It is designed as a practical learning experience rather than a clinical programme, with short exercises learners can integrate into normal routines.',
      audience:
      'Individuals and teams looking for practical ways to improve awareness, focus, reflection and workplace well-being.',
      learningObjectives: [
        'Understand the relationship between attention, stress and behaviour.',
        'Practice short mindfulness and grounding techniques.',
        'Notice unhelpful patterns before reacting automatically.',
        'Build simple habits that support sustainable well-being.',
      ],
      curriculum: [
        'Module 1 — Mindfulness & Everyday Awareness',
        'Module 2 — Understanding Stress Responses',
        'Module 3 — Focus, Reflection & Emotional Balance',
        'Module 4 — Building Sustainable Workplace Habits',
      ],
      outcomes: [
        'Better awareness of stress patterns',
        'Practical techniques for focus and reflection',
        'Healthier pause-and-respond habits',
        'A personal workplace well-being routine',
      ],
      reviews: [
        'The session was engaging and gave me practical ideas I can use immediately.',
        'I enjoyed the interaction and reflection activities.',
        'Overall, the programme was good and well planned.',
      ],
    ),
  ];
}

// ============================================================
// LEARNING PAGE
// ============================================================

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = getCourses();

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const PageHero(
              eyebrow: 'LEARNING HUB',
              title: 'Learn. Apply. Grow.',
              description:
              'Explore practical learning in emotional intelligence, mindfulness, leadership, communication, team effectiveness, workplace well-being and personal development.',
              image: 'assets/images/learning.jpg',
            ),
            SectionWrapper(
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.dark,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final desktop = constraints.maxWidth > 760;
                    final copy = const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FIND YOUR LEARNING PATH',
                          style: TextStyle(
                            color: AppColors.yellow,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Not sure which course fits your goals?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Take a short prototype quiz and receive a recommended learning path.',
                          style: TextStyle(color: Colors.white70, height: 1.55),
                        ),
                      ],
                    );
                    final button = ElevatedButton.icon(
                      onPressed: () => goTo(context, '/course-finder'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        foregroundColor: AppColors.dark,
                      ),
                      icon: const Icon(Icons.quiz_rounded),
                      label: const Text('Find My Course'),
                    );
                    if (desktop) {
                      return Row(
                        children: [
                          Expanded(child: copy),
                          const SizedBox(width: 30),
                          button,
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [copy, const SizedBox(height: 22), button],
                    );
                  },
                ),
              ),
            ),
            const SectionWrapper(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilterChipLabel('All'),
                  FilterChipLabel('Emotional Intelligence'),
                  FilterChipLabel('Mindfulness'),
                  FilterChipLabel('Leadership'),
                  FilterChipLabel('Communication'),
                  FilterChipLabel('Team Effectiveness'),
                  FilterChipLabel('Workplace Well-being'),
                  FilterChipLabel('Personal Development'),
                  FilterChipLabel('Organizational Development'),
                ],
              ),
            ),
            SectionWrapper(
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: courses.map((course) => CourseCard(course: course)).toList(),
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

class FilterChipLabel extends StatelessWidget {
  final String text;

  const FilterChipLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class CourseCard extends StatelessWidget {
  final CourseData course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        width: 355,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                course.image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              course.category.toUpperCase(),
              style: const TextStyle(
                color: AppColors.blue,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              course.title,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              course.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black54, height: 1.45),
            ),
            const SizedBox(height: 15),
            Text(
              '${course.duration} • ${course.modules} • ${course.level}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              course.price,
              style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 17),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
                  );
                },
                child: const Text('View Course'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// COURSE DETAIL
// ============================================================

class CourseDetailPage extends StatefulWidget {
  final CourseData course;

  const CourseDetailPage({
    super.key,
    required this.course,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  int reviewIndex = 0;

  CourseData get course => widget.course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SectionWrapper(
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(34),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final desktop = constraints.maxWidth > 860;
                    final copy = Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.yellow,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              course.category.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.dark,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Text(
                            course.title,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: desktop ? 45 : 35,
                              height: 1.08,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            course.description,
                            style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.65),
                          ),
                          const SizedBox(height: 24),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              CourseMetaChip(text: course.duration, icon: Icons.schedule_rounded),
                              CourseMetaChip(text: course.modules, icon: Icons.menu_book_rounded),
                              CourseMetaChip(text: course.level, icon: Icons.signal_cellular_alt_rounded),
                              const CourseMetaChip(text: 'Certificate', icon: Icons.workspace_premium_rounded),
                            ],
                          ),
                        ],
                      ),
                    );
                    final enrolCard = Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(21),
                            child: Image.asset(
                              course.image,
                              width: double.infinity,
                              height: 285,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            course.price,
                            style: const TextStyle(
                              color: AppColors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => goTo(context, '/dashboard'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.dark,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Start Demo Course'),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (desktop) {
                      return Row(
                        children: [
                          Expanded(flex: 11, child: copy),
                          const SizedBox(width: 28),
                          Expanded(flex: 9, child: enrolCard),
                        ],
                      );
                    }
                    return Column(children: [copy, const SizedBox(height: 20), enrolCard]);
                  },
                ),
              ),
            ),
            SectionWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(
                    eyebrow: 'COURSE OVERVIEW',
                    title: 'About this course',
                    description:
                    'A fuller course overview helps learners understand what they will study, how the content is structured and whether the learning experience fits their goals.',
                  ),
                  const SizedBox(height: 26),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Text(
                      course.about,
                      style: const TextStyle(fontSize: 16, height: 1.75, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            SectionWrapper(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final desktop = constraints.maxWidth > 800;
                  final learn = CourseListPanel(
                    title: 'What You’ll Learn',
                    icon: Icons.lightbulb_rounded,
                    items: course.learningObjectives,
                  );
                  final audience = Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.groups_rounded, color: AppColors.dark, size: 34),
                        const SizedBox(height: 16),
                        const Text(
                          'Who This Course Is For',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 12),
                        Text(course.audience, style: const TextStyle(height: 1.65)),
                      ],
                    ),
                  );
                  if (desktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: learn),
                        const SizedBox(width: 22),
                        Expanded(child: audience),
                      ],
                    );
                  }
                  return Column(children: [learn, const SizedBox(height: 22), audience]);
                },
              ),
            ),
            SectionWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(
                    eyebrow: 'CURRICULUM',
                    title: 'Course modules',
                    description:
                    'The prototype uses a clear module structure so learners can understand the path from introduction to practical application.',
                  ),
                  const SizedBox(height: 28),
                  ...List.generate(
                    course.curriculum.length,
                        (index) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ExpansionTile(
                        shape: const Border(),
                        collapsedShape: const Border(),
                        leading: CircleAvatar(
                          backgroundColor: index == 0 ? AppColors.yellow : const Color(0xFFF0F2F8),
                          foregroundColor: AppColors.dark,
                          child: Text('${index + 1}'),
                        ),
                        title: Text(
                          course.curriculum[index],
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(index < 2 ? 'Demo lesson available' : 'Prototype module'),
                        childrenPadding: const EdgeInsets.fromLTRB(72, 0, 24, 22),
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Each module can contain video, text, downloadable resources, reflection activities and a short knowledge check.',
                              style: TextStyle(color: Colors.black54, height: 1.55),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () => goTo(context, '/course-player'),
                              child: const Text('Preview lesson →'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SectionWrapper(
              child: CourseListPanel(
                title: 'Expected Learning Outcomes',
                icon: Icons.emoji_events_rounded,
                items: course.outcomes,
              ),
            ),
            SectionWrapper(
              child: Container(
                padding: const EdgeInsets.all(34),
                decoration: BoxDecoration(
                  color: AppColors.dark,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PARTICIPANT FEEDBACK',
                      style: TextStyle(
                        color: AppColors.yellow,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'What learners say',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 31,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star_rounded, color: AppColors.yellow),
                              Icon(Icons.star_rounded, color: AppColors.yellow),
                              Icon(Icons.star_rounded, color: AppColors.yellow),
                              Icon(Icons.star_rounded, color: AppColors.yellow),
                              Icon(Icons.star_rounded, color: AppColors.yellow),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Text(
                            '“${course.reviews[reviewIndex]}”',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 19, height: 1.6, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Workshop Participant',
                            style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    reviewIndex = (reviewIndex - 1 + course.reviews.length) % course.reviews.length;
                                  });
                                },
                                icon: const Icon(Icons.arrow_back_rounded),
                              ),
                              Text('${reviewIndex + 1} / ${course.reviews.length}'),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    reviewIndex = (reviewIndex + 1) % course.reviews.length;
                                  });
                                },
                                icon: const Icon(Icons.arrow_forward_rounded),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Feedback themes are adapted from MT Alchemy participant comments and are not presented as verified reviews of this exact prototype course.',
                      style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

class CourseMetaChip extends StatelessWidget {
  final String text;
  final IconData icon;

  const CourseMetaChip({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 7),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class CourseListPanel extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> items;

  const CourseListPanel({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F0FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.purple),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...items.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Icon(Icons.check_circle_rounded, color: AppColors.blue, size: 19),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item, style: const TextStyle(height: 1.5))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// STORE
// ============================================================

class ProductData {
  final String title;
  final String type;
  final String description;
  final String price;
  final String image;
  final String availability;
  final String about;
  final List<String> features;

  const ProductData({
    required this.title,
    required this.type,
    required this.description,
    required this.price,
    required this.image,
    required this.availability,
    required this.about,
    required this.features,
  });
}

const demoProducts = [
  ProductData(
    title: 'Emotional Clarity Workbook',
    type: 'Digital Product',
    description:
    'A guided reflection workbook for emotional awareness, communication and personal development.',
    price: 'Demo price • RM35',
    image: 'assets/images/product_workbook.jpg',
    availability: 'Prototype digital download',
    about:
    'The Emotional Clarity Workbook is a prototype learning companion designed to help users pause, reflect and connect emotional experiences with everyday behaviour. It can be used alongside a course or independently as a structured reflection resource. The workbook concept includes prompts for identifying triggers, noticing patterns, reframing situations and planning more intentional responses.',
    features: [
      'Guided self-reflection prompts',
      'Emotional pattern check-ins',
      'Communication reflection exercises',
      'Personal action planning pages',
    ],
  ),
  ProductData(
    title: 'Mindfulness Journal',
    type: 'Physical Product',
    description:
    'A practical journal for reflection, mindful check-ins and healthier daily routines.',
    price: 'Demo price • RM45',
    image: 'assets/images/product_journal.jpg',
    availability: 'Prototype physical product',
    about:
    'The Mindfulness Journal is designed as a simple space for short daily reflection. Instead of asking users to write long diary entries, it focuses on practical prompts around attention, stress, gratitude, emotional awareness and intention. It can complement workplace well-being programmes or be used as an individual development tool.',
    features: [
      'Daily mindfulness prompts',
      'Stress and energy check-ins',
      'Weekly reflection pages',
      'Simple habit and intention tracking',
    ],
  ),
  ProductData(
    title: 'Leadership Reflection Cards',
    type: 'Physical Product',
    description:
    'Conversation and reflection cards for leadership learning, coaching and team discussion.',
    price: 'Demo price • RM55',
    image: 'assets/images/product_cards.png',
    availability: 'Prototype physical product',
    about:
    'Leadership Reflection Cards are a prototype facilitation resource for individual reflection, coaching conversations and team development activities. Each card can introduce a leadership question, short scenario or conversation prompt that encourages people to think about communication, trust, empathy and decision-making.',
    features: [
      'Leadership reflection questions',
      'Team discussion prompts',
      'Coaching conversation starters',
      'Workshop-friendly activity format',
    ],
  ),
];

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  String filter = 'All';

  @override
  Widget build(BuildContext context) {
    final visibleProducts = demoProducts.where((product) {
      if (filter == 'All') return true;
      return product.type.startsWith(filter);
    }).toList();

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SimplePageHero(
              eyebrow: 'STORE',
              title: 'Tools for learning, reflection and growth.',
              description:
              'Explore prototype digital and physical resources designed to support self-reflection, learning and people development.',
            ),
            SectionWrapper(
              child: Row(
                children: [
                  const Text(
                    'Browse products',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'All', label: Text('All')),
                      ButtonSegment(value: 'Digital', label: Text('Digital')),
                      ButtonSegment(value: 'Physical', label: Text('Physical')),
                    ],
                    selected: {filter},
                    onSelectionChanged: (value) => setState(() => filter = value.first),
                  ),
                ],
              ),
            ),
            SectionWrapper(
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: visibleProducts
                    .map((product) => ProductCard(product: product))
                    .toList(),
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductData product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(27),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(21),
              child: Image.asset(
                product.image,
                width: double.infinity,
                height: 235,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              product.type.toUpperCase(),
              style: const TextStyle(
                color: AppColors.blue,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 9),
            Text(
              product.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 11),
            Text(product.price, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 17),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
                  );
                },
                child: const Text('View Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final ProductData product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final related = demoProducts.where((item) => item.title != product.title).take(2).toList();

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SectionWrapper(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final desktop = constraints.maxWidth > 840;
                  final visual = Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        product.image,
                        width: double.infinity,
                        height: 470,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                  final details = Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.type.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.7,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          product.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: desktop ? 43 : 35,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          product.description,
                          style: const TextStyle(color: Colors.black54, fontSize: 16, height: 1.65),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          product.price,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.availability,
                          style: const TextStyle(color: Colors.black45, fontSize: 13),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                              decoration: BoxDecoration(
                                color: AppColors.softGray,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Text('Qty 1', style: TextStyle(fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => goTo(context, '/cart'),
                                icon: const Icon(Icons.shopping_bag_outlined),
                                label: const Text('Add to Cart'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Prototype product — no real purchase will be processed.',
                          style: TextStyle(fontSize: 11, color: Colors.black45),
                        ),
                      ],
                    ),
                  );
                  if (desktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: visual),
                        const SizedBox(width: 35),
                        Expanded(child: details),
                      ],
                    );
                  }
                  return Column(children: [visual, const SizedBox(height: 25), details]);
                },
              ),
            ),
            SectionWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(
                    eyebrow: 'PRODUCT OVERVIEW',
                    title: 'Designed to support reflection and learning.',
                    description:
                    'The store prototype shows how MT Alchemy can present useful learning resources with clear purpose, format and access information.',
                  ),
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Text(
                      product.about,
                      style: const TextStyle(fontSize: 16, height: 1.75),
                    ),
                  ),
                ],
              ),
            ),
            SectionWrapper(
              child: CourseListPanel(
                title: 'What’s Inside',
                icon: Icons.inventory_2_rounded,
                items: product.features,
              ),
            ),
            SectionWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(
                    eyebrow: 'RELATED PRODUCTS',
                    title: 'Continue exploring.',
                    description: 'Other prototype resources from the MT Alchemy store.',
                  ),
                  const SizedBox(height: 26),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: related.map((item) => ProductCard(product: item)).toList(),
                  ),
                ],
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CART
// ============================================================

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SimplePageHero(
              eyebrow: 'SHOPPING CART',
              title: 'Review your selected resources.',
              description:
              'A representative cart showing quantity, subtotal, shipping and order summary before checkout.',
            ),
            SectionWrapper(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final desktop = constraints.maxWidth > 900;
                  final items = Column(
                    children: const [
                      CartItemCard(
                        image: 'assets/images/product_workbook.jpg',
                        title: 'Emotional Clarity Workbook',
                        type: 'Digital Product',
                        price: 'RM35',
                      ),
                      SizedBox(height: 14),
                      CartItemCard(
                        image: 'assets/images/product_journal.jpg',
                        title: 'Mindfulness Journal',
                        type: 'Physical Product',
                        price: 'RM45',
                      ),
                    ],
                  );
                  final summary = Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Summary',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 20),
                        const CartSummaryLine(label: 'Subtotal', value: 'RM80'),
                        const CartSummaryLine(label: 'Discount', value: 'RM0'),
                        const CartSummaryLine(label: 'Shipping', value: 'RM8'),
                        const Divider(height: 28),
                        const CartSummaryLine(label: 'Total', value: 'RM88', strong: true),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => goTo(context, '/checkout'),
                            child: const Text('Proceed to Checkout'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => goTo(context, '/store'),
                            child: const Text('Continue Shopping'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Prototype totals only — no real order or payment is created.',
                          style: TextStyle(fontSize: 10, color: Colors.black45),
                        ),
                      ],
                    ),
                  );
                  if (desktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: items),
                        const SizedBox(width: 22),
                        SizedBox(width: 350, child: summary),
                      ],
                    );
                  }
                  return Column(children: [items, const SizedBox(height: 22), summary]);
                },
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final String image;
  final String title;
  final String type;
  final String price;

  const CartItemCard({
    super.key,
    required this.image,
    required this.title,
    required this.type,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(image, width: 110, height: 95, fit: BoxFit.cover),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(type, style: const TextStyle(color: Colors.black45, fontSize: 12)),
                const SizedBox(height: 10),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.remove_circle_outline_rounded, size: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('1', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    Icon(Icons.add_circle_outline_rounded, size: 20),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(price, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class CartSummaryLine extends StatelessWidget {
  final String label;
  final String value;
  final bool strong;

  const CartSummaryLine({
    super.key,
    required this.label,
    required this.value,
    this.strong = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(fontWeight: strong ? FontWeight.w900 : FontWeight.w500)),
          ),
          Text(value, style: TextStyle(fontWeight: strong ? FontWeight.w900 : FontWeight.w700)),
        ],
      ),
    );
  }
}

// ============================================================
// CHECKOUT
// ============================================================

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final formKey = GlobalKey<FormState>();
  String payment = 'Card / Payment Provider';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SimplePageHero(
              eyebrow: 'CHECKOUT',
              title: 'Complete your prototype order.',
              description:
              'Customer, billing and shipping fields demonstrate the required checkout structure. No real payment gateway is connected.',
            ),
            SectionWrapper(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final desktop = constraints.maxWidth > 900;
                  final form = Container(
                    padding: const EdgeInsets.all(34),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Customer Information',
                            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 20),
                          const RequiredField(label: 'Name'),
                          const SizedBox(height: 14),
                          const RequiredField(label: 'Email', email: true),
                          const SizedBox(height: 14),
                          const RequiredField(label: 'Phone'),
                          const SizedBox(height: 28),
                          const Text(
                            'Billing & Shipping',
                            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 20),
                          const RequiredField(label: 'Address'),
                          const SizedBox(height: 14),
                          const Row(
                            children: [
                              Expanded(child: RequiredField(label: 'City')),
                              SizedBox(width: 12),
                              Expanded(child: RequiredField(label: 'State')),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Row(
                            children: [
                              Expanded(child: RequiredField(label: 'Postcode')),
                              SizedBox(width: 12),
                              Expanded(child: RequiredField(label: 'Country')),
                            ],
                          ),
                          const SizedBox(height: 28),
                          const Text(
                            'Payment',
                            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: payment,
                            items: const [
                              DropdownMenuItem(
                                value: 'Card / Payment Provider',
                                child: Text('Card / Payment Provider'),
                              ),
                              DropdownMenuItem(
                                value: 'Online Banking',
                                child: Text('Online Banking'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) setState(() => payment = value);
                            },
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Prototype only — the final payment provider has not been selected.',
                            style: TextStyle(fontSize: 11, color: Colors.black45),
                          ),
                        ],
                      ),
                    ),
                  );

                  final summary = Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.dark,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ORDER SUMMARY',
                          style: TextStyle(
                            color: AppColors.yellow,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '2 items',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 18),
                        const CheckoutSummaryLine(label: 'Workbook', value: 'RM35'),
                        const CheckoutSummaryLine(label: 'Mindfulness Journal', value: 'RM45'),
                        const CheckoutSummaryLine(label: 'Shipping', value: 'RM8'),
                        const Divider(color: Colors.white24, height: 28),
                        const CheckoutSummaryLine(label: 'Total', value: 'RM88', strong: true),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Prototype Order Confirmed'),
                                    content: const Text(
                                      'Thank you. A real implementation would now create an order and return payment status, download access or shipping information.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellow,
                              foregroundColor: AppColors.dark,
                            ),
                            child: const Text('Confirm Prototype Order'),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (desktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: form),
                        const SizedBox(width: 22),
                        SizedBox(width: 360, child: summary),
                      ],
                    );
                  }
                  return Column(children: [form, const SizedBox(height: 22), summary]);
                },
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

class CheckoutSummaryLine extends StatelessWidget {
  final String label;
  final String value;
  final bool strong;

  const CheckoutSummaryLine({
    super.key,
    required this.label,
    required this.value,
    this.strong = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: strong ? Colors.white : Colors.white70,
                fontWeight: strong ? FontWeight.w900 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: strong ? AppColors.yellow : Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// INSIGHTS
// ============================================================

class ArticleData {
  final String category;
  final String title;
  final String image;
  final String intro;
  final List<(String, String)> sections;
  final List<String> takeaways;

  const ArticleData({
    required this.category,
    required this.title,
    required this.image,
    required this.intro,
    required this.sections,
    required this.takeaways,
  });
}

const demoArticles = [
  ArticleData(
    category: 'EMOTIONAL INTELLIGENCE',
    title: 'Why self-awareness matters at work',
    image: 'assets/images/article_self_awareness.jpg',
    intro:
    'Self-awareness is the ability to notice emotions, reactions, strengths, blind spots and behavioural patterns as they happen. In the workplace, this matters because our internal state influences how we communicate, make decisions and respond to pressure.',
    sections: [
      (
      'From reaction to response',
      'When people do not notice what they are feeling, they can react automatically. A rushed reply, defensive tone or avoided conversation can quickly affect trust. Self-awareness creates a small pause between emotion and action, giving people more choice in how they respond.'
      ),
      (
      'Better communication starts internally',
      'Clear communication is not only about choosing the right words. It also depends on recognizing assumptions, stress signals and emotional triggers. A self-aware person is more likely to check understanding, listen actively and adjust how a message is delivered.'
      ),
      (
      'A foundation for leadership',
      'Leaders influence the emotional climate of a team. Understanding personal habits, strengths and pressure points can help leaders communicate more consistently, receive feedback with less defensiveness and model reflective behaviour.'
      ),
    ],
    takeaways: [
      'Pause before responding in emotionally charged moments.',
      'Notice patterns in situations that repeatedly create stress.',
      'Ask for feedback to compare intention with impact.',
      'Use short reflection notes after important conversations.',
    ],
  ),
  ArticleData(
    category: 'LEADERSHIP',
    title: 'Building authentic leadership',
    image: 'assets/images/article_leadership.jpg',
    intro:
    'Authentic leadership is less about performing a role and more about leading with consistency, self-awareness and clear values. It combines confidence with openness, helping people understand what a leader stands for and what they can expect.',
    sections: [
      (
      'Clarity builds trust',
      'Teams work more confidently when leaders communicate priorities, expectations and decisions clearly. Consistency between words and behaviour helps reduce uncertainty and creates a stronger sense of psychological safety.'
      ),
      (
      'Empathy is a leadership skill',
      'Empathy does not mean avoiding accountability. It means understanding another person’s perspective before deciding how to respond. This can improve feedback, conflict conversations and team support during change.'
      ),
      (
      'Reflection supports better decisions',
      'Leadership often requires quick action, but reflection still matters. Reviewing what worked, what created tension and what could be handled differently turns everyday experiences into ongoing leadership development.'
      ),
    ],
    takeaways: [
      'Communicate expectations early and clearly.',
      'Explain the reasoning behind important decisions when appropriate.',
      'Listen before moving directly into problem-solving.',
      'Review difficult conversations and identify one improvement.',
    ],
  ),
  ArticleData(
    category: 'WORKPLACE CULTURE',
    title: 'Creating healthier team cultures',
    image: 'assets/images/article_team_culture.jpg',
    intro:
    'Healthy team culture is built through repeated everyday behaviours. Communication, trust, inclusion, accountability and well-being are not separate initiatives; together they shape how people experience work and how effectively a team collaborates.',
    sections: [
      (
      'Culture appears in daily interactions',
      'Team culture is visible in how meetings are run, how mistakes are handled, how feedback is given and whether people feel safe asking for help. Small behaviours repeated over time become the normal way of working.'
      ),
      (
      'Connection supports collaboration',
      'People collaborate better when they understand one another, feel respected and have clear ways to communicate. Intentional team-building can help, but everyday listening, follow-through and shared problem-solving are equally important.'
      ),
      (
      'Well-being and performance are connected',
      'Sustainable performance is difficult when stress, confusion and unresolved conflict become normal. Teams benefit when workload, expectations and communication practices support both results and human well-being.'
      ),
    ],
    takeaways: [
      'Create team norms for communication and feedback.',
      'Make responsibilities and expectations visible.',
      'Address conflict early instead of allowing tension to build.',
      'Include regular check-ins on workload, clarity and support.',
    ],
  ),
];

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SimplePageHero(
              eyebrow: 'INSIGHTS',
              title: 'Ideas for people, leaders and workplaces.',
              description:
              'Explore prototype articles and resources across emotional intelligence, leadership, mindfulness, communication, personal development and organizational development.',
            ),
            const SectionWrapper(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilterChipLabel('Articles'),
                  FilterChipLabel('Emotional Intelligence'),
                  FilterChipLabel('Leadership'),
                  FilterChipLabel('Mindfulness'),
                  FilterChipLabel('Communication'),
                  FilterChipLabel('Workplace'),
                  FilterChipLabel('Personal Development'),
                  FilterChipLabel('Organizational Development'),
                ],
              ),
            ),
            SectionWrapper(
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: demoArticles.map((article) => InsightCard(article: article)).toList(),
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

class InsightCard extends StatelessWidget {
  final ArticleData article;

  const InsightCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                article.image,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              article.category,
              style: const TextStyle(
                color: AppColors.blue,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              article.title,
              style: const TextStyle(fontSize: 21, height: 1.25, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Text(
              article.intro,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black54, height: 1.45),
            ),
            const SizedBox(height: 14),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ArticleDetailPage(article: article)),
                );
              },
              child: const Text('Read article →'),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleDetailPage extends StatelessWidget {
  final ArticleData article;

  const ArticleDetailPage({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SectionWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.category,
                    style: const TextStyle(
                      color: AppColors.blue,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 850),
                    child: Text(
                      article.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 52,
                        height: 1.08,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 780),
                    child: Text(
                      article.intro,
                      style: const TextStyle(fontSize: 18, height: 1.7, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      article.image,
                      width: double.infinity,
                      height: 520,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            SectionWrapper(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 880),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F4FF),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline_rounded, color: AppColors.blue),
                            SizedBox(width: 13),
                            Expanded(
                              child: Text(
                                'Prototype article content created for the Flutter interface. It demonstrates how the future MT Alchemy Insights platform can present educational content.',
                                style: TextStyle(height: 1.55),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 35),
                      ...article.sections.map(
                            (section) => Padding(
                          padding: const EdgeInsets.only(bottom: 34),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                section.$1,
                                style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                section.$2,
                                style: const TextStyle(fontSize: 16, height: 1.8, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: AppColors.yellow,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Practical Takeaways',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 18),
                            ...article.takeaways.map(
                                  (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.check_circle_rounded, size: 18),
                                    const SizedBox(width: 10),
                                    Expanded(child: Text(item, style: const TextStyle(height: 1.5))),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 34),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => goTo(context, '/learning'),
                            child: const Text('Explore Learning'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: () => goTo(context, '/contact'),
                            child: const Text('Contact MT Alchemy'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CONTACT FORM
// ============================================================

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final formKey = GlobalKey<FormState>();
  String enquiryType = 'Corporate Training';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SimplePageHero(
              eyebrow: 'CONTACT',
              title: 'Let’s build a thriving workplace together.',
              description:
              'Connect with MT Alchemy about coaching, corporate development, leadership, teams, products or partnerships.',
            ),
            SectionWrapper(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final desktop = constraints.maxWidth > 880;
                  final form = Container(
                    padding: const EdgeInsets.all(36),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tell us what you’re looking for',
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'This form demonstrates the enquiry flow for the prototype.',
                            style: TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 25),
                          const RequiredField(label: 'Name'),
                          const SizedBox(height: 15),
                          const RequiredField(label: 'Email', email: true),
                          const SizedBox(height: 15),
                          const RequiredField(label: 'Phone'),
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Organization'),
                          ),
                          const SizedBox(height: 15),
                          DropdownButtonFormField<String>(
                            value: enquiryType,
                            decoration: const InputDecoration(labelText: 'Enquiry Type'),
                            items: const [
                              DropdownMenuItem(
                                value: 'Individual Coaching',
                                child: Text('Individual Coaching'),
                              ),
                              DropdownMenuItem(
                                value: 'Corporate Training',
                                child: Text('Corporate Training'),
                              ),
                              DropdownMenuItem(
                                value: 'Leadership Development',
                                child: Text('Leadership Development'),
                              ),
                              DropdownMenuItem(
                                value: 'Team Development',
                                child: Text('Team Development'),
                              ),
                              DropdownMenuItem(value: 'Products', child: Text('Products')),
                              DropdownMenuItem(value: 'Partnership', child: Text('Partnership')),
                              DropdownMenuItem(value: 'Other', child: Text('Other')),
                            ],
                            onChanged: (value) {
                              if (value != null) setState(() => enquiryType = value);
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            minLines: 4,
                            maxLines: 6,
                            decoration: const InputDecoration(labelText: 'Message'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Message is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Enquiry form validated successfully — prototype only.'),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Submit Enquiry'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                  final contact = Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.deepBlue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CONTACT MT ALCHEMY',
                          style: TextStyle(
                            color: AppColors.yellow,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Start a conversation.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 29,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 13),
                        Text(
                          'Whether you are exploring leadership, team effectiveness, employee well-being or a customized programme, MT Alchemy is ready to discuss your needs.',
                          style: TextStyle(color: Colors.white70, height: 1.65),
                        ),
                        SizedBox(height: 30),
                        ContactInfoRow(
                          icon: Icons.chat_rounded,
                          label: 'WhatsApp',
                          value: '+6011-7239 9249',
                        ),
                        SizedBox(height: 18),
                        ContactInfoRow(
                          icon: Icons.email_rounded,
                          label: 'Email',
                          value: 'mabeltan.alchemy@gmail.com',
                        ),
                        SizedBox(height: 26),
                        Text(
                          'Social profiles can be connected once the final URLs are confirmed.',
                          style: TextStyle(color: Colors.white54, fontSize: 12, height: 1.5),
                        ),
                      ],
                    ),
                  );

                  if (desktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: form),
                        const SizedBox(width: 24),
                        Expanded(flex: 4, child: contact),
                      ],
                    );
                  }
                  return Column(children: [form, const SizedBox(height: 22), contact]);
                },
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

class ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ContactInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.yellow),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RequiredField extends StatelessWidget {
  final String label;
  final bool email;

  const RequiredField({
    super.key,
    required this.label,
    this.email = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        if (email &&
            !RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$').hasMatch(value.trim())) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }
}

// ============================================================
// REGISTER
// ============================================================

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  String accountType = 'Individual';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Container(
            width: 620,
            padding: const EdgeInsets.all(36),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login / Register',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create a prototype learning account.',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 28),

                  const RequiredField(
                    label: 'Name',
                  ),
                  const SizedBox(height: 15),

                  const RequiredField(
                    label: 'Email',
                    email: true,
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    obscureText: true,
                    decoration:
                    const InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.length < 6) {
                        return 'Password must contain at least 6 characters';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    value: accountType,
                    decoration:
                    const InputDecoration(
                      labelText: 'Account Type',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Individual',
                        child: Text(
                          'Individual',
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Employer',
                        child: Text(
                          'Employer / Organization',
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          accountType = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!
                            .validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Registration form validated successfully — demo account opened.',
                              ),
                            ),
                          );
                          Future.delayed(const Duration(milliseconds: 250), () {
                            if (!context.mounted) return;
                            goTo(
                              context,
                              accountType == 'Employer' ? '/employer' : '/dashboard',
                            );
                          });
                        }
                      },
                      child: const Text(
                        'Create Account',
                      ),
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

// ============================================================
// EMPLOYER DASHBOARD
// ============================================================

class EmployerDashboard extends StatelessWidget {
  const EmployerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SectionWrapper(
              child: Container(
                padding: const EdgeInsets.all(34),
                decoration: BoxDecoration(
                  color: AppColors.deepBlue,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final desktop = constraints.maxWidth > 760;
                    final copy = const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ORGANIZATION PORTAL • DEMO',
                          style: TextStyle(
                            color: AppColors.yellow,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Welcome, ABC Sdn Bhd',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 39,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Manage employees, assign learning and review organization progress from one workspace.',
                          style: TextStyle(color: Colors.white70, height: 1.6),
                        ),
                      ],
                    );
                    final badge = Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.business_rounded, color: AppColors.yellow),
                          SizedBox(width: 10),
                          Text(
                            'Employer Account',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    );
                    if (desktop) {
                      return Row(
                        children: [
                          Expanded(child: copy),
                          const SizedBox(width: 25),
                          badge,
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [copy, const SizedBox(height: 22), badge],
                    );
                  },
                ),
              ),
            ),
            const SectionWrapper(
              child: Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  DashboardCard(value: '50', label: 'Employees'),
                  DashboardCard(value: '32', label: 'Active Learners'),
                  DashboardCard(value: '4', label: 'Courses Assigned'),
                  DashboardCard(value: '68%', label: 'Completion Rate'),
                  DashboardCard(value: '17', label: 'Certificates Earned'),
                  DashboardCard(value: '126h', label: 'Learning Hours'),
                ],
              ),
            ),
            SectionWrapper(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final desktop = constraints.maxWidth > 850;
                  final progress = Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overall Learning Progress',
                          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: 20),
                        LinearProgressIndicator(
                          value: 0.68,
                          minHeight: 13,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        SizedBox(height: 10),
                        Text('68% completed across assigned learning'),
                        SizedBox(height: 24),
                        ProgressRow(label: 'Leadership & Communication', value: 0.81),
                        SizedBox(height: 14),
                        ProgressRow(label: 'Emotional Intelligence', value: 0.64),
                        SizedBox(height: 14),
                        ProgressRow(label: 'Mindfulness at Work', value: 0.52),
                      ],
                    ),
                  );
                  final actions = Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Actions',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 18),
                        DashboardActionButton(
                          icon: Icons.people_alt_rounded,
                          label: 'Manage Employees',
                          onTap: () => goTo(context, '/employees'),
                        ),
                        DashboardActionButton(
                          icon: Icons.assignment_add,
                          label: 'Assign Course',
                          onTap: () => goTo(context, '/assign-course'),
                        ),
                        DashboardActionButton(
                          icon: Icons.analytics_rounded,
                          label: 'View Reports',
                          onTap: () => goTo(context, '/reports'),
                        ),
                        DashboardActionButton(
                          icon: Icons.shopping_cart_rounded,
                          label: 'Browse Learning',
                          onTap: () => goTo(context, '/learning'),
                        ),
                      ],
                    ),
                  );
                  if (desktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: progress),
                        const SizedBox(width: 22),
                        Expanded(flex: 4, child: actions),
                      ],
                    );
                  }
                  return Column(children: [progress, const SizedBox(height: 22), actions]);
                },
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}

class ProgressRow extends StatelessWidget {
  final String label;
  final double value;

  const ProgressRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
            Text('${(value * 100).round()}%'),
          ],
        ),
        const SizedBox(height: 7),
        LinearProgressIndicator(
          value: value,
          minHeight: 8,
          backgroundColor: const Color(0xFFEFEFEF),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
      ],
    );
  }
}

class DashboardActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DashboardActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: AppColors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
                const Icon(Icons.arrow_forward_rounded, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String value;
  final String label;

  const DashboardCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        width: 245,
        padding: const EdgeInsets.all(27),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: AppColors.blue,
                fontSize: 34,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// REUSABLE LAYOUT
// ============================================================

class SectionWrapper extends StatelessWidget {
  final Widget child;

  const SectionWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        constraints:
        const BoxConstraints(maxWidth: 1250),
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 58,
        ),
        child: child,
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String description;

  const SectionTitle({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
      const BoxConstraints(maxWidth: 720),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: const TextStyle(
              color: AppColors.blue,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.dark,
              fontSize: 40,
              height: 1.08,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

class CenteredSectionTitle
    extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String description;

  const CenteredSectionTitle({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          eyebrow,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.blue,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 40,
            height: 1.08,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          constraints:
          const BoxConstraints(maxWidth: 700),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
              height: 1.65,
            ),
          ),
        ),
      ],
    );
  }
}

class PageHero extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String description;
  final String image;

  const PageHero({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Container(
        padding: const EdgeInsets.all(27),
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(34),
        ),
        child: Column(
          children: [
            Text(
              eyebrow,
              style: const TextStyle(
                color: AppColors.yellow,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              constraints:
              const BoxConstraints(maxWidth: 900),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 43,
                  height: 1.08,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            ClipRRect(
              borderRadius:
              BorderRadius.circular(27),
              child: Image.asset(
                image,
                width: double.infinity,
                height: 440,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimplePageHero extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String description;

  const SimplePageHero({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 35,
          vertical: 70,
        ),
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(34),
        ),
        child: Column(
          children: [
            Text(
              eyebrow,
              style: const TextStyle(
                color: AppColors.yellow,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 17),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 43,
                height: 1.08,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 17),
            Container(
              constraints:
              const BoxConstraints(maxWidth: 750),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  final String title;
  final String text;

  const InfoBox({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        width: 540,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              text,
              style: const TextStyle(
                color: Colors.black54,
                height: 1.65,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// FOOTER
// ============================================================

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.dark,
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 55),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Wrap(
                spacing: 45,
                runSpacing: 35,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 320,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/logo.png', height: 75),
                        const SizedBox(height: 16),
                        const Text(
                          'Building emotionally intelligent leaders and resilient workplace cultures.',
                          style: TextStyle(color: Colors.white70, height: 1.6),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'WhatsApp: +6011-7239 9249',
                          style: TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'mabeltan.alchemy@gmail.com',
                          style: TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                        const SizedBox(height: 16),
                        const Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            SocialPlaceholder(label: 'LinkedIn'),
                            SocialPlaceholder(label: 'Instagram'),
                            SocialPlaceholder(label: 'Facebook'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const FooterColumn(
                    title: 'Explore',
                    links: [
                      FooterLinkData('About', '/about'),
                      FooterLinkData('Services', '/services'),
                      FooterLinkData('Upskilling', '/learning'),
                      FooterLinkData('Store', '/store'),
                      FooterLinkData('Insights', '/insights'),
                    ],
                  ),
                  const FooterColumn(
                    title: 'Work With Us',
                    links: [
                      FooterLinkData('For Organizations', '/organizations'),
                      FooterLinkData('Corporate Programmes', '/corporate-programmes'),
                      FooterLinkData('Individual Coaching', '/coaching'),
                      FooterLinkData('Contact', '/contact'),
                    ],
                  ),
                  const FooterColumn(
                    title: 'Account',
                    links: [
                      FooterLinkData('My Learning', '/dashboard'),
                      FooterLinkData('Login / Register', '/register'),
                      FooterLinkData('Employer Portal', '/employer'),
                      FooterLinkData('Cart', '/cart'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 38),
              Container(height: 1, color: Colors.white12),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      '© 2026 MT Alchemy • Flutter UI Prototype',
                      style: TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ),
                  Text(
                    'Prototype data where noted',
                    style: TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialPlaceholder extends StatelessWidget {
  final String label;

  const SocialPlaceholder({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white54, fontSize: 10),
      ),
    );
  }
}

class FooterLinkData {
  final String label;
  final String route;

  const FooterLinkData(this.label, this.route);
}

class FooterColumn extends StatelessWidget {
  final String title;
  final List<FooterLinkData> links;

  const FooterColumn({
    super.key,
    required this.title,
    required this.links,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ...links.map(
                (link) => TextButton(
              onPressed: () => goTo(context, link.route),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 5),
                foregroundColor: Colors.white60,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(link.label),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
