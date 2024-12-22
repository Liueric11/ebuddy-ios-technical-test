//
//  SettingViewModel.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 22/12/24.
//

import Foundation

@MainActor
final class SettingViewModel: ObservableObject {
    var signInUseCase = SignInUseCase(
        repository: UserDataRepository()
    )
    
    @Published var uid: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var gender: GenderEnum = .male
    @Published var isLoading = false
    @Published var isSuccess = false
    @Published var errorMessage: String?
    
    func initialize(user: UserJSON?) {
        if let user = user {
            self.uid = user.id ?? ""
            self.email = user.email ?? ""
            self.phone = user.phoneNumber ?? ""
            self.gender = user.gender ?? .male
        }
    }
    
    func updateUserDetail() {
        guard !uid.isEmpty else { return }
        self.isLoading = true
        
        Task {
            do {
                try await FirestoreManager.shared.updateUserData(
                    uid: uid,
                    email: email,
                    phone: phone,
                    gender: gender.rawValue
                )
                self.isLoading = false
                self.isSuccess = true
            } catch {
                self.isLoading = false
                self.isSuccess = false
                self.errorMessage = "error update data"
            }
        }
    }

}
