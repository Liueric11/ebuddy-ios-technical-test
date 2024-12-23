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
        TabView {
            NavigationStack(path: $routerManager.routes) {
                ProfileView(showLoginView: $showLoginView)
                    .navigationDestination(for: Route.self) { $0 }
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
            .environmentObject(profileViewModel)
            .environmentObject(routerManager)
            
            NavigationStack{
                UsersListView()
            }
            .tabItem {
                Label("Users", systemImage: "list.dash")
            }
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
        .onChange(of: showLoginView) { newValue, oldValue in
            profileViewModel.getUserDetail()
        }
    }
}

#Preview {
    ContentView()
}
