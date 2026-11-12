import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/design_preferences_provider.dart';
import '../../deposit/screens/confirm_deposit_screen.dart';
import '../../../screens/customer_dashboard_screen.dart';
import '../../../screens/my_slot_screen.dart';

class MyDesignScreen extends StatefulWidget {
  const MyDesignScreen({super.key});

  @override
  State<MyDesignScreen> createState() => _MyDesignScreenState();
}

class _MyDesignScreenState extends State<MyDesignScreen> {
  static const Color burgundy = Color(0xFF590019);
  static const Color cream = Color(0xFFF7F2E0);
  static const Color brown = Color(0xFF58372B);

  final _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final provider =
          context.read<DesignPreferencesProvider>();

      _imageController.text =
          provider.referenceImageUrl;
    });
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  void _goToConfirmScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const ConfirmDepositScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<DesignPreferencesProvider>();

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(automaticallyImplyLeading: false,
        backgroundColor: burgundy,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'My Design',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Reference photo (Optional)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: brown,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 40,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '+ Add photo',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Colour',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: brown,
              ),
            ),
            const SizedBox(height: 12),

              Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  provider.colours.map(
                (colour) {
                  return ChoiceChip(
                    label: Text(colour),
                    selected:
                        provider.selectedColour ==
                            colour,
                    selectedColor:
                        const Color(
                      0xFF80AEE8,
                    ),
                    backgroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    side: const BorderSide(
                      color: Color(0xFFB6BDCC)
                    ),
                    onSelected: (_) =>
                        provider
                            .selectColour(
                      colour,
                    ),
                  );
                },
              ).toList(),
            ),

            const SizedBox(height: 24),

            const Text(
              'Style',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: brown,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  provider.styles.map(
                (style) {
                  return ChoiceChip(
                    label: Text(style),
                    selected:
                        provider.selectedStyle ==
                            style,
                    selectedColor:
                        const Color(
                      0xFF80AEE8,
                    ),
                    backgroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    side: const BorderSide(
                      color: Color(0xFFB6BDCC)
                    ),
                    onSelected: (_) =>
                        provider.selectStyle(
                      style,
                    ),
                  );
                },
              ).toList(),
            ),

            const SizedBox(height: 24),

            const Text(
              'Shape',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: brown,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  provider.shapes.map(
                (shape) {
                  return ChoiceChip(
                    label: Text(shape),
                    selected:
                        provider.selectedShape ==
                            shape,
                    selectedColor:
                        const Color(
                      0xFF80AEE8,
                    ),
                    backgroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    side: const BorderSide(
                      color: Color(0xFFB6BDCC)
                    ),
                    onSelected: (_) =>
                        provider.selectShape(
                      shape,
                    ),
                  );
                },
              ).toList(),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'AI design suggestions will be implemented in a future milestone.',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.auto_awesome,
                  color: burgundy,
                ),
                label: const Text(
                  'Suggest Design (AI)',
                  style: TextStyle(
                    color: burgundy,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: burgundy,
                  minimumSize: const Size.fromHeight(50),
                  shape: const StadiumBorder(),
                  side: const BorderSide(
                    color: burgundy,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildSuggestionCard(
                    'Idea name',
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildSuggestionCard(
                    'Idea name',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      burgundy,
                  foregroundColor:
                      Colors.white,
                  shape:
                      const StadiumBorder(),
                ),
                onPressed:
                    _goToConfirmScreen,
                child: const Text(
                  'Next: Confirm',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFDCE8F8),
        selectedIndex: 0,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const CustomerDashboardScreen(),
                ),
                (_) => false,
              );
              break;

            case 1:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const MySlotScreen(),
                ),
                (_) => false,
              );
              break;

            case 2:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const NailMuseAiPlaceholder(),
                ),
                (_) => false,
              );
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Book Now',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'My Slot',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'Nail Muse AI',
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(
    String title,
  ) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            height: 70,
            margin:
                const EdgeInsets.all(10),
            color:
                const Color(0xFF80AEE8),
          ),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

}