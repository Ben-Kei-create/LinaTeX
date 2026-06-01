import SwiftUI

@main
struct LinaTeXApp: App {
    @State private var showSplash = true
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false

    var body: some Scene {
        WindowGroup {
            if showSplash && !hasLaunchedBefore {
                SplashScreenView()
                    .onAppear {
                        hasLaunchedBefore = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showSplash = false
                            }
                        }
                    }
            } else {
                ContentView()
                    .onAppear { showSplash = false }
            }
        }
    }
}
