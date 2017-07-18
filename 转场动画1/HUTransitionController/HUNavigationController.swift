//
//  HUNavigationController.swift
//  HUTransitionControllerDemo
//
//  Created by 胡校明 on 2016/11/1.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class HUNavigationController: UINavigationController {

    override var interactivePopGestureRecognizer: UIGestureRecognizer? {
        get {
            return slidePopDelegate.slidePopGesture
        }
    }
    
    var pushAnimationType: HUTransitionAnimation! {
        set {
            slidePopDelegate.pushAnimationType = newValue
        }
        get {
            return slidePopDelegate.pushAnimationType
        }
    }
    
    var slidePopDelegate: HUNavigationControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slidePopDelegate = HUNavigationControllerDelegate(targetViewController: self, animationType: HUTransitionAnimation.defaultPush(duration: 0.3, interactiveEnable: true))
    }

}
