//
//  APIServiceTests.swift
//  CineFlyTests
//
//  Created by chris on 17/09/25.
//

import XCTest
@testable import CineFly

final class APIServiceTests: XCTestCase {
    var sut: APIService!
    
    override func setUp() {
        super.setUp()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]  // intercept requests
        let mockSession = URLSession(configuration: config)
        
        sut = APIService(session: mockSession)
    }
    
    override func tearDown() {
        sut = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.stubError = nil
        super.tearDown()
    }
    
    func testRequest_success_decodesResponse() async throws {
        struct MockResponse: Codable, Equatable {
            let id: Int
            let name: String
        }
        
        let expected = MockResponse(id: 1, name: "Test Movie")
        let jsonData = try JSONEncoder().encode(expected)
        MockURLProtocol.stubResponseData = jsonData
        
        let route = APIRouter.search(query: "test", page: 1)
        let result: MockResponse = try await sut.request(route, method: .get)
        
        XCTAssertEqual(result, expected)
    }
    
    func testRequest_failure_invalidJSON() async {
        let invalidJSON = "{ invalid json }".data(using: .utf8)!
        MockURLProtocol.stubResponseData = invalidJSON
        
        let route = APIRouter.search(query: "fail", page: 1)
        
        do {
            let _: DecodableTest = try await sut.request(route, method: .get)
            XCTFail("Expected decoding error")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testRequest_networkError() async {
        MockURLProtocol.stubError = URLError(.notConnectedToInternet)
        
        let route = APIRouter.search(query: "offline", page: 1)
        
        do {
            let _: DecodableTest = try await sut.request(route, method: .get)
            XCTFail("Expected network error")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
}
private struct DecodableTest: Decodable {}
