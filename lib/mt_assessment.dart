part of 'main.dart';

/// EQ assessment: the fixed answer key is checked again in Firestore Rules.
/// Minimum passing score: 6 / 8 (75%). A student can retake it.
class MTQuestion {
  const MTQuestion(this.id, this.question, this.options, this.answer, this.explanation);
  final String id;
  final String question;
  final List<String> options;
  final int answer;
  final String explanation;
}

class MTAssessmentService {
  static const requiredCorrect = 6;
  static const questions = <MTQuestion>[
    MTQuestion('q1', 'Which best describes emotional intelligence?', [
      'Hiding emotions from others',
      'Recognising, understanding and responding constructively to emotions',
      'Always feeling positive',
      'Avoiding difficult conversations',
    ], 1, 'EQ includes awareness, understanding and constructive responses.'),
    MTQuestion('q2', 'What should you do first when an emotional trigger occurs?', [
      'Immediately respond to the other person',
      'Ignore the situation entirely',
      'Notice and name the emotion you feel',
      'Assume your first interpretation is correct',
    ], 2, 'Identifying the feeling creates a useful pause before acting.'),
    MTQuestion('q3', 'Your teammate sends a message that makes you anxious. What is the best response?', [
      'Pause, check your assumptions and ask for clarification',
      'Send an angry reply immediately',
      'Tell everyone they are being unfair',
      'Stop communicating with the teammate',
    ], 0, 'Separate what you know from what you assume.'),
    MTQuestion('q4', 'Which action demonstrates empathy?', [
      'Agreeing with everything someone says',
      'Changing the subject to your own experience',
      'Giving advice before listening',
      'Listening carefully and trying to understand their perspective',
    ], 3, 'Empathy involves understanding others, not automatic agreement.'),
    MTQuestion('q5', 'What is a constructive way to respond to difficult feedback?', [
      'Reject the feedback without listening',
      'Ask for a concrete example and reflect before responding',
      'Assume the person dislikes you',
      'Avoid the person afterwards',
    ], 1, 'Clarifying feedback makes it easier to learn from it.'),
    MTQuestion('q6', 'Which activity develops self-awareness?', [
      'Recording your emotions, triggers and reactions',
      'Blaming others for every setback',
      'Suppressing all negative emotions',
      'Avoiding reflection after conflict',
    ], 0, 'Reflection helps you identify repeated emotional patterns.'),
    MTQuestion('q7', 'A manager notices tension during a meeting. What is the most emotionally intelligent next step?', [
      'Ignore the tension and rush the discussion',
      'Assume everyone is upset for the same reason',
      'Invite respectful discussion and listen to different perspectives',
      'Announce a decision without further questions',
    ], 2, 'Good communication checks the situation instead of guessing.'),
    MTQuestion('q8', 'How can EQ support teamwork?', [
      'By removing all disagreements',
      'By making technical knowledge unnecessary',
      'By guaranteeing every decision is correct',
      'By improving communication, trust and conflict management',
    ], 3, 'EQ complements technical skills through better human interaction.'),
  ];

  static User get _user {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('Please log in first.');
    return user;
  }

  static DocumentReference<Map<String, dynamic>> get _assessmentRef =>
      FirebaseFirestore.instance.collection('assessments').doc(_user.uid)
          .collection('courses').doc(MTProgressService.courseId);

  static DocumentReference<Map<String, dynamic>> get _certificateRef =>
      FirebaseFirestore.instance.collection('certificates').doc(_user.uid)
          .collection('courses').doc(MTProgressService.courseId);

  static Stream<DocumentSnapshot<Map<String, dynamic>>> watchResult() => _assessmentRef.snapshots();
  static Stream<DocumentSnapshot<Map<String, dynamic>>> watchCertificate() => _certificateRef.snapshots();

