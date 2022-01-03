//
//  Person.swift
//  MVVM+RxSwift Example
//
//  Created by Jaron Lowe on 11/18/21.
//

import Foundation

enum Gender {
    case male
    case female
    
    var title: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        }
    }
    
}

struct Person {
    let imageUrl: String
    let gender: Gender
    let age: Int
    let firstName: String
    let lastName: String
    
    var fullName: String {
        return [firstName, lastName]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).capitalized }
            .compactMap { $0 }
            .joined(separator: " ")
    }
}
