import 'package:flutter/material.dart';
import '../services/firebase_test.dart';
import '../widgets/logout_button.dart';

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  bool _isTesting = false;
  bool _connectionTestPassed = false;
  bool _collectionsTestPassed = false;
  String _testResults = '';

  Future<void> _runConnectionTest() async {
    setState(() {
      _isTesting = true;
      _testResults = 'Running connection test...\n';
    });

    try {
      final success = await FirebaseTest.testConnection();
      setState(() {
        _connectionTestPassed = success;
        _testResults += success 
            ? '✅ Connection test PASSED!\n'
            : '❌ Connection test FAILED!\n';
      });
    } catch (e) {
      setState(() {
        _connectionTestPassed = false;
        _testResults += '❌ Connection test ERROR: $e\n';
      });
    }
  }

  Future<void> _runCollectionsTest() async {
    setState(() {
      _isTesting = true;
      _testResults += 'Running collections test...\n';
    });

    try {
      await FirebaseTest.testCollections();
      setState(() {
        _collectionsTestPassed = true;
        _testResults += '✅ Collections test completed!\n';
      });
    } catch (e) {
      setState(() {
        _collectionsTestPassed = false;
        _testResults += '❌ Collections test ERROR: $e\n';
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Connection Test'),
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
        actions: const [
          LogoutButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Firebase Status',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _connectionTestPassed ? Icons.check_circle : Icons.error,
                          color: _connectionTestPassed ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Connection: ${_connectionTestPassed ? "Connected" : "Not Connected"}',
                          style: TextStyle(
                            color: _connectionTestPassed ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          _collectionsTestPassed ? Icons.check_circle : Icons.error,
                          color: _collectionsTestPassed ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Collections: ${_collectionsTestPassed ? "Accessible" : "Not Tested"}',
                          style: TextStyle(
                            color: _collectionsTestPassed ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isTesting ? null : _runConnectionTest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Test Connection'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isTesting ? null : _runCollectionsTest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Test Collections'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Test Results',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              _testResults.isEmpty ? 'No tests run yet' : _testResults,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
