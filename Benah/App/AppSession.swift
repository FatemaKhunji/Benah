// AppSession.swift
// The shared state of the whole app: which backend we use, who is signed in, and
// their profile.
//
// 📘 Learning note: @Observable
// `@Observable` (iOS 17) makes SwiftUI watch this object. When `currentUser`
// changes, every screen that reads `session.currentUser` redraws by itself.
// We create ONE AppSession in BenahApp and hand it to every screen with
// `.environment(session)`. A screen gets it back with:
//
//   @Environment(AppSession.self) private var session

import Foundation
import Observation

@Observable
@MainActor
final class AppSession {
    enum State: Equatable {
        case loading
        case signedOut
        case signedIn
    }

    let backend: Backend
    let store: DataStore
    let auth: AuthService

    private(set) var state: State = .loading
    private(set) var currentUser: AppUser?
    var lastError: String?

    init(backend: Backend, store: DataStore, auth: AuthService) {
        self.backend = backend
        self.store = store
        self.auth = auth
    }

    /// Builds the right session for the chosen backend.
    static func make(for backend: Backend) -> AppSession {
        switch backend {
        case .firebase:
            AppSession(backend: .firebase, store: FirestoreDataStore(), auth: FirebaseAuthService())
        case .sample:
            AppSession(backend: .sample, store: SampleDataStore(), auth: SampleAuthService())
        }
    }

    /// A session with sample data, signed in as Fatima. Use it in #Preview.
    static var preview: AppSession {
        let session = AppSession(backend: .sample, store: SampleDataStore(), auth: SampleAuthService())
        session.currentUser = SampleData.fatima
        session.state = .signedIn
        return session
    }

    // MARK: - Lifecycle

    /// Called when the app starts: are we already signed in from last time?
    func restore() async {
        guard let uid = auth.currentUserId else {
            state = .signedOut
            return
        }
        await loadProfile(uid: uid)
    }

    /// After a successful code check. Loads the profile, or marks the user as new
    /// (the account feature then shows the registration form).
    func didSignIn(uid: String) async {
        await loadProfile(uid: uid)
    }

    /// Creates or updates the signed-in user's profile document.
    func saveProfile(_ user: AppUser) async throws {
        try await store.set(user, at: FirestorePath.user(user.id))
        currentUser = user
        state = .signedIn
    }

    func signOut() {
        do {
            try auth.signOut()
        } catch {
            lastError = error.localizedDescription
        }
        currentUser = nil
        state = .signedOut
    }

    private func loadProfile(uid: String) async {
        do {
            currentUser = try await store.get(AppUser.self, at: FirestorePath.user(uid))
        } catch {
            lastError = error.localizedDescription
            currentUser = nil
        }
        // Signed in but no profile yet = brand-new user (Register screen will handle it).
        state = .signedIn
    }

    /// The signed-in user id, if any.
    var userId: String? { auth.currentUserId }
}
