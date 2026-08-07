import SwiftData
import SwiftUI

private enum IntentRoute: Hashable {
    case detail(UUID)
}

private enum IntentSheet: String, Identifiable {
    case add

    var id: String {
        rawValue
    }
}

struct IntentListView: View {
    @Environment(\.locale) private var locale
    @Query(sort: \PurchaseIntent.revisitDate) private var intents: [PurchaseIntent]
    @State private var presentedSheet: IntentSheet?

    private var currencyCode: String {
        locale.currency?.identifier ?? "USD"
    }

    var body: some View {
        NavigationStack {
            List {
                RetainedSummaryCard(
                    intents: intents,
                    currencyCode: currencyCode
                )

                Section("Purchase decisions") {
                    ForEach(intents) { intent in
                        NavigationLink(value: IntentRoute.detail(intent.id)) {
                            IntentRow(intent: intent)
                        }
                    }
                }
            }
            .overlay {
                if intents.isEmpty {
                    ContentUnavailableView(
                        "No decisions yet",
                        systemImage: "hourglass",
                        description: Text("Add something you want and revisit it with a cooler head.")
                    )
                }
            }
            .navigationTitle("StillWant")
            .navigationDestination(for: IntentRoute.self) { route in
                switch route {
                case let .detail(id):
                    if let intent = intents.first(where: { $0.id == id }) {
                        IntentDetailView(intent: intent)
                    } else {
                        ContentUnavailableView(
                            "Decision not found",
                            systemImage: "questionmark.folder"
                        )
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add decision", systemImage: "plus") {
                        presentedSheet = .add
                    }
                }
            }
            .sheet(item: $presentedSheet) { sheet in
                switch sheet {
                case .add:
                    AddIntentView()
                }
            }
        }
    }
}

private struct RetainedSummaryCard: View {
    let summary: SavingsSummary
    let currencyCode: String

    init(intents: [PurchaseIntent], currencyCode: String) {
        summary = SavingsSummary(intents: intents, currencyCode: currencyCode)
        self.currencyCode = currencyCode
    }

    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Label("Money retained", systemImage: "checkmark.circle.fill")
                    .font(.headline)
                Text(summary.retainedAmount, format: .currency(code: currencyCode))
                    .font(.largeTitle.bold())
                    .minimumScaleFactor(0.7)
                Text("Skipped purchases: \(summary.skippedCount)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .accessibilityElement(children: .combine)
            .padding(.vertical, 8)
        }
    }
}

private struct IntentRow: View {
    let intent: PurchaseIntent

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(intent.title)
                    .font(.headline)
                Spacer()
                Text(intent.amount, format: .currency(code: intent.currencyCode))
                    .font(.headline)
            }
            HStack {
                Text(intent.phase(at: .now).label)
                Spacer()
                Text(intent.revisitDate, format: .dateTime.month().day().year())
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }
}
