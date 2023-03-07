//
//  RegistirationView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 26.02.2023.
//

import SwiftUI

struct RegistirationView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 40) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .imageScale(.medium)
                        .padding(.horizontal)
                }
                
                Text("Create new account")
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .frame(width: 250, height: 100)
                
                VStack(spacing: 80) {
                    VStack(spacing: 56) {
                        CustomInputField(text: $fullName, title: "Full Name", placeholder: "Enter your name")
                        CustomInputField(text: $email, title: "Email", placeholder: "name@example.com")
                        CustomInputField(text: $password, title: "Create Password", placeholder: "Enter your password")
                        
                    }.padding(.horizontal, 21)

                    
                    Button {
                        authViewModel.registerUser(withEmail: email, password: password, fullName: fullName)
                    } label: {
                        HStack {
                            Text("SIGN UP")
                                .foregroundColor(.black)
                                .font(.callout)
                                .fontWeight(.semibold)
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 45)
                        .background {
                            Rectangle()
                                .fill(.white)
                                .cornerRadius(10)
                                
                        }
                    }
                    Spacer()
                }
            }
            .foregroundColor(.white)
        }
    }
}

struct RegistirationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistirationView()
    }
}
