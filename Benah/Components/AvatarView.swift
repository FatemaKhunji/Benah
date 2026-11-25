// AvatarView.swift
// The Figma "Avatar" component: a circle with initials. 6 tones × 2 sizes.
//
//   AvatarView(initials: "FA")                         // tone picked from the initials
//   AvatarView(initials: "YM", tone: .teal, size: .large)

import SwiftUI

struct AvatarView: View {
    enum Tone: CaseIterable { case navy, saffron, coral, teal, blue, sand }
    enum Size { case medium, large }

    let initials: String
    var tone: Tone? = nil
    var size: Size = .medium

    /// If no tone is given, choose one from the initials so the same person
    /// always gets the same colour on every screen.
    private var resolvedTone: Tone {
        if let tone { return tone }
        let sum = initials.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        return Tone.allCases[sum % Tone.allCases.count]
    }

    private var colors: (bg: Color, fg: Color) {
        let c = Color.benah
        switch resolvedTone {
        case .navy: return (c.brandNavyTint, c.brandNavy)
        case .saffron: return (c.brandSaffronTint, c.warning)
        case .coral: return (c.lammahTint, c.lammah)
        case .teal: return (c.qattahTint, c.qattah)
        case .blue: return (c.infoTint, c.info)
        case .sand: return (c.bgSunken, c.textSecondary)
        }
    }

    var body: some View {
        let dimension: CGFloat = size == .large ? 56 : 40
        Text(initials.uppercased())
            .font(.custom("PlusJakartaSans-Bold", size: size == .large ? 20 : 15))
            .foregroundStyle(colors.fg)
            .frame(width: dimension, height: dimension)
            .background(colors.bg, in: Circle())
            .accessibilityHidden(true) // the person's name is shown/read next to the avatar
    }
}

extension String {
    /// "Fatima Alrafaei" → "FA"
    var initials: String {
        split(separator: " ").prefix(2).compactMap(\.first).map(String.init).joined()
    }
}

#Preview {
    HStack {
        ForEach(AvatarView.Tone.allCases, id: \.self) { tone in
            AvatarView(initials: "FA", tone: tone)
        }
    }
    .padding()
}
