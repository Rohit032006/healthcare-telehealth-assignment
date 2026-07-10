import 'package:flutter/material.dart';

  extension Sized on num {
    SizedBox get height => SizedBox(
          height: toDouble(),
        );
    SizedBox get width => SizedBox(
          width: toDouble(),
        );
  }

extension SizedBoxExtension on int {
  SizedBox toHeight() {
    switch (this) {
      case 2:
        return const SizedBox(height: 2);
      case 4:
        return const SizedBox(height: 4);
      case 6:
        return const SizedBox(height: 6);
      case 8:
        return const SizedBox(height: 8);
      case 10:
        return const SizedBox(height: 10);
      case 12:
        return const SizedBox(height: 12);
      case 14:
        return const SizedBox(height: 14);
      case 16:
        return const SizedBox(height: 16);
      case 18:
        return const SizedBox(height: 18);
      case 20:
        return const SizedBox(height: 20);
      case 22:
        return const SizedBox(height: 22);
      case 24:
        return const SizedBox(height: 24);
      case 26:
        return const SizedBox(height: 26);
      case 28:
        return const SizedBox(height: 28);
      case 30:
        return const SizedBox(height: 30);
      case 32:
        return const SizedBox(height: 32);
      default:
        return const SizedBox(height: 0);
    }
  }
}

extension StringCasingExtension on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  String capitalizeEachWord() {
    return split(" ")
        .map((word) => word.capitalizeFirst())
        .join(" ");
  }

  /// Removes HTML tags from the string and returns plain text
  String removeHtmlTags() {
    String result = this;
    
    result = result.replaceAll(RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false, multiLine: true, dotAll: true), '');
    result = result.replaceAll(RegExp(r'<style[^>]*>.*?</style>', caseSensitive: false, multiLine: true, dotAll: true), '');
    
    result = result.replaceAll(RegExp(r'<[^>]*>', caseSensitive: false, multiLine: true), '');
    
    result = result
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
    
    result = result.replaceAllMapped(
      RegExp(r'&#(\d+);'),
      (match) => String.fromCharCode(int.parse(match.group(1)!)),
    );
    
    result = result.replaceAllMapped(
      RegExp(r'&#x([0-9a-fA-F]+);'),
      (match) => String.fromCharCode(int.parse(match.group(1)!, radix: 16)),
    );
    
    result = result.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    return result;
  }

  // Get file extension
  String getFileExtension() {
    if (contains('.')) {
      return split('.').last;
    }
    return '';
  }

  // Get file icon based on extension
  IconData getFileIcon() {
    String extension = getFileExtension().toLowerCase();
    
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return Icons.image;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'txt':
        return Icons.text_snippet;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.folder_zip;
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'mkv':
        return Icons.video_file;
      case 'mp3':
      case 'wav':
      case 'flac':
        return Icons.audio_file;
      default:
        return Icons.insert_drive_file;
    }
  }

  // Check if file is an image
  bool isImageFile() {
    String extension = getFileExtension().toLowerCase();
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageExtensions.contains(extension);
  }

  // Get file type category
  String getFileCategory() {
    String extension = getFileExtension().toLowerCase();
    
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return 'Image';
      case 'pdf':
        return 'PDF';
      case 'doc':
      case 'docx':
        return 'Document';
      case 'xls':
      case 'xlsx':
        return 'Spreadsheet';
      case 'ppt':
      case 'pptx':
        return 'Presentation';
      case 'txt':
        return 'Text';
      case 'zip':
      case 'rar':
      case '7z':
        return 'Archive';
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'mkv':
        return 'Video';
      case 'mp3':
      case 'wav':
      case 'flac':
        return 'Audio';
      default:
        return 'File';
    }
  }

  // Get color for file type
  Color getFileColor() {
    String extension = getFileExtension().toLowerCase();
    
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return Colors.blue;
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.indigo;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'txt':
        return Colors.grey;
      case 'zip':
      case 'rar':
      case '7z':
        return Colors.purple;
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'mkv':
        return Colors.teal;
      case 'mp3':
      case 'wav':
      case 'flac':
        return Colors.pink;
      default:
        return Colors.blueGrey;
    }
  }
}



extension FileContentTypeExtension on String {
  String getContentType() {
    final extension = split('.').last.toLowerCase();
    final typeMap = {
      // Images
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'bmp': 'image/bmp',
      'webp': 'image/webp',
      'svg': 'image/svg+xml',

      // Documents
      'pdf': 'application/pdf',
      'doc': 'application/msword',
      'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'xls': 'application/vnd.ms-excel',
      'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'ppt': 'application/vnd.ms-powerpoint',
      'pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      'txt': 'text/plain',
      'rtf': 'application/rtf',

      // Videos
      'mp4': 'video/mp4',
      'mov': 'video/quicktime',
      'avi': 'video/x-msvideo',
      'wmv': 'video/x-ms-wmv',
      'flv': 'video/x-flv',
      'webm': 'video/webm',

      // Audio
      'mp3': 'audio/mpeg',
      'wav': 'audio/wav',
      'ogg': 'audio/ogg',
      'aac': 'audio/aac',

      // Archives
      'zip': 'application/zip',
      'rar': 'application/x-rar-compressed',
      '7z': 'application/x-7z-compressed',
    };

    return typeMap[extension] ?? 'application/octet-stream';
  }
}

