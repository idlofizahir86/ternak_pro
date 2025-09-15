import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ternak_pro/models/BannerItem.dart';
import 'package:ternak_pro/models/KonsultasiPakarItem.dart';
import 'package:ternak_pro/models/TernakItem.dart';
import 'package:ternak_pro/models/TipsItem.dart';
import 'package:intl/intl.dart';

import '../cubit/page_cubit.dart';
import '../models/DailyTaskItem.dart';
import '../models/KeuanganItem.dart';
import '../models/NotificationData.dart';
import '../models/user.dart';
import '../shared/custom_loading.dart';
import '../shared/theme.dart';

class ApiService {
  // Base URL untuk API
  static const String _baseUrl = 'https://ternakpro.id/api/v1';
  // static const String _baseUrl = 'https://aquamarine-ferret-962895.hostingersite.com/api/v1';

  // Fungsi untuk menyimpan token dan user_id ke SharedPreferences
    Future<void> _saveCredentials(String token, String userId, String email, String noTelepon, String name, int roleId) async {
      final prefs = await SharedPreferences.getInstance();

      // Simpan data di SharedPreferences
      await prefs.setString('token', token);
      await prefs.setString('user_id', userId);
      await prefs.setString('email', email);
      await prefs.setString('no_telepon', noTelepon);
      await prefs.setString('name', name);
      await prefs.setInt('role_id', roleId);
    }

    Future<void> savePengulanganTemps(int nPengulangan, String satuanPengulangan, String hariPengulangan, int nKerekapan, int totalKerekapan, String tglAkhir) async {
      final prefs = await SharedPreferences.getInstance();

      // Simpan data di SharedPreferences dengan tipe yang sesuai
      await prefs.setInt('n_pengulangan', nPengulangan);  // Simpan sebagai int
      await prefs.setString('satuan_pengulangan', satuanPengulangan);  // Simpan sebagai string
      await prefs.setString('hari_pengulangan', hariPengulangan);  // Simpan sebagai string
      await prefs.setInt('n_kerekapan', nKerekapan);  // Simpan sebagai int
      await prefs.setInt('total_kerekapan', totalKerekapan);  // Simpan sebagai int
      await prefs.setString('tgl_akhir', tglAkhir);  // Simpan sebagai string

      
      print((nPengulangan, satuanPengulangan, hariPengulangan, nKerekapan, totalKerekapan, tglAkhir));
    }

    Future<Map<String, dynamic>> _loadPengulanganTemps() async {
      final prefs = await SharedPreferences.getInstance();

      // Memuat data dari SharedPreferences
      int nPengulangan = prefs.getInt('n_pengulangan') ?? 0;  // Default ke 0 jika data tidak ditemukan
      String satuanPengulangan = prefs.getString('satuan_pengulangan') ?? '';  // Default ke string kosong
      String hariPengulangan = prefs.getString('hari_pengulangan') ?? '';  // Default ke string kosong
      int nKerekapan = prefs.getInt('n_kerekapan') ?? 0;  // Default ke 0 jika data tidak ditemukan
      int totalKerekapan = prefs.getInt('total_kerekapan') ?? 0;  // Default ke 0 jika data tidak ditemukan
      String tglAkhir = prefs.getString('tgl_akhir') ?? '';  // Default ke string kosong jika data tidak ditemukan

      // Periksa tgl_akhir, jika "-" atau bukan tanggal valid, set ke "-"
      if (tglAkhir == '-') {
        tglAkhir = '-';
      } else {
        // Gunakan tryParse untuk memeriksa apakah tgl_akhir valid
        try {
          DateTime parsedDate = DateFormat("yyyy-MM-dd").parseStrict(tglAkhir);
          tglAkhir = DateFormat("yyyy-MM-dd").format(parsedDate);
        } catch (e) {
          tglAkhir = '-';  // Jika tgl_akhir tidak valid, set ke "-"
        }
      }

      
      print((nPengulangan, satuanPengulangan, hariPengulangan, nKerekapan, totalKerekapan, tglAkhir));

      // Mengembalikan data sebagai Map
      return {
        'n_pengulangan': nPengulangan,
        'satuan_pengulangan': satuanPengulangan,
        'hari_pengulangan': hariPengulangan,
        'n_kerekapan': nKerekapan,
        'total_kerekapan': totalKerekapan,
        'tgl_akhir': tglAkhir,
      };
    }


    Future<bool> _clearPengulanganTemps() async {
      final prefs = await SharedPreferences.getInstance();

      // Menghapus data dari SharedPreferences
      await prefs.remove('n_pengulangan');
      await prefs.remove('satuan_pengulangan');
      await prefs.remove('hari_pengulangan');
      await prefs.remove('n_kerekapan');
      await prefs.remove('total_kerekapan');
      await prefs.remove('tgl_akhir');

      // Mengecek apakah data telah dihapus
      bool isDataCleared = prefs.getInt('n_pengulangan') == null &&
                          prefs.getString('satuan_pengulangan') == null &&
                          prefs.getString('hari_pengulangan') == null &&
                          prefs.getInt('n_kerekapan') == null &&
                          prefs.getInt('total_kerekapan') == null &&
                          prefs.getString('tgl_akhir') == null;

      if (isDataCleared) {
        print('Semua data pengulangan telah dihapus');
      } else {
        print('Gagal menghapus data');
      }

      return isDataCleared;  // Mengembalikan status penghapusan
    }




