import UIKit
import Flutter
import flutter_downloader
import GoogleMaps // ✅ Tambahkan ini

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // ✅ Inisialisasi Google Maps API key
    GMSServices.provideAPIKey("AIzaSyCvBOGfNZ3-VY8ROPcXx2yr-FBiOBXHFR4")

    GeneratedPluginRegistrant.register(with: self)
    
    FlutterDownloaderPlugin.setPluginRegistrantCallback { registry in
        GeneratedPluginRegistrant.register(with: registry)
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
