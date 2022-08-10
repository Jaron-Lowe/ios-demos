import SwiftUI

struct FloatingPlaceholderTextField: View {
    let title: String
    let text: Binding<String>
    let onEditingChanged: ((Bool) -> ())
    
    @State private(set) var isEditing = false
    var shouldFloatPlaceholder: Bool {
        return isEditing || !text.wrappedValue.isEmpty
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.secondary)
                .offset(y: shouldFloatPlaceholder ? -35 : -3)
                .scaleEffect(shouldFloatPlaceholder ? 0.75: 1, anchor: .leading)
            VStack(spacing: 4) {
                TextField("", text: text, onEditingChanged: { isEditing in
                    self.isEditing = isEditing
                    onEditingChanged(isEditing)
                })
                .textFieldStyle(.plain)
                .frame(height: 40)
                Divider()
            }
        }
        .padding(.top, 15.0)
        .animation(.easeInOut(duration: 0.2), value: isEditing)
    }
}