    Future<Map<String, dynamic>> loadCredentials() async {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('token');
      final userId = prefs.getString('user_id');
      final email = prefs.getString('email');
      final name = prefs.getString('name');
      final roleId = prefs.getInt('role_id');
      final rememberMe = prefs.getBool('remember_me');

      // Kembalikan data dalam bentuk Map
      return {
        'token': token,
        'user_id': userId,
        'email': email,
        'name': name,
        'role_id': roleId,
        'remember_me': rememberMe,
      };
    }



  Future<void> _saveRememberMe(bool rememberMe, email, password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', rememberMe);
    await prefs.setString('remember_email', email);
    await prefs.setString('remember_password', password);
  }

  Future<Map<String, dynamic>> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final $rememberMe = prefs.getBool('remember_me') ?? false;
    final $rememberEmail = prefs.getString('remember_email');
    final $rememberPassword = prefs.getString('remember_password');

    return {
      'remember_me': $rememberMe,
      'remember_email': $rememberEmail,
      'remember_password': $rememberPassword
    };
  }

  // Fungsi umum untuk menangani HTTP request dengan header autentikasi
  Future<http.Response> _makeRequest({
    required String method,
    required String endpoint,
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final credentials = await loadCredentials(); // Memanggil fungsi loadCredentials
    final token = credentials['token']; // Mengakses token setelah pemanggilan selesai
    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    headers = headers != null ? {...defaultHeaders, ...headers} : defaultHeaders;

    try {
      switch (method.toUpperCase()) {
        case 'GET':
          return await http.get(uri, headers: headers);
        case 'POST':
          return await http.post(uri, headers: headers, body: jsonEncode(body));
        case 'PUT':
          return await http.put(uri, headers: headers, body: jsonEncode(body));
        case 'DELETE':
          return await http.delete(uri, headers: headers);
        default:
          throw Exception('Metode HTTP tidak didukung: $method');
      }
    } catch (e) {
      throw Exception('Gagal melakukan request: $e');
    }
  }

  // Fungsi untuk menangani response
  dynamic _handleResponse(http.Response response) {
    try {
      final body = jsonDecode(response.body);  // Decode JSON response body
      if (body is! Map) {
        throw Exception('Invalid response format');
      }

      switch (response.statusCode) {
        case 200:
        case 201:
          if (body['status'] == 'success') {
              return body['data'];  // Return data if it's a List
          } else {
            throw Exception(body['message'] ?? 'Terjadi kesalahan: ${body['errors']}');
          }

        case 401:
          throw Exception(body['message'] ?? 'Kredensial tidak valid');

        case 422:
          throw Exception(body['message'] ?? 'Validasi gagal: ${body['errors']}');

        case 404:
          throw Exception(body['message'] ?? 'Data tidak ditemukan');

        default:
          throw Exception('Error ${response.statusCode}: ${body['message'] ?? 'Terjadi kesalahan'}');
      }
    } catch (e) {
      throw Exception('Error: Gagal memproses respons dari server. Pesan: $e');
    }
  }



  // **Register Endpoint**
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required int roleId,
    String? noTelepon,
  }) async {
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'role_id': 3,
      if (noTelepon != null) 'no_telepon': noTelepon,
    };
    final response = await _makeRequest(method: 'POST', endpoint: '/register', body: data);
    final result = _handleResponse(response);
    // Simpan token, uid, dan data pengguna lainnya ke SharedPreferences
    await _saveCredentials(result['token'], result['user']['uid'], result['user']['email'], result['user']['no_telepon'], result['user']['name'], result['user']['role_id']);
    
    // Kembalikan objek User
    return User.fromJson(result['user']);
  }

  // **Login Endpoint**
  Future<User> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final data = {
      'email_or_phone': email,
      'password': password,
    };

    // Melakukan request ke API
    final response = await _makeRequest(method: 'POST', endpoint: '/login', body: data);

    // Periksa apakah status code 200 (OK)
    if (response.statusCode == 200) {
      // Parsing JSON dari body response
      final result = jsonDecode(response.body);

      // Debugging: Cetak respons untuk memastikan kita menerima data yang diharapkan
      print('Response Body: ${response.body}');

      // Periksa apakah data ada dalam response
      if (result != null && result['status'] == 'success' && result.containsKey('data')) {
        final data = result['data'];  // Ambil objek data dari respons
        final user = data['user'];    // Ambil data user
        final token = data['token'];  // Ambil token

        // Akses data user
        final uid = (user['uid'] ?? '') as String;
        final userEmail = (user['email'] ?? '') as String;
        final noTelepon = (user['no_telepon'] ?? '') as String;
        final name = (user['name'] ?? '') as String;
        final roleId = (user['role_id'] ?? 3) as int; // Default ke 3 jika roleId tidak ada

        // Simpan token dan data pengguna ke SharedPreferences
        await _saveCredentials(token, uid, userEmail, noTelepon, name, roleId);

        // Simpan status rememberMe
        await _saveRememberMe(rememberMe, email, password);

        // Kembalikan objek User
        return User.fromJson({
          'uid': uid,
          'email': userEmail,
          'no_telepon': noTelepon,
          'name': name,
          'role_id': roleId,
        });
      } else {
        throw Exception('Login gagal: Data pengguna atau token tidak ditemukan di response.');
      }
    } else {
      // Tangani jika status code bukan 200 (misalnya 401 untuk unauthorized, 500 untuk server error)
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String message = responseData['message'] ?? 'Pesan tidak tersedia';
      throw Exception('Login gagal: $message');
    }
  }



  // **Logout**
  static Future<void> logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user_id');
      await prefs.remove('name');
      await prefs.remove('no_telepon');
      await prefs.remove('role_id');
      await prefs.remove('_userDataKey');
      await prefs.remove('_lastCacheTimeKey');
      await prefs.remove('_tasksDataKey');
      await prefs.remove('_tipsDataKey');
      await prefs.remove('_locationLatKey');
      await prefs.remove('_locationLngKey');
      await prefs.remove('_locationAddressKey');
      await prefs.remove('chatMessages');

      context.read<PageCubit>().setPage(0);
          
      // Mengarahkan pengguna ke halaman login setelah logout
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Error during logout: $e");
    }
  }



  //***************************************************Harga Pasar Endpoints*******************************************************
  //***************************************************Harga Pasar Endpoints*******************************************************
  //***************************************************Harga Pasar Endpoints*******************************************************
  Future<List<Map<String, dynamic>>> getAllHargaPasar() async {
    final response = await _makeRequest(
      method: 'GET',
      endpoint: '/harga-pasar',
    );

    if (response.statusCode == 200) {
      final List<dynamic> tipsKategoris = jsonDecode(response.body);

      print(("tips data:", tipsKategoris));

      return tipsKategoris.map((item) {
        return {
          'id': item['id'],
          'image_url': item['image_url'],
          'nama': item['nama'],
          'harga_kg': item['harga_kg'],
          'kondisi': item['kondisi'],
          'lokasi': item['lokasi'],
          'created_at': DateTime.parse(item['created_at']),  // Parse to DateTime
          'updated_at': DateTime.parse(item['updated_at']),  // Parse to DateTime
        };
      }).toList();
    } else {
      throw Exception('Gagal mengambil data kategori harga pasar');
    }
  }


  Future<dynamic> storeHargaPasar(Map<String, dynamic> data) async {
    final response = await _makeRequest(method: 'POST', endpoint: '/harga-pasar', body: data);
    return _handleResponse(response);
  }

  Future<dynamic> updateHargaPasar(int id, Map<String, dynamic> data) async {
    final response = await _makeRequest(method: 'PUT', endpoint: '/harga-pasar/$id', body: data);
    return _handleResponse(response);
  }

  Future<dynamic> deleteHargaPasar(int id) async {
    final response = await _makeRequest(method: 'DELETE', endpoint: '/harga-pasar/$id');
    return _handleResponse(response);
  }

  // **Supplier Pakan Endpoints**
  Future<List<Map<String, dynamic>>> getAllKategoriSuplierPakan() async {
    final response = await _makeRequest(
      method: 'GET',
      endpoint: '/suplier-pakan/kategoris',
    );
    
    if (response.statusCode == 200) {
        final List<dynamic> tipsKategoris = jsonDecode(response.body);

        return tipsKategoris.map((item) {
          return {
            'kategori_id': item['id'],    // Ambil id
            'kategori_name': item['nama'], // Ambil nama
          };
        }).toList();
        
      } else {
        throw Exception('Gagal mengambil data katergori supplier pakan');
      }
  }

  Future<List<Map<String, dynamic>>> getAllSuplierPakan() async {
    final response = await _makeRequest(
      method: 'GET',
      endpoint: '/suplier-pakan',
    );

    if (response.statusCode == 200) {
      final List<dynamic> tipsKategoris = jsonDecode(response.body);

      print("suplier data: $tipsKategoris");

      return tipsKategoris.map((item) {
        return {
          'id': item['id'],  // Make sure these keys match the response JSON structure
          'image_url': item['image_url'],
          'judul': item['judul'],
          'detail': item['detail'],
          'khasiat': item['khasiat'],
          'kategori_id': item['kategori_id'],
          'is_stok': item['is_stok'],
          'is_nego': item['is_nego'],
          'harga': item['harga'],
          'no_tlp': item['no_tlp'],
          'alamat_overview': item['alamat_overview'],
          'alamat': item['alamat'],
          'maps_link': item['maps_link'],
          'created_at': item['created_at'],
          'updated_at': item['updated_at'],
        };
      }).toList();
    } else {
      throw Exception('Gagal mengambil data kategori harga pasar');
    }
  }


  Future<dynamic> storeSuplierPakan(Map<String, dynamic> data) async {
    final response = await _makeRequest(method: 'POST', endpoint: '/suplier-pakan', body: data);
    return _handleResponse(response);
  }

  Future<dynamic> updateSuplierPakan(int id, Map<String, dynamic> data) async {
    final response = await _makeRequest(method: 'PUT', endpoint: '/suplier-pakan/$id', body: data);
    return _handleResponse(response);
  }

  Future<dynamic> deleteSuplierPakan(int id) async {
    final response = await _makeRequest(method: 'DELETE', endpoint: '/suplier-pakan/$id');
    return _handleResponse(response);
  }

  //***************************************************Konsultasi Pakan Endpoints*******************************************************
  //***************************************************Konsultasi Pakan Endpoints*******************************************************
  //***************************************************Konsultasi Pakan Endpoints*******************************************************
  Future<List<Map<String, dynamic>>> getAllKategoriKonsultasi() async {
    final response = await _makeRequest(
      method: 'GET',
      endpoint: '/konsultasi-pakar/kategoris',
    );
    
    if (response.statusCode == 200) {
        final List<dynamic> tipsKategoris = jsonDecode(response.body);

        return tipsKategoris.map((item) {
          return {
            'kategori_id': item['id'],    // Ambil id
            'kategori_name': item['nama'], // Ambil nama
          };
        }).toList();
        
      } else {
        throw Exception('Gagal mengambil data katergori konsultasi pakan');
      }
  }

  Future<List<KonsultasiPakarItem>> getAllKonsultasiPakar() async {

    try {
      final response = await _makeRequest(
        method: 'GET',
        endpoint: '/konsultasi-pakar',
      );

      if (response.statusCode == 200) {
        final List<dynamic> tipsList = jsonDecode(response.body);
        // Mengonversi setiap elemen tipsList menjadi objek TipsItem
        List<KonsultasiPakarItem> tasks = tipsList.map<KonsultasiPakarItem>((item) {
          return KonsultasiPakarItem.fromJson(item);
        }).toList();

        return tasks; // Mengembalikan list tips
      } else {
        throw Exception('Gagal mengambil data konsultasi');
      }
    } catch (e) {
      throw Exception('Error saat mengambil data konsultasi: $e');
    }
  }

  Future<dynamic> storeKonsultasiPakar(Map<String, dynamic> data) async {
    final response = await _makeRequest(method: 'POST', endpoint: '/konsultasi-pakar', body: data);
    return _handleResponse(response);
  }

  Future<dynamic> updateKonsultasiPakar(int id, Map<String, dynamic> data) async {
    final response = await _makeRequest(method: 'PUT', endpoint: '/konsultasi-pakar/$id', body: data);
    return _handleResponse(response);
  }

  Future<dynamic> deleteKonsultasiPakar(int id) async {
    final response = await _makeRequest(method: 'DELETE', endpoint: '/konsultasi-pakar/$id');
    return _handleResponse(response);
  }

  
  //***************************************************Keuangan Endpoints*******************************************************
  //***************************************************Keuangan Endpoints*******************************************************
  //***************************************************Keuangan Endpoints*******************************************************
  Future<int> getTotalKeuangan(String tipe, int selectedMonth, int selectedYear,  userId) async {
    try {
      final response = await _makeRequest(
        method: 'GET',
        endpoint: '/keuangan/$tipe/$selectedMonth/$selectedYear/total/$userId',
      );

      // print('Full API Response: ${response.body}');  // Untuk memeriksa seluruh response

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final totalKeuanganStr = body['total_keuangan'] ?? '0';
        final totalKeuangan = int.tryParse(totalKeuanganStr.toString()) ?? 0;
        return totalKeuangan;
      } else {
        throw Exception('Gagal mengambil total keuangan');
      }
    } catch (e) {
      throw Exception('Error saat mengambil total keuangan: $e');
    }
  }

  Future<List<KeuanganItem>> getDataKeuanganUser(String userId) async {
    
    try {
      final response = await _makeRequest(
        method: 'GET',
        endpoint: '/keuangan/$userId',
      );

      print('Full API Response: ${response.body}');  // Untuk memeriksa seluruh response

      if (response.statusCode == 200) {
        final List<dynamic> keuanganList = jsonDecode(response.body);
        // Mengonversi setiap elemen keuanganList menjadi objek KeuanganItem
        List<KeuanganItem> keuanganItems = keuanganList.map<KeuanganItem>((item) {
          return KeuanganItem.fromJson(item);
        }).toList();
        print('Keuangan response: $keuanganList');
        return keuanganItems; // Mengembalikan list keuangan
      } else {
        throw Exception('Gagal mengambil data keuangan');
      }
    } catch (e) {
      throw Exception('Error saat mengambil data keuangan: $e');
    }
  }

  // Fungsi untuk menyimpan data keuangan
  Future<KeuanganItem> storeKeuangan(
      KeuanganItem keuanganItem, 
      String userId,
      BuildContext context // Menambahkan BuildContext di sini
  ) async {
    try {
      final payload = {
        'user_id': userId,
        'is_pengeluaran': keuanganItem.isPengeluaran,
        'tgl_keuangan': keuanganItem.tglKeuangan.toIso8601String().substring(0, 10), 
        'nominal_total': keuanganItem.nominalTotal,
        'dari_tujuan': keuanganItem.dariTujuan.isNotEmpty ? keuanganItem.dariTujuan : null,
        'aset_id': keuanganItem.asetId != 0 ? keuanganItem.asetId : null,
        'catatan': keuanganItem.catatan.isNotEmpty ? keuanganItem.catatan : null,
      };

      final response = await _makeRequest(
        method: 'POST',
        endpoint: '/keuangan',
        body: payload,
      );


      if (response.statusCode == 302) {
        final redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          print('Redirect to: $redirectUrl');
          Navigator.pop(context, true);  // Navigasi ke halaman sebelumnya dengan hasil true
          throw Exception('Redirect to: $redirectUrl');
        }
      }

      if (response.statusCode == 201) {
        final body = jsonDecode(response.body);
        return KeuanganItem(
          idKeuangan: body['id'] as int,
          isPengeluaran: body['is_pengeluaran'] as bool,
          nominalTotal: body['nominal_total'] as int,
          dariTujuan: (body['dari_tujuan'] as String?) ?? '',
          asetId: (body['aset_id'] as int?) ?? 0,
          namaAset: keuanganItem.namaAset.isNotEmpty ? keuanganItem.namaAset : '', 
          tglKeuangan: DateTime.parse(body['tgl_keuangan'] as String),
          catatan: (body['catatan'] as String?) ?? '',
        );
      } else {
        throw Exception('Gagal menyimpan data keuangan: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error saat menyimpan data keuangan: $e');
    }
  }



  Future<dynamic> updateKeuangan(int id, Map<String, dynamic> data) async {
    final response = await _makeRequest(method: 'PUT', endpoint: '/keuangan/$id', body: data);
    return _handleResponse(response);
  }

  Future<dynamic> deleteKeuangan(int id) async {
    final response = await _makeRequest(method: 'DELETE', endpoint: '/keuangan/$id');
    return _handleResponse(response);
  }

  
  //***************************************************Asset Endpoints*******************************************************
  //***************************************************Asset Endpoints*******************************************************
  //***************************************************Asset Endpoints*******************************************************
  Future<List<Map<String, dynamic>>> getAsset(String userId) async {
    final response = await _makeRequest(
      method: 'GET',
      endpoint: '/asset/$userId',
    );
    
    if (response.statusCode == 200) {
        final List<dynamic> assetList = jsonDecode(response.body);
        assetList.add({
          'id': 0, // id untuk "Tambah baru"
          'nama': '+ Tambah baru..', // Nama untuk "Tambah baru"
        });

        return assetList.map((item) {
          return {
            'id': item['id'],    // Ambil id
            'nama': item['nama'], // Ambil nama
          };
        }).toList();
        
      } else {
        throw Exception('Gagal mengambil data tugas');
      }
  }

  static Future<int> storeAsset(String userId, String nama) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/asset/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'nama': nama,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['id']; // Asumsi API mengembalikan ID tujuan ternak yang baru
      } else {
        throw Exception('Gagal menyimpan tujuan ternak: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error menyimpan tujuan ternak: $e');
    }
  }

  Future<dynamic> updateAsset(String userId, Map<String, dynamic> data) async {
    final response = await _makeRequest(method: 'PUT', endpoint: '/asset/$userId', body: data);
    return _handleResponse(response);
  }

  Future<dynamic> deleteAsset(String userId) async {
    final response = await _makeRequest(method: 'DELETE', endpoint: '/asset/$userId');
    return _handleResponse(response);
  }

  

  //***************************************************Ternak Endpoints*******************************************************
  //***************************************************Ternak Endpoints*******************************************************
  //***************************************************Ternak Endpoints*******************************************************
  // Fungsi untuk mendapatkan semua ternak berdasarkan user_id
  Future<List<Ternakitem>> getTernakUserAll(String userId) async {

    try {
      final response = await _makeRequest(
        method: 'GET',
        endpoint: '/ternak/$userId',
      );

      // print('Full API Response: ${response.body}');  // Untuk memeriksa seluruh response

      if (response.statusCode == 200) {
        final List<dynamic> ternakList = jsonDecode(response.body);
        // Mengonversi setiap elemen ternakList menjadi objek Ternakitem
        List<Ternakitem> ternaks = ternakList.map<Ternakitem>((item) {
          return Ternakitem.fromJson(item);
        }).toList();
        print('Ternak response: $ternakList');
        return ternaks; // Mengembalikan list ternak
      } else {
        throw Exception('Gagal mengambil data ternak');
      }
    } catch (e) {
      throw Exception('Error saat mengambil data ternak: $e');
    }
  }

  Future<int> getTernakUserCount(String userId) async {
    try {
      final response = await _makeRequest(
        method: 'GET',
        endpoint: '/ternak/$userId',
      );

      // print('Full API Response: ${response.body}');  // Untuk memeriksa seluruh response

      if (response.statusCode == 200) {
        final List<dynamic> ternakList = jsonDecode(response.body);
        // Mengembalikan panjang list ternakList
        return ternakList.length;  // Mengembalikan jumlah data
      } else {
        throw Exception('Gagal mengambil data ternak');
      }
    } catch (e) {
      throw Exception('Error saat mengambil data ternak: $e');
    }
  }

  Future<bool> storeTernak({
    required String userId,
    required String namaTernak,
    required String tglMulai,          // format 'YYYY-MM-DD'
    required int hewanId,
    required int rasId,
    required int tujuanTernakId,
    required bool isIndividual,        // true: individual, false: batch
    int? usia,
    String? tagId,                     // wajib saat individual (sesuai backend)
    String? kondisiTernak,
    String? jenisKelamin,
    double? berat,
    int? jumlahHewan,                  // wajib saat batch (sesuai backend)
    String? catatan,
    
    required BuildContext context // Menambahkan BuildContext di sini
  }) async {
    try {

      // Buat payload dasar untuk semua kasus
      final payload = <String, dynamic>{
        'user_id': userId,
        'nama_ternak': namaTernak,
        'tgl_mulai': tglMulai,
        'hewan_id': hewanId,
        'ras_id': rasId,
        'tujuan_ternak_id': tujuanTernakId,
        'is_individual': isIndividual,
        'catatan': catatan,
      };

      // Tambahkan field khusus untuk isIndividual = true
      if (isIndividual) {
        payload.addAll({
          'tag_id': tagId,
          'kondisi_ternak': kondisiTernak,
          'jenis_kelamin': jenisKelamin,
          'berat': berat,
          'usia': usia ?? 0,
        });
      } else {
        // Tambahkan field khusus untuk isIndividual = false
        payload['jumlah_hewan'] = jumlahHewan;
      }

      final response = await _makeRequest(
        method: 'POST',
        endpoint: '/ternak',
        body: payload,
      );

      if (response.statusCode == 302) {
        final redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          print('Redirect to: $redirectUrl');
          Navigator.pushNamed(context, '/list-data-ternak-tugas');  // Navigasi ke halaman sebelumnya dengan hasil true
          throw Exception('Redirect to: $redirectUrl');
        }
      }

      if (response.statusCode == 201) {
        return true; // sukses create
      }

      // Tangani error umum & validasi biar pesannya informatif
      if (response.statusCode == 422) {
        final body = jsonDecode(response.body);
        throw Exception('Validasi gagal: ${body['errors'] ?? body}');
      }

      throw Exception('Gagal menyimpan data ternak: '
          '${response.statusCode} - ${response.body}');
    } catch (e) {
      throw Exception('Error saat menyimpan data ternak: $e');
    }
  }

  Future<void> updateDataTernak({
    required String userId,
    required int idTernak,
    required String jenisKelamin,
    required String kondisiTernak,
    required String berat,
    String? catatan,
  }) async {
    try {
      final credentials = await loadCredentials();
      final userId = credentials['user_id'];
      final response = await http.put(
        Uri.parse('$_baseUrl/ternak/$userId/$idTernak'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'jenis_kelamin': jenisKelamin,
          'kondisi_ternak': kondisiTernak,
          'berat': double.parse(berat),
          'catatan': catatan,
        }),
      );

      if (response.statusCode == 200) {
        return; // Sukses, tidak perlu mengembalikan data kecuali diperlukan
      } else {
        throw Exception('Gagal memperbarui data ternak: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error memperbarui data ternak: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getHewan() async {
    final response = await _makeRequest(
      method: 'GET',
      endpoint: '/hewan',
    );
    
    if (response.statusCode == 200) {
        final List<dynamic> hewanList = jsonDecode(response.body);
        
        return hewanList.map((item) {
          return {
            'id': item['id'],    // Ambil id
            'nama': item['nama'], // Ambil nama
          };
        }).toList();
        
      } else {
        throw Exception('Gagal mengambil data hewan');
      }
  }


  // New method to fetch a single Hewan by ID
  Future<Map<String, dynamic>> getHewanById(String hewanId) async {
    final response = await _makeRequest(
      method: 'GET',
      endpoint: '/hewan/$hewanId',
    );
    final body = jsonDecode(response.body);
    // print('Full API Response: $body');  // Untuk memeriksa seluruh response

    return _handleResponse(response);
  }

  Future<List<Map<String, dynamic>>> getRas() async {
    final response = await _makeRequest(
      method: 'GET',
      endpoint: '/ras',
    );
    
    if (response.statusCode == 200) {
        final List<dynamic> hewanList = jsonDecode(response.body);
        
        return hewanList.map((item) {
          return {
            'id': item['id'],    // Ambil id
            'nama': item['nama'], // Ambil nama
          };
        }).toList();
        
      } else {
        throw Exception('Gagal mengambil data hewan');
      }
  }

  Future<List<Map<String, dynamic>>> getTujuanTernakListByUserId(String userId) async {
    final response = await _makeRequest(
      method: 'GET',
      endpoint: '/tujuan/ternak/$userId',
    );
    
    if (response.statusCode == 200) {
        final List<dynamic> tujuanTernakList = jsonDecode(response.body);
        tujuanTernakList.add({
          'id': 0, // id untuk "Tambah baru"
          'nama': '+ Tambah baru..', // Nama untuk "Tambah baru"
        });

        return tujuanTernakList.map((item) {
          return {
            'id': item['id'],    // Ambil id
            'nama': item['nama'], // Ambil nama
          };
        }).toList();
        
      } else {
        throw Exception('Gagal mengambil data tugas');
      }
  }

  static Future<int> storeTujuanTernak(String userId, String nama) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/tujuan/ternak/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'nama': nama,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['id']; // Asumsi API mengembalikan ID tujuan ternak yang baru
      } else {
        throw Exception('Gagal menyimpan tujuan ternak: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error menyimpan tujuan ternak: $e');
    }
  }

  

  //***************************************************Tugas Endpoints*******************************************************
  //***************************************************Tugas Endpoints*******************************************************
  //***************************************************Tugas Endpoints*******************************************************
  Future<List<DailyTaskItem>> getTugasUserAll(String userId) async {

    try {
      final response = await _makeRequest(
        method: 'GET',
        endpoint: '/tugas/$userId',
      );

      if (response.statusCode == 200) {
        final List<dynamic> tugasList = jsonDecode(response.body);
        // Mengonversi setiap elemen tugasList menjadi objek DailyTaskItem
        List<DailyTaskItem> tasks = tugasList.map<DailyTaskItem>((item) {
          return DailyTaskItem.fromJson(item);
        }).toList();
        

        return tasks; // Mengembalikan list tugas
      } else {
        throw Exception('Gagal mengambil data tugas');
      }
    } catch (e) {
      throw Exception('Error saat mengambil data tugas: $e');
    }
  }

  Future<int> getTugasUserCount(String userId) async {
  try {
    final response = await _makeRequest(
      method: 'GET',
      endpoint: '/tugas/$userId',
    );

    // print('Full API Response: ${response.body}');  // Untuk memeriksa seluruh response

    if (response.statusCode == 200) {
      final List<dynamic> ternakList = jsonDecode(response.body);
      // Mengembalikan panjang list ternakList
      return ternakList.length;  // Mengembalikan jumlah data
    } else {
      throw Exception('Gagal mengambil data ternak');
    }
  } catch (e) {
    throw Exception('Error saat mengambil data ternak: $e');
  }
}

