import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:my_drugs/app/features/drug_list/bloc/drug_list_bloc.dart';
import 'package:my_drugs/app/features/drug_list/drug_list_screen.dart';
import 'package:my_drugs/app/features/manage_drug/bloc/manage_drug_bloc.dart';
import 'package:my_drugs/app/features/manage_drug/manage_drug_screen.dart';
import 'package:my_drugs/app/routes/app_routes.dart';
import 'package:my_drugs/data_access/data_access.dart';
import 'package:my_drugs/models/drug.dart';

class AppRouteFactory {
  /// Used to push/pop screens from blocs.
  final navigatorKey = GlobalKey<NavigatorState>();

  final AbstractDrugRepository repository;
  final List<Drug> drugs;

  AppRouteFactory(this.repository, this.drugs);

  Route<dynamic> generateRoute(RouteSettings settings, BuildContext context) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case AppRoutes.drugList:
        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, _, __) => _buildDrugListScreen(context));
      case AppRoutes.manageDrug:
        return platformPageRoute(
            context: context,
            settings: settings,
            fullscreenDialog: true,
            builder: (context) => _buildManageDrugScreen(context, arguments));
        break;
    }
    return _buildUnknownRoute(
      context,
    );
  }

  // TODO: Improve appearance
  Route<dynamic> _buildUnknownRoute(BuildContext context) => platformPageRoute(
        context: context,
        builder: (_) => Container(
          child: Center(
            child: Text('Unknown route'),
          ),
        ),
      );

  Widget _buildDrugListScreen(
    BuildContext context,
  ) =>
      BlocProvider<DrugListBloc>(
        create: (context) => DrugListBloc(
          repository,
          drugs,
        ),
        child: DrugListScreen(),
      );

  Widget _buildManageDrugScreen(
    BuildContext context,
    Drug drug,
  ) =>
      BlocProvider<ManageDrugBloc>(
        create: (context) => ManageDrugBloc(
          navigatorKey,
          repository,
          drug,
        ),
        child: ManageDrugScreen(),
      );
}
