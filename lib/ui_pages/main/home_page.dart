import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../models/DailyTaskItem.dart';
import '../../models/TipsItem.dart';
import '../../services/api_service.dart';
import '../../shared/custom_loading.dart';
import '../../shared/theme.dart';
import '../../shared/widgets/home/daily_task.dart';
import '../../shared/widgets/custom_image_view.dart';
import '../../shared/widgets/daily_tip_card.dart';
import '../../shared/widgets/featured_service_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String greeting = 'Hai Selamat Pagi,';
  String formattedDate = '';
  Timer? _timer;
  String? _currentAddress; // Store the address
  Position? currentPosition; // Store the GPS position
  bool _isLoadingLocation = false; // Track loading state
  List<DailyTaskItem> _tasks = [];
  bool _isLoadingTasks = false;
  String? _errorMessage;

  final ApiService _apiService = ApiService(); // Initialize your ApiService

  

  @override
  void initState() {
    super.initState();
    _updateGreetingAndDate();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateGreetingAndDate();
    });
    _getCurrentLocation(); // Fetch location on init
    loadUserData();
    _fetchTasks();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateGreetingAndDate() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;

    // Tentukan salam berdasarkan waktu
    if ((hour == 2 && minute >= 1) || (hour > 2 && hour <= 11)) {
      greeting = 'Hai Selamat Pagi,';
    } else if (hour > 11 && hour <= 15) {
      greeting = 'Hai Selamat Siang,';
    } else if (hour > 15 && hour <= 18) {
      greeting = 'Hai Selamat Sore,';
    } else {
      greeting = 'Hai Selamat Malam,';
    }

    // Format tanggal ke "Nama Hari, DD Bulan YYYY"
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');
    formattedDate = dateFormat.format(now);

    setState(() {});
  }

  // Check and request location permissions
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    if (kIsWeb) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Izin lokasi ditolak.')),
            );
          }
          return false;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Izin lokasi ditolak secara permanen. Silakan izinkan di pengaturan browser.')),
          );
        }
        return false;
      }
      return true;
    }

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Layanan lokasi dinonaktifkan. Aktifkan untuk melanjutkan.')),
        );
      }
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Izin lokasi ditolak.')),
          );
        }
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Izin lokasi ditolak secara permanen. Silakan izinkan di pengaturan.')),
        );
      }
      return false;
    }

    return true;
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    if (kIsWeb) {
      // Web-specific fallback for testing
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
          _currentAddress = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lokasi otomatis tidak tersedia di web. Silakan pilih lokasi secara manual.'),
          ),
        );
      }
      return;
    }

    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
          _currentAddress = null;
        });
      }
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('Gagal mendapatkan lokasi dalam waktu yang ditentukan.');
      });

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Check if placemarks is not empty
      if (placemarks.isEmpty) {
        throw Exception('Tidak ada data placemark yang ditemukan.');
      }

      Placemark place = placemarks[0];
      // Ensure placemark fields are not null
      String address = [
        place.subLocality ?? '',
        place.locality ?? '',
        place.administrativeArea ?? '',
      ].where((e) => e.isNotEmpty).join(', ').trim();

      if (address.isEmpty) {
        address = 'Lokasi tidak dikenal';
      }

      if (mounted) {
        setState(() {
          currentPosition = position;
          _currentAddress = address;
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
          _currentAddress = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mendapatkan lokasi: ${e.toString()}'),
          ),
        );
      }
    }
  }
  

  void _selectLocationManually() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pilih Lokasi'),
        content: Text('Fitur pemilihan lokasi manual (contoh).'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _currentAddress = 'Lokasi Manual, Kota Contoh';
              });
              Navigator.pop(context);
            },
            child: Text('Pilih'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
        ],
      ),
    );
  }

  // Fetch tasks dynamically from the server
  Future<void> _fetchTasks() async {
    final credential = await _apiService.loadCredentials();
    final userId = credential['user_id'];  // Ambil user ID

    setState(() {
      _isLoadingTasks = true;
      _errorMessage = null;
    });

    try {
      // Memanggil getTugasUserAll untuk mendapatkan data tugas
      List<DailyTaskItem> tasks = await _apiService.getTugasUserAll(userId);

      // Menunggu 3 detik sebelum mematikan _isLoadingTasks
      await Future.delayed(const Duration(seconds: 3));

      setState(() {
        _tasks = tasks;  // Menyimpan data tugas ke dalam state
        _isLoadingTasks = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load tasks: $e';  // Menampilkan pesan error
        _isLoadingTasks = false;
      });
    }
  }




  String dataUser = '';
  Future<void> loadUserData() async {
    final credential = await _apiService.loadCredentials(); // Await the Future
    setState(() {
      dataUser = credential['name'] ?? ''; // Safe access with default value
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(context, greeting, formattedDate, dataUser),
            _buildStatsCard(context),
            _buildFeaturedServices(context),
            _buildDailyTasks(context),
            _buildDailyTips(context),
            SizedBox(height: 110), // Spacing at the bottom
          ],
        ),
      ),
    );
  }

   // Modified buildDailyTasks to handle dynamic tasks, loading, and error states
  Widget _buildDailyTasks(BuildContext context) {
    

    if (_errorMessage != null) {
      return Center(
        child: Column(
          children: [
            Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchTasks,
              child: Text('Coba lagi'),
            ),
          ],
        ),
      );
    }

    final task2 = _tasks.take(2).toList();

    return buildDailyTasks(context, task2, _isLoadingTasks); // Use the dynamic _tasks list
  }

  


