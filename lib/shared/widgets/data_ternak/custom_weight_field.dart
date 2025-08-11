import 'package:flutter/material.dart';

class CustomWeightField extends StatefulWidget {
  final String berat;

  const CustomWeightField({super.key, required this.berat});

  @override
  CustomWeightFieldState createState() => CustomWeightFieldState();
}

class CustomWeightFieldState extends State<CustomWeightField> {
  late TextEditingController _weightController; // Use late initialization for controller
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Initialize the controller after the widget is created
    _weightController = TextEditingController(text: widget.berat);

    // Listen to focus changes to update when editing starts or stops
    _focusNode.addListener(() {
      setState(() {
        _isEditing = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _weightController.dispose();  // Dispose the controller when the widget is disposed
    _focusNode.dispose(); // Dispose the focus node when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'Berat Badan',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        
        // Custom TextField for weight input
        GestureDetector(
          onTap: () {
            // Request focus for the TextField when tapped
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: Container(
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey), // Replace with your custom color
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // Icon for weight
                Image.asset(
                  'assets/data_ternak_assets/icons/ic_weight_indicator.png',
                  width: 16,
                  height: 16,
                ),
                SizedBox(width: 10),
                
                // TextField or Text display depending on the focus
                Expanded(
                  child: _isEditing
                      ? TextField(
                          controller: _weightController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Masukkan berat badan',
                            isDense: true,
                          ),
                          keyboardType: TextInputType.number,
                          onEditingComplete: () {
                            // Hide keyboard when done editing
                            _focusNode.unfocus();
                          },
                        )
                      : Row(
                          children: [
                            Text(
                              _weightController.text,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black, // Replace with your custom color
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Kg', // Static 'Kg' text
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black, // Replace with your custom color
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
