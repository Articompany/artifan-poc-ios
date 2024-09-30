//
//  ApiManager.swift
//  Artifan-POC
//
//  Created by Victor Castro on 12/08/24.
//

import Foundation

class APIManager {

    enum HttpMethods: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum APIError: Error {
        case invalidURL
        case invalidURLComponents(URLComponents)
        case decodingError(Error)
        case networkError
        case invalidResponse
        
        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "URL no válida"
            case .invalidURLComponents(let components):
                return "\(components) no válida"
            case .decodingError(let error):
                return "Error al decodificar la respuesta: \(error.localizedDescription)"
            case .networkError:
                return "Error en la respuesta del servidor"
            case .invalidResponse:
                return "Respuesta no válida"
            }
        }
    }

    static let shared = APIManager()

    private init() {}

    func call<T: Decodable>(
        path: String,
        method: HttpMethods,
        queryItems: [URLQueryItem]? = nil,
        body: Data? = nil,
        responseType: T.Type
    ) async throws -> T {
        guard let url = EnvironmentManager.shared.environmentURL else {
            throw APIError.invalidURL
        }
        
        var components = URLComponents()
        components.scheme = url.scheme
        components.host = url.host
        components.port = url.port
        components.path = path.hasPrefix("/") ? path : "/" + path
        components.queryItems = queryItems

        guard let urlWithComponents = components.url else {
            throw APIError.invalidURLComponents(components)
        }
        print("🔗 Full URL: \(urlWithComponents)")

        var request = URLRequest(url: urlWithComponents)
        request.httpMethod = method.rawValue

        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            print("📦 HTTP BodyRequest: \(String(data: body, encoding: .utf8) ?? "")")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        if let jsonString = String(data: data, encoding: .utf8) {
            print("🛜 [\(method.rawValue)] JSON Response: \(jsonString)")
        }

        if let httpResponse = response as? HTTPURLResponse {
            print("📶 HTTP Status Code: \(httpResponse.statusCode)")
            if httpResponse.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let decodedResponse = try decoder.decode(responseType, from: data)
                    return decodedResponse
                } catch {
                    print("❌ Decoding Error: \(error.localizedDescription)")
                    throw APIError.decodingError(error)
                }
            } else {
                throw APIError.networkError
            }
        } else {
            throw APIError.invalidResponse
        }
    }
}
