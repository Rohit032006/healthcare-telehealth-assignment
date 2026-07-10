import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/themes/app_text_style.dart';
import '../controller/video_call_controller.dart';

class VideoCallScreen extends StatefulWidget {
  final String appointmentId;

  const VideoCallScreen({super.key, required this.appointmentId});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late final VideoCallController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<VideoCallController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initCall(widget.appointmentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          if (controller.permissionDenied.value) {
            return _PermissionDeniedView(onEndCall: () => controller.endCall(context));
          }

          return Stack(
            children: [
              Positioned.fill(
                child: RTCVideoView(
                  controller.remoteRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
              if (controller.isConnecting.value)
                Positioned.fill(
                  child: Container(
                    color: Colors.black87,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(color: Colors.white),
                          const SizedBox(height: 16),
                          Text(
                            controller.callStatusText.value,
                            style: AppTextStyle.mediumNormalText.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 16,
                right: 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 110,
                    height: 150,
                    child: RTCVideoView(
                      controller.localRenderer,
                      mirror: true,
                      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _CallControlButton(
                      icon: controller.isMicOn.value ? Icons.mic : Icons.mic_off,
                      onTap: controller.toggleMic,
                    ),
                    const SizedBox(width: 20),
                    _CallControlButton(
                      backgroundColor: AppColors.redColor,
                      icon: Icons.call_end,
                      onTap: () => controller.endCall(context),
                    ),
                    const SizedBox(width: 20),
                    _CallControlButton(
                      icon: controller.isCameraOn.value ? Icons.videocam : Icons.videocam_off,
                      onTap: controller.toggleCamera,
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _PermissionDeniedView extends StatelessWidget {
  final VoidCallback onEndCall;

  const _PermissionDeniedView({required this.onEndCall});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.videocam_off, color: Colors.white, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Camera and microphone permissions are required to start a video call.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: onEndCall,
              child: const Text('Go Back', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _CallControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;

  const _CallControlButton({required this.icon, required this.onTap, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? Colors.white.withValues(alpha: 0.2),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
