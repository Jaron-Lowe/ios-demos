//
//  PeopleService.swift
//  MVVM+RxSwift Example
//
//  Created by Jaron Lowe on 11/18/21.
//

import Foundation
import RxSwift

protocol PeopleServicing {
    func getPeople(filters: PeopleFilters) -> Single<Result<[Person], Error>>
}

final class PeopleService: PeopleServicing {
    
    func getPeople(filters: PeopleFilters) -> Single<Result<[Person], Error>> {
        return Single.just(())
            .delay(.milliseconds(Int.random(in: 1000...2500)), scheduler: MainScheduler.instance)
            .map {
                var people: [Person]
                switch filters.gender {
                case .any:
                    people = DummyData.people
                case .male:
                    people = DummyData.people.filter { $0.gender == .male }
                case .female:
                    people = DummyData.people.filter { $0.gender == .female }
                }
                
                people = people.filter { filters.age.value ~= $0.age }
                
                return .success(people)
            }
    }
    
}


enum PeopleServiceError: Error {
    case general
}
