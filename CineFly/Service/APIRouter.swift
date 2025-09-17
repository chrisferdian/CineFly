//
//  APIRouter.swift
//  CineFly
//
//  Created by chris on 16/09/25.
//


enum APIRouter {
    static let baseURL = "https://api.themoviedb.org/3/"
    case discover(page: Int, genre: Int?)
    case genres
    case videos(id: Int)
    case reviews(id: Int, page: Int)
    case similer(id: Int)
    case credits(id: Int)
    case search(query: String, page: Int)
    
    var path: String {
        switch self {
        case .discover:
            return "discover/movie"
        case .genres:
            return "genre/movie/list"
        case .videos(let id):
            return "movie/\(id)/videos"
        case .reviews(let id, _):
            return "movie/\(id)/reviews"
        case .similer(let id):
            return "movie/\(id)/similar"
        case .credits(let id):
            return "movie/\(id)/credits"
        case .search:
            return "search/movie"
        }
    }
    
    var parameters: [String: Any?]? {
        switch self {
        case .discover(let page, let genre):
            return [
                "page": page,
                "with_genres": genre
            ]
        case .reviews(_, let page):
            return [
                "page": page
            ]
        case .search(let query, let page):
            return [
                "query": query,
                "page": page
            ]
        case .similer:
            return [
                "language": "en-US",
                "page": 1
            ]
        case .genres, .videos, .credits:
            return [
                "language": "en-US"
            ]
        }
    }
}
