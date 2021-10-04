//
//  Network.swift
//  ApolloGraphqlTest
//
//  Created by Jaron Lowe on 3/23/21.
//

import Foundation
import Apollo
import RxSwift

class ECApi {
    
    static let graph = ApolloClient(url: URL(string: "https://apollo-fullstack-tutorial.herokuapp.com")!);
    
    static func Login(email: String) -> Observable<Result<GraphQLResult<LoginMutation.Data>, Error>> {
            return Observable.create({ observer in
                let request = ECApi.shared.apollo.perform(mutation: LoginMutation(email: email), resultHandler: { result in
                    observer.onNext(result);
                    observer.onCompleted();
                });
                return Disposables.create { request.cancel(); }
            });
    }
    
    static func GetLaunchList(cursor: String?, pageSize: Int? = nil) -> Observable<Result<GraphQLResult<GetLaunchListQuery.Data>, Error>> {
        
        return Observable.create({ observer in
            let request = ECApi.shared.apollo.fetch(query: GetLaunchListQuery(cursor: cursor, pageSize: pageSize), resultHandler: { result in
                observer.onNext(result);
                observer.onCompleted();
            });
            return Disposables.create { request.cancel(); }
        });
    }
}
