//
//  ViewController.swift
//  shopCartAnimationDemo
//
//  Created by yunjoy on 15/10/9.
//  Copyright © 2015年 yunjoy. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    private let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    private let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    @IBOutlet weak var showList: UITableView!
    @IBOutlet weak var shopCount: UILabel!
    @IBOutlet weak var shopCart: UIImageView!
    private var shops = [ShopModel]()
    private var _layer: CALayer!
    private var path: UIBezierPath!
    private var _cnt = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.shopCount.layer.cornerRadius = CGRectGetWidth(self.shopCount.bounds)/2
        self.shopCount.layer.masksToBounds = true
        self.loadShops()
    }

    private func loadShops(){
        var i = 0
        repeat{
            let model = ShopModel()
            
            let index = arc4random()%5 + 1
            
            model.shopIcon = "test0\(index).jpg"
            model.shopName = "第\(i)个商品"
            shops.append(model)
            i++
        }while i<10
    }
    
    //MARK: tableview 代理事件
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.shops.count
    }
    
    

     internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let identifier = "reusetablecell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? TableViewCell
        if cell == nil{
            cell = NSBundle.mainBundle().loadNibNamed("TableViewCell", owner: nil, options: nil).last as? TableViewCell
        }
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        cell!.initModel(self.shops[indexPath.row])
        cell!.shopCartBlock = { image in
            var rect = tableView.rectForRowAtIndexPath(indexPath)
            rect.origin.y = rect.origin.y - tableView.contentOffset.y
            
            var headRect = image.frame
            headRect.origin.y = rect.origin.y+headRect.origin.y
            self.startAnimationWithRect(headRect, ImageView: image)
        }
        return cell!
    }
    
    internal func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    internal func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100
    }
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
    }
    
    func startAnimationWithRect(rect: CGRect, ImageView imageView:UIImageView)
    {
    if _layer == nil {
    
    _layer = CALayer()
    _layer.contents = imageView.layer.contents
    
    _layer.contentsGravity = kCAGravityResizeAspectFill
    _layer.bounds = rect
    _layer.cornerRadius = CGRectGetHeight(_layer.bounds)/2
    
    _layer.masksToBounds = true
    // 导航64
    _layer.position = CGPointMake(imageView.center.x, CGRectGetMidY(rect)+64);
    self.view.layer.addSublayer(_layer)
    
    self.path = UIBezierPath()
    self.path.moveToPoint(_layer.position)
    self.path.addQuadCurveToPoint(CGPointMake(SCREEN_WIDTH-50, SCREEN_HEIGHT-40), controlPoint: CGPointMake(SCREEN_WIDTH/2, rect.origin.y-80))
   
    
    
    }
    self.groupAnimation()
    }
    func groupAnimation()
    {
    self.showList.userInteractionEnabled = false
    let animation = CAKeyframeAnimation(keyPath: "position")
    
    animation.path = self.path.CGPath
    animation.rotationMode = kCAAnimationRotateAuto
    let expandAnimation = CABasicAnimation(keyPath: "transform.scale")
   
    expandAnimation.duration = 0.5
    expandAnimation.fromValue = NSNumber(float: 1)
    expandAnimation.toValue = NSNumber(float: 2.0)
    expandAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    
    let narrowAnimation = CABasicAnimation(keyPath: "transform.scale")
    
    narrowAnimation.beginTime = 0.5
    narrowAnimation.fromValue = NSNumber(float: 2.0)
    narrowAnimation.duration = 1.5
    narrowAnimation.toValue = NSNumber(float: 0.3)
    
    narrowAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    
    let groups = CAAnimationGroup()
    
    groups.animations = [animation,expandAnimation,narrowAnimation]
    groups.duration = 2.0
    groups.removedOnCompletion=false
    groups.fillMode=kCAFillModeForwards
    groups.delegate = self
    self._layer.addAnimation(groups, forKey: "group")
    
    }
    override func animationDidStop(anim: CAAnimation, finished flag:Bool)
    {
    
    if anim == self._layer.animationForKey("group"){
    self.showList.userInteractionEnabled = true
    self._layer.removeFromSuperlayer()
    
    self._layer = nil
    _cnt++
    if _cnt != 0 {
    shopCount.hidden = false
    }
    let animation = CATransition()
    
    animation.duration = 0.25
    shopCount.text = "\(_cnt)"
    shopCount.layer.addAnimation(animation, forKey: nil)
    let shakeAnimation = CABasicAnimation(keyPath: "transform.translation.y")
    
    shakeAnimation.duration = 0.25
    shakeAnimation.fromValue = NSNumber(float: -5)
    shakeAnimation.toValue = NSNumber(float: 5)
    shakeAnimation.autoreverses = true
    self.shopCart.layer.addAnimation(shakeAnimation, forKey: nil)
    
    }
    }

}

