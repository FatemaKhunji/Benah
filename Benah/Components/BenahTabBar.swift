// BenahTabBar.swift
// The floating "glass" tab bar at the bottom of the main screens.
// Five tabs: Home, Jam'iya, Lammah, Qattah, Profile. The active tab gets a navy-tint pill.
//
// 📘 Learning note
// We draw our own bar instead of using the system TabView bar because the design
// has a custom floating pill shape. MainTabView hides the system bar and shows this.

import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case home, jamiya, lammah, qattah, profile
    var id: String { rawValue }

    var title: LocalizedStringKey {
        switch self {
        case .home: "Home"
        case .jamiya: "Jam'iya"
        case .lammah: "Lammah"
        case .qattah: "Qattah"
        case .profile: "Profile"
        }
    }

    var icon: BenahIcon {
        switch self {
        case .home: .home
        case .jamiya: .jamiya
        case .lammah: .lammah
        case .qattah: .qattah
        case .profile: .user
        }
    }
}

struct BenahTabBar: View {
    @Binding var selection: AppTab
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                let isActive = tab == selection
                Button {
                    selection = tab
                } label: {
                    VStack(spacing: 2) {
                        BenahIconView(tab.icon, size: 22)
                        Text(tab.title).benahFont(.labelS).lineLimit(1)
                    }
                    .foregroundStyle(isActive ? Color.benah.brandNavy : Color.benah.textSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background {
                        if isActive {
                            Capsule().fill(Color.benah.brandNavyTint)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(isActive ? .isSelected : [])
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 6)
        .background {
            // "Glass": blur of what is behind + a translucent surface colour.
            ZStack {
                Capsule().fill(.ultraThinMaterial)
                Capsule().fill(Color.benah.bgGlass)
            }
        }
        .overlay { Capsule().strokeBorder(Color.benah.borderDefault, lineWidth: 1) }
        .elevation(.raised)
        .padding(.horizontal, Space.s16)
        .animation(reduceMotion ? nil : .easeOut(duration: 0.2), value: selection)
    }
}

#Preview {
    struct Demo: View {
        @State var tab: AppTab = .home
        var body: some View {
            ZStack(alignment: .bottom) {
                Color.benah.bgCanvas.ignoresSafeArea()
                BenahTabBar(selection: $tab)
            }
        }
    }
    return Demo()
}
