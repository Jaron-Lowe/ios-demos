import SwiftUIX

extension CocoaTextField {
    func focused(_ currentState: Binding<String?>?, equals: String?) -> Self {
        guard let currentState = currentState, let equals = equals else {
            return self
        }

        let isFocused = Binding(
            get: { (currentState.wrappedValue == equals) },
            set: {
                if $0 {
                    currentState.wrappedValue = equals
                } else {
                    currentState.wrappedValue = nil
                }
            }
        )
        return focused(isFocused)
    }
}
