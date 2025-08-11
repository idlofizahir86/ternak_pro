import 'package:flutter/material.dart';
import '../../theme.dart';

class CustomDropdownSehat extends StatefulWidget {
  final String status; // Tambahkan parameter status untuk menerima nilai default

  const CustomDropdownSehat({super.key, required this.status});

  @override
  CustomDropdownSehatState createState() => CustomDropdownSehatState();
}

class CustomDropdownSehatState extends State<CustomDropdownSehat> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    // Set nilai default berdasarkan status yang diterima
    _selectedValue = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kondisi',
          style: AppTextStyle.semiBold.copyWith(
            fontSize: 14,
            color: AppColors.black100,
          ),
        ),
        SizedBox(height: 3),
        GestureDetector(
          onTap: () {
            _showCustomDialog(context);
          },
          child: Container(
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.white06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Icon
                    Image.asset(
                      _selectedValue == 'Sehat'
                          ? 'assets/home_assets/icons/ic_check_green.png'
                          : 'assets/home_assets/icons/ic_check_yellow.png',
                      width: 16,
                      height: 16,
                    ),
                    SizedBox(width: 10),
                    // Text
                    Text(
                      _selectedValue,
                      style: AppTextStyle.medium.copyWith(
                        fontSize: 16,
                        color: AppColors.blackText,
                      ),
                    ),
                  ],
                ),
                // Dropdown icon
                Image.asset(
                  'assets/home_assets/icons/ic_dropdown.png',
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Function to show the custom dropdown dialog
  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            height: 150,
            child: Column(
              children: <Widget>[
                _buildDialogOption('Sehat'),
                _buildDialogOption('Sakit'),
              ],
            ),
          ),
        );
      },
    );
  }

  // Dialog option item
  Widget _buildDialogOption(String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedValue = value; // Update the selected value
        });
        Navigator.pop(context); // Close the dialog
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          children: [
            Image.asset(
              value == 'Sehat'
                  ? 'assets/home_assets/icons/ic_check_green.png'
                  : 'assets/home_assets/icons/ic_check_yellow.png',
              width: 16,
              height: 16,
            ),
            SizedBox(width: 10),
            Text(
              value,
              style: AppTextStyle.medium.copyWith(
                fontSize: 16,
                color: AppColors.blackText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
