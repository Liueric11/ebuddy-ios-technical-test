//
//  Route.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 22/12/24.
//

import Foundation
import SwiftUI

enum Route {
    case contentView
    case settingView(showLoginView: Binding<Bool>)
}

extension Route: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs) {
        case (.contentView, .contentView):
            return true
        case (.settingView, .settingView):
            return true
        default:
            return false
        }
    }
}

extension Route: View {
    
    var body: some View {
        
        switch self {
        case .contentView:
            ContentView()
        case .settingView(let showLoginView):
            SettingView(showLoginView: showLoginView)
        }
    }
}

