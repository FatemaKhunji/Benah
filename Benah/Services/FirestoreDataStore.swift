// FirestoreDataStore.swift
// The real backend: reads and writes Cloud Firestore.
//
// 📘 Learning note
// • `Firestore.Encoder` turns our Codable structs into a dictionary Firestore
//   understands (Date → Timestamp, Money → number of fils).
// • `Firestore.Decoder` does the reverse.
// • The document id is not stored inside the document by Firestore, so after
//   reading we copy `document.documentID` into the "id" field ourselves.
// • Security: who may read or write what is decided by the rules in
//   firebase/firestore.rules, not by this file. The app can *try* anything,
//   and the server refuses what the rules don't allow.

import Foundation
import FirebaseFirestore

final class FirestoreDataStore: DataStore, @unchecked Sendable {
    private let db: Firestore

    init(db: Firestore = Firestore.firestore()) {
        self.db = db
    }

    func get<T: Codable & Sendable>(_ type: T.Type, at path: String) async throws -> T? {
        let snapshot = try await db.document(path).getDocument()
        guard snapshot.exists else { return nil }
        return try decode(type, from: snapshot)
    }

    func set<T: Codable & Sendable>(_ value: T, at path: String) async throws {
        let data = try Firestore.Encoder().encode(value)
        try await db.document(path).setData(data)
    }

    func delete(at path: String) async throws {
        try await db.document(path).delete()
    }

    func list<T: Codable & Sendable>(_ type: T.Type, in collection: String,
                                     whereArray field: String?, contains value: String?) async throws -> [T] {
        let snapshot = try await query(collection, field, value).getDocuments()
        return snapshot.documents.compactMap { try? decode(type, from: $0) }
    }

    func listen<T: Codable & Sendable>(_ type: T.Type, in collection: String,
                                       whereArray field: String?, contains value: String?) -> AsyncThrowingStream<[T], Error> {
        AsyncThrowingStream { continuation in
            let registration = query(collection, field, value).addSnapshotListener { [weak self] snapshot, error in
                if let error {
                    continuation.finish(throwing: error)
                    return
                }
                guard let self, let snapshot else { return }
                continuation.yield(snapshot.documents.compactMap { try? self.decode(type, from: $0) })
            }
            // Stop listening when the screen goes away (the `.task` is cancelled).
            continuation.onTermination = { _ in registration.remove() }
        }
    }

    func newId() -> String {
        db.collection("_").document().documentID
    }

    // MARK: - Helpers

    private func query(_ collection: String, _ field: String?, _ value: String?) -> Query {
        let ref = db.collection(collection)
        if let field, let value {
            return ref.whereField(field, arrayContains: value)
        }
        return ref
    }

    private func decode<T: Decodable>(_ type: T.Type, from snapshot: DocumentSnapshot) throws -> T {
        var data = snapshot.data() ?? [:]
        data["id"] = snapshot.documentID
        return try Firestore.Decoder().decode(type, from: data)
    }
}
