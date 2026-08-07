import Foundation

struct SavingsSummary {
    let retainedAmount: Decimal
    let skippedCount: Int
    let purchasedCount: Int
    let pendingCount: Int

    init(intents: [PurchaseIntent], currencyCode: String) {
        let matchingCurrency = intents.filter { $0.currencyCode == currencyCode }
        retainedAmount = matchingCurrency
            .filter { $0.outcome == .skipped }
            .reduce(0) { $0 + $1.amount }
        skippedCount = matchingCurrency.count { $0.outcome == .skipped }
        purchasedCount = matchingCurrency.count { $0.outcome == .purchased }
        pendingCount = matchingCurrency.count { $0.outcome == .pending }
    }
}
