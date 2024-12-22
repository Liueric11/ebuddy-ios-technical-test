//
//  SettingView.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 22/12/24.
//

import SwiftUI
import PhotosUI

struct SettingView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject private var routeManager: NavigationRouter
    @StateObject private var settingViewModel = SettingViewModel()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var showErrorModal = false
    @Binding var showLoginView: Bool
    
    var body: some View {
        VStack{
            TextField("Email...", text: $settingViewModel.email)
                .padding()
                .background(Color.gray.opacity(0.6))
                .cornerRadius(10)
            
            TextField("Phone...", text: $settingViewModel.phone)
                .keyboardType(.numberPad)
                .onChange(of: settingViewModel.phone) { newValue, oldValue in
                    settingViewModel.phone = newValue.filter { $0.isNumber }
                }
                .padding()
                .background(Color.gray.opacity(0.6))
                .cornerRadius(10)
            
            HStack {
                Text("Select Gender")
                    .font(.headline)
                    .foregroundStyle(Color.gray.opacity(0.6))
                
                Spacer()
                
                Picker("Select Gender", selection: $settingViewModel.gender) {
                    ForEach(GenderEnum.allCases, id: \.self) { gender in
                        Text(gender.displayName).tag(gender)
                    }
                }
                .pickerStyle(.menu)
            }
            .padding()
            
            if let user = profileViewModel.user {
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
                
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    Text("Select a photo")
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Button{
                Task {
                    do {
                        try AuthenticationManager.shared.signOut()
                        self.showLoginView = true
                        routeManager.reset()
                    } catch {

                    }
                }
            }label:{
                Text("logout")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button{
                settingViewModel.updateUserDetail()
            } label: {
                Text("Ubah")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            settingViewModel.initialize(user: profileViewModel.user)
        }
        .alert(isPresented: $showErrorModal) {
            Alert(
                title: Text("Error"),
                message: Text(settingViewModel.errorMessage ?? "Unknown error occurred"),
                dismissButton: .default(Text("OK"))
            )
        }
        .overlay {
            if settingViewModel.isLoading {
                ProgressView("Saving...").progressViewStyle(
                    CircularProgressViewStyle())
            }
        }
        .onChange(of: settingViewModel.errorMessage) { oldValue, newValue in
            if newValue != nil {
                showErrorModal = true
            }
        }
        .onChange(of: settingViewModel.isSuccess) { oldValue, newValue in
            if newValue {
                profileViewModel.getUserDetail()
                routeManager.goBack()
            }
        }
        .onChange(of: selectedItem) { oldValue, newValue in
            if let newValue {
                profileViewModel.saveProfileImage(item: newValue)
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var routerManager = NavigationRouter()
    @Previewable @StateObject var profileViewModel = ProfileViewModel()
        
    NavigationStack(path: $routerManager.routes){
        SettingView(showLoginView: .constant(false))
            .navigationDestination(for: Route.self) { $0 }
    }
    .environmentObject(routerManager)
    .environmentObject(profileViewModel)
}
