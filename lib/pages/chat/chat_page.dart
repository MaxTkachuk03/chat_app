import 'package:chat_app/pages/pages.dart';
import 'package:chat_app/services/services.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key, required this.recieverEmail, required this.recieverId});

  final String recieverEmail;
  final String recieverId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final TextEditingController _messageController;

  final AuthServices _authServices = AuthServices();

  final ChatServices _chatServices = ChatServices();

  late final FocusNode myFocusNode;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _messageController = TextEditingController();
    myFocusNode = FocusNode();

    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(seconds: 1), () => scrollDown());
      }
    });
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(
          recieverId: widget.recieverId, message: _messageController.text);

      _messageController.clear();
    }

    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final senderId = _authServices.getCurrentUser()!.uid;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(widget.recieverEmail),
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: _chatServices.getMessage(
                      userId: senderId, otherUserId: widget.recieverId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.data == null) {
                      return const Text("No data!");
                    }
                    return ListView(
                      controller: _scrollController,
                      children: snapshot.data!.docs.map((doc) {
                        Map<String, dynamic> data =
                            doc.data() as Map<String, dynamic>;

                        bool isCurrentUser = data['senderId'] ==
                            _authServices.getCurrentUser()?.uid;

                        final Alignment aligment = isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft;
                        return Container(
                            alignment: aligment,
                            child: Column(
                              crossAxisAlignment: isCurrentUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                ChatBubble(
                                  message: data['message'],
                                  isCurrentUser: isCurrentUser,
                                ),
                              ],
                            ));
                      }).toList(),
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MyTextfield(
                    focusNode: myFocusNode,
                    hintText: 'Say something...',
                    obscureText: false,
                    controller: _messageController,
                  ),
                ),
                IconButton.filled(
                    iconSize: 30,
                    onPressed: sendMessage,
                    icon: const Icon(
                      Icons.arrow_upward_rounded,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
