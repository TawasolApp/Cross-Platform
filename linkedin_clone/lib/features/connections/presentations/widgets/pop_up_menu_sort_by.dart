import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/connections_provider.dart';

class PopUpMenuSortBy extends StatelessWidget {
  final connectionsProvider;
  const PopUpMenuSortBy({super.key, required this.connectionsProvider});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.tune, size: 25),
      color: Theme.of(context).textTheme.titleLarge?.color,

      onPressed: () {
        _popUpMenuSortBy(context);
      },
    );
  }

  void _popUpMenuSortBy(BuildContext context) {
    String selectedFilter = 'Recently added'; // Default selected filter

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Consumer<ConnectionsProvider>(
          builder:
              (context, connectionsListProvider, child) => Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),

                      ///drag handle
                      child: Container(
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
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Wrap(
                            spacing: 10,
                            children:
                                ['Recently added', 'First name', 'Last name']
                                    .map(
                                      (filter) => ChoiceChip(
                                        label: Text(filter),
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
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          side: BorderSide(
                                            color:
                                                Theme.of(context).dividerColor,
                                          ),
                                        ),
                                        onSelected: (bool selected) {
                                          selectedFilter = filter;
                                          connectionsListProvider.setFilter(
                                            filter,
                                          );
                                        },
                                      ),
                                    )
                                    .toList(),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (selectedFilter == 'Last name') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Sorting by last name is not supported yet',
                                    ),
                                  ),
                                );
                              } else {
                                connectionsProvider.sortConnectionBy(
                                  selectedFilter,
                                );
                              }
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
