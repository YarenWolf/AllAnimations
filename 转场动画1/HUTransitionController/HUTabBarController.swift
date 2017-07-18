//
//  HUTabBarController.swift
//  HUTransitionControllerDemo
//
//  Created by 胡校明 on 2016/11/1.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class HUTabBarController: UITabBarController {

    var interactiveTransitionGestureRecognizer: UIGestureRecognizer? {
        get {
            return slideDelegate?.slideGesture
        }
    }
    
    var tansitionAnimationType: HUTransitionAnimation? {
        set {
            slideDelegate?.animationType = newValue!
        }
        get {
            return slideDelegate?.animationType
        }
    }
    
    var slideDelegate: HUTabBarControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 1
        slideDelegate = HUTabBarControllerDelegate(targetViewController: self, animationType: HUTransitionAnimation.translation(duration: 0.3, interactiveEnable: true))
    }

}
