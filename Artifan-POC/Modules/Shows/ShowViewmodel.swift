//
//  ShowViewmodel.swift
//  Artifan-POC
//
//  Created by Victor Castro on 10/08/24.
//

import SwiftUI

class ShowViewModel: ObservableObject {
    @Published var shows: [Show] = []
    
    func fetchShows() {
        guard let url = createShowsURL() else {
            print("❌ Error: No se pudo crear la URL.")
            return
        }
        
        print("🔍 Fetching shows from URL: \(url)\n") // Log de la URL
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error fetching shows: \(error)\n") // Log del error
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 HTTP Response Status Code: \(httpResponse.statusCode)\n") // Log del código de estado
            }
            
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📄 Response JSON:\n\(jsonString)\n") // Log de la respuesta JSON
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(ShowResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.shows = decodedResponse.data
                        print("✅ Decoded response: \(decodedResponse)\n") // Log de la respuesta decodificada
                    }
                } catch {
                    print("❌ Error decoding response: \(error)\n") // Log del error de decodificación
                }
            }
        }.resume()
    }
    
    func createShowsURL() -> URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "localhost"
        components.port = 1337
        components.path = "/api/shows"
        
        components.queryItems = [
            URLQueryItem(name: "fields[0]", value: "title"),
            URLQueryItem(name: "fields[1]", value: "description"),
            URLQueryItem(name: "fields[2]", value: "city"),
            URLQueryItem(name: "populate[banner][fields][0]", value: "url"),
            URLQueryItem(name: "populate[category][fields][0]", value: "name")
        ]
        
        return components.url
    }
}
