import SwiftUI

struct DatePickerTextField: View {
    let placeholder: String
    @Binding var date: Date?
    let dateRange: ClosedRange<Date>
    
    
    @State private var isPresentingPicker = false
    @State private var dateValue: Date = Date()
        
    var body: some View {
        Button {
            isPresentingPicker = true
        } label: {
            VStack(spacing: 4.0) {
                HStack(spacing: 8.0) {
                    ZStack {
                        if let date = date {
                            Text(date.localeFormatted(dateStyle: .short, timeStyle: .none))
                                .foregroundColor(.black)
                        } else {
                            Text(placeholder)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 44.0)
                    Spacer()
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.secondary)
                }
                Divider()
            }
        }
        .fullScreenCover(isPresented: $isPresentingPicker, onDismiss: {
            date = dateValue
        }, content: {
            VStack {
                CloseBar(style: .doneButton) {
                    isPresentingPicker = false
                }
                DatePicker("Date", selection: $dateValue, in: dateRange, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .accentColor(.primary500)
                    .padding(.all, 30.0)
                    
            }
            .frame(maxHeight: .infinity, alignment: .top)
        })
    }
}

struct DatePickerTextField_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerTextField(placeholder: "Select date", date: .constant(nil), dateRange: Date.distantPast...Date.distantFuture)
            .previewLayout(.sizeThatFits)
    }
}
