//
//  CurrentUser.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import Foundation

protocol CurrentUserProtocol {
    func execute() throws -> AuthDataResultModel
}

struct CurrentUserUseCase: CurrentUserProtocol {
    var repository: UserDataRepositoryProtocol
        
    func execute() throws -> AuthDataResultModel {
        let result = try repository.currentUser()
        return result
    }
}
