//
//  UserDataRepository.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import Foundation

struct UserDataRepository: UserDataRepositoryProtocol {
    var dataSource: UserDataSourceProtocol

    init() {
        if ConfigManager.shared.getValue(forKey: "USE_MOCK_DATA") == "TRUE" {
            self.dataSource = UserDataSourceMock()
        } else {
            self.dataSource = UserDataSource()
        }
    }
    
    func signIn(email: String, password: String) async -> Bool {
        return await dataSource.signIn(email: email, password: password)
    }
    
    func currentUser() throws -> AuthDataResultModel {
        return try dataSource.currentUser()
    }
    
    func logout() throws {
        return try dataSource.logout()
    }
    
    func userDetail() async throws -> UserJSON {
        return try await dataSource.userDetail()
    }
}
