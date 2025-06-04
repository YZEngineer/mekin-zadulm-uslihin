import 'package:flutter/material.dart';

class IslamicInfoScreen extends StatelessWidget {
  const IslamicInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'التبويب الأول'),
              Tab(text: 'التبويب الثاني'),
              Tab(text: 'التبويب الثالث'),
              Tab(text: 'التبويب الرابع'),
              Tab(text: 'التبويب الخامس'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('محتوى التبويب الأول')),
            Center(child: Text('محتوى التبويب الثاني')),
            Center(child: Text('محتوى التبويب الثالث')),
            Center(child: Text('محتوى التبويب الرابع')),
            Center(child: Text('محتوى التبويب الخامس')),
          ],
        ),
      ),
    );
  }
}
