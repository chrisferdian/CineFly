//
//  APIRouterTests.swift
//  CineFlyTests
//
//  Created by chris on 17/09/25.
//

import XCTest
@testable import CineFly

final class APIRouterTests: XCTestCase {
    func testDiscoverPathAndParameters() {
        let router = APIRouter.discover(page: 2, genre: 28)
        
        XCTAssertEqual(router.path, "discover/movie")
        XCTAssertEqual(router.parameters?["page"] as? Int, 2)
        XCTAssertEqual(router.parameters?["with_genres"] as? Int, 28)
    }
    
    func testGenresPath() {
        let router = APIRouter.genres
        XCTAssertEqual(router.path, "genre/movie/list")
        XCTAssertEqual(router.parameters?.count, 1)
    }
    
    func testVideosPath() {
        let router = APIRouter.videos(id: 123)
        XCTAssertEqual(router.path, "movie/123/videos")
    }
    
    func testReviewsPathAndParameters() {
        let router = APIRouter.reviews(id: 99, page: 3)
        XCTAssertEqual(router.path, "movie/99/reviews")
        XCTAssertEqual(router.parameters?["page"] as? Int, 3)
    }
    
    func testSimilarPath() {
        let router = APIRouter.similer(id: 42)
        XCTAssertEqual(router.path, "movie/42/similar")
    }
    
    func testCreditsPath() {
        let router = APIRouter.credits(id: 55)
        XCTAssertEqual(router.path, "movie/55/credits")
    }
    
    func testSearchPathAndParameters() {
        let router = APIRouter.search(query: "batman", page: 1)
        XCTAssertEqual(router.path, "search/movie")
        XCTAssertEqual(router.parameters?["query"] as? String, "batman")
        XCTAssertEqual(router.parameters?["page"] as? Int, 1)
    }
}
