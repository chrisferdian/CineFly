# 🎬 CineFly

An iOS movie discovery app powered by TMDB API. Built with SwiftUI, SwiftData, and modern iOS development practices.

## 🚀 Tech Stack

Language: Swift 5

UI Framework: SwiftUI

Persistence: SwiftData

Networking: URLSession

Minimum iOS: 17.0

## ✨ Features

🔍 Search Movies – query TMDB database with pagination support.

🎥 Movie Detail – view full information including overview, cast, related videos, and similar movies.

❤️ Favorites – save your favorite movies for quick access.

🕑 Recent Searches – revisit your search history easily.

📡 Offline Support – cached data available when offline (via SwiftData).

## 🧪 Unit Tests

#### Unit tests are provided for the core layer:

✅ Network API service

✅ Environment configuration

✅ API routes

✅ View routes

## 🔧 Setup
1. Clone the repository
```
git clone https://github.com/chrisferdian/CineFly.git
```
2. Open the project in Xcode 15+.
3. Add your TMDB API key in Secrets.swift:
```
struct Secrets {
    static let apiKey = "YOUR_API_KEY"
}
```
4. Run the project on iOS 17 simulator or device.

## Brief Write-up

#### Decisions Made
- SwiftData for caching → Selected over Core Data for its simplicity and deep SwiftUI integration.
- MVVM with modular layers → Ensures separation of concerns between networking, persistence, and UI.
- Async/await networking → Provides cleaner, modern concurrency handling.

#### Challenges Faced
- Caching strategy: Needed to balance between online/offline usage. Solved by persisting search results and recent queries with SwiftData.
- Pagination logic: Avoided duplicate requests and ensured smooth scrolling experience.
- TMDB API complexity: Some endpoints (like cast & videos) required multiple requests; solved by abstracting calls into APIRouter.

#### How I Overcame Them
- Broke down the problem into layers: API → Repository → ViewModel → View.
- Wrote unit tests for APIService and routes early to ensure reliability.
- Applied SwiftUI’s state-driven updates to make UI reactive and simpler to maintain.
