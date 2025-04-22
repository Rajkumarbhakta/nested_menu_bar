part of 'nested_menu_bar.dart';

class NestedMenuBar extends StatefulWidget {
  final List<NestedMenuItem> menus;

  /// Text of the back button. (default. 'Go back')
  final String goBackButtonText;

  /// show the back button (default : true )
  final bool showBackButton;

  /// menu height. (default. '45')
  final double height;

  /// {@macro Nested_menu_item_style}
  final NestedMenuItemStyle itemStyle;

  /// Determines the mode in which the submenu is opened.
  ///
  /// [NestedMenuBarMode.tap] Tap to open a submenu.
  /// [NestedMenuBarMode.hover] Opens a submenu by hovering the mouse.
  final NestedMenuBarMode mode;

  //menu bar properties
  final double? menuBarPadding;
  final Decoration? menuBarDecoration;

  //pop up menu item properties
  final Color? popUpMenuItemBackgroundColor;
  final Color? popUpMenuItemHoverBackgroundColor;

  final double? popUpMenuItemBorderRadius;
  final Color? popUpMenuItemBorderColor;
  final double? popUpMenuItemBorderWidth;
  final double? popUpMenuItemPadding;

  final Color? popUpMenuItemForegroundColor;
  final Color? popUpMenuItemHoverForegroundColor;

  //menu pop up properties
  final double? popUpPadding;
  final BoxDecoration? popUpDecoration;

  //menu bar menu properties
  final Color? menuBarItemColor;
  final Color? menuBarItemHoverColor;

  NestedMenuBar(
      {super.key,
      required this.menus,
      this.goBackButtonText = 'Go back',
      this.showBackButton = true,
      this.height = 45,
      this.itemStyle = const NestedMenuItemStyle(),
      this.mode = NestedMenuBarMode.hover,

      //menu bar properties
      this.menuBarPadding,
      this.menuBarDecoration,

      //pop up menu items properties
      this.popUpMenuItemBackgroundColor,
      this.popUpMenuItemHoverBackgroundColor,
      this.popUpMenuItemBorderRadius,
      this.popUpMenuItemBorderColor,
      this.popUpMenuItemBorderWidth,
      this.popUpMenuItemPadding,
      this.popUpMenuItemForegroundColor,
      this.popUpMenuItemHoverForegroundColor,

      //pop up menu properties
      this.popUpPadding,
      this.popUpDecoration,

      //menu bar menu properties
      this.menuBarItemColor,
      this.menuBarItemHoverColor})
      : assert(menus.isNotEmpty);

  @override
  State<NestedMenuBar> createState() => _NestedMenuBarState();
}

class _NestedMenuBarState extends State<NestedMenuBar> {
  GlobalKey<State<StatefulWidget>>? _selectedMenuKey;

  bool get enabledSelectedTopMenu => widget.itemStyle.enableSelectedTopMenu;

  @override
  void initState() {
    super.initState();

    _initSelectedTopMenu();
  }


  /// Initializes the selected top menu.
  ///
  /// This method sets the `_selectedMenuKey` to the key of the menu item
  /// specified by the `initialSelectedTopMenuIndex` property in the `itemStyle`.
  /// It ensures that the selected menu index is within valid bounds and updates
  /// the `_selectedMenuKey` accordingly.
  ///
  /// - If `enableSelectedTopMenu` is `false`, the method returns without making
  ///   any changes.
  /// - If `initialSelectedTopMenuIndex` is `null`, no menu is selected.
  ///
  /// The method adjusts the index to ensure it is within the range of available
  /// menu items:
  /// - If the index is less than 0, it is set to 0.
  /// - If the index is greater than or equal to the number of menu items, it is
  ///   set to the last menu item.
  ///
  /// This function is typically called during the `initState` lifecycle method
  /// to initialize the selected menu when the widget is first created.

  void _initSelectedTopMenu() {
    if (!enabledSelectedTopMenu) return;
    if (widget.itemStyle.initialSelectedTopMenuIndex == null) return;

    int index = widget.itemStyle.initialSelectedTopMenuIndex!;

    if (index < 0) {
      index = 0;
    } else if (index >= widget.menus.length) {
      index = widget.menus.length - 1;
    }
    _selectedMenuKey = widget.menus[index].key;
  }

  /// Sets the selected menu key.
  ///
  /// This method updates the `_selectedMenuKey` to the provided [key] if
  /// the `enableSelectedTopMenu` property is `true`. It triggers a state
  /// update to reflect the change in the UI.
  ///
  /// - [key]: The `GlobalKey` of the menu to be selected. If `null`, no menu
  ///   will be selected.
  ///
  /// This function has no effect if `enableSelectedTopMenu` is `false`.
  void _setSelectedMenuKey(GlobalKey<State<StatefulWidget>>? key) {
    if (!enabledSelectedTopMenu) return;
    setState(() {
      _selectedMenuKey = key;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, size) {
        return Container(
          width: size.maxWidth,
          height: widget.height,
          padding: EdgeInsets.symmetric(horizontal: widget.menuBarPadding ?? 0),
          decoration: widget.menuBarDecoration ??
              const BoxDecoration(color: Colors.white),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.menus.length,
              itemBuilder: (_, index) {
                return MenuWidget(
                  widget.menus[index],
                  goBackButtonText: widget.goBackButtonText,
                  showBackButton: widget.showBackButton,
                  height: widget.height,
                  style: widget.itemStyle,
                  mode: widget.mode,
                  selectedMenuKey: _selectedMenuKey,
                  setSelectedMenuKey: _setSelectedMenuKey,

                  //pop up menu item properties
                  popUpMenuItemBackgroundColor:
                      widget.popUpMenuItemBackgroundColor,
                  popUpMenuItemHoverBackgroundColor:
                      widget.popUpMenuItemHoverBackgroundColor,
                  popUpMenuItemBorderRadius: widget.popUpMenuItemBorderRadius,
                  popUpMenuItemBorderColor: widget.popUpMenuItemBorderColor,
                  popUpMenuItemBorderWidth: widget.popUpMenuItemBorderWidth,
                  popUpMenuItemPadding: widget.popUpMenuItemPadding,
                  popUpMenuItemForegroundColor:
                      widget.popUpMenuItemForegroundColor,
                  popUpMenuItemHoverForegroundColor:
                      widget.popUpMenuItemHoverForegroundColor,

                  //pop up menu properties
                  popUpPadding: widget.popUpPadding,
                  popUpDecoration: widget.popUpDecoration,

                  //menu bar menu properties
                  menuBarItemColor: widget.menuBarItemColor,
                  menuBarItemHoverColor: widget.menuBarItemHoverColor,
                );
              },
            ),
          ),
          // ),
        );
      },
    );
  }
}

