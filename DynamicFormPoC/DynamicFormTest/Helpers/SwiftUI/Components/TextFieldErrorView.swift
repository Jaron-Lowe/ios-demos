import SwiftUI

struct TextFieldErrorView: View {
    let title: String
    
    var body: some View {
        HStack(spacing: 8.0) {
            Text(title)
                .font(.system(size: 13.0))
                .fontWeight(.bold)
                .foregroundColor(.errorRed)
                .minimumScaleFactor(0.8)
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.errorRed)
        }
    }
}

struct TextFieldErrorView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldErrorView(title: "Please enter a valid address")
            
    }
}
