//
//  LoginView.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 26.02.2023.
//

import SwiftUI

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack {
                    Image("uber")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 266)
                    
                    VStack(spacing: 32) {
                        // email
                        CustomInputField(text: $email, title: "Email Address", placeholder: "name@example.com")
                        // password
                        CustomInputField(text: $password, title: "Password", placeholder: "Enter your password", isSecureFiled: false)
                    }
                    .padding(.horizontal)
                    
                    // forgot password
                    Button {
                        
                    } label: {
                        Text("Forgot Password ?")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.top, 25)
                            .padding(.trailing, 28)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    // sign in with social
                    VStack {
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color(.init(white: 1, alpha: 0.3)))
                                .frame(width: UIScreen.main.bounds.width - 32, height: 0.7)
                            
                            Text("Sign in with social")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .background {
                                    Rectangle()
                                        .fill(Color.black)
                                }
                        }
                        .padding(.vertical)
                        
                        // face - google
                        HStack(spacing: 30) {
                            Button {
                                
                            } label: {
                                Image("face")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }

                            Button {
                                
                            } label: {
                                Image("google")
                                    .resizable()
                                    .frame(width: 45, height: 45)
                            }
                        }
                    }.padding(.bottom, 30)
                    
                    // sign in
                    Button {
                        authViewModel.signIn(withEmail: email, password: password)
                    } label: {
                        HStack {
                            Text("SIGN IN")
                                .foregroundColor(.black)
                                .font(.callout)
                                .fontWeight(.semibold)
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                        .background {
                            Rectangle()
                                .fill(.white)
                                .cornerRadius(10)
                                
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink {
                        RegistirationView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack {
                            Text("Don't have an account ?")
                                .font(.footnote)
                                .foregroundColor(.white)
                            Text("Sign Up")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
