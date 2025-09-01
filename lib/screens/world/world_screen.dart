import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/logout_button.dart';



class WorldScreen extends ConsumerWidget {
  const WorldScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    return Scaffold(
      backgroundColor: const Color(0xFF0f3460),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a2e),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.deepOrange.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.map,
                    color: Colors.deepOrange,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'World Map',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Explore the ninja world',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const LogoutButton(),
                ],
              ),
            ),
            
            // World Map
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Map Grid
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF16213e),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.deepOrange.withValues(alpha: 0.3),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: GridView.builder(
                            padding: const EdgeInsets.all(8),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 25,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1,
                            ),
                            itemCount: 625, // 25x25 grid
                            itemBuilder: (context, index) {
                              return _buildMapTile(index);
                            },
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Legend
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16213e),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.deepOrange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Map Legend',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: [
                              _buildLegendItem('Village', Colors.orange),
                              _buildLegendItem('Safe Zone', Colors.green),
                              _buildLegendItem('Danger Zone', Colors.red),
                              _buildLegendItem('PvP Zone', Colors.purple),
                              _buildLegendItem('PvE Zone', Colors.blue),
                              _buildLegendItem('Resource Zone', Colors.yellow),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapTile(int index) {
    // Calculate position in 25x25 grid
    final row = index ~/ 25;
    final col = index % 25;
    
    // Determine tile type based on position
    Color tileColor = Colors.grey;
    
    // Village locations (center of each quadrant)
    if ((row == 12 && col == 12) || // Center
        (row == 6 && col == 6) ||   // Top-left village
        (row == 6 && col == 18) ||  // Top-right village
        (row == 18 && col == 6) ||  // Bottom-left village
        (row == 18 && col == 18)) { // Bottom-right village
      tileColor = Colors.orange.withValues(alpha: 0.6);
    }
    // Safe zones around villages
    else if ((row >= 5 && row <= 7 && col >= 5 && col <= 7) ||
             (row >= 5 && row <= 7 && col >= 17 && col <= 19) ||
             (row >= 17 && row <= 19 && col >= 5 && col <= 7) ||
             (row >= 17 && row <= 19 && col >= 17 && col <= 19) ||
             (row >= 11 && row <= 13 && col >= 11 && col <= 13)) {
      tileColor = Colors.green.withValues(alpha: 0.3);
    }
    // PvP zones (edges)
    else if (row == 0 || row == 24 || col == 0 || col == 24) {
      tileColor = Colors.purple.withValues(alpha: 0.6);
    }
    // PvE zones (middle areas)
    else if ((row >= 8 && row <= 16 && col >= 8 && col <= 16) &&
             !(row >= 11 && row <= 13 && col >= 11 && col <= 13)) {
      tileColor = Colors.blue.withValues(alpha: 0.6);
    }
    // Resource zones (scattered)
    else if ((row + col) % 7 == 0) {
      tileColor = Colors.yellow.withValues(alpha: 0.6);
    }
    // Danger zones (random patches)
    else if ((row * col) % 13 == 0) {
      tileColor = Colors.red.withValues(alpha: 0.8);
    }
    // Wilderness
    else {
      tileColor = Colors.grey.withValues(alpha: 0.1);
    }
    
    return Container(
      decoration: BoxDecoration(
        color: tileColor,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Center(
        child: _getTileIcon(row, col),
      ),
    );
  }

  Widget? _getTileIcon(int row, int col) {
    // Village icons
    if ((row == 12 && col == 12) || // Center
        (row == 6 && col == 6) ||   // Top-left village
        (row == 6 && col == 18) ||  // Top-right village
        (row == 18 && col == 6) ||  // Bottom-left village
        (row == 18 && col == 18)) { // Bottom-right village
      return Icon(
        Icons.location_city,
        color: Colors.white.withValues(alpha: 0.7),
        size: 12,
      );
    }
    
    // Resource icons
    if ((row + col) % 7 == 0) {
      return Icon(
        Icons.forest,
        color: Colors.white.withValues(alpha: 0.7),
        size: 8,
      );
    }
    
    return null;
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: color.withValues(alpha: 0.7),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
