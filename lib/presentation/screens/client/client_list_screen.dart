import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/client_provider.dart';
import '../widgets/client/client_card.dart';
import '../widgets/common/loading_widget.dart';
import '../widgets/common/message_widget.dart';
import 'add_client_screen.dart';
import 'client_detail_screen.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({Key? key}) : super(key: key);

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _loadClients();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _loadClients() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final clientProvider = Provider.of<ClientProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      clientProvider.getClientList(authProvider.user!.id);
    }
  }
  
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final clientProvider = Provider.of<ClientProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      clientProvider.searchClients(authProvider.user!.id, query);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              authProvider.signOut().then((_) {
                Navigator.of(context).pushReplacementNamed('/login');
              });
            },
          ),
        ],
      ),
      body: Consumer2<AuthProvider, ClientProvider>(
        builder: (context, authProvider, clientProvider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search clients',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              Expanded(
                child: clientProvider.isLoading
                    ? const LoadingWidget()
                    : clientProvider.errorMessage != null
                        ? MessageWidget(
                            message: clientProvider.errorMessage!,
                            type: MessageType.error,
                          )
                        : clientProvider.clients.isEmpty
                            ? const Center(
                                child: Text('No clients found'),
                              )
                            : RefreshIndicator(
                                onRefresh: () async {
                                  _loadClients();
                                },
                                child: ListView.builder(
                                  itemCount: clientProvider.clients.length,
                                  itemBuilder: (context, index) {
                                    final client = clientProvider.clients[index];
                                    return ClientCard(
                                      client: client,
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ClientDetailScreen(clientId: client.id),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddClientScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}