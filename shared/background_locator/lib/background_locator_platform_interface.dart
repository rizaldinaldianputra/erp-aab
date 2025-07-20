import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'background_locator_method_channel.dart';

abstract class BackgroundLocatorPlatform extends PlatformInterface {
  /// Constructs a BackgroundLocatorPlatform.
  BackgroundLocatorPlatform() : super(token: _token);

  static final Object _token = Object();

  static BackgroundLocatorPlatform _instance = MethodChannelBackgroundLocator();

  /// The default instance of [BackgroundLocatorPlatform] to use.
  ///
  /// Defaults to [MethodChannelBackgroundLocator].
  static BackgroundLocatorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BackgroundLocatorPlatform] when
  /// they register themselves.
  static set instance(BackgroundLocatorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
