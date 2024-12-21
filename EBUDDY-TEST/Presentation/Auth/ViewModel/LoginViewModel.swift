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
    
    func signIn() -> Bool {
        guard !email.isEmpty, !password.isEmpty else { return false }
        
        Task {
            do {
                let _ = try await signInUseCase.execute(email: email, password: password)
                return true
            } catch{
                return false
            }
        }
        
        return false
    }
}
