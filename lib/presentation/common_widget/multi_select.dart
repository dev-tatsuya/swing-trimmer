import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:swing_trimmer/main.dart';

class MultiSelectItem<T> {
  MultiSelectItem({
    required this.value,
    required this.title,
  });

  final T value;
  final String title;
}

class MultiSelect<T> extends StatefulWidget {
  const MultiSelect({
    Key? key,
    required this.title,
    this.value,
    this.itemList,
    this.onChange,
  }) : super(key: key);

  final String title;
  final T? value;
  final List<MultiSelectItem<T>>? itemList;
  final ValueChanged<T?>? onChange;

  @override
  _MultiSelectState<T> createState() => _MultiSelectState<T>();
}

class _MultiSelectState<T> extends State<MultiSelect<T>> {
  late T? selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.clear),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                if (widget.itemList != null)
                  ...widget.itemList!.map(
                    (e) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedItem = e.value;
                        });
                      },
                      child: _multiSelectItemChip(
                        title: e.title,
                        selected: selectedItem == e.value,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onChange?.call(null);
                  },
                  child: Container(
                    width: 90,
                    height: 44,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30),
                      ),
                      border: Border.all(color: Colors.grey[700]!),
                    ),
                    child: const Center(
                      child: Text(
                        'クリア',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                GestureDetector(
                  onTap: () {
                    widget.onChange?.call(selectedItem);
                  },
                  child: Container(
                    width: 90,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '選択',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _multiSelectItemChip({
    required String title,
    required bool selected,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        border: Border.all(
          color: selected ? Colors.blueGrey : backgroundColor,
          width: selected ? 2 : 1,
        ),
        color: selected ? Colors.blueGrey : backgroundColor,
      ),
      child: Padding(
        padding: selected
            ? const EdgeInsets.fromLTRB(15, 7, 15, 7)
            : const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
