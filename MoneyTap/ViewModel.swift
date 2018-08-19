//
//  ViewModel.swift
//  MoneyTap
//
//  Created by Piyush Gangil on 17/08/18.
//  Copyright © 2018 Altisource. All rights reserved.
//

import UIKit

class ViewModel: NSObject {
    typealias ReloadTableViewHandler = (()->Void)
    var cache = NSCache<NSString,NSArray>()
    var itemArray:[SearchResult] = []
    var reloadTableView : ReloadTableViewHandler?
    
    override init() {
        super.init()
    }
    
    func fetchList(with searchText:String) {
        if let cacheVersion = self.cache.object(forKey: searchText as NSString) {
            self.itemArray.removeAll()
            self.itemArray = cacheVersion as! [SearchResult]
            DispatchQueue.main.async {
                if let handler = self.reloadTableView {
                    handler()
                }
            }
        }
        else {
            self.getSearchList(searchText: searchText)
        }
    }
    
    
    func getSearchList(searchText:String) {
        self.callWebServiceApi(searchString: searchText) { (result, error) in
            if let list = result {
                self.itemArray.removeAll()
                self.itemArray = list
                self.cache.setObject(list as NSArray, forKey: searchText as NSString)
                DispatchQueue.main.async {
                    if let handler = self.reloadTableView {
                        handler()
                    }
                }
                
            }
        }
    }
    
    
    func callWebServiceApi(searchString:String,completionHandler:@escaping(([SearchResult]?,Error?)->Void)) {
        if var urlComponents = URLComponents(string: baseUrl) {
            urlComponents.queryItems = [URLQueryItem(name: "action", value: "query"),
                                        URLQueryItem(name: "format", value: "json"),
                                        URLQueryItem(name: "prop", value: "pageprops|pageimages|description"),
                                        URLQueryItem(name: "generator", value: "prefixsearch"),
                                        URLQueryItem(name: "ppprop", value: "displaytitle"),
                                        URLQueryItem(name: "piprop", value: "thumbnail"),
                                        URLQueryItem(name: "pithumbsize", value: "50"),
                                        URLQueryItem(name: "pilimit", value: pageLimit),
                                        URLQueryItem(name: "gpssearch", value: searchString),
                                        URLQueryItem(name: "gpslimit", value: pageLimit)]
            if let url = urlComponents.url {
                let request =  NSMutableURLRequest(url:url,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 60.0)
                request.httpMethod = "GET"
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, _ , error) -> Void in
                    if let error = error {
                       completionHandler(nil,error)
                    }
                    else {
                        if let data = data {
                            do {
                                if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] {
                                    if let query = jsonDictionary["query"] as? [String:AnyObject] {
                                        if let pages = query["pages"] as? [String:AnyObject] {
                                            var searchList:[SearchResult] = []
                                            pages.forEach({ dict in
                                                let dictValue = dict.value as! Dictionary<String,Any>
                                                let result = SearchResult(title: (dictValue["title"] ?? "") as! String , description: (dictValue["description"] ?? "") as! String)
                                                if dictValue.contains(where: {$0.key == "thumbnail"}) {
                                                    if let thumbnail = dictValue["thumbnail"] as? Dictionary<String,Any> {
                                                        result.thumbnailUrl = (thumbnail["source"] ?? "") as! String
                                                    }
                                                }
                                                searchList.append(result)
                                            })
                                           completionHandler(searchList,nil)
                                        }
                                    }
                                }
                              } catch let error {
                                completionHandler(nil,error)
                            }
                        }
                    }
                })
                dataTask.resume()
            }
        }
    }
    
}
