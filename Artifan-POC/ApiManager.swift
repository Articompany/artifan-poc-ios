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
            throw NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL no válida"])
        }

        var components = URLComponents()
        components.scheme = url.scheme
        components.host = url.host
        components.port = url.port
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else {
            throw NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL no válida"])
        }
        print("🔗 Full URL: \(url)")

        var request = URLRequest(url: url)
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
                    throw NSError(
                        domain: "DecodingError",
                        code: 0,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Error al decodificar la respuesta.",
                            NSUnderlyingErrorKey: error
                        ]
                    )
                }
            } else {
                throw NSError(
                    domain: "NetworkError",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Error en la respuesta del servidor"]
                )
            }
        } else {
            throw NSError(
                domain: "InvalidResponse",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Respuesta no válida"]
            )
        }
    }
}
