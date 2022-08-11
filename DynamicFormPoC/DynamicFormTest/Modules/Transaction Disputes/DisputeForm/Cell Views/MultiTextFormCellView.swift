import SwiftUI
import Combine

struct MultiTextFormCellView: View {
    private let viewModel: FormElementViewModel
    private let formValueChanges: PassthroughSubject<FormElementValueChange, Never>
    
    @State private(set) var values: [String]
    private var placeholder = "Value..."
    private var addButtonTitle = "+ Add value"
    private var keyboardType = UIKeyboardType.default
    
    init(viewModel: FormElementViewModel, formValueChanges: PassthroughSubject<FormElementValueChange, Never>) {
        self.viewModel = viewModel
        self.formValueChanges = formValueChanges
        
        if case .multiText(let placeholder, let addButtonTitle, let keyboardType) = viewModel.element.type {
            self.placeholder = placeholder
            self.addButtonTitle = addButtonTitle
            self.keyboardType = keyboardType
        }
        
        if case .multiText(let values) = viewModel.value {
            self.values = values
        } else {
            self.values = [""]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text(viewModel.element.title)
                .font(.system(size: 21.0))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                ForEach(values.indices, id: \.self) { index in
                    FloatingPlaceholderTextField(title: placeholder, text: $values[index], onEditingChanged: { isEditing in
                        guard !isEditing else { return }
                        formValueChanges.send(FormElementValueChange(key: viewModel.element.key, value: .multiText(values)))
                    })
                    .keyboardType(keyboardType)
                }
            }
            Button(addButtonTitle) {
                withAnimation {
                    values.append("")
                }
            }
            .font(.system(size: 12.0))
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 30.0)
        .background(Color.white)
        
    }
}

struct MultiTextFormCellView_Previews: PreviewProvider {
    static var previews: some View {
        MultiTextFormCellView(
            viewModel: FormElementViewModel(
                element: Form.Element(
                    key: "A",
                    type: .multiText(placeholder: "Test value...", addFieldTitle: "+ Add here", keyboardType: .numberPad),
                    title: "This is a test form element. Right?"
                ),
                value: nil
            ),
            formValueChanges: PassthroughSubject()
        )
        .previewLayout(.sizeThatFits)
    }
}
