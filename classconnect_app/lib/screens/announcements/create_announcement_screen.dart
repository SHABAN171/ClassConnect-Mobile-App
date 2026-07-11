import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../../services/announcement_service.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class CreateAnnouncementScreen extends StatefulWidget {
  const CreateAnnouncementScreen({
    super.key,
    required this.classId,
    required this.author,
  });

  final String classId;
  final AppUser author;

  @override
  State<CreateAnnouncementScreen> createState() =>
      _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _announcementService = AnnouncementService();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _announcementService.postAnnouncement(
        classId: widget.classId,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        authorId: widget.author.uid,
        authorName: widget.author.name,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not post announcement: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Announcement')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _titleController,
                  label: 'Title',
                  validator: (value) =>
                      value != null && value.trim().isNotEmpty
                      ? null
                      : 'Enter a title',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bodyController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) =>
                      value != null && value.trim().isNotEmpty
                      ? null
                      : 'Enter a message',
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Post Announcement',
                  isLoading: _isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
