// SelectionControls.swift
// The Figma "Toggle", "Checkbox" and "Radio" components.
//
//   Toggle("Notifications", isOn: $notificationsOn).toggleStyle(.benah)
//   CheckboxView(isChecked: $agreed)
//   RadioView(isSelected: method == .applePay)

import SwiftUI

// MARK: - Toggle

struct BenahToggleStyle: ToggleStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer(minLength: Space.s12)
            Capsule()
                .fill(configuration.isOn ? Color.benah.brandNavy : Color.benah.borderStrong)
                .frame(width: 51, height: 31)
                .overlay(alignment: configuration.isOn ? .trailing : .leading) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 27, height: 27)
                        .padding(2)
                        .shadow(color: .black.opacity(0.15), radius: 2, y: 1)
                }
                // Handoff: toggles slide 200 ms.
                .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: configuration.isOn)
                .onTapGesture { configuration.isOn.toggle() }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
        .accessibilityValue(configuration.isOn ? "On" : "Off")
        .accessibilityAction { configuration.isOn.toggle() }
    }
}

extension ToggleStyle where Self == BenahToggleStyle {
    static var benah: BenahToggleStyle { BenahToggleStyle() }
}

// MARK: - Checkbox

struct CheckboxView: View {
    @Binding var isChecked: Bool

    var body: some View {
        Button { isChecked.toggle() } label: {
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .fill(isChecked ? Color.benah.brandNavy : Color.benah.bgSurface)
                .overlay {
                    if isChecked {
                        BenahIconView(.check, size: 16).foregroundStyle(Color.benah.textOnBrand)
                    } else {
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .strokeBorder(Color.benah.borderStrong, lineWidth: 1.5)
                    }
                }
                .frame(width: 24, height: 24)
                .frame(width: 44, height: 44) // minimum tap target
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Checkbox")
        .accessibilityValue(isChecked ? "Checked" : "Not checked")
    }
}

// MARK: - Radio

/// Visual only: wrap it in a Button / row that sets the selection.
struct RadioView: View {
    let isSelected: Bool

    var body: some View {
        Circle()
            .strokeBorder(isSelected ? Color.benah.brandNavy : Color.benah.borderStrong,
                          lineWidth: isSelected ? 7 : 1.5)
            .background(Circle().fill(Color.benah.bgSurface))
            .frame(width: 24, height: 24)
            .animation(.easeOut(duration: 0.15), value: isSelected)
            .accessibilityHidden(true)
    }
}

#Preview {
    struct Demo: View {
        @State var on = true
        @State var checked = false
        @State var choice = 0
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Toggle("Notifications", isOn: $on).toggleStyle(.benah)
                CheckboxView(isChecked: $checked)
                ForEach(0..<2) { i in
                    Button { choice = i } label: {
                        HStack { RadioView(isSelected: choice == i); Text("Option \(i + 1)") }
                    }.buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
    return Demo()
}
