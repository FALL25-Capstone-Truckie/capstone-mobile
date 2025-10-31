import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class OdometerUploadWidget extends StatefulWidget {
  final bool isUploading;
  final String? errorMessage;
  final Function(File imageFile, double reading) onUpload;
  final VoidCallback? onSuccess;

  const OdometerUploadWidget({
    Key? key,
    required this.isUploading,
    this.errorMessage,
    required this.onUpload,
    this.onSuccess,
  }) : super(key: key);

  @override
  State<OdometerUploadWidget> createState() => _OdometerUploadWidgetState();
}

class _OdometerUploadWidgetState extends State<OdometerUploadWidget> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _odometerController = TextEditingController();

  @override
  void dispose() {
    _odometerController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi chọn ảnh: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn nguồn ảnh'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Chụp ảnh'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Chọn từ thư viện'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleUpload() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ảnh đồng hồ'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_odometerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập số km'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final reading = double.tryParse(_odometerController.text);
    if (reading == null || reading <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Số km không hợp lệ'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    widget.onUpload(_selectedImage!, reading);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.speed, color: Colors.blue[700]),
                const SizedBox(width: 8),
                const Text(
                  'Đồng hồ công tơ mét cuối',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Vui lòng chụp ảnh đồng hồ công tơ mét và nhập số km để hoàn thành chuyến xe.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            // Odometer reading input
            TextField(
              controller: _odometerController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Số km hiện tại',
                hintText: 'Ví dụ: 12345.5',
                prefixIcon: const Icon(Icons.speed),
                suffixText: 'km',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabled: !widget.isUploading,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Image preview
            if (_selectedImage != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Error message
            if (widget.errorMessage != null && widget.errorMessage!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.isUploading ? null : _showImageSourceDialog,
                    icon: const Icon(Icons.add_a_photo),
                    label: Text(_selectedImage == null ? 'Chọn ảnh' : 'Đổi ảnh'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: widget.isUploading || _selectedImage == null
                        ? null
                        : _handleUpload,
                    icon: widget.isUploading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.upload),
                    label: Text(widget.isUploading ? 'Đang tải...' : 'Hoàn thành'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
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
