// JamiyaModels.swift
// Jam'iya = a rotating savings group. Every member pays the same amount each
// month; each month one member (in turn order) receives the whole pot.
//
// Firestore paths:
//   jamiyas/{jamiyaId}                         → Jamiya
//   jamiyas/{jamiyaId}/swapRequests/{id}       → SwapRequest
//   joinRequests/{id}                          → JoinRequest (shared with Lammah/Qattah)

import Foundation

struct Jamiya: Codable, Identifiable, Hashable, Sendable {
    enum Status: String, Codable, Sendable {
        /// Created, inviting people, choosing turns.
        case waiting
        /// Rounds are running.
        case active
        case completed
    }

    var id: String
    var name: String
    var description: String = ""
    var hostId: String
    /// Everyone in the group, host included. Used by queries ("my Jam'iyas").
    var memberIds: [String]
    var memberCount: Int
    var monthlyContribution: Money
    var status: Status = .waiting
    /// 6-character code people type to join, e.g. "FAM482".
    var joinCode: String
    var startDate: Date?
    /// Turn order: userId → turn number (1 = receives the pot first).
    var turns: [String: Int] = [:]
    /// 1-based round currently running (only when active).
    var currentRound: Int = 0
    /// Payments for the current round: userId → true when paid.
    var paidThisRound: [String: Bool] = [:]
    var createdAt: Date = .now

    /// The pot one member receives each month.
    var payout: Money { monthlyContribution * memberCount }

    /// Who receives the pot in the given round.
    func recipient(ofRound round: Int) -> String? {
        turns.first { $0.value == round }?.key
    }

    var isFull: Bool { memberIds.count >= memberCount }
}

struct SwapRequest: Codable, Identifiable, Hashable, Sendable {
    enum Kind: String, Codable, Sendable {
        /// Swap with one chosen member.
        case direct
        /// Ask several members; the first who accepts swaps.
        case group
    }
    enum Status: String, Codable, Sendable { case pending, accepted, declined, cancelled }

    var id: String
    var fromUserId: String
    var toUserIds: [String]
    var kind: Kind
    var status: Status = .pending
    var acceptedBy: String?
    var createdAt: Date = .now
}

/// Someone asking to join a Jam'iya / Lammah / Qattah with a code.
struct JoinRequest: Codable, Identifiable, Hashable, Sendable {
    enum Status: String, Codable, Sendable { case pending, approved, declined }

    var id: String
    var module: Module
    var groupId: String
    var groupName: String
    var hostId: String
    var requesterId: String
    var requesterName: String
    var status: Status = .pending
    var createdAt: Date = .now
}
