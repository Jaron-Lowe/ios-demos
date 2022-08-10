import Foundation

struct FormElementViewModel: Identifiable {
    var id: String { return element.key }
    
    let element: Form.Element
    let value: FormElementValue?
}

extension Array where Element == FormElementViewModel {
    var lastRequiredElementHasValue: Bool {
        guard let lastRequired = self.last(where: { $0.element.isRequired }) else { return true }
        return lastRequired.value != nil
    }
    
    var hasAllRequiredValues: Bool {
        for viewModel in self {
            if viewModel.element.isRequired && viewModel.value == nil { return false }
        }
        return true
    }
    
    func canMakeAvailable(element: Form.Element, values: [String: FormElementValue]) -> Bool {
        guard !element.parents.isEmpty else { return true }
        for parent in element.parents {
            guard self.contains(where: { $0.element.key == parent.key }), let value = values[parent.key], case .radio(let valueIndex) = value else { continue }
            if parent.index == nil || parent.index == valueIndex { return true }
        }
        return false
    }
}
