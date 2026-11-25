// NotificationBell.swift
// The single "Notification bell" component used on every Home screen:
// a 44 pt round button with a red unread-count badge.
//
//   NotificationBell(unreadCount: 5) { openNotifications() }

import SwiftUI

struct NotificationBell: View {
    let unreadCount: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            BenahIconView(.bell, size: 22)
                .foregroundStyle(Color.benah.textPrimary)
                .frame(width: 44, height: 44)
                .background(Color.benah.bgSurface, in: Circle())
                .overlay(alignment: .topTrailing) {
                    if unreadCount > 0 {
                        Text(unreadCount > 9 ? "9+" : "\(unreadCount)")
                            .benahFont(.labelS)
                            .foregroundStyle(Color.benah.textOnBrand)
                            .padding(.horizontal, 6)
                            .frame(minWidth: 20, minHeight: 20)
                            .background(Color.benah.danger, in: Capsule())
                            .offset(x: 4, y: -4)
                    }
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Notifications")
        .accessibilityValue(unreadCount > 0 ? "\(unreadCount) unread" : "No unread")
    }
}

#Preview {
    HStack(spacing: 24) {
        NotificationBell(unreadCount: 5) {}
        NotificationBell(unreadCount: 0) {}
    }
    .padding()
    .background(Color.benah.bgCanvas)
}
