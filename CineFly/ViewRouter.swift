//
//  ViewRouter.swift
//  CineFly
//
//  Created by chris on 16/09/25.
//

import Foundation

enum ViewRouter: Identifiable, Hashable {
    static func == (lhs: ViewRouter, rhs: ViewRouter) -> Bool {
        lhs.id == rhs.id
    }
    case detail(Movie)
    case favorite
    
    var id: String {
        switch self {
        case .detail(let movie):
            return "detail-\(movie.id)"
        case .favorite:
            return "favorite"
        }
    }
}
