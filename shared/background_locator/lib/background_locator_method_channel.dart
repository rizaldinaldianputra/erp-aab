import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'background_locator_platform_interface.dart';

/// An implementation of [BackgroundLocatorPlatform] that uses method channels.
class MethodChannelBackgroundLocator extends BackgroundLocatorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('background_locator');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
