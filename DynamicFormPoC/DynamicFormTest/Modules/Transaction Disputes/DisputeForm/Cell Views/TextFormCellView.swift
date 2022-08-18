import SwiftUI
import Combine

struct TextFormCellView: View {
    @ObservedObject private(set) var viewModel: FormElementViewModel
    private let formValueChanges: PassthroughSubject<FormElementValueChange, Never>
    private let focusState: Binding<String?>
    
    @State private(set) var textValue: String
    
    init(viewModel: FormElementViewModel, formValueChanges: PassthroughSubject<FormElementValueChange, Never>, focusState: Binding<String?>) {
        self.viewModel = viewModel
        self.formValueChanges = formValueChanges
        self.focusState = focusState
        
        if case .multiText(let values) = viewModel.value, let text = values.first {
            textValue = text
        } else {
            textValue = ""
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text(viewModel.element.title)
                .fontWeight(.semibold)
                .font(.system(size: 21.0))
                .frame(maxWidth: .infinity, alignment: .leading)
            if case .text(let placeholder, let keyboardType) = viewModel.element.type {
                FloatingPlaceholderTextField(title: placeholder, text: $textValue, onEditingChanged: { isEditing in
                    guard !isEditing, !textValue.isEmpty else { return }
                    formValueChanges.send(FormElementValueChange(key: viewModel.element.key, value: .multiText([textValue])))
                }, focusKey: viewModel.element.key, focusState: focusState)
                .keyboardType(keyboardType)
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

struct TextFormCellView_Previews: PreviewProvider {
    static var previews: some View {
        TextFormCellView(
            viewModel: FormElementViewModel(
                element: Form.Element(key: "A", type: .text(placeholder: "Test Placeholder", keyboardType: .default), title: "Test title"),
                value: .multiText(["Test String"]),
                isInReview: false
            ),
            formValueChanges: PassthroughSubject(),
            focusState: .constant("Test")
        )
        .previewLayout(.sizeThatFits)
    }
}
