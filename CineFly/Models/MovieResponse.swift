//
//  MovieResponse.swift
//  CineFly
//
//  Created by chris on 16/09/25.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
    let total_pages: Int
}

struct Movie: Codable, Identifiable, Hashable {
    let id: Int
    let title: String?
    let overview: String?
    let release_date: String?
    let poster_path: String?
    
    var posterURL: URL? {
        guard let path = poster_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}
