//
//  ShowModel.swift
//  Artifan-POC
//
//  Created by Victor Castro on 10/08/24.
//

import Foundation

// MARK: - ShowResponse
struct ShowResponse: Codable {
    let data: [Show]
    let meta: Meta
}

// MARK: - Show
struct Show: Codable, Identifiable {
    let id: Int
    let attributes: ShowAttributes
}

// MARK: - ShowAttributes
struct ShowAttributes: Codable {
    let title: String
    let description: String
    let city: String
    let banner: Banner?
    let category: Category?
}

// MARK: - Banner
struct Banner: Codable {
    let data: BannerData?
}

// MARK: - BannerData
struct BannerData: Codable {
    let id: Int
    let attributes: BannerAttributes
}

// MARK: - BannerAttributes
struct BannerAttributes: Codable {
    let url: String
}

// MARK: - Category
struct Category: Codable {
    let data: CategoryData
}

// MARK: - CategoryData
struct CategoryData: Codable {
    let id: Int
    let attributes: CategoryAttributes
}

// MARK: - CategoryAttributes
struct CategoryAttributes: Codable {
    let name: String
}

// MARK: - Meta
struct Meta: Codable {
    let pagination: Pagination
}

// MARK: - Pagination
struct Pagination: Codable {
    let page, pageSize, pageCount, total: Int
}
