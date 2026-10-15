# Kathiravan K – Portfolio

Responsive, animated portfolio website built with **Flutter (web)** and Dart.

## Features
- Modern dark theme (midnight ink + violet → cyan gradient, amber accent)
- Animated hero (typewriter roles, floating tech chips, drifting gradient backdrop)
- Scroll-reveal animations, count-up stats, hover-lift cards, scroll-progress bar, active-section nav
- Sections: Hero, About, Skills, Experience (timeline), Projects, Resume, Contact
- **Resume:** view in browser, download as PDF, share (WhatsApp / LinkedIn / Email / copy link)
- **Contact:** WhatsApp, Gmail, LinkedIn, call, plus a message form that sends via WhatsApp / Gmail / LinkedIn
- Fully responsive (phone → desktop), text-scale clamped, no fixed-size overflow; drawer menu on small screens

## Run
```bash
flutter pub get
flutter run -d chrome
```

## Build
```bash
flutter build web --release
# GitHub Pages (project site):
flutter build web --release --base-href "/Kathiravan_Portfolio/"
```
Pushing to `main` deploys automatically through `.github/workflows/deploy.yml`
(enable **Settings → Pages → Source: GitHub Actions** once).

## Customise
- All text/content: `lib/data/portfolio_data.dart`
- Contact details / links: `lib/core/links.dart`
- Colours: `lib/core/app_colors.dart`
- Resume PDF: replace `assets/resume/Kathiravan_K_Resume.pdf` (keep the file name)
- Profile photo: add `assets/images/profile.jpg` and set `PortfolioData.profileAsset`
