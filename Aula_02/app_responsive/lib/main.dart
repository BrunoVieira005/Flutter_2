import 'package:app_responsive/screens/sum_app.dart';
import 'package:app_responsive/screens/calculator.dart';
import 'package:app_responsive/screens/div_app.dart';
import 'package:app_responsive/screens/mult_app.dart';
import 'package:app_responsive/screens/sub_app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive App - Class 2',
      home: ResponsiveHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({super.key});

  @override
  Widget build(BuildContext context) {
    // Variable who is responsible to get the size of the screen in the context
    final mediaQueryData = MediaQuery.of(context);
    // Stores the width of the screen
    final screenWidth = mediaQueryData.size.width;
    // Stores the height of the screen
    final screenHeight = mediaQueryData.size.height;

    // 'isMobile' is true when the screen width is less than 600
    final isMobile = screenWidth < 600;
    // 'isTablet' is true when screen width is between 600 and 1024
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    // 'isDesktop' is true when screen width is 1024 or greater
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Responsive Home"),
        backgroundColor: Colors.blue,
      ),
      drawer: isMobile
          ? Drawer(
              backgroundColor: Colors.redAccent,
              child: ListView(
                children: [
                  DrawerHeader(child: Text('Menu')),
                  ListTile(title: Text("Item 1")),
                  ListTile(title: Text("Item 2")),
                ],
              ),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            Container(
              width: isTablet ? 200 : 250,
              color: Colors.blue[100],
              child: ListView(
                children: [
                  DrawerHeader(
                    child: Text('Menu'),
                  ),
                  ListTile(
                    title: Text('Item 1'),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalculatorScreen()))
                    },
                  ),
                  ListTile(
                    title: Text('Sum App'),
                    onLongPress: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SumApp())),
                  ),
                  ListTile(
                    title: Text('Subtract App'),
                    onLongPress: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SubtractApp())),
                  ),
                  ListTile(
                    title: Text('Multiply App'),
                    onLongPress: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MultiplyApp())),
                  ),
                  ListTile(
                    title: Text('Division App'),
                    onLongPress: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DivisionApp())),
                  ),
                ],
              ),
            ),
          // Widget that expands to fill the remaining screen space
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Screen Width: ${screenWidth}',
                style: TextStyle(fontSize: screenWidth / 10),
              ),
              Text(
                'Screen Height: ${screenHeight}',
                style: TextStyle(fontSize: screenHeight / 20),
              ),
              if (isMobile)
                Text(
                  'Mobile Screen',
                  style: TextStyle(fontSize: screenWidth / 10),
                ),
              if (isTablet)
                Text(
                  'Tablet Screen',
                  style: TextStyle(fontSize: screenWidth / 10),
                ),
              if (isDesktop)
                Text(
                  'Desktop Screen',
                  style: TextStyle(fontSize: screenWidth / 10),
                ),
            ],
          ))
        ],
      ),
    );
  }
}
