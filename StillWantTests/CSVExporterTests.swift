import Foundation
@testable import StillWant
import Testing

struct CSVExporterTests {
    @Test
    func exportsStableFieldsAndEscapesUserText() throws {
        let intent = try PurchaseIntent(
            title: "Lamp, \"warm\"",
            amount: #require(Decimal(string: "12.5")),
            currencyCode: "USD",
            createdAt: Date(timeIntervalSince1970: 0),
            revisitDate: Date(timeIntervalSince1970: 0)
        )
        intent.markSkipped(on: Date(timeIntervalSince1970: 1))

        let csv = try #require(
            String(data: CSVExporter.export(intents: [intent]), encoding: .utf8)
        )

        #expect(csv.hasPrefix("title,amount,currency,revisit_date,outcome\n"))
        #expect(csv.contains("\"Lamp, \"\"warm\"\"\""))
        #expect(csv.contains("\"12.5\",\"USD\""))
        #expect(csv.contains("\"skipped\""))
    }
}
