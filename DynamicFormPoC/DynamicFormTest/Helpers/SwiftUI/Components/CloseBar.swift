import SwiftUI

struct CloseBar: View {
    private let closeAction: (() -> Void)?

    init(closeAction: (() -> Void)? = nil) {
        self.closeAction = closeAction
    }
    
    var body: some View {
        HStack {
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
        }
        .background(Color.white)
        .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
        .frame(maxWidth: .infinity)
    }
}

struct CloseBar_Previews: PreviewProvider {
    static var previews: some View {
        CloseBar()
    }
}
