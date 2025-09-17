//
//  APIService.swift
//  CineFly
//
//  Created by chris on 16/09/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case noRespose
    case invalidRequestBody
    // Add more error cases as needed
}

final class APIService {
    static let shared = APIService()
    private let customSession: URLSession

    init(session: URLSession = .shared) {
        self.customSession = session
    }
    
    private func prettyPrintedJSONString(from data: Data) -> String {
        guard let object = try? JSONSerialization.jsonObject(with: data),
              let prettyData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return String(data: data, encoding: .utf8) ?? "nil"
        }
        return prettyString
    }

    func request<T: Decodable>(_ route: APIRouter, method: HttpMethod) async throws -> T {
        guard var components = URLComponents(string: APIRouter.baseURL + route.path) else {
            throw NetworkError.invalidURL
        }

        // Query parameters (always include API key)
        components.queryItems = route.parameters?.map { key, value in
            return URLQueryItem(name: key, value: "\(value ?? "")")
        } ?? []
        components.queryItems?.append(URLQueryItem(name: "api_key", value: Secrets.apiKey))

        guard let finalURL = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue

        if method == .post, let parameters = route.parameters {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
                throw NetworkError.invalidRequestBody
            }
            request.httpBody = body
        }

        #if DEBUG
        print("📡 REQUEST ====================================")
        print("➡️ URL:", request.url?.absoluteString ?? "nil")
        print("➡️ METHOD:", request.httpMethod ?? "nil")
        print("➡️ HEADERS:", request.allHTTPHeaderFields ?? [:])
        if let body = request.httpBody {
            print("➡️ BODY:\n\(prettyPrintedJSONString(from: body))")
        }
        #endif

        let (data, response) = try await customSession.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            #if DEBUG
            print("📩 RESPONSE ====================================")
            print("⬅️ STATUS:", httpResponse.statusCode)
            print("⬅️ BODY:\n\(prettyPrintedJSONString(from: data))")
            #endif
        }

        do {
            let decoder = JSONDecoder()
            // decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            #if DEBUG
            print("❌ ERROR ====================================")
            print("Decoding failed for type:", T.self)
            print("Raw Response:\n\(prettyPrintedJSONString(from: data))")
            print("Error:", error)
            #endif
            throw error
        }
    }
}
