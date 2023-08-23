import SwiftUI

extension UIColor {
    static let textFieldBorderColor: UIColor = .init(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
    static let textFieldIconColor: UIColor = .init(red: 178/255, green: 178/255, blue: 178/255, alpha: 1)
}

struct ContentView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Email: \(email)")
            Text("Password: \(password)")
            Spacer()
                .frame(height: 50)
            IconTextField(iconSystemName: "envelope") {
                TextField("Enter e-mail address", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            IconTextField(iconSystemName: "lock") {
                SecureField("Enter password", text: $password)
                    .textContentType(.password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
        }
        .padding()
    }
}

struct IconTextField<Content: View>: View {
    let iconSystemName: String
    @ViewBuilder let textField: () -> Content
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: iconSystemName)
                .imageScale(.medium)
                .foregroundColor(Color(.textFieldIconColor))
            textField()
        }
        .padding()
        .overlay {
            Capsule(style: .circular)
                .stroke(Color(.textFieldBorderColor), lineWidth: 2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
