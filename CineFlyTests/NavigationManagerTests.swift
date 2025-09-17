//
//  NavigationManagerTests.swift
//  CineFlyTests
//
//  Created by chris on 17/09/25.
//

import XCTest
import SwiftUI
@testable import CineFly

final class NavigationManagerTests: XCTestCase {
    var sut: NavigationManager!
    private let mockMovie = Movie.init(id: 1, title: nil, overview: nil, release_date: nil, poster_path: nil)
    
    override func setUp() {
        super.setUp()
        sut = NavigationManager()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testPush_addsRouteToPath() {
        // Given
        let route = ViewRouter.detail(mockMovie)
        
        // When
        sut.push(route)
        
        // Then
        XCTAssertEqual(sut.path.count, 1)
        XCTAssertEqual(sut.path.last, route)
    }
    
    func testPop_removesLastRoute() {
        // Given
        let route = ViewRouter.detail(mockMovie)
        sut.push(route)
        
        // When
        sut.pop()
        
        // Then
        XCTAssertEqual(sut.path.count, 0)
    }
    
    func testPopToRoot_removesAllRoutes() {
        // Given
        let route = ViewRouter.detail(mockMovie)
        sut.push(route)
        
        // When
        sut.popToRoot()
        
        // Then
        XCTAssertTrue(sut.path.isEmpty)
    }
    
    func testEnvironmentValuesNavigationManager_defaultValue() {
        let env = EnvironmentValues()
        
        // By default, it should return a fresh instance
        let defaultNav = env.nav
        XCTAssertTrue(defaultNav.path.isEmpty)
    }
    
    func testEnvironmentValuesNavigationManager_customValue() {
        var env = EnvironmentValues()
        let customNav = NavigationManager()
        customNav.push(.detail(mockMovie))
        
        env.nav = customNav
        
        XCTAssertEqual(env.nav.path.count, 1)
        XCTAssertEqual(env.nav.path.first?.id, "detail-1")
    }
}
