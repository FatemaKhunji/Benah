// Typography.swift
// The text styles from Figma ("Display/Large", "Title/1", "Body/M", …).
//
// 📘 Learning note
// Usage on any Text:   Text("Your activities").benahFont(.title3)
// That one call sets the font, size, line height and letter spacing from Figma.
//
// Fonts used (all free, SIL Open Font License; licence files are in Resources/Fonts):
//   • Plus Jakarta Sans: headings, amounts, buttons
//   • Inter: body text and labels
//   • Readex Pro: Arabic
// Sizes scale with the user's Dynamic Type setting (accessibility text size).

import SwiftUI

enum BenahTextStyle: CaseIterable {
    case displayLarge, title1, title2, title3
    case amountXL, amountL, amountM
    case button, buttonSmall
    case bodyL, bodyM, bodyMStrong
    case labelM, labelS
    case caption, captionStrong, overline
    case arTitle, arHeading, arBody, arLabel

    /// PostScript name of the font file (what iOS calls the font internally).
    var fontName: String {
        switch self {
        case .displayLarge, .amountXL, .amountL: return "PlusJakartaSans-ExtraBold"
        case .title1, .title2, .title3, .amountM, .button, .buttonSmall: return "PlusJakartaSans-Bold"
        case .bodyL, .bodyM, .caption: return "Inter-Regular"
        case .bodyMStrong, .labelM, .labelS, .captionStrong: return "Inter-SemiBold"
        case .overline: return "Inter-Bold"
        case .arTitle, .arHeading: return "ReadexPro-SemiBold"
        case .arBody: return "ReadexPro-Regular"
        case .arLabel: return "ReadexPro-Medium"
        }
    }

    var size: CGFloat {
        switch self {
        case .displayLarge: 34
        case .title1: 28
        case .title2: 20
        case .title3: 17
        case .amountXL: 36
        case .amountL: 26
        case .amountM: 18
        case .button: 16
        case .buttonSmall: 14
        case .bodyL: 17
        case .bodyM, .bodyMStrong: 15
        case .labelM: 14
        case .labelS: 11
        case .caption, .captionStrong: 13
        case .overline: 12
        case .arTitle: 26
        case .arHeading: 18
        case .arBody: 15
        case .arLabel: 13
        }
    }

    /// Line height in points (from Figma).
    var lineHeight: CGFloat {
        switch self {
        case .displayLarge: 40
        case .title1: 34
        case .title2: 26
        case .title3: 22
        case .amountXL: 42
        case .amountL: 32
        case .amountM: 24
        case .button, .buttonSmall: 20
        case .bodyL: 26
        case .bodyM, .bodyMStrong: 22
        case .labelM: 20
        case .labelS: 14
        case .caption, .captionStrong: 18
        case .overline: 16
        case .arTitle: 38
        case .arHeading: 28
        case .arBody: 24
        case .arLabel: 20
        }
    }

    /// Letter spacing as a percentage of the font size (Figma uses %).
    var trackingPercent: CGFloat {
        switch self {
        case .displayLarge, .amountXL: -1
        case .title1, .amountL: -0.5
        case .title2: -0.3
        case .overline: 6
        default: 0
        }
    }

    /// Which Dynamic Type size this style grows with.
    var relativeTo: Font.TextStyle {
        switch self {
        case .displayLarge, .amountXL: .largeTitle
        case .title1, .amountL, .arTitle: .title
        case .title2, .arHeading: .title2
        case .title3, .amountM: .headline
        case .button, .bodyL: .body
        case .bodyM, .bodyMStrong, .arBody, .buttonSmall: .subheadline
        case .labelM, .arLabel: .callout
        case .caption, .captionStrong, .overline: .caption
        case .labelS: .caption2
        }
    }

    var font: Font { .custom(fontName, size: size, relativeTo: relativeTo) }
}

private struct BenahFontModifier: ViewModifier {
    let style: BenahTextStyle

    func body(content: Content) -> some View {
        content
            .font(style.font)
            .tracking(style.size * style.trackingPercent / 100)
            // SwiftUI has no "line height", so we add the extra space between lines.
            .lineSpacing(max(0, style.lineHeight - style.size * 1.2))
            .textCase(style == .overline ? .uppercase : nil)
    }
}

extension View {
    /// Applies a Benah text style, e.g. `.benahFont(.bodyM)`.
    func benahFont(_ style: BenahTextStyle) -> some View {
        modifier(BenahFontModifier(style: style))
    }
}
