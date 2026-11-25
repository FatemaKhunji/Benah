// AppEnvironment.swift
// Decides at launch whether the app talks to Firebase or uses sample data.
//
// 📘 Learning note
// Firebase needs a settings file, GoogleService-Info.plist, downloaded from the
// Firebase console. We deliberately keep that file OUT of GitHub (.gitignore),
// so each developer drops their own copy into the Benah/ folder.
//   • File present  → real Firebase backend
//   • File missing  → sample data, so the app still runs (handy for UI work)

import Foundation
import FirebaseCore

enum Backend: String {
    case firebase = "Firebase"
    case sample = "Sample data"
}

enum AppEnvironment {
    /// True when GoogleService-Info.plist is inside the app.
    static var hasFirebaseConfig: Bool {
        Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil
    }

    /// Call once at launch. Returns which backend the app will use.
    static func configure() -> Backend {
        FontRegistration.registerBundledFonts()
        guard hasFirebaseConfig else {
            print("ℹ️ GoogleService-Info.plist not found: running with SAMPLE DATA.")
            return .sample
        }
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        return .firebase
    }

    /// True inside Xcode's preview canvas (never use Firebase there).
    static var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
