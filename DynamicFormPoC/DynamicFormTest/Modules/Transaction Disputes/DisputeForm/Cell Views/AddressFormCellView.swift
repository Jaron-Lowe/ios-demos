import SwiftUI
import Combine

struct AddressFormCellView: View {
    let viewModel: FormElementViewModel
    let formValueChanges: PassthroughSubject<FormElementValueChange, Never>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text(viewModel.element.title)
                .fontWeight(.semibold)
                .font(.system(size: 21.0))
                .frame(maxWidth: .infinity, alignment: .leading)
            Button("Simulate Value") {
                formValueChanges.send(FormElementValueChange(key: viewModel.element.key, value: .date(Date())))
            }
        }
        .frame(maxWidth: .infinity)
        .padding([.top, .leading, .bottom, .trailing], 30.0)
        .background(Color.white)
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
