import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            Tab("Decide", systemImage: "hourglass") {
                IntentListView()
            }

            Tab("Insights", systemImage: "chart.bar.xaxis") {
                InsightsView()
            }

            Tab("Settings", systemImage: "gearshape") {
                SettingsView()
            }
        }
    }
}

#Preview {
    RootView()
        .environment(EntitlementStore())
        .modelContainer(for: PurchaseIntent.self, inMemory: true)
}
