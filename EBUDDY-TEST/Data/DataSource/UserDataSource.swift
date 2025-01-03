//
//  UserDataSource.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import Foundation
import Firebase

struct UserDataSource: UserDataSourceProtocol {
    func signIn(email: String, password: String) async -> Bool {
        do {
            let _ = try await AuthenticationManager.shared.createUser(email: email, password: password)
            return true
        } catch{
            return false
        }
    }
    
    func currentUser() throws -> AuthDataResultModel {
        guard let user = try? AuthenticationManager.shared.getAuthenticatedUser() else {
            throw URLError(.badServerResponse)
        }
        return user
    }
    
    func logout() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func userDetail() async throws -> UserJSON {
        guard let userData = try? AuthenticationManager.shared.getAuthenticatedUser() else {
            throw URLError(.badServerResponse)
        }
        
        let user = try await FirestoreManager.shared.fetchUser(uid: userData.uid)
        return user
    }
}
