// DesignSystemGalleryView.swift
// A developer screen showing every token and component, so you can compare the
// app side by side with the Figma "📘 Read Me & Design System" page.
// Open it from Profile → Developer → Design system.

import SwiftUI

struct DesignSystemGalleryView: View {
    @Environment(ToastCenter.self) private var toasts
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var text = ""
    @State private var phone = ""
    @State private var toggleOn = true
    @State private var checked = true
    @State private var radio = 0
    @State private var chip = "Monthly"
    @State private var tab: AppTab = .home

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Space.s32) {
                group("Logo") {
                    HStack(spacing: Space.s24) {
                        BenahLogo(size: 96)
                        BenahLogoLockup()
                    }
                }

                group("Colours") { colours }

                group("Typography") {
                    VStack(alignment: .leading, spacing: Space.s8) {
                        ForEach(BenahTextStyle.allCases, id: \.self) { style in
                            Text(sampleText(for: style)).benahFont(style)
                        }
                    }
                }

                group("Buttons") {
                    VStack(spacing: Space.s12) {
                        Button("Continue") {}.buttonStyle(.benah(.primary))
                        Button("Continue") {}.buttonStyle(.benah(.primary)).disabled(true)
                        Button("Continue") {}.buttonStyle(.benah(.secondary))
                        Button("Continue") {}.buttonStyle(.benah(.tertiary))
                        Button("Leave") {}.buttonStyle(.benah(.destructive))
                        HStack {
                            Button("Small") {}.buttonStyle(.benah(.primary, size: .small))
                            Button("Small") {}.buttonStyle(.benah(.secondary, size: .small))
                            Button("Small") {}.buttonStyle(.benah(.destructive, size: .small))
                        }
                    }
                }

                group("Fields") {
                    VStack(spacing: Space.s16) {
                        BenahTextField(label: "First name", text: $text, placeholder: "Fatima", isRequired: true)
                        BenahTextField(label: "Mobile number", text: $phone, placeholder: "3912 3456",
                                       prefix: "+973", helper: "We'll send a 6-digit code", keyboard: .phonePad)
                        BenahTextField(label: "Surname", text: .constant(""), isRequired: true, error: "Enter your surname")
                        BenahTextField(label: "Email", text: .constant("fatima.ahmed@example.com")).disabled(true)
                    }
                }

                group("Badges") {
                    FlowRow {
                        ForEach(BadgeTone.allCases, id: \.self) { tone in
                            StatusBadge("\(tone)".capitalized, tone: tone)
                        }
                    }
                }

                group("Chips") {
                    HStack {
                        ForEach(["Weekly", "Monthly"], id: \.self) { option in
                            BenahChip(option, isSelected: chip == option) { chip = option }
                        }
                    }
                }

                group("Avatars") {
                    HStack {
                        ForEach(AvatarView.Tone.allCases, id: \.self) { tone in
                            AvatarView(initials: "FA", tone: tone)
                        }
                    }
                }

                group("Toggle, checkbox, radio") {
                    VStack(alignment: .leading, spacing: Space.s12) {
                        Toggle("Notifications", isOn: $toggleOn).toggleStyle(.benah).benahFont(.bodyM)
                        HStack { CheckboxView(isChecked: $checked); Text("I agree").benahFont(.bodyM) }
                        ForEach(0..<2) { i in
                            Button { radio = i } label: {
                                HStack { RadioView(isSelected: radio == i); Text(i == 0 ? "Apple Pay" : "BenefitPay").benahFont(.bodyM) }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                group("Toasts") {
                    VStack(spacing: Space.s12) {
                        Button("Show success toast") { toasts.show("Reminder sent to Ahmed and Noor", reduceMotion: reduceMotion) }
                            .buttonStyle(.benah(.secondary, size: .small))
                        Button("Show danger toast") { toasts.show("Payment failed. Try again", tone: .danger, reduceMotion: reduceMotion) }
                            .buttonStyle(.benah(.secondary, size: .small))
                    }
                }

                group("Notification bell & tab bar") {
                    VStack(spacing: Space.s16) {
                        HStack(spacing: Space.s24) {
                            NotificationBell(unreadCount: 5) {}
                            NotificationBell(unreadCount: 0) {}
                        }
                        BenahTabBar(selection: $tab).padding(.horizontal, -Space.s16)
                    }
                }

                group("Icons") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: Space.s12) {
                        ForEach(BenahIcon.allCases, id: \.self) { BenahIconView($0, size: 22) }
                    }
                    .foregroundStyle(Color.benah.textPrimary)
                }

                group("Money") {
                    VStack(alignment: .leading) {
                        Text(Money(fils: 10_000).formatted()).benahFont(.amountL)
                        Text(Money(fils: 50_000).formatted(arabic: true)).benahFont(.arHeading)
                        Text("10.000 ÷ 3 = " + Money(fils: 10_000).split(into: 3).map(\.description).joined(separator: " + "))
                            .benahFont(.caption)
                    }
                }
            }
            .padding(Space.s20)
            .padding(.bottom, 100)
        }
        .benahScreenBackground()
        .navigationTitle("Design system")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Pieces

    private var colours: some View {
        let c = Color.benah
        let swatches: [(String, Color)] = [
            ("brand/navy", c.brandNavy), ("navy-tint", c.brandNavyTint), ("saffron", c.brandSaffron),
            ("jamiya", c.jamiya), ("lammah", c.lammah), ("qattah", c.qattah),
            ("canvas", c.bgCanvas), ("surface", c.bgSurface), ("sunken", c.bgSunken),
            ("text/primary", c.textPrimary), ("text/secondary", c.textSecondary), ("border", c.borderStrong),
            ("success", c.success), ("warning", c.warning), ("danger", c.danger), ("info", c.info),
        ]
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: Space.s8), count: 4), spacing: Space.s12) {
            ForEach(swatches.indices, id: \.self) { index in
                let swatch = swatches[index]
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: Radius.sm)
                        .fill(swatch.1)
                        .frame(height: 44)
                        .overlay(RoundedRectangle(cornerRadius: Radius.sm).strokeBorder(c.borderDefault))
                    Text(swatch.0).benahFont(.labelS).foregroundStyle(c.textSecondary).lineLimit(1).minimumScaleFactor(0.7)
                }
            }
        }
    }

    private func group<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: Space.s12) {
            Text(title).benahFont(.overline).foregroundStyle(Color.benah.textSecondary)
            content()
        }
    }

    private func sampleText(for style: BenahTextStyle) -> String {
        switch style {
        case .arTitle, .arHeading, .arBody, .arLabel: return "جمعية · لمّة · قطّة"
        case .amountXL, .amountL, .amountM: return "BHD 250.000"
        default: return "\(style)"
        }
    }
}

/// Simple wrapping row (badges wrap onto the next line).
struct FlowRow: Layout {
    var spacing: CGFloat = Space.s8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = arrange(subviews, width: proposal.width ?? .infinity)
        return CGSize(width: proposal.width ?? rows.width, height: rows.height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = arrange(subviews, width: bounds.width)
        for (index, point) in rows.origins.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + point.x, y: bounds.minY + point.y), proposal: .unspecified)
        }
    }

    private func arrange(_ subviews: Subviews, width: CGFloat) -> (origins: [CGPoint], width: CGFloat, height: CGFloat) {
        var origins: [CGPoint] = []
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0, maxX: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > 0, x + size.width > width {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            origins.append(CGPoint(x: x, y: y))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            maxX = max(maxX, x - spacing)
        }
        return (origins, maxX, y + rowHeight)
    }
}

#Preview {
    NavigationStack { DesignSystemGalleryView() }
        .environment(ToastCenter())
        .toastHost()
}
