//
//  LoginView.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 20/12/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    @Binding var showLoginView: Bool
    
    var body: some View {
        VStack{
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.6))
                .cornerRadius(10)
            
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.6))
                .cornerRadius(10)
            
            Button{
                showLoginView = viewModel.signIn()
            } label: {
                Text("Login")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Login")
    }
}

#Preview {
    NavigationStack{
        LoginView(showLoginView: .constant(false))
    }
}
