part of 'main.dart';

/// The only global overlay. Keeps the Assistant available on every routed page.
class MTAlchemyRouteShell extends StatelessWidget {
  final Widget child;
  const MTAlchemyRouteShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.width < 600;
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        Positioned(
          right: compact ? 14 : 24,
          bottom: compact ? 14 : 22,
          child: const FloatingAssistantButton(),
        ),
      ],
    );
  }
}

class FloatingAssistantButton extends StatelessWidget {
  const FloatingAssistantButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Open MT Alchemy assistant',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showVirtualAssistant(context),
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.deepBlue,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.yellow, width: 2),
              boxShadow: [BoxShadow(
                color: AppColors.deepBlue.withOpacity(0.22),
                blurRadius: 17,
                offset: const Offset(0, 7),
              )],
            ),
            child: const Icon(Icons.chat_bubble_outline_rounded,
                color: AppColors.yellow, size: 26),
          ),
        ),
      ),
    );
  }
}

class _MTChatMessage {
  final String message;
  final bool fromVisitor;
  const _MTChatMessage(this.message, {this.fromVisitor = false});
}

/// Working FAQ chat preview. Not advertised as AI before a secure API is connected.
class MTAlchemyAssistantChatDialog extends StatefulWidget {
  final ValueChanged<String> onNavigate;
  const MTAlchemyAssistantChatDialog({super.key, required this.onNavigate});

  @override
  State<MTAlchemyAssistantChatDialog> createState() => _MTAlchemyAssistantChatDialogState();
}

class _MTAlchemyAssistantChatDialogState extends State<MTAlchemyAssistantChatDialog> {
  final input = TextEditingController();
  final scrollController = ScrollController();
  final messages = <_MTChatMessage>[
    const _MTChatMessage('Hi! Welcome to MT Alchemy. I can help you find courses, services and products. What would you like to explore?'),
  ];

  @override
  void dispose() {
    input.dispose();
    scrollController.dispose();
    super.dispose();
  }

  String _answerFor(String value) {
    final q = value.toLowerCase();
    if (q.contains('course') || q.contains('learn') || q.contains('training') || q.contains('study')) {
      return 'Visit Learning Hub to explore Emotional Intelligence, Mindfulness and Leadership courses. You can filter courses by topic.';
    }
    if (q.contains('certificate') || q.contains('quiz') || q.contains('test')) {
      return 'Courses include learning modules and quizzes. A certificate can be viewed after completing the required learning steps. Full progress tracking will be connected to Firebase.';
    }
    if (q.contains('company') || q.contains('business') || q.contains('team') || q.contains('corporate') || q.contains('employer')) {
      return 'MT Alchemy offers corporate solutions in emotional intelligence, leadership, communication, team development and well-being. Visit For Organizations to enquire.';
    }
    if (q.contains('store') || q.contains('buy') || q.contains('product') || q.contains('workbook') || q.contains('price')) {
      return 'You can browse digital resources and physical learning products in Store. Prices and checkout are currently demonstrative until the payment integration is ready.';
    }
    if (q.contains('contact') || q.contains('enquiry') || q.contains('help')) {
      return 'You can send an enquiry from our Contact page. Choose the service you are interested in and leave your message.';
    }
    if (q.contains('hello') || q.contains('hi') || q.contains('hey')) {
      return 'Hello! Try asking about courses, corporate services, certificates or the store.';
    }
    return 'I can help with courses, corporate programmes, learning certificates and the store. For a specific enquiry, please use our Contact page.';
  }

  void _send([String? suggested]) {
    final text = (suggested ?? input.text).trim();
    if (text.isEmpty) return;
    setState(() {
      messages.add(_MTChatMessage(text, fromVisitor: true));
      messages.add(_MTChatMessage(_answerFor(text)));
      input.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final narrow = size.width < 480;
    return Dialog(
      alignment: Alignment.bottomRight,
      insetPadding: EdgeInsets.fromLTRB(narrow ? 12 : 20, 12, narrow ? 12 : 23, 88),
      elevation: 12,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: SizedBox(
        width: narrow ? size.width - 24 : 380,
        height: size.height < 700 ? size.height * 0.65 : 520,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(18, 16, 12, 14),
              decoration: const BoxDecoration(
                color: AppColors.deepBlue,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Row(children: [
                const Icon(Icons.auto_awesome_rounded, color: AppColors.yellow),
                const SizedBox(width: 10),
                const Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MT Alchemy Assistant',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                    Text('Course & website FAQ',
                        style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                )),
                IconButton(
                  tooltip: 'Close assistant',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                ),
              ]),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final item = messages[index];
                  return Align(
                    alignment: item.fromVisitor ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      constraints: const BoxConstraints(maxWidth: 305),
                      decoration: BoxDecoration(
                        color: item.fromVisitor ? AppColors.iceBlue : AppColors.background,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(item.message, style: const TextStyle(fontSize: 13, height: 1.45)),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Wrap(spacing: 5, runSpacing: 5, children: [
                ActionChip(label: const Text('Courses'), onPressed: () => _send('Courses')),
                ActionChip(label: const Text('Corporate'), onPressed: () => _send('Corporate training')),
                ActionChip(label: const Text('Store'), onPressed: () => _send('Store products')),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
              child: Row(children: [
                Expanded(child: TextField(
                  controller: input,
                  onSubmitted: (_) => _send(),
                  textInputAction: TextInputAction.send,
                  decoration: InputDecoration(
                    hintText: 'Ask a question...',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                )),
                IconButton(
                  tooltip: 'Send message',
                  onPressed: () => _send(),
                  icon: const Icon(Icons.send_rounded, color: AppColors.blue),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 9),
              child: TextButton(
                onPressed: () => widget.onNavigate('/contact'),
                child: const Text('Need more help? Contact us'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
