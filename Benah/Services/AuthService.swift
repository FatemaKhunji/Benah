// AuthService.swift
// Signing in with a mobile number and a 6-digit code (OTP).
//
// 📘 Learning note: how phone sign-in works
//  1. The app sends the number to Firebase → Firebase answers with a
//     "verification id" (a ticket saying "a code was sent for this number").
//  2. The user types the code → the app sends ticket + code to Firebase.
//  3. If they match, Firebase signs the user in and gives them a user id (uid).
//     That uid is the key of their document: users/{uid}.
//
// 💸 Free plan: real SMS needs Firebase's paid plan, so we use Firebase "test
// phone numbers" (Console → Authentication → Sign-in method → Phone → Phone numbers
// for testing). No SMS is sent; the code is the one you typed in the console
// (482915, like the prototype).

import Foundation
import FirebaseAuth

protocol AuthService: AnyObject, Sendable {
    /// The signed-in user's id, or nil.
    var currentUserId: String? { get }
    /// Step 1: "send" a code to a Bahrain number like "39123456". Returns the verification id.
    func sendCode(toLocalNumber number: String) async throws -> String
    /// Step 2: check the code. Returns the user id.
    func verify(code: String, verificationId: String) async throws -> String
    func signOut() throws
}

enum AuthError: LocalizedError {
    case invalidCode, expiredCode, tooManyAttempts, invalidNumber, unknown(String)

    var errorDescription: String? {
        switch self {
        case .invalidCode: "That code isn't right. Check it and try again."
        case .expiredCode: "This code has expired. Ask for a new one."
        case .tooManyAttempts: "Too many attempts. Try again later."
        case .invalidNumber: "Enter a valid Bahrain mobile number."
        case .unknown(let message): message
        }
    }
}

// MARK: - Firebase

final class FirebaseAuthService: AuthService, @unchecked Sendable {
    init() {
        #if DEBUG
        // Lets Firebase *test* numbers sign in without an Apple push or reCAPTCHA check.
        // Only works with the fictional numbers you list in the Firebase console.
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        #endif
    }

    var currentUserId: String? { Auth.auth().currentUser?.uid }

    func sendCode(toLocalNumber number: String) async throws -> String {
        let digits = number.filter(\.isNumber)
        guard digits.count == 8 else { throw AuthError.invalidNumber }
        do {
            return try await PhoneAuthProvider.provider().verifyPhoneNumber("+973\(digits)", uiDelegate: nil)
        } catch {
            throw Self.map(error)
        }
    }

    func verify(code: String, verificationId: String) async throws -> String {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId,
                                                                 verificationCode: code)
        do {
            return try await Auth.auth().signIn(with: credential).user.uid
        } catch {
            throw Self.map(error)
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    /// Turns Firebase's error codes into messages from the Figma screens.
    private static func map(_ error: Error) -> AuthError {
        switch AuthErrorCode(rawValue: (error as NSError).code) {
        case .invalidVerificationCode: .invalidCode
        case .sessionExpired: .expiredCode
        case .tooManyRequests: .tooManyAttempts
        case .invalidPhoneNumber, .missingPhoneNumber: .invalidNumber
        default: .unknown(error.localizedDescription)
        }
    }
}

// MARK: - Sample (no Firebase)

/// Accepts the prototype code 482915 for any 8-digit number.
final class SampleAuthService: AuthService, @unchecked Sendable {
    private(set) var currentUserId: String?

    init(signedInAs userId: String? = SampleData.fatima.id) {
        currentUserId = userId
    }

    func sendCode(toLocalNumber number: String) async throws -> String {
        let digits = number.filter(\.isNumber)
        guard digits.count == 8 else { throw AuthError.invalidNumber }
        return digits // the "verification id" is just the number
    }

    func verify(code: String, verificationId: String) async throws -> String {
        guard code == SampleData.otpCode else { throw AuthError.invalidCode }
        let existing = SampleData.allUsers.first { $0.phone == verificationId }
        let id = existing?.id ?? "u_\(verificationId)"
        currentUserId = id
        return id
    }

    func signOut() throws {
        currentUserId = nil
    }
}
