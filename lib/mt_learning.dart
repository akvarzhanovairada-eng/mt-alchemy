part of 'main.dart';

/// Phase 1 real-time My Learning. We intentionally do not display fake quiz
/// scores, orders or certificates while those integrations are unfinished.
class MTLearningDashboardPage extends StatelessWidget {
  const MTLearningDashboardPage({super.key});

  Future<void> _start(BuildContext context) async {
    try {
      final existing = await MTCommerceService.canStartEq();
      if (!existing) {
        if (context.mounted) goTo(context, '/learning');
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please purchase the course first in Learning Hub.')));
        return;
      }
      await MTProgressService.enroll();
      if (context.mounted) goTo(context, '/course-player');
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open your course: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const MTAccessMessage(title: 'Please log in', icon: Icons.lock_outline_rounded);
    }
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SectionWrapper(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: MTUserService.profileStream(user.uid),
                builder: (context, snapshot) {
                  final profile = MTUserProfile.fromMap(snapshot.data?.data() ?? {});
                  final name = profile.name.isNotEmpty ? profile.name : 'Learner';
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Wrap(spacing: 18, runSpacing: 14, crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        CircleAvatar(radius: 30, backgroundColor: AppColors.yellow,
                            child: Text(profile.initials,
                                style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.dark))),
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min, children: [
                              Text('Welcome back, $name!',
                                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                              const SizedBox(height: 5),
                              Text(user.email ?? '', style: const TextStyle(color: Colors.white70)),
                            ]),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SectionWrapper(child: MTMyAssignedCoursesPanel()),
            SectionWrapper(
              child: StreamBuilder<MTProgress?>(
                stream: MTProgressService.watch(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _panel(
                      child: const Text('Could not load your progress. Please check Firestore Rules and your connection.'),
                    );
                  }
                  if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final progress = snapshot.data;
                  final enrolled = progress != null;
                  final finished = progress?.completedModules.length ?? 0;
                  final percentage = progress?.percent ?? 0;
                  return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Wrap(spacing: 15, runSpacing: 12, children: [
                      DashboardCard(value: enrolled ? '1' : '0', label: 'Active Courses'),
                      DashboardCard(value: '$percentage%', label: 'EQ Course Progress'),
                      DashboardCard(value: '$finished / 5', label: 'Completed Modules'),
                    ]),
                    const SizedBox(height: 20),
                    _panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('MY LEARNING', style: TextStyle(
                          color: AppColors.blue, fontSize: 12, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 16),
                      LayoutBuilder(builder: (context, constraints) {
                        final img = ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.asset('assets/images/course_eq.jpg',
                              width: constraints.maxWidth < 550 ? double.infinity : 180,
                              height: 130, fit: BoxFit.cover),
                        );
                        final details = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Emotional Intelligence Fundamentals',
                              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 9),
                          Text(enrolled
                              ? 'Continue with Module ${(progress.lastModule + 1)}: ${MTProgressService.moduleTitles[progress.lastModule]}'
                              : 'Five modules • Learn at your own pace • Progress saved to your account',
                              style: const TextStyle(color: Colors.black54, height: 1.5)),
                        ]);
                        if (constraints.maxWidth < 550) {
                          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            img, const SizedBox(height: 14), details]);
                        }
                        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          img, const SizedBox(width: 20), Expanded(child: details)]);
                      }),
                      const SizedBox(height: 20),
                      Row(children: [
                        const Text('Your progress', style: TextStyle(fontWeight: FontWeight.w700)),
                        const Spacer(),
                        Text('$percentage%', style: const TextStyle(
                            color: AppColors.blue, fontWeight: FontWeight.w900)),
                      ]),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: percentage / 100, minHeight: 11,
                          borderRadius: BorderRadius.circular(16)),
                      const SizedBox(height: 22),
                      if (enrolled) ...[
                        ...List.generate(MTProgressService.moduleTitles.length, (index) =>
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(progress.completedModules.contains(index)
                                  ? Icons.check_circle_rounded
                                  : index == progress.lastModule
                                  ? Icons.play_circle_rounded
                                  : Icons.circle_outlined,
                                  color: progress.completedModules.contains(index) || index == progress.lastModule
                                      ? AppColors.blue : Colors.black26),
                              title: Text('${index + 1}. ${MTProgressService.moduleTitles[index]}'),
                              trailing: progress.completedModules.contains(index)
                                  ? const Text('Done', style: TextStyle(color: Colors.green)) : null,
                            )),
                        const SizedBox(height: 10),
                      ],
                      FilledButton.icon(
                        onPressed: () => _start(context),
                        icon: Icon(enrolled ? Icons.play_arrow_rounded : Icons.school_rounded),
                        label: Text(enrolled ? 'Continue Learning' : 'Enrol and Start Course'),
                      ),
                    ])),
                    const SizedBox(height: 18),
                    _panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Final assessment & certificate',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: MTAssessmentService.watchResult(),
                        builder: (context, result) {
                          final record = result.data?.data();
                          final best = record?['bestScore'];
                          return Text(best == null
                              ? 'Complete all 5 lessons to unlock your assessment.'
                              : 'Best quiz score: $best / 8. ${record?['passed'] == true ? 'Passed!' : 'Keep practising.'}');
                        },
                      ),
                      const SizedBox(height: 12),
                      Wrap(spacing: 10, runSpacing: 10, children: [
                        FilledButton.icon(
                            onPressed: progress?.lessonsFinished == true
                                ? () => goTo(context, '/learning-quiz') : null,
                            icon: const Icon(Icons.quiz_outlined),
                            label: const Text('Final Quiz')),
                        OutlinedButton.icon(onPressed: () => goTo(context, '/certificate'),
                            icon: const Icon(Icons.workspace_premium_outlined),
                            label: const Text('My Certificate')),
                        OutlinedButton(onPressed: () => goTo(context, '/my-orders'),
                            child: const Text('My Orders')),
                      ]),
                    ])),
                  ]);
                },
              ),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  Widget _panel({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(25),
    decoration: BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFEDF0F7))),
    child: child,
  );
}

