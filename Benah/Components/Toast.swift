// Toast.swift
// The Figma "Toast" component: a dark pill message that slides in from the top
// ("Link copied", "Reminder sent to Ahmed and Noor", …).
//
// 📘 Learning note
// Any screen can show a toast without knowing how toasts work:
//
//   @Environment(ToastCenter.self) private var toasts
//   …
//   toasts.show("Link copied", tone: .success)
//
// `ToastCenter` is created once in BenahApp and shared with every screen through
// the SwiftUI "environment". `.toastHost()` on the root view draws the toast.
//
// Handoff spec: slide from top 250 ms, auto-hide after 1.6 s.
// With Reduce Motion on: appear in place, stay 4 s, and VoiceOver announces it.

import SwiftUI
import UIKit
import Observation

struct ToastMessage: Identifiable, Equatable {
    enum Tone { case success, info, danger }
    let id = UUID()
    let text: String
    let tone: Tone
}

@Observable
@MainActor
final class ToastCenter {
    private(set) var current: ToastMessage?
    private var hideTask: Task<Void, Never>?

    func show(_ text: String, tone: ToastMessage.Tone = .success, reduceMotion: Bool = false) {
        let message = ToastMessage(text: text, tone: tone)
        current = message
        UIAccessibility.post(notification: .announcement, argument: text)

        hideTask?.cancel()
        hideTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(reduceMotion ? 4 : 1.6))
            guard !Task.isCancelled, self?.current == message else { return }
            self?.current = nil
        }
    }

    func dismiss() { current = nil }
}

struct ToastView: View {
    let message: ToastMessage

    private var icon: BenahIcon {
        switch message.tone {
        case .success: .check
        case .info: .info
        case .danger: .alert
        }
    }

    // Icon colours are fixed light tints so they read well on the dark pill.
    private var iconColor: Color {
        switch message.tone {
        case .success: Color(uiColor: UIColor(hex: 0x7ED3A6))
        case .info: Color(uiColor: UIColor(hex: 0xA9B9F0))
        case .danger: Color(uiColor: UIColor(hex: 0xF2A49D))
        }
    }

    var body: some View {
        HStack(spacing: 10) {
            BenahIconView(icon, size: 20).foregroundStyle(iconColor)
            Text(message.text)
                .benahFont(.bodyMStrong)
                .foregroundStyle(Color.benah.textOnBrand)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, Space.s16)
        .padding(.vertical, 14)
        .background(Color.benah.bgInverse, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .elevation(.raised)
        .padding(.horizontal, Space.s16)
        .accessibilityElement(children: .combine)
    }
}

private struct ToastHostModifier: ViewModifier {
    @Environment(ToastCenter.self) private var toasts
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content.overlay(alignment: .top) {
            if let message = toasts.current {
                ToastView(message: message)
                    .padding(.top, Space.s8)
                    .transition(reduceMotion ? .opacity : .move(edge: .top).combined(with: .opacity))
                    .onTapGesture { toasts.dismiss() }
                    .id(message.id)
            }
        }
        .animation(.easeOut(duration: 0.25), value: toasts.current)
    }
}

extension View {
    /// Put this once on the root view so toasts can appear above every screen.
    func toastHost() -> some View { modifier(ToastHostModifier()) }
}

#Preview {
    VStack(spacing: 12) {
        ToastView(message: .init(text: "Reminder sent to Ahmed and Noor", tone: .success))
        ToastView(message: .init(text: "Link copied", tone: .info))
        ToastView(message: .init(text: "Payment failed. Try again", tone: .danger))
    }
}
