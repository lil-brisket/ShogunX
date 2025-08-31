import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../services/services.dart';

class AvatarChangeDialog extends ConsumerStatefulWidget {
  final Character character;
  final Function(String? avatarUrl) onAvatarChanged;

  const AvatarChangeDialog({
    super.key,
    required this.character,
    required this.onAvatarChanged,
  });

  @override
  ConsumerState<AvatarChangeDialog> createState() => _AvatarChangeDialogState();
}

class _AvatarChangeDialogState extends ConsumerState<AvatarChangeDialog> {
  final TextEditingController _urlController = TextEditingController();
  final AvatarService _avatarService = AvatarService();
  List<String> _recentAvatars = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAvatars();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _loadAvatars() async {
    setState(() => _isLoading = true);
    
    try {
      final recent = await _avatarService.getAvatarHistory();
      
      setState(() {
        _recentAvatars = recent;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addCustomAvatar() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    if (!_avatarService.isValidAvatarUrl(url)) {
      if (mounted) {
        _showErrorSnackbar('Please enter a valid URL');
      }
      return;
    }

    // Add to history and update avatar
    await _avatarService.addAvatarToHistory(url);
    widget.onAvatarChanged(url);
    if (mounted) {
      Navigator.of(context).pop();
      _showSuccessSnackbar('Avatar updated successfully!');
    }
  }

  Future<void> _selectAvatar(String? avatarUrl) async {
    if (avatarUrl != null) {
      await _avatarService.addAvatarToHistory(avatarUrl);
    }
    widget.onAvatarChanged(avatarUrl);
    if (mounted) {
      Navigator.of(context).pop();
      _showSuccessSnackbar('Avatar updated successfully!');
    }
  }

  Future<void> _removeFromHistory(String avatarUrl) async {
    await _avatarService.removeAvatarFromHistory(avatarUrl);
    await _loadAvatars();
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF16213e),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a2e),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.face, color: Colors.deepOrange, size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'Change Avatar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.deepOrange))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Custom URL Input
                          _buildUrlInputSection(),
                          const SizedBox(height: 24),

                          // Current Avatar
                          _buildCurrentAvatarSection(),
                          const SizedBox(height: 24),

                          // Recent Avatars
                          if (_recentAvatars.isNotEmpty) ...[
                            _buildSectionTitle('Recent Avatars'),
                            const SizedBox(height: 16),
                            _buildAvatarGrid(_recentAvatars, isRecent: true),
                            const SizedBox(height: 24),
                          ],


                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrlInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Paste Avatar URL',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _urlController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'https://example.com/avatar.jpg',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                  filled: true,
                  fillColor: const Color(0xFF1a1a2e),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.deepOrange.withValues(alpha: 0.5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.deepOrange.withValues(alpha: 0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.deepOrange),
                  ),
                ),
                onSubmitted: (_) => _addCustomAvatar(),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _addCustomAvatar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrentAvatarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Current Avatar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: () => _selectAvatar(null),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.character.avatarUrl == null
                    ? Colors.deepOrange.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.character.avatarUrl == null
                      ? Colors.deepOrange
                      : Colors.grey,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(12),
                      image: widget.character.avatarUrl != null
                          ? DecorationImage(
                              image: NetworkImage(widget.character.avatarUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: widget.character.avatarUrl == null
                        ? const Icon(Icons.person, color: Colors.white, size: 40)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Default Avatar',
                    style: TextStyle(
                      color: widget.character.avatarUrl == null
                          ? Colors.deepOrange
                          : Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAvatarGrid(List<String> avatars, {required bool isRecent}) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: avatars.map((avatarUrl) => _buildAvatarTile(avatarUrl, isRecent)).toList(),
    );
  }

  Widget _buildAvatarTile(String avatarUrl, bool isRecent) {
    final isCurrent = widget.character.avatarUrl == avatarUrl;
    
    return GestureDetector(
      onTap: () => _selectAvatar(avatarUrl),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isCurrent
              ? Colors.deepOrange.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCurrent ? Colors.deepOrange : Colors.grey,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(avatarUrl),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        // Handle image loading errors
                      },
                    ),
                  ),
                ),
                if (isCurrent)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.deepOrange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (isRecent)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _removeFromHistory(avatarUrl),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.red,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
