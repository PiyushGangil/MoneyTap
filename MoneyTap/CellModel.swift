//
//  CellModel.swift
//  MoneyTap
//
//  Created by Piyush Gangil on 19/08/18.
//  Copyright © 2018 Altisource. All rights reserved.
//

import UIKit

final class CellModel {
    var item:SearchResult?
  
    init(searchResultItem:SearchResult) {
        self.item = searchResultItem
    }
    
    func downloadImage(thumbnailUrl: URL, callback: @escaping((UIImage?) -> Void)) {
        let task = URLSession.shared.dataTask(with: thumbnailUrl, completionHandler: { (data, _ , _) -> Void in
            // if responseData is not null...
            if let data = data {
                // execute in UI thread
                DispatchQueue.main.async {
                    callback(UIImage(data: data))
                }
            }
            else {
                DispatchQueue.main.async {
                    callback(nil)
                }
            }
        })
        task.resume()
    }
}
