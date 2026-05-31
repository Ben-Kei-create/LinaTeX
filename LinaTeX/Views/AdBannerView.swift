import SwiftUI
import UIKit

// MARK: - Ad Banner View
//
// ── AdMob SDK を Xcode で追加する ─────────────────────────────────────────────
// File → Add Package Dependencies
// URL: https://github.com/googleads/swift-package-manager-google-mobile-ads
// Target: LinaTeX
//
// 追加後、下の AdBannerPlaceholder() を RealAdBannerView() に差し替える
// ──────────────────────────────────────────────────────────────────────────────

private let adUnitID = "ca-app-pub-4859622277330192/4330175551"

struct AdBannerView: View {
    var body: some View {
        AdBannerPlaceholder()
        // SDK追加後: AdBannerPlaceholder() → RealAdBannerView() に変更
    }
}

// MARK: - Placeholder

private struct AdBannerPlaceholder: View {
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6)

            HStack {
                Text("広告")
                    .font(.system(size: 10))
                    .foregroundColor(Color(UIColor.systemGray3))
                    .padding(.leading, 10)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .overlay(
            Rectangle()
                .fill(Color(UIColor.systemGray4).opacity(0.5))
                .frame(height: 0.5),
            alignment: .top
        )
    }
}

// MARK: - Real AdMob Banner

// SDK追加後にコメントを外す:
//
// import GoogleMobileAds
//
// private struct RealAdBannerView: UIViewRepresentable {
//     func makeUIView(context: Context) -> GADBannerView {
//         let banner = GADBannerView(adSize: GADAdSizeBanner)
//         banner.adUnitID = adUnitID
//         banner.rootViewController = UIApplication.shared
//             .connectedScenes
//             .compactMap { $0 as? UIWindowScene }
//             .flatMap { $0.windows }
//             .first { $0.isKeyWindow }?
//             .rootViewController
//         banner.load(GADRequest())
//         return banner
//     }
//     func updateUIView(_ uiView: GADBannerView, context: Context) {}
// }
