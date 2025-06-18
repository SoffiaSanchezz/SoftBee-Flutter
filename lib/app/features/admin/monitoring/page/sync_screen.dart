import 'package:flutter/material.dart';
import 'package:soft_bee/app/features/admin/monitoring/service/local_db_service.dart';
import 'package:soft_bee/app/features/admin/monitoring/service/sync_service.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({Key? key}) : super(key: key);

  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final SyncService syncService = SyncService();
  final LocalDBService localDB = LocalDBService();
  bool isSyncing = false;
  String syncStatus = '';
  int pendingCount = 0;

  @override
  void initState() {
    super.initState();
    _loadPendingCount();
  }

  Future<void> _loadPendingCount() async {
    final pendientes = await localDB.getMonitoreosPendientes();
    setState(() {
      pendingCount = pendientes.length;
    });
  }

  Future<void> _syncData() async {
    setState(() {
      isSyncing = true;
      syncStatus = 'Buscando datos pendientes...';
    });

    final pendientes = await localDB.getMonitoreosPendientes();

    if (pendientes.isEmpty) {
      setState(() {
        syncStatus = 'No hay datos pendientes por sincronizar';
        isSyncing = false;
      });
      return;
    }

    setState(() {
      syncStatus = 'Sincronizando ${pendientes.length} monitoreos...';
    });

    final success = await syncService.syncMonitoreos(pendientes);

    setState(() {
      isSyncing = false;
      syncStatus =
          success
              ? 'Sincronización completada con éxito'
              : 'Error en la sincronización. Intente nuevamente.';

      if (success) {
        pendingCount = 0;
      } else {
        _loadPendingCount();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sincronización de Datos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.sync, size: 50),
                    const SizedBox(height: 16),
                    Text(
                      'Monitoreos pendientes: $pendingCount',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isSyncing) ...[
              const LinearProgressIndicator(),
              const SizedBox(height: 16),
            ],
            Text(
              syncStatus,
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    isSyncing
                        ? Colors.blue
                        : syncStatus.contains('éxito')
                        ? Colors.green
                        : syncStatus.contains('Error')
                        ? Colors.red
                        : Colors.black,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: isSyncing ? null : _syncData,
              child: const Text('Sincronizar Ahora'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
