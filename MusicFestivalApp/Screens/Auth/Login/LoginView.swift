import SwiftUI

struct LoginView: View {
    @StateObject private var loginVM = LoginViewModel(
        service: AuthService(),
        keyChain: KeyChainManager(secureStore: SecureStore()))
    
    var body: some View {
        VStack{
            Form{
                Section(header: Text("USERNAME")){
                    TextField("Username", text: $loginVM.username)
                }
                Section(header: Text("PASSWORD")){
                    SecureField("Password", text: $loginVM.password)
                }
            }.textInputAutocapitalization(.never)
          
            Button(action : {
                Task{
                    await loginVM.login()
                }
            }, label: {
                Text("Login")
                    .frame(maxWidth: .infinity)
            }).modifier(StandardTintButtonStyle())
            
            NavigationLink (destination: RegisterView(), label: {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.purple)
                    .frame(height: 53)
                    .overlay(
                        Text("Create Account")
                            .foregroundColor(.white)
                    )
                    .padding([.leading, .trailing])
            })
          
            Group{
                if(loginVM.roleName == "ADMIN" && loginVM.isAuthenticated){
                    NavigationLink(destination: AdminTabView().navigationBarBackButtonHidden(true), isActive: $loginVM.isAuthenticated) { EmptyView() }
                    
                }
                if(loginVM.roleName == "BASIC" && loginVM.isAuthenticated){
                    NavigationLink(destination: UserTabView().navigationBarBackButtonHidden(true), isActive: $loginVM.isAuthenticated) { EmptyView() }
                }
            }
            
        }.navigationTitle("Login")
        .alert(item: $loginVM.alertItem, content: { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
            LoginView()
    }
}


