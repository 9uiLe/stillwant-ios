import Foundation
@testable import StillWant
import Testing

struct PurchaseIntentTests {
    @Test
    func coolingOffIntentBecomesReadyAtRevisitDate() {
        let revisitDate = Date(timeIntervalSince1970: 1000)
        let intent = PurchaseIntent(
            title: "Desk lamp",
            amount: 12345,
            currencyCode: "JPY",
            revisitDate: revisitDate
        )

        #expect(intent.phase(at: revisitDate.addingTimeInterval(-1)) == .coolingOff)
        #expect(intent.phase(at: revisitDate) == .ready)
    }

    @Test
    func skippedIntentCountsAsRetainedMoneyButPurchasedIntentDoesNot() {
        let skipped = PurchaseIntent(
            title: "Headphones",
            amount: 120,
            currencyCode: "USD",
            revisitDate: .distantPast
        )
        skipped.markSkipped(on: Date(timeIntervalSince1970: 2000))

        let purchased = PurchaseIntent(
            title: "Shoes",
            amount: 80,
            currencyCode: "USD",
            revisitDate: .distantPast
        )
        purchased.markPurchased(on: Date(timeIntervalSince1970: 2000))

        let summary = SavingsSummary(intents: [skipped, purchased], currencyCode: "USD")

        #expect(summary.retainedAmount == 120)
        #expect(summary.skippedCount == 1)
    }
}
