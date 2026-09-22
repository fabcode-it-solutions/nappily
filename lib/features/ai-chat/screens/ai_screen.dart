import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notizen/features/ai-chat/controller/ai_controller.dart';

class ChatModal extends ConsumerStatefulWidget {
  final String userId;
  const ChatModal({super.key, required this.userId});

  @override
  ConsumerState<ChatModal> createState() => _ChatModalState();
}

class _ChatModalState extends ConsumerState<ChatModal> {
  final TextEditingController _controller = TextEditingController();
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    ref.read(aiMessagesProvider.notifier).loadHistory(widget.userId);
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _sheetController.animateTo(
          1.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(aiMessagesProvider);

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 1.0,
      snapAnimationDuration: Duration(milliseconds: 300),
      builder: (context, scrollController) {
        _scrollToBottom(scrollController);
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F0D1D), Color(0xFF443B83)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              minWidth:
                  MediaQuery.of(context).size.width -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              children: [
                _chatHeader(context),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (_, index) {
                      final msg = messages[index];
                      return Row(
                        mainAxisAlignment:
                            msg.isUser
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!msg.isUser)
                            const ImageIcon(
                              AssetImage(
                                'assets/images/icons/ai-chat-icon.png',
                              ),
                              color: Color(0X805CA99F),
                              size: 42,
                            ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              elevation: 0,
                              color: const Color(0X1A5CA99F),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child:
                                    msg.isTyping
                                        ? const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              "Typing...",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        )
                                        : Text(
                                          msg.text,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          if (msg.isUser)
                            const ImageIcon(
                              AssetImage(
                                'assets/images/icons/user-chat-icon.png',
                              ),
                              color: Color(0X805CA99F),
                              size: 30,
                            ),
                        ],
                      );
                    },
                  ),
                ),
                _chatFooter(scrollController),
              ],
            ),
          ),
        );
      },
    );
  }

  Row _chatFooter(ScrollController scrollController) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: TextField(
              focusNode: _focusNode,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type your message...",
                hintStyle: TextStyle(
                  color: Color(0X80FFFFFF),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  fontFamily: "Poppins",
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(color: Colors.white, width: 1),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(color: Colors.white, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(color: Colors.white, width: 1),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: CircleAvatar(
            backgroundColor: Color(0XFF5CA99F),
            radius: 22,
            child: IconButton(
              icon: Icon(Icons.send, color: Color(0XFFFFFFFF), size: 25),
              onPressed: () {
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  ref
                      .read(aiMessagesProvider.notifier)
                      .sendMessage(text, widget.userId);
                  _controller.clear();
                  _scrollToBottom(scrollController);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Row _chatHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: ImageIcon(
            AssetImage('assets/images/icons/close-icon.png'),
            color: Color(0X80FFFFFF),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        Text(
          'Chat with AI',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: "Poppins",
          ),
        ),
        IconButton(
          icon: ImageIcon(
            AssetImage('assets/images/icons/history-icon.png'),
            color: Color(0X80FFFFFF),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  void _scrollToBottom(ScrollController scrollController) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
