import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import 'package:hobin_warehouse/src/constants/icon.dart';
import 'package:hobin_warehouse/src/constants/image_strings.dart';
import 'package:hobin_warehouse/src/constants/sizes.dart';
import 'package:hobin_warehouse/src/constants/text_strings.dart';
import 'package:hobin_warehouse/src/features/dashboard/controllers/account/profile_controller.dart';
import 'package:hobin_warehouse/src/features/authentication/models/user_models.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/account/update_profile_screen.dart';
import 'package:hobin_warehouse/src/features/dashboard/screens/account/widget/profile_menu_widget.dart';
import 'package:hobin_warehouse/src/repository/authentication_repository/authentication_repository.dart';

import '../../../../common_widgets/dialog/dialog.dart';
import 'information_profile_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final ProfileController controllerProfile = Get.find();
  late UserModel userAccountUpdate =
      UserModel(email: '', password: '', name: '', phone: '', photoURL: '');

  @override
  void initState() {
    userAccountUpdate = controllerProfile.userDataFrebase;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void logout(BuildContext context) {
      AuthenticationRepository.instance.logout();
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            backIcon,
            height: 20,
            color: whiteColor,
          ),
        ),
        backgroundColor: backGroundColor,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage(tBackGround1), // where is this variable defined?
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: const Text(
          tAppBarAccount,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w900, fontSize: 21),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: (userAccountUpdate.photoURL.isNotEmpty)
                      ? userAccountUpdate.photoURL
                      : tDefaultAvatar,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              userAccountUpdate.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              userAccountUpdate.email,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 230,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateProfileScreen(
                                  userData: userAccountUpdate,
                                  photoFb: userAccountUpdate.photoURL)))
                      .then((newvalue) {
                    print(newvalue);
                    if (newvalue == true) {
                      print('nhay vao true');
                    } else if (newvalue is UserModel) {
                      print('vao setState');
                      setState(() {
                        userAccountUpdate = newvalue;
                      });
                    } else {
                      print('nhay vao false');
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: pink500Color,
                    side: BorderSide.none,
                    shape: const StadiumBorder()),
                child: const Text(
                  'Sửa thông tin',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(), // căn giữa theo co
            //Menu
            ProfileMenuWidget(
              title: 'Thông tin tài khoản',
              imageicon: inforUserIcon,
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InformationProfileScreen(user: userAccountUpdate),
                    ));
              },
            ),

            ProfileMenuWidget(
              title: 'Thẻ tín dụng',
              imageicon: creditcardIcon,
              onPress: () {},
            ),

            ProfileMenuWidget(
              title: 'Cài đặt',
              imageicon: settingIcon,
              onPress: () {},
            ),

            ProfileMenuWidget(
              title: 'Đăng xuất',
              imageicon: signoutIcon,
              onPress: () {
                MyDialog.showAlertDialog(
                  context,
                  "Đăng xuất",
                  "Bạn muốn đăng xuất tài khoản?",
                  () => logout(context),
                );
                // AuthenticationRepository.instance.logout();
              },
            ),
          ],
        ),
      )),
    );
  }
}