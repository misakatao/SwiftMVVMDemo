//
//  HideTopNavBarController.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/27.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit

class HideTopNavBarController: UINavigationController {

    var hideTopBarVC: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        hideTopBarVC = NSArray(contentsOfFile: Bundle.main.path(forResource: "HideNavConfigure", ofType: "plist")!) as? [String]
        
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.light),
            NSAttributedStringKey.foregroundColor: UIColor.darkGray
        ]
        
        delegate = self
        UIApplication.shared.isStatusBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HideTopNavBarController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        assert(!(viewController is UITableViewController), "此样式下不支持UITableViewController")
        
        let willShowName = type(of: viewController).debugDescription().components(separatedBy: ",").last
        
        for vc in hideTopBarVC! {
            if let name = willShowName {
                if name == vc {
                    return
                }
            }
        }
        
        var hasAddBar = false
        
        for sub in viewController.view.subviews {
            if type(of: sub) == PlaceHolderNavBar.self {
                hasAddBar = true
            }
        }
        
        guard hasAddBar else {
            
            UIApplication.shared.isStatusBarHidden = false
            UIApplication.shared.statusBarStyle = .default
            
            var offsetY: CGFloat = 0
            let bar = PlaceHolderNavBar()
            let globalBar = UINavigationBar.appearance()
            bar.barStyle = globalBar.barStyle
            bar.setBackgroundImage(UIImage(color: UIColor.white), for: UIBarMetrics.default)
            bar.shadowImage = UIImage(color: UIColor(hexColor: "#E9E9E9"),
                                      size: CGSize(width: kScreenWidth, height: 1/UIScreen.main.scale))
            viewController.view.addSubview(bar)
            
            if viewController is UITableViewController {
                offsetY = -64
                bar.snp.makeConstraints({ (make) in
                    make.left.equalToSuperview()
                    make.width.equalToSuperview()
                    if isiPhoneX {
                        make.top.equalToSuperview().offset(offsetY)
                    } else {
                        make.top.equalTo(offsetY)
                    }
                    make.height.equalTo(isiPhoneX ? 122 : 64)
                })
            } else {
                bar.snp.makeConstraints({ (make) in
                    make.left.right.equalToSuperview()
                    if isiPhoneX {
                        make.top.equalToSuperview().offset(offsetY)
                    } else {
                        make.top.equalTo(offsetY)
                    }
                    make.height.equalTo(isiPhoneX ? 122 : 64)
                })
            }
            return
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        let willShowName = type(of: viewController).description().components(separatedBy: ".").last
        
        for vc in hideTopBarVC! {
            if let name = willShowName {
                
                if name == vc {
                    UIApplication.shared.isStatusBarHidden = (name == "LoginController")
                    UIApplication.shared.statusBarStyle = .lightContent
                    return
                }
            }
        }
    }
}
