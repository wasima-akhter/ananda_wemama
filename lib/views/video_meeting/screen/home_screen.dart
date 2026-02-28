import 'package:mama_app/app/helper_widgets_export.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBarContent(title: "Home Screen"),

      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Get.toNamed(RoutePaths.meetingScreen);
              },
              child: Text("Join Meeting"),
            ),

            Gap(itemGap * 3),
          ],
        ),
      ),
    );
  }
}
