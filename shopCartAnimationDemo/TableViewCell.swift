//
//  TableViewCell.swift
//  shopCartAnimationDemo
//
//  Created by yunjoy on 15/10/9.
//  Copyright © 2015年 yunjoy. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    var shopCartBlock: ((image:UIImageView)->Void)?
    @IBAction func shopAction(sender: UIButton) {
        if self.shopCartBlock != nil{
        self.shopCartBlock!(image: self.headImage)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
       
        headImage.layer.cornerRadius = CGRectGetWidth(headImage.bounds)/2
        headImage.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal func initModel(model: ShopModel){
        self.headImage.image = UIImage(named: model.shopIcon!)
        self.title.text = model.shopName
    }
    
    
}
