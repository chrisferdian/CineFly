//
//  SearchViewModel.swift
//  CineFly
//
//  Created by chris on 16/09/25.
//

import Combine
import SwiftData
import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentPage = 1
    @Published var hasMore = true
    @Published var totalPages: Int = 0
    
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    func search(query: String) async {
        if query.isEmpty {
            movies = []
            errorMessage = nil
            isLoading = false
            return
        }
        
        if let cached = try? context.fetch(
            FetchDescriptor<CachedSearch>(
                predicate: #Predicate { movie in
                    movie.query == query
                }
            )
        ).first {
            self.movies = cached.movies.map {
                Movie(
                    id: $0.id,
                    title: $0.title,
                    overview: $0.overview,
                    release_date: $0.releaseDate,
                    poster_path: $0.posterPath
                )
            }
        } else { movies = [] }
        
        totalPages = 0
        currentPage = 1
        isLoading = true
        errorMessage = nil
        
        do {
            let results: MovieResponse = try await APIService.shared.request(
                .search(query: query, page: currentPage),
                method: .get
            )
            
            totalPages = results.total_pages
            
            if let oldCache = try? context.fetch(
                FetchDescriptor<CachedSearch>(
                    predicate: #Predicate { $0.query == query }
                )
            ).first {
                context.delete(oldCache)
            }
            
            let cachedMovies = results.results.map {
                CachedMovie(
                    id: $0.id,
                    title: $0.title,
                    overview: $0.overview,
                    releaseDate: $0.release_date,
                    posterPath: $0.poster_path
                )
            }
            self.saveQuery(query, list: cachedMovies)
            movies = results.results
            currentPage += 1
            hasMore = totalPages >= currentPage
        } catch {
            errorMessage = "Failed to load movies. Please try again."
        }
        
        isLoading = false
    }
    

    func loadMore(query: String) async {
        errorMessage = nil
        guard hasMore else { return }
        do {
            let response: MovieResponse = try await APIService.shared.request(.search(query: query, page: currentPage), method: .get)
            if response.results.isEmpty {
                hasMore = false
            } else {
                movies.append(contentsOf: response.results)
                currentPage += 1
            }
        } catch {
            errorMessage = "Failed to load more movies."
        }
    }
    
    @MainActor
    func saveQuery(_ query: String, list: [CachedMovie]) {
        // Check if already exists
        let descriptor = FetchDescriptor<CachedSearch>(
            predicate: #Predicate { $0.query == query }
        )
        if let existing = try? context.fetch(descriptor).first {
            existing.timestamp = .now
        } else {
            let cached = CachedSearch(query: query, movies: list)
            context.insert(cached)
        }
        
        DispatchQueue.main.async {
            do {
                try self.context.save()
                print("✅ Save CachedSearch: \(query)")
            } catch {
                print("❌ Failed to save CachedSearch: \(error)")
            }
        }
    }
}
