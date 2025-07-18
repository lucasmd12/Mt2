import 'package:flutter/material.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() => _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    // Simulando carregamento de usuários
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _users = [
            {
              'id': '1',
              'username': 'lucasg',
              'email': 'lucas@example.com',
              'role': 'user',
              'isOnline': true,
              'lastSeen': DateTime.now(),
              'clanName': 'POCASIDEIA',
              'clanTag': 'PCD',
            },
            {
              'id': '2',
              'username': 'admin',
              'email': 'admin@example.com',
              'role': 'admMaster',
              'isOnline': false,
              'lastSeen': DateTime.now().subtract(const Duration(hours: 2)),
              'clanName': null,
              'clanTag': null,
            },
            {
              'id': '3',
              'username': 'player1',
              'email': 'player1@example.com',
              'role': 'clanMember',
              'isOnline': true,
              'lastSeen': DateTime.now(),
              'clanName': 'WARRIORS',
              'clanTag': 'WAR',
            },
          ];
          _filteredUsers = List.from(_users);
          _isLoading = false;
        });
      }
    });
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = List.from(_users);
      } else {
        _filteredUsers = _users.where((user) {
          return user['username'].toLowerCase().contains(query.toLowerCase()) ||
                 user['email'].toLowerCase().contains(query.toLowerCase()) ||
                 (user['clanName']?.toLowerCase().contains(query.toLowerCase()) ?? false);
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
              'Conteúdo da Gestão de Usuários ADM',
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
                hintText: 'Pesquisar usuários...',
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
              onChanged: _filterUsers,
            ),
          ),

          const SizedBox(height: 16),

          // Lista de usuários
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return _buildUserCard(user);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Adicionar novo usuário
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final isOnline = user['isOnline'] ?? false;
    final role = user['role'] ?? 'user';
    final clanName = user['clanName'];
    final clanTag = user['clanTag'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOnline ? Colors.green.withOpacity(0.5) : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar do usuário
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: _getRoleColor(role),
                    child: Text(
                      user['username'][0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: isOnline ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // Informações do usuário
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['username'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user['email'],
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    if (clanName != null && clanTag != null)
                      Text(
                        'Clã: $clanName [$clanTag]',
                        style: TextStyle(
                          color: Colors.blue[300],
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),

              // Badge do role
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getRoleColor(role),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getRoleDisplayName(role),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Ações do usuário
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                'Editar',
                Icons.edit,
                Colors.blue,
                () => _editUser(user),
              ),
              _buildActionButton(
                'Banir',
                Icons.block,
                Colors.red,
                () => _banUser(user),
              ),
              _buildActionButton(
                'Promover',
                Icons.arrow_upward,
                Colors.green,
                () => _promoteUser(user),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(80, 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admMaster':
        return Colors.red;
      case 'clanLeader':
        return Colors.orange;
      case 'clanSubLeader':
        return Colors.yellow.shade700;
      case 'clanMember':
        return Colors.blue;
      case 'user':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'admMaster':
        return 'ADM MASTER';
      case 'clanLeader':
        return 'LÍDER';
      case 'clanSubLeader':
        return 'SUB-LÍDER';
      case 'clanMember':
        return 'MEMBRO';
      case 'user':
        return 'USUÁRIO';
      default:
        return role.toUpperCase();
    }
  }

  void _editUser(Map<String, dynamic> user) {
    // Implementar edição de usuário
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editando usuário: ${user['username']}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _banUser(Map<String, dynamic> user) {
    // Implementar banimento de usuário
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: const Text('Confirmar Banimento', style: TextStyle(color: Colors.white)),
        content: Text(
          'Tem certeza que deseja banir o usuário ${user['username']}?',
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
                  content: Text('Usuário ${user['username']} foi banido'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Banir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _promoteUser(Map<String, dynamic> user) {
    // Implementar promoção de usuário
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Promovendo usuário: ${user['username']}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

