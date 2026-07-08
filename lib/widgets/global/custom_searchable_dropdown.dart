import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_corner_express/utils/colors.dart';
import 'package:takos_corner_express/widgets/global/custom_search_textfield.dart';

class CustomAddSearchableDropdown extends StatefulWidget {
  final String? selectedItem;
  final String hint;
  final List<String> items;
  final TextEditingController searchController;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> selectItem;
  final VoidCallback addItem;
  final VoidCallback clearSearch;
  const CustomAddSearchableDropdown(
    this.selectedItem,
    this.hint,
    this.items,
    this.searchController,
    this.onChanged,
    this.selectItem,
    this.addItem,
    this.clearSearch, {
    super.key,
  });

  @override
  State<CustomAddSearchableDropdown> createState() =>
      _CustomAddSearchableDropdownState();
}

class _CustomAddSearchableDropdownState
    extends State<CustomAddSearchableDropdown> {
  final FocusNode focusNode = FocusNode();
  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        hasFocus = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSearchTextfield(
          widget.hint,
          searchController: widget.searchController,
          clearSearch: widget.clearSearch,
          handleSearchChanged: widget.onChanged,
          isDropdown: true,
          focusNode: focusNode,
        ),
        if (hasFocus) ...[
          SizedBox(height: 4.h),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200.h),
            child: Container(
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(12.r),
                border: context.border,
                boxShadow: context.shadows,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 4.h),
                itemCount: widget.items.isEmpty ? 1 : widget.items.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: uiBorderLight.withValues(alpha: 0.5),
                ),
                itemBuilder: (context, i) {
                  if (widget.items.isEmpty) {
                    return ListTile(
                      title: Text(
                        'Create: "${widget.searchController.text}"',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(
                        Icons.add_circle_outline,
                        size: 18.sp,
                        color: primaryColor,
                      ),
                      onTap: widget.addItem,
                    );
                  }
                  return ListTile(
                    dense: true,
                    title: Text(
                      widget.items[i],
                      style: TextStyle(fontSize: 12.sp, color: textBody),
                    ),
                    onTap: () => widget.selectItem(widget.items[i]),
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}
