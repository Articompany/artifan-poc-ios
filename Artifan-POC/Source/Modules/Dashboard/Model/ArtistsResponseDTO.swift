//
//  ArtistsResponseDTO.swift
//  Artifan-POC
//
//  Created by Victor Castro on 28/09/24.
//

import Foundation

struct OneArtistResponseDTO: Codable {
    let data: ArtistDTO
}

struct ListArtistsResponseDTO: Codable {
    let data: [ArtistSampleDTO]
    let meta: MetaDTO
    
    struct MetaDTO: Codable {
        let pagination: PaginationDTO
        
        struct PaginationDTO: Codable {
            let total: Int
            let page: Int
            let pageSize: Int
            let pageCount: Int
        }
    }
}

// MARK: - ArtistSampleDTO Model
struct ArtistSampleDTO: Codable {
    let id: Int
    let documentId: String
    let name: String
    let city: String
    let description: String
    let banner: BannerDTO
    let category: CategoryDTO
}

// MARK: - ArtistDTO Model
struct ArtistDTO: Codable {
    let id: Int
    let documentId: String
    let name: String
    let city: String
    let description: String
    let banner: BannerDTO
    let category: CategoryDTO
    let whatsapp: Int
    let photos: [PhotoDTO]
    
    // MARK: - PhotoDTO Model
    struct PhotoDTO: Codable {
        let id: Int
        let documentId: String
        let name: String
        let url: String
        let formats: FormatsDTO
    }
}

// MARK: - BannerDTO Model
struct BannerDTO: Codable {
    let id: Int
    let documentId: String
    let url: String
    let formats: FormatsDTO
}

// MARK: - CategoryDTO Model
struct CategoryDTO: Codable {
    let id: Int
    let documentId: String
    let name: String
}

// MARK: - FormatsDTO Model
struct FormatsDTO: Codable {
    let large: FormatDTO
    let small: FormatDTO
    let medium: FormatDTO
    let thumbnail: FormatDTO
    
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

extension ArtistSampleDTO {
    func toModel() -> ArtistModel {
        let banner = ArtistModel.Banner(
            url: banner.url,
            largeURL: banner.formats.large.url,
            smallURL: banner.formats.small.url,
            mediumURL: banner.formats.medium.url,
            thumbnail: banner.formats.thumbnail.url
        )
        
        let category = ArtistModel.Category(
            id: category.documentId,
            name: category.name
        )
        
        return ArtistModel(
            id: documentId,
            name: name,
            city: city,
            description: description,
            banner: banner,
            category: category,
            whatsapp: ""
        )
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
            id: category.documentId,
            name: category.name
        )
        
        return ArtistModel(
            id: documentId,
            name: name,
            city: city,
            description: description,
            banner: banner,
            category: category,
            whatsapp: String(whatsapp)
        )
    }
}
