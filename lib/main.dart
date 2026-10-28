import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Mobile App Dev - Lab 02',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const Lab02Screen(),
    );
  }
}

class Lab02Screen extends StatefulWidget {
  const Lab02Screen({super.key});

  @override
  State<Lab02Screen> createState() => _Lab02ScreenState();
}

class _Lab02ScreenState extends State<Lab02Screen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedRole = 'Slytherin';
  final List<String> roles = ['Gryffindor', 'Slytherin', 'Ravenclaw', 'Hufflepuff'];

  // Material Date Picker
  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Cupertino Date Picker (Modal Sheet)
  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 240,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() => _selectedDate = newDate);
                },
              ),
            ),
            CupertinoButton(
              child: const Text('Done'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
  }

  // Cupertino Picker (Wheel)
  void _showCupertinoRolePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 240,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: CupertinoPicker(
                itemExtent: 32,
                scrollController: FixedExtentScrollController(
                    initialItem: roles.indexOf(_selectedRole)),
                onSelectedItemChanged: (int index) {
                  setState(() => _selectedRole = roles[index]);
                },
                children: roles.map((role) => Center(child: Text(role))).toList(),
              ),
            ),
            CupertinoButton(
              child: const Text('Done'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02', style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.indigo[100],
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView()
              : _buildLandscapeView();
        },
      ),
    );
  }

  Widget _buildPortraitView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStudentProfile(),
        const SizedBox(height: 16),
        _buildPickersSection(),
      ],
    );
  }

  Widget _buildLandscapeView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildStudentProfile(),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildPickersSection(),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentProfile() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/image.png'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Wong Hin Ching',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 4),
            Text(
              'Student ID: BCS24090007',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const Divider(height: 32, thickness: 1),
            const TitleSection(
              name: 'Hogwarts School of Witchcraft\nand Wizardry',
              location: 'Hogsmeade, Scotland',
              starCount: 41,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickersSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Interactive Pickers (Lab 2.2)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            Text('Selected Date: ${_selectedDate.toString().split(' ')[0]}'),
            Text('Selected House: $_selectedRole'),
            const Divider(height: 32),
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: const Text('Material Date Picker'),
              onPressed: () => _selectMaterialDate(context),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(CupertinoIcons.calendar),
              label: const Text('Cupertino Date Picker (Sheet)'),
              onPressed: () => _showCupertinoDatePicker(context),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('Material Dropdown: '),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedRole,
                  items: roles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => _selectedRole = newValue);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(CupertinoIcons.person_3),
              label: const Text('Cupertino House Wheel Picker'),
              onPressed: () => _showCupertinoRolePicker(context),
            ),
          ],
        ),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.red[500]),
          const SizedBox(width: 4),
          Text('$starCount'),
        ],
      ),
    );
  }
}