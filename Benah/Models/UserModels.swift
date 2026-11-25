// UserModels.swift
// Data about people: the signed-in user, "Your people", and saved groups.
//
// 📘 Learning note
// These are plain Swift structs. `Codable` lets them be turned into a dictionary
// for Firestore and back again automatically. They don't import Firebase at all,
// so the same structs also work with the built-in sample data.
//
// Firestore paths (see docs/ARCHITECTURE.md):
//   users/{userId}                       → AppUser
//   users/{userId}/people/{personId}     → Person        ("Your people")
//   users/{userId}/savedGroups/{groupId} → SavedGroup

import Foundation

struct AppUser: Codable, Identifiable, Hashable, Sendable {
    enum Role: String, Codable, Sendable { case member, admin }
    /// "limited" = restricted by an administrator (the Khalid flow).
    enum AccountStatus: String, Codable, Sendable { case active, limited }
    enum Language: String, Codable, Sendable { case english = "en", arabic = "ar" }

    var id: String
    var firstName: String
    var surname: String
    /// Local Bahrain number without +973, e.g. "36123456".
    var phone: String
    var email: String?
    var isEmailVerified: Bool = false
    var language: Language = .english
    var notificationsEnabled: Bool = true
    var role: Role = .member
    var status: AccountStatus = .active
    var createdAt: Date = .now

    var fullName: String { "\(firstName) \(surname)" }
    var initials: String { fullName.initials }
    var isLimited: Bool { status == .limited }
}

/// Someone in "Your people". `userId` is set when that person has a Benah account.
struct Person: Codable, Identifiable, Hashable, Sendable {
    var id: String
    var name: String
    var phone: String?
    var userId: String?
    /// Extra line under the name, e.g. "Cousin" or "Office".
    var detail: String?

    var initials: String { name.initials }
}

/// A named collection of people, e.g. "Ahmed family (6 people)".
struct SavedGroup: Codable, Identifiable, Hashable, Sendable {
    var id: String
    var name: String
    var personIds: [String]
    var createdAt: Date = .now
}
