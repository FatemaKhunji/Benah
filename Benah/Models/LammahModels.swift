// LammahModels.swift
// Lammah = planning a gathering. The organiser either picks dates first
// (members mark availability, then vote) or a place first (vote on venue slots).
//
// Firestore path:
//   lammahs/{lammahId} → Lammah

import Foundation

struct Lammah: Codable, Identifiable, Hashable, Sendable {
    enum PlanningApproach: String, Codable, Sendable { case dateFirst, placeFirst }

    enum Stage: String, Codable, Sendable {
        /// Members are marking which of the candidate days they are free.
        case collectingAvailability
        /// Voting on the best date options.
        case dateVote
        /// Voting on a venue.
        case venueVote
        /// Date and place fixed.
        case confirmed
        case completed
    }

    var id: String
    var title: String
    var hostId: String
    var participantIds: [String]
    var approach: PlanningApproach
    var stage: Stage = .collectingAvailability
    var joinCode: String
    /// The days the organiser offered (members can only mark these).
    var candidateDates: [Date] = []
    /// userId → the days that member is free.
    var availability: [String: [Date]] = [:]
    /// userId → chosen date option (for the date vote).
    var dateVotes: [String: Date] = [:]
    var venues: [Venue] = []
    /// userId → venue id (for the venue vote).
    var venueVotes: [String: String] = [:]
    var confirmedDate: Date?
    var confirmedVenueId: String?
    /// userId → number of children coming (AttendanceChildren screen).
    var childrenCount: [String: Int] = [:]
    var optionalCosts: [CostItem] = []
    /// Qattah created to collect the costs, if any (LinkedLammahQattah).
    var linkedQattahId: String?
    var createdAt: Date = .now

    var confirmedVenue: Venue? { venues.first { $0.id == confirmedVenueId } }
}

struct Venue: Codable, Identifiable, Hashable, Sendable {
    var id: String
    var name: String
    var area: String
    var notes: String = ""
    var suggestedBy: String
    /// Optional cost per person for this place.
    var costPerPerson: Money?
}

struct CostItem: Codable, Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var amount: Money
    /// true = everyone pays a share; false = only those who opt in.
    var isShared: Bool = true
    var optedIn: [String] = []
}
