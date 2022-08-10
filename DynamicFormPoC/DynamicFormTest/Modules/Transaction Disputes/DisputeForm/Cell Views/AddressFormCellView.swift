import SwiftUI
import Combine

struct AddressFormCellView: View {
    private let viewModel: FormElementViewModel
    private let formValueChanges: PassthroughSubject<FormElementValueChange, Never>
    
    @State private(set) var address1: String
    @State private(set) var address2: String
    @State private(set) var city: String
    @State private(set) var state: String
    @State private(set) var postalCode: String
    @State private(set) var isValid = true
    
    init(viewModel: FormElementViewModel, formValueChanges: PassthroughSubject<FormElementValueChange, Never>) {
        self.viewModel = viewModel
        self.formValueChanges = formValueChanges
        
        if case .address(let address) = viewModel.value {
            address1 = address.address1
            address2 = address.address2
            city = address.city
            state = address.state
            postalCode = address.postalCode
        } else {
            address1 = ""
            address2 = ""
            city = ""
            state = ""
            postalCode = ""
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text(viewModel.element.title)
                .fontWeight(.semibold)
                .font(.system(size: 21.0))
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: 0) {
                FloatingPlaceholderTextField(title: "Address, Line 1", text: $address1) { isEditing in
                    processTextEditingChange(isEditing: isEditing)
                }
                FloatingPlaceholderTextField(title: "Address, Line 2 (optional)", text: $address2) { isEditing in
                    processTextEditingChange(isEditing: isEditing)
                }
                FloatingPlaceholderTextField(title: "City", text: $city) { isEditing in
                    processTextEditingChange(isEditing: isEditing)
                }
                FloatingPlaceholderTextField(title: "State (optional)", text: $state) { isEditing in
                    processTextEditingChange(isEditing: isEditing)
                }
                FloatingPlaceholderTextField(title: "Zip Code", text: $postalCode) { isEditing in
                    processTextEditingChange(isEditing: isEditing)
                }
            }
            if !isValid {
                TextFieldErrorView(title: "Please enter a valid address.")
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 30.0)
        .background(Color.white)
    }
    
    func processTextEditingChange(isEditing: Bool) {
        guard !isEditing else { return }
        let address = Address(address1: address1, address2: address2, city: city, state: state, postalCode: postalCode)
        withAnimation {
            isValid = address.isValid
        }
        formValueChanges.send(FormElementValueChange(key: viewModel.element.key, value: .address(address)))
    }
}

struct AddressFormCellView_Previews: PreviewProvider {
    static var previews: some View {
        AddressFormCellView(
            viewModel: FormElementViewModel(
                element: Form.Element(key: "A", type: .address, title: "This is a question."),
                value: nil
            ),
            formValueChanges: PassthroughSubject()
        )
    }
}
