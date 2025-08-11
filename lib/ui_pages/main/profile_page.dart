import 'package:flutter/material.dart';
import 'package:ternak_pro/shared/widgets/profile_setting_item.dart';

import '../../shared/theme.dart';
import '../../shared/widgets/custom_image_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(context),
            _pribadiSettings(context),
            _aplikasiSettings(context),
            _panduanSettings(context),
            _logOutSettings(context),
            SizedBox(height: 110), // Spacing at the bottom
          ],
        ),
      ),
    );
  }
}

Widget _buildHeaderSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.gradasi01,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        )
      ),
      child: Stack(
        children: [
          CustomImageView(
            imagePath: "assets/home_assets/images/img_star.png",
            height: MediaQuery.of(context).size.height * 0.2,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 90,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            border: BoxBorder.all(
                              color: AppColors.primaryWhite,
                              width: 0.3,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Image.asset('assets/profile_assets/icons/ic_farmer.png'),),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 23,
                              height: 23,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.primaryWhite,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Image.asset('assets/profile_assets/icons/ic_pencil.png'),
                              ),
                          ),
                      ],
                    ),
                    SizedBox(width: 17), 
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Peternakan',
                          style: AppTextStyle.medium.copyWith(fontSize: 20, color: AppColors.white100),
                        ),
                        Text(
                          'Khoiru Rizki Bani Adam',
                          style: AppTextStyle.extraBold.copyWith(
                            fontSize: MediaQuery.of(context).size.width * 0.01,  // Adjust font size dynamically
                            color: AppColors.white100,
                            overflow: TextOverflow.ellipsis,  // Ensures the text doesn't overflow
                          ),
                          maxLines: 1,  // Ensures the text is truncated in case of overflow
                        ),
                      ],
                    ),
                  ],
                ),
                
              ],
            ),
          ),
          Positioned(
            right: 5,
            bottom: 0,
            child: Row(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 12,),
                                CustomImageView(
                                  imagePath: "assets/home_assets/images/img_amelia_1_3.png",
                                  height: 28,
                                  width: 32,
                                ),
                              ],
                            ),
                            SizedBox(width: 8),
                            CustomImageView(
                              imagePath: "assets/home_assets/images/img_amelia_1_4.png",
                              height: 40,
                              width: 32,
                            ),
                          ],
                        ),
          ),
          Positioned(
            bottom: 0,
            left: 31,
            child: Row(
              children: [
                CustomImageView(
                  imagePath: "assets/home_assets/images/img_amelia_1_1.png",
                  height: 40,
                  width: 28,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Row(
              children: [
                CustomImageView(
                      imagePath: "assets/home_assets/images/img_amelia_1_2.png",
                      height: 36,
                      width: 32,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pribadiSettings(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 24, right: 24),
      transform: Matrix4.translationValues(0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengaturan Pribadi',
            style: AppTextStyle.semiBold.copyWith(fontSize: 16),
          ),
          SizedBox(height: 8),
          ProfileSettingItem(
            imageUrl: 'assets/profile_assets/icons/ic_user.png', 
            bgImage: Color(0XFFFFE0D5),
            menuName: 'Username', 
            placeHolder: 'Khoiru Rizki Bani Adam', 
            onTap: (){}
          ),
          ProfileSettingItem(
            imageUrl: 'assets/profile_assets/icons/ic_mail.png', 
            bgImage: Color(0XFFFFF0C8),
            menuName: 'Email', 
            placeHolder: 'Khoiruriski2354@gmail.com', 
            onTap: (){}
          ),
          ProfileSettingItem(
            imageUrl: 'assets/profile_assets/icons/ic_lock.png', 
            bgImage: Color(0XFFD4F4F1),
            menuName: 'Kata Sandi', 
            placeHolder: '********', 
            onTap: (){}
          ),
        ],
      ),
    );
  }

  Widget _aplikasiSettings(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 24, right: 24),
      transform: Matrix4.translationValues(0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengaturan Aplikasi',
            style: AppTextStyle.semiBold.copyWith(fontSize: 16),
          ),
          SizedBox(height: 8),
          ProfileSettingItem(
            imageUrl: 'assets/profile_assets/icons/ic_loc.png', 
            bgImage: Color(0XFFDCE8F7),
            menuName: 'Lokasi Ternak', 
            placeHolder: 'Sidoarjo,Jawa Timur', 
            onTap: (){}
          ),
          ProfileSettingItem(
            imageUrl: 'assets/profile_assets/icons/ic_bell.png', 
            bgImage: Color(0XFFFFF0C8),
            menuName: 'Pemberitahuan', 
            placeHolder: 'Izinkan', 
            onTap: (){}
          ),
          ProfileSettingItem(
            imageUrl: 'assets/profile_assets/icons/ic_mode.png', 
            bgImage: Color(0XFFF8D5FF),
            menuName: 'Mode Gelap', 
            placeHolder: 'Terang', 
            onTap: (){}
          ),
        ],
      ),
    );
  }

  Widget _panduanSettings(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 24, right: 24),
      transform: Matrix4.translationValues(0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Panduan Aplikasi',
            style: AppTextStyle.semiBold.copyWith(fontSize: 16),
          ),
          SizedBox(height: 8),
          ProfileSettingItem(
            imageUrl: 'assets/profile_assets/icons/ic_loc.png', 
            bgImage: Color(0XFFD5E7FF),
            menuName: 'FAQ', 
            placeHolder: '', 
            onTap: (){}
          ),
          ProfileSettingItem(
            imageUrl: 'assets/profile_assets/icons/ic_feature.png', 
            bgImage: Color(0XFFFFEDD5),
            menuName: 'Fitur', 
            placeHolder: '', 
            onTap: (){}
          ),
          ProfileSettingItem(
            imageUrl: 'assets/profile_assets/icons/ic_phone.png', 
            bgImage: Color(0XFFD5F8F7),
            menuName: 'Hubungi Kami', 
            placeHolder: '', 
            onTap: (){}
          ),
        ],
      ),
    );
  }

  Widget _logOutSettings(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 24, right: 24),
      transform: Matrix4.translationValues(0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          SizedBox(height: 8),
          
          ProfileSettingItem(
            imageUrl: 'assets/profile_assets/icons/ic_out.png', 
            bgImage: Color(0XFFFFE0D5),
            menuName: 'Keluar Akun', 
            placeHolder: '', 
            onTap: (){}
          ),
        ],
      ),
    );
  }

