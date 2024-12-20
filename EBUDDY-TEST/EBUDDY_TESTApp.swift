//
//  EBUDDY_TESTApp.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 20/12/24.
//

import SwiftUI
import Firebase

@main
struct EBUDDY_TESTApp: App {
    
    init () {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
