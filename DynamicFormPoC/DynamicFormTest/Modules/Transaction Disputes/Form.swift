import UIKit

struct Form {
    // MARK: Properties
    let elements: [Element]

    // MARK: Init
    init(elements: [Element] = []) {
        self.elements = elements
    }
        
    struct Element {
        let key: String
        let parents: [ElementParent]
        let type: ElementType
        let isRequired: Bool
        let title: String
        
        init(key: String, type: ElementType, title: String, isRequired: Bool = true, parents: [ElementParent] = []) {
            self.key = key
            self.type = type
            self.title = title
            self.isRequired = isRequired
            self.parents = parents
        }
    }

    enum ElementType {
        case radio(options: [String])
        case text(placeholder: String, keyboardType: UIKeyboardType)
        case email
        case multiText(placeholder: String, addFieldTitle: String, keyboardType: UIKeyboardType)
        case address
        case date(min: Date, max: Date)
        case currency(placeholder: String)
    }
    
    struct ElementParent {
        let key: String
        let index: Int?
    }
}

struct Address: Codable {
    let address1: String
    let address2: String
    let city: String
    let state: String
    let postalCode: String
    
    var isValid: Bool {
        return !address1.isEmpty && !city.isEmpty && !postalCode.isEmpty
    }
}

enum FormElementValue {
    case radio(Int)
    case multiText([String])
    case address(Address)
    case date(Date)
    case currency(Decimal)

    var isValid: Bool {
        switch self {
        case .radio, .date, .currency:
            return true
        case .multiText(let array):
            return array.first?.isEmpty == false
        case .address(let address):
            return address.isValid
        }
    }
}

struct FormElementValueChange {
    let key: String
    let value: FormElementValue
}
