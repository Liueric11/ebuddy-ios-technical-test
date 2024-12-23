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
    @State private var showErrorModal = false
    
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
                viewModel.signIn()
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
        .overlay {
            if viewModel.isLoading {
                ProgressView("loading...").progressViewStyle(
                    CircularProgressViewStyle())
            }
        }
        .alert(isPresented: $showErrorModal) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "Unknown error occurred"),
                dismissButton: .default(Text("OK"))
            )
        }
        .onChange(of: viewModel.errorMessage) { oldValue, newValue in
            if newValue != nil {
                showErrorModal = true
            }
        }
        .onChange(of: viewModel.isSuccess) { oldValue, newValue in
            if newValue {
                showLoginView = !newValue
            }
        }
    }
}

#Preview {
    NavigationStack{
        LoginView(showLoginView: .constant(false))
    }
}
