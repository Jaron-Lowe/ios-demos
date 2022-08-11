import SwiftUI
import Combine

struct EmailFormCellView: View {
    private let viewModel: FormElementViewModel
    private let formValueChanges: PassthroughSubject<FormElementValueChange, Never>
    
    @State private(set) var values: [String]
    
    init(viewModel: FormElementViewModel, formValueChanges: PassthroughSubject<FormElementValueChange, Never>) {
        self.viewModel = viewModel
        self.formValueChanges = formValueChanges
        
        if case .multiText(let values) = viewModel.value {
            self.values = values
        } else {
            self.values = ["", ""]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 36.0) {
            VStack(spacing: 8) {
                Text("Cardholder Email Address")
                    .fontWeight(.semibold)
                    .font(.system(size: 21.0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(values[0])
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(spacing: 0) {
                Text("Additional Email (optional)")
                    .fontWeight(.semibold)
                    .font(.system(size: 21.0))
                    .frame(maxWidth: .infinity, alignment: .leading)
                FloatingPlaceholderTextField(title: "e.g. example@email.com", text: $values[1]) { isEditing in
                    guard !isEditing else { return }
                    formValueChanges.send(FormElementValueChange(key: viewModel.element.key, value: .multiText(values)))
                }
                .keyboardType(.emailAddress)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 30.0)
        .background(Color.white)
    }
}


struct EmailFormCellView_Previews: PreviewProvider {
    static var previews: some View {
        EmailFormCellView(
            viewModel: FormElementViewModel(
                element: Form.Element(
                    key: "A",
                    type: .email,
                    title: "Email Address"
                ),
                value: .multiText(["example@example.com", ""])
            ),
            formValueChanges: PassthroughSubject()
        )
    }
}
