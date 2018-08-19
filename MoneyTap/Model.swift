//
//  Model.swift
//  MoneyTap
//
//  Created by Piyush Gangil on 18/08/18.
//  Copyright © 2018 Altisource. All rights reserved.
//

import UIKit


final class SearchResult {
    var title = ""
    var description = ""
    var thumbnailUrl = ""
    
    init(title:String , description:String) {
        self.title = title
        self.description = description
    }
}
