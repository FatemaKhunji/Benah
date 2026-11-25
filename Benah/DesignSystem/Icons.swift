// Icons.swift
// One place for every icon used in the design.
//
// 📘 Learning note
// The Figma file uses 52 line icons. Almost all of them have a matching Apple
// "SF Symbol" (free, built into iOS, and they flip automatically for Arabic).
// The three module icons are custom to Benah, so we draw them from the Figma shapes.
//
// Usage:  BenahIconView(.calendar)  or  BenahIconView(.jamiya, size: 22)

import SwiftUI

enum BenahIcon: String, CaseIterable {
    // Custom Benah icons (drawn from Figma)
    case jamiya, lammah, qattah
    // Everything else maps to SF Symbols
    case chevron, back, check, calendar, users, clock, edit, lock, alert, plus, close
    case shield, info, pin, down, receipt, flag, user, more, minus, vote, logout, home
    case card, swap, share, gift, target, sliders, message, link, eye, refresh, send, ban
    case bank, sun, bell, child, trophy, scan, camera, search, wifi, flash, image
    case arrowUp, arrowDown, copy

    /// SF Symbol name for the icon (nil for the custom ones).
    var systemName: String? {
        switch self {
        case .jamiya, .lammah, .qattah: return nil
        case .chevron: return "chevron.right"
        case .back: return "chevron.left"
        case .check: return "checkmark"
        case .calendar: return "calendar"
        case .users: return "person.2"
        case .clock: return "clock"
        case .edit: return "pencil"
        case .lock: return "lock"
        case .alert: return "exclamationmark.triangle"
        case .plus: return "plus"
        case .close: return "xmark"
        case .shield: return "checkmark.shield"
        case .info: return "info.circle"
        case .pin: return "mappin.and.ellipse"
        case .down: return "chevron.down"
        case .receipt: return "doc.text"
        case .flag: return "flag"
        case .user: return "person"
        case .more: return "ellipsis"
        case .minus: return "minus"
        case .vote: return "checkmark.square"
        case .logout: return "rectangle.portrait.and.arrow.right"
        case .home: return "house"
        case .card: return "creditcard"
        case .swap: return "arrow.left.arrow.right"
        case .share: return "square.and.arrow.up"
        case .gift: return "gift"
        case .target: return "target"
        case .sliders: return "slider.horizontal.3"
        case .message: return "message"
        case .link: return "link"
        case .eye: return "eye"
        case .refresh: return "arrow.clockwise"
        case .send: return "paperplane"
        case .ban: return "nosign"
        case .bank: return "building.columns"
        case .sun: return "sun.max"
        case .bell: return "bell"
        case .child: return "figure.and.child.holdinghands"
        case .trophy: return "trophy"
        case .scan: return "doc.viewfinder"
        case .camera: return "camera"
        case .search: return "magnifyingglass"
        case .wifi: return "wifi"
        case .flash: return "bolt"
        case .image: return "photo"
        case .arrowUp: return "arrow.up"
        case .arrowDown: return "arrow.down"
        case .copy: return "doc.on.doc"
        }
    }
}

/// Draws a Benah icon at a given size, tinted with the current foreground colour.
struct BenahIconView: View {
    let icon: BenahIcon
    var size: CGFloat = 20

    init(_ icon: BenahIcon, size: CGFloat = 20) {
        self.icon = icon
        self.size = size
    }

    var body: some View {
        Group {
            switch icon {
            case .jamiya: JamiyaIconShape()
            case .lammah: LammahIconShape()
            case .qattah: QattahIconShape()
            default:
                Image(systemName: icon.systemName ?? "questionmark")
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.medium)
                    .padding(size * 0.1)
            }
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true) // icons are decoration; the label next to them is read out
    }
}

#Preview {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 16) {
        ForEach(BenahIcon.allCases, id: \.self) { icon in
            VStack(spacing: 4) {
                BenahIconView(icon, size: 22)
                Text(icon.rawValue).font(.system(size: 9))
            }
        }
    }
    .padding()
}
