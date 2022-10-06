import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurants/core/constants/lotti_assets.dart';
import 'package:restaurants/features/auth/provider/auth_provider.dart';
import 'package:restaurants/features/restaurant/provider/restaurant_provider.dart';
import 'package:restaurants/features/table/models/users_table.dart';
import 'package:restaurants/features/table/provider/table_provider.dart';
import 'package:restaurants/ui/widgets/buttons/custom_elevated_button.dart';

class TableMenuScreen extends ConsumerWidget {
  const TableMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableProv = ref.watch(tableProvider);
    final restaurantState = ref.watch(restaurantProvider);
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                restaurantState.restaurant.on(
                  onData: (data) => Text(
                    'Mesa: ${data.tableName}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  onError: (err) => Center(child: Text('Error ${err.message}')),
                  onLoading: () => const Center(child: CircularProgressIndicator()),
                  onInitial: () => const SizedBox(),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Lottie.asset(
                        LottieAssets.ordering,
                        width: 140,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Estado',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text('Ordenando...'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: [
                      tableProv.tableUsers.on(
                        onData: (data) => ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: data.users.length,
                          itemBuilder: (context, index) {
                            final item = data.users[index];
                            return TableUserCard(userTable: item);
                          },
                        ),
                        onError: (e) => Center(child: Text(e.message)),
                        onLoading: () => const SizedBox(),
                        onInitial: () => const SizedBox(),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 5,
            left: 20,
            right: 20,
            child: CustomElevatedButton(
              onPressed: handleOnOrderNow,
              child: const Text('Ordenar ahora'),
            ),
          ),
        ],
      ),
    );
  }

  void handleOnOrderNow() {}
}

class TableUserCard extends ConsumerWidget {
  const TableUserCard({
    Key? key,
    required this.userTable,
  }) : super(key: key);

  final UserTable userTable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProv = ref.watch(authProvider);
    final isMine = authProv.authModel.data?.user.id == userTable.userId;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isMine ? Colors.deepOrange : Colors.blueAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.person),
      ),
      title: Text(
        '${userTable.firstName} ${userTable.lastName} ${isMine ? '(Yo)' : ''}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
