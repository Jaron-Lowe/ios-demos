import SwiftUI

struct CloseBar: View {
    enum Style {
        case xButton
        case doneButton
    }
    
    private let style: Style
    private let closeAction: (() -> Void)?

    init(style: Style = .xButton, closeAction: (() -> Void)? = nil) {
        self.style = style
        self.closeAction = closeAction
    }
    
    var body: some View {
        HStack {
            switch style {
            case .xButton:
                Button {
                    closeAction?()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.primary500)
                }
                Spacer()
            case .doneButton:
                Spacer()
                Button("Done") {
                    closeAction?()
                }
                .font(.system(size: 16.0, weight: .semibold))
                .foregroundColor(.primary500)
            }
        }
        .background(Color.white)
        .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
        .frame(maxWidth: .infinity)
    }
}

struct CloseBar_Previews: PreviewProvider {
    static var previews: some View {
        CloseBar(style: .xButton)
            .previewLayout(.sizeThatFits)
        CloseBar(style: .doneButton)
            .previewLayout(.sizeThatFits)
    }
}
