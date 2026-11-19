// UI-06 Nail Muse AI (FR-09, FR-10, FR-AI-02, FR-AI-03, FR-AI-04).
// Demo version: answers come from fixed text, not from OpenAI yet (M3).
// The AI is a guide only. The owner confirms the final design and price.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../providers/app_provider.dart';
import '../../../widgets/switch_role_button.dart';

class _ChatMessage {
  final String text;
  final bool fromUser;
  // null = no feedback yet, true = helpful, false = not helpful
  bool? helpful;

  _ChatMessage(this.text, {required this.fromUser});
}

class NailMuseAiScreen extends StatefulWidget {
  const NailMuseAiScreen({super.key});

  @override
  State<NailMuseAiScreen> createState() => _NailMuseAiScreenState();
}

class _NailMuseAiScreenState extends State<NailMuseAiScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      'Hi! I can help with prices, hours and deposit. '
      'Tap a button or type your question.',
      fromUser: false,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  String _priceAnswer() {
    final services = context.read<AppProvider>().services;
    if (services.isEmpty) {
      return 'Prices are not ready yet. Please check again later.';
    }
    final lines = services
        .map((s) => '${s.serviceName}: RM${s.servicePrice.toStringAsFixed(0)}')
        .join('\n');
    return 'Our prices:\n$lines\n\n'
        'This is a price guide. Ms. Michelle confirms the final price.';
  }

  String _answerFor(String question) {
    final q = question.toLowerCase();
    if (q.contains('price') ||
        q.contains('cost') ||
        q.contains('how much') ||
        q.contains('harga')) {
      return _priceAnswer();
    }
    if (q.contains('hour') ||
        q.contains('open') ||
        q.contains('time') ||
        q.contains('waktu')) {
      return 'Opening hours are being confirmed with the salon. '
          'Please see the available times on the Date and Time screen.';
    }
    if (q.contains('deposit') ||
        q.contains('cancel') ||
        q.contains('48')) {
      return 'The deposit is at least 20% of the service price. '
          'You pay it outside the app.\n\n'
          'Cancel at least 48 hours before your appointment. '
          'If you cancel less than 48 hours before, the deposit is not returned.';
    }
    return 'Sorry, I can only help with prices, hours and deposit now. '
        'Please try one of the buttons.';
  }

  void _send(String text) {
    final question = text.trim();
    if (question.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(question, fromUser: true));
      _messages.add(_ChatMessage(_answerFor(question), fromUser: false));
    });
    _controller.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _setFeedback(_ChatMessage message, bool helpful) {
    setState(() {
      message.helpful = helpful;
    });
  }

  Widget _chip(String label) {
    return ActionChip(
      label: Text(label),
      backgroundColor: AppColors.skyTint,
      labelStyle: const TextStyle(
        color: AppColors.nightBordeaux,
        fontWeight: FontWeight.w600,
      ),
      onPressed: () => _send(label),
    );
  }

  Widget _bubble(_ChatMessage m) {
    final fromUser = m.fromUser;
    return Align(
      alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: fromUser ? AppColors.nightBordeaux : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: fromUser ? null : Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              m.text,
              style: TextStyle(
                color: fromUser ? Colors.white : AppColors.ink,
              ),
            ),
            if (!fromUser) ...[
              const SizedBox(height: 6),
              if (m.helpful == null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Helpful?',
                      style: TextStyle(fontSize: 12),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Helpful',
                      icon: const Icon(Icons.thumb_up_alt_outlined, size: 18),
                      onPressed: () => _setFeedback(m, true),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Not helpful',
                      icon:
                          const Icon(Icons.thumb_down_alt_outlined, size: 18),
                      onPressed: () => _setFeedback(m, false),
                    ),
                  ],
                )
              else
                const Text(
                  'Thanks for your feedback.',
                  style: TextStyle(fontSize: 12, color: AppColors.sage),
                ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ivoryMist,
      appBar: AppBar(
        backgroundColor: AppColors.nightBordeaux,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Nail Muse AI'),
        actions: const [SwitchRoleButton()],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.skyTint,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              'AI answers are a guide only. '
              'Ms. Michelle confirms the final design and price.',
              style: TextStyle(fontSize: 12, color: AppColors.nightBordeaux),
            ),
          ),
          Expanded(
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.all(16),
              children: _messages.map(_bubble).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: [
                _chip('Prices'),
                _chip('Hours'),
                _chip('Deposit'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _send,
                    decoration: InputDecoration(
                      hintText: 'Ask a question',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.nightBordeaux,
                  ),
                  tooltip: 'Send',
                  icon: const Icon(Icons.send),
                  onPressed: () => _send(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
