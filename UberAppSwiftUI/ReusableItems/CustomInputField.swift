//
//  CustomInputField.swift
//  UberAppSwiftUI
//
//  Created by Aykut ATABAY on 26.02.2023.
//

import SwiftUI

struct CustomInputField: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureFiled: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(.white)
                .font(.footnote)
                .fontWeight(.semibold)
            if isSecureFiled {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
            }

                
            Rectangle()
                .foregroundColor(Color(.init(white: 1, alpha: 0.3)))
                .frame(width: UIScreen.main.bounds.width - 32, height: 0.7)
            
        }
    }
}

struct CustomInputField_Previews: PreviewProvider {
    static var previews: some View {
        CustomInputField(text: .constant(""), title: "Email Address", placeholder: "name@example.com", isSecureFiled: true)
    }
}
