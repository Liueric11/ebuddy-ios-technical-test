//
//  ContentView.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 20/12/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showLoginView: Bool = false
    
    var body: some View {
        ZStack{
            NavigationStack{
                ProfileView(showLoginView: $showLoginView)
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
    }
}

#Preview {
    ContentView()
}
