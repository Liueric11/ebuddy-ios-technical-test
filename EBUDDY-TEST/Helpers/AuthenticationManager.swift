//
//  AuthenticationManager.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 20/12/24.
//

import Foundation
import FirebaseAuth

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() {}
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            return AuthDataResultModel(user: authResult.user)
        } catch let error as NSError {
            if error.code == AuthErrorCode.userNotFound.rawValue {
                let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
                return AuthDataResultModel(user: authDataResult.user)
            } else {
                throw error
            }
        }
    
    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        try  Auth.auth().signOut()
    }
    
}
