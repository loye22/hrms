
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class iconWiget extends StatelessWidget {
  const iconWiget({
    super.key,
    required this.icon,
    required this.fun,
  });

  final IconData icon;

  final VoidCallback fun;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8, bottom: 8),
      child: InkWell(
        child: Container(
          width: 80,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.white.withOpacity(0.13)),
            color: Colors.grey.shade200.withOpacity(0.8),
          ),
          child: Icon(
            icon,
            color: Colors.black,
          ),
        ),
        onTap: fun,
      ),
    );
  }
}

