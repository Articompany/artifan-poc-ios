//
//  NavigationKey.swift
//  NavigationCoordinatorDemo
//
//  Created by Alex Nagy on 12.03.2024.
//

import SwiftUI

struct NavigationKey: @preconcurrency EnvironmentKey {
    @MainActor
    static let defaultValue = Navigation()
}
