//
//  ArtistModelDTO.swift
//  Artifan-POC
//
//  Created by Victor Castro on 28/09/24.
//

import Foundation

struct ArtistModelDTO: Codable {
    let data: [ArtistDTO]
}

// MARK: - Event Model
struct ArtistDTO: Codable {
    let id: Int
    let documentId: String
    let name: String
    let city: String
    let banner: BannerDTO
    let category: CategoryDTO
    
    // MARK: - Banner Model
    struct BannerDTO: Codable {
        let id: Int
        let documentId: String
        let url: String
        let formats: FormatsDTO
        
        // MARK: - Formats Model
        struct FormatsDTO: Codable {
            let large: FormatDTO
            let small: FormatDTO
            let medium: FormatDTO
            let thumbnail: FormatDTO
            
            // MARK: - Format Model
            struct FormatDTO: Codable {
                let ext: String
                let url: String
                let hash: String
                let mime: String
                let name: String
                let path: String?
                let size: Double
                let width: Int
                let height: Int
                let sizeInBytes: Int
            }
        }
    }

    // MARK: - Category Model
    struct CategoryDTO: Codable {
        let id: Int
        let documentId: String
        let name: String
    }
}

extension ArtistDTO {
    func toModel() -> ArtistModel {
        
        let banner = ArtistModel.Banner(
            url: banner.url,
            largeURL: banner.formats.large.url,
            smallURL: banner.formats.small.url,
            mediumURL: banner.formats.medium.url,
            thumbnail: banner.formats.thumbnail.url
        )
        
        let category = ArtistModel.Category(
            id: category.id,
            name: category.name
        )
        
        return ArtistModel(
            id: id,
            name: name,
            city: city,
            banner: banner,
            category: category
        )
    }
}
