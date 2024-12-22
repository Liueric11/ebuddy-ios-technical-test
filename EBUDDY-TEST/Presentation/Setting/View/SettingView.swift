//
//  SettingView.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 22/12/24.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject private var routeManager: NavigationRouter
    @StateObject private var settingViewModel = SettingViewModel()
    @State private var showErrorModal = false
    
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
    }
}

#Preview {
    @Previewable @StateObject var routerManager = NavigationRouter()
    @Previewable @StateObject var profileViewModel = ProfileViewModel()
        
    NavigationStack(path: $routerManager.routes){
        SettingView()
            .navigationDestination(for: Route.self) { $0 }
    }
    .environmentObject(routerManager)
    .environmentObject(profileViewModel)
}
