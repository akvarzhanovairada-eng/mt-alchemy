part of 'main.dart';

/// Learning content based on MT Alchemy's EQ presentations and learner workbook.
/// External videos are supplementary and retain their original attribution.
class MTEQLessonContent {
  const MTEQLessonContent({
    required this.videoId,
    required this.videoTitle,
    required this.videoAuthor,
    required this.durationLabel,
    required this.objective,
    required this.keyPoints,
    required this.scenario,
    required this.practice,
    required this.source,
  });

  final String videoId;
  final String videoTitle;
  final String videoAuthor;
  final String durationLabel;
  final String objective;
  final List<String> keyPoints;
  final String scenario;
  final String practice;
  final String source;

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$videoId';
}

class MTEQLessons {
  static const modules = <MTEQLessonContent>[
    MTEQLessonContent(
      videoId: '6Sy2T_IX78o',
      videoTitle: 'What is emotional intelligence?',
      videoAuthor: 'The School of Life',
      durationLabel: 'Watch and reflect',
      objective: 'Describe emotional intelligence and connect its four skills to everyday decisions.',
      keyPoints: [
        'Emotional intelligence means recognising, understanding and working with emotional information. It does not mean suppressing difficult feelings.',
        'Perceiving emotions: notice how you and other people may be feeling.',
        'Using emotions: consider what feelings tell you about attention, motivation and priorities.',
        'Understanding emotions: explore causes and changes in feelings.',
        'Managing emotions: choose a constructive response instead of reacting automatically.',
      ],
      scenario: 'A colleague gives you unexpected criticism. You feel embarrassed. Instead of arguing, identify the feeling, ask what they meant and decide what feedback you can use.',
      practice: 'Think about a time you received feedback. What emotion did you notice, and what response would have been constructive?',
      source: 'MT Alchemy · Understanding Emotional Intelligence, slides 2–3',
    ),
    MTEQLessonContent(
      videoId: 'sCHI7polDEc',
      videoTitle: 'How to Identify + Manage Your Emotional Triggers',
      videoAuthor: 'Terri Cole',
      durationLabel: 'Extended video lesson',
      objective: 'Name emotions precisely, notice body signals and map an emotional trigger.',
      keyPoints: [
        'Replace a vague label such as “bad” with a more specific feeling: frustrated, overwhelmed, embarrassed or anxious.',
        'Look for body signals such as tension, faster breathing and changes in attention.',
        'Rate the intensity of the feeling from 1 (low) to 5 (strong).',
        'Map the sequence: situation → thought → emotion → reaction → better response.',
        'A trigger may prompt a strong reaction, but it does not determine what you must do next.',
      ],
      scenario: 'Your team leader changes the deadline. Your immediate thought is “They do not respect my time,” and you feel frustrated. Check the facts and ask for clarification.',
      practice: 'Write the situation, your first thought, the emotion you felt and one alternative explanation. You do not need to share your response.',
      source: 'MT Alchemy · Understanding Emotional Intelligence, slides 4–5; Self-Awareness and Emotional Triggers, slides 2–7; Learner Workbook, pp. 2–5',
    ),
    MTEQLessonContent(
      videoId: 'Uew5BbvmLks',
      videoTitle: 'How to manage your emotions',
      videoAuthor: 'TED-Ed',
      durationLabel: 'Short video lesson',
      objective: 'Use a pause, check your assumptions and choose a response with intention.',
      keyPoints: [
        'Emotions can influence attention and judgement. They are useful information, not the whole picture.',
        'Recognise: what am I feeling right now?',
        'Evaluate: what do I actually know, and what am I assuming?',
        'Decide: which action is most likely to help in this situation?',
        'A practical pause: stop, identify the emotion, understand the situation and choose your next action.',
      ],
      scenario: 'A teammate messages: “We need to talk about your part of the project.” You feel worried, but the message does not say what the discussion is about.',
      practice: 'Write one fact from the message, one assumption you made and one helpful question you could ask before responding.',
      source: 'MT Alchemy · Understanding Emotional Intelligence, slide 6; Learner Workbook, pp. 6–8',
    ),
    MTEQLessonContent(
      videoId: '1Evwgu369Jw',
      videoTitle: 'Brené Brown on Empathy',
      videoAuthor: 'RSA',
      durationLabel: 'Animated video lesson',
      objective: 'Practise empathy, active listening and clear, respectful communication.',
      keyPoints: [
        'Empathy involves trying to understand someone else’s perspective without claiming to know exactly how they feel.',
        'Give the speaker your attention and avoid interrupting.',
        'Ask open questions instead of immediately offering advice or making assumptions.',
        'Summarise the main point to check your understanding.',
        'Acknowledging a feeling does not require agreeing with every statement.',
      ],
      scenario: 'A colleague says, “I am struggling to manage my workload this week.” Instead of “Everyone is busy,” try: “That sounds difficult. Which task is creating the most pressure?”',
      practice: 'Write an empathetic response, one open question and a short sentence that checks you understood the other person.',
      source: 'MT Alchemy · Learner Workbook, p. 9',
    ),
    MTEQLessonContent(
      videoId: 'dCIgOYY4NKc',
      videoTitle: 'How to Lead with Emotional Intelligence',
      videoAuthor: 'Linda Raynier',
      durationLabel: 'Workplace application',
      objective: 'Apply emotional intelligence to teamwork, feedback and workplace conflict.',
      keyPoints: [
        'Notice your own reactions during difficult teamwork conversations.',
        'Listen to both perspectives before judging an issue.',
        'Separate specific facts (tasks, deadlines, expectations) from personal assumptions.',
        'Agree on concrete next steps and clear responsibilities.',
        'Build a practical action plan: one skill, one small action, a time to practise and a way to review progress.',
      ],
      scenario: 'Two employees disagree about missed deadlines. One says tasks are late; the other says expectations were unclear. Help them clarify responsibilities and agree on realistic next steps.',
      practice: 'Choose one EQ skill you will practise at work or study. Describe when you will use it and how you will know whether it helped.',
      source: 'MT Alchemy · Learner Workbook, pp. 10–12',
    ),
  ];
}

