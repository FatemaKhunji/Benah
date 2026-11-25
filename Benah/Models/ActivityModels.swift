// ActivityModels.swift
// Things that happen around the groups: notifications, payments and reports.
//
// Firestore paths:
//   users/{userId}/notifications/{id} → AppNotification
//   payments/{id}                     → PaymentRecord
//   reports/{id}                      → Report
//   admins/{userId}                   → (exists = this user is staff)

import Foundation

struct AppNotification: Codable, Identifiable, Hashable, Sendable {
    enum Kind: String, Codable, Sendable {
        case joinRequest, requestApproved, requestDeclined, invitation, invitationDeclined
        case paymentDue, paymentReceived, reminder
        case swapRequest, swapAccepted, swapDeclined
        case voteOpen, voteResults, planConfirmed
        case accountLimited, accountRestored, general
    }

    var id: String
    var kind: Kind
    /// nil for account-level notifications.
    var module: Module?
    var title: String
    var body: String
    var groupId: String?
    /// e.g. the joinRequest id this notification is about.
    var referenceId: String?
    var isRead: Bool = false
    var createdAt: Date = .now
}

/// A payment. Payments are SIMULATED: no real money moves (see README).
/// It is still saved, so everyone in the group sees who has paid.
struct PaymentRecord: Codable, Identifiable, Hashable, Sendable {
    enum Method: String, Codable, CaseIterable, Sendable { case applePay, benefitPay, card }
    enum Status: String, Codable, Sendable { case processing, succeeded, failed }

    var id: String
    var payerId: String
    var amount: Money
    var method: Method
    var module: Module
    var groupId: String
    /// Jam'iya round number, if relevant.
    var round: Int?
    var status: Status = .processing
    var createdAt: Date = .now
}

/// "Report a problem" from the group menu, handled by an administrator.
struct Report: Codable, Identifiable, Hashable, Sendable {
    enum Status: String, Codable, Sendable { case open, resolved }
    enum Outcome: String, Codable, Sendable {
        /// "No action needed"
        case noAction
        /// "Send a warning"
        case warning
        /// "Escalate / restrict account"
        case restrict
    }

    var id: String
    var reporterId: String
    var reporterName: String
    var module: Module?
    var groupId: String?
    var groupName: String?
    /// The member the report is about (if any).
    var aboutUserId: String?
    var aboutName: String?
    var reason: String
    var details: String = ""
    var status: Status = .open
    var outcome: Outcome?
    var adminNote: String?
    var createdAt: Date = .now
    var resolvedAt: Date?
}
