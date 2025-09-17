//
//  MovieVideoResponse.swift
//  CineFly
//
//  Created by chris on 16/09/25.
//

import Foundation

struct MovieVideoResponse: Codable {
    let id: Int
    let results: [MovieVideo]
}

// MARK: - Result
struct MovieVideo: Codable, Hashable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
    
    /// Full YouTube URL
    var youtubeURL: URL? {
        guard site.lowercased() == "youtube" else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
    
    /// YouTube thumbnail
    var thumbnailURL: URL? {
        guard site.lowercased() == "youtube" else { return nil }
        return URL(string: "https://img.youtube.com/vi/\(key)/0.jpg")
    }
}
