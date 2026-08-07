import SwiftData
import SwiftUI

@main
@MainActor
struct StillWantApp: App {
    @State private var entitlements = EntitlementStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(entitlements)
                .task {
                    await entitlements.start()
                }
        }
        .modelContainer(for: PurchaseIntent.self)
    }
}
