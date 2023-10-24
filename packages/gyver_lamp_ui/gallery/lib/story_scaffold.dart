import 'package:flutter/material.dart';
import 'package:gallery/theme/theme.dart';

class StoryScaffold extends StatelessWidget {
  const StoryScaffold({
    required this.title,
    required this.body,
    this.backgroundColor,
    this.image,
    this.trailing,
    super.key,
  });

  final String title;
  final Widget body;
  final Color? backgroundColor;
  final Image? image;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _AppBar(
        image: image,
        title: title,
        trailing: trailing,
      ),
      body: body,
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    required this.title,
    this.image,
    this.trailing,
  });

  final String title;
  final Image? image;
  final Widget? trailing;

  @override
  Size get preferredSize => const Size.fromHeight(115);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              if (image != null) ...[
                SizedBox.square(
                  dimension: 56,
                  child: image,
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: GalleryTextStyles.headlineLarge,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(width: 16),
                      Flexible(
                        child: trailing!,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          const Divider(
            height: 2,
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
