import StoreKit
import SwiftUI

struct PaywallView: View {
    var body: some View {
        SubscriptionStoreView(productIDs: [ProductIdentifiers.plusMonthly]) {
            VStack(spacing: 12) {
                Image(systemName: "hourglass.badge.plus")
                    .font(.largeTitle)
                    .accessibilityHidden(true)
                Text("StillWant Plus")
                    .font(.title.bold())
                Text("See ongoing decision insights and export your history whenever you need it.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .storeButton(.visible, for: .restorePurchases)
        .subscriptionStoreButtonLabel(.multiline)
        .subscriptionStorePolicyDestination(
            url: AppLinks.privacyPolicy,
            for: .privacyPolicy
        )
        .subscriptionStorePolicyDestination(
            url: AppLinks.termsOfUse,
            for: .termsOfService
        )
        .navigationTitle("StillWant Plus")
        .navigationBarTitleDisplayMode(.inline)
    }
}
