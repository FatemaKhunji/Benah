// BenahApp.swift
// The entry point: iOS starts the app here.
//
// 📘 Learning note
// `@main` marks where the app begins. `body` returns the first window (a Scene).
// We set up Firebase (or sample data), create the shared objects once, and pass
// them down to every screen with `.environment(...)`.

import SwiftUI

@main
struct BenahApp: App {
    @State private var session: AppSession
    @State private var toasts = ToastCenter()

    init() {
        let backend = AppEnvironment.configure()
        _session = State(initialValue: AppSession.make(for: backend))
    }

    var body: some Scene {
        WindowGroup {
            // Order matters: `.toastHost()` must come BEFORE `.environment(toasts)`.
            // An environment value only reaches modifiers written above it (inside it).
            RootView()
                .toastHost()
                .environment(session)
                .environment(toasts)
                .task { await session.restore() }
        }
    }
}
