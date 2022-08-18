import Foundation
import Combine
import CombineExt
import XCoordinator
import SwiftUIX

class DisputeFormViewModel: ObservableObject {
    // MARK: Properties
    @Published private(set) var shouldShowConfirmCancelAlert = false
    @Published private(set) var formElements: [FormElementViewModel] = []
    @Published private(set) var nextInvalidElement: String = ""
    @Published private(set) var isReviewDisputesButtonDisabled = false
    
    private let router: WeakRouter<DisputesRoute>
    private var cancellables = Set<AnyCancellable>()
    private let formStructure = CurrentValueSubject<Form, Never>(Form())
    
    // MARK: Init
    init(router: WeakRouter<DisputesRoute>, disputeForm: DisputeForm) {
        self.router = router
        formStructure.send(disputeForm.formStructure)
    }
}

// MARK: - BindableViewModel
extension DisputeFormViewModel: BindableViewModel {
    struct Inputs {
        let viewDidLoads: AnyPublisher<Void, Never>
        let isKeyboardShown: AnyPublisher<Bool, Never>
        let reviewDisputeButtonTaps: AnyPublisher<Void, Never>
        let cancelButtonTaps: AnyPublisher<Void, Never>
        let formValueChanges: AnyPublisher<FormElementValueChange, Never>
    }
    
    struct Compositions {
        let formStructure: AnyPublisher<Form, Never>
        let formValues: AnyPublisher<[String: FormElementValue], Never>
        let isInReview: AnyPublisher<Bool, Never>
        let hasPageChanges: AnyPublisher<Bool, Never>
    }
    
    func bind(inputs: Inputs) {
        setUpSubscriptions(inputs: inputs)
        
        let formStructure = formStructure.eraseToAnyPublisher()
        let compositions = Compositions(
            formStructure: formStructure,
            formValues: formValues(inputs: inputs),
            isInReview: isInReview(inputs: inputs),
            hasPageChanges: hasPageChanges(inputs: inputs)
        )
        
        shouldShowConfirmCancelAlert(inputs: inputs, compositions: compositions).assign(to: &$shouldShowConfirmCancelAlert)
        let formElements = formElements(compositions: compositions)
        formElements.assign(to: &$formElements)
        nextInvalidElement(formElements: formElements).assign(to: &$nextInvalidElement)
        isReviewDisputesButtonDisabled(inputs: inputs, formElements: formElements).assign(to: &$isReviewDisputesButtonDisabled)
    }
}

// MARK: - Private Methods
private extension DisputeFormViewModel {
    // MARK: Subscriptions
    func setUpSubscriptions(inputs: Inputs) {
        inputs.viewDidLoads
            .sink(receiveValue: { [weak self] _ in
                self?.router.trigger(.tip)
            })
            .store(in: &cancellables)
    }
    
    // MARK: Compositions
    func formValues(inputs: Inputs) -> AnyPublisher<[String: FormElementValue], Never> {
        let initialFormValues: [String: FormElementValue] = ["email": .multiText(["example@example.com", ""])]
        return inputs.formValueChanges
            .scan(initialFormValues) {
                var values = $0
                values[$1.key] = $1.value
                return values
            }
            .prepend(initialFormValues)
            .print("--- formValues")
            .share()
            .eraseToAnyPublisher()
    }
    
    func isInReview(inputs: Inputs) -> AnyPublisher<Bool, Never> {
        return inputs.reviewDisputeButtonTaps
            .scan(false) { accumulator, _ in
                return !accumulator
            }
            .prepend(false)
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
        return Publishers.CombineLatest3(
            compositions.formStructure,
            compositions.formValues,
            compositions.isInReview
        )
        .map { formStructure, values, isInReview in
            var formElements: [FormElementViewModel] = []
            for element in formStructure.elements {
                guard formElements.canMakeAvailable(element: element, values: values) else { continue }
                formElements.append(FormElementViewModel(element: element, value: values[element.key], isInReview: isInReview))
            }
            formElements.applyErrorStates()
            return formElements
        }
        .print("--- formElements")
        .receive(on: DispatchQueue.main)
        .share()
        .eraseToAnyPublisher()
    }
    
    func nextInvalidElement(formElements: AnyPublisher<[FormElementViewModel], Never>) -> AnyPublisher<String, Never> {
        return formElements
            .compactMap { formElements in
                guard let nextItem = formElements.first(where: { $0.value?.isValid == false || $0.value == nil }) else { return "bottom" }
                return nextItem.element.key
            }
            .dropFirst()
            .delay(for: .milliseconds(100), scheduler: RunLoop.main)
            .print("--- nextInvalidElement")
            .receive(on: DispatchQueue.main)
            .share()
            .eraseToAnyPublisher()
    }
    
    func isReviewDisputesButtonDisabled(inputs: Inputs, formElements: AnyPublisher<[FormElementViewModel], Never>) -> AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(formElements, inputs.isKeyboardShown)
            .map { !($0.lastRequiredElementHasValue && $0.hasAllRequiredValues) || $1 }
            .print("--- isReviewDisputesButtonDisabled")
            .receive(on: DispatchQueue.main)
            .share()
            .eraseToAnyPublisher()
    }
}
