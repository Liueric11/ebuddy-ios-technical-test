//
//  ContentView.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 20/12/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showLoginView: Bool = false
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var routerManager = NavigationRouter()
    
    var body: some View {
        ZStack{
            NavigationStack(path: $routerManager.routes){
                ProfileView(showLoginView: $showLoginView)
                    .navigationDestination(for: Route.self) { $0 }
            }
            .environmentObject(profileViewModel)
            .environmentObject(routerManager)
        }
        .onAppear{
            let user = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showLoginView = user == nil 
        }
        .fullScreenCover(isPresented: $showLoginView) {
            NavigationStack{
                LoginView(showLoginView: $showLoginView)
            }
        }
    }
}

#Preview {
    ContentView()
}