  static Future<int> submit(Map<String, int> chosen) async {
    if (chosen.length != questions.length) throw StateError('Please answer all questions.');
    final progress = await MTProgressService.fetch();
    if (progress == null || !progress.lessonsFinished) {
      throw StateError('Finish all five modules before taking the final quiz.');
    }
    final result = <String, String>{};
    var score = 0;
    for (final question in questions) {
      final choice = chosen[question.id];
      if (choice == null || choice < 0 || choice > 3) {
        throw StateError('Please answer all questions.');
      }
      final answer = String.fromCharCode(65 + choice);
      result[question.id] = answer;
      if (choice == question.answer) score++;
    }
    final ref = _assessmentRef;
    await FirebaseFirestore.instance.runTransaction<void>((tx) async {
      final existing = await tx.get(ref);
      final old = existing.data() ?? const <String, dynamic>{};
      final previousBest = (old['bestScore'] as int?) ?? 0;
      final previousCount = (old['attemptCount'] as int?) ?? 0;
      final best = score > previousBest ? score : previousBest;
      tx.set(ref, {
        'answers': result,
        'latestScore': score,
        'bestScore': best,
        'total': questions.length,
        'passed': best >= requiredCorrect,
        'attemptCount': previousCount + 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
    final saved = await ref.get();
    final savedData = saved.data() ?? const <String, dynamic>{};
    await FirebaseFirestore.instance.collection('courseRoster').doc(MTProgressService.courseId)
        .collection('learners').doc(_user.uid).set({
      'bestScore': savedData['bestScore'] ?? score,
      'latestScore': score,
      'passed': savedData['passed'] ?? (score >= requiredCorrect),
      'attemptCount': savedData['attemptCount'] ?? 1,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return score;
  }

  static Future<void> issueCertificate() async {
    final user = _user;
    final progress = await MTProgressService.fetch();
    if (progress == null || !progress.lessonsFinished) {
      throw StateError('Complete all five lessons first.');
    }
    final score = await _assessmentRef.get();
    if (score.data()?['passed'] != true) throw StateError('Pass the assessment first.');
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final name = (userDoc.data()?['name'] as String?)?.trim() ?? '';
    if (name.isEmpty) throw StateError('Your profile name is required.');
    final ref = _certificateRef;
    await FirebaseFirestore.instance.runTransaction<void>((tx) async {
      final existing = await tx.get(ref);
      if (!existing.exists) {
        tx.set(ref, {
          'userId': user.uid,
          'courseId': MTProgressService.courseId,
          'courseTitle': MTProgressService.courseName,
          'name': name,
          'certificateId': 'MT-EQ-${user.uid}',
          'issuedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }
}

class MTAssessmentPage extends StatefulWidget {
  const MTAssessmentPage({super.key});
  @override
  State<MTAssessmentPage> createState() => _MTAssessmentPageState();
}

class _MTAssessmentPageState extends State<MTAssessmentPage> {
  final answers = <String, int>{};
  bool sending = false;
  String? error;
  int? latest;

  Future<void> _submit() async {
    setState(() { sending = true; error = null; });
    try {
      final score = await MTAssessmentService.submit(answers);
      if (!mounted) return;
      setState(() => latest = score);
      if (score >= MTAssessmentService.requiredCorrect) {
        await MTAssessmentService.issueCertificate();
      }
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SiteHeader(),
      body: SingleChildScrollView(child: Column(children: [
        const SimplePageHero(eyebrow: 'FINAL ASSESSMENT',
            title: 'Show what you have learned.',
            description: 'Eight questions · Pass with at least 6 correct answers · Your best score is saved to Firebase.'),
        SectionWrapper(child: StreamBuilder<MTProgress?>(
          stream: MTProgressService.watch(),
          builder: (context, progressSnapshot) {
            if (progressSnapshot.hasError) return const Text('Could not load learning progress.');
            if (!progressSnapshot.hasData && progressSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (progressSnapshot.data?.lessonsFinished != true) {
              return Column(children: [
                const Text('Complete all five course modules to unlock this quiz.',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                const SizedBox(height: 18),
                FilledButton(onPressed: () => goTo(context, '/course-player'), child: const Text('Continue learning')),
              ]);
            }
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: MTAssessmentService.watchResult(),
                builder: (context, snapshot) {
                  final data = snapshot.data?.data();
                  if (data == null) return const SizedBox.shrink();
                  return Card(child: Padding(padding: const EdgeInsets.all(18),
                      child: Text('Your saved best score: ${data['bestScore']}/8  •  Attempts: ${data['attemptCount']}',
                          style: const TextStyle(fontWeight: FontWeight.w800))));
                },
              ),
              ...MTAssessmentService.questions.map((question) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(padding: const EdgeInsets.all(20), child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${MTAssessmentService.questions.indexOf(question) + 1}. ${question.question}',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    ...List.generate(4, (i) => RadioListTile<int>(
                      contentPadding: EdgeInsets.zero,
                      title: Text(question.options[i]),
                      value: i,
                      groupValue: answers[question.id],
                      onChanged: sending ? null : (v) => setState(() => answers[question.id] = v!),
                    )),
                    if (latest != null) Text(question.explanation,
                        style: const TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                  ))),
              ),
              const SizedBox(height: 14),
              if (error != null) Padding(padding: const EdgeInsets.only(bottom: 14),
                  child: Text(error!, style: const TextStyle(color: Colors.red))),
              if (latest != null) Card(color: AppColors.iceBlue,
                  child: Padding(padding: const EdgeInsets.all(18), child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Latest attempt: $latest/8',
                        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                    Text(latest! >= MTAssessmentService.requiredCorrect
                        ? 'Passed! Your certificate is ready.'
                        : 'Not yet passed. Review the lesson and try again.'),
                    if (latest! >= MTAssessmentService.requiredCorrect) ...[
                      const SizedBox(height: 10),
                      FilledButton.icon(onPressed: () => goTo(context, '/certificate'),
                          icon: const Icon(Icons.workspace_premium_outlined),
                          label: const Text('View my certificate')),
                    ],
                  ]))),
              FilledButton.icon(onPressed: sending || answers.length != 8 ? null : _submit,
                  icon: const Icon(Icons.fact_check_outlined),
                  label: Text(sending ? 'Saving result...' : 'Submit assessment')),
              const SizedBox(height: 20),
            ]);
          },
        )),
        const SiteFooter(),
      ])),
    );
  }
}

class MTCertificatePage extends StatelessWidget {
  const MTCertificatePage({super.key});

  Future<void> _download(Map<String, dynamic> certificate) async {
    final doc = pw.Document();
    final date = certificate['issuedAt'] is Timestamp
        ? (certificate['issuedAt'] as Timestamp).toDate() : DateTime.now();
    final dateText = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    doc.addPage(pw.Page(build: (context) => pw.Center(child: pw.Container(
      padding: const pw.EdgeInsets.all(35),
      decoration: pw.BoxDecoration(border: pw.Border.all(width: 2)),
      child: pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
        pw.Text('MT ALCHEMY', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 20),
        pw.Text('CERTIFICATE OF COMPLETION', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 20),
        pw.Text('Awarded to'),
        pw.SizedBox(height: 8),
        pw.Text('${certificate['name']}', style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 14),
        pw.Text('for successfully completing'),
        pw.SizedBox(height: 8),
        pw.Text(MTProgressService.courseName, style: pw.TextStyle(fontSize: 20)),
        pw.SizedBox(height: 25),
        pw.Text('Issued: $dateText'),
        pw.Text('ID: ${certificate['certificateId']}', style: const pw.TextStyle(fontSize: 9)),
        pw.SizedBox(height: 10),
        pw.Text('MT Alchemy · Educational project certificate', style: const pw.TextStyle(fontSize: 9)),
      ]),
    ))));
    await Printing.sharePdf(bytes: await doc.save(), filename: 'MT_Alchemy_EQ_Certificate.pdf');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const SiteHeader(),
    body: SingleChildScrollView(child: Column(children: [
      const SimplePageHero(eyebrow: 'MY CERTIFICATE',
          title: 'Celebrate your progress.',
          description: 'A certificate is issued after all modules and a passing assessment.'),
      SectionWrapper(child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: MTAssessmentService.watchCertificate(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Text('Could not load your certificate.');
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final certificate = snapshot.data?.data();
          if (certificate == null) {
            return Column(children: [
              const Icon(Icons.lock_outline_rounded, size: 48, color: AppColors.blue),
              const SizedBox(height: 12),
              const Text('Your certificate is not issued yet.'),
              const SizedBox(height: 12),
              FilledButton(onPressed: () => goTo(context, '/learning-quiz'),
                  child: const Text('Complete final assessment')),
            ]);
          }
          final ts = certificate['issuedAt'];
          final dt = ts is Timestamp ? ts.toDate() : null;
          return Column(children: [
            Container(padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(28)),
              child: Container(width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  decoration: BoxDecoration(color: Colors.white,
                      borderRadius: BorderRadius.circular(18)),
                  child: Column(children: [
                    Image.asset('assets/images/logo.png', height: 80),
                    const SizedBox(height: 20),
                    const Text('Certificate of Completion', textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    const Text('Presented to'),
                    const SizedBox(height: 12),
                    Text('${certificate['name']}', textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.deepBlue, fontSize: 27,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    const Text('for completing Emotional Intelligence Fundamentals'),
                    const SizedBox(height: 20),
                    Text('Certificate ID: ${certificate['certificateId']}', textAlign: TextAlign.center),
                    if (dt != null) Text('Issued: ${dt.day}/${dt.month}/${dt.year}'),
                  ])),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(onPressed: () async {
              try {
                await _download(certificate);
              } catch (e) {
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not export PDF: $e')));
              }
            }, icon: const Icon(Icons.picture_as_pdf_outlined),
                label: const Text('Download PDF certificate')),
          ]);
        },
      )),
      const SiteFooter(),
    ])),
  );
}
