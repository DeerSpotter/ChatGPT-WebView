import SwiftUI

struct SupabaseSetupView: View {
    @EnvironmentObject private var appModel: AppModel
    @State private var projectURLText = ""
    @State private var publishableKey = ""
    @State private var setupLink = ""

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

                    Button("Run Diagnostics") {
                        Task {
                            await appModel.runDiagnostics(
                                projectURLText: projectURLText,
                                publishableKey: publishableKey
                            )
                        }
                    }
                    .disabled(appModel.isBusy || projectURLText.isEmpty || publishableKey.isEmpty)

                    Button("Save Supabase Project") {
                        appModel.saveConfig(
                            projectURLText: projectURLText,
                            publishableKey: publishableKey
                        )
                    }
                    .disabled(projectURLText.isEmpty || publishableKey.isEmpty)
                }

                Section("Diagnostics") {
                    if appModel.diagnostics.isEmpty {
                        Text("Run diagnostics before logging in. The app will check the project URL, publishable key, auth settings, and memory function.")
                            .font(.footnote)
                    } else {
                        ForEach(appModel.diagnostics) { item in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(item.status.rawValue)
                                        .font(.caption)
                                        .bold()
                                    Text(item.name)
                                        .font(.headline)
                                }
                                Text(item.detail)
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                Section("Import Setup Link") {
                    Text("Advanced setup can be imported with a link like this. It must include only the project URL and publishable key.")
                        .font(.footnote)

                    Button("Generate Setup Link Preview") {
                        setupLink = appModel.setupDeepLink(
                            projectURLText: projectURLText,
                            publishableKey: publishableKey
                        ) ?? "Invalid project URL or key."
                    }
                    .disabled(projectURLText.isEmpty || publishableKey.isEmpty)

                    if !setupLink.isEmpty {
                        Text(setupLink)
                            .font(.system(.caption, design: .monospaced))
                            .textSelection(.enabled)
                    }
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
