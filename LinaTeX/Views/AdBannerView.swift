import SwiftUI
import UIKit

// MARK: - Ad Banner View
//
// Shows a Google AdMob banner at the bottom of main screens.
//
// ── AdMob Setup (do this in Xcode) ────────────────────────────────────────────
// 1. admob.google.com → register app → get App ID
// 2. Xcode → File → Add Package Dependencies
//    URL: https://github.com/googleads/swift-package-manager-google-mobile-ads
//    Target: LinaTeX
// 3. Info.plist → GADApplicationIdentifier = <your-App-ID>
// 4. AdMob console → create Banner Ad Unit → copy Ad Unit ID
// 5. Replace adUnitID below with your real Ad Unit ID
// 6. Swap AdBannerPlaceholder() for RealAdBannerView() in the body below
// ──────────────────────────────────────────────────────────────────────────────

private let adUnitID = "ca-app-pub-3940256099942544/2934735716" // test ID

struct AdBannerView: View {
    var body: some View {
        AdBannerPlaceholder()
        // Replace with RealAdBannerView() after completing AdMob setup above
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

// MARK: - Real AdMob Banner (uncomment after adding SDK)
//
// import GoogleMobileAds
//
// struct RealAdBannerView: UIViewRepresentable {
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
