//
//  UserDataSourceProtocol.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import Foundation

protocol UserDataSourceProtocol {
    func signIn(email: String, password: String) async -> Bool
    func currentUser() throws -> AuthDataResultModel
    func logout() throws
    func userDetail() async throws -> UserJSON
}
