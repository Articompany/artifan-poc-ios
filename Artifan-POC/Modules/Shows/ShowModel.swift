//
//  ShowModel.swift
//  Artifan-POC
//
//  Created by Victor Castro on 14/08/24.
//

import Foundation

struct ShowModel: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String
    let city: String
    let banner: BannerModel?
    let category: CategoryModel?
    let photos: [PhotoModel]?
    let whatsapp: Int?
    let socialMedia: [SocialMediaModel]?
    
    struct BannerModel: Codable {
        let id: Int
        let url: String?
    }
    
    struct CategoryModel: Codable {
        let id: Int
        let name: String
    }
    
    struct PhotoModel: Codable {
        let id: Int
        let url: String
    }
    
    struct SocialMediaModel: Codable, Identifiable {
        let id: String
        let name: String
        let link: String
    }
}
