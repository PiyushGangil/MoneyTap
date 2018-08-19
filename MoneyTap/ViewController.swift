//
//  ViewController.swift
//  MoneyTap
//
//  Created by Piyush Gangil on 17/08/18.
//  Copyright © 2018 Altisource. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var viewModel = ViewModel()
    var cache = NSCache<NSString,SearchResult>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.tableHeaderView = UIView(frame: CGRect.zero)
        self.tblView.tableFooterView = UIView(frame: CGRect.zero)
        self.viewModel.reloadTableView = {
            self.tblView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController {
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = UINib(nibName: "CustomTableViewCell", bundle: nil).instantiate(withOwner: self, options: [:])[0] as! CustomTableViewCell
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.itemArray.count
    }
    
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let customCell = cell as? CustomTableViewCell {
            
            let item = self.viewModel.itemArray[indexPath.row]
            if let cacheVersion = cache.object(forKey: "cacheObject:\(item.title)" as NSString) {
                customCell.cellModel = CellModel(searchResultItem: cacheVersion)
            }
            else {
                cache.setObject(item, forKey: "cacheObject:\(item.title)" as NSString)
                customCell.cellModel = CellModel(searchResultItem: item)
            }
        }
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80.0)
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
        let item = self.viewModel.itemArray[indexPath.row]
        self.performSegue(withIdentifier: "WikiPageSagueIdentifier", sender: item.title)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
           self.viewModel.fetchList(with: searchText)
        }
        else {
            self.viewModel.itemArray.removeAll()
            self.tblView.reloadData()
        }
    }
}

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WikiPageSagueIdentifier" {
            let destinationVC = segue.destination as! WiKiPageViewController
            destinationVC.webPageTitle = (sender as! String)
        }
    }
}

