import 'package:flutter/material.dart'; // Material Widgets
import 'package:get/get.dart'; // Import GetX State Management package

class subtractionController extends GetxController {
  var number1 = 0.0.obs; // Variable to store Number1
  var number2 = 0.0.obs; // Variable to store Number1
  var result = 0.0.obs; // Variable to store the result

  // Creating the methods of the clas
  void setNumber1(String value) {
    number1.value = double.tryParse(value) ?? 0.0; // Converts value
  }

  void setNumber2(String value) {
    number2.value = double.tryParse(value) ?? 0.0; // Converts value
  }

  // Method to subtract the number1 and number2
  void subtractValue() {
    result.value = number1.value - number2.value;
  }
}

class SubtractApp extends StatelessWidget {
  final subtractionController controller =
      Get.put(subtractionController()); // Injects controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text(
          'Subtraction App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Number 1',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller.setNumber1(value)),
          SizedBox(
            height: 16,
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Number 2', border: OutlineInputBorder()),
            onChanged: (value) => controller.setNumber2(value),
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: controller.subtractValue,
            child: Text('Subtract'),
          ),
          SizedBox(
            height: 16,
          ),

          // State Manager OBX
          Obx(() => Text(
                'Result: ${controller.result}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
