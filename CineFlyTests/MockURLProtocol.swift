//
//  MockURLProtocol.swift
//  CineFly
//
//  Created by chris on 17/09/25.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    static var stubResponseData: Data?
    static var stubStatusCode: Int = 200
    static var stubError: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true // intercept all requests
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = MockURLProtocol.stubError {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: MockURLProtocol.stubStatusCode,
                httpVersion: nil,
                headerFields: nil
            )!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

            if let data = MockURLProtocol.stubResponseData {
                client?.urlProtocol(self, didLoad: data)
            }
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