class NestedMenuItemStyle {
  const NestedMenuItemStyle({
    this.iconColor = Colors.black54,
    this.iconSize = 20,
    this.moreIconColor = Colors.black54,
    this.iconScale = 0.86,
    this.unselectedColor = Colors.black26,
    this.activatedColor = Colors.lightBlue,
    this.indicatorColor = const Color(0xFFDCF5FF),
    this.padding = const EdgeInsets.symmetric(horizontal: 15),
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
    this.enableSelectedTopMenu = false,
    this.initialSelectedTopMenuIndex = 0,
    this.selectedTopMenuIconColor = Colors.lightBlue,
    this.selectedTopMenuTextStyle = const TextStyle(
      color: Colors.lightBlue,
      fontSize: 14,
    ),
    this.selectedTopMenuResolver,
  });

  /// The color of the icon in the menu item.
  ///
  /// This property defines the default color of the icons used in the menu items.
  /// It is applied to all icons unless overridden by specific styles or states.
  final Color iconColor;

  /// The size of the icon in the menu item.
  ///
  /// This property defines the default size of the icons used in the menu items.
  /// It is applied to all icons unless overridden by specific styles or states.
  final double iconSize;

  /// The color of the "more" icon in the menu item.
  ///
  /// This property defines the default color of the "more" icons used in the menu items.
  /// It is applied to all "more" icons unless overridden by specific styles or states.
  final Color moreIconColor;

  /// The scale factor for the icons in the menu item.
  ///
  /// This property defines the scaling applied to the icons used in the menu items.
  /// It allows for resizing the icons relative to their default size.
  final double iconScale;

  /// The color of unselected menu items.
  ///
  /// This property defines the default color of menu items that are not selected.
  /// It is used to visually differentiate unselected items from selected ones.
  final Color unselectedColor;

  /// The color of activated menu items.
  ///
  /// This property defines the default color of menu items that are activated or selected.
  /// It is used to highlight the currently active or selected menu item.
  final Color activatedColor;

  /// The color of the indicator for the menu item.
  ///
  /// This property defines the color of the indicator used to highlight the menu item.
  /// It is typically used to show focus or selection state.
  final Color indicatorColor;

  /// The padding applied to the menu item.
  ///
  /// This property defines the amount of space around the content of the menu item.
  /// It is used to control the spacing and layout of the menu item.
  final EdgeInsets padding;

  /// The text style applied to the menu item.
  ///
  /// This property defines the default text style for the menu item labels.
  /// It includes properties such as font size, color, and weight.
  final TextStyle textStyle;

  /// When the top menu is tapped, the selected style is set.
  final bool enableSelectedTopMenu;

  /// Initial top-level menu selection index.
  ///
  /// If the value is set to null, no menu is selected.
  ///
  /// Valid only when [enableSelectedTopMenu] is set to true.
  final int? initialSelectedTopMenuIndex;

  /// The color of the icon in the selected state of the top menu.
  ///
  /// Valid only when [enableSelectedTopMenu] is set to true.
  final Color selectedTopMenuIconColor;

  /// The text style of the selected state of the top-level menu.
  ///
  /// Valid only when [enableSelectedTopMenu] is set to true.
  final TextStyle selectedTopMenuTextStyle;

  /// Determines whether the top-level menu is enabled or disabled when tapped.
  ///
  /// Valid only when [enableSelectedTopMenu] is set to true.
  ///
  /// ```dart
  /// selectedTopMenuResolver: (menu, enabled) {
  ///   final description = enabled == true ? 'disabled' : 'enabled';
  ///   message(context, '${menu.title} $description');
  ///   return enabled == true ? null : true;
  /// },
  /// ```
  final bool? Function(NestedMenuItem, bool?)? selectedTopMenuResolver;
}

/// Enum representing the mode in which the `NestedMenuBar` operates.
///
/// - [hover]: Submenus are opened when the user hovers over a menu item.
/// - [tap]: Submenus are opened when the user taps on a menu item.
/// enum NestedMenuBarMode {
///  hover,
///   tap;
///
///   /// Returns `true` if the mode is set to [hover].
///   bool get isHover => this == NestedMenuBarMode.hover;
///
///   /// Returns `true` if the mode is set to [tap].
///   bool get isTap => this == NestedMenuBarMode.tap;
/// }

enum NestedMenuBarMode {
  hover,
  tap;

  bool get isHover => this == NestedMenuBarMode.hover;

  bool get isTap => this == NestedMenuBarMode.tap;
}
