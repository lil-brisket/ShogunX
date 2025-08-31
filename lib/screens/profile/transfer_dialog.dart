import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../services/banking_service.dart';

class TransferDialog extends ConsumerStatefulWidget {
  final Character character;

  const TransferDialog({
    super.key,
    required this.character,
  });

  @override
  ConsumerState<TransferDialog> createState() => _TransferDialogState();
}

class _TransferDialogState extends ConsumerState<TransferDialog> {
  final _searchController = TextEditingController();
  final _amountController = TextEditingController();
  final _messageController = TextEditingController();
  
  Character? _selectedRecipient;
  bool _isSearching = false;
  List<Character> _searchResults = [];
  
  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxTransfer = widget.character.ryoOnHand;
    final canTransfer = maxTransfer >= BankingService.minTransferAmount;

    return Dialog(
      backgroundColor: const Color(0xFF16213e),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.send, color: Colors.purple),
                const SizedBox(width: 8),
                const Text(
                  'Transfer Ryo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Transfer Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info, color: Colors.amber, size: 16),
                      const SizedBox(width: 6),
                      const Text(
                        'Transfer Information',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Available to send: ${_formatNumber(maxTransfer)} Ryo',
                    style: const TextStyle(color: Colors.green, fontSize: 12),
                  ),
                  Text(
                    'Minimum transfer: ${BankingService.minTransferAmount} Ryo',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            if (!canTransfer) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Insufficient funds for transfer',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Player Search
            const Text(
              'Search Player',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter player name...',
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.deepOrange),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.deepOrange.withValues(alpha: 0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: canTransfer ? _searchPlayers : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  child: _isSearching
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Search'),
                ),
              ],
            ),

            // Search Results / Selected Player
            const SizedBox(height: 16),
            Expanded(
              child: _selectedRecipient != null
                  ? _buildSelectedPlayer()
                  : _buildSearchResults(),
            ),

            // Transfer Form (only if player selected and can transfer)
            if (_selectedRecipient != null && canTransfer) ...[
              const SizedBox(height: 16),
              _buildTransferForm(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty && !_isSearching) {
      return const Center(
        child: Text(
          'Search for players to transfer Ryo to',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      );
    }

    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.purple),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search Results (${_searchResults.length})',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final player = _searchResults[index];
              return _buildPlayerCard(player, () {
                setState(() {
                  _selectedRecipient = player;
                });
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedPlayer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Selected Player',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedRecipient = null;
                });
              },
              child: const Text(
                'Change',
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildPlayerCard(_selectedRecipient!, null),
      ],
    );
  }

  Widget _buildPlayerCard(Character player, VoidCallback? onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _selectedRecipient?.id == player.id
                ? Colors.purple.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _selectedRecipient?.id == player.id
                  ? Colors.purple
                  : Colors.white.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(8),
                  image: player.avatarUrl != null 
                      ? DecorationImage(
                          image: NetworkImage(player.avatarUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: player.avatarUrl == null
                    ? Center(
                        child: Text(
                          player.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${player.ninjaRank} • ${player.village}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransferForm() {
    final maxTransfer = widget.character.ryoOnHand;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transfer Details',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          
          // Amount Field
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Amount (Ryo)',
              labelStyle: const TextStyle(color: Colors.white70),
                                  hintText: 'Min: ${BankingService.minTransferAmount}, Max: ${_formatNumber(maxTransfer)}',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
              prefixIcon: const Icon(Icons.monetization_on, color: Colors.amber),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Message Field
          TextField(
            controller: _messageController,
            style: const TextStyle(color: Colors.white),
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Message (optional)',
              labelStyle: const TextStyle(color: Colors.white70),
              hintText: 'Add a message with your transfer...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
              prefixIcon: const Icon(Icons.message, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Transfer Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _performTransfer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Send Transfer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchPlayers() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      final bankingService = ref.read(bankingServiceProvider);
      final results = await bankingService.searchPlayersForTransfer(
        query,
        excludeCharacterId: widget.character.id,
      );
      
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (error) {
      setState(() {
        _isSearching = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _performTransfer() async {
    final amountStr = _amountController.text.trim();
    final amount = int.tryParse(amountStr);
    final message = _messageController.text.trim();

    if (amount == null || amount <= 0) {
      _showSnackbar('Please enter a valid amount', Colors.red);
      return;
    }

    if (amount < BankingService.minTransferAmount) {
      _showSnackbar('Minimum transfer is ${BankingService.minTransferAmount} Ryo', Colors.red);
      return;
    }

    final maxTransfer = widget.character.ryoOnHand;
    if (amount > maxTransfer) {
      _showSnackbar('Maximum transfer is ${_formatNumber(maxTransfer)} Ryo', Colors.red);
      return;
    }

    if (_selectedRecipient == null) {
      _showSnackbar('Please select a recipient', Colors.red);
      return;
    }

    try {
      final bankingNotifier = ref.read(bankingNotifierProvider(widget.character.id).notifier);
      final result = await bankingNotifier.transferTo(
        _selectedRecipient!.id,
        amount,
        message: message.isNotEmpty ? message : null,
      );

      if (mounted) {
        _showSnackbar(result.message, result.success ? Colors.green : Colors.red);
        
        if (result.success) {
          Navigator.of(context).pop();
        }
      }
    } catch (error) {
      if (mounted) {
        _showSnackbar('Transfer failed: $error', Colors.red);
      }
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
  }
}