Widget _buildHeaderSection(BuildContext context, String greeting, String formattedDate, String dataUser) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  // Ukuran dinamis berdasarkan ukuran layar
  double headerHeight = screenHeight * 0.25; // Menyesuaikan tinggi header
  double imageHeight = screenHeight * 0.2; // Menyesuaikan tinggi gambar
  double fontSizeSmall = (screenWidth * 0.05).clamp(16.0, 20.0); // Responsif untuk ukuran font
  double fontSizeLarge = (screenWidth * 0.06).clamp(18.0, 22.0); // Responsif untuk ukuran font besar
  double iconSize = (screenWidth * 0.08).clamp(20.0, 36.0); // Responsif untuk ukuran ikon

  return Container(
    height: headerHeight,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: AppColors.gradasi01,
    ),
    child: Stack(
      children: [
        CustomImageView(
          imagePath: "assets/home_assets/images/img_star.png",
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 58,
          left: 24,
          right: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: AppTextStyle.medium.copyWith(fontSize: fontSizeSmall, color: AppColors.white100),
                  ),
                  Text(
                    dataUser != null ? dataUser : 'Tidak Dikenal',
                    style: AppTextStyle.extraBold.copyWith(fontSize: fontSizeLarge, color: AppColors.white100),
                  ),
                ],
              ),
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: AppColors.white100,
                  borderRadius: BorderRadius.circular(iconSize / 2),
                ),
                child: Center(
                  child: CustomImageView(
                    imagePath: "assets/home_assets/icons/ic_bell.png",
                    height: iconSize * 0.6,
                    width: iconSize * 0.6,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 110,
          left: 24,
          right: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: _selectLocationManually,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.white100,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          CustomImageView(
                            imagePath: "assets/home_assets/icons/ic_location.png",
                            height: 24,
                            width: 24,
                          ),
                          SizedBox(width: 8),
                          _isLoadingLocation
                              ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: TernakProBoxLoading(),
                                )
                              : SizedBox(
                                  width: screenWidth * 0.5, // Limit width to prevent overflow
                                  child: Text(
                                    _currentAddress ?? 'Tambahkan Lokasi',
                                    style: AppTextStyle.medium.copyWith(fontSize: 14),
                                    maxLines: 1, // Restrict to one line
                                    overflow: TextOverflow.ellipsis, // Add ellipsis for long text
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  CustomImageView(
                    imagePath: "assets/home_assets/images/img_amelia_1_2.png",
                    height: 36,
                    width: 32,
                  ),
                ],
              ),
              
            ],
          ),
        ),
        Positioned(
          bottom: 40,
          right: 15,
          child: Text(
                    formattedDate,
                    style: AppTextStyle.medium.copyWith(
                      fontSize: fontSizeSmall*0.6,
                      color: AppColors.white100,
                    ),
                  ),),
        Positioned(
          right: 0,
          bottom: 0,
          child: Row(
            children: [
              Column(
                children: [
                  SizedBox(height: 12),
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
          left: 0,
          child: CustomImageView(
            imagePath: "assets/home_assets/images/img_amelia_1_1.png",
            height: 40,
            width: 28,
          ),
        ),
      ],
    ),
  );
}


}
  
  final ApiService _apiService = ApiService(); // Initialize your ApiService
  // Fungsi untuk mendapatkan jumlah ternak
  Future<int> _getTernakUserCount() async {
    final credential = await _apiService.loadCredentials();
    final userId = credential['user_id'];

    try {
      final count = await _apiService.getTernakUserCount(userId);  // Panggil fungsi getTernakUserCount untuk mendapatkan jumlah data ternak
      return count;  // Mengembalikan jumlah data ternak
    } catch (e) {
      return 0;  // Mengembalikan 0 jika gagal
    }
  }
  

  Widget _buildStatsCard(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;

        // Ukuran dinamis
        double fontSizeSmall = (maxWidth * 0.01).clamp(10.0, 14.0);
        double fontSizeMedium = (maxWidth * 0.025).clamp(14.0, 18.0);
        double fontSizeLarge = (maxWidth * 0.04).clamp(14.0, 18.0);
        double iconSmall = (maxWidth * 0.05).clamp(16.0, 24.0);
        double iconLarge = (maxWidth * 0.08).clamp(24.0, 36.0);
        double verticalSpacing = (maxWidth * 0.02).clamp(6.0, 12.0);
        double dividerHeight = (maxWidth * 0.12).clamp(40.0, 60.0);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          transform: Matrix4.translationValues(0, -24, 0),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: verticalSpacing,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: AppColors.white100,
              border: Border.all(color: AppColors.grey20),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kolom 1: Jumlah Ternak
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jumlah Ternak",
                            style: AppTextStyle.semiBold.copyWith(
                              fontSize: fontSizeSmall,
                              color: AppColors.blackText,
                            ),
                          ),
                          SizedBox(height: verticalSpacing),
                          Row(
                            children: [
                              Image.asset(
                                "assets/home_assets/icons/ic_cow.png",
                                height: iconSmall,
                                width: iconSmall,
                              ),
                              SizedBox(width: 10),
                              FutureBuilder<int>(
                                future: _getTernakUserCount(), // Memanggil fungsi untuk mendapatkan jumlah ternak
                                builder: (context, snapshot) {
                                  int nData = 0;
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      nData = snapshot.data!;
                                    } else if (snapshot.hasError) {
                                      return Text(
                                        "-",
                                        style: AppTextStyle.extraBold.copyWith(
                                          fontSize: fontSizeLarge,
                                          color: AppColors.blackText,
                                        ),
                                      );
                                      }
                                  }

                                  return Text(
                                    "${nData.toString()} Ekor",
                                    style: AppTextStyle.extraBold.copyWith(
                                      fontSize: fontSizeMedium,
                                      color: AppColors.blackText,
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),

                      // Kolom 2: Pakan Harian
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pakan Harian",
                            style: AppTextStyle.semiBold.copyWith(
                              fontSize: fontSizeSmall,
                              color: AppColors.blackText,
                            ),
                          ),
                          SizedBox(height: verticalSpacing),
                          Row(
                            children: [
                              Image.asset(
                                "assets/home_assets/icons/ic_snack.png",
                                height: iconSmall,
                                width: iconSmall,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "-",
                                style: AppTextStyle.extraBold.copyWith(
                                  fontSize: fontSizeLarge,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),

                      // Divider vertikal
                      Container(
                        height: dividerHeight,
                        width: 1,
                        color: AppColors.grey20,
                      ),

                      // Kolom 3: Update Data Harian (tombol)
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/list-data-ternak-tugas');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/home_assets/icons/ic_update.png",
                              height: iconLarge,
                              width: iconLarge,
                            ),
                            SizedBox(height: verticalSpacing / 2),
                            Text(
                              "Update Data\nHarian",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.semiBold.copyWith(
                                fontSize: fontSizeSmall,
                                color: AppColors.blackText,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Kolom 4: Tambah Data Ternak (tombol)
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/tambah-data-ternak');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/home_assets/icons/ic_plus.png",
                              height: iconLarge,
                              width: iconLarge,
                            ),
                            SizedBox(height: verticalSpacing / 2),
                            Text(
                              "Tambah Data\nTernak",
                              textAlign: TextAlign.center,
                              style: AppTextStyle.semiBold.copyWith(
                                fontSize: fontSizeSmall,
                                color: AppColors.blackText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



 Widget _buildFeaturedServices(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      transform: Matrix4.translationValues(0, -10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fitur Unggulan',
            style: AppTextStyle.semiBold.copyWith(fontSize: 16),
          ),
          SizedBox(height: 8),
          FeaturedServiceCardWidget(
            iconPath: "assets/home_assets/icons/ic_ai_agent.png",
            title: 'Asisten Virtual Peternak',
            description: 'Asisten AI Untuk Membantu Mengelola Ternakmu',
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF298FBB), Color(0xFF298FBB)],
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/asisten-virtual',
                arguments: {
                  'initialText': null,
                  'externalInput': true,
                },
              );
            },
          ),
          SizedBox(height: 8),
          FeaturedServiceCardWidget(
            iconPath: "assets/home_assets/icons/ic_invest.png",
            title: 'Harga Pasar Hari Ini',
            description: 'Pantau Harga Standar Produk Ternak Dipasaran',
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF0EBCB1), Color(0xFF065627)],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/harga-pasar');
            },
          ),
        ],
      ),
    );
  }


  Widget _buildDailyTips(BuildContext context) {
  final ApiService _apiService = ApiService();

  return Container(
    margin: const EdgeInsets.only(top: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            'Tips Harian Kamu',
            style: AppTextStyle.semiBold.copyWith(fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 135,
          child: FutureBuilder<List<TipsItem>>(
            future: _apiService.getTipsItem(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: TernakProBoxLoading());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada data tips'));
              }

              // Ambil 4 item pertama
              final tips = snapshot.data!.take(4).toList();

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tips.length,
                itemBuilder: (context, index) {
                  final tip = tips[index];
                  return Row(
                    children: [
                      if (index == 0) const SizedBox(width: 24), // Jarak di awal
                      DailyTipCardWidget(
                        imagePath: tip.imageUrl,
                        title: tip.judul,
                        author: tip.author ?? 'Anonim',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/tips-harian-detail',
                            arguments: tip, // Kirim objek TipsItem
                          );
                        },
                      ),
                      const SizedBox(width: 8), // Jarak antar card
                    ],
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/tips-harian');
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppColors.gradasi01WithOpacity20,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lihat Lainnya →',
                    style: AppTextStyle.semiBold.copyWith(
                      color: AppColors.green01,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}