part of "setting.page.dart";

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  _handleMoveToEditProfile() {
    context.push(RoutePaths.editProfile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
        actions: [
          IconButton(
              onPressed: _handleMoveToEditProfile, icon: const Icon(Icons.edit))
        ],
      ),
    );
  }
}
