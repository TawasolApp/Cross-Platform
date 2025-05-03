import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/connections_provider.dart';

class PopUpMenuSortBy extends StatelessWidget {
  final connectionsProvider;
  const PopUpMenuSortBy({super.key, required this.connectionsProvider});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('key_popupsort_menu_button'),
      icon: Icon(Icons.tune, size: 25),
      color: Theme.of(context).textTheme.titleLarge?.color,

      onPressed: () {
        _popUpMenuSortBy(context);
      },
    );
  }

  void _popUpMenuSortBy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Consumer<ConnectionsProvider>(
          key: const Key('key_popupsort_consumer'),
          builder:
              (context, connectionsListProvider, child) => Padding(
                key: const Key('key_popupsort_outer_padding'),
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  key: const Key('key_popupsort_main_column'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      key: const Key('key_popupsort_handle_padding'),
                      padding: const EdgeInsets.all(8.0),

                      ///drag handle
                      child: Container(
                        key: const Key('key_popupsort_drag_handle'),
                        width: 40,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Theme.of(context).textTheme.titleLarge?.color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                      ),
                    ),
                    Text(
                      "Sort by",
                      key: const Key('key_popupsort_title_text'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      key: Key('key_popupsort_spacer1'),
                      height: 10,
                    ),
                    Divider(
                      key: const Key('key_popupsort_divider'),
                      height: 1,
                      thickness: 1,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    SizedBox(
                      key: const Key('key_popupsort_spacer2'),
                      height: 10,
                    ),
                    Padding(
                      key: const Key('key_popupsort_content_padding'),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        key: const Key('key_popupsort_content_column'),
                        children: [
                          Wrap(
                            key: const Key('key_popupsort_filters_wrap'),
                            spacing: 10,
                            children:
                                [
                                  'Recently added',
                                  'First name',
                                  'Last name',
                                ].asMap().entries.map((entry) {
                                  int index = entry.key;
                                  String filter = entry.value;
                                  return ChoiceChip(
                                    key: Key(
                                      'key_popupsort_filter_chip_$index',
                                    ),
                                    label: Text(
                                      filter,
                                      key: Key(
                                        'key_popupsort_filter_text_$index',
                                      ),
                                    ),
                                    selected:
                                        connectionsListProvider
                                            .selectedFilter ==
                                        filter,
                                    selectedColor: const Color.fromARGB(
                                      255,
                                      43,
                                      130,
                                      60,
                                    ),
                                    backgroundColor:
                                        Theme.of(
                                          context,
                                        ).scaffoldBackgroundColor,
                                    labelPadding: EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 0,
                                    ),
                                    showCheckmark: false,
                                    visualDensity: VisualDensity.compact,
                                    labelStyle: TextStyle(
                                      color:
                                          connectionsListProvider
                                                      .selectedFilter ==
                                                  filter
                                              ? Colors
                                                  .white //TODO: fix for dark mode
                                              : Colors.black,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                    onSelected: (bool selected) {
                                      connectionsListProvider.setFilter(filter);
                                    },
                                  );
                                }).toList(),
                          ),
                          const SizedBox(
                            key: Key('key_popupsort_spacer3'),
                            height: 20,
                          ),
                          ElevatedButton(
                            key: const Key('key_popupsort_results_button'),
                            onPressed: () {
                              connectionsListProvider.setActiveFilter();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(
                                255,
                                10,
                                102,
                                194,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              minimumSize: const Size(double.infinity, 20),
                            ),
                            child: const Text(
                              "Show results",
                              key: Key('key_popupsort_results_text'),
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white, //TODO: fix for dark mode
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        );
      },
    );
  }
}
