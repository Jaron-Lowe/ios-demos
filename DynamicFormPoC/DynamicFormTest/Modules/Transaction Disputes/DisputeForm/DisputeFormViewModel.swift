import Foundation
import Combine
import CombineExt

class DisputeFormViewModel: ObservableObject {
    // MARK: Properties
    @Published private(set) var shouldShowConfirmCancelAlert = false
    @Published private(set) var formElements: [FormElementViewModel] = []
    @Published private(set) var pathToNextEmptyElement: [String] = []
    @Published private(set) var isReviewDisputesButtonDisabled = false
    
    private let formStructure = CurrentValueSubject<Form, Never>(Form())
    
    // MARK: Init
    init(disputeForm: DisputeForm) {
        formStructure.send(disputeForm.formStructure)
    }
}

// MARK: - BindableViewModel
extension DisputeFormViewModel: BindableViewModel {
    struct Inputs {
        let reviewDisputeButtonTaps: AnyPublisher<Void, Never>
        let cancelButtonTaps: AnyPublisher<Void, Never>
        let formValueChanges: AnyPublisher<FormElementValueChange, Never>
    }
    
    struct Compositions {
        let formStructure: AnyPublisher<Form, Never>
        let formValues: AnyPublisher<[String: FormElementValue], Never>
        let hasPageChanges: AnyPublisher<Bool, Never>
    }
    
    func bind(inputs: Inputs) {
        let formStructure = formStructure.eraseToAnyPublisher()
        let compositions = Compositions(
            formStructure: formStructure,
            formValues: formValues(inputs: inputs),
            hasPageChanges: hasPageChanges(inputs: inputs)
        )
        
        shouldShowConfirmCancelAlert(inputs: inputs, compositions: compositions).assign(to: &$shouldShowConfirmCancelAlert)
        let formElements = formElements(compositions: compositions)
        formElements.assign(to: &$formElements)
        pathToNextEmptyElement(formElements: formElements).assign(to: &$pathToNextEmptyElement)
        isReviewDisputesButtonDisabled(formElements: formElements).assign(to: &$isReviewDisputesButtonDisabled)
    }
}

// MARK: - Private Methods
private extension DisputeFormViewModel {
    // MARK: Compositions
    func formValues(inputs: Inputs) -> AnyPublisher<[String: FormElementValue], Never> {
        return inputs.formValueChanges
            .scan([String: FormElementValue]()) {
                var values = $0
                values[$1.key] = $1.value
                return values
            }
            .prepend([:])
            .share()
            .eraseToAnyPublisher()
    }
    
    func isAtTerminatingElement(formElements: AnyPublisher<[FormElementViewModel], Never>) -> AnyPublisher<Bool, Never> {
        return formElements
            .map { $0.last?.value != nil }
            .share()
            .eraseToAnyPublisher()
    }
    
    func hasPageChanges(inputs: Inputs) -> AnyPublisher<Bool, Never> {
        return inputs.formValueChanges.map { _ in true }
            .prepend(false)
            .print("--- hasPageChanges")
            .share()
            .eraseToAnyPublisher()
    }
    
    // MARK: Outputs
    func shouldShowConfirmCancelAlert(inputs: Inputs, compositions: Compositions) -> AnyPublisher<Bool, Never> {
        return inputs.cancelButtonTaps
            .withLatestFrom(compositions.hasPageChanges)
            .print("--- shouldShowConfirmCancelAlert")
            .receive(on: DispatchQueue.main)
            .share()
            .eraseToAnyPublisher()
    }
    
    func formElements(compositions: Compositions) -> AnyPublisher<[FormElementViewModel], Never> {
        return Publishers.CombineLatest(compositions.formStructure, compositions.formValues)
            .map { formStructure, values in
                var formElements: [FormElementViewModel] = []
                for element in formStructure.elements {
                    guard formElements.canMakeAvailable(element: element, values: values) else { continue }
                    formElements.append(FormElementViewModel(element: element, value: values[element.key]))
                }
                return formElements
            }
            .print("--- formElements")
            .receive(on: DispatchQueue.main)
            .share()
            .eraseToAnyPublisher()
    }
    
    func pathToNextEmptyElement(formElements: AnyPublisher<[FormElementViewModel], Never>) -> AnyPublisher<[String], Never> {
        return formElements
            .compactMap { formElements in
                guard let nextItem = formElements.first(where: { $0.value == nil }) else { return nil }
                var path: [String] = []
                for element in formElements {
                    path.append(element.element.key)
                    if (element.element.key == nextItem.element.key) { break }
                }
                return path
            }
            .print("--- pathToNextEmptyElement")
            .receive(on: DispatchQueue.main)
            .share()
            .eraseToAnyPublisher()
    }
    
    func isReviewDisputesButtonDisabled(formElements: AnyPublisher<[FormElementViewModel], Never>) -> AnyPublisher<Bool, Never> {
        return formElements
            .map { !($0.lastRequiredElementHasValue && $0.hasAllRequiredValues) }
            .print("--- isReviewDisputesButtonDisabled")
            .receive(on: DispatchQueue.main)
            .share()
            .eraseToAnyPublisher()
    }
}
