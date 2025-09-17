//
//  MovieDetailViewModel.swift
//  CineFly
//
//  Created by chris on 16/09/25.
//

import Combine

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var similarMovies: [Movie] = []
    @Published var cast: [CastMovie] = []
    @Published var videos: [MovieVideo] = []
    
    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    @MainActor
    func getSimilarMovies() async {
        do {
            let results: MovieResponse = try await APIService.shared.request(.similer(id: movie.id), method: .get)
            self.similarMovies = results.results
        } catch {
            
        }
    }
    
    @MainActor
    func fetchCredits()  async{
        do {
            let results: CreditResponse = try await APIService.shared.request(.credits(id: movie.id), method: .get)
            self.cast = results.cast ?? []
        } catch {
            
        }
    }
    
    @MainActor
    func getMovieVideo()  async{
        do {
            let results: MovieVideoResponse = try await APIService.shared.request(.videos(id: movie.id), method: .get)
            self.videos = results.results
        } catch {
            
        }
    }
}
