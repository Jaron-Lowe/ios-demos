import SwiftUI
import Combine

struct CurrencyFormCellView: View {
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

struct CurrencyFormCellView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyFormCellView(
            viewModel: FormElementViewModel(
                element: Form.Element(key: "A", type: .currency(placeholder: "Amount"), title: "How much money is this question wanting?"),
                value: nil
            ),
            formValueChanges: PassthroughSubject()
        )
    }
}
