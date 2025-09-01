import 'package:flutter/material.dart';
import '../../models/admin_user.dart';

class UserEditDialog extends StatefulWidget {
  final AdminUser user;
  
  const UserEditDialog({
    super.key,
    required this.user,
  });

  @override
  State<UserEditDialog> createState() => _UserEditDialogState();
}

class _UserEditDialogState extends State<UserEditDialog> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _rankController;
  late TextEditingController _levelController;
  late TextEditingController _currentHpController;
  late TextEditingController _maxHpController;
  late TextEditingController _currentChakraController;
  late TextEditingController _maxChakraController;
  late TextEditingController _currentStaminaController;
  late TextEditingController _maxStaminaController;
  late TextEditingController _villageController;
  
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _rankController = TextEditingController(text: widget.user.rank);
    _levelController = TextEditingController(text: widget.user.level.toString());
    _currentHpController = TextEditingController(text: widget.user.currentHp.toString());
    _maxHpController = TextEditingController(text: widget.user.maxHp.toString());
    _currentChakraController = TextEditingController(text: widget.user.currentChakra.toString());
    _maxChakraController = TextEditingController(text: widget.user.maxChakra.toString());
    _currentStaminaController = TextEditingController(text: widget.user.currentStamina.toString());
    _maxStaminaController = TextEditingController(text: widget.user.maxStamina.toString());
    _villageController = TextEditingController(text: widget.user.village);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _rankController.dispose();
    _levelController.dispose();
    _currentHpController.dispose();
    _maxHpController.dispose();
    _currentChakraController.dispose();
    _maxChakraController.dispose();
    _currentStaminaController.dispose();
    _maxStaminaController.dispose();
    _villageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Edit User: ${widget.user.username}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Info Section
                      _buildSectionHeader('Basic Information'),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Username is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _rankController,
                              decoration: const InputDecoration(
                                labelText: 'Rank',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Rank is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _levelController,
                              decoration: const InputDecoration(
                                labelText: 'Level',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Level is required';
                                }
                                final level = int.tryParse(value);
                                if (level == null || level < 1) {
                                  return 'Level must be a positive number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _villageController,
                        decoration: const InputDecoration(
                          labelText: 'Village',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Village is required';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Stats Section
                      _buildSectionHeader('Character Stats'),
                      const SizedBox(height: 16),
                      
                      // HP Stats
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _currentHpController,
                              decoration: const InputDecoration(
                                labelText: 'Current HP',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Current HP is required';
                                }
                                final hp = int.tryParse(value);
                                if (hp == null || hp < 0) {
                                  return 'HP must be a non-negative number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _maxHpController,
                              decoration: const InputDecoration(
                                labelText: 'Max HP',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Max HP is required';
                                }
                                final hp = int.tryParse(value);
                                if (hp == null || hp < 1) {
                                  return 'Max HP must be a positive number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Chakra Stats
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _currentChakraController,
                              decoration: const InputDecoration(
                                labelText: 'Current Chakra',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Current Chakra is required';
                                }
                                final chakra = int.tryParse(value);
                                if (chakra == null || chakra < 0) {
                                  return 'Chakra must be a non-negative number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _maxChakraController,
                              decoration: const InputDecoration(
                                labelText: 'Max Chakra',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Max Chakra is required';
                                }
                                final chakra = int.tryParse(value);
                                if (chakra == null || chakra < 1) {
                                  return 'Max Chakra must be a positive number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Stamina Stats
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _currentStaminaController,
                              decoration: const InputDecoration(
                                labelText: 'Current Stamina',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Current Stamina is required';
                                }
                                final stamina = int.tryParse(value);
                                if (stamina == null || stamina < 0) {
                                  return 'Stamina must be a non-negative number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _maxStaminaController,
                              decoration: const InputDecoration(
                                labelText: 'Max Stamina',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Max Stamina is required';
                                }
                                final stamina = int.tryParse(value);
                                if (stamina == null || stamina < 1) {
                                  return 'Max Stamina must be a positive number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) return;
    
    final updatedUser = widget.user.copyWith(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      rank: _rankController.text.trim(),
      level: int.parse(_levelController.text),
      currentHp: int.parse(_currentHpController.text),
      maxHp: int.parse(_maxHpController.text),
      currentChakra: int.parse(_currentChakraController.text),
      maxChakra: int.parse(_maxChakraController.text),
      currentStamina: int.parse(_currentStaminaController.text),
      maxStamina: int.parse(_maxStaminaController.text),
      village: _villageController.text.trim(),
    );
    
    Navigator.of(context).pop(updatedUser);
  }
}
