//
//  ProfileView.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showErrorModal = false
    @Binding var showLoginView: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let user = viewModel.user {
                Text("UID: \(user.id ?? "N/A")")
                    .font(.headline)
                Text("Email: \(user.email ?? "N/A")")
                    .font(.subheadline)
                Text("Phone: \(user.phoneNumber ?? "N/A")")
                    .font(.subheadline)
                Text("Gender: \(user.gender != nil ? (user.gender == .male ? "Male" : "Female") : "N/A")")
                    .font(.subheadline)
            } else if viewModel.isLoading {
                ProgressView("Loading...").progressViewStyle(CircularProgressViewStyle())
            } else {
                Text("No user data available.")
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button{
                Task {
                    do {
                        try AuthenticationManager.shared.signOut()
                        self.showLoginView = true
                    } catch {
                        
                    }
                }
            }label:{
                Text("logout")
            }
        }
        .onAppear {
            viewModel.getUserDetail()
        }
        .alert(isPresented: $showErrorModal) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "Unknown error occurred"),
                dismissButton: .default(Text("OK"))
            )
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView("Saving...").progressViewStyle(
                    CircularProgressViewStyle())
            }
        }
        .onChange(of: viewModel.errorMessage) { oldValue, newValue in
            if newValue != nil {
                showErrorModal = true
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .navigationTitle("Profile")
    }
}

#Preview {
    NavigationStack{
        ProfileView(showLoginView: .constant(false))
    }
}
