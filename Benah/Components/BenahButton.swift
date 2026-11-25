// BenahButton.swift
// The Figma "Button" component: 4 styles × 2 sizes × (default / disabled).
//
// 📘 Learning note
// In SwiftUI a reusable look for buttons is a `ButtonStyle`. You keep using the
// normal `Button`, and add `.buttonStyle(.benah(.primary))` to give it the Benah look.
//
//   Button("Continue") { … }
//       .buttonStyle(.benah(.primary))
//
//   Button("Cancel") { … }
//       .buttonStyle(.benah(.secondary, size: .small))
//
// Disabled state comes for free: add `.disabled(true)` and the style switches colours.

import SwiftUI

struct BenahButtonStyle: ButtonStyle {
    enum Kind { case primary, secondary, tertiary, destructive }
    enum Size { case large, small }

    var kind: Kind = .primary
    var size: Size = .large
    /// Large buttons stretch to the full width by default, like the Figma bottom action bar.
    var fullWidth: Bool = true

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        let c = Color.benah
        let background: Color = {
            guard isEnabled else { return kind == .tertiary ? .clear : c.bgSunken }
            switch kind {
            case .primary: return c.brandNavySolid
            case .secondary: return c.brandNavyTint
            case .tertiary: return .clear
            case .destructive: return c.dangerTint
            }
        }()
        let foreground: Color = {
            guard isEnabled else { return c.textTertiary }
            switch kind {
            case .primary: return c.textOnBrand
            case .secondary, .tertiary: return c.brandNavy
            case .destructive: return c.danger
            }
        }()

        configuration.label
            .benahFont(size == .large ? .button : .buttonSmall)
            .foregroundStyle(foreground)
            .padding(.horizontal, size == .large ? Space.s24 : 14)
            .frame(height: size == .large ? 52 : 36)
            .frame(maxWidth: fullWidth && size == .large ? .infinity : nil)
            .background(background, in: RoundedRectangle(cornerRadius: size == .large ? 16 : 12, style: .continuous))
            .contentShape(Rectangle())
            // Micro-interaction from the Handoff page: darken + scale to 0.98 on press.
            .overlay {
                RoundedRectangle(cornerRadius: size == .large ? 16 : 12, style: .continuous)
                    .fill(Color.black.opacity(configuration.isPressed ? 0.08 : 0))
            }
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == BenahButtonStyle {
    static func benah(_ kind: BenahButtonStyle.Kind = .primary,
                      size: BenahButtonStyle.Size = .large,
                      fullWidth: Bool = true) -> BenahButtonStyle {
        BenahButtonStyle(kind: kind, size: size, fullWidth: fullWidth)
    }
}

#Preview {
    VStack(spacing: 12) {
        Button("Continue") {}.buttonStyle(.benah(.primary))
        Button("Continue") {}.buttonStyle(.benah(.primary)).disabled(true)
        Button("Continue") {}.buttonStyle(.benah(.secondary))
        Button("Continue") {}.buttonStyle(.benah(.tertiary))
        Button("Leave Jam'iya") {}.buttonStyle(.benah(.destructive))
        HStack {
            Button("Small") {}.buttonStyle(.benah(.primary, size: .small))
            Button("Small") {}.buttonStyle(.benah(.secondary, size: .small))
        }
    }
    .padding()
    .background(Color.benah.bgCanvas)
}
