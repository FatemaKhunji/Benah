// SampleDataStore.swift
// An in-memory DataStore used when Firebase is not set up yet (no
// GoogleService-Info.plist), and in SwiftUI previews.
//
// It behaves like Firestore: documents live at paths, `listen` sends updates when
// something changes. Nothing is saved: restarting the app resets the sample data.

import Foundation

final class SampleDataStore: DataStore, @unchecked Sendable {
    /// path → JSON of the document. A lock keeps it safe when used from many tasks.
    private var documents: [String: Data] = [:]
    private var listeners: [UUID: () -> Void] = [:]
    private let lock = NSLock()

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(seed: Bool = true) {
        if seed { SampleData.seed(into: self) }
    }

    // MARK: DataStore

    func get<T: Codable & Sendable>(_ type: T.Type, at path: String) async throws -> T? {
        guard let data = locked({ documents[path] }) else { return nil }
        return try decoder.decode(type, from: data)
    }

    func set<T: Codable & Sendable>(_ value: T, at path: String) async throws {
        setSync(value, at: path)
    }

    func delete(at path: String) async throws {
        locked { documents[path] = nil }
        notifyListeners()
    }

    func list<T: Codable & Sendable>(_ type: T.Type, in collection: String,
                                     whereArray field: String?, contains value: String?) async throws -> [T] {
        listSync(type, in: collection, field: field, value: value)
    }

    func listen<T: Codable & Sendable>(_ type: T.Type, in collection: String,
                                       whereArray field: String?, contains value: String?) -> AsyncThrowingStream<[T], Error> {
        AsyncThrowingStream { continuation in
            let id = UUID()
            let send = { [weak self] in
                guard let self else { return }
                continuation.yield(self.listSync(type, in: collection, field: field, value: value))
            }
            locked { listeners[id] = send }
            send() // first value straight away, like Firestore
            continuation.onTermination = { [weak self] _ in
                self?.locked { self?.listeners[id] = nil }
            }
        }
    }

    // MARK: Synchronous helpers (also used to seed the sample data)

    func setSync<T: Encodable>(_ value: T, at path: String) {
        guard let data = try? encoder.encode(value) else { return }
        locked { documents[path] = data }
        notifyListeners()
    }

    private func listSync<T: Decodable>(_ type: T.Type, in collection: String, field: String?, value: String?) -> [T] {
        let prefix = collection + "/"
        let matching: [Data] = locked {
            documents
                .filter { path, _ in
                    // Direct children only: "users/x" is in "users", "users/x/people/y" is not.
                    path.hasPrefix(prefix) && !path.dropFirst(prefix.count).contains("/")
                }
                .sorted { $0.key < $1.key }
                .map(\.value)
        }
        return matching.compactMap { data in
            if let field, let value {
                let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
                guard (json?[field] as? [String])?.contains(value) == true else { return nil }
            }
            return try? decoder.decode(type, from: data)
        }
    }

    private func notifyListeners() {
        let all = locked { Array(listeners.values) }
        all.forEach { $0() }
    }

    private func locked<R>(_ work: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return work()
    }
}
