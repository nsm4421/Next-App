part of "display_private_chat.page.dart";

class PrivateChatScreen extends StatefulWidget {
  const PrivateChatScreen({super.key});

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  late RealtimeChannel _channel;

  @override
  void initState() {
    super.initState();
    _channel = context.read<DisplayPrivateChatBloc>().getConversationChannel(
        onInsert: (message) {
      context
          .read<DisplayPrivateChatBloc>()
          .add(AwareNewPrivateChatEvent(message));
    }, onDelete: (message) {
      context
          .read<DisplayPrivateChatBloc>()
          .add(AwarePrivateChatDeletedEvent(message));
    }).subscribe();
  }

  @override
  void dispose() {
    super.dispose();
    _channel.unsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CHAT"),
        actions: [
          // test
          IconButton(
              onPressed: () {
                context.push(RoutePaths.privateChatRoom.path
                ,extra: PresenceEntity(
                      id:"dc8df4d0-01ab-48ff-8e5d-50f1907c6e22",
                      nickname: "test2@naver.com",
                      profileImage: "http://10.0.2.2:54321/storage/v1/object/public/profile-image/public/profile_image_dc8df4d0-01ab-48ff-8e5d-50f1907c6e22"
                    ));
              },
              icon: const Icon(Icons.people_alt_outlined)),
          IconButton(
              onPressed: () {
                context.push(RoutePaths.openChat.path);
              },
              icon: const Icon(Icons.people_alt_outlined))
        ],
      ),
      body: const LastPrivateChatListFragment(),
    );
  }
}
