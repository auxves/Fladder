import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fladder/jellyfin/jellyfin_open_api.swagger.dart' as dto;
import 'package:fladder/jellyfin/jellyfin_open_api.swagger.dart';
import 'package:fladder/models/items/media_streams_model.dart';
import 'package:fladder/screens/shared/flat_button.dart';

enum Resolution {
  sd("SD"),
  hd("HD"),
  fhd("FHD"),
  uhd("4K");

  const Resolution(this.value);
  final String value;

  Widget icon(
    BuildContext context,
    Function()? onTap,
  ) {
    return DefaultVideoInformationBox(
      onTap: onTap,
      child: Text(
        value,
      ),
    );
  }

  static Resolution? fromVideoStream(VideoStreamModel? model) {
    if (model == null) return null;
    return Resolution.fromSize(model.width, model.height);
  }

  static Resolution? fromSize(int? width, int? height) {
    if (width == null || height == null) return null;
    if (width < 1280 && height < 720) {
      return Resolution.sd;
    } else if (width < 1920 && height < 1080) {
      return Resolution.hd;
    } else if (width < 3840 && height < 2160) {
      return Resolution.fhd;
    } else {
      return Resolution.uhd;
    }
  }
}

enum DisplayProfile {
  sdr("SDR"),
  hdr("HDR");

  const DisplayProfile(this.value);
  final String value;

  Widget icon(
    BuildContext context,
    Function()? onTap,
  ) {
    return DefaultVideoInformationBox(
      onTap: onTap,
      child: Text(
        value,
      ),
    );
  }

  static DisplayProfile? fromStreams(List<MediaStream>? mediaStreams) {
    final videoStream = (mediaStreams?.firstWhereOrNull((element) => element.type == dto.MediaStreamType.video) ??
        mediaStreams?.firstOrNull);
    if (videoStream == null) return null;
    return DisplayProfile.fromVideoStream(VideoStreamModel.fromMediaStream(videoStream));
  }

  static DisplayProfile? fromVideoStreams(List<VideoStreamModel>? mediaStreams) {
    final videoStream = mediaStreams?.firstWhereOrNull((element) => element.isDefault) ?? mediaStreams?.firstOrNull;
    if (videoStream == null) return null;
    return DisplayProfile.fromVideoStream(videoStream);
  }

  static DisplayProfile fromVideoStream(VideoStreamModel stream) {
    return switch (stream.videoRangeType) {
      dto.VideoRangeType.doviwithsdr => DisplayProfile.hdr,
      dto.VideoRangeType.doviwithhdr10 => DisplayProfile.hdr,
      dto.VideoRangeType.dovi => DisplayProfile.hdr,
      dto.VideoRangeType.hlg => DisplayProfile.hdr,
      dto.VideoRangeType.hdr10 => DisplayProfile.hdr,
      dto.VideoRangeType.doviwithhlg => DisplayProfile.hdr,
      dto.VideoRangeType.hdr10plus => DisplayProfile.hdr,
      _ => DisplayProfile.sdr
    };
  }
}

class DefaultVideoInformationBox extends ConsumerWidget {
  final Widget child;
  final Function()? onTap;
  const DefaultVideoInformationBox({required this.child, this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: FlatButton(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Material(
            type: MaterialType.button,
            textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            color: Colors.transparent,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
