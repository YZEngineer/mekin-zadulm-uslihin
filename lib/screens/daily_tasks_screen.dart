import 'package:flutter/material.dart';

class DailyTasksScreen extends StatelessWidget {
  const DailyTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'التبويب الأول'),
              Tab(text: 'التبويب الثاني'),
              Tab(text: 'التبويب الثالث'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('محتوى التبويب الأول')),
            Center(child: Text('محتوى التبويب الثاني')),
            Center(child: Text('محتوى التبويب الثالث')),
          ],
        ),
      ),
    );
  }
}
