# Benah · بينّه

An iPhone app for trusted people pooling money and time:

- **Jam'iya**: a rotating savings group (everyone pays monthly, one member receives the pot each month)
- **Lammah**: plan a gathering (pick a date and a place everyone can make)
- **Qattah**: split a bill or collect money (equal, custom, target, flexible, scanned receipt)

Built with **SwiftUI** (iOS 17+) and **Firebase** (free Spark plan), from the Figma file *Section05 – Group05*.

## Start here

| I want to… | Read |
|---|---|
| Run the app for the first time | [docs/GETTING_STARTED.md](docs/GETTING_STARTED.md) |
| Understand the folders and how data flows | [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) |
| See which feature is built in which branch | [docs/ROADMAP.md](docs/ROADMAP.md) |

## What is simulated (to stay free)

| In the design | In the app |
|---|---|
| SMS / WhatsApp login code | Firebase **test phone numbers**: no SMS is sent, code `482915` |
| Apple Pay / BenefitPay / Visa | Payments are **simulated**, but saved in Firestore so the group sees who paid |
| Receipt scanning | Apple Vision reads the receipt **on the phone**; the photo is not uploaded |
| Push notifications | **In-app** notifications only (push needs the paid Apple Developer Program) |

## Credits

Fonts: Plus Jakarta Sans, Inter, Readex Pro, all under the SIL Open Font License (see `Benah/Resources/Fonts`).
