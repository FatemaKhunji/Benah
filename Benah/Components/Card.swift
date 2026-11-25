// Card.swift
// Small layout helpers used on almost every screen.
//
//   VStack { … }.benahCard()                  // white rounded card with soft shadow
//   SectionHeader("In progress")               // bold section title
//   SectionHeader("Your people", actionTitle: "See all") { … }

import SwiftUI

extension View {
    /// White (or dark grey in dark mode) rounded card, radius 20, Elevation/Card shadow.
    func benahCard(padding: CGFloat = Space.s16) -> some View {
        self
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.benah.bgSurface, in: RoundedRectangle(cornerRadius: Radius.lg, style: .continuous))
            .elevation(.card)
    }

    /// The standard screen background colour, extended behind the status bar.
    func benahScreenBackground() -> some View {
        background(Color.benah.bgCanvas.ignoresSafeArea())
    }
}

struct SectionHeader: View {
    let title: LocalizedStringKey
    var actionTitle: LocalizedStringKey? = nil
    var action: (() -> Void)? = nil

    init(_ title: LocalizedStringKey, actionTitle: LocalizedStringKey? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        HStack {
            Text(title)
                .benahFont(.title3)
                .foregroundStyle(Color.benah.textPrimary)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .benahFont(.labelM)
                    .foregroundStyle(Color.benah.brandNavy)
            }
        }
    }
}
