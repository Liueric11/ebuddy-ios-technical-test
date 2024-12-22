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
        VStack(spacing: 8){
            VStack(spacing: 4){
                Text("Username")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Username...", text: $settingViewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(spacing: 4){
                Text("Email")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Email...", text: $settingViewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(spacing: 4){
                Text("Phone Number")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Phone...", text: $settingViewModel.phone)
                    .keyboardType(.numberPad)
                    .onChange(of: settingViewModel.phone) { newValue, oldValue in
                        settingViewModel.phone = newValue.filter { $0.isNumber }
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(spacing: 4){
                Text("Pricing")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Pricing...", value: $settingViewModel.pricing, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }
            

            
            HStack {
                Text("Select Gender")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                
                Spacer()
                
                Picker("Select Gender", selection: $settingViewModel.gender) {
                    ForEach(GenderEnum.allCases, id: \.self) { gender in
                        Text(gender.displayName).tag(gender)
                    }
                }
                .pickerStyle(.menu)
            }
            
            if let user = profileViewModel.user {
                VStack{
                    Text("Photo Profile")
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack{
                        if let urlString = user.profileImage, let url = URL(string: urlString) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .scaledToFit()
                                    .cornerRadius(10)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 150, height: 150)
                            }
                        } else {
                            Image(systemName: "photo.fill")
                                .resizable()
                                .frame(width: 150, height: 150)
                                .cornerRadius(40)
                        }
                        
                        Spacer()
                        
                        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                            Text("Select a photo")
                                .font(.subheadline)
                        }
                    }
                }
            }
            
            Spacer()
            
            Button{
                Task {
                    do {
                        try AuthenticationManager.shared.signOut()
                        self.showLoginView = true
                        routeManager.reset()
                    } catch {

                    }
                }
            } label: {
                Text("Logout")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(10)
            }
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    settingViewModel.updateUserDetail()
                }
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
