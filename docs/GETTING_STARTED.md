# Getting started

This guide assumes you have never set up a backend and are new to GitHub.
Do the parts in order. Each step says **what** to do and **why**.

---

## Part 1: Words you'll see

| Word | Meaning |
|---|---|
| **Repository (repo)** | The project folder, stored on GitHub with its full history. |
| **Commit** | A saved snapshot of changes, with a message describing them. |
| **Branch** | A separate line of work. `main` is the approved version; each feature gets its own branch (e.g. `feature/foundation`) so work in progress never breaks `main`. |
| **Pull request (PR)** | A request on GitHub to merge a branch into `main`. You review the changes, then press **Merge**. Nothing reaches `main` without your approval. |
| **Clone / fetch / pull** | Clone = download the repo the first time. Fetch = ask GitHub what's new. Pull = download it into your branch. |
| **Backend** | The part that runs on a server: accounts and the shared database. Here it's Firebase. |
| **Firestore** | Firebase's database. Data is stored as *documents* (like JSON files) inside *collections* (like folders). |

---

## Part 2: One-time setup on your Mac

### 2.1 Install Xcode
App Store → search **Xcode** → install (version 16 or newer) → open it once and let it install the extra components.

### 2.2 Download the project (clone)
Open the **Terminal** app and run these (each line is one command):

```bash
cd ~/Documents
```

```bash
git clone https://github.com/fatemakhunji/benah.git
```

```bash
cd benah
```

### 2.3 Protect `main` (so nothing is merged without you)
On github.com → your repo → **Settings** → **Branches** → **Add branch protection rule**
→ Branch name pattern: `main` → tick **Require a pull request before merging** → **Create**.

---

## Part 3: Firebase (free)

You can skip this part at first: without Firebase the app runs on **sample data**
(Fatima Ahmed, Family Circle, …). Do it when you want real accounts and saved data.

### 3.1 Create the project
1. Go to <https://console.firebase.google.com> and sign in with a Google account.
2. **Create a project** → name it `benah` → turn **off** Google Analytics → **Create**.
3. You are on the **Spark (free)** plan. Never click *Upgrade*: Blaze asks for a card.

### 3.2 Add the iPhone app
1. On the project page, click the **iOS+** icon ("Add app").
2. **Apple bundle ID**: `com.benah.app` (must match Xcode, see 4.2).
3. Click **Register app** → **Download GoogleService-Info.plist** → keep the file.
4. Skip the remaining steps in that wizard (the code is already set up) → **Continue to console**.

### 3.3 Turn on sign-in with a phone number
1. Left menu → **Build → Authentication** → **Get started**.
2. **Sign-in method** tab → **Phone** → **Enable** → **Save**.
   - ⚠️ If Firebase asks you to add billing, stop and tell Claude. We'll switch to email sign-in instead.
3. Still in the Phone settings, open **Phone numbers for testing** and add:

| Phone number | Code |
|---|---|
| +973 3912 3456 | 482915 |
| +973 3301 2210 | 482915 |

Why: real SMS costs money. Test numbers never send an SMS; Firebase accepts the code you chose.

### 3.4 Create the database
1. Left menu → **Build → Firestore Database** → **Create database**.
2. Location: choose one near Bahrain, e.g. **europe-west** (Belgium) or **me-central** if listed. *This can't be changed later.*
3. Start in **production mode** → **Create**.

### 3.5 Publish the security rules
1. Firestore Database → **Rules** tab.
2. Open `firebase/firestore.rules` from this repo, copy everything, paste it over what is there.
3. Click **Publish**.

Why: rules decide who can read and write what. Without them, production mode refuses everything.

---

## Part 4: Run the app

### 4.1 Get the branch you want to test
In Terminal, inside the `benah` folder:

```bash
git fetch origin
```

```bash
git checkout feature/foundation
```

(Later branches: replace `feature/foundation` with the branch name from the PR.)

### 4.2 Open in Xcode
1. Double-click **Benah.xcodeproj**.
2. The first time, Xcode downloads Firebase (*Fetching packages…* at the top). Wait for it to finish (a few minutes).
3. Click **Benah** (blue icon, top of the left sidebar) → **Signing & Capabilities** → **Team**: choose your Apple ID
   (*Add an Account…* if empty; a free Apple ID works).
   - If you see *"bundle identifier is not available"*, change `com.benah.app` to something unique like
     `com.yourname.benah`, **and** use the same ID in Firebase (3.2).

### 4.3 Add the Firebase file (optional, see Part 3)
Drag **GoogleService-Info.plist** from Finder into the **Benah** folder in Xcode's left sidebar.
Tick **Copy items if needed**. It is listed in `.gitignore`, so it will never be uploaded to GitHub.

### 4.4 Run
At the top, choose a simulator (e.g. **iPhone 16**) → press **▶** (or ⌘R).

---

## Part 5: Testing the foundation branch

| Check | Where |
|---|---|
| App opens, logo, tab bar at the bottom | first screen |
| Colours, fonts, buttons, fields, badges, chips, toasts, icons | **Profile → Design system** (or *Open design system* on the start screen) |
| Dark mode | Simulator menu **Features → Toggle Appearance** (⇧⌘A) |
| Backend works | **Backend check** → **Run check**: every line should be green ✅ |

### If the build fails
1. In Xcode, open the **Issue navigator** (⌘5, the ⚠️ icon) to see the red errors.
2. Copy the error text (or take a screenshot) and send it to Claude, saying which branch you were on.

---

## Part 6: Approving a feature (Pull Request)

1. Claude pushes a branch and opens a PR into `main`.
2. Test it as in Part 4 and Part 5.
3. On GitHub → **Pull requests** → open it → **Files changed** to see the code.
4. Happy? → **Merge pull request** → **Confirm merge**. Not happy? Write a comment saying what's wrong.
5. Update your copy of `main`:

```bash
git checkout main
```

```bash
git pull
```
