//
//  CachedSearch.swift
//  CineFly
//
//  Created by chris on 16/09/25.
//


import SwiftData
import Foundation

@Model
class CachedSearch {
    @Attribute(.unique) var query: String
    var movies: [CachedMovie]
    var timestamp: Date
    
    init(query: String, movies: [CachedMovie], timestamp: Date = .now) {
        self.query = query
        self.movies = movies
        self.timestamp = timestamp
    }
}

@Model
class CachedMovie {
    @Attribute(.unique) var id: Int
    var title: String?
    var overview: String?
    var releaseDate: String?
    var posterPath: String?
    
    init(id: Int, title: String?, overview: String?, releaseDate: String?, posterPath: String?) {
        self.id = id
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.posterPath = posterPath
    }
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}
