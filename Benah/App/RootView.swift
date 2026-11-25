// RootView.swift
// Chooses the first screen based on whether someone is signed in.
//
// FOUNDATION NOTE: the real Splash → Onboarding → Welcome → Log in flow is built in
// the `feature/launch-onboarding` and `feature/account-profile` branches.
// For now:
//   • loading    → the logo
//   • signed in  → the main tabs
//   • signed out → a temporary screen that opens the main tabs and the Backend check

import SwiftUI

struct RootView: View {
    @Environment(AppSession.self) private var session

    var body: some View {
        Group {
            switch session.state {
            case .loading:
                BenahLogo(size: 120)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .benahScreenBackground()
            case .signedIn:
                MainTabView()
            case .signedOut:
                FoundationSignedOutView()
            }
        }
        .animation(.easeInOut(duration: 0.2), value: session.state)
    }
}

/// Temporary until the account feature adds the real Welcome / Log in screens.
private struct FoundationSignedOutView: View {
    @State private var showGallery = false
    @State private var showBackendCheck = false

    var body: some View {
        VStack(spacing: Space.s24) {
            Spacer()
            BenahLogoLockup()
            Text("Foundation build. The sign-in screens arrive in the account feature.")
                .benahFont(.bodyM)
                .foregroundStyle(Color.benah.textSecondary)
                .multilineTextAlignment(.center)
            Spacer()
            Button("Open design system") { showGallery = true }
                .buttonStyle(.benah(.primary))
            Button("Backend check") { showBackendCheck = true }
                .buttonStyle(.benah(.secondary))
        }
        .padding(Space.s20)
        .benahScreenBackground()
        .sheet(isPresented: $showGallery) { NavigationStack { DesignSystemGalleryView() } }
        .sheet(isPresented: $showBackendCheck) { NavigationStack { BackendCheckView() } }
    }
}

#Preview {
    RootView()
        .environment(AppSession.preview)
        .environment(ToastCenter())
}
