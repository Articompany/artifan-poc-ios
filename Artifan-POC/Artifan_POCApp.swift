//
//  Artifan_POCApp.swift
//  Artifan-POC
//
//  Created by Victor Castro on 10/08/24.
//

import SwiftUI

@main
struct Artifan_POCApp: App {
    
    @StateObject private var coordinator = CoordinatorManager()
    
    var body: some Scene {
        WindowGroup {
            coordinator.contentView()
             .preferredColorScheme(.light)
        }
    }
}
