import Observation
import StoreKit

@MainActor
@Observable
final class EntitlementStore {
    private(set) var hasPlus = false
    @ObservationIgnored private var updatesTask: Task<Void, Never>?

    func start() async {
        await refresh()

        guard updatesTask == nil else {
            return
        }

        updatesTask = Task { [weak self] in
            for await _ in Transaction.updates {
                guard !Task.isCancelled else {
                    return
                }
                await self?.refresh()
            }
        }
    }

    func refresh() async {
        var active = false

        for await result in Transaction.currentEntitlements {
            guard case let .verified(transaction) = result else {
                continue
            }
            if transaction.productID == ProductIdentifiers.plusMonthly,
               transaction.revocationDate == nil
            {
                active = true
            }
        }

        hasPlus = active
    }

    deinit {
        updatesTask?.cancel()
    }
}
