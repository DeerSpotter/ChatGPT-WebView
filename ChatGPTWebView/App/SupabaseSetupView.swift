import SwiftUI

struct SupabaseSetupView: View {
    @EnvironmentObject private var appModel: AppModel
    @State private var projectURLText = ""
    @State private var publishableKey = ""

    var body: some View {
        NavigationView {
            Form {
                Section("Your Supabase Project") {
                    TextField("https://project-ref.supabase.co", text: $projectURLText)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.URL)
                        .autocorrectionDisabled()

                    SecureField("Publishable key", text: $publishableKey)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    Button("Save Supabase Project") {
                        appModel.saveConfig(
                            projectURLText: projectURLText,
                            publishableKey: publishableKey
                        )
                    }
                    .disabled(projectURLText.isEmpty || publishableKey.isEmpty)
                }

                Section("Important") {
                    Text("Use your own Supabase project. Do not paste a secret key or service role key into the app.")
                    Text("The memory schema and Edge Function must be deployed to this project before memory search/save will work.")
                }

                Section("Required Callback URL") {
                    Text("Add this under Supabase Authentication URL Configuration:")
                    Text("chatgptwebview://auth-callback")
                        .font(.system(.footnote, design: .monospaced))
                }

                Section("Status") {
                    if appModel.isBusy {
                        ProgressView()
                    }
                    Text(appModel.statusMessage.isEmpty ? "Add a Supabase project to continue." : appModel.statusMessage)
                        .font(.footnote)
                }
            }
            .navigationTitle("Supabase Setup")
        }
        .onAppear {
            if let config = appModel.configStore.config {
                projectURLText = config.projectURL.absoluteString
                publishableKey = config.publishableKey
            }
        }
    }
}
