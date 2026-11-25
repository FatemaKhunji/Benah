// Colors.swift
// The Benah colour tokens, copied from the Figma variable collection "Benah · Color".
//
// 📘 Learning note
// A "token" is a named design value. Instead of writing Color(red:…) on every
// screen, you write `Color.benah.brandNavy`. If the designer changes navy later,
// we change it here once and every screen updates.
//
// Every token has a Light and a Dark value (the two "modes" in Figma).
// `Color(lightHex:darkHex:)` below builds a colour that switches automatically when the
// phone changes between light and dark mode, so screens never need `if dark { … }`.

import SwiftUI
import UIKit

extension Color {
    /// Builds a colour that follows the system appearance (light / dark).
    init(lightHex light: UInt32, darkHex dark: UInt32, lightAlpha: Double = 1, darkAlpha: Double = 1) {
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(hex: dark, alpha: darkAlpha)
                : UIColor(hex: light, alpha: lightAlpha)
        })
    }

    /// Namespace so you can type `Color.benah.` and let autocomplete show every token.
    static let benah = BenahColors()
}

extension UIColor {
    /// `UIColor(hex: 0x263D60)` → the colour #263D60.
    convenience init(hex: UInt32, alpha: Double = 1) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: alpha
        )
    }
}

/// All colour tokens. Names mirror Figma: "brand/navy" → `brandNavy`.
struct BenahColors {
    // MARK: Brand
    let brandNavy           = Color(lightHex: 0x263D60, darkHex: 0x0A84FF)
    let brandNavyStrong     = Color(lightHex: 0x1A2B45, darkHex: 0x409CFF)
    let brandNavyTint       = Color(lightHex: 0xE7ECF4, darkHex: 0x18314B)
    /// Use for filled buttons/chips: slightly deeper in dark mode so white text stays readable.
    let brandNavySolid      = Color(lightHex: 0x263D60, darkHex: 0x0973DE)
    let brandNavyStrongSolid = Color(lightHex: 0x1A2B45, darkHex: 0x3177C2)
    let brandSaffron        = Color(lightHex: 0xF2B456, darkHex: 0xFFD60A)
    let brandSaffronTint    = Color(lightHex: 0xFDF3E1, darkHex: 0x49411A)

    // MARK: Modules (each feature has its own colour)
    let jamiya       = Color(lightHex: 0x9A5B07, darkHex: 0xFF9F0A)
    let jamiyaTint   = Color(lightHex: 0xFBF0DC, darkHex: 0x49361A)
    let jamiyaSolid  = Color(lightHex: 0x9A5B07, darkHex: 0xA36606)
    let lammah       = Color(lightHex: 0xB23F2A, darkHex: 0xFF6961)
    let lammahTint   = Color(lightHex: 0xFCE9E4, darkHex: 0x492B2B)
    let lammahSolid  = Color(lightHex: 0xB23F2A, darkHex: 0xC2504A)
    let qattah       = Color(lightHex: 0x0F6E68, darkHex: 0x40C8E0)
    let qattahTint   = Color(lightHex: 0xDDF1EF, darkHex: 0x233E45)
    let qattahSolid  = Color(lightHex: 0x0F6E68, darkHex: 0x287E8D)

    // MARK: Backgrounds
    let bgCanvas   = Color(lightHex: 0xF5F7FA, darkHex: 0x000000)   // screen background
    let bgSurface  = Color(lightHex: 0xFFFFFF, darkHex: 0x1C1C1E)   // cards, fields
    let bgSunken   = Color(lightHex: 0xEAEEF3, darkHex: 0x2C2C2E)   // disabled, inset areas
    let bgInverse  = Color(lightHex: 0x1F1A24, darkHex: 0x3A3A3C)   // toasts
    let bgGlass    = Color(lightHex: 0xFFFFFF, darkHex: 0x1C1C1E, lightAlpha: 0.82, darkAlpha: 0.82)

    // MARK: Borders
    let borderDefault = Color(lightHex: 0xDDE3EA, darkHex: 0x38383A)
    let borderStrong  = Color(lightHex: 0xC4CCD7, darkHex: 0x48484A)

    // MARK: Text
    let textPrimary        = Color(lightHex: 0x1F1A24, darkHex: 0xFFFFFF)
    let textSecondary      = Color(lightHex: 0x5F5768, darkHex: 0x98989F)
    let textTertiary       = Color(lightHex: 0x726A7A, darkHex: 0x8E8E93)
    let textOnBrand        = Color(lightHex: 0xFFFFFF, darkHex: 0xFFFFFF)
    let textOnBrandMuted   = Color(lightHex: 0xE7ECF4, darkHex: 0xDCE6F5)

    // MARK: Status (always pair a colour with a written label: never colour alone)
    let success      = Color(lightHex: 0x1F7A52, darkHex: 0x30D158)
    let successTint  = Color(lightHex: 0xE1F2EA, darkHex: 0x20402A)
    let warning      = Color(lightHex: 0x8F5A06, darkHex: 0xFF9F0A)
    let warningTint  = Color(lightHex: 0xFBF0DC, darkHex: 0x49361A)
    let danger       = Color(lightHex: 0xBE342B, darkHex: 0xFF453A)
    let dangerTint   = Color(lightHex: 0xFBE7E5, darkHex: 0x492424)
    let info         = Color(lightHex: 0x3A58A6, darkHex: 0x0A84FF)
    let infoTint     = Color(lightHex: 0xE7ECF8, darkHex: 0x18314B)

    // MARK: Overlays
    /// Dim behind sheets and dialogs.
    let backdrop = Color(lightHex: 0x1F1A24, darkHex: 0x000000, lightAlpha: 0.40, darkAlpha: 0.50)

    // MARK: Logo
    let logoCoral = Color(lightHex: 0xEE6F5B, darkHex: 0xEE6F5B)
    let logoTeal  = Color(lightHex: 0x2BA59A, darkHex: 0x2BA59A)
    let logoAmber = Color(lightHex: 0xF2A93B, darkHex: 0xF2A93B)
    /// The "B" stem is navy on light screens and cream on dark screens (Handoff notes).
    let logoStem  = Color(lightHex: 0x2C3E5F, darkHex: 0xF8F5F0)
}
