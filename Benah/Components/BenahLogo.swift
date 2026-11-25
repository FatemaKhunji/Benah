// BenahLogo.swift
// The Benah mark (concept "D1", the clear-pane B), drawn from the Figma vectors
// so it stays sharp at any size. No image file needed.
//
//   BenahLogo()                 // 120 pt
//   BenahLogo(size: 64)
//   BenahLogoLockup()           // mark + "Benah · بينّه"

import SwiftUI

/// Shapes from Figma "Logo / Benah mark", in its 300 × 300 drawing box.
private enum LogoGeometry {
    static let box: CGFloat = 300

    static func coralPane() -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 81, y: 42))
        p.addLine(to: CGPoint(x: 183, y: 42))
        p.addArc(center: CGPoint(x: 183, y: 99), radius: 57, startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: false)
        p.addLine(to: CGPoint(x: 81, y: 156))
        p.closeSubpath()
        return p
    }

    static func tealPane() -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 81, y: 132))
        p.addLine(to: CGPoint(x: 195, y: 132))
        p.addArc(center: CGPoint(x: 195, y: 195), radius: 63, startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: false)
        p.addLine(to: CGPoint(x: 81, y: 258))
        p.closeSubpath()
        return p
    }

    static func stem() -> Path {
        Path(roundedRect: CGRect(x: 63, y: 42, width: 45, height: 216), cornerRadius: 12)
    }
}

struct BenahLogo: View {
    var size: CGFloat = 120

    var body: some View {
        Canvas { context, canvasSize in
            let scale = canvasSize.width / LogoGeometry.box
            context.scaleBy(x: scale, y: scale)
            let c = Color.benah
            let coral = LogoGeometry.coralPane()
            let teal = LogoGeometry.tealPane()
            context.fill(coral, with: .color(c.logoCoral))
            context.fill(teal, with: .color(c.logoTeal))
            // Where the two panes overlap, the colour mixes to amber ("clear pane" effect).
            var overlap = context
            overlap.clip(to: coral)
            overlap.fill(teal, with: .color(c.logoAmber))
            context.fill(LogoGeometry.stem(), with: .color(c.logoStem))
        }
        .frame(width: size, height: size)
        .accessibilityLabel("Benah")
    }
}

struct BenahLogoLockup: View {
    var markSize: CGFloat = 56

    var body: some View {
        HStack(spacing: Space.s12) {
            BenahLogo(size: markSize)
            VStack(alignment: .leading, spacing: 0) {
                Text("Benah").benahFont(.title1)
                Text("بينّه").benahFont(.arHeading)
            }
            .foregroundStyle(Color.benah.textPrimary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Benah")
    }
}

#Preview {
    VStack(spacing: 24) {
        BenahLogo()
        BenahLogoLockup()
    }
    .padding()
}
