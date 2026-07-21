import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:memory_ticket_app/core/widgets/custom_app_bar.dart';
import 'package:memory_ticket_app/core/widgets/custom_button.dart';
import 'package:memory_ticket_app/core/widgets/custom_category_chips.dart';
import 'package:memory_ticket_app/features/memory/domain/entities/memory.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:memory_ticket_app/features/memory/presentation/bloc/memory_event.dart';
import 'package:memory_ticket_app/features/memory/presentation/widgets/memory_ticket_card.dart';
import 'package:memory_ticket_app/features/memory/presentation/widgets/upload_placeholder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:uuid/uuid.dart';

class NewMemoryTicketPage extends StatefulWidget {
  const NewMemoryTicketPage({super.key});

  @override
  State<NewMemoryTicketPage> createState() => _NewMemoryTicketPageState();
}

class _NewMemoryTicketPageState extends State<NewMemoryTicketPage> {
  final List<String> _styles = ['Movie', 'Flight', 'Concert', 'Festival'];
  int _selectedStyleIndex = 0;
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Travel';

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      if (!mounted) return;
      _openEditor(File(pickedFile.path));
    }
  }

  void _openEditor(File file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProImageEditor.file(
          file,
          callbacks: ProImageEditorCallbacks(
            onImageEditingComplete: (Uint8List bytes) async {
              final tempDir = await getTemporaryDirectory();
              final timestamp = DateTime.now().millisecondsSinceEpoch;
              final editedFile = File('${tempDir.path}/edited_$timestamp.jpg');
              await editedFile.writeAsBytes(bytes);

              setState(() {
                _imagePath = editedFile.path;
              });

              if (mounted) Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Select Image Source',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _saveMemory() {
    if (_titleController.text.isEmpty ||
        _imagePath == null ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final memory = Memory(
      id: const Uuid().v4(),
      title: _titleController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      date: _dateController.text.isEmpty
          ? DateFormat('MMM dd, yyyy').format(DateTime.now())
          : _dateController.text,
      imagePath: _imagePath!,
      category: _selectedCategory,
    );

    context.read<MemoryBloc>().add(AddMemory(memory));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "New Memory"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- UPLOAD BOX ---
              UploadPlaceholder(
                title: "Tap to upload a photo",
                subtitle: "PNG, JPG UP TO 10MB",
                icon: FontAwesomeIcons.camera,
                imagePath: _imagePath,
                onTap: _showImagePickerOptions,
              ),
              const SizedBox(height: 24),

              // --- FORM FIELDS BLOCK ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormLabel('MEMORY TITLE'),
                    _buildTextField(
                      'Summer at the Amalfi Coast',
                      controller: _titleController,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormLabel('DATE'),
                              _buildTextField(
                                'mm/dd/yyyy',
                                controller: _dateController,
                                suffixIcon: Icons.calendar_today_outlined,
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (date != null) {
                                    _dateController.text =
                                        DateFormat('MMM dd yyyy').format(date);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormLabel('LOCATION'),
                              _buildTextField(
                                'Positano, Italy',
                                controller: _locationController,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFormLabel('DESCRIPTION'),
                    _buildTextField(
                      'Describe the sights, sounds, and smells...',
                      controller: _descriptionController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormLabel('CATEGORY'),
                              _buildDropdownField(
                                _selectedCategory,
                                items: [
                                  'Travel',
                                  'Food',
                                  'Friends',
                                  'Nature',
                                  'Work',
                                  'Family',
                                  'Pets'
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedCategory = val);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // --- CHOOSE TICKET STYLE HIERARCHY ---
              Text(
                'CHOOSE TICKET STYLE',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),

              CustomCategoryChips(
                categories: _styles,
                selectedIndex: _selectedStyleIndex,
                onSelected: (index) {
                  setState(() => _selectedStyleIndex = index);
                },
              ),
              const SizedBox(height: 12),

              // --- LIVE PREVIEW HEADER ---
              if (_imagePath != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LIVE PREVIEW',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E7FD),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'DRAFT',
                        style: TextStyle(
                          color: Color(0xFF4E44E7),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // --- THE MEMORY TICKET CARD PREVIEW ---
                ListenableBuilder(
                  listenable: Listenable.merge([
                    _titleController,
                    _locationController,
                    _dateController,
                    _descriptionController,
                  ]),
                  builder: (context, _) {
                    return MemoryTicketCard(
                      imagePath: _imagePath!,
                      title: _titleController.text.isEmpty
                          ? 'New Memory'
                          : _titleController.text,
                      location: _locationController.text.isEmpty
                          ? 'Home Sanctuary'
                          : _locationController.text,
                      date: _dateController.text.isEmpty
                          ? DateFormat('MMM dd yyyy').format(DateTime.now())
                          : _dateController.text,
                      description: _descriptionController.text.isEmpty
                          ? 'A moment captured in time, waiting for its story to be told...'
                          : _descriptionController.text,
                      isFavorite: false,
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],

              // --- SAVE BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 54,
                child: CustomButton(
                  label: "Save Memory",
                  icon: Icons.save_outlined,
                  onPressed: _saveMemory,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    TextEditingController? controller,
    IconData? suffixIcon,
    int maxLines = 1,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onTap: onTap,
      readOnly: onTap != null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        fillColor: const Color(0xFFF4F6FA),
        filled: true,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, size: 18, color: Colors.black)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String value, {
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          items: items
              .map(
                (String val) => DropdownMenuItem(
                  value: val,
                  child: Text(val, style: const TextStyle(fontSize: 14)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