/// This widget is given a ValueKey(moduleIndex) so changing modules destroys
/// the previous controller and creates a new controller for the next video.
class MTVideoLesson extends StatefulWidget {
  const MTVideoLesson({super.key, required this.lesson});
  final MTEQLessonContent lesson;

  @override
  State<MTVideoLesson> createState() => _MTVideoLessonState();
}

class _MTVideoLessonState extends State<MTVideoLesson> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.lesson.videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        enableCaption: true,
        privacyEnhancedMode: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  Future<void> _openYoutube() async {
    final uri = Uri.parse(widget.lesson.youtubeUrl);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw StateError('Could not open YouTube');
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Open this link: ${widget.lesson.youtubeUrl}'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: ColoredBox(
          color: AppColors.dark,
          child: YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
        ),
      ),
      const SizedBox(height: 12),
      Wrap(spacing: 12, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(Icons.play_circle_outline_rounded, size: 20, color: AppColors.blue),
          Text(widget.lesson.videoTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
          Text('By ${widget.lesson.videoAuthor}',
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          TextButton.icon(
            onPressed: _openYoutube,
            icon: const Icon(Icons.open_in_new_rounded, size: 16),
            label: const Text('Open on YouTube'),
          ),
        ],
      ),
      const Text(
        'Supplementary video from an external creator. Playback requires an internet connection. '
            'If embedding is disabled by the uploader, use “Open on YouTube”.',
        style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.5),
      ),
    ]);
  }
}

class MTLessonStudyCards extends StatelessWidget {
  const MTLessonStudyCards({super.key, required this.lesson});
  final MTEQLessonContent lesson;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Learning objective',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      const SizedBox(height: 7),
      Text(lesson.objective, style: const TextStyle(height: 1.55)),
      const SizedBox(height: 22),
      const Text('Key ideas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      ...lesson.keyPoints.map((point) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
              padding: EdgeInsets.only(top: 3, right: 10),
              child: Icon(Icons.check_circle_outline_rounded, size: 19, color: AppColors.blue)),
          Expanded(child: Text(point, style: const TextStyle(height: 1.5))),
        ]),
      )),
      const SizedBox(height: 14),
      Container(
        padding: const EdgeInsets.all(18),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9DF),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFFFFE8A3)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('CASE TO CONSIDER', style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF845C00))),
          const SizedBox(height: 8),
          Text(lesson.scenario, style: const TextStyle(height: 1.55)),
        ]),
      ),
      const SizedBox(height: 11),
      Text('Based on: ${lesson.source}', style: const TextStyle(
          color: Colors.black54, fontSize: 12, height: 1.45)),
    ]);
  }
}

/// Private reflection notes: stored under the learner's own enrolment.
/// They are never shown in an employer's progress report.
class MTModuleReflection extends StatefulWidget {
  const MTModuleReflection({super.key, required this.moduleIndex, required this.prompt});
  final int moduleIndex;
  final String prompt;

  @override
  State<MTModuleReflection> createState() => _MTModuleReflectionState();
}

class _MTModuleReflectionState extends State<MTModuleReflection> {
  final TextEditingController _notes = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  String? _savedMessage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final existing = await MTReflectionService.fetch(widget.moduleIndex);
      if (!mounted) return;
      _notes.text = existing;
    } catch (error) {
      if (mounted) _savedMessage = 'Could not load saved notes: $error';
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() { _saving = true; _savedMessage = null; });
    try {
      await MTReflectionService.save(widget.moduleIndex, _notes.text.trim());
      if (mounted) setState(() => _savedMessage = 'Reflection saved privately to your account.');
    } catch (error) {
      if (mounted) setState(() => _savedMessage = 'Could not save reflection: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.iceBlue,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('PERSONAL REFLECTION', style: TextStyle(
            fontWeight: FontWeight.w900, color: AppColors.deepBlue, fontSize: 12)),
        const SizedBox(height: 8),
        Text(widget.prompt, style: const TextStyle(height: 1.5)),
        const SizedBox(height: 12),
        if (_loading)
          const LinearProgressIndicator(minHeight: 3)
        else ...[
          TextField(
            controller: _notes,
            enabled: !_saving,
            maxLines: 4,
            minLines: 3,
            maxLength: 2000,
            decoration: InputDecoration(
              hintText: 'Your private reflection... (optional)',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(spacing: 12, crossAxisAlignment: WrapCrossAlignment.center, children: [
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.save_outlined),
              label: Text(_saving ? 'Saving...' : 'Save reflection'),
            ),
            if (_savedMessage != null)
              Text(_savedMessage!, style: const TextStyle(fontSize: 12, color: AppColors.deepBlue)),
          ]),
          const SizedBox(height: 10),
          const Text('Your notes are optional and only accessible to your account. '
              'Save before leaving this module.', style: TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ]),
    );
  }
}

class MTReflectionService {
  static DocumentReference<Map<String, dynamic>> _ref(int index) {
    if (index < 0 || index >= MTEQLessons.modules.length) {
      throw RangeError.index(index, MTEQLessons.modules);
    }
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw StateError('Please log in first.');
    return FirebaseFirestore.instance
        .collection('enrollments').doc(uid)
        .collection('courses').doc(MTProgressService.courseId)
        .collection('reflections').doc('$index');
  }

  static Future<String> fetch(int index) async {
    final data = (await _ref(index).get()).data();
    return data?['text'] is String ? data!['text'] as String : '';
  }

  static Future<void> save(int index, String text) async {
    if (text.length > 2000) throw ArgumentError('Reflection is too long.');
    await _ref(index).set({
      'text': text,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
