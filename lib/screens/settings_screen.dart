import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'التبويب الأول'),
              Tab(text: 'التبويب الثاني'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('محتوى التبويب الأول')),
            Center(child: Text('محتوى التبويب الثاني')),
          ],
        ),
      ),
    );
  }
}
