import SwiftUI
import UIKit

// MARK: - Ad Banner View
//
// This is the bottom banner ad shown throughout the app.
// Currently shows a placeholder. Follow the steps below to wire up real Google AdMob ads.
//
// ── AdMob Setup Steps (do this in Xcode) ──────────────────────────────────────
// 1. Go to https://admob.google.com and register your app → get an App ID.
// 2. In Xcode → File → Add Package Dependencies…
//    URL: https://github.com/googleads/swift-package-manager-google-mobile-ads
//    Add "GoogleMobileAds" to the LinaTeX target.
// 3. In Info.plist add:
//      Key: GADApplicationIdentifier   Type: String   Value: <your-App-ID>
// 4. Create a Banner Ad Unit in AdMob console → copy the Ad Unit ID.
// 5. Replace the adUnitID constant below with your real Ad Unit ID.
// 6. Uncomment the #if block and delete AdBannerPlaceholder from the view.
// ────────────────────────────────────────────────────────────────────────────────

// Test Ad Unit ID (Google's official test ID — safe to use during development)
private let adUnitID = "ca-app-pub-3940256099942544/2934735716"

struct AdBannerView: View {
    var body: some View {
        // Replace AdBannerPlaceholder with RealAdBannerView() once AdMob SDK is installed.
        AdBannerPlaceholder()
    }
}

// MARK: - Placeholder (replace with RealAdBannerView once SDK is added)

private struct AdBannerPlaceholder: View {
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6)

            HStack(spacing: 0) {
                Text("広 告")
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(Color(UIColor.systemGray2))
                    .padding(.leading, 10)

                Spacer()

                // Placeholder ad content (replace with real ad)
                Text("AdMob 広告が表示されます")
                    .font(.system(size: 12))
                    .foregroundColor(Color(UIColor.systemGray3))

                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .overlay(
            Rectangle()
                .fill(Color(UIColor.systemGray4))
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
//         let banner = GADBannerView(adSize: GADAdSizeBanner) // 320x50
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
