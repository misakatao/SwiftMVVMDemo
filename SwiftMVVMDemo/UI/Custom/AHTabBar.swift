//
//  AHTabBar.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/27.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit

class AHTabBar: UITabBar {

    private var centerButton: UIButton!
    
    var centerButtonClickClosure: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bgImageView = drawTabBarBGImageView()
        self.insertSubview(bgImageView, at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func drawTabBarBGImageView() -> UIImageView {
        
        let radius: CGFloat = 28
        let standOutHeight: CGFloat = 20
        let tabBarHeight: CGFloat = self.height
        let allFloat: CGFloat = pow(radius, 2) - pow(radius - standOutHeight, 2)
        let ww: CGFloat = CGFloat(sqrt(Float(allFloat)))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: tabBarHeight))
        let size = imageView.size
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: size.width / 2.0 - ww, y: 0))
        
        let angleH = (radius - ww) / radius
        let startAngle = (1 + angleH) * CGFloat(Double.pi)
        let endAngle = (2 - angleH) * Float(Double.pi)
        
        path.addArc(withCenter: CGPoint(x: size.width/2, y: radius - standOutHeight),
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: true)
        path.addLine(to: CGPoint(x: size.width/2 + ww, y: 0))
        path.addLine(to: CGPoint(x: size.width, y: 0))
        path.addLine(to: CGPoint(x: size.width, y: size.height))
        path.addLine(to: CGPoint(x: 0, y: size.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: size.width/2 - ww, y: 0))
        
        layer.path = path.cgPath
        layer.fillColor = UIColor.white.cgColor
        layer.lineWidth = 1/UIScreen.main.scale
        imageView.layer.addSublayer(layer)
        
        centerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        centerButton.backgroundColor = UIColor.init(hexColor: "#49AFCD")
        centerButton.center = CGPoint(x: imageView.width / 2, y: imageView.height / 2)
        centerButton.setImage(UIImage(named: "icon_nav_close_white"), for: UIControlState.normal)
        centerButton.layer.masksToBounds = true
        centerButton.layer.cornerRadius = centerButton.width / 2
        centerButton.addTarget(self, action: #selector(centerButtonClick), for: UIControlEvents.touchUpInside)
        imageView.addSubview(centerButton)
        
        imageView.clipsToBounds = false
        imageView.isUserInteractionEnabled = false
        imageView.layer.shadowOpacity = 0.1
        imageView.layer.shadowRadius = 1/UIScreen.main.scale
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: -1/UIScreen.main.scale)
        
        return imageView
    }
    
    @objc func centerButtonClick() {
        
        guard let clickBlock = centerButtonClickClosure else {
            return
        }
        clickBlock()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        var view = super.hitTest(point, with: event)
        if view == nil {
            let newPoint = centerButton.convert(point, from: self)
            if centerButton.bounds.contains(newPoint) {
                view = centerButton
            }
        }
        return view
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
