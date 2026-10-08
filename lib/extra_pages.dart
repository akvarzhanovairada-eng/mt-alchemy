part of 'main.dart';

// ============================================================
// EXTRA PROTOTYPE PAGES
// These screens extend the public website with representative
// LMS, individual, employer, trainer and admin experiences.
// ============================================================

class OrganizationsPage extends StatelessWidget {
  const OrganizationsPage({super.key});

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

    const solutions = [
      ('Leadership Development', Icons.leaderboard_rounded),
      ('Emotional Intelligence', Icons.psychology_rounded),
      ('Team Effectiveness', Icons.groups_rounded),
      ('Communication', Icons.forum_rounded),
      ('Workplace Well-being', Icons.spa_rounded),
      ('Organizational Development', Icons.domain_rounded),
      ('CSR & ESG', Icons.volunteer_activism_rounded),
      ('Customized Training', Icons.tune_rounded),
    ];

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SimplePageHero(
              eyebrow: 'FOR ORGANIZATIONS',
              title: 'Build emotionally intelligent leaders and resilient workplace cultures.',
              description:
              'Explore corporate learning solutions that address communication, leadership, team effectiveness and workplace well-being.',
            ),
            SectionWrapper(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final desktop = constraints.maxWidth > 850;
                  final challengePanel = Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.dark,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ORGANIZATIONAL CHALLENGES',
                          style: TextStyle(
                            color: AppColors.yellow,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'When people challenges become business challenges.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            height: 1.15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Wrap(
                          spacing: 9,
                          runSpacing: 9,
                          children: challenges
                              .map(
                                (item) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 11,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                item,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                              .toList(),
                        ),
                      ],
                    ),
                  );

                  final solutionPanel = Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'OUR SOLUTIONS',
                          style: TextStyle(
                            color: AppColors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Human development that connects people and performance.',
                          style: TextStyle(
                            fontSize: 27,
                            height: 1.15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 22),
                        ...solutions.map(
                              (solution) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F4FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    solution.$2,
                                    color: AppColors.blue,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    solution.$1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (desktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: challengePanel),
                        const SizedBox(width: 22),
                        Expanded(child: solutionPanel),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      challengePanel,
                      const SizedBox(height: 22),
                      solutionPanel,
                    ],
                  );
                },
              ),
            ),
            SectionWrapper(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Wrap(
                  spacing: 18,
                  runSpacing: 14,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const SizedBox(
                      width: 690,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Need a programme for your organization?',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Explore programme structures or speak with MT Alchemy about a customized solution.',
                            style: TextStyle(height: 1.55),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ElevatedButton(
                          onPressed: () => goTo(context, '/corporate-programmes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.dark,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Corporate Programmes'),
                        ),
                        OutlinedButton(
                          onPressed: () => goTo(context, '/contact'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.dark,
                            side: const BorderSide(color: AppColors.dark),
                          ),
                          child: const Text('Talk to MT Alchemy'),
                        ),
                      ],
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

class CorporateProgrammesPage extends StatelessWidget {
  const CorporateProgrammesPage({super.key});

  @override
  Widget build(BuildContext context) {
    const programmes = [
      (
      'Emotionally Intelligent Leadership',
      'Leadership Development',
      'Managers & emerging leaders',
      'Half-day / Full-day / Customized',
      'Build self-awareness, empathy, communication and emotionally intelligent leadership habits.',
      'assets/images/leadership.jpg'
      ),
      (
      'Team Effectiveness Lab',
      'Team Development',
      'Functional & cross-functional teams',
      'Half-day / Full-day',
      'Strengthen trust, communication, collaboration and team problem-solving through experiential activities.',
      'assets/images/teamwork.jpg'
      ),
      (
      'Mindful Workplace Programme',
      'Well-being',
      'Employees, teams & people leaders',
      'Workshop / Series',
      'Support awareness, reflection, healthier stress responses and sustainable workplace habits.',
      'assets/images/wellbeing.jpg'
      ),
    ];

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SimplePageHero(
              eyebrow: 'CORPORATE PROGRAMMES',
              title: 'Learning experiences built around organizational needs.',
              description:
              'Programme cards below are prototype examples showing how MT Alchemy can present objectives, audience, format and enquiry actions without inventing confirmed corporate pricing.',
            ),
            SectionWrapper(
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: programmes
                    .map(
                      (programme) => HoverLift(
                    child: Container(
                      width: 355,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(27),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              programme.$6,
                              height: 205,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            programme.$2.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.blue,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            programme.$1,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            programme.$5,
                            style: const TextStyle(
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 15),
                          _ProgrammeInfoLine(
                            icon: Icons.groups_rounded,
                            text: programme.$3,
                          ),
                          _ProgrammeInfoLine(
                            icon: Icons.schedule_rounded,
                            text: programme.$4,
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => goTo(context, '/contact'),
                              child: const Text('Request a Quote'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
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

class _ProgrammeInfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ProgrammeInfoLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: AppColors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class IndividualCoachingPage extends StatelessWidget {
  const IndividualCoachingPage({super.key});

  @override
  Widget build(BuildContext context) {
    const focusAreas = [
      ('Career guidance', Icons.explore_rounded),
      ('Career transitions', Icons.swap_horiz_rounded),
      ('Relationships', Icons.favorite_border_rounded),
      ('Personal development', Icons.auto_awesome_rounded),
    ];

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SimplePageHero(
              eyebrow: 'INDIVIDUAL COACHING',
              title: 'A reflective space for clarity, growth and next steps.',
              description:
              'The coaching page demonstrates how MT Alchemy can present individual support for career, relationships and personal development.',
            ),
            SectionWrapper(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final desktop = constraints.maxWidth > 820;
                  final who = Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Who coaching is for',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Coaching can support people who want space to think through a transition, clarify personal goals, understand recurring patterns or prepare for an important next step. The prototype avoids presenting fixed clinical or therapeutic claims.',
                          style: TextStyle(height: 1.7, color: Colors.black54),
                        ),
                      ],
                    ),
                  );
                  final focus = Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Coaching focus',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ...focusAreas.map(
                              (area) => Padding(
                            padding: const EdgeInsets.only(bottom: 13),
                            child: Row(
                              children: [
                                Icon(area.$2, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    area.$1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (desktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: who),
                        const SizedBox(width: 22),
                        Expanded(child: focus),
                      ],
                    );
                  }
                  return Column(
                    children: [who, const SizedBox(height: 22), focus],
                  );
                },
              ),
            ),
            const SectionWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                    eyebrow: 'HOW IT WORKS',
                    title: 'Simple, conversation-led support.',
                    description:
                    'The detailed programme packages, session duration and pricing should be confirmed by MT Alchemy before production launch.',
                  ),
                  SizedBox(height: 28),
                  Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: [
                      CoachingStep(
                        number: '01',
                        title: 'Connect',
                        text: 'Share what you would like to explore and what outcome you are hoping for.',
                      ),
                      CoachingStep(
                        number: '02',
                        title: 'Reflect',
                        text: 'Use guided conversation and practical reflection to understand the situation more clearly.',
                      ),
                      CoachingStep(
                        number: '03',
                        title: 'Move Forward',
                        text: 'Identify practical actions, experiments or next steps to continue development.',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SectionWrapper(
              child: Center(
                child: ElevatedButton(
                  onPressed: () => goTo(context, '/contact'),
                  child: const Text('Book a Coaching Session'),
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

class CoachingStep extends StatelessWidget {
  final String number;
  final String title;
  final String text;

  const CoachingStep({
    super.key,
    required this.number,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345,
      padding: const EdgeInsets.all(27),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              color: AppColors.blue,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.black54, height: 1.55),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// COURSE FINDER
// ============================================================

class CourseFinderPage extends StatefulWidget {
  const CourseFinderPage({super.key});

  @override
  State<CourseFinderPage> createState() => _CourseFinderPageState();
}

class _CourseFinderPageState extends State<CourseFinderPage> {
  String audience = 'Individual';
  String goal = 'Leadership';
  String format = 'Self-paced';
  String level = 'Beginner';
  bool showResult = false;

  CourseData get recommendation {
    final courses = getCourses();
    if (goal == 'Emotional Intelligence') return courses[0];
    if (goal == 'Well-being') return courses[2];
    if (goal == 'Communication') return courses[1];
    if (goal == 'Teamwork') return courses[1];
    return courses[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SimplePageHero(
              eyebrow: 'FIND MY COURSE',
              title: 'A quick way to explore your best-fit learning path.',
              description:
              'This is a rules-based prototype recommendation flow. No AI model is connected at this stage.',
            ),
            SectionWrapper(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                padding: const EdgeInsets.all(34),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const QuizChoiceTitle(
                      number: '01',
                      title: 'Who are you exploring learning for?',
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ChoiceChip(
                          label: const Text('Individual'),
                          selected: audience == 'Individual',
                          onSelected: (_) => setState(() => audience = 'Individual'),
                        ),
                        ChoiceChip(
                          label: const Text('Employer / Team'),
                          selected: audience == 'Employer / Team',
                          onSelected: (_) => setState(() => audience = 'Employer / Team'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const QuizChoiceTitle(
                      number: '02',
                      title: 'What would you most like to strengthen?',
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final item in [
                          'Leadership',
                          'Communication',
                          'Emotional Intelligence',
                          'Well-being',
                          'Teamwork',
                        ])
                          ChoiceChip(
                            label: Text(item),
                            selected: goal == item,
                            onSelected: (_) => setState(() => goal = item),
                          ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const QuizChoiceTitle(
                      number: '03',
                      title: 'What learning style do you prefer?',
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final item in ['Self-paced', 'Workshop', 'Group Learning'])
                          ChoiceChip(
                            label: Text(item),
                            selected: format == item,
                            onSelected: (_) => setState(() => format = item),
                          ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const QuizChoiceTitle(
                      number: '04',
                      title: 'What level feels right?',
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final item in ['Beginner', 'Intermediate', 'Advanced'])
                          ChoiceChip(
                            label: Text(item),
                            selected: level == item,
                            onSelected: (_) => setState(() => level = item),
                          ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => showResult = true),
                      icon: const Icon(Icons.auto_awesome_rounded),
                      label: const Text('Show My Recommendation'),
                    ),
                    if (showResult) ...[
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(27),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F4FF),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final desktop = constraints.maxWidth > 650;
                            final image = ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                recommendation.image,
                                width: double.infinity,
                                height: 230,
                                fit: BoxFit.cover,
                              ),
                            );
                            final copy = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'RECOMMENDED FOR YOU',
                                  style: TextStyle(
                                    color: AppColors.blue,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  recommendation.title,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 11),
                                Text(
                                  recommendation.description,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    height: 1.55,
                                  ),
                                ),
                                const SizedBox(height: 13),
                                Text(
                                  'Based on: $audience • $goal • $format • $level',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CourseDetailPage(
                                          course: recommendation,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('View Recommended Course'),
                                ),
                              ],
                            );
                            if (desktop) {
                              return Row(
                                children: [
                                  Expanded(child: image),
                                  const SizedBox(width: 25),
                                  Expanded(child: copy),
                                ],
                              );
                            }
                            return Column(
                              children: [
                                image,
                                const SizedBox(height: 22),
                                copy,
                              ],
                            );
                          },
                        ),
                      ),
                    ],
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

class QuizChoiceTitle extends StatelessWidget {
  final String number;
  final String title;

  const QuizChoiceTitle({
    super.key,
    required this.number,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Text(
              number,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// LEARNER DASHBOARD
// ============================================================

class LearnerDashboardPage extends StatelessWidget {
  const LearnerDashboardPage({super.key});

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
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final desktop = constraints.maxWidth > 760;
                    final user = const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 37,
                          backgroundColor: AppColors.yellow,
                          child: Text(
                            'DL',
                            style: TextStyle(
                              color: AppColors.dark,
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        SizedBox(width: 17),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back, Demo Learner',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Individual learner account • Prototype data',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                    final button = ElevatedButton.icon(
                      onPressed: () => goTo(context, '/course-player'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        foregroundColor: AppColors.dark,
                      ),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Continue Learning'),
                    );
                    if (desktop) {
                      return Row(
                        children: [
                          Expanded(child: user),
                          const SizedBox(width: 30),
                          button,
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [user, const SizedBox(height: 22), button],
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
                  DashboardCard(value: '2', label: 'Active Courses'),
                  DashboardCard(value: '65%', label: 'Main Course Progress'),
                  DashboardCard(value: '7h', label: 'Learning Hours'),
                  DashboardCard(value: '1', label: 'Certificate Earned'),
                ],
              ),
            ),
            SectionWrapper(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final desktop = constraints.maxWidth > 850;
                  final course = Container(
                    padding: const EdgeInsets.all(27),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CURRENT COURSE',
                          style: TextStyle(
                            color: AppColors.blue,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.asset(
                                'assets/images/course_eq.jpg',
                                width: 150,
                                height: 125,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 18),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Emotional Intelligence Fundamentals',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    'Module 3 of 5 • Emotional Regulation in Practice',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 23),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '65%',
                              style: TextStyle(
                                color: AppColors.blue,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 9),
                        const LinearProgressIndicator(
                          value: 0.65,
                          minHeight: 11,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        const SizedBox(height: 22),
                        const ModuleStatusRow(
                          title: '1. Understanding Emotional Intelligence',
                          status: 'Completed',
                          completed: true,
                        ),
                        const ModuleStatusRow(
                          title: '2. Self-Awareness & Emotional Patterns',
                          status: 'Completed',
                          completed: true,
                        ),
                        const ModuleStatusRow(
                          title: '3. Emotional Regulation in Practice',
                          status: 'In progress',
                          current: true,
                        ),
                        const ModuleStatusRow(
                          title: '4. Empathy & Effective Communication',
                          status: 'Locked',
                        ),
                        const ModuleStatusRow(
                          title: '5. Applying EQ',
                          status: 'Locked',
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton.icon(
                          onPressed: () => goTo(context, '/course-player'),
                          icon: const Icon(Icons.play_circle_fill_rounded),
                          label: const Text('Continue Module 3'),
                        ),
                      ],
                    ),
                  );

                  final side = Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(26),
                        decoration: BoxDecoration(
                          color: AppColors.yellow,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Latest Result',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 13),
                            const Text(
                              'Module 2 Knowledge Check',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '4 / 5',
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Text('80% • Passed'),
                            const SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: () => goTo(context, '/learning-quiz'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.dark,
                                side: const BorderSide(color: AppColors.dark),
                              ),
                              child: const Text('Open Quiz'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(26),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Certificate',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              '1 certificate available from a completed demo course.',
                              style: TextStyle(
                                color: Colors.black54,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => goTo(context, '/certificate'),
                              icon: const Icon(Icons.workspace_premium_rounded),
                              label: const Text('View Certificate'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );

                  if (desktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: course),
                        const SizedBox(width: 22),
                        Expanded(flex: 4, child: side),
                      ],
                    );
                  }
                  return Column(
                    children: [course, const SizedBox(height: 22), side],
                  );
                },
              ),
            ),
            SectionWrapper(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Orders & Digital Resources',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 18),
                    const OrderRow(
                      order: '#MA1001',
                      item: 'Emotional Clarity Workbook',
                      date: '10 Sep 2026',
                      status: 'Available',
                    ),
                    const Divider(height: 30),
                    const OrderRow(
                      order: '#MA1002',
                      item: 'Mindfulness Journal',
                      date: '12 Sep 2026',
                      status: 'Shipped',
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

class ModuleStatusRow extends StatelessWidget {
  final String title;
  final String status;
  final bool completed;
  final bool current;

  const ModuleStatusRow({
    super.key,
    required this.title,
    required this.status,
    this.completed = false,
    this.current = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: current ? const Color(0xFFF1F4FF) : AppColors.background,
        borderRadius: BorderRadius.circular(15),
        border: current ? Border.all(color: AppColors.blue.withOpacity(0.2)) : null,
      ),
      child: Row(
        children: [
          Icon(
            completed
                ? Icons.check_circle_rounded
                : current
                ? Icons.play_circle_fill_rounded
                : Icons.lock_outline_rounded,
            color: completed || current ? AppColors.blue : Colors.black26,
            size: 20,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: current ? FontWeight.w800 : FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            status,
            style: TextStyle(
              color: current ? AppColors.blue : Colors.black45,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderRow extends StatelessWidget {
  final String order;
  final String item;
  final String date;
  final String status;

  const OrderRow({
    super.key,
    required this.order,
    required this.item,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 18,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            order,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        SizedBox(width: 280, child: Text(item)),
        SizedBox(width: 120, child: Text(date)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F4FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: const TextStyle(
              color: AppColors.blue,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// COURSE PLAYER
// ============================================================

class CoursePlayerPage extends StatefulWidget {
  const CoursePlayerPage({super.key});

  @override
  State<CoursePlayerPage> createState() => _CoursePlayerPageState();
}

class _CoursePlayerPageState extends State<CoursePlayerPage> {
  int activeModule = 2;
  bool completed = false;

  final modules = const [
    'Understanding Emotional Intelligence',
    'Self-Awareness & Emotional Patterns',
    'Emotional Regulation in Practice',
    'Empathy & Effective Communication',
    'Applying EQ at Work',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1250),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final desktop = constraints.maxWidth > 900;
                final sidebar = Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(27),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'COURSE CONTENT',
                        style: TextStyle(
                          color: AppColors.blue,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Emotional Intelligence Fundamentals',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...List.generate(
                        modules.length,
                            (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: index == activeModule
                                ? const Color(0xFFF1F4FF)
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(15),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () => setState(() => activeModule = index),
                              child: Padding(
                                padding: const EdgeInsets.all(13),
                                child: Row(
                                  children: [
                                    Icon(
                                      index < 2 || (index == 2 && completed)
                                          ? Icons.check_circle_rounded
                                          : index == activeModule
                                          ? Icons.play_circle_fill_rounded
                                          : Icons.circle_outlined,
                                      color: index <= activeModule
                                          ? AppColors.blue
                                          : Colors.black26,
                                      size: 19,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        '${index + 1}. ${modules[index]}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: index == activeModule
                                              ? FontWeight.w800
                                              : FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                final lesson = Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(27),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MODULE ${activeModule + 1}',
                        style: const TextStyle(
                          color: AppColors.blue,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        modules[activeModule],
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Container(
                        height: 330,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.dark,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.play_circle_fill_rounded,
                                color: AppColors.yellow,
                                size: 72,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Lesson Video Placeholder',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        'Lesson Overview',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'This representative lesson shows how MT Alchemy learning content can combine video, written explanation, reflection and downloadable resources. In this module, the learner explores practical ways to pause, recognize emotional triggers and choose a more intentional response.',
                        style: TextStyle(height: 1.75, color: Colors.black87),
                      ),
                      const SizedBox(height: 22),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F4FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.picture_as_pdf_rounded, color: AppColors.blue),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Reflection Worksheet.pdf',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                            Text(
                              'Demo resource',
                              style: TextStyle(fontSize: 11, color: Colors.black45),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          OutlinedButton.icon(
                            onPressed: activeModule == 0
                                ? null
                                : () => setState(() => activeModule--),
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('Previous'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => setState(() => completed = true),
                            icon: Icon(
                              completed
                                  ? Icons.check_circle_rounded
                                  : Icons.done_rounded,
                            ),
                            label: Text(
                              completed ? 'Marked Complete' : 'Mark Complete',
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: activeModule == modules.length - 1
                                ? null
                                : () => setState(() => activeModule++),
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: const Text('Next'),
                          ),
                          if (activeModule >= 1)
                            OutlinedButton.icon(
                              onPressed: () => goTo(context, '/learning-quiz'),
                              icon: const Icon(Icons.quiz_rounded),
                              label: const Text('Knowledge Check'),
                            ),
                        ],
                      ),
                    ],
                  ),
                );

                if (desktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 335, child: sidebar),
                      const SizedBox(width: 22),
                      Expanded(child: lesson),
                    ],
                  );
                }
                return Column(
                  children: [sidebar, const SizedBox(height: 22), lesson],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// BASIC QUIZ
// ============================================================

class LearningQuizPage extends StatefulWidget {
  const LearningQuizPage({super.key});

  @override
  State<LearningQuizPage> createState() => _LearningQuizPageState();
}

class _LearningQuizPageState extends State<LearningQuizPage> {
  final Map<int, int> answers = {};
  bool submitted = false;

  final questions = const [
    (
    'Which behaviour best demonstrates self-awareness?',
    [
      'Reacting immediately when frustrated',
      'Noticing your emotional trigger before responding',
      'Avoiding all difficult conversations',
      'Ignoring feedback from others',
    ],
    1
    ),
    (
    'Active listening is mainly about…',
    [
      'Preparing your next response',
      'Agreeing with everything',
      'Understanding the speaker before responding',
      'Ending the conversation quickly',
    ],
    2
    ),
    (
    'A useful first step in emotional regulation is…',
    [
      'Recognizing what you are feeling',
      'Blaming someone else',
      'Suppressing every emotion',
      'Changing the subject',
    ],
    0
    ),
  ];

  int get score {
    var total = 0;
    for (var i = 0; i < questions.length; i++) {
      if (answers[i] == questions[i].$3) total++;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SimplePageHero(
              eyebrow: 'ASSESSMENT',
              title: 'Module knowledge check.',
              description:
              'A representative quiz screen showing multiple-choice questions, scoring and feedback.',
            ),
            SectionWrapper(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  children: [
                    ...List.generate(
                      questions.length,
                          (index) => Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(27),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'QUESTION ${index + 1} OF ${questions.length}',
                              style: const TextStyle(
                                color: AppColors.blue,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 11),
                            Text(
                              questions[index].$1,
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 15),
                            ...List.generate(
                              questions[index].$2.length,
                                  (answerIndex) => RadioListTile<int>(
                                value: answerIndex,
                                groupValue: answers[index],
                                onChanged: submitted
                                    ? null
                                    : (value) {
                                  if (value != null) {
                                    setState(() => answers[index] = value);
                                  }
                                },
                                title: Text(questions[index].$2[answerIndex]),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            if (submitted) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: answers[index] == questions[index].$3
                                      ? const Color(0xFFEAF8EE)
                                      : const Color(0xFFFFF0F0),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  answers[index] == questions[index].$3
                                      ? 'Correct — this response reflects the learning objective.'
                                      : 'Review the module and try again. The correct option is highlighted in the course explanation.',
                                  style: const TextStyle(height: 1.45),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (!submitted)
                      ElevatedButton(
                        onPressed: answers.length < questions.length
                            ? null
                            : () => setState(() => submitted = true),
                        child: const Text('Submit Quiz'),
                      ),
                    if (submitted)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: AppColors.dark,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'YOUR RESULT',
                              style: TextStyle(
                                color: AppColors.yellow,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '$score / ${questions.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 46,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              score >= 2 ? 'Passed' : 'Review and retake',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      submitted = false;
                                      answers.clear();
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.white54),
                                  ),
                                  child: const Text('Retake Quiz'),
                                ),
                                ElevatedButton(
                                  onPressed: () => goTo(context, '/dashboard'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.yellow,
                                    foregroundColor: AppColors.dark,
                                  ),
                                  child: const Text('Back to Dashboard'),
                                ),
                              ],
                            ),
                          ],
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

// ============================================================
// CERTIFICATE
// ============================================================

class CertificatePage extends StatelessWidget {
  const CertificatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SectionWrapper(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1000),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(34),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 55,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: AppColors.dark, width: 2),
                  ),
                  child: Column(
                    children: [
                      Image.asset('assets/images/logo.png', height: 78),
                      const SizedBox(height: 28),
                      Text(
                        'Certificate of Completion',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 17),
                      const Text(
                        'This prototype certificate is awarded to',
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Demo Learner',
                        style: TextStyle(
                          color: AppColors.deepBlue,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('for completing'),
                      const SizedBox(height: 10),
                      const Text(
                        'Mindfulness at Work',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 18),
                      const Wrap(
                        spacing: 40,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          CertificateDetail(label: 'Completion date', value: '08 Oct 2026'),
                          CertificateDetail(label: 'Certificate ID', value: 'MT-DEMO-2026-001'),
                          CertificateDetail(label: 'Trainer', value: 'MT Alchemy'),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: AppColors.softGray,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.qr_code_2_rounded,
                            size: 66,
                            color: AppColors.dark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Verification QR placeholder',
                        style: TextStyle(fontSize: 10, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SectionWrapper(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Certificate download is a prototype action.'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Download Certificate'),
                  ),
                  OutlinedButton(
                    onPressed: () => goTo(context, '/dashboard'),
                    child: const Text('Back to My Learning'),
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

class CertificateDetail extends StatelessWidget {
  final String label;
  final String value;

  const CertificateDetail({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.black45, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

// ============================================================
// EMPLOYEE MANAGEMENT
// ============================================================

class EmployeeManagementPage extends StatelessWidget {
  const EmployeeManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SimplePageHero(
              eyebrow: 'EMPLOYER PORTAL',
              title: 'Employee management.',
              description:
              'A representative employer screen for adding learners, organizing departments and reviewing course progress.',
            ),
            SectionWrapper(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(27),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Employees',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Add Employee form would open here.'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.person_add_rounded),
                          label: const Text('Add Employee'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Employee')),
                          DataColumn(label: Text('Department')),
                          DataColumn(label: Text('Course')),
                          DataColumn(label: Text('Progress')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(Text('Employee A')),
                            DataCell(Text('HR')),
                            DataCell(Text('EQ Fundamentals')),
                            DataCell(Text('80%')),
                            DataCell(StatusPill(text: 'In Progress')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Employee B')),
                            DataCell(Text('Management')),
                            DataCell(Text('Leadership')),
                            DataCell(Text('100%')),
                            DataCell(StatusPill(text: 'Completed')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Employee C')),
                            DataCell(Text('Finance')),
                            DataCell(Text('Mindfulness')),
                            DataCell(Text('45%')),
                            DataCell(StatusPill(text: 'In Progress')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Employee D')),
                            DataCell(Text('Sales')),
                            DataCell(Text('Not assigned')),
                            DataCell(Text('—')),
                            DataCell(StatusPill(text: 'Available')),
                          ]),
                        ],
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

class StatusPill extends StatelessWidget {
  final String text;

  const StatusPill({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.blue,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// ============================================================
// COURSE ASSIGNMENT
// ============================================================

class CourseAssignmentPage extends StatefulWidget {
  const CourseAssignmentPage({super.key});

  @override
  State<CourseAssignmentPage> createState() => _CourseAssignmentPageState();
}

class _CourseAssignmentPageState extends State<CourseAssignmentPage> {
  String course = 'Emotional Intelligence Fundamentals';
  final selected = <String>{'HR', 'Management'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SimplePageHero(
              eyebrow: 'EMPLOYER PORTAL',
              title: 'Assign learning to your team.',
              description:
              'Select a course, choose employees or departments and set a prototype completion deadline.',
            ),
            SectionWrapper(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                padding: const EdgeInsets.all(34),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Course',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 9),
                    DropdownButtonFormField<String>(
                      value: course,
                      decoration: const InputDecoration(),
                      items: const [
                        DropdownMenuItem(
                          value: 'Emotional Intelligence Fundamentals',
                          child: Text('Emotional Intelligence Fundamentals'),
                        ),
                        DropdownMenuItem(
                          value: 'Leadership & Communication',
                          child: Text('Leadership & Communication'),
                        ),
                        DropdownMenuItem(
                          value: 'Mindfulness at Work',
                          child: Text('Mindfulness at Work'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => course = value);
                      },
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Assign to departments',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final dept in ['HR', 'Management', 'Finance', 'Sales'])
                          FilterChip(
                            label: Text(dept),
                            selected: selected.contains(dept),
                            onSelected: (value) {
                              setState(() {
                                if (value) {
                                  selected.add(dept);
                                } else {
                                  selected.remove(dept);
                                }
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Deadline',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 9),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: '30 October 2026',
                        suffixIcon: Icon(Icons.calendar_month_rounded),
                      ),
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '$course assigned to ${selected.length} department(s) — prototype only.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.assignment_turned_in_rounded),
                        label: const Text('Assign Course'),
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

// ============================================================
// LEARNING REPORTS
// ============================================================

class LearningReportsPage extends StatelessWidget {
  const LearningReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SimplePageHero(
              eyebrow: 'EMPLOYER REPORTS',
              title: 'See learning progress at a glance.',
              description:
              'A representative reporting dashboard for completion, scores, learning hours and department progress.',
            ),
            const SectionWrapper(
              child: Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  DashboardCard(value: '68%', label: 'Completion Rate'),
                  DashboardCard(value: '82%', label: 'Average Quiz Score'),
                  DashboardCard(value: '126h', label: 'Learning Hours'),
                  DashboardCard(value: '17', label: 'Certificates'),
                ],
              ),
            ),
            SectionWrapper(
              child: Container(
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
                        const Expanded(
                          child: Text(
                            'Department Progress',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _showExportMessage(context, 'PDF'),
                              icon: const Icon(Icons.picture_as_pdf_rounded),
                              label: const Text('PDF'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _showExportMessage(context, 'CSV'),
                              icon: const Icon(Icons.table_view_rounded),
                              label: const Text('CSV'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    const ProgressRow(label: 'Management', value: 0.88),
                    const SizedBox(height: 18),
                    const ProgressRow(label: 'HR', value: 0.79),
                    const SizedBox(height: 18),
                    const ProgressRow(label: 'Finance', value: 0.63),
                    const SizedBox(height: 18),
                    const ProgressRow(label: 'Sales', value: 0.52),
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

  static void _showExportMessage(BuildContext context, String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$format export is a prototype action.')),
    );
  }
}

// ============================================================
// TRAINER DASHBOARD
// ============================================================

class TrainerDashboardPage extends StatelessWidget {
  const TrainerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SimplePageHero(
              eyebrow: 'TRAINER PORTAL',
              title: 'Manage learning delivery and learner progress.',
              description:
              'Representative trainer access for assigned courses, learning materials, assessments and learner monitoring.',
            ),
            const SectionWrapper(
              child: Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  DashboardCard(value: '3', label: 'Assigned Courses'),
                  DashboardCard(value: '74', label: 'Active Learners'),
                  DashboardCard(value: '8', label: 'Assessments to Review'),
                  DashboardCard(value: '81%', label: 'Average Progress'),
                ],
              ),
            ),
            SectionWrapper(
              child: Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  AdminFeatureCard(
                    icon: Icons.menu_book_rounded,
                    title: 'Learning Materials',
                    text: 'Preview where trainers would manage lesson resources and course content.',
                    onTap: () => goTo(context, '/course-player'),
                  ),
                  AdminFeatureCard(
                    icon: Icons.quiz_rounded,
                    title: 'Assessments',
                    text: 'Review quizzes and learner results in a representative trainer workflow.',
                    onTap: () => goTo(context, '/learning-quiz'),
                  ),
                  AdminFeatureCard(
                    icon: Icons.groups_rounded,
                    title: 'Learners',
                    text: 'Monitor learner activity and course progress.',
                    onTap: () => goTo(context, '/reports'),
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
// ADMIN DASHBOARD
// ============================================================

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    const navigation = [
      'Dashboard',
      'Users',
      'Organizations',
      'Courses',
      'Modules',
      'Assessments',
      'Certificates',
      'Products',
      'Orders',
      'Payments',
      'Inventory',
      'Content',
      'Testimonials',
      'Impact Stories',
      'Reports',
      'Settings',
    ];

    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SimplePageHero(
              eyebrow: 'ADMIN PORTAL',
              title: 'Platform management overview.',
              description:
              'A representative administrator dashboard covering users, organizations, courses, products, orders, content and reporting.',
            ),
            const SectionWrapper(
              child: Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  DashboardCard(value: '128', label: 'Users'),
                  DashboardCard(value: '14', label: 'Organizations'),
                  DashboardCard(value: '12', label: 'Courses'),
                  DashboardCard(value: '38', label: 'Orders'),
                  DashboardCard(value: '9', label: 'Products'),
                  DashboardCard(value: '6', label: 'Draft Content Items'),
                ],
              ),
            ),
            SectionWrapper(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Admin Navigation',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: navigation
                          .map(
                            (item) => ActionChip(
                          avatar: const Icon(
                            Icons.settings_suggest_rounded,
                            size: 17,
                            color: AppColors.blue,
                          ),
                          label: Text(item),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$item management — prototype screen.'),
                              ),
                            );
                          },
                        ),
                      )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            SectionWrapper(
              child: Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  AdminFeatureCard(
                    icon: Icons.school_rounded,
                    title: 'Course Management',
                    text: 'Create, edit, publish and organize courses, modules and learning resources.',
                    onTap: () => goTo(context, '/learning'),
                  ),
                  AdminFeatureCard(
                    icon: Icons.inventory_2_rounded,
                    title: 'Product Management',
                    text: 'Manage digital and physical products, categories, stock and publication status.',
                    onTap: () => goTo(context, '/store'),
                  ),
                  AdminFeatureCard(
                    icon: Icons.receipt_long_rounded,
                    title: 'Order Management',
                    text: 'Review payment, order and shipping states for prototype customer purchases.',
                    onTap: () => goTo(context, '/cart'),
                  ),
                  AdminFeatureCard(
                    icon: Icons.article_rounded,
                    title: 'Content Management',
                    text: 'Manage articles, testimonials, impact stories and website content.',
                    onTap: () => goTo(context, '/insights'),
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

class AdminFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final VoidCallback onTap;

  const AdminFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
        width: 355,
        padding: const EdgeInsets.all(27),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(27),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: AppColors.dark),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(color: Colors.black54, height: 1.55),
            ),
            const SizedBox(height: 15),
            TextButton(onPressed: onTap, child: const Text('Open →')),
          ],
        ),
      ),
    );
  }
}
