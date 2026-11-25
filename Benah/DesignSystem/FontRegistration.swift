// FontRegistration.swift
// Makes our custom .ttf fonts available to the app.
//
// 📘 Learning note
// iOS only knows its built-in fonts. Custom fonts must be "registered" once when
// the app starts. The usual way is listing them in Info.plist; we do it in code
// instead because it is easier to see and does not need any Info.plist editing.

import CoreText
import Foundation

enum FontRegistration {
    private static var didRegister = false

    /// Call once at app launch (BenahApp does this).
    static func registerBundledFonts() {
        guard !didRegister else { return }
        didRegister = true

        let fontURLs = Bundle.main.urls(forResourcesWithExtension: "ttf", subdirectory: nil) ?? []
        for url in fontURLs {
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error) {
                // Not fatal: the system font is used instead. Printed so you notice in Xcode.
                print("⚠️ Could not register font \(url.lastPathComponent): \(String(describing: error?.takeRetainedValue()))")
            }
        }
        #if DEBUG
        if fontURLs.isEmpty { print("⚠️ No .ttf files found in the app bundle. Check Resources/Fonts.") }
        #endif
    }
}
