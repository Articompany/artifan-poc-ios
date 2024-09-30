//
//  EnvironmentValues+Coordinator.swift
//  NavigationCoordinatorDemo
//
//  Created by Alex Nagy on 12.03.2024.
//

import SwiftUI

extension EnvironmentValues {
    var navigation: Navigation {
        get {
            return self[NavigationKey.self]
        }
        set {
            self[NavigationKey.self] = newValue
        }
    }
}
