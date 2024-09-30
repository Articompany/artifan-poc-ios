//
//  CoordinatorManager.swift
//  Artifan-POC
//
//  Created by Victor Castro on 29/09/24.
//

import SwiftUI

@MainActor
class CoordinatorManager: ObservableObject {
    
    @Published var root: AppRootScreens = .splash
    
    enum AppRootScreens {
        case splash
        case dashboard
//        case signUp
//        case login
//        case privateZone
    }
    
    func contentView() -> some View {
        Group {
            switch root {
            case .splash:
                NavigationRoot(.splash)
                
            case .dashboard:
                NavigationRoot(.dashboard)
                
//            case .signUp:
//                NavigationRoot(.signUp)
//                
//            case .login:
//                NavigationRoot(.login)
//                
//            case .privateZone:
//                NavigationRoot(.privateZone)
            }
        }
        .environmentObject(self)
    }
}
