import SwiftData
import SwiftUI

struct AddIntentView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.locale) private var locale
    @Environment(\.modelContext) private var modelContext
    @State private var amountText = ""
    @State private var revisitDate = Date.now
    @State private var title = ""

    private var amount: Decimal? {
        AmountParser.parse(amountText, locale: locale)
    }

    private var currencyCode: String {
        locale.currency?.identifier ?? "USD"
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && amount.map { $0 > 0 } == true
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("What do you want?") {
                    TextField("Item name", text: $title)
                        .textInputAutocapitalization(.sentences)
                    TextField("Amount", text: $amountText)
                        .keyboardType(.decimalPad)
                        .accessibilityHint(Text("Enter the price in \(currencyCode)"))
                }

                Section("When should you decide?") {
                    DatePicker(
                        "Revisit date",
                        selection: $revisitDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
            }
            .navigationTitle("New decision")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }

    private func save() {
        guard let amount else {
            return
        }

        let intent = PurchaseIntent(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            amount: amount,
            currencyCode: currencyCode,
            revisitDate: revisitDate
        )
        modelContext.insert(intent)
        dismiss()
    }
}
