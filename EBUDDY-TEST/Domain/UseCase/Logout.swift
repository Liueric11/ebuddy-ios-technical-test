//
//  Logout.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import Foundation

protocol LogoutProtocol {
    func execute() throws
}

struct LogoutUseCase: LogoutProtocol {
    var repository: UserDataRepositoryProtocol
        
    func execute() throws {
        try repository.logout()
    }
}
