// Layout.swift
// Spacing, corner radius and shadow tokens from Figma ("Benah · Spacing & Radius"
// and the Elevation styles).
//
// 📘 Learning note
// Use `.padding(Space.s16)` instead of `.padding(16)`. The number is the same,
// but the name tells everyone it is a design token, not a random value.

import SwiftUI
import UIKit

enum Space {
    static let s4: CGFloat = 4
    static let s8: CGFloat = 8
    static let s12: CGFloat = 12
    static let s16: CGFloat = 16
    static let s20: CGFloat = 20   // standard screen side margin
    static let s24: CGFloat = 24
    static let s32: CGFloat = 32
}

enum Radius {
    static let sm: CGFloat = 11
    static let md: CGFloat = 14    // text fields
    static let lg: CGFloat = 20    // cards
    static let xl: CGFloat = 28    // sheets
    static let pill: CGFloat = 999 // fully rounded
}

/// Shadow styles. In Figma they are "Elevation/Card", "Elevation/Raised", "Elevation/Sheet".
enum Elevation {
    case card, raised, sheet
}

private struct ElevationModifier: ViewModifier {
    let level: Elevation
    @Environment(\.colorScheme) private var scheme

    // Shadow colour is the dark "text/primary" (#1F1A24) at low opacity.
    private let shadowColor = Color(uiColor: UIColor(hex: 0x1F1A24))

    func body(content: Content) -> some View {
        // Shadows are invisible on black, so dark mode relies on surface colours instead.
        let strength: Double = scheme == .dark ? 0 : 1
        switch level {
        case .card:
            content
                .shadow(color: shadowColor.opacity(0.05 * strength), radius: 1, y: 1)
                .shadow(color: shadowColor.opacity(0.06 * strength), radius: 10, y: 6)
        case .raised:
            content.shadow(color: shadowColor.opacity(0.12 * strength), radius: 12, y: 8)
        case .sheet:
            content.shadow(color: shadowColor.opacity(0.18 * strength), radius: 20, y: 12)
        }
    }
}

extension View {
    /// Adds a Figma elevation shadow, e.g. `.elevation(.card)`.
    func elevation(_ level: Elevation) -> some View {
        modifier(ElevationModifier(level: level))
    }
}
