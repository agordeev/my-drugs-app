import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_drugs/features/drug_list/drug_list_item.dart';
import 'package:my_drugs/features/drug_list/drug_row.dart';

import 'bloc/drug_list_bloc.dart';

class DrugListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Drugs'),
      ),
      body: BlocBuilder<DrugListBloc, DrugListState>(
        builder: (context, state) {
          if (state is DrugListEmpty) {
            return _buildEmptyStateContent(context);
          } else if (state is DrugListLoaded) {
            return _buildLoadedStateContent(
              context,
              state,
            );
          } else {
            return Container();
          }
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Colors.grey[350],
            ),
          )),
      child: SafeArea(
        child: Container(
          height: 24,
        ),
      ),
    );
  }

  Widget _buildEmptyStateContent(BuildContext context) => Center(
        child: Text('No drugs added yet'),
      );

  Widget _buildLoadedStateContent(
    BuildContext context,
    DrugListLoaded state,
  ) {
    return ListView.builder(
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        if (item is DrugHeadingItem) {
          return _buildHeading(
            context,
            item.name,
          );
        } else if (item is DrugItem) {
          return DrugRow(
            item: state.items[index],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildHeading(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Text(text),
    );
  }
}
