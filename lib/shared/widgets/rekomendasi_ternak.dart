import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationSuggestion {
  final String displayName;
  final double lat;
  final double lon;
  final String province; // Tambah untuk provinsi

  LocationSuggestion({
    required this.displayName,
    required this.lat,
    required this.lon,
    required this.province,
  });

  factory LocationSuggestion.fromJson(Map<String, dynamic> json) {
    return LocationSuggestion(
      displayName: json['display_name'] ?? '',
      lat: double.tryParse(json['lat'] ?? '0') ?? 0.0,
      lon: double.tryParse(json['lon'] ?? '0') ?? 0.0,
      province: json['address']?['state'] ?? '', // Ambil dari Nominatim 'state' (provinsi)
    );
  }
}

class LocationPickerDialog extends StatefulWidget {
  final LatLng? initialLocation;
  final String? initialAddress;
  final String? initialProvince; // Tambah untuk provinsi awal

  const LocationPickerDialog({
    Key? key,
    this.initialLocation,
    this.initialAddress,
    this.initialProvince,
  }) : super(key: key);

  @override
  _LocationPickerDialogState createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<LocationPickerDialog> {
  LatLng? _selectedLocation;
  String _currentAddress = 'Pilih lokasi di peta';
  String _selectedProvince = ''; // State untuk provinsi terpilih
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  // Daftar 38 provinsi Indonesia (terkini per 2024/2025)
  final List<String> _provinces = [
    'Aceh',
    'Sumatera Utara',
    'Sumatera Barat',
    'Riau',
    'Jambi',
    'Sumatera Selatan',
    'Bengkulu',
    'Lampung',
    'Kepulauan Bangka Belitung',
    'Kepulauan Riau',
    'DKI Jakarta',
    'Jawa Barat',
    'Jawa Tengah',
    'Daerah Istimewa Yogyakarta',
    'Jawa Timur',
    'Banten',
    'Bali',
    'Nusa Tenggara Barat',
    'Nusa Tenggara Timur',
    'Kalimantan Barat',
    'Kalimantan Tengah',
    'Kalimantan Selatan',
    'Kalimantan Timur',
    'Kalimantan Utara',
    'Sulawesi Utara',
    'Sulawesi Tengah',
    'Sulawesi Selatan',
    'Sulawesi Tenggara',
    'Gorontalo',
    'Sulawesi Barat',
    'Maluku',
    'Maluku Utara',
    'Papua',
    'Papua Barat',
    'Papua Selatan',
    'Papua Tengah',
    'Papua Pegunungan',
    'Papua Barat Daya',
  ];

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    _currentAddress = widget.initialAddress ?? 'Pilih lokasi di peta';
    _selectedProvince = widget.initialProvince ?? '';
    _searchController.text = widget.initialAddress ?? '';
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedLocation != null) {
        _mapController.move(_selectedLocation!, 15.0);
      }
    });
  }

  // Fungsi untuk mencari lokasi berdasarkan query + provinsi filter
  Future<List<LocationSuggestion>> _searchLocations(String query) async {
    if (query.isEmpty) return [];

    try {
      // Tambah filter provinsi ke query jika dipilih
      String searchQuery = query;
      if (_selectedProvince.isNotEmpty) {
        searchQuery = '$query, $_selectedProvince, Indonesia';
      } else {
        searchQuery = '$query, Indonesia';
      }

      final response = await http.get(
        Uri.parse('https://nominatim.openstreetmap.org/search?format=json&q=${Uri.encodeComponent(searchQuery)}&addressdetails=1&limit=5'),
        headers: {'User-Agent': 'TernakProApp/1.0'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => LocationSuggestion.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error searching locations: $e');
      return [];
    }
  }

  // Fungsi untuk mendapatkan alamat dari koordinat (sama seperti sebelumnya)
  Future<String> _getAddressFromLatLng(LatLng latLng) async {
    setState(() => _isLoading = true);
    
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        return _formatAddress(place);
      }
      return '${latLng.latitude.toStringAsFixed(6)}, ${latLng.longitude.toStringAsFixed(6)}';
    } catch (e) {
      print('Error getting address: $e');
      return '${latLng.latitude.toStringAsFixed(6)}, ${latLng.longitude.toStringAsFixed(6)}';
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatAddress(Placemark place) {
    String address = '';
    
    if (place.street != null && place.street!.isNotEmpty) {
      address += place.street!;
    }
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      address += address.isNotEmpty ? ', ${place.subLocality!}' : place.subLocality!;
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      address += address.isNotEmpty ? ', ${place.locality!}' : place.locality!;
    }
    if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
      address += address.isNotEmpty ? ', ${place.administrativeArea!}' : place.administrativeArea!;
    }
    
    return address.isNotEmpty ? address : 'Lokasi terpilih';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Provinsi & Lokasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              // Fitur GPS bisa ditambahkan di sini
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Dropdown Provinsi (baru)
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              value: _selectedProvince.isEmpty ? null : _selectedProvince,
              decoration: const InputDecoration(
                labelText: 'Pilih Provinsi',
                prefixIcon: Icon(Icons.map),
                border: OutlineInputBorder(),
              ),
              items: _provinces.map((String province) {
                return DropdownMenuItem<String>(
                  value: province,
                  child: Text(province),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedProvince = newValue ?? '';
                  _searchController.clear(); // Reset search saat ganti provinsi
                });
              },
            ),
          ),
          // Search Bar (dengan filter provinsi)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TypeAheadField<LocationSuggestion>(
              controller: _searchController,
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: _selectedProvince.isNotEmpty 
                        ? 'Cari lokasi di $_selectedProvince...' 
                        : 'Pilih provinsi dulu, lalu cari alamat...',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                );
              },
              suggestionsCallback: (pattern) async {
                if (_selectedProvince.isEmpty && pattern.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pilih provinsi dulu!')),
                  );
                  return [];
                }
                return await _searchLocations(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(suggestion.displayName),
                  subtitle: Text('Provinsi: ${suggestion.province}'),
                );
              },
              onSelected: (suggestion) async {
                final latLng = LatLng(suggestion.lat, suggestion.lon);
                setState(() {
                  _selectedLocation = latLng;
                  _currentAddress = suggestion.displayName;
                  _searchController.text = suggestion.displayName;
                });
                _mapController.move(latLng, 15.0);
              },
            ),
          ),
          // Peta (sama seperti sebelumnya)
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _selectedLocation ?? const LatLng(-6.2088, 106.8456), // Default Jakarta
                initialZoom: 15.0,
                onTap: (tapPosition, latLng) async {
                  setState(() {
                    _selectedLocation = latLng;
                  });
                  final address = await _getAddressFromLatLng(latLng);
                  setState(() {
                    _currentAddress = address;
                    _searchController.text = address;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.ternak_pro',
                ),
                if (_selectedLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedLocation!,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Info Lokasi (tambah provinsi)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              children: [
                _isLoading
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          Text(
                            _currentAddress,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          if (_selectedProvince.isNotEmpty)
                            Text(
                              'Provinsi: $_selectedProvince',
                              style: const TextStyle(fontSize: 14, color: Colors.blue),
                            ),
                        ],
                      ),
                const SizedBox(height: 8),
                if (_selectedLocation != null)
                  Text(
                    'Koordinat: ${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
          // Tombol Aksi (sama seperti sebelumnya, tapi return tambah province)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: (_selectedLocation != null && _selectedProvince.isNotEmpty)
                        ? () {
                            Navigator.pop(context, {
                              'province': _selectedProvince, // Tambah ini
                              'location': _selectedLocation,
                              'address': _currentAddress,
                            });
                          }
                        : null,
                    child: const Text('Pilih Lokasi Ini'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}