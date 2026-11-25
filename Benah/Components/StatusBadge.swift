// StatusBadge.swift
// The Figma "Badge" component: a small pill with a dot and a label.
//
//   StatusBadge("Paid", tone: .success)
//   StatusBadge("Waiting", tone: .warning)
//   StatusBadge("Jam'iya", tone: .jamiya)
//
// Accessibility rule from the Read Me: status is always a written label plus colour,
// never colour alone. That is why the badge requires text.

import SwiftUI

enum BadgeTone: CaseIterable {
    case neutral, brand, success, warning, danger, info, jamiya, lammah, qattah

    var foreground: Color {
        let c = Color.benah
        switch self {
        case .neutral: return c.textSecondary
        case .brand: return c.brandNavy
        case .success: return c.success
        case .warning: return c.warning
        case .danger: return c.danger
        case .info: return c.info
        case .jamiya: return c.jamiya
        case .lammah: return c.lammah
        case .qattah: return c.qattah
        }
    }

    var background: Color {
        let c = Color.benah
        switch self {
        case .neutral: return c.bgSunken
        case .brand: return c.brandNavyTint
        case .success: return c.successTint
        case .warning: return c.warningTint
        case .danger: return c.dangerTint
        case .info: return c.infoTint
        case .jamiya: return c.jamiyaTint
        case .lammah: return c.lammahTint
        case .qattah: return c.qattahTint
        }
    }
}

struct StatusBadge: View {
    let text: String
    var tone: BadgeTone = .neutral
    var showsDot: Bool = true

    init(_ text: String, tone: BadgeTone = .neutral, showsDot: Bool = true) {
        self.text = text
        self.tone = tone
        self.showsDot = showsDot
    }

    var body: some View {
        HStack(spacing: 6) {
            if showsDot {
                Circle().fill(tone.foreground).frame(width: 6, height: 6)
            }
            Text(text).benahFont(.captionStrong)
        }
        .foregroundStyle(tone.foreground)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(tone.background, in: Capsule())
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 8) {
        ForEach(BadgeTone.allCases, id: \.self) { tone in
            StatusBadge("\(tone)".capitalized, tone: tone)
        }
    }
    .padding()
}
