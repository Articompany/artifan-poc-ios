//
//  ArtistModel.swift
//  Artifan-POC
//
//  Created by Victor Castro on 28/09/24.
//

import Foundation

struct ArtistModel: Identifiable {
    let id: String
    let name: String
    let city: String
    let description: String
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
        let id: String
        let name: String
    }
}

extension ArtistModel: AFGridItemProtocol {
    var gridID: String { id }
    var gridTitle: String { name }
    var gridImage: String { banner.largeURL }
}
