//
//  UserDetail.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import Foundation

protocol UserDetailProtocol {
    func execute() async throws -> UserJSON
}

struct UserDetailUseCase: UserDetailProtocol {
    var repository: UserDataRepositoryProtocol
        
    func execute() async throws -> UserJSON {
        let result = try await repository.userDetail()
        return result
    }
}
