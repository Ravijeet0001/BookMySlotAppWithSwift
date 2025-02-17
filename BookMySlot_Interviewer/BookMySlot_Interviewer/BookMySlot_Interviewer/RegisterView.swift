//
//  RegisterView.swift
//  BookMySlot_Interviewer
//
//  Created by admin on 15/02/25.
//

import SwiftUI
import CoreData

struct RegisterView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @State private var registrationSuccess = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Register")
                    .font(.largeTitle)
                    .padding()

                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.emailAddress)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Register") {
                    registerUser()
                }
                .buttonStyle(.borderedProminent)
                .padding()

                if registrationSuccess {
                    Text("Registration successful!")
                        .foregroundColor(.green)
                        .padding()
                    
                    NavigationLink("Go to Login", destination: LoginView())
                        .padding()
                }
            }
            .padding()
        }
    }

    private func registerUser() {
        guard !username.isEmpty, !password.isEmpty, !email.isEmpty else {
            print("All fields are required!")
            return
        }

        let newUser = User(context: viewContext)
        newUser.username = username
        newUser.password = password
        newUser.email = email

        do {
            try viewContext.save()
            registrationSuccess = true
            clearFields()
        } catch {
            print("Failed to register user: \(error.localizedDescription)")
        }
    }

    private func clearFields() {
        username = ""
        password = ""
        email = ""
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
