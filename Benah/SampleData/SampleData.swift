// SampleData.swift
// The people and groups from the Figma prototype, used when Firebase is not set
// up and in SwiftUI previews. Names and numbers are fictional (see Figma Read Me).
//
// Sample login (same as the prototype):
//   Fatima Ahmed   +973 3912 3456   code 482915
//   Khalid Nasser  +973 3301 2210   code 482915   (demo account for admin restrictions)

import Foundation

enum SampleData {
    static let otpCode = "482915"

    // MARK: Users

    static let fatima = AppUser(id: "u_fatima", firstName: "Fatima", surname: "Ahmed",
                                phone: "39123456", email: "fatima.ahmed@example.com", isEmailVerified: true)
    static let khalid = AppUser(id: "u_khalid", firstName: "Khalid", surname: "Nasser", phone: "33012210")

    /// Other members, as listed in the Figma "yourPeople/…" variables.
    static let members: [AppUser] = [
        ("u_ahmed", "Ahmed", "Saleh"), ("u_ali", "Ali", "Mansoor"), ("u_hasan", "Hasan", "Jaffar"),
        ("u_huda", "Huda", "Kamal"), ("u_layla", "Layla", "Hasan"), ("u_maryam", "Maryam", "Ali"),
        ("u_mohammed", "Mohammed", "Khalaf"), ("u_mona", "Mona", "Jasim"), ("u_noor", "Noor", "Abdulla"),
        ("u_omar", "Omar", "Khalil"), ("u_sara", "Sara", "Mohammed"), ("u_yousif", "Yousif", "Al-Mahroos"),
        ("u_zainab", "Zainab", "Isa"),
    ].enumerated().map { index, item in
        AppUser(id: item.0, firstName: item.1, surname: item.2, phone: "3600\(String(format: "%04ld", index + 1))")
    }

    static var allUsers: [AppUser] { [fatima, khalid] + members }

    static func user(_ id: String) -> AppUser? { allUsers.first { $0.id == id } }

    // MARK: Dates

    private static func days(_ n: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: n, to: Calendar.current.startOfDay(for: .now)) ?? .now
    }

    // MARK: Groups

    static let familyCircle = Jamiya(
        id: "j_family", name: "Family Circle", description: "Monthly family savings",
        hostId: fatima.id,
        memberIds: [fatima.id, "u_ahmed", "u_ali", "u_noor", "u_zainab"],
        memberCount: 5, monthlyContribution: Money(dinars: 50), status: .active, joinCode: "FAM482",
        startDate: days(-10),
        turns: [fatima.id: 3, "u_ahmed": 1, "u_ali": 2, "u_noor": 4, "u_zainab": 5],
        currentRound: 1, paidThisRound: ["u_noor": true, "u_zainab": true]
    )

    static let officeCircle = Jamiya(
        id: "j_office", name: "Office Circle", description: "Colleagues saving together",
        hostId: "u_hasan", memberIds: ["u_hasan", fatima.id, "u_maryam", "u_omar"],
        memberCount: 6, monthlyContribution: Money(dinars: 40), status: .waiting, joinCode: "OFC731"
    )

    static let winterCamp = Lammah(
        id: "l_winter", title: "Family Winter Camp", hostId: fatima.id,
        participantIds: [fatima.id, "u_ahmed", "u_noor", "u_zainab", "u_layla"],
        approach: .dateFirst, stage: .dateVote, joinCode: "CAMP28",
        candidateDates: [days(3), days(4), days(10), days(11)]
    )

    static let padelNight = Qattah(
        id: "q_padel", title: "Weekend padel", kind: .equal, hostId: fatima.id,
        participantIds: [fatima.id, "u_ahmed", "u_noor", "u_omar"],
        total: Money(dinars: 24),
        shares: [fatima.id: Money(dinars: 6), "u_ahmed": Money(dinars: 6), "u_noor": Money(dinars: 6), "u_omar": Money(dinars: 6)],
        paid: [fatima.id: Money(dinars: 6), "u_omar": Money(dinars: 6)]
    )

    // MARK: Seeding

    static func seed(into store: SampleDataStore) {
        for user in allUsers { store.setSync(user, at: FirestorePath.user(user.id)) }

        // Fatima's "Your people"
        for member in members {
            let person = Person(id: member.id, name: member.fullName, phone: member.phone, userId: member.id)
            store.setSync(person, at: "\(FirestorePath.people(of: fatima.id))/\(person.id)")
        }
        store.setSync(SavedGroup(id: "g_ahmed", name: "Ahmed family",
                                 personIds: ["u_ahmed", "u_ali", "u_noor", "u_zainab", "u_layla", "u_mona"]),
                      at: "\(FirestorePath.savedGroups(of: fatima.id))/g_ahmed")

        store.setSync(familyCircle, at: "\(FirestorePath.jamiyas)/\(familyCircle.id)")
        store.setSync(officeCircle, at: "\(FirestorePath.jamiyas)/\(officeCircle.id)")
        store.setSync(winterCamp, at: "\(FirestorePath.lammahs)/\(winterCamp.id)")
        store.setSync(padelNight, at: "\(FirestorePath.qattahs)/\(padelNight.id)")

        let notifications: [AppNotification] = [
            AppNotification(id: "n1", kind: .joinRequest, module: .jamiya,
                            title: "Yousif Al-Mahroos wants to join Family Circle",
                            body: "Review the request to let them in.", groupId: familyCircle.id),
            AppNotification(id: "n2", kind: .invitation, module: .jamiya,
                            title: "Hasan Jaffar invited you to Office Circle",
                            body: "BHD 40.000 a month · 6 members", groupId: officeCircle.id),
            AppNotification(id: "n3", kind: .voteOpen, module: .lammah,
                            title: "Vote on a date for Family Winter Camp",
                            body: "4 dates offered", groupId: winterCamp.id),
            AppNotification(id: "n4", kind: .reminder, module: .qattah,
                            title: "Weekend padel: 2 people still to pay",
                            body: "Ahmed Saleh and Noor Abdulla", groupId: padelNight.id),
            AppNotification(id: "n5", kind: .paymentReceived, module: .jamiya,
                            title: "Zainab Isa paid round 1", body: "Family Circle", groupId: familyCircle.id,
                            isRead: true),
        ]
        for n in notifications { store.setSync(n, at: "\(FirestorePath.notifications(of: fatima.id))/\(n.id)") }

        // Khalid is staff-free; the admin account for the admin view is created in that feature.
    }
}
