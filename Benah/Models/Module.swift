// Module.swift
// Benah has three features ("modules"). Many things (notifications, payments,
// reports, join requests) need to say which one they belong to.

import SwiftUI

enum Module: String, Codable, CaseIterable, Sendable {
    case jamiya, lammah, qattah

    var displayName: String {
        switch self {
        case .jamiya: "Jam'iya"
        case .lammah: "Lammah"
        case .qattah: "Qattah"
        }
    }

    /// One-line explanation used on onboarding and empty states.
    var tagline: String {
        switch self {
        case .jamiya: "Save together and take turns receiving the pot."
        case .lammah: "Plan a gathering: pick a date and a place everyone can make."
        case .qattah: "Split a bill or collect money for a shared cost."
        }
    }

    var color: Color {
        switch self {
        case .jamiya: Color.benah.jamiya
        case .lammah: Color.benah.lammah
        case .qattah: Color.benah.qattah
        }
    }

    var tint: Color {
        switch self {
        case .jamiya: Color.benah.jamiyaTint
        case .lammah: Color.benah.lammahTint
        case .qattah: Color.benah.qattahTint
        }
    }

    var icon: BenahIcon {
        switch self {
        case .jamiya: .jamiya
        case .lammah: .lammah
        case .qattah: .qattah
        }
    }

    var badgeTone: BadgeTone {
        switch self {
        case .jamiya: .jamiya
        case .lammah: .lammah
        case .qattah: .qattah
        }
    }
}
