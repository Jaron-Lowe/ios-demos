import SwiftUI
import SwiftUIX

struct FloatingPlaceholderTextField: View {
    private let title: String
    private let text: Binding<String>
    private let onEditingChanged: ((Bool) -> ())?
    private let onCommit: (() -> ())?
    private var focusKey: String?
    private var focusState: Binding<String?>?
    
    @State private(set) var isEditing = false
    //@State private(set) var isXFocused = false
    private var shouldFloatPlaceholder: Bool {
        return isEditing || !text.wrappedValue.isEmpty
    }
    
    init(title: String, text: Binding<String>, onEditingChanged: ((Bool) -> ())? = nil, onCommit: (() -> ())? = nil, focusKey: String? = nil, focusState: Binding<String?>? = nil) {
        self.title = title
        self.text = text
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
        self.focusKey = focusKey
        self.focusState = focusState
    }
    
    var body: some View {
        return ZStack(alignment: .leading) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .offset(y: shouldFloatPlaceholder ? -35 : -3)
                .scaleEffect(shouldFloatPlaceholder ? 0.75 : 1, anchor: .leading)
            VStack(spacing: 4.0) {
                CocoaTextField("", text: text, onEditingChanged: localOnEditingChanged(isEditing:), onCommit: localOnCommit)
                    .focused(focusState, equals: focusKey)
                    .textFieldStyle(.roundedBorder)
                    .frame(height: 40)
                Divider()
            }
        }
        .padding(.top, 15.0)
        .onTapGesture {
            guard !isEditing, let focusKey = focusKey else { return }
            focusState?.wrappedValue = focusKey
        }
        .animation(.easeInOut(duration: 0.2), value: shouldFloatPlaceholder)
    }
    
    
}

private extension FloatingPlaceholderTextField {
    func localOnEditingChanged(isEditing: Bool) {
        self.isEditing = isEditing
        onEditingChanged?(isEditing)
    }
    
    func localOnCommit() {
        isEditing = false
        onCommit?()
    }
}


struct FloatingPlaceholderTextField_Preview: PreviewProvider {
    static var previews: some View {
        FloatingPlaceholderTextField(title: "First name", text: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
