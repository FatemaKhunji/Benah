// QattahModels.swift
// Qattah = splitting a bill or collecting money.
// Kinds (from "NewQattah-ChooseType"):
//   • equal:     total ÷ people
//   • custom:    organiser types each person's amount (must add up to the total)
//   • target:    collect towards a goal amount, e.g. a gift
//   • flexible:  people give what they want; host decides or the group votes on use
//   • itemised:  scan a receipt, everyone picks their items
//
// Firestore path:
//   qattahs/{qattahId} → Qattah

import Foundation

struct Qattah: Codable, Identifiable, Hashable, Sendable {
    enum Kind: String, Codable, CaseIterable, Sendable { case equal, custom, target, flexible, itemised }
    enum Status: String, Codable, Sendable {
        case open
        /// Host closed the collection.
        case closed
        /// Flexible collection: group is voting on what to do with the money.
        case voting
        /// Itemised bill checked and final.
        case finalised
    }

    var id: String
    var title: String
    var kind: Kind
    var hostId: String
    var participantIds: [String]
    var status: Status = .open
    var total: Money = .zero
    /// For target collections.
    var target: Money?
    /// userId → what that person owes (equal / custom / itemised).
    var shares: [String: Money] = [:]
    /// userId → what that person has paid so far.
    var paid: [String: Money] = [:]
    /// Receipt lines for itemised bills.
    var items: [ReceiptItem] = []
    /// Options + votes for flexible collections.
    var voteOptions: [String] = []
    var votes: [String: Int] = [:]
    var linkedLammahId: String?
    var createdAt: Date = .now

    var collected: Money { paid.values.reduce(.zero, +) }

    func hasPaid(_ userId: String) -> Bool {
        guard let share = shares[userId] else { return (paid[userId] ?? .zero) > .zero }
        return (paid[userId] ?? .zero) >= share
    }

    /// For custom splits: do the shares add up to the total?
    var isBalanced: Bool { shares.values.reduce(.zero, +) == total }
}

struct ReceiptItem: Codable, Identifiable, Hashable, Sendable {
    var id: String
    var name: String
    var unitPrice: Money
    var quantity: Int = 1
    /// People who had this item; the price is shared between them.
    var claimedBy: [String] = []

    var lineTotal: Money { unitPrice * quantity }
}
