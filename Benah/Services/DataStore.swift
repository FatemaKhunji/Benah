// DataStore.swift
//
// 📘 Learning note: what is this file?
// The screens need to save and load data, but they should NOT care whether the
// data lives in Firebase or in sample data inside the app. So we describe what a
// data store can do in a `protocol` (a list of required functions), and write two
// versions of it:
//
//   • FirestoreDataStore: the real backend (Firebase Cloud Firestore)
//   • SampleDataStore: in memory, filled with the Figma sample people and groups
//
// The app picks one at launch (see AppEnvironment.swift). Screens only ever talk
// to `DataStore`, so they work with both.
//
// Firestore organises data like folders and files:
//   collection "users"  →  document "abc123"  →  fields { firstName: "Fatima", … }
// A *path* is just the address: "users/abc123", "users/abc123/people/p1".

import Foundation

protocol DataStore: AnyObject, Sendable {
    /// Read one document, or nil if it doesn't exist.
    func get<T: Codable & Sendable>(_ type: T.Type, at path: String) async throws -> T?

    /// Create or replace one document.
    func set<T: Codable & Sendable>(_ value: T, at path: String) async throws

    /// Delete one document.
    func delete(at path: String) async throws

    /// Read every document in a collection, optionally only those where the array
    /// field `field` contains `value` (e.g. jamiyas where memberIds contains my id).
    func list<T: Codable & Sendable>(_ type: T.Type, in collection: String,
                                     whereArray field: String?, contains value: String?) async throws -> [T]

    /// Like `list`, but keeps sending a fresh array every time the data changes.
    /// Use it with `for try await items in store.listen(…)` in a `.task { }`.
    func listen<T: Codable & Sendable>(_ type: T.Type, in collection: String,
                                       whereArray field: String?, contains value: String?) -> AsyncThrowingStream<[T], Error>

    /// A new random id for a document you are about to create.
    func newId() -> String
}

extension DataStore {
    func list<T: Codable & Sendable>(_ type: T.Type, in collection: String) async throws -> [T] {
        try await list(type, in: collection, whereArray: nil, contains: nil)
    }

    func listen<T: Codable & Sendable>(_ type: T.Type, in collection: String) -> AsyncThrowingStream<[T], Error> {
        listen(type, in: collection, whereArray: nil, contains: nil)
    }

    func newId() -> String {
        UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(20).lowercased()
    }
}

/// Every Firestore address in one place, so a typo can't create a stray collection.
enum FirestorePath {
    static let users = "users"
    static func user(_ id: String) -> String { "users/\(id)" }
    static func people(of userId: String) -> String { "users/\(userId)/people" }
    static func savedGroups(of userId: String) -> String { "users/\(userId)/savedGroups" }
    static func notifications(of userId: String) -> String { "users/\(userId)/notifications" }

    static let jamiyas = "jamiyas"
    static func swapRequests(of jamiyaId: String) -> String { "jamiyas/\(jamiyaId)/swapRequests" }
    static let lammahs = "lammahs"
    static let qattahs = "qattahs"
    static let joinRequests = "joinRequests"
    static let payments = "payments"
    static let reports = "reports"
    static let admins = "admins"
}
