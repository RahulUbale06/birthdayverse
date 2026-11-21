
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';

import '../../models/birthday_config.dart';

class CreatorScreen extends StatefulWidget {
  const CreatorScreen({super.key});

  @override
  State<CreatorScreen> createState() => _CreatorScreenState();
}

class _CreatorScreenState extends State<CreatorScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _relationshipController = TextEditingController();
  final _messageController = TextEditingController();
  final _letterController = TextEditingController();

  // Media services
  final ImagePicker _imagePicker = ImagePicker();
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Wizard
  int currentStep = 0;

  // Birthday details
  DateTime? birthdayDate;

  // Theme
  String selectedTheme = 'pink_dream';

  // Photos
  final List<XFile> selectedImages = [];
  final List<Uint8List> selectedImageBytes = [];

  // Music
  String? selectedMusicPath;
  String? selectedMusicName;
  Uint8List? selectedMusicBytes;

  bool isPlaying = false;

  final List<Map<String, dynamic>> themes = [
    {
      'id': 'pink_dream',
      'name': 'Pink Dream',
      'color': const Color(0xFFF7B6CE),
    },
    {
      'id': 'lavender_sky',
      'name': 'Lavender Sky',
      'color': const Color(0xFFC5B5F7),
    },
    {
      'id': 'golden_glow',
      'name': 'Golden Glow',
      'color': const Color(0xFFFFD58C),
    },
  ];

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;

      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _relationshipController.dispose();
    _messageController.dispose();
    _letterController.dispose();

    _audioPlayer.dispose();

    super.dispose();
  }

  // ==========================================
  // COMMON MESSAGE
  // ==========================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // ==========================================
  // BIRTHDAY DATE
  // ==========================================

  Future<void> _selectBirthday() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: birthdayDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selected != null && mounted) {
      setState(() {
        birthdayDate = selected;
      });
    }
  }

  // ==========================================
  // PHOTO PICKER
  // ==========================================

  Future<void> _pickImages() async {
    try {
      final images = await _imagePicker.pickMultiImage(
        imageQuality: 85,
      );

      if (images.isEmpty || !mounted) return;

      final newBytes = <Uint8List>[];

      for (final image in images) {
        final bytes = await image.readAsBytes();
        newBytes.add(bytes);
      }

      if (!mounted) return;

      setState(() {
        selectedImages.addAll(images);
        selectedImageBytes.addAll(newBytes);
      });

      _showMessage('${images.length} photo(s) added successfully!');
    } catch (e) {
      _showMessage('Photo selection failed: $e');
    }
  }

  // ==========================================
  // REMOVE PHOTO
  // ==========================================

  void _removeImage(int index) {
    if (index < 0 || index >= selectedImages.length) return;

    setState(() {
      selectedImages.removeAt(index);
      selectedImageBytes.removeAt(index);
    });

    _showMessage('Photo removed successfully');
  }

  // ==========================================
  // MUSIC PICKER
  // ==========================================

  Future<void> _pickMusic() async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.audio,
      );

      if (file == null) return;

      final bytes = await file.readAsBytes();

      if (bytes.isEmpty) {
        _showMessage('The selected audio file is empty.');
        return;
      }

      await _audioPlayer.stop();

      if (!mounted) return;

      setState(() {
        selectedMusicName = file.name;
        selectedMusicPath = file.path;
        selectedMusicBytes = bytes;
        isPlaying = false;
      });

      _showMessage('Music added successfully!');
    } catch (e) {
      _showMessage('Music selection failed: $e');
    }
  }

  // ==========================================
  // MUSIC PLAY / PAUSE
  // ==========================================

  Future<void> _toggleMusic() async {
    if (selectedMusicBytes == null) {
      _showMessage('Please select music first.');
      return;
    }

    try {
      if (isPlaying) {
        await _audioPlayer.pause();

        if (!mounted) return;

        setState(() {
          isPlaying = false;
        });
      } else {
        await _audioPlayer.play(
          BytesSource(selectedMusicBytes!),
        );

        if (!mounted) return;

        setState(() {
          isPlaying = true;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isPlaying = false;
      });

      _showMessage('Music playback failed: $e');
    }
  }

  // ==========================================
  // WIZARD NAVIGATION
  // ==========================================

  void _continueStep() {
    if (!_formKey.currentState!.validate()) return;

    if (currentStep == 0 && birthdayDate == null) {
      _showMessage('Please select the birthday date.');
      return;
    }

    if (currentStep < 3) {
      setState(() {
        currentStep++;
      });
    } else {
      _createBirthday();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  // ==========================================
  // CREATE BIRTHDAY
  // ==========================================

  void _createBirthday() {
    final birthday = BirthdayConfig(
      id: const Uuid().v4(),
      recipientName: _nameController.text.trim(),
      nickname: _nicknameController.text.trim(),
      relationship: _relationshipController.text.trim(),
      birthdayDate: birthdayDate!,
      birthdayMessage: _messageController.text.trim(),
      themeId: selectedTheme,
      birthdayLetter: _letterController.text.trim(),

      // Local paths retained for the current model.
      photos: selectedImages.map((image) => image.path).toList(),
      photoBytes: List<Uint8List>.from(selectedImageBytes),
      musicPath: selectedMusicPath,
      musicName: selectedMusicName,
      musicBytes: selectedMusicBytes,
    );
      context.push('/preview', extra: birthday);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Birthday Created! 🎂'),
          content: Text(
            'Birthday configuration for '
            '${birthday.recipientName} has been created.\n\n'
            'Photos: ${birthday.photos.length}\n'
            'Music: ${birthday.musicName ?? "Not selected"}\n'
            'Theme: ${birthday.themeId}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // REUSABLE TEXT FIELD
  // ==========================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFFFF7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }

        return null;
      },
    );
  }

  // ==========================================
  // STEP 1: RECIPIENT DETAILS
  // ==========================================

  Widget _buildRecipientStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: _nameController,
          label: 'Recipient Name',
          hint: 'Enter their full name',
        ),

        const SizedBox(height: 17),

        TextFormField(
          controller: _nicknameController,
          decoration: InputDecoration(
            labelText: 'Nickname (Optional)',
            hintText: 'What do you call them?',
            filled: true,
            fillColor: const Color(0xFFFFF7FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 17),

        TextFormField(
          controller: _relationshipController,
          decoration: InputDecoration(
            labelText: 'Relationship',
            hintText: 'e.g. Best Friend, Sister, Brother',
            filled: true,
            fillColor: const Color(0xFFFFF7FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Birthday Date',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 10),

        InkWell(
          onTap: _selectBirthday,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7FA),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  color: Color(0xFFEC82AA),
                ),
                const SizedBox(width: 12),
                Text(
                  birthdayDate == null
                      ? 'Select birthday date'
                      : '${birthdayDate!.day}/'
                          '${birthdayDate!.month}/'
                          '${birthdayDate!.year}',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // STEP 2: BIRTHDAY MESSAGE
  // ==========================================

  Widget _buildMessageStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Make their day special!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Write a beautiful birthday greeting '
          'that they will remember.',
          style: TextStyle(color: Colors.grey),
        ),

        const SizedBox(height: 22),

        _buildTextField(
          controller: _messageController,
          label: 'Birthday Message',
          hint: 'Happy Birthday! Wishing you...',
          maxLines: 5,
        ),
      ],
    );
  }

  // ==========================================
  // STEP 3: PERSONAL LETTER AND THEME
  // ==========================================

  Widget _buildLetterStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add a personal touch ❤️',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Write something meaningful for them.',
          style: TextStyle(color: Colors.grey),
        ),

        const SizedBox(height: 20),

        _buildTextField(
          controller: _letterController,
          label: 'Personal Letter',
          hint: 'Dear friend, I want to tell you...',
          maxLines: 6,
        ),

        const SizedBox(height: 22),

        const Text(
          'Choose Birthday Theme',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        RadioGroup<String>(
          groupValue: selectedTheme,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedTheme = value;
              });
            }
          },
          child: Column(
            children: themes.map((theme) {
              final isSelected =
                  selectedTheme == theme['id'];

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: theme['color'] as Color,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF292536)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: RadioListTile<String>(
                  value: theme['id'] as String,
                  title: Text(
                    theme['name'] as String,
                    style: const TextStyle(
                      color: Color(0xFF292536),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  activeColor: const Color(0xFF292536),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // PHOTO GALLERY
  // ==========================================

  Widget _buildPhotoGallery() {
    if (selectedImageBytes.isEmpty) {
      return Container(
        height: 130,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 35,
              color: Color(0xFFEC82AA),
            ),
            SizedBox(height: 8),
            Text('No photos selected yet'),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedImageBytes.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                selectedImageBytes[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const ColoredBox(
                    color: Color(0xFFFFE0EB),
                    child: Icon(Icons.broken_image),
                  );
                },
              ),
            ),

            // Remove button
            Positioned(
              right: 5,
              top: 5,
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 3,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => _removeImage(index),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 17,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // STEP 4: MEMORIES AND MUSIC
  // ==========================================

  Widget _buildMediaStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Capture beautiful memories 📸',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Choose photos that make this birthday special.',
          style: TextStyle(color: Colors.grey),
        ),

        const SizedBox(height: 18),

        OutlinedButton.icon(
          onPressed: _pickImages,
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('Select Photos'),
        ),

        const SizedBox(height: 15),

        _buildPhotoGallery(),

        const SizedBox(height: 30),

        const Text(
          'Choose Background Music 🎵',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.music_note_rounded,
                    color: Color(0xFFEC82AA),
                    size: 30,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      selectedMusicName ?? 'No music selected',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickMusic,
                      icon: const Icon(Icons.folder_open),
                      label: const Text('Choose Music'),
                    ),
                  ),

                  if (selectedMusicBytes != null) ...[
                    const SizedBox(width: 8),

                    IconButton.filled(
                      onPressed: _toggleMusic,
                      icon: Icon(
                        isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'Photos and music are optional. '
          'You can continue without them.',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // MAIN BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    final stepTitles = [
      'Recipient Details',
      'Birthday Message',
      'Personal Touch',
      'Memories & Music',
    ];

    final stepDescriptions = [
      'Tell us who this birthday surprise is for.',
      'Create a memorable birthday greeting.',
      'Add your personal letter and theme.',
      'Choose photos and background music.',
    ];

    final stepContents = [
      _buildRecipientStep(),
      _buildMessageStep(),
      _buildLetterStep(),
      _buildMediaStep(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Birthday'),
        backgroundColor: const Color(0xFFFFF9FC),
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20, 18, 20, 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step ${currentStep + 1} of 4',
                      style: const TextStyle(
                        color: Color(0xFFEC82AA),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (currentStep + 1) / 4,
                        minHeight: 7,
                        backgroundColor:
                            const Color(0xFFF2EAF0),
                        color: const Color(0xFFEC82AA),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stepTitles[currentStep],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF292536),
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        stepDescriptions[currentStep],
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 27),

                      stepContents[currentStep],
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    if (currentStep > 0) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _previousStep,
                          child: const Text('Back'),
                        ),
                      ),

                      const SizedBox(width: 12),
                    ],

                    Expanded(
                      child: ElevatedButton(
                        onPressed: _continueStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFEC82AA),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          currentStep == 3
                              ? 'Create Birthday'
                              : 'Continue',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
