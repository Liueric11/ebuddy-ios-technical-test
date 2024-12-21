//
//  AuthDataResultModel.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 20/12/24.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoURL: String?
    
    init(uid: String, email: String?, photoURL: String?){
        self.uid = uid
        self.email = email
        self.photoURL = photoURL
    }
}
