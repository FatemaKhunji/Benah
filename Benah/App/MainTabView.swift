// MainTabView.swift
// The 5 main tabs with the floating Benah tab bar.
//
// 📘 Learning note
// Each tab has its own NavigationStack, so going deeper in Jam'iya and switching to
// Lammah and back keeps your place in Jam'iya (like most iPhone apps).
// Features replace the placeholder views in their own branches.

import SwiftUI

struct MainTabView: View {
    @State private var selection: AppTab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            // The system TabView keeps each tab alive; we hide its own bar.
            TabView(selection: $selection) {
                ForEach(AppTab.allCases) { tab in
                    NavigationStack {
                        screen(for: tab)
                    }
                    .tag(tab)
                    .toolbar(.hidden, for: .tabBar)
                }
            }

            BenahTabBar(selection: $selection)
                .padding(.bottom, Space.s4)
        }
        .ignoresSafeArea(.keyboard)
    }

    @ViewBuilder
    private func screen(for tab: AppTab) -> some View {
        switch tab {
        case .home: HomePlaceholderView()
        case .jamiya: ComingSoonView(title: "Jam'iya", module: .jamiya, branch: "feature/jamiya")
        case .lammah: ComingSoonView(title: "Lammah", module: .lammah, branch: "feature/lammah")
        case .qattah: ComingSoonView(title: "Qattah", module: .qattah, branch: "feature/qattah")
        case .profile: ProfilePlaceholderView()
        }
    }
}

/// Placeholder screen shown until a feature branch is merged.
struct ComingSoonView: View {
    let title: String
    var module: Module? = nil
    let branch: String

    var body: some View {
        VStack(spacing: Space.s16) {
            if let module {
                BenahIconView(module.icon, size: 48)
                    .foregroundStyle(module.color)
                    .frame(width: 88, height: 88)
                    .background(module.tint, in: Circle())
                Text(module.tagline)
                    .benahFont(.bodyM)
                    .foregroundStyle(Color.benah.textSecondary)
                    .multilineTextAlignment(.center)
            }
            StatusBadge("Coming in \(branch)", tone: .info)
        }
        .padding(Space.s20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .benahScreenBackground()
        .navigationTitle(title)
    }
}

/// Shows live data from the DataStore, so you can see the backend working.
private struct HomePlaceholderView: View {
    @Environment(AppSession.self) private var session
    @State private var notifications: [AppNotification] = []
    @State private var jamiyas: [Jamiya] = []
    @State private var showNotificationsInfo = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Space.s20) {
                HStack(spacing: Space.s12) {
                    AvatarView(initials: session.currentUser?.initials ?? "?", tone: .navy)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Good evening").benahFont(.caption).foregroundStyle(Color.benah.textSecondary)
                        Text(session.currentUser?.firstName ?? "Welcome").benahFont(.title2)
                    }
                    Spacer()
                    NotificationBell(unreadCount: notifications.filter { !$0.isRead }.count) {
                        showNotificationsInfo = true
                    }
                }

                SectionHeader("Your Jam'iyas")
                if jamiyas.isEmpty {
                    Text("No Jam'iyas yet").benahFont(.bodyM).foregroundStyle(Color.benah.textSecondary)
                }
                ForEach(jamiyas) { jamiya in
                    VStack(alignment: .leading, spacing: Space.s8) {
                        HStack {
                            Text(jamiya.name).benahFont(.title3)
                            Spacer()
                            StatusBadge(jamiya.status.rawValue.capitalized,
                                        tone: jamiya.status == .active ? .success : .warning)
                        }
                        Text("\(jamiya.monthlyContribution.formatted()) a month · \(jamiya.memberIds.count)/\(jamiya.memberCount) members")
                            .benahFont(.bodyM)
                            .foregroundStyle(Color.benah.textSecondary)
                    }
                    .benahCard()
                }

                StatusBadge("Backend: \(session.backend.rawValue)", tone: .brand)
                    .padding(.top, Space.s8)
            }
            .padding(.horizontal, Space.s20)
            .padding(.bottom, 120) // room for the floating tab bar
        }
        .benahScreenBackground()
        .toolbar(.hidden, for: .navigationBar)
        .alert("Notifications arrive in feature/home-notifications", isPresented: $showNotificationsInfo) {}
        // `.task` starts when the screen appears and is cancelled when it disappears.
        .task(id: session.userId) { await listen() }
    }

    private func listen() async {
        guard let uid = session.userId else { return }
        async let n: Void = listenNotifications(uid)
        async let j: Void = listenJamiyas(uid)
        _ = await (n, j)
    }

    private func listenNotifications(_ uid: String) async {
        do {
            for try await items in session.store.listen(AppNotification.self, in: FirestorePath.notifications(of: uid)) {
                notifications = items
            }
        } catch {
            session.lastError = error.localizedDescription
        }
    }

    private func listenJamiyas(_ uid: String) async {
        do {
            for try await items in session.store.listen(Jamiya.self, in: FirestorePath.jamiyas,
                                                        whereArray: "memberIds", contains: uid) {
                jamiyas = items
            }
        } catch {
            session.lastError = error.localizedDescription
        }
    }
}

private struct ProfilePlaceholderView: View {
    @Environment(AppSession.self) private var session

    var body: some View {
        List {
            Section {
                HStack(spacing: Space.s12) {
                    AvatarView(initials: session.currentUser?.initials ?? "?", tone: .navy, size: .large)
                    VStack(alignment: .leading) {
                        Text(session.currentUser?.fullName ?? "New user").benahFont(.title3)
                        Text("+973 \(session.currentUser?.phone ?? "")").benahFont(.caption)
                            .foregroundStyle(Color.benah.textSecondary)
                    }
                }
            }
            Section("Developer") {
                NavigationLink("Design system") { DesignSystemGalleryView() }
                NavigationLink("Backend check") { BackendCheckView() }
            }
            Section {
                Button("Sign out", role: .destructive) { session.signOut() }
            }
        }
        .navigationTitle("Profile")
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 80) }
    }
}

#Preview {
    MainTabView()
        .environment(AppSession.preview)
        .environment(ToastCenter())
}
