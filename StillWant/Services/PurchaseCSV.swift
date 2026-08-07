import CoreTransferable
import Foundation
import UniformTypeIdentifiers

struct PurchaseCSV: Transferable {
    let data: Data

    init(intents: [PurchaseIntent]) {
        data = CSVExporter.export(intents: intents)
    }

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .commaSeparatedText) { export in
            export.data
        }
        .suggestedFileName("StillWant.csv")
    }
}

enum CSVExporter {
    static func export(intents: [PurchaseIntent]) -> Data {
        let header = "title,amount,currency,revisit_date,outcome\n"
        let rows = intents.map { intent in
            [
                escape(intent.title),
                escape(NSDecimalNumber(decimal: intent.amount).stringValue),
                escape(intent.currencyCode),
                escape(intent.revisitDate.ISO8601Format()),
                escape(intent.outcome.rawValue),
            ].joined(separator: ",")
        }
        let csv = header + rows.joined(separator: "\n") + (rows.isEmpty ? "" : "\n")
        return Data(csv.utf8)
    }

    private static func escape(_ value: String) -> String {
        "\"\(value.replacingOccurrences(of: "\"", with: "\"\""))\""
    }
}
