// BenahChip.swift
// The Figma "Chip" component: a selectable pill (filters, options, days).
// Selected = navy fill with a check mark. Default = white with a grey border.
//
//   BenahChip("Monthly", isSelected: frequency == .monthly) { frequency = .monthly }

import SwiftUI

struct BenahChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(_ title: String, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if isSelected {
                    BenahIconView(.check, size: 16)
                        .transition(.scale.combined(with: .opacity))
                }
                Text(title).benahFont(.labelM)
            }
            .foregroundStyle(isSelected ? Color.benah.textOnBrand : Color.benah.textPrimary)
            .padding(.horizontal, 14)
            .frame(height: 36)
            .background(isSelected ? Color.benah.brandNavySolid : Color.benah.bgSurface, in: Capsule())
            .overlay {
                Capsule().strokeBorder(isSelected ? Color.clear : Color.benah.borderStrong, lineWidth: 1)
            }
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .animation(reduceMotion ? nil : .easeOut(duration: 0.2), value: isSelected)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    struct Demo: View {
        @State var selected = "Fri"
        var body: some View {
            HStack {
                ForEach(["Thu", "Fri", "Sat"], id: \.self) { day in
                    BenahChip(day, isSelected: selected == day) { selected = day }
                }
            }
            .padding()
        }
    }
    return Demo()
}
