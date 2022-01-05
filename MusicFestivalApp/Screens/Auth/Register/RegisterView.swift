import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var userInfo: UserSensitiveData
    @StateObject private var registerVM = RegisterViewModel(service: AuthService())
    
    var body: some View {
        VStack{
            Form{
                Section(header: Text("USERNAME")){
                    TextField("Username", text: $registerVM.username){
                    }
                    if(!registerVM.username.isValidUsername){
                        Text(registerVM.usernamePrompt)
                            .font(.caption)
                    }
                }
                Section(header: Text("PASSWORD")){
                    SecureField("Password", text: $registerVM.password)
                    if(!registerVM.password.isValidPassword){
                        Text(registerVM.passwordPrompt)
                            .font(.caption)
                    }
                    SecureField("Confirm Password", text: $registerVM.confirmPassword)
                    if(!registerVM.passwordsMatch()){
                        Text(registerVM.confirmPwPrompt)
                            .font(.caption)
                    }
                }
                Section(header: Text("EMAIL")){
                    TextField("Email", text: $registerVM.email)
                    if(!registerVM.email.isValidEmail){
                        Text(registerVM.emailPrompt)
                            .font(.caption)
                    }
                }
            }.textInputAutocapitalization(.never)
            
            Button(action : {
                Task{
                    await registerVM.register()
                }
            }, label: {
                Text("Register")
                    .frame(maxWidth: .infinity)
            }).disabled(!registerVM.isRegisterComplete)
            .padding()
            .buttonStyle(.bordered)
            .tint(.accentColor)
            .controlSize(.large)
            
            if(registerVM.isRegistered){
                NavigationLink(destination: LoginView(), isActive: $registerVM.isRegistered) { EmptyView() }
            }
            
        }.navigationTitle("Register")
        .alert(item: $registerVM.alertItem, content: { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        })
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
