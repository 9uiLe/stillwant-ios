import Foundation
@testable import StillWant
import Testing

struct AmountParserTests {
    @Test
    func parsesAmountUsingTheUsersLocale() {
        let locale = Locale(identifier: "en_US")

        #expect(AmountParser.parse("1,234.50", locale: locale) == Decimal(string: "1234.5"))
    }

    @Test
    func rejectsTextThatIsNotAnAmount() {
        #expect(AmountParser.parse("later", locale: Locale(identifier: "en_US")) == nil)
    }
}
