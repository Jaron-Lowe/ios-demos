import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        return StyleView(configuration: configuration)
    }
}

private extension PrimaryButtonStyle {
    struct StyleView: View {
        @Environment(\.isEnabled) var isEnabled
        
        let configuration: PrimaryButtonStyle.Configuration
        
        var body: some View {
            HStack {
                Spacer()
                configuration.label
                    .foregroundColor(Color.onPrimary500)
                    .font(.system(size: 20.0, weight: .semibold))
                Spacer()
            }
            .padding(.all, 13.0)
            .background(
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(isEnabled ? Color.primary500 : Color.primary500.opacity(0.56))
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
        }
    }
}
