import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucasbeatsfederacao/services/clan_service.dart';
import 'package:lucasbeatsfederacao/models/clan_war_model.dart';
import 'package:lucasbeatsfederacao/utils/logger.dart';
import 'package:lucasbeatsfederacao/widgets/custom_snackbar.dart';

class AdminManageWarsScreen extends StatefulWidget {
  const AdminManageWarsScreen({super.key});

  @override
  State<AdminManageWarsScreen> createState() => _AdminManageWarsScreenState();
}

class _AdminManageWarsScreenState extends State<AdminManageWarsScreen> {
  List<ClanWar> _activeWars = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadActiveWars();
  }

  Future<void> _loadActiveWars() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final clanService = Provider.of<ClanService>(context, listen: false);
      final wars = await clanService.getActiveWars();
      if (mounted) {
        setState(() {
          _activeWars = wars;
        });
      }
    } catch (e, s) {
      Logger.error('Error loading active wars:', error: e, stackTrace: s);
      if (mounted) {
        CustomSnackbar.showError(context, 'Erro ao carregar guerras ativas: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleWarAction(String warId, String action) async {
    try {
      final clanService = Provider.of<ClanService>(context, listen: false);
      ClanWar? warResult = null;
      String message = '';
      // Placeholder values - TODO: Implement UI to collect actual data
      String placeholderWinnerId = 'placeholder_winner_id';
      String placeholderLoserId = 'placeholder_loser_id';
      Map<String, int> placeholderScore = {'placeholder_key': 0};

      switch (action) {
        case 'accept':
 warResult = await clanService.acceptWar(warId);
          message = 'Guerra aceita com sucesso!';
          break;
        case 'reject':
 warResult = await clanService.rejectWar(warId);
          message = 'Guerra rejeitada com sucesso!';
          break;
        case 'cancel':
 warResult = await clanService.cancelWar(warId, 'Cancelled by Admin'); // TODO: Allow admin to provide a reason
          message = 'Guerra cancelada com sucesso!';
          break;
        case 'report_win':
 warResult = await clanService.reportWarResult(warId, placeholderWinnerId, placeholderLoserId, placeholderScore); // TODO: Implement UI to select winner/loser and input score
          message = 'Resultado de vitória reportado com sucesso!';
          break;
        case 'report_loss':
 warResult = await clanService.reportWarResult(warId, placeholderWinnerId, placeholderLoserId, placeholderScore); // TODO: Implement UI to select winner/loser and input score
          message = 'Resultado de derrota reportado com sucesso!';
          break;
        case 'report_draw':
 warResult = await clanService.reportWarResult(warId, placeholderWinnerId, placeholderLoserId, placeholderScore); // TODO: Implement UI to select winner/loser and input score
          message = 'Resultado de empate reportado com sucesso!';
          break;
      }

      if (warResult != null) {
        // Refine success message based on action for clarity
        String specificMessage = '';
        if (action == 'accept') specificMessage = 'Guerra aceita!';
        else if (action == 'reject') specificMessage = 'Guerra rejeitada!';
        else if (action == 'cancel') specificMessage = 'Guerra cancelada!';
        else if (action.startsWith('report')) specificMessage = 'Resultado reportado!';
        CustomSnackbar.showSuccess(context, specificMessage);
        CustomSnackbar.showSuccess(context, message);
        _loadActiveWars(); // Refresh list
      } else {
        CustomSnackbar.showError(context, 'Falha na ação: $message');
      }
    } catch (e, s) {
      Logger.error('Error handling war action:', error: e, stackTrace: s);
      CustomSnackbar.showError(context, 'Erro ao executar ação: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Guerras'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _activeWars.isEmpty
              ? const Center(child: Text('Nenhuma guerra ativa encontrada.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _activeWars.length,
                  itemBuilder: (context, index) {
                    final war = _activeWars[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${war.challengerClan.name} vs ${war.challengedClan.name}',
 style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text('Status: ${war.status}'),
                            Text('Início: ${war.declaredAt.toLocal().toString().split('.')[0]}'),
                            if (war.endedAt != null)
                              Text('Fim: ${war.endedAt!.toLocal().toString().split('.')[0]}'),
                            // Display result if war has ended, otherwise display status
                            if (war.endedAt != null) ...[
                              if (war.winnerClan != null)
                                Text('Vencedor: ${war.winnerClan!.name}')
                              else if (war.loserClan != null)
                                Text('Perdedor: ${war.loserClan!.name}')
                              else Text('Resultado: Empate'), // Assuming if ended and no winner/loser, it's a draw
                            ],
                            const SizedBox(height: 16.0),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: [
                                if (war.status == 'pending') ...[
                                  ElevatedButton(
                                    onPressed: () => _handleWarAction(war.id, 'accept'),
                                    child: const Text('Aceitar'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _handleWarAction(war.id, 'reject'),
                                    child: const Text('Rejeitar'),
                                  ),
                                ],
                                if (war.status == 'active') ...[
                                  ElevatedButton(
                                    onPressed: () => _handleWarAction(war.id, 'report_win'),
                                    child: const Text('Reportar Vitória'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _handleWarAction(war.id, 'report_loss'),
                                    child: const Text('Reportar Derrota'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _handleWarAction(war.id, 'report_draw'),
                                    child: const Text('Reportar Empate'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _handleWarAction(war.id, 'cancel'),
                                    child: const Text('Cancelar'),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}


