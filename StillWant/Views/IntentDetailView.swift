import SwiftData
import SwiftUI

struct IntentDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let intent: PurchaseIntent

    private var phase: PurchasePhase {
        intent.phase(at: .now)
    }

    var body: some View {
        List {
            Section("Purchase") {
                LabeledContent("Amount") {
                    Text(intent.amount, format: .currency(code: intent.currencyCode))
                }
                LabeledContent("Revisit date") {
                    Text(intent.revisitDate, format: .dateTime.month().day().year().hour().minute())
                }
                LabeledContent("Status") {
                    Text(phase.label)
                }
            }

            if intent.outcome == .pending {
                Section("Your decision") {
                    Button("I skipped it", systemImage: "checkmark.circle") {
                        intent.markSkipped()
                    }
                    .disabled(phase == .coolingOff)

                    Button("I bought it", systemImage: "bag") {
                        intent.markPurchased()
                    }
                    .disabled(phase == .coolingOff)

                    if phase == .coolingOff {
                        Text("Decision buttons unlock on the revisit date.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section {
                Button("Delete decision", systemImage: "trash", role: .destructive) {
                    modelContext.delete(intent)
                    dismiss()
                }
            }
        }
        .navigationTitle(intent.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
