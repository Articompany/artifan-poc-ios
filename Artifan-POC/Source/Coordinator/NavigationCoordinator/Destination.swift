//
//  Destination.swift
//  NavigationCoordinator
//
//  Created by Alex Nagy on 13.02.2024.
//

import SwiftUI

struct Destination: RawRepresentable, Hashable, Equatable {
    var rawValue: String
    
    init(rawValue: String = UUID().uuidString) {
        self.rawValue = rawValue
    }
}