/// The selected module and completion state are persisted per Firebase UID.
class MTLearningPlayerPage extends StatefulWidget {
  const MTLearningPlayerPage({super.key});

  @override
  State<MTLearningPlayerPage> createState() => _MTLearningPlayerPageState();
}

class _MTLearningPlayerPageState extends State<MTLearningPlayerPage> {
  int activeModule = 0;
  bool loading = true;
  bool saving = false;
  String? errorMessage;
  late final Stream<MTProgress?> progressStream;

  static const descriptions = [
    'Emotional intelligence is not about hiding feelings or always being positive. Learn to perceive, use, understand and manage emotional information in everyday life.',
    'Practice naming an emotion precisely, noticing its physical signals and identifying what may have triggered it. Reflect before reacting.',
    'Emotions affect attention, assumptions and decisions. Practice pausing, checking the facts and choosing a constructive response.',
    'Consider another person\'s perspective, listen actively and respond with empathy instead of making assumptions.',
    'Apply emotional intelligence in workplace situations: feedback, challenging conversations, collaboration and leadership.',
  ];

  static const reflections = [
    'Think about feedback you received. What did you feel, and what response would have been constructive?',
    'Name a recent emotion, rate its intensity from 1–5, and identify the situation that triggered it.',
    'Recall a difficult decision. What were the facts, and which emotions may have influenced your choice?',
    'Remember a conversation where someone felt unheard. What could you ask to understand their perspective?',
    'Choose one workplace situation where you will apply a pause, an empathetic question or a more thoughtful response.',
  ];

  @override
  void initState() {
    super.initState();
    progressStream = MTProgressService.watch();
    _load();
  }

  Future<void> _load() async {
    try {
      await MTProgressService.enroll();
      final progress = await MTProgressService.fetch();
      if (!mounted) return;
      setState(() {
        activeModule = progress?.lastModule ?? 0;
        loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        errorMessage = error.toString();
        loading = false;
      });
    }
  }

