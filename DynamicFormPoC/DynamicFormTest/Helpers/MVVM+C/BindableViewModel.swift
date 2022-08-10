import Foundation

protocol BindableViewModel {
    associatedtype Inputs
    
    func bind(inputs: Inputs)
}
