import 'package:flutter/material.dart';

import '../../shared/theme.dart';
import '../../shared/widgets/custom_image_view.dart';

// Data model untuk notifikasi
class NotificationData {
  final int id;
  final String title;
  final String message;
  final String iconPath;
  bool isRead;

  NotificationData({
    required this.id,
    required this.title,
    required this.message,
    required this.iconPath,
    this.isRead = false,
  });
}

// Header dengan ikon back
Widget _buildHeaderSection(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.12,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: AppColors.gradasi01,
    ),
    child: Stack(
      children: [
        CustomImageView(
          imagePath: "assets/home_assets/images/img_star.png",
          height: MediaQuery.of(context).size.height * 0.12,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 60,
          left: 24,
          right: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Back Icon Button
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Image.asset(
                      'assets/data_ternak_assets/icons/ic_back.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  SizedBox(width: 10),
                  // Title Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notifikasi',
                        style: AppTextStyle.medium.copyWith(
                          fontSize: 20,
                          color: AppColors.white100,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              // More Icon Button
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.more_horiz,
                  color: AppColors.white100,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Fungsi untuk menampilkan custom modal dengan detail notifikasi
Future<void> showNotificationDetailDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String iconPath,
  required VoidCallback onRead,
}) async {
  await showDialog(
    context: context,
    barrierColor: Colors.black.withAlpha(89),
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.bgLight,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        contentPadding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tombol close
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        onRead(); // Tandai sebagai dibaca saat modal dibuka
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                // Ikon notifikasi
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: AppColors.gradasi01WithOpacity20,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: CustomImageView(
                        imagePath: iconPath,
                        height: 34,
                        width: 34,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                // Judul notifikasi
                Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.semiBold.copyWith(
                      fontSize: 18,
                      color: AppColors.black100,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Pesan notifikasi lengkap
                Text(
                  message,
                  style: AppTextStyle.medium.copyWith(
                    fontSize: 14,
                    color: AppColors.black100,
                  ),
                ),
                const SizedBox(height: 16),
                // Tombol tutup
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Material(
                      color: Colors.transparent,
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: AppColors.gradasi01,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            onRead(); // Tandai sebagai dibaca saat tombol tutup diklik
                            Navigator.of(context).pop();
                          },
                          child: const Center(
                            child: Text(
                              'Tutup',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  // Data dummy notifikasi
  final List<NotificationData> notifications = [
    NotificationData(
      id: 1,
      title: 'Vaksin Ternak',
      message:
          'Jangan lupa! Vaksinasi sapi Anda dijadwalkan hari ini. Pastikan ternak tetap sehat 💉🐄. Pastikan Anda menyiapkan vaksin yang diperlukan dan konsultasikan dengan dokter hewan untuk jadwal yang tepat.',
      iconPath: 'assets/home_assets/icons/ic_shield.png',
      isRead: false,
    ),
    NotificationData(
      id: 2,
      title: 'Pemeriksaan Kesehatan',
      message:
          'Jadwal pemeriksaan kesehatan ternak mingguan akan dilakukan besok. Siapkan kandang dan catatan kesehatan ternak Anda.',
      iconPath: 'assets/home_assets/icons/ic_snack.png',
      isRead: false,
    ),
    NotificationData(
      id: 3,
      title: 'Pembaruan Pakan',
      message:
          'Stok pakan ternak hampir habis. Segera lakukan pembelian untuk memastikan ketersediaan pakan minggu depan.',
      iconPath: 'assets/home_assets/icons/ic_cow.png',
      isRead: false,
    ),
  ];

  // Fungsi untuk tandai semua notifikasi sebagai dibaca
  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.12),
        child: _buildHeaderSection(context),
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () {
                    showNotificationDetailDialog(
                      context,
                      title: notification.title,
                      message: notification.message,
                      iconPath: notification.iconPath,
                      onRead: () {
                        setState(() {
                          notification.isRead = true;
                        });
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blue10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                gradient: AppColors.gradasi01WithOpacity20,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: CustomImageView(
                                  imagePath: notification.iconPath,
                                  height: 34,
                                  width: 34,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !notification.isRead,
                              child: Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: AppColors.red,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.title,
                                style: AppTextStyle.semiBold.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                notification.message,
                                style: AppTextStyle.medium.copyWith(
                                  fontSize: 12,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Tombol floating "Tandai telah dibaca semua"
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _markAllAsRead,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: BoxBorder.all(
                        width: 2,
                        color: AppColors.blue01,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text('Tandai telah dibaca semua',
                        style: AppTextStyle.semiBold.copyWith(
                          color: AppColors.blue01,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}