  Future<void> _selectModule(int index) async {
    if (saving || index == activeModule) return;
    setState(() => saving = true);
    try {
      await MTProgressService.openModule(index);
      if (mounted) setState(() => activeModule = index);
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Future<void> _complete() async {
    if (saving) return;
    setState(() => saving = true);
    try {
      await MTProgressService.markComplete(activeModule);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Module completed — progress saved to Firebase.')),
        );
      }
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not save progress: $error')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text('Could not load the course: $errorMessage'),
      ))
          : StreamBuilder<MTProgress?>(
        stream: progressStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Could not load progress. Please check Firestore Rules.'));
          }
          final progress = snapshot.data;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  TextButton.icon(
                    onPressed: () => goTo(context, '/dashboard'),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('My Learning'),
                  ),
                  const SizedBox(height: 12),
                  Text(MTProgressService.courseName,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: LinearProgressIndicator(
                        value: progress?.fraction ?? 0, minHeight: 10,
                        borderRadius: BorderRadius.circular(12))),
                    const SizedBox(width: 14),
                    Text('${progress?.percent ?? 0}% completed',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.blue)),
                  ]),
                  const SizedBox(height: 24),
                  LayoutBuilder(builder: (context, constraints) {
                    final sidebar = Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white,
                          borderRadius: BorderRadius.circular(24)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('COURSE CONTENT',
                            style: TextStyle(color: AppColors.blue, fontSize: 12,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 14),
                        ...List.generate(MTProgressService.moduleTitles.length, (index) {
                          final done = progress?.completedModules.contains(index) ?? false;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: ListTile(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                              tileColor: index == activeModule ? AppColors.iceBlue : null,
                              leading: Icon(done ? Icons.check_circle_rounded
                                  : Icons.circle_outlined,
                                  color: done ? Colors.green : AppColors.blue),
                              title: Text('${index + 1}. ${MTProgressService.moduleTitles[index]}',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                              onTap: saving ? null : () => _selectModule(index),
                            ),
                          );
                        }),
                      ]),
                    );
                    final lesson = Container(
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(color: Colors.white,
                          borderRadius: BorderRadius.circular(24)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('MODULE ${activeModule + 1} OF 5',
                            style: const TextStyle(color: AppColors.blue,
                                fontWeight: FontWeight.w800, fontSize: 12)),
                        const SizedBox(height: 9),
                        Text(MTProgressService.moduleTitles[activeModule],
                            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 20),
                        MTVideoLesson(
                          key: ValueKey('eq-video-$activeModule'),
                          lesson: MTEQLessons.modules[activeModule],
                        ),
                        const SizedBox(height: 20),
                        const Text('Lesson overview', style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 9),
                        Text(descriptions[activeModule],
                            style: const TextStyle(height: 1.6, color: Colors.black87)),
                        const SizedBox(height: 22),
                        MTLessonStudyCards(lesson: MTEQLessons.modules[activeModule]),
                        const SizedBox(height: 16),
                        MTTrainerMaterialsForModule(moduleIndex: activeModule),
                        const SizedBox(height: 20),
                        MTModuleReflection(
                          key: ValueKey('eq-reflection-$activeModule'),
                          moduleIndex: activeModule,
                          prompt: MTEQLessons.modules[activeModule].practice,
                        ),
                        const SizedBox(height: 22),
                        Wrap(spacing: 10, runSpacing: 10, children: [
                          OutlinedButton.icon(
                            onPressed: saving || activeModule == 0
                                ? null : () => _selectModule(activeModule - 1),
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('Previous'),
                          ),
                          FilledButton.icon(
                            onPressed: saving || (progress?.completedModules.contains(activeModule) ?? false)
                                ? null : _complete,
                            icon: const Icon(Icons.check_circle_outline_rounded),
                            label: Text((progress?.completedModules.contains(activeModule) ?? false)
                                ? 'Completed' : 'Mark Complete'),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: saving || activeModule == MTProgressService.moduleTitles.length - 1
                                ? null : () => _selectModule(activeModule + 1),
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: const Text('Next Module'),
                          ),
                        ]),
                        if (progress?.lessonsFinished == true) ...[
                          const SizedBox(height: 18),
                          FilledButton.icon(
                              onPressed: () => goTo(context, '/learning-quiz'),
                              icon: const Icon(Icons.fact_check_outlined),
                              label: const Text('Take Final Quiz')),
                        ],
                        const SizedBox(height: 13),
                        const Text('Completed lessons are saved to your account. You can safely log out and continue on another device.',
                            style: TextStyle(fontSize: 12, color: Colors.black54)),
                      ]),
                    );
                    if (constraints.maxWidth < 850) {
                      return Column(children: [sidebar,
                        const SizedBox(height: 18), lesson]);
                    }
                    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      SizedBox(width: 310, child: sidebar),
                      const SizedBox(width: 20),
                      Expanded(child: lesson),
                    ]);
                  }),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}