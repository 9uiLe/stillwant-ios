import Foundation

enum AmountParser {
    static func parse(_ text: String, locale: Locale) -> Decimal? {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.locale = locale
        formatter.numberStyle = .decimal

        guard let number = formatter.number(from: text) else {
            return nil
        }

        return number.decimalValue
    }
}
