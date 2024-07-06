import 'package:example/expandable%20container/expandable_container.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ExpandableContainer(
                icon: Icons.abc,
                textTitle: 'Master Data',
                content: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.abc,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Data1',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.abc_rounded,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Data2',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                )),
            ExpandableContainer(
                icon: Icons.abc,
                textTitle: 'Master Data2',
                content: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.abc,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Data3',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.abc_rounded,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Data4',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                    ExpandableContainer(
                        icon: Icons.abc,
                        textTitle: 'Master Data4',
                        content: Column(
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.abc,
                                color: Colors.white,
                              ),
                              title: Text(
                                'Data7',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.abc_rounded,
                                color: Colors.white,
                              ),
                              title: Text(
                                'Data8',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        )),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
