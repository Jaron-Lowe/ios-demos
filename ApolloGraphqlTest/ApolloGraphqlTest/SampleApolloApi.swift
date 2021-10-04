//
//  Network.swift
//  ApolloGraphqlTest
//
//  Created by Jaron Lowe on 3/23/21.
//

import Foundation
import Apollo
import RxSwift

class SampleApolloApi {
    
    static let graph = ApolloClient(url: URL(string: "https://apollo-fullstack-tutorial.herokuapp.com/")!);
    
    static func processGraphQLResult<T>(result: Result<GraphQLResult<T>, Error>) -> Result<T, Error> {
        switch result {
        case .success(let graphResult):
            if let errors = graphResult.errors, let error = errors.first {
                for (index, error) in errors.enumerated() { print("Graph Error (\(index)): \(error.localizedDescription)"); }
                return .failure(error);
            }
            return .success(graphResult.data!);
        case .failure(let error):
            return .failure(error);
        }
    }
    
    @discardableResult
    static func Login(email: String, completion: @escaping(_ result: Result<LoginMutation.Data, Error>)->()) -> Cancellable {
        return SampleApolloApi.graph.perform(mutation: LoginMutation(email: email), resultHandler: { result in
            completion(processGraphQLResult(result: result));
        });
    }
        
    @discardableResult
    static func GetLaunchList(cursor: String?, pageSize: Int? = nil, completion: @escaping(_ result: Result<GetLaunchListQuery.Data, Error>)->()) -> Cancellable {
        return SampleApolloApi.graph.fetch(query: GetLaunchListQuery(cursor: cursor, pageSize: pageSize), resultHandler: { result in
            completion(processGraphQLResult(result: result));
        });
    }
    
}


// =================================================================================
// MARK: - Rx Setup
// =================================================================================

extension SampleApolloApi {
    
    static func Login(email: String) -> Observable<Result<LoginMutation.Data, Error>> {
        return Observable.create({ observer in
            let request = Login(email: email) { (result) in
                observer.onNext(result);
                observer.onCompleted();
            };
            return Disposables.create { request.cancel(); }
        });
    }
    
    static func GetLaunchList(cursor: String?, pageSize: Int? = nil) -> Observable<Result<GetLaunchListQuery.Data, Error>> {
        return Observable.create({ observer in
            let request = GetLaunchList(cursor: cursor, pageSize: pageSize) { (result) in
                observer.onNext(result);
                observer.onCompleted();
            };
            return Disposables.create { request.cancel(); }
        });
    }
}
