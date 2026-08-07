# StillWant product contract

StillWant helps a person pause before a discretionary purchase, revisit the desire after a cooling-off period, and record whether they bought it or kept the money.

## Required outcome

- Ship as a native iPhone app for iOS 26 or later, suitable for App Store submission.
- Keep development and operation free of additional fixed-cost services. Apple Developer Program membership is an external distribution prerequisite and is not created by this repository.
- Store personal purchase intentions locally; do not require an account, analytics service, advertising network, or developer-operated backend.
- Offer the complete pause-and-decide workflow for free.
- Provide an auto-renewable StillWant Plus subscription through StoreKit 2 for ongoing premium insights and data export. StoreKit test products must make the purchase flow testable without App Store Connect credentials.
- Explain the subscription terms, restoration action, and privacy behavior in the app.
- Support English and Japanese, VoiceOver labels, Dynamic Type, and reduce-motion behavior through native SwiftUI controls.

## Observable acceptance seams

- A user can add an item with a name, amount, and revisit date; after the revisit date they can mark it bought or skipped.
- The app reports money retained from skipped items using locale-aware currency formatting.
- A StoreKit configuration contains the same subscription product identifier requested by the app, and a user can purchase or restore it in the StoreKit test environment.
- A clean checkout enters the Nix development shell, generates the Xcode project, builds and tests on an iOS Simulator, and produces an unsigned generic iOS archive with host Xcode.
- nagi runs the implementation in an isolated worktree and independently records QA against the candidate commit.
