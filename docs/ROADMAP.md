# Roadmap: one branch per feature

Each branch gets a Pull Request into `main`. Merge them **in this order**, because later ones build
on earlier ones. Dark mode comes with every branch, since the colours switch automatically.

| # | Branch | Figma sections | Screens |
|---|---|---|---|
| 1 | `feature/foundation` | Read Me & Design System | design tokens, components, models, Firebase, tab shell |
| 2 | `feature/launch-onboarding` | 00 Launch & onboarding, 00b Skeleton loading | 19 |
| 3 | `feature/account-profile` | 01 Account & Profile | 27 |
| 4 | `feature/home-notifications` | 02 Home, Notifications & Saved Groups | 26 |
| 5 | `feature/people` | 10 Add people, 11 Your people | 12 |
| 6 | `feature/jamiya` | 03 Jam'iya | 70 |
| 7 | `feature/lammah` | 04 Lammah | 66 |
| 8 | `feature/qattah` | 05 Qattah, 06 Receipt scanning | 67 |
| 9 | `feature/payments` | 07 Shared payments | 14 |
| 10 | `feature/group-menu-reports` | 12 Group menu, share & reports | 8 |
| 11 | `feature/admin` | 08 Administrator, 13 Restricted member (Khalid) | 41 |
| 12 | `feature/arabic-rtl` | 09 Arabic / RTL samples | 23 (+ Arabic text for every screen) |

Note: many Figma "screens" are states of one screen (e.g. *OTP-InvalidCode*, *OTP-ExpiredCode*),
so in code they become one view with different states, not separate files.
