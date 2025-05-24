import 'package:flutter/material.dart';
import 'package:project_application/models/category.dart';
import 'package:project_application/utils/constants.dart';
import 'package:project_application/utils/localization.dart';

class CategorySelector extends StatelessWidget {
  final List<Category> categories;
  final int? selectedCategoryId;
  final Function(int?) onCategorySelected;
  
  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Column(
      children: [
        // "Any category" option
        _buildCategoryTile(
          context,
          id: null,
          name: localizations.get('any'),
          icon: Icons.category,
        ),
        
        // Divider
        const Divider(),
        
        // List of categories
        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final iconData = AppConstants.categoryIcons[category.id] ?? Icons.help;
              
              return _buildCategoryTile(
                context,
                id: category.id,
                name: category.name,
                icon: iconData,
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildCategoryTile(
    BuildContext context, {
    required int? id,
    required String name,
    required IconData icon,
  }) {
    final isSelected = id == selectedCategoryId;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check_circle) : null,
      onTap: () => onCategorySelected(id),
      selected: isSelected,
    );
  }
}
