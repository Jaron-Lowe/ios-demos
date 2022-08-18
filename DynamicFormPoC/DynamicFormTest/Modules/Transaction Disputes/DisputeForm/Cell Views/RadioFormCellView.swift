import SwiftUI
import Combine

struct RadioFormCellView: View {
    @ObservedObject private(set) var viewModel: FormElementViewModel
    let formValueChanges: PassthroughSubject<FormElementValueChange, Never>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text(viewModel.element.title)
                .fontWeight(.semibold)
                .font(.system(size: 21.0))
                .frame(maxWidth: .infinity, alignment: .leading)
            if case .radio(let options) = viewModel.element.type {
                VStack(alignment: .leading, spacing: 10.0) {
                    ForEach(Array(options.enumerated()), id: \.element) { optionIndex, option in
                        Button(action: {
                            formValueChanges.send(FormElementValueChange(key: viewModel.element.key, value: .radio(optionIndex)))
                        }, label: {
                            HStack(spacing: 16) {
                                ZStack {
                                    Color.white
                                        .frame(width: 25, height: 25, alignment: .leading)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.black, lineWidth: 1)
                                        )
                                    if case .radio(let selectedIndex) = viewModel.value, selectedIndex == optionIndex {
                                        Color.primary500
                                            .frame(width: 15, height: 15, alignment: .leading)
                                            .clipShape(Circle())
                                    }
                                }
                                Text(option)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        })
                        
                    }
                }
                .frame(maxWidth: .infinity)
                if viewModel.isInError {
                    TextFieldErrorView(title: "This field is required.")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 30.0)
        .background(Color.white)
        .animation(.default, value: viewModel.isInError)
    }
}

struct RadioFormCellView_Previews: PreviewProvider {
    static var previews: some View {
        RadioFormCellView(
            viewModel: FormElementViewModel(
                element: Form.Element(
                    key: "A",
                    type: .radio(options: ["YES", "NO"]),
                    title: "This is a test form element. Right?"
                ),
                value: .radio(0),
                isInReview: false
            ),
            formValueChanges: PassthroughSubject()
        )
        .previewLayout(.sizeThatFits)
    }
}
