//
//  UIViewController+Extension.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/27.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit

public protocol KeyboardHandle {
    
}

extension UIViewController {
    
    static let cmp_swizzleMethod: Void = {
        DispatchQueue.once(UUID().uuidString, block: {
            
            swizzleMethod(UIViewController.self, originalSelector: #selector(UIViewController.viewDidLoad), swizzleSelector: #selector(UIViewController.cm_viewDidLoad))
            
            swizzleMethod(UIViewController.self, originalSelector: #selector(UIViewController.prepare(for:sender:)), swizzleSelector: #selector(UIViewController.cm_prepare(for:sender:)))
        })
    }()
    
    @objc func cm_viewDidLoad() {
        cm_viewDidLoad()
        
        setupBackItem()
        if let _ = self as? KeyboardHandle {
            setupHidKeyboard()
        }
    }
    
    @objc func cm_prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.hidesBottomBarWhenPushed = true
        
        cm_prepare(for: segue, sender: sender)
    }
    
    private func setupHidKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardAction))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboardAction() {
        view.endEditing(true)
    }
    
    @objc func popToLastVC() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupBackItem() {
        
        guard !(self is UINavigationController) else {
            return
        }
        
        guard navigationController != nil else {
            return
        }
        
        guard (navigationController?.viewControllers.count ?? 0) > 1 else {
            return
        }
        
        let imageName = (navigationController is HideTopNavBarController) ? "icon_back_arrow_gray" : "icon_back_arrow"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: imageName), target: self, action: #selector(popToLastVC))
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
}
