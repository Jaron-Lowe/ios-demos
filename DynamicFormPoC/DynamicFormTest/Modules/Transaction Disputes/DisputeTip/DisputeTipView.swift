import SwiftUI
import Combine

struct DisputeTipView: View {
    @ObservedObject private(set) var viewModel: DisputeTipViewModel
    
    // MARK: Inputs
    private let closeButtonTaps = PassthroughSubject<Void, Never>()
    private let primaryButtonTaps = PassthroughSubject<Void, Never>()
    
    // MARK: Init
    init(viewModel: DisputeTipViewModel) {
        self.viewModel = viewModel
        viewModel.bind(inputs: DisputeTipViewModel.Inputs(
            closeButtonTaps: closeButtonTaps.eraseToAnyPublisher(),
            primaryButtonTaps: primaryButtonTaps.eraseToAnyPublisher()
        ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CloseBar {
                closeButtonTaps.send()
            }
            VStack(spacing: 32.0) {
                Image(systemName: "info.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 130)
                    .foregroundColor(.primary500)
                Text("Tip: Contact the merchant")
                    .font(.system(size: 29))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                Text("To expedite your dispute claim, we recommend that you try to resolve your dispute with the merchant before submitting your dispute to City National Bank.")
                    .font(.system(size: 18))
                    .lineSpacing(10)
                Spacer()
                Button("OK") {
                    primaryButtonTaps.send()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(.all, 30.0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct DisputeTipView_Previews: PreviewProvider {
    static var previews: some View {
        DisputeTipView(viewModel: DisputeTipViewModel(router: PreviewRouter<DisputesRoute>().weakRouter))
    }
}
