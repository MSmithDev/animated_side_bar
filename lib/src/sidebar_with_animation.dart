import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///ignore: must_be_immutable
class SideBarAnimated extends StatefulWidget {
  final ValueChanged<int>? onTap;
  Color sideBarColor;
  Duration sideBarAnimationDuration;
  Color selectedItemColor;
  Color selectedIconColor;
  Color unselectedIconColor;
  Color dividerColor;
  Color hoverColor;
  Color splashColor;
  Color highlightColor;
  Color unSelectedTextColor;
  double widthSwitch;
  double borderRadius;
  double sideBarWidth;
  double sideBarSmallWidth;
  Widget mainLogoImage;
  List<SideBarItem> sidebarItems;
  bool settingsDivider;
  Curve curve;
  TextStyle textStyle;

  SideBarAnimated({
    super.key,
    this.sideBarColor = const Color(0xff1D1D1D),
    this.selectedItemColor = const Color(0xff323232),
    this.unSelectedTextColor = const Color(0xffA0A5A9),
    this.selectedIconColor = Colors.white,
    this.unselectedIconColor = const Color(0xffA0A5A9),
    this.hoverColor = Colors.black38,
    this.splashColor = Colors.black87,
    this.highlightColor = Colors.black,
    this.borderRadius = 20,
    this.sideBarWidth = 260,
    this.sideBarSmallWidth = 84,
    this.settingsDivider = true,
    this.curve = Curves.easeOut,
    this.sideBarAnimationDuration = const Duration(milliseconds: 700),
    this.dividerColor = const Color(0xff929292),
    this.textStyle = const TextStyle(
        fontFamily: "SFPro", fontSize: 16, color: Colors.white),
    required this.mainLogoImage,
    required this.sidebarItems,
    required this.widthSwitch,
    required this.onTap,
  });

  @override
  State<SideBarAnimated> createState() => _SideBarAnimatedState();
}

class _SideBarAnimatedState extends State<SideBarAnimated>
    with SingleTickerProviderStateMixin {
  late double _width;
  late double _height;
  late double sideBarItemHeight = 60; // Increased height to accommodate wrapping text
  int _selectedIndex = 0;
  bool _minimize = false;

  @override
  void initState() {
    if (widget.sidebarItems.isEmpty) {
      throw "Side bar Items can't be empty";
    }
    super.initState();
  }

  /// Function to handle item tap
  void moveToNewIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTap?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    /// Using animated container for the side bar for smooth responsiveness
    return AnimatedContainer(
      curve: widget.curve,
      height: _height,
      margin: const EdgeInsets.all(5),
      width: _width >= widget.widthSwitch && !_minimize
          ? widget.sideBarWidth
          : widget.sideBarSmallWidth,
      decoration: BoxDecoration(
        color: widget.sideBarColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      duration: widget.sideBarAnimationDuration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: _width >= widget.widthSwitch && !_minimize ? 20 : 18,
                top: 24),
            child: SizedBox(
              width: 48,
              height: 48,
              child: widget.mainLogoImage,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                  top: 40,
                  left: _width >= widget.widthSwitch && !_minimize ? 20 : 18,
                  right: _width >= widget.widthSwitch && !_minimize ? 20 : 18,
                  bottom: 24),
              child: Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return sideBarItem(
                        textStyle: widget.textStyle,
                        unselectedIconColor: widget.unselectedIconColor,
                        selectedIconColor: widget.selectedIconColor,
                        unSelectedTextColor: widget.unSelectedTextColor,
                        widthSwitch: widget.widthSwitch,
                        minimize: _minimize,
                        hoverColor: widget.hoverColor,
                        splashColor: widget.splashColor,
                        highlightColor: widget.highlightColor,
                        width: _width,
                        imageSelected: widget.sidebarItems[index].imageSelected,
                        imageUnselected: widget.sidebarItems[index].imageUnselected ??
                            widget.sidebarItems[index].imageSelected,
                        text: widget.sidebarItems[index].text,
                        onTap: () => moveToNewIndex(index),
                        isSelected: index == _selectedIndex,
                        selectedItemColor: widget.selectedItemColor,
                        borderRadius: 12,
                      );
                    },
                    separatorBuilder: (context, index) {
                      if (index == widget.sidebarItems.length - 2 &&
                          widget.settingsDivider) {
                        return Divider(
                          height: 12,
                          thickness: 0.2,
                          color: widget.dividerColor,
                        );
                      } else {
                        return const SizedBox(
                          height: 8,
                        );
                      }
                    },
                    itemCount: widget.sidebarItems.length,
                  ),
                ],
              ),
            ),
          ),
          if (_width >= widget.widthSwitch)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: IconButton(
                hoverColor: Colors.black38,
                splashColor: Colors.black87,
                highlightColor: Colors.black,
                onPressed: () {
                  setState(() => _minimize = !_minimize);
                },
                icon: SizedBox(
                  width: 24,
                  height: 24,
                  child: _width >= widget.widthSwitch && _minimize
                      ? Image.asset(
                          'lib/images/icons/right.png') // Pass your minimize icon here
                      : Image.asset(
                          'lib/images/icons/left.png'), // Pass your maximize icon here
                ),
              ),
            )
        ],
      ),
    );
  }
}

/// Sidebar item widget that we use inside the ListView with InkWell to make each item clickable
Widget sideBarItem({
  required Widget imageSelected,
  required Widget imageUnselected,
  required String text,
  required double width,
  required double widthSwitch,
  required bool minimize,
  required Color hoverColor,
  required Color unselectedIconColor,
  required Color selectedIconColor,
  required Color splashColor,
  required Color highlightColor,
  required Color unSelectedTextColor,
  required Function() onTap,
  required TextStyle textStyle,
  required bool isSelected,
  required Color selectedItemColor,
  required double borderRadius,
}) {
  return Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(borderRadius),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    child: InkWell(
      onTap: onTap,
      hoverColor: hoverColor,
      splashColor: splashColor,
      highlightColor: highlightColor,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? selectedItemColor : Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Centered vertically
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: 24,
                height: 24,
                child: isSelected ? imageSelected : imageUnselected,
              ),
            ),
            if (width >= widthSwitch && !minimize)
              Expanded(
                child: Text(
                  text,
                  style: textStyle.copyWith(
                    color: isSelected ? selectedIconColor : unSelectedTextColor,
                  ),
                  textAlign: TextAlign.left,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

/// Sidebar model contains images as widgets instead of image paths
class SideBarItem {
  final Widget imageSelected;
  final Widget? imageUnselected;
  final String text;

  SideBarItem({
    required this.imageSelected,
    this.imageUnselected,
    required this.text,
  });
}
