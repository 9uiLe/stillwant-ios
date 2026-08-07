import SwiftUI

struct SettingsView: View {
    @Environment(EntitlementStore.self) private var entitlements

    private var subscriptionStatus: LocalizedStringResource {
        entitlements.hasPlus ? "Active" : "Free"
    }

    var body: some View {
        NavigationStack {
            List {
                Section("StillWant Plus") {
                    LabeledContent("Status") {
                        Label(
                            subscriptionStatus,
                            systemImage: entitlements.hasPlus
                                ? "checkmark.seal.fill"
                                : "person.crop.circle"
                        )
                    }

                    NavigationLink("Manage or subscribe") {
                        PaywallView()
                    }
                }

                Section("About") {
                    Link("Privacy Policy", destination: AppLinks.privacyPolicy)
                    Link("Terms of Use", destination: AppLinks.termsOfUse)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
