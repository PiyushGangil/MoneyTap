//
//  CustomTableViewCell.swift
//  MoneyTap
//
//  Created by Piyush Gangil on 18/08/18.
//  Copyright © 2018 Altisource. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var cellModel:CellModel? {
        didSet{
            self.configureCell(cellModel: cellModel)
        }
    }
    
    func configureCell(cellModel:CellModel?)  {
        if let title = cellModel?.item?.title {
            self.titleLabel.text = title
        }
        
        if let description = cellModel?.item?.description {
            self.subTitleLabel.text = description
        }
        
        if let imageURL = cellModel?.item?.thumbnailUrl {
            if let url = URL(string: imageURL) {
                self.cellModel?.downloadImage(thumbnailUrl: url, callback: { image in
                    if let image = image {
                        self.imgView.image = image
                    }
                })
            }
            
        }
    }
}
