//
//  Launch+Test.swift
//  ApolloGraphqlTest
//
//  Created by Jaron Lowe on 3/24/21.
//

import Foundation

extension GetLaunchListQuery.Data.Launch.Launch {
    
    var isTestElement: Bool {
        return self.id == "80"
    }
    
    
}
