import Foundation
import SwiftData

enum PurchaseOutcome: String, Codable {
    case pending
    case purchased
    case skipped
}

enum PurchasePhase: Equatable {
    case coolingOff
    case ready
    case purchased
    case skipped

    var label: LocalizedStringResource {
        switch self {
        case .coolingOff:
            "Cooling off"
        case .ready:
            "Ready to decide"
        case .purchased:
            "Purchased"
        case .skipped:
            "Skipped"
        }
    }
}

@Model
final class PurchaseIntent {
    @Attribute(.unique) var id: UUID
    var title: String
    private var amountStorage: String
    var currencyCode: String
    var createdAt: Date
    var revisitDate: Date
    var decidedAt: Date?
    private var outcomeStorage: String

    init(
        id: UUID = UUID(),
        title: String,
        amount: Decimal,
        currencyCode: String,
        createdAt: Date = .now,
        revisitDate: Date
    ) {
        self.id = id
        self.title = title
        amountStorage = NSDecimalNumber(decimal: amount).stringValue
        self.currencyCode = currencyCode
        self.createdAt = createdAt
        self.revisitDate = revisitDate
        decidedAt = nil
        outcomeStorage = PurchaseOutcome.pending.rawValue
    }

    var amount: Decimal {
        Decimal(string: amountStorage, locale: Locale(identifier: "en_US_POSIX")) ?? 0
    }

    var outcome: PurchaseOutcome {
        PurchaseOutcome(rawValue: outcomeStorage) ?? .pending
    }

    func phase(at date: Date) -> PurchasePhase {
        switch outcome {
        case .purchased:
            .purchased
        case .skipped:
            .skipped
        case .pending where date < revisitDate:
            .coolingOff
        case .pending:
            .ready
        }
    }

    func markPurchased(on date: Date = .now) {
        outcomeStorage = PurchaseOutcome.purchased.rawValue
        decidedAt = date
    }

    func markSkipped(on date: Date = .now) {
        outcomeStorage = PurchaseOutcome.skipped.rawValue
        decidedAt = date
    }
}
