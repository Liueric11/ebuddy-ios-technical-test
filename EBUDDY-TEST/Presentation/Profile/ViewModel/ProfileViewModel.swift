//
//  ProfileViewModel.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    var userDetailUseCase = UserDetailUseCase(
        repository: UserDataRepository()
    )
    
    @Published var user: UserJSON? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func getUserDetail() {
        self.isLoading = true
        
        Task {
            do {
                let userDetail = try await userDetailUseCase.execute()
                self.isLoading = false
                self.user = userDetail
            } catch {
                self.isLoading = false
                self.errorMessage = "error get user data"
            }
        }
    }
}
