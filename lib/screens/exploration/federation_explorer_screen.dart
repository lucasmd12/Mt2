import 'package:flutter/material.dart';

class FederationExplorerScreen extends StatefulWidget {
  const FederationExplorerScreen({super.key});

  @override
  State<FederationExplorerScreen> createState() => _FederationExplorerScreenState();
}

class _FederationExplorerScreenState extends State<FederationExplorerScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _federations = [];
  List<Map<String, dynamic>> _filteredFederations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFederations();
  }

  void _loadFederations() {
    // Simulando carregamento de federações
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _federations = [
            {
              'id': '1',
              'name': 'FEDERACAO MADOUT',
              'tag': 'FMAD',
              'description': 'A maior federação de gaming do Brasil',
              'memberCount': 1247,
              'clanCount': 156,
              'isPublic': true,
              'logo': null,
              'bannerColor': Colors.purple,
            },
            {
              'id': '2',
              'name': 'ELITE WARRIORS',
              'tag': 'EW',
              'description': 'Federação focada em competições e torneios',
              'memberCount': 892,
              'clanCount': 89,
              'isPublic': true,
              'logo': null,
              'bannerColor': Colors.red,
            },
            {
              'id': '3',
              'name': 'CASUAL GAMERS',
              'tag': 'CG',
              'description': 'Para jogadores casuais e iniciantes',
              'memberCount': 567,
              'clanCount': 67,
              'isPublic': true,
              'logo': null,
              'bannerColor': Colors.blue,
            },
            {
              'id': '4',
              'name': 'PRO LEAGUE',
              'tag': 'PL',
              'description': 'Federação exclusiva para jogadores profissionais',
              'memberCount': 234,
              'clanCount': 23,
              'isPublic': false,
              'logo': null,
              'bannerColor': Colors.orange,
            },
          ];
          _filteredFederations = List.from(_federations);
          _isLoading = false;
        });
      }
    });
  }

  void _filterFederations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredFederations = List.from(_federations);
      } else {
        _filteredFederations = _federations.where((federation) {
          return federation['name'].toLowerCase().contains(query.toLowerCase()) ||
                 federation['tag'].toLowerCase().contains(query.toLowerCase()) ||
                 federation['description'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Cabeçalho
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Conteúdo da Tela de Exploração de Federações',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 16),

          // Barra de pesquisa
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Pesquisar federações...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.grey[800],
              ),
              onChanged: _filterFederations,
            ),
          ),

          const SizedBox(height: 16),

          // Lista de federações
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  )
                : _filteredFederations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhuma federação encontrada',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredFederations.length,
                        itemBuilder: (context, index) {
                          final federation = _filteredFederations[index];
                          return _buildFederationCard(federation);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFederationCard(Map<String, dynamic> federation) {
    final isPublic = federation['isPublic'] ?? true;
    final bannerColor = federation['bannerColor'] ?? Colors.blue;
    final memberCount = federation['memberCount'] ?? 0;
    final clanCount = federation['clanCount'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bannerColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Banner da federação
          Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [bannerColor, bannerColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Stack(
              children: [
                // Logo da federação (placeholder)
                Positioned(
                  left: 16,
                  top: 16,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.account_tree,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                
                // Tag da federação
                Positioned(
                  right: 16,
                  top: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '[${federation['tag']}]',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Status público/privado
                Positioned(
                  right: 16,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPublic ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isPublic ? 'Público' : 'Privado',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Conteúdo da federação
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome da federação
                Text(
                  federation['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // Descrição
                Text(
                  federation['description'],
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                // Estatísticas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('Membros', '$memberCount', Icons.people),
                    _buildStatColumn('Clãs', '$clanCount', Icons.groups),
                    _buildStatColumn('Rank', '#${federation['id']}', Icons.star),
                  ],
                ),

                const SizedBox(height: 16),

                // Botões de ação
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _viewFederation(federation),
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('Ver Detalhes'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isPublic ? () => _joinFederation(federation) : null,
                        icon: Icon(
                          isPublic ? Icons.add : Icons.lock,
                          size: 16,
                        ),
                        label: Text(isPublic ? 'Solicitar' : 'Privado'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPublic ? Colors.green : Colors.grey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _viewFederation(Map<String, dynamic> federation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: Text(
          federation['name'],
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tag: [${federation['tag']}]',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              federation['description'],
              style: TextStyle(color: Colors.grey[300]),
            ),
            const SizedBox(height: 16),
            Text(
              'Estatísticas:',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '• ${federation['memberCount']} membros',
              style: TextStyle(color: Colors.grey[300]),
            ),
            Text(
              '• ${federation['clanCount']} clãs',
              style: TextStyle(color: Colors.grey[300]),
            ),
            Text(
              '• ${federation['isPublic'] ? 'Federação pública' : 'Federação privada'}',
              style: TextStyle(color: Colors.grey[300]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _joinFederation(Map<String, dynamic> federation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: const Text('Solicitar Entrada', style: TextStyle(color: Colors.white)),
        content: Text(
          'Deseja solicitar entrada na federação ${federation['name']}?',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Solicitação enviada para ${federation['name']}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Solicitar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

