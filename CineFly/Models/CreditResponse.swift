//
//  CreditResponse.swift
//  CineFly
//
//  Created by chris on 16/09/25.
//

import Foundation

// MARK: - Credits
struct CreditResponse: Codable {
    let cast, crew: [CastMovie]?
}

struct CastMovie: Codable, Hashable, Identifiable {
    var id: String {
        return name ?? ""
    }
    
    var known_for_department: String?
    var name: String?
    var profile_path: String?
    var character: String?
    
    var posterURL: URL? {
        guard let path = profile_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}