Future<bool> storeTugas({
    required BuildContext context, // Menambahkan BuildContext
    required String userId,
    required int jenisTugasId,
    required String tglTugas,
    required String waktuTugas,
    required int statusTugasId,
    required String? catatan,
    required int pengulanganId,
    required bool? isPengingat,
  }) async {
    try {
      // Membuat payload dasar
      final Map<String, dynamic> payload = {
        'user_id': userId,
        'jenis_tugas_id': jenisTugasId,
        'tgl_tugas': tglTugas,
        'waktu_tugas': waktuTugas,
        'status_tugas_id': statusTugasId,
        'catatan': catatan,
        'pengulangan_id': pengulanganId,
        'is_pengingat': isPengingat,
      };


      // Jika pengulangan_id adalah 6, tambahkan data tambahan
      if (pengulanganId == 6) {
        final pengulanganData = await _loadPengulanganTemps();

        print(pengulanganData);
        // Tambahkan data pengulangan ke payload
        payload.addAll(pengulanganData);

      }

      
      print(payload);

      // Kirim request POST ke endpoint '/tugas'
      final response = await _makeRequest(
        method: 'POST',
        endpoint: '/tugas',
        body: payload,
      );

      if (response.statusCode == 302) {
        final redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          print('Redirect to: $redirectUrl');
          Navigator.pushNamed(
            context,
            '/list-data-ternak-tugas',
            arguments: {'initialIndex': 1},
          ); // Navigasi ke halaman sebelumnya
          throw Exception('Redirect to: $redirectUrl');
        }
      }

      if (response.statusCode == 201) {
        // Panggil _clearPengulanganTemps setelah berhasil
        await _clearPengulanganTemps();
        return true; // Berhasil membuat tugas
      }

      // Tangani error umum & validasi
      if (response.statusCode == 422) {
        final body = jsonDecode(response.body);
        throw Exception('Validasi gagal: ${body['errors'] ?? body}');
      }

      throw Exception('Gagal menyimpan data tugas: ${response.statusCode} - ${response.body}');
    } catch (e) {
      throw Exception('Error saat menyimpan data tugas: $e');
    }
  }

  Future<void> updateDataTugas({
    required BuildContext context,
    required String userId,
    required int idTugas,
    required String waktuTugas,
    required String tglTugas,
    required int statusTugasId,
    required bool isHome,
    String? catatan,
  }) async {
    // Fungsi untuk menampilkan loading overlay
    void showLoadingOverlay(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false, // Mencegah menutup dialog dengan tap
        builder: (BuildContext context) {
          return Stack(
            children: [
              ModalBarrier(
                color: Colors.black.withOpacity(0.4), // Efek freeze semi-transparan
                dismissible: false, // Tidak bisa ditutup dengan tap
              ),
              const Center(
                child: TernakProBoxLoading(), // Loading indicator di tengah
              ),
            ],
          );
        },
      );
    }

    // Tampilkan loading overlay
    showLoadingOverlay(context);

    try {
      final credentials = await loadCredentials();
      final userId = credentials['user_id'];
      final response = await http.put(
        Uri.parse('$_baseUrl/tugas/$userId/$idTugas'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'tgl_tugas': tglTugas,
          'waktu_tugas': waktuTugas,
          'status_tugas_id': statusTugasId,
          'catatan': catatan,
        }),
      ).timeout(const Duration(seconds: 30)); // Tambahkan timeout

      // Tutup loading overlay
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        if (isHome == true) {
          Navigator.pushNamed(context, '/main');
        } else {
          Navigator.pushNamed(
            context,
            '/list-data-ternak-tugas',
            arguments: {'initialIndex': 1},
          );
        }
        return; // Sukses
      } else {
        throw Exception('Gagal memperbarui data tugas: ${response.statusCode}');
      }
    } catch (e) {
      // Tutup loading overlay sebelum menampilkan error
      Navigator.of(context).pop();
      // Tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error memperbarui data tugas: $e'),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      throw Exception('Error memperbarui data tugas: $e');
    }
  }

  static Future<int> storeJenisTugas(String userId, String nama, String iconPath) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/jenis/tugas/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'nama': nama,
          'icon_path': iconPath,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['id']; // Asumsi API mengembalikan ID tujuan ternak yang baru
      } else {
        throw Exception('Gagal menyimpan tujuan ternak: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error menyimpan tujuan ternak: $e');
    }
  }

  // New method to fetch a single Hewan by ID
  Future<List<Map<String, dynamic>>> getJenisTugasListByUserId(String userId) async {
    final response = await _makeRequest(
      method: 'GET',
      endpoint: '/jenis/tugas/$userId',
    );
    
    if (response.statusCode == 200) {
        final List<dynamic> jenisTugasList = jsonDecode(response.body);
        jenisTugasList.add({
          'id': 0, // id untuk "Tambah baru"
          'nama': '+ Tambah baru..', // Nama untuk "Tambah baru"
        });
        
        return jenisTugasList.map((item) {
          return {
            'id': item['id'],    // Ambil id
            'nama': item['nama'], // Ambil nama
          };
        }).toList();
        
      } else {
        throw Exception('Gagal mengambil data tugas');
      }
  }

  Future<List<Map<String, dynamic>>> getPengulanganTugas() async {
    final response = await _makeRequest(
      method: 'GET',
      endpoint: '/pengulangan/tugas',
    );
    
    if (response.statusCode == 200) {
        final List<dynamic> pengulanganTugasList = jsonDecode(response.body);
        
        return pengulanganTugasList.map((item) {
          return {
            'id': item['id'],    // Ambil id
            'nama': item['nama'], // Ambil nama
          };
        }).toList();
        
      } else {
        throw Exception('Gagal mengambil data tugas');
      }
  }

  Future<List<Map<String, dynamic>>> getStatusTugas() async {
    final response = await _makeRequest(
      method: 'GET',
      endpoint: '/status/tugas',
    );
    
    if (response.statusCode == 200) {
        final List<dynamic> statusTugasList = jsonDecode(response.body);

        return statusTugasList.map((item) {
          return {
            'id': item['id'],    // Ambil id
            'nama': item['nama'], // Ambil nama
          };
        }).toList();
        
      } else {
        throw Exception('Gagal mengambil data status tugas');
      }
  }


  Future<Map<String, dynamic>> getJenisTugasById(String userId, int id) async {
    final response = await _makeRequest(
      method: 'GET',
      endpoint: '/jenis/tugas/$userId/$id',
    );
    return _handleResponse(response);
  }

  
  //***************************************************Tips Endpoints*******************************************************
  //***************************************************Tips Endpoints*******************************************************
  //***************************************************Tips Endpoints*******************************************************
  Future<List<Map<String, dynamic>>> getTipsKategoris() async {
    final response = await _makeRequest(
      method: 'GET',
      endpoint: '/tips/kategoris',
    );
    
    if (response.statusCode == 200) {
        final List<dynamic> tipsKategoris = jsonDecode(response.body);

        return tipsKategoris.map((item) {
          return {
            'kategori_id': item['id'],    // Ambil id
            'kategori_name': item['nama'], // Ambil nama
          };
        }).toList();
        
      } else {
        throw Exception('Gagal mengambil data status tips');
      }
  }

  Future<List<TipsItem>> getTipsItem() async {

    try {
      final response = await _makeRequest(
        method: 'GET',
        endpoint: '/tips',
      );

      if (response.statusCode == 200) {
        final List<dynamic> tipsList = jsonDecode(response.body);
        // Mengonversi setiap elemen tipsList menjadi objek TipsItem
        List<TipsItem> tasks = tipsList.map<TipsItem>((item) {
          return TipsItem.fromJson(item);
        }).toList();

        return tasks; // Mengembalikan list tips
      } else {
        throw Exception('Gagal mengambil data tips');
      }
    } catch (e) {
      throw Exception('Error saat mengambil data tips: $e');
    }
  }

  //***************************************************Tips Endpoints*******************************************************
  //***************************************************Tips Endpoints*******************************************************
  //***************************************************Tips Endpoints*******************************************************
  Future<List<BannerItem>> fetchBanners() async {
    final response = await http.get(
      Uri.parse(
        "$_baseUrl/active-banners",
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((item) => BannerItem.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load banners');
    }
  }

  Future<int> fetchBannersCount() async {
    final response = await http.get(
      Uri.parse(
        "$_baseUrl/active-banners",
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final bannersList = data['data'] as List;
      return bannersList.length; // Mengembalikan jumlah notifikasi
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  //***************************************************Notifikasi Endpoints*******************************************************
  //***************************************************Notifikasi Endpoints*******************************************************
  //***************************************************Notifikasi Endpoints*******************************************************
  Future<List<NotificationData>> fetchNotifications(String userId) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/notifications/$userId',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((item) => NotificationData.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load banners');
    }
  }

  //***************************************************Rekomendasi Ternak Endpoints*******************************************************
  //***************************************************Rekomendasi Ternak Endpoints*******************************************************
  //***************************************************Rekomendasi Ternak Endpoints*******************************************************
  Future<Map<String, dynamic>> getRekomendasiTernak({
    required String region,
    required num landLength,
    required num landWidth,
    required String goal, // 'daging', 'telur', 'susu', 'bibit', 'lainnya'
    required List<String> availableFeed,
    required String timeAvailability, // 'pagi', 'siang', 'sore', 'sepanjang_hari'
    required String experience, // 'pemula', 'menengah', 'ahli'
  }) async {
    try {
      // Validasi sederhana di client-side (opsional)
      if (region.isEmpty || region.length > 100) {
        throw Exception('Region harus string valid (max 100 karakter)');
      }
      if (landLength < 1 || landLength > 1000 || landWidth < 1 || landWidth > 1000) {
        throw Exception('Ukuran lahan harus antara 1-1000');
      }
      if (!['daging', 'telur', 'susu', 'bibit', 'lainnya'].contains(goal)) {
        throw Exception('Goal tidak valid');
      }
      if (availableFeed.isEmpty) {
        throw Exception('Available feed harus tidak kosong');
      }
      if (!['pagi', 'siang', 'sore', 'sepanjang_hari'].contains(timeAvailability)) {
        throw Exception('Time availability tidak valid');
      }
      if (!['pemula', 'menengah', 'ahli'].contains(experience)) {
        throw Exception('Experience tidak valid');
      }

      // Buat payload sesuai backend
      final payload = <String, dynamic>{
        'region': region,
        'land_length': landLength,
        'land_width': landWidth,
        'goal': goal,
        'available_feed': availableFeed, // Dikirim sebagai array
        'time_availability': timeAvailability,
        'experience': experience,
      };

      print('Sending recommendation request: $payload'); // Debug log

      // Panggil _makeRequest (return http.Response)
      final response = await _makeRequest(
        method: 'POST',
        endpoint: '/ai/rekomendasi-ternak',
        body: payload,
      );

      // Pengecekan eksplisit statusCode == 200
      if (response.statusCode == 200) {
        // Parse JSON dari body
        final responseBody = jsonDecode(response.body);
        
        // Cek success flag di JSON (opsional, tapi sesuai backend)
        if (responseBody['success'] == true) {
          print('Recommendation success: ${responseBody['data']}');
          return responseBody; // Return full response (success: true, data: formatted)
        } else {
          throw Exception(responseBody['message'] ?? 'Unknown error from server');
        }
      } else {
        // Handle error berdasarkan status code
        String errorMessage;
        try {
          final errorBody = jsonDecode(response.body);
          errorMessage = errorBody['message'] ?? 'Server error (${response.statusCode})';
        } catch (e) {
          errorMessage = 'Server error (${response.statusCode}): ${response.body}';
        }
        
        print('Error response: $errorMessage (Status: ${response.statusCode})');
        
        switch (response.statusCode) {
          case 422:
            throw Exception('Validation failed: $errorMessage');
          case 503:
            throw Exception('AI service temporarily unavailable: $errorMessage');
          case 500:
            throw Exception('Server error: $errorMessage');
          default:
            throw Exception('Request failed: $errorMessage');
        }
      }

    } catch (e) {
      print('Error getting recommendation: $e'); // Log error
      rethrow; // Propagate ke UI
    }
  }
}