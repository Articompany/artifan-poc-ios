//
//  ArtistModel.swift
//  Artifan-POC
//
//  Created by Victor Castro on 28/09/24.
//

import Foundation

struct ArtistModel: Identifiable {
    let id: Int
    let name: String
    let city: String
    let banner: Banner
    let category: Category
    
    struct Banner {
        let url: String
        let largeURL: String
        let smallURL: String
        let mediumURL: String
        let thumbnail: String
    }
    
    struct Category {
        let id: Int
        let name: String
    }
}

extension ArtistModel: GridItemProtocol {
    var title: String { name }
    var image: String { banner.largeURL }
}
