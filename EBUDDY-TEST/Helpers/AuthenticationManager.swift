//
//  AuthenticationManager.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 20/12/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

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
            if error.code == AuthErrorCode.userNotFound.rawValue || error.code == AuthErrorCode.invalidCredential.rawValue {
                let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
                var userData: [String:Any] = [
                    "uid": authDataResult.user.uid,
                    "phoneNumber": "",
                ]
                
                if let email = authDataResult.user.email {
                    userData["email"] = email
                }
                
                if let photoURL = authDataResult.user.photoURL {
                    userData["photoURL"] = photoURL.absoluteString
                }
                
                try await Firestore.firestore().collection("USERS").document(authDataResult.user.uid).setData(userData, merge: false)
                
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
