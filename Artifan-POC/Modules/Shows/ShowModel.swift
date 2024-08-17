//
//  ShowModel.swift
//  Artifan-POC
//
//  Created by Victor Castro on 14/08/24.
//

import Foundation

struct ShowModel: Identifiable {
    let id: Int
    let title: String
    let description: String
    let city: String
    let banner: Banner?
    let category: Category?
    
    struct Banner {
        let id: Int
        let url: String?
    }
    
    struct Category {
        let id: Int
        let name: String
    }
}
