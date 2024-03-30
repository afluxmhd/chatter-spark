import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controller/chat_controller.dart';
import 'services/firebase/firebase_chat_services.dart';
import 'util.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({
    super.key,
    required this.room,
    required this.user,
  });

  final types.Room room;
  final String user;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final textEditingController = TextEditingController();
  bool isLoading = false;
  bool isAnalyzed = false;

  void _handleTextAnalyzePress() async {
    await ref
        .read(chatControllerProvider.notifier)
        .analyzeAndFixSentence(context: context, text: textEditingController.text.trim())
        .then((value) {
      if (value.isNotEmpty) {
        setState(() {
          textEditingController.text = value;
          isAnalyzed = true;
        });
      }
    });
  }

  void _handleSendPressed(types.PartialText message) {
    textEditingController.clear();
    FirebaseChatServer.sendMessage(message, widget.room.id);
    isAnalyzed = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    isLoading = ref.watch(chatControllerProvider);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        toolbarHeight: 70,
        centerTitle: true,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone),
          ),
          const SizedBox(width: 10),
        ],
        title: Column(
          children: [
            Text(
              widget.user,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              convertToLastSeenString(widget.room.updatedAt),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, color: Colors.blueGrey),
            ),
          ],
        ),
      ),
      body: StreamBuilder<types.Room>(
        initialData: widget.room,
        stream: FirebaseChatCore.instance.room(widget.room.id),
        builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
          initialData: const [],
          stream: FirebaseChatCore.instance.messages(snapshot.data!),
          builder: (context, snapshot) => Chat(
            messages: snapshot.data ?? [],
            onSendPressed: _handleSendPressed,
            onMessageTap: (context, message) {},
            customBottomWidget: Input(
              onSendPressed: _handleSendPressed,
              onAttachmentPressed: _handleTextAnalyzePress,
              options: InputOptions(
                inputClearMode: InputClearMode.always,
                textEditingController: textEditingController,
              ),
            ),
            onMessageLongPress: (ctx, message) {},
            theme: DefaultChatTheme(
              inputBackgroundColor: Colors.white,
              inputTextColor: Colors.black87,
              attachmentButtonIcon: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.deepPurple, strokeWidth: 2),
                    )
                  : Icon(Icons.flash_on_outlined, color: isAnalyzed ? Colors.green : Colors.deepPurple),
              inputContainerDecoration: BoxDecoration(
                border: Border.all(width: 0.2, color: Colors.blueGrey),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                ),
              ),
            ),
            user: types.User(
              id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
            ),
          ),
        ),
      ),
    );
  }
}
