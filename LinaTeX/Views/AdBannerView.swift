import SwiftUI
import UIKit
import GoogleMobileAds

private let adUnitID = "ca-app-pub-4859622277330192/4330175551"

struct AdBannerView: View {
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color(hex: 0xE2E8F0))

            RealAdBannerView()
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color(hex: 0xF8FAFC).opacity(0.8))
        }
    }
}

// MARK: - Real AdMob Banner

private struct RealAdBannerView: UIViewRepresentable {
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = adUnitID
        banner.rootViewController = UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
        banner.load(Request())
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {}
}
