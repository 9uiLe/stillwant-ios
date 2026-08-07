import Foundation
@testable import StillWant
import Testing

struct StoreKitConfigurationTests {
    @Test
    func localConfigurationContainsTheRequestedSubscription() throws {
        let repositoryRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let configurationURL = repositoryRoot
            .appending(path: "StillWant/Resources/StillWant.storekit")
        let configuration = try String(contentsOf: configurationURL, encoding: .utf8)

        #expect(configuration.contains(ProductIdentifiers.plusMonthly))
    }
}
