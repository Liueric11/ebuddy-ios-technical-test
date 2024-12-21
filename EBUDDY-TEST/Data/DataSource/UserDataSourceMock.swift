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
}
