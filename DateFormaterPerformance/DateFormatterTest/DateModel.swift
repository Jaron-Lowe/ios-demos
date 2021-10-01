//
//  DateModel.swift
//  DateFormatterTest
//
//  Created by Jaron Lowe on 3/30/21.
//

import Foundation

struct DateModel : Codable, CustomStringConvertible  {
    var dateCreated: String?;
    var useShared: Bool = false;
    var storedDate: Date;
    var computedDate: Date {
        return (self.useShared) ? DateModel.cachedDateConvert(dateString: self.dateCreated) : DateModel.uncachedDateConvert(dateString: self.dateCreated);
    }
    
    init(dateString: String?, useShared: Bool) {
        self.useShared = useShared;
        self.dateCreated = dateString;
        self.storedDate = (self.useShared) ? DateModel.cachedDateConvert(dateString: dateString) : DateModel.uncachedDateConvert(dateString: dateString);
    }
    
    var description: String {
        return "{ dateCreated: \(dateCreated ?? "") }";
    }
    
    
    static func uncachedDateConvert(dateString: String?) -> Date {
        let formatter = DateFormatter();
        formatter.locale = Locale(identifier: "en_US");
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        return formatter.date(from: dateString ?? "") ?? Date();
    }
    
    static func cachedDateConvert(dateString: String?) -> Date {
        return DateFormatter.shared.date(from: dateString ?? "") ?? Date();
    }
}
