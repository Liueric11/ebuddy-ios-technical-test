//
//  ProfileView.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject private var routeManager: NavigationRouter
    @State private var showErrorModal = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @Binding var showLoginView: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if let user = profileViewModel.user {
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
                    
                    
                    NavigationLink {
                        VStack{
                            Text("test upload when in another screen")
                        }
                    } label: {
                        Text("next screen")
                    }
                    
                } else if profileViewModel.isLoading {
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
        }
        .refreshable {
            profileViewModel.getUserDetail()
        }
        .onAppear {
            profileViewModel.getUserDetail()
        }
        .alert(isPresented: $showErrorModal) {
            Alert(
                title: Text("Error"),
                message: Text(profileViewModel.errorMessage ?? "Unknown error occurred"),
                dismissButton: .default(Text("OK"))
            )
        }
        .overlay {
            if profileViewModel.isLoading {
                ProgressView("Saving...").progressViewStyle(
                    CircularProgressViewStyle())
            }
        }
        .onChange(of: profileViewModel.errorMessage) { oldValue, newValue in
            if newValue != nil {
                showErrorModal = true
            }
        }
        .onChange(of: selectedItem) { oldValue, newValue in
            if let newValue {
                profileViewModel.saveProfileImage(item: newValue)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button{
                    routeManager.push(to: .settingView)
                }label:{
                    Image(systemName: "gear")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var routerManager = NavigationRouter()
    @Previewable @StateObject var profileViewModel = ProfileViewModel()
        
    NavigationStack(path: $routerManager.routes){
        ProfileView(showLoginView: .constant(false))
            .navigationDestination(for: Route.self) { $0 }
    }
    .environmentObject(routerManager)
    .environmentObject(profileViewModel)
}
