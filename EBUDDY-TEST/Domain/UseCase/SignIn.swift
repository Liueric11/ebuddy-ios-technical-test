//
//  SignIn.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import Foundation

protocol SignInProtocol {
    func execute(
        email: String,
        password: String
    ) async throws -> Bool
}

struct SignInUseCase: SignInProtocol {
    var repository: UserDataRepositoryProtocol
        
    func execute(
        email: String,
        password: String
    ) async throws -> Bool {
        let result = await repository.signIn(email: email, password: password)
        return result
    }
}
