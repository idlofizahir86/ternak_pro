import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ternak_pro/models/TernakItem.dart';
import 'package:ternak_pro/models/TipsItem.dart';

import '../models/DailyTaskItem.dart';
import '../models/KeuanganItem.dart';
import '../models/user.dart';

class ApiService {
  // Base URL untuk API
  static const String _baseUrl = 'https://aquamarine-ferret-962895.hostingersite.com/api/v1';

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
    final $remember_me = prefs.getBool('remember_me') ?? false;
    final $remember_email = prefs.getString('remember_email');
    final $remember_password = prefs.getString('remember_password');

    return {
      'remember_me': $remember_me,
      'remember_email': $remember_email,
      'remember_password': $remember_password
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
            if (body['data'] is List) {
              return body['data'];  // Return data if it's a List
            } else {
              throw Exception('Data yang diterima bukan List seperti yang diharapkan');
            }
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
      throw Exception('Login gagal: ${response.statusCode} - ${response.body}');
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
    
      // Mengarahkan pengguna ke halaman login setelah logout
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Error during logout: $e");
    }
  }



  //***************************************************Harga Pasar Endpoints*******************************************************
  //***************************************************Harga Pasar Endpoints*******************************************************
  //***************************************************Harga Pasar Endpoints*******************************************************
  Future<List<dynamic>> getAllHargaPasar() async {
    final response = await _makeRequest(method: 'GET', endpoint: '/harga-pasar');
    return _handleResponse(response);
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
  Future<List<dynamic>> getAllKategoriSuplierPakan() async {
    final response = await _makeRequest(method: 'GET', endpoint: '/suplier-pakan/kategoris');
    return _handleResponse(response);
  }

  Future<List<dynamic>> getAllSuplierPakan() async {
    final response = await _makeRequest(method: 'GET', endpoint: '/suplier-pakan');
    return _handleResponse(response);
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

  // **Konsultasi Pakar Endpoints**
  Future<List<dynamic>> getAllKategoriKonsultasi() async {
    final response = await _makeRequest(method: 'GET', endpoint: '/konsultasi-pakar/kategoris');
    return _handleResponse(response);
  }

  Future<List<dynamic>> getAllKonsultasiPakar() async {
    final response = await _makeRequest(method: 'GET', endpoint: '/konsultasi-pakar');
    return _handleResponse(response);
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
  Future<int> getTotalKeuangan(String tipe, String userId) async {
    try {
      final response = await _makeRequest(
        method: 'GET',
        endpoint: '/keuangan/$tipe/total/$userId',
      );

      print('Full API Response: ${response.body}');  // Untuk memeriksa seluruh response

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

  Future<dynamic> storeAsset(String userId, Map<String, dynamic> data) async {
    final response = await _makeRequest(method: 'POST', endpoint: '/asset/$userId', body: data);
    return _handleResponse(response);
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

      print('Full API Response: ${response.body}');  // Untuk memeriksa seluruh response

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

      print('Full API Response: ${response.body}');  // Untuk memeriksa seluruh response

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
    print('Full API Response: $body');  // Untuk memeriksa seluruh response

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

    print('Full API Response: ${response.body}');  // Untuk memeriksa seluruh response

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

}