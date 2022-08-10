import SwiftUI
import Combine

struct EmailFormCellView: View {
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
                value: nil
            ),
            formValueChanges: PassthroughSubject()
        )
    }
}
