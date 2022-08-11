import SwiftUI
import Combine

struct TextFormCellView: View {
    private let viewModel: FormElementViewModel
    private let formValueChanges: PassthroughSubject<FormElementValueChange, Never>
    
    @State private(set) var textValue: String
    
    init(viewModel: FormElementViewModel, formValueChanges: PassthroughSubject<FormElementValueChange, Never>) {
        self.viewModel = viewModel
        self.formValueChanges = formValueChanges
        
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
                    guard !isEditing else { return }
                    formValueChanges.send(FormElementValueChange(key: viewModel.element.key, value: .multiText([textValue])))
                })
                .keyboardType(keyboardType)
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 30.0)
        .background(Color.white)
    }
}

struct TextFormCellView_Previews: PreviewProvider {
    static var previews: some View {
        TextFormCellView(
            viewModel: FormElementViewModel(
                element: Form.Element(key: "A", type: .text(placeholder: "Test Placeholder", keyboardType: .default), title: "Test title"),
                value: .multiText(["Test String"])
            ),
            formValueChanges: PassthroughSubject()
        )
        .previewLayout(.sizeThatFits)
    }
}
