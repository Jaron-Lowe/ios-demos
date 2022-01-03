//
//  PeopleFilters.swift
//  MVVM+RxSwift Example
//
//  Created by Jaron Lowe on 11/18/21.
//

import Foundation

enum GenderFilterOption: CaseIterable {
    case any
    case male
    case female
    
    var title: String {
        switch self {
        case .any:
            return "Any"
        case .male:
            return "Male"
        case .female:
            return "Female"
        }
    }
}

enum AgeFilterOption: CaseIterable {
    case any
    case range18To27
    case range28To37
    case range38To47
    case range48To57
    case range58To67
    case range68Plus
    
    var title: String {
        switch self {
        case .any:
            return "Any"
        case .range18To27:
            return "18 - 27"
        case .range28To37:
            return "28 - 37"
        case .range38To47:
            return "38 - 47"
        case .range48To57:
            return "48 - 57"
        case .range58To67:
            return "58 - 67"
        case .range68Plus:
            return "68+"
        }
    }
    
    var value: ClosedRange<Int> {
        switch self {
        case .any:
            return 0...Int.max
        case .range18To27:
            return 18...27
        case .range28To37:
            return 28...37
        case .range38To47:
            return 38...47
        case .range48To57:
            return 48...57
        case .range58To67:
            return 58...67
        case .range68Plus:
            return 68...Int.max
        }
    }
    
}

struct PeopleFilters {
    let isFriendsOnly: Bool
    let isOnlineOnly: Bool
    let gender: GenderFilterOption
    let age: AgeFilterOption
    
    static let defaultFilters = PeopleFilters(isFriendsOnly: false, isOnlineOnly: false, gender: .any, age: .any)
}
