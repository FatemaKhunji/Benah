// BackendCheckView.swift
// A developer screen that proves the backend works, step by step:
//   1. Is Firebase configured?   2. Sign in with a test number + code
//   3. Write your profile         4. Read it back
// Open it from the start screen or Profile → Developer → Backend check.
//
// 📘 Learning note
// When something fails, the red message is the exact error from Firebase.
// Copy it to Claude / Google: it usually says exactly what's wrong
// (e.g. "PERMISSION_DENIED" = the security rules refused the request).

import SwiftUI

struct BackendCheckView: View {
    @Environment(AppSession.self) private var session

    @State private var phone = "39123456"
    @State private var code = SampleData.otpCode
    @State private var log: [(ok: Bool, text: String)] = []
    @State private var isRunning = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Space.s20) {
                HStack {
                    Text("Backend").benahFont(.title3)
                    Spacer()
                    StatusBadge(session.backend.rawValue, tone: session.backend == .firebase ? .success : .warning)
                }
                if session.backend == .sample {
                    Text("GoogleService-Info.plist was not found, so the app uses sample data. Add the file to the Benah folder in Xcode to use Firebase.")
                        .benahFont(.bodyM)
                        .foregroundStyle(Color.benah.textSecondary)
                }

                BenahTextField(label: "Test mobile number", text: $phone, prefix: "+973",
                               helper: "Must be listed under 'Phone numbers for testing' in Firebase",
                               keyboard: .phonePad)
                BenahTextField(label: "Test code", text: $code, keyboard: .numberPad)

                Button(isRunning ? "Running…" : "Run check") {
                    Task { await runCheck() }
                }
                .buttonStyle(.benah(.primary))
                .disabled(isRunning)

                VStack(alignment: .leading, spacing: Space.s8) {
                    ForEach(Array(log.enumerated()), id: \.offset) { _, line in
                        HStack(alignment: .top, spacing: Space.s8) {
                            BenahIconView(line.ok ? .check : .alert, size: 16)
                                .foregroundStyle(line.ok ? Color.benah.success : Color.benah.danger)
                            Text(line.text).benahFont(.caption).textSelection(.enabled)
                        }
                    }
                }
            }
            .padding(Space.s20)
            .padding(.bottom, 100)
        }
        .benahScreenBackground()
        .navigationTitle("Backend check")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func runCheck() async {
        isRunning = true
        log = []
        defer { isRunning = false }

        log.append((true, "Backend in use: \(session.backend.rawValue)"))
        do {
            let verificationId = try await session.auth.sendCode(toLocalNumber: phone)
            log.append((true, "Code requested for +973 \(phone)"))

            let uid = try await session.auth.verify(code: code, verificationId: verificationId)
            log.append((true, "Signed in. User id: \(uid)"))

            var profile = try await session.store.get(AppUser.self, at: FirestorePath.user(uid))
                ?? AppUser(id: uid, firstName: "Fatima", surname: "Ahmed", phone: phone)
            profile.notificationsEnabled = true
            try await session.store.set(profile, at: FirestorePath.user(uid))
            log.append((true, "Wrote users/\(uid)"))

            let readBack = try await session.store.get(AppUser.self, at: FirestorePath.user(uid))
            log.append((readBack != nil, readBack.map { "Read back: \($0.fullName)" } ?? "Could not read the profile back"))

            await session.didSignIn(uid: uid)
            log.append((true, "All good. The backend works ✅"))
        } catch {
            log.append((false, "Failed: \(error.localizedDescription)"))
        }
    }
}

#Preview {
    NavigationStack { BackendCheckView() }
        .environment(AppSession.preview)
}
