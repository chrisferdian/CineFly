//
//  NavigationManager.swift
//  CineFly
//
//  Created by chris on 16/09/25.
//

import Combine
import SwiftUI

final class NavigationManager: ObservableObject {
    @Published var path: [ViewRouter] = []

    func push(_ route: ViewRouter) {
        path.append(route)
    }

    func pop() {
        _ = path.popLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}

private struct NavigationManagerKey: EnvironmentKey {
    static let defaultValue: NavigationManager = NavigationManager()
}

extension EnvironmentValues {
    var nav: NavigationManager {
        get { self[NavigationManagerKey.self] }
        set { self[NavigationManagerKey.self] = newValue }
    }
}
