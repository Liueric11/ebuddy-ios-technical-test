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
            return AuthDataResultModel(
                uid: authResult.user.uid,
                email: authResult.user.email,
                photoURL: authResult.user.photoURL?.absoluteString
            )
        } catch let error as NSError {
            if error.code == AuthErrorCode.userNotFound.rawValue {
                let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
                return AuthDataResultModel(
                    uid: authDataResult.user.uid,
                    email: authDataResult.user.email,
                    photoURL: authDataResult.user.photoURL?.absoluteString
                )
            } else {
                throw error
            }
        }
    
    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(uid: user.uid, email: user.email, photoURL: user.photoURL?.absoluteString)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
}
