// Money.swift
//
// 📘 Learning note: why money is stored as an Int of "fils"
// 1 Bahraini dinar (BHD) = 1000 fils. Computers store decimals like 0.1 slightly
// wrong (try 0.1 + 0.2 in any language). For money that means a split bill can be
// off by a fils. So we store whole fils as an Int: BHD 10.000 is stored as 10000.
// We only turn it into "BHD 10.000" when showing it on screen.

import Foundation

struct Money: Codable, Hashable, Comparable, Sendable {
    var fils: Int

    init(fils: Int) { self.fils = fils }
    init(dinars: Int) { self.fils = dinars * 1000 }

    static let zero = Money(fils: 0)

    static func + (a: Money, b: Money) -> Money { Money(fils: a.fils + b.fils) }
    static func - (a: Money, b: Money) -> Money { Money(fils: a.fils - b.fils) }
    static func * (a: Money, n: Int) -> Money { Money(fils: a.fils * n) }
    static func < (a: Money, b: Money) -> Bool { a.fils < b.fils }

    /// Splits an amount into `parts` shares that add up exactly to the total.
    /// The first shares get the leftover fils, so 10.000 / 3 = 3.334 + 3.333 + 3.333.
    func split(into parts: Int) -> [Money] {
        guard parts > 0 else { return [] }
        let base = fils / parts
        let remainder = fils % parts
        return (0..<parts).map { Money(fils: base + ($0 < remainder ? 1 : 0)) }
    }

    /// "BHD 10.000" in English, "10.000 د.ب" in Arabic (as in the Figma RTL screens).
    func formatted(arabic: Bool = false) -> String {
        let sign = fils < 0 ? "-" : ""
        let value = abs(fils)
        let number = "\(value / 1000).\(String(format: "%03ld", value % 1000))"
        return arabic ? "\(sign)\(number) د.ب" : "\(sign)BHD \(number)"
    }

    // Stored in Firestore as a plain number of fils, e.g. 10000.
    init(from decoder: Decoder) throws {
        fils = try decoder.singleValueContainer().decode(Int.self)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(fils)
    }
}

extension Money: CustomStringConvertible {
    var description: String { formatted() }
}
