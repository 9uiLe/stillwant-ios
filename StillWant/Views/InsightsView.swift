import CoreTransferable
import SwiftData
import SwiftUI

struct InsightsView: View {
    @Environment(\.locale) private var locale
    @Environment(EntitlementStore.self) private var entitlements
    @Query(sort: \PurchaseIntent.createdAt) private var intents: [PurchaseIntent]

    private var currencyCode: String {
        locale.currency?.identifier ?? "USD"
    }

    var body: some View {
        NavigationStack {
            if entitlements.hasPlus {
                PlusInsightsView(
                    intents: intents,
                    currencyCode: currencyCode
                )
            } else {
                LockedInsightsView()
            }
        }
    }
}

private struct LockedInsightsView: View {
    var body: some View {
        ContentUnavailableView {
            Label("StillWant Plus", systemImage: "chart.bar.xaxis")
        } description: {
            Text("Unlock ongoing insights and CSV export for your purchase decisions.")
        } actions: {
            NavigationLink("View StillWant Plus") {
                PaywallView()
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Insights")
    }
}

private struct PlusInsightsView: View {
    let intents: [PurchaseIntent]
    let currencyCode: String

    private var summary: SavingsSummary {
        SavingsSummary(intents: intents, currencyCode: currencyCode)
    }

    var body: some View {
        List {
            Section("Money retained") {
                Text(summary.retainedAmount, format: .currency(code: currencyCode))
                    .font(.largeTitle.bold())
                    .minimumScaleFactor(0.7)
            }

            Section("Decisions") {
                LabeledContent("Skipped") {
                    Text(summary.skippedCount, format: .number)
                }
                LabeledContent("Purchased") {
                    Text(summary.purchasedCount, format: .number)
                }
                LabeledContent("Pending") {
                    Text(summary.pendingCount, format: .number)
                }
            }

            Section("Your data") {
                ShareLink(
                    item: PurchaseCSV(intents: intents),
                    preview: SharePreview("StillWant decisions")
                ) {
                    Label("Export CSV", systemImage: "square.and.arrow.up")
                }
            }
        }
        .navigationTitle("Insights")
    }
}
