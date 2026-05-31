import SwiftUI
import UIKit
import GoogleMobileAds

private let adUnitID = "ca-app-pub-4859622277330192/4330175551"

struct AdBannerView: View {
    var body: some View {
        RealAdBannerView()
            .frame(maxWidth: .infinity)
            .frame(height: 50)
    }
}

// MARK: - Real AdMob Banner

private struct RealAdBannerView: UIViewRepresentable {
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: GADAdSizeBanner)
        banner.adUnitID = adUnitID
        banner.rootViewController = UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
        banner.load(GADRequest())
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {}
}
