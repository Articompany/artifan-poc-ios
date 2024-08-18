//
//  ShowsResponseDTO.swift
//  Artifan-POC
//
//  Created by Victor Castro on 10/08/24.
//

import Foundation

// MARK: - RootDTO
struct ShowsResponseDTO: Codable {
    let data: [ShowDataDTO]
    let meta: MetaDTO
}

// MARK: - ShowDataDTO
struct ShowDataDTO: Codable {
    let id: Int
    let attributes: ShowAttributesDTO
}

// MARK: - ShowAttributesDTO
struct ShowAttributesDTO: Codable {
    let title: String
    let description: String?
    let city: String
    let facebook: String?
    let tiktok: String?
    let youtube: String?
    let instagram: String?
    let whatsapp: Int?
    let createdAt: String
    let updatedAt: String
    let banner: BannerDTO?
    let photos: PhotosDTO?
    let category: CategoryDTO?
}

// MARK: - BannerDTO
struct BannerDTO: Codable {
    let data: BannerDataDTO
}

// MARK: - BannerDataDTO
struct BannerDataDTO: Codable {
    let id: Int
    let attributes: ImageAttributesDTO
}

// MARK: - BannerAttributesDTO
struct ImageAttributesDTO: Codable {
    let name: String
    let alternativeText: String?
    let caption: String?
    let width: Int
    let height: Int
    let formats: ImageFormatsDTO?
    let hash: String
    let ext: String
    let mime: String
    let size: Double
    let url: String
    let previewUrl: String?
    let provider: String
    let providerMetadata: String?
    let createdAt: String
    let updatedAt: String
}

// MARK: - ImageFormatsDTO
struct ImageFormatsDTO: Codable {
    let thumbnail: ImageFormatDTO?
    let small: ImageFormatDTO?
    let large: ImageFormatDTO?
    let medium: ImageFormatDTO?
}

// MARK: - ImageFormatDTO
struct ImageFormatDTO: Codable {
    let name: String
    let hash: String
    let ext: String
    let mime: String
    let path: String?
    let width: Int
    let height: Int
    let size: Double
    let sizeInBytes: Int
    let url: String
}

// MARK: - PhotosDTO
struct PhotosDTO: Codable {
    let data: [PhotoDataDTO]?
}

// MARK: - PhotoDataDTO
struct PhotoDataDTO: Codable {
    let id: Int
    let attributes: ImageAttributesDTO
}

// MARK: - CategoryDTO
struct CategoryDTO: Codable {
    let data: CategoryDataDTO
}

// MARK: - CategoryDataDTO
struct CategoryDataDTO: Codable {
    let id: Int
    let attributes: CategoryAttributesDTO
}

// MARK: - CategoryAttributesDTO
struct CategoryAttributesDTO: Codable {
    let name: String
    let icon: String
    let createdAt: String
    let updatedAt: String
}

// MARK: - MetaDTO
struct MetaDTO: Codable {
    let pagination: PaginationDTO
}

// MARK: - PaginationDTO
struct PaginationDTO: Codable {
    let page: Int
    let pageSize: Int
    let pageCount: Int
    let total: Int
}

extension ShowDataDTO {
    func toModel() -> ShowModel {
        let banner = ShowModel.BannerModel(
            id: attributes.banner?.data.id ?? 0,
            url: attributes.banner?.data.attributes.url
        )
        let category = ShowModel.CategoryModel(
            id: attributes.category?.data.id ?? 0,
            name: attributes.category?.data.attributes.name ?? ""
        )
        
        let photos = attributes.photos?.data?.map({ photo in
            ShowModel.PhotoModel(id: photo.id, url: photo.attributes.url)
        }) ?? []
        
        var socialMediaLinks: [ShowModel.SocialMediaModel] = []
        
        if let facebookLink = attributes.facebook {
            socialMediaLinks.append(ShowModel.SocialMediaModel(id: "facebook", name: "Facebook", link: facebookLink))
        }
        
        if let instagramLink = attributes.instagram {
            socialMediaLinks.append(ShowModel.SocialMediaModel(id: "instagram", name: "Instagram", link: instagramLink))
        }
        
        if let tiktokLink = attributes.tiktok {
            socialMediaLinks.append(ShowModel.SocialMediaModel(id: "tiktok", name: "Tiktok", link: tiktokLink))
        }
        
        if let youtubeLink = attributes.youtube {
            socialMediaLinks.append(ShowModel.SocialMediaModel(id: "youtube", name: "Youtube", link: youtubeLink))
        }
        
        return ShowModel(
            id: id,
            title: attributes.title,
            description: attributes.description ?? "",
            city: attributes.city,
            banner: banner,
            category: category,
            photos: photos,
            whatsapp: attributes.whatsapp,
            socialMedia: socialMediaLinks
        )
    }
}
