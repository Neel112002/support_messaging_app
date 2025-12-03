import 'package:flutter/material.dart';
import 'package:support_messaging_app/screens/messages_screen.dart';
import 'package:support_messaging_app/screens/internal_tools_screen.dart';

class RootScaffold extends StatefulWidget {
  const RootScaffold({Key? key}) : super(key: key);

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int _currentIndex = 0;
  bool _hasUnread = false;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      MessagesScreen(
        onIncomingMessage: _handleIncomingMessage,
        onMessagesViewed: _handleMessagesViewed,
      ),
      const InternalToolsScreen(),
    ];
  }

  void _handleIncomingMessage() {
    if (_currentIndex != 0) {
      setState(() {
        _hasUnread = true;
      });
    }
  }

  void _handleMessagesViewed() {
    if (_currentIndex == 0) {
      setState(() {
        _hasUnread = false;
      });
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        _hasUnread = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: _buildMessagesIcon(),
            label: 'Messages',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Tools',
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesIcon() {
    if (!_hasUnread) {
      return const Icon(Icons.chat_bubble_outline);
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.chat_bubble_outline),
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
