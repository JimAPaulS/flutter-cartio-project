// import 'package:flutter/material.dart';
//
// class HoverEffectContainer extends StatefulWidget {
//   final Widget child;
//
//   const HoverEffectContainer({Key? key, required this.child}) : super(key: key);
//
//   @override
//   _HoverEffectContainerState createState() => _HoverEffectContainerState();
// }
//
// class _HoverEffectContainerState extends State<HoverEffectContainer> with SingleTickerProviderStateMixin {
//   bool isHovered = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => isHovered = true),
//       onExit: (_) => setState(() => isHovered = false),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         transform: isHovered ? Matrix4.identity() * 0.95 : Matrix4.identity(),
//         decoration: BoxDecoration(
//           color: isHovered ? Colors.grey.shade900.withOpacity(0.7) : Colors.grey.shade900,
//           border: Border.all(color: Colors.cyan, width: 2.0),
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         child: widget.child,
//       ),
//     );
//   }
// }
