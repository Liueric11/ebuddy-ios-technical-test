//
//  UserDataSourceMock.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import Foundation
import FirebaseAuth

struct UserDataSourceMock: UserDataSourceProtocol {
    func signIn(email: String, password: String) async -> Bool {
        return true
    }
    
    func currentUser() throws -> AuthDataResultModel {
        return AuthDataResultModel(
            uid: "F912NhEjgwRgpw0acr4L",
            email: "ericfrndo@gmail.com",
            photoURL: nil
        )
    }
    
    func logout() throws {
    }
    
    func userDetail() async throws -> UserJSON {
        let user = UserJSON(id: "twvswqhFczTra66okhkBC9vEJ8f1", email: "ericfrndo@gmail.com", phoneNumber: "082213231071", gender: .male)
        return user
    }
}
