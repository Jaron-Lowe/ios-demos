import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        return StyleView(configuration: configuration)
    }
}

private extension SecondaryButtonStyle {
    struct StyleView: View {
        @Environment(\.isEnabled) var isEnabled
        
        let configuration: SecondaryButtonStyle.Configuration
        
        var body: some View {
            HStack {
                Spacer()
                configuration.label
                    .foregroundColor(Color.primary500)
                    .font(.system(size: 20.0, weight: .semibold))
                Spacer()
            }
            .padding([.top, .leading, .bottom, .trailing], 13.0)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.primary500, lineWidth: 2)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            
        }
    }
}
