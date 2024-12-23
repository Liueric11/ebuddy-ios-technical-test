//
//  LoginViewModel.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 20/12/24.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    var signInUseCase = SignInUseCase(
        repository: UserDataRepository()
    )
    
    @Published var email: String = ""
    @Published var password: String = ""

    @Published var isSuccess = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else { return }
        self.isLoading = true
        
        Task {
            do {
                let result = try await signInUseCase.execute(
                    email: email.trimmingCharacters(in: .whitespaces),
                    password: password
                )
                self.isLoading = false
                self.isSuccess = result
                self.errorMessage = result ? nil : "Invalid credentials"
            } catch{
                self.isLoading = false
                self.isSuccess = false
                self.errorMessage = "Invalid credentials"
            }
        }
    }
}
