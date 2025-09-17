//
//  MovieEntity.swift
//  CineFly
//
//  Created by chris on 16/09/25.
//

import Foundation
import SwiftData

@Model
class MovieEntity {
    @Attribute(.unique) var id: Int
    var title: String
    var overview: String
    var releaseDate: String?
    var posterPath: String?
    var timestamp: Date
    
    init(id: Int, title: String, overview: String, releaseDate: String?, posterPath: String? = nil, timestamp: Date = .now) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.timestamp = timestamp
    }
    
    init(movie: Movie) {
        id = movie.id
        title = movie.title ?? "Unknown Title"
        overview = movie.overview ?? ""
        releaseDate = movie.release_date
        posterPath = movie.poster_path
        self.timestamp = .now
    }
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    func getMovie() -> Movie {
        return Movie(id: id, title: title, overview: overview, release_date: releaseDate, poster_path: posterPath)
    }
}
