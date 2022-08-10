import SwiftUI
import Combine

struct DisputeSelectView: View {
    @ObservedObject private(set) var viewModel: DisputeSelectViewModel
    
    // MARK: Inputs
    private let disputeOptionTaps = PassthroughSubject<DisputeForm, Never>()
    
    // MARK: Init
    init(viewModel: DisputeSelectViewModel) {
        self.viewModel = viewModel
        viewModel.bind(inputs: DisputeSelectViewModel.Inputs(
            disputeOptionTaps: disputeOptionTaps.eraseToAnyPublisher()
        ))
    }
    
    var body: some View {
        VStack(spacing: 0.0) {
            DisputeInfoView()
                .frame(maxWidth: .infinity)
            Text("Why are you disputing this transaction?")
                .font(.system(size: 16.0))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding([.top, .leading, .bottom, .trailing], 20.0)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Divider()
            List(viewModel.disputeOptions, id: \.self) { option in
                Button {
                    disputeOptionTaps.send(option)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4.0) {
                            Text(option.title)
                                .font(.system(size: 14.0))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            Text(option.detail)
                                .font(.system(size: 13.0))
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            }
            .frame(maxHeight: .infinity)
            .listStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

struct DisputeInfoView: View {
    var body: some View {
        VStack(spacing: 16.0) {
            Text("Lock your card and call (800) 557-4262 right away if:")
                .font(.system(size: 16.0))
            VStack(spacing: 4.0) {
                HStack(alignment: .top) {
                    Text("\u{2022}")
                    Text("You suspect fraud")
                        .font(.system(size: 14.0))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                HStack(alignment: .top) {
                    Text("\u{2022}")
                    Text("Your card is lost or stolen")
                        .font(.system(size: 14.0))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                HStack(alignment: .top) {
                    Text("\u{2022}")
                    Text("You don't see the right dispute type below")
                        .font(.system(size: 14.0))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding([.leading, .trailing], 8.0)
            
        }
        .frame(maxWidth: .infinity)
        .padding([.top, .leading, .bottom, .trailing], 30.0)
        .background(Color.background)
    }
}

struct DisputeSelectView_Previews: PreviewProvider {
    static var previews: some View {
        DisputeSelectView(viewModel: DisputeSelectViewModel())
    }
}
