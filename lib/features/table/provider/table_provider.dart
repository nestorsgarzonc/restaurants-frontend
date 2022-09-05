import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurants/core/router/router.dart';
import 'package:restaurants/core/validators/text_form_validator.dart';
import 'package:restaurants/features/table/provider/table_state.dart';
import 'package:restaurants/ui/menu/menu_screen.dart';
import 'package:restaurants/ui/widgets/snackbar/custom_snackbar.dart';

final tableProvider = StateNotifierProvider<TableProvider, TableState>((ref) {
  return TableProvider(read: ref.read);
});

class TableProvider extends StateNotifier<TableState> {
  TableProvider({required this.read}) : super(const TableState());

  final Reader read;

  Future<void> onReadTableCode(String code) async {
    final validationError = TextFormValidator.tableCodeValidator(code);
    if (validationError != null) {
      CustomSnackbar.showSnackBar(read(routerProvider).context, validationError);
      return;
    }
    state = state.copyWith(tableCode: code);
    GoRouter.of(read(routerProvider).context).go('${MenuScreen.route}?tableId=$code');
  }
}
