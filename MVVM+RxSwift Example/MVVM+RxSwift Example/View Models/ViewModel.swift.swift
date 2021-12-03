//
//  ViewModel.swift.swift
//  MVVM+RxSwift Example
//
//  Created by Jaron Lowe on 11/18/21.
//

import Foundation

protocol ViewModel {
    associatedtype Inputs
    associatedtype Outputs
    
    func transform(_ inputs: Inputs) -> Outputs
}
