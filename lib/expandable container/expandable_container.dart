import 'package:flutter/material.dart';

class ExpandableContainer extends StatefulWidget {
  const ExpandableContainer(
      {super.key,
      this.onTap,
      required this.icon,
      required this.textTitle,
      this.content});

  final void Function()? onTap;
  final IconData icon;
  final String textTitle;
  final Widget? content;

  @override
  State<ExpandableContainer> createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  bool _isExpanded = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.black,
          child: ListTile(
            onTap: widget.onTap ?? toggleExpansion,
            leading: Icon(
              widget.icon,
              color: Colors.white,
            ),
            title: Text(
              widget.textTitle,
              style: TextStyle(color: Colors.white),
            ),
            trailing: widget.content == null
                ? null
                : Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                  ),
          ),
        ),
        SizeTransition(
          sizeFactor: animation,
          child: Container(
            color: Colors.black,
            child: widget.content,
          ),
        )
      ],
    );
  }
}
