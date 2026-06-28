import SwiftUI

struct AuthView: View {
    @EnvironmentObject private var appModel: AppModel
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationView {
            Form {
                Section("Supabase Sign In") {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()

                    SecureField("Password", text: $password)
                }

                Section {
                    Button("Sign In") {
                        Task { await appModel.signIn(email: email, password: password) }
                    }
                    .disabled(appModel.isBusy || email.isEmpty || password.isEmpty)

                    Button("Create Account") {
                        Task { await appModel.signUp(email: email, password: password) }
                    }
                    .disabled(appModel.isBusy || email.isEmpty || password.count < 6)
                }

                Section("Status") {
                    if appModel.isBusy {
                        ProgressView()
                    }
                    Text(appModel.statusMessage.isEmpty ? "Sign in to test Supabase memory." : appModel.statusMessage)
                        .font(.footnote)
                }
            }
            .navigationTitle("Memory Login")
        }
    }
}
