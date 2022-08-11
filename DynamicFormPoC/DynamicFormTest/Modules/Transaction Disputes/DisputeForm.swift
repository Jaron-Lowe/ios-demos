import Foundation

enum DisputeForm: CaseIterable {
    case duplicated
    case recurring
    case returnOrCancellation
    case damaged
    case wrongAmountOrType

    var title: String {
        switch self {
        case .duplicated:
            return "Charged more than once"
        case .recurring:
            return "Charged after cancelling recurring transaction"
        case .returnOrCancellation:
            return "Charged after return or cancellation"
        case .damaged:
            return "Charged for unsatisfactory item(s) or service(s)"
        case .wrongAmountOrType:
            return "Charged wrong amount or payment type"
        }
    }
    
    var detail: String {
        switch self {
        case .duplicated:
            return "This transaction shouldn’t appear multiple times."
        case .recurring:
            return "You were charged after cancelling a recurring bill."
        case .returnOrCancellation:
            return "You’ve been charged after returning an item or canceling a service."
        case .damaged:
            return "You received a damaged item, weren’t satisfied with a service, or didn’t get what you ordered."
        case .wrongAmountOrType:
            return "The charge is higher than you expected, or the wrong payment type was charged."
        }
    }
    
    var formStructure: Form {
        switch self {
        case .duplicated:
            return Form(elements: [
                Form.Element(key: "email", type: .email, title: "Cardholder Email Address"),
                Form.Element(key: "provide_receipt", type: .radio(options: ["Yes", "No"]), title: "Are you able to provide a copy of the original transaction receipt?")
            ])
        case .recurring:
            return Form(elements: [
                Form.Element(key: "email", type: .email, title: "Cardholder Email Address"),
                Form.Element(key: "why", type: .text(placeholder: "Enter text here...", keyboardType: .default), title: "Please describe why you're disputing this transaction."),
                Form.Element(key: "received", type: .radio(options: ["Yes", "No"]), title: "Did you receive the good(s) or service(s)?"),
                Form.Element(key: "provided_address", type: .address, title: "What address did you provide for delivery of the good(s) or service(s)?"),
                Form.Element(key: "tried_contact", type: .radio(options: ["Yes", "No"]), title: "Have you tried to contact the merchant?"),
                // YES - tried_contact
                Form.Element(key: "last_contact", type: .date(range: Date.distantRange), title: "When did you last try to contact the merchant?", parents: [.init(key: "tried_contact", index: 0)]),
                Form.Element(key: "how_contact", type: .radio(options: ["Phone", "Email", "In Person", "Letter", "Live Chat", "Fax", "Text", "Other"]), title: "How did you try to contact the merchant?", parents: [.init(key: "tried_contact", index: 0)]),
                Form.Element(key: "what_contact", type: .text(placeholder: "Enter text here...", keyboardType: .default), title: "Tell us what happened when you tried to contact the merchant.", parents: [.init(key: "tried_contact", index: 0)]),
                Form.Element(key: "prove_contact", type: .radio(options: ["Yes", "No"]), title: "Are you able to show us that you contacted the merchant?", parents: [.init(key: "tried_contact", index: 0)]),
                Form.Element(key: "canceled_when", type: .date(range: Date.distantRange), title: "When did you cancel this transaction?", parents: [.init(key: "tried_contact", index: 0)]),
                Form.Element(key: "confirmation_numbers", type: .multiText(placeholder: "Enter confirmation number", addFieldTitle: "+ Add another number", keyboardType: .numberPad), title: "Please provide any cancellation confirmation numbers from the merchant (if available).", isRequired: false, parents: [.init(key: "tried_contact", index: 0)]),
                Form.Element(key: "initial_authorization", type: .radio(options: ["Yes", "No"]), title: "Do you have a copy of your initial authorization for the charge?", parents: [.init(key: "tried_contact", index: 0)]),
                Form.Element(key: "return_after_cancel", type: .radio(options: ["Yes", "No"]), title: "Did you return anything to the merchant after cancelling this transaction?", parents: [.init(key: "tried_contact", index: 0)]),
                // YES - return_after_cancel
                Form.Element(key: "date_of_return", type: .date(range: Date.distantRange), title: "Enter the date that you made the return.", parents: [.init(key: "return_after_cancel", index: 0)]),
                Form.Element(key: "prove_return", type: .radio(options: ["Yes", "No"]), title: "Are you able to show us proof of this return?", parents: [.init(key: "return_after_cancel", index: 0)]),
                // NO Funnel - tried_contact, return_after_cancel, prove_return
                Form.Element(key: "did_you_know", type: .radio(options: ["Yes", "No"]), title: "Did you know this would be a recurring charge?", parents: [.init(key: "tried_contact", index: 1), .init(key: "return_after_cancel", index: 1), .init(key: "prove_return", index: nil)]),
            ])
        case .returnOrCancellation:
            return Form(elements: [
                Form.Element(key: "email", type: .email, title: "Cardholder Email Address"),
                Form.Element(key: "why", type: .text(placeholder: "Enter text here...", keyboardType: .default), title: "Please describe why you're disputing this transaction."),
                Form.Element(key: "received", type: .radio(options: ["Yes", "No"]), title: "Did you receive the good(s) or service(s)?"),
                Form.Element(key: "provided_address", type: .address, title: "What address did you provide for delivery of the good(s) or service(s)?"),
                Form.Element(key: "tried_contact", type: .radio(options: ["Yes", "No"]), title: "Have you tried to contact the merchant?"),
                Form.Element(key: "last_contact", type: .date(range: Date.distantRange), title: "When did you last try to contact the merchant?", parents: [.init(key: "tried_contact", index: 0)]),
                Form.Element(key: "how_contact", type: .radio(options: ["Phone", "Email", "In Person", "Letter", "Live Chat", "Fax", "Text", "Other"]), title: "How did you try to contact the merchant?", parents: [.init(key: "tried_contact", index: 0)]),
                Form.Element(key: "what contact", type: .text(placeholder: "Enter text here...", keyboardType: .default), title: "Tell us what happened when you tried to contact the merchant.", parents: [.init(key: "tried_contact", index: 0)]),
                Form.Element(key: "prove_contact", type: .radio(options: ["Yes", "No"]), title: "Are you able to show us that you contacted the merchant?", parents: [.init(key: "tried_contact", index: 0)]),
                Form.Element(key: "credits_refunds", type: .radio(options: ["Yes", "No"]), title: "Have you received any credits or refunds?", parents: [.init(key: "tried_contact", index: 0)]),
                Form.Element(key: "merchant_acknowledged", type: .radio(options: ["Yes", "No"]), title: "Did the merchant acknowledge the cancellation or refund?", parents: [.init(key: "tried_contact", index: 0)]),
                Form.Element(key: "prove_acknowlegement", type: .radio(options: ["Yes", "No"]), title: "Are you able to show us the merchant's acknowledgement?", parents: [.init(key: "merchant_acknowledged", index: 0)]),
                Form.Element(key: "receipt_received", type: .radio(options: ["Yes", "No"]), title: "Did you get a receipt for a refund or credit?", parents: [.init(key: "merchant_acknowledged", index: 1), .init(key: "prove_acknowlegement", index: nil)]),
                Form.Element(key: "show_us_receipt", type: .radio(options: ["Yes", "No"]), title: "Are you able to show us a copy of your receipt?", parents: [.init(key: "receipt_received", index: 0)]),
                Form.Element(key: "initial_authorization", type: .radio(options: ["Yes", "No"]), title: "Do you have a copy of your initial authorization for the charge?", parents: [.init(key: "receipt_received", index: 1), .init(key: "show_us_receipt", index: nil)]),
                Form.Element(key: "prove_return", type: .radio(options: ["Yes", "No"]), title: "Are you able to show us that you made any returns or cancelled any services?", parents: [.init(key: "receipt_received", index: 1), .init(key: "show_us_receipt", index: nil)]),
                Form.Element(key: "have_tracking_numbers", type: .radio(options: ["Yes", "No"]), title: "Do you have any tracking numbers for your returns?", parents: [.init(key: "receipt_received", index: 1), .init(key: "show_us_receipt", index: nil)]),
                Form.Element(key: "tracking_numbers", type: .multiText(placeholder: "Enter tracking number", addFieldTitle: "+ Add another number", keyboardType: .numberPad), title: "Tracking number(s):", parents: [.init(key: "have_tracking_numbers", index: 0)]),
                Form.Element(key: "date_returned", type: .date(range: Date.distantRange), title: "Enter the date that you returned the good(s) or cancelled the service(s).", parents: [.init(key: "have_tracking_numbers", index: nil)]),
                Form.Element(key: "amount_charged", type: .currency(placeholder: "Amount charged"), title: "How much were you charged for this transaction?", parents: [.init(key: "have_tracking_numbers", index: nil)]),
            ])
        case .damaged:
            return Form(elements: [
                Form.Element(key: "email", type: .email, title: "Cardholder Email Address"),
                Form.Element(key: "why", type: .text(placeholder: "Enter text here...", keyboardType: .default), title: "Please describe why you're disputing this transaction."),
                Form.Element(key: "received", type: .radio(options: ["Yes", "No"]), title: "Did you receive the good(s) or service(s)?"),
                Form.Element(key: "provided_address", type: .address, title: "What address did you provide for delivery of the good(s) or service(s)?"),
                Form.Element(key: "tried_contact", type: .radio(options: ["Yes", "No"]), title: "Have you tried to contact the merchant to cancel this recurring transaction?"),
                // YES - tried_contact
                Form.Element(key: "last_contact", type: .date(range: Date.distantRange), title: "When did you last try to contact the merchant?", parents: [.init(key: "tried_contact", index: 0)]),
                Form.Element(key: "how_contact", type: .radio(options: ["Phone", "Email", "In Person", "Letter", "Live Chat", "Fax", "Text", "Other"]), title: "How did you try to contact the merchant?", parents: [.init(key: "tried_contact", index: 0)]),
                Form.Element(key: "what_contact", type: .text(placeholder: "Enter text here...", keyboardType: .default), title: "Tell us what happened when you tried to contact the merchant.", parents: [.init(key: "tried_contact", index: 0)]),
                // NO - tried_contact
                Form.Element(key: "best_explains", type: .radio(options: ["Shipping Damage", "Didn't receive good(s) or service(s)", "Defects (not from shipping)"]), title: "Tell us which choice below best explains your dispute:", parents: [.init(key: "tried_contact", index: nil)]),
                // OPTION 2 - best_explains
                Form.Element(key: "receive_any", type: .radio(options: ["Yes", "No"]), title: "Did you receive any part of the good(s) or service(s) you were charged for?", parents: [.init(key: "best_explains", index: 1)]),
                Form.Element(key: "describe_expectations", type: .text(placeholder: "Enter text here...", keyboardType: .default), title: "Please describe the good(s) or service(s) you expected to receive.", parents: [.init(key: "best_explains", index: 1)]),
                Form.Element(key: "when_expectations", type: .date(range: Date.distantRange), title: "When did you expect to receive the good(s) or service(s)?", parents: [.init(key: "best_explains", index: 1)]),
                Form.Element(key: "price_paid", type: .currency(placeholder: "Enter amount (USD)"), title: "What was the price paid for the good(s) or service(s)?", parents: [.init(key: "best_explains", index: 1)]),
                // OPTION 1 OR 3 - best_explains
                Form.Element(key: "describe_damage", type: .text(placeholder: "Enter text here...", keyboardType: .default), title: "Describe the damage or defects.", parents: [.init(key: "best_explains", index: 0), .init(key: "best_explains", index: 2)]),
                Form.Element(key: "resolution_attempt_proof", type: .radio(options: ["Yes", "No"]), title: "Are you able to show us that you tried to resolve the issue with the merchant or shipping company?", parents: [.init(key: "best_explains", index: 0), .init(key: "best_explains", index: 2)]),
                Form.Element(key: "have_tracking_numbers", type: .radio(options: ["Yes", "No"]), title: "Do you have any tracking numbers for your returns?", parents: [.init(key: "best_explains", index: 0), .init(key: "best_explains", index: 2)]),
                // YES - have_tracking_numbers
                Form.Element(key: "tracking_numbers", type: .multiText(placeholder: "Enter tracking number", addFieldTitle: "+ Add another number", keyboardType: .numberPad), title: "Tracking number(s):", parents: [.init(key: "have_tracking_numbers", index: 0)]),
            ])
        case .wrongAmountOrType:
            return Form(elements: [
                Form.Element(key: "email", type: .email, title: "Cardholder Email Address"),
                Form.Element(key: "why", type: .text(placeholder: "Enter text here...", keyboardType: .default), title: "Please describe why you're disputing this transaction."),
                Form.Element(key: "was_wrong_amount", type: .radio(options: ["Yes", "No"]), title: "Was the wrong amount charged?"),
                // YES - was_wrong_amount
                Form.Element(key: "prove_wrong_amount", type: .radio(options: ["Yes", "No"]), title: "Are you able to show us that the wrong amount was charged?", parents: [.init(key: "was_wrong_amount", index: 0)]),
                Form.Element(key: "charged_amount", type: .currency(placeholder: "Enter amount (USD)"), title: "How much were you charged for this transaction?", parents: [.init(key: "was_wrong_amount", index: 0)]),
                Form.Element(key: "correct_amount", type: .currency(placeholder: "Enter amount (USD)"), title: "How much should you have been charged?", parents: [.init(key: "was_wrong_amount", index: 0)]),
                // NO - was_wrong_amount
                Form.Element(key: "alternate_payment_form", type: .radio(options: ["Yes", "No"]), title: "Was this charge supposed to have been paid using an alternate form of payment (e.g., check, different card, travel voucher, etc.)?", parents: [.init(key: "was_wrong_amount", index: 1)]),
                // YES - alternate_payment_form
                Form.Element(key: "card_charged_anyway", type: .radio(options: ["Yes", "No"]), title: "Was your credit card charged even though it shouldn't have been?", parents: [.init(key: "alternate_payment_form", index: 0)]),
                Form.Element(key: "alternate_payment_proof", type: .radio(options: ["Yes", "No"]), title: "Are you able to show us the alternate payment type used?", parents: [.init(key: "alternate_payment_form", index: 0)]),
                // Funnel - was_wrong_amount, alternate_payment_form
                Form.Element(key: "tried_contact", type: .radio(options: ["Yes", "No"]), title: "Have you tried to contact the merchant?", parents: [.init(key: "was_wrong_amount", index: 0), .init(key: "alternate_payment_form", index: 1), .init(key: "alternate_payment_form", index: 1)]),
                // YES - tried_contact
                Form.Element(key: "last_contact", type: .date(range: Date.distantRange), title: "When did you last try to contact the merchant to resolve this dispute?", parents: [.init(key: "tried_contact", index: 0)]),
                Form.Element(key: "how_contact", type: .radio(options: ["Phone", "Email", "In Person", "Letter", "Live Chat", "Fax", "Text", "Other"]), title: "How did you try to contact the merchant?", parents: [.init(key: "tried_contact", index: 0)]),
                Form.Element(key: "what_contact", type: .text(placeholder: "Enter text here...", keyboardType: .default), title: "Tell us what happened when you tried to contact the merchant.", parents: [.init(key: "tried_contact", index: 0)]),
            ])
        }
    }
}
