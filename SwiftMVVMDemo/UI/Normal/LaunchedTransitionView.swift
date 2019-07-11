//
//  LaunchedTransitionView.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/27.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit
import SnapKit

class LaunchedTransitionView: UIView {

    var bgImageView: UIImageView!
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        
        bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "IMG_Cool_Car_5")
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo_swift")
        bgImageView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(29)
            make.top.equalTo(119)
            make.centerX.equalToSuperview()
        }
    }
    
    class func show() {
        
        let launchView = LaunchedTransitionView()
        let window: UIWindow = UIApplication.shared.delegate!.window!!
        window.addSubview(launchView)
        launchView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        launchView.delayToHide()
    }
    
    func delayToHide() {
        
        let window: UIWindow = UIApplication.shared.delegate!.window!!
        window.rootViewController!.view.alpha = 1.0
        UIView.animate(withDuration: 3.0, animations: {
            self.bgImageView.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
