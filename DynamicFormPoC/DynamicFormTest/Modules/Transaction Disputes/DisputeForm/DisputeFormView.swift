import SwiftUI
import Combine
import SwiftUIX

struct DisputeFormView: View {
    @ObservedObject private(set) var viewModel: DisputeFormViewModel
    @State private(set) var focusState: String?
    
    // MARK: Inputs
    private let viewDidLoads = PassthroughSubject<Void, Never>()
    private let reviewDisputeButtonTaps = PassthroughSubject<Void, Never>()
    private let cancelButtonTaps = PassthroughSubject<Void, Never>()
    private let formValueChanges = PassthroughSubject<FormElementValueChange, Never>()
    
    // MARK: Init
    init(viewModel: DisputeFormViewModel) {
        self.viewModel = viewModel
        viewModel.bind(inputs: DisputeFormViewModel.Inputs(
            viewDidLoads: viewDidLoads.eraseToAnyPublisher(),
            isKeyboardShown: Keyboard.main.$isShown.eraseToAnyPublisher(),
            reviewDisputeButtonTaps: reviewDisputeButtonTaps.eraseToAnyPublisher(),
            cancelButtonTaps: cancelButtonTaps.eraseToAnyPublisher(),
            formValueChanges: formValueChanges.eraseToAnyPublisher()
        ))
        
        viewDidLoads.send()
    }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack(spacing: 0.0) {
                ScrollViewReader { reader in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 10.0) {
                            CallForAssistanceView()
                            ForEach(viewModel.formElements) { elementViewModel in
                                cell(for: elementViewModel)
                            }
                            VStack {
                                Button("Review Dispute") {
                                    reviewDisputeButtonTaps.send()
                                }
                                .disabled(viewModel.isReviewDisputesButtonDisabled)
                                .buttonStyle(PrimaryButtonStyle())
                                .id("bottom")
                            }
                            .padding(EdgeInsets(top: 15.0, leading: 30.0, bottom: 15.0, trailing: 30.0))
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .onReceive(viewModel.$nextInvalidElement, perform: { nextKey in
                        focusState = nextKey
                        withAnimation {
                            reader.scrollTo(nextKey, anchor: .bottom)
                        }
                    })
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    func cell(for viewModel: FormElementViewModel) -> some View {
        switch viewModel.element.type {
        case .radio:
            RadioFormCellView(viewModel: viewModel, formValueChanges: formValueChanges)
        case .text:
            TextFormCellView(viewModel: viewModel, formValueChanges: formValueChanges, focusState: $focusState)
        case .email:
            EmailFormCellView(viewModel: viewModel, formValueChanges: formValueChanges)
        case .multiText:
            MultiTextFormCellView(viewModel: viewModel, formValueChanges: formValueChanges)
        case .address:
            AddressFormCellView(viewModel: viewModel, formValueChanges: formValueChanges)
        case .date:
            DateFormCellView(viewModel: viewModel, formValueChanges: formValueChanges)
        case .currency:
            CurrencyFormCellView(viewModel: viewModel, formValueChanges: formValueChanges)
        }
    }
}

struct CallForAssistanceView: View {
    var body: some View {
        Text("Call (800) 557-4262 for immediate assistance.")
            .padding(EdgeInsets(top: 24.0, leading: 20.0, bottom: 24.0, trailing: 20.0))
            .frame(maxWidth: .infinity)
            .background(Color.primary200)
            .font(.system(size: 16.0))
            .foregroundColor(.onPrimary200)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
    }
}



struct DisputeFormView_Previews: PreviewProvider {
    static var previews: some View {
        DisputeFormView(viewModel: DisputeFormViewModel(router: PreviewRouter<DisputesRoute>().weakRouter, disputeForm: .returnOrCancellation))
    }
}
