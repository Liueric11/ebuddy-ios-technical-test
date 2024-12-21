//
//  ProfileView.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showErrorModal = false
    @State private var selectedItem: PhotosPickerItem? = nil
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
                
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    Text("Select a photo")
                        .font(.subheadline)
                }
                
                if let urlString = user.profileImage, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 150, height: 150)
                    }
                }
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
        .onChange(of: selectedItem) { oldValue, newValue in
            if let newValue {
                viewModel.saveProfileImage(item: newValue)
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
