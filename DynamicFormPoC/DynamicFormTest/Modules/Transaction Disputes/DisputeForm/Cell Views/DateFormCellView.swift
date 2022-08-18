import SwiftUI
import Combine

struct DateFormCellView: View {
    @ObservedObject private(set) var viewModel: FormElementViewModel
    private let formValueChanges: PassthroughSubject<FormElementValueChange, Never>
    
    @State private(set) var dateValue: Date? = nil
    private var dateRange: ClosedRange<Date> = Date.distantRange
    
    init(viewModel: FormElementViewModel, formValueChanges: PassthroughSubject<FormElementValueChange, Never>) {
        self.viewModel = viewModel
        self.formValueChanges = formValueChanges
        
        if case .date(let dateRange) = viewModel.element.type {
            self.dateRange = dateRange
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            Text(viewModel.element.title)
                .fontWeight(.semibold)
                .font(.system(size: 21.0))
                .frame(maxWidth: .infinity, alignment: .leading)
            DatePickerTextField(placeholder: "Select date", date: $dateValue, dateRange: dateRange)
                .onChange(of: dateValue) { newValue in
                    guard let newDate = newValue else { return }
                    formValueChanges.send(FormElementValueChange(key: viewModel.element.key, value: .date(newDate)))
                }
            if viewModel.isInError {
                TextFieldErrorView(title: "This field is required.")
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 30.0)
        .background(Color.white)
        .animation(.default, value: viewModel.isInError)
        .onAppear {
            if case .date(let date) = viewModel.value {
                dateValue = date
            }
        }
    }
}

struct DateFormCellView_Previews: PreviewProvider {
    static var previews: some View {
        DateFormCellView(
            viewModel: FormElementViewModel(
                element: Form.Element(key: "A", type: .date(range: Date.distantPast...Date.distantFuture), title: "What date answers this question?"),
                value: nil,
                isInReview: false
            ),
            formValueChanges: PassthroughSubject()
        )
        .previewLayout(.sizeThatFits)
    }
}
