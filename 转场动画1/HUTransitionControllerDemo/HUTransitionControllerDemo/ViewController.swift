//
//  ViewController.swift
//  HUTransitionControllerDemo
//
//  Created by 胡校明 on 2016/11/1.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.contents = #imageLiteral(resourceName: "mv").cgImage
        view.backgroundColor = UIColor.gray
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let vc = ViewController()
//        let nav = self.navigationController as? HUNavigationController
//        if nav?.childViewControllers.count == 3 {
//            nav?.pushAnimationType = HUTransitionAnimation.flipOver(duration: 0.5, interactiveEnable: false)
//        } else if nav?.childViewControllers.count == 6 {
//            nav?.pushAnimationType = HUTransitionAnimation.defaultPush(duration: 0.3, interactiveEnable: true)
//        } else if nav?.childViewControllers.count == 8 {
//            nav?.pushAnimationType = HUTransitionAnimation.flipOver(duration: 0.5, interactiveEnable: false)
//        }
//        nav?.pushViewController(vc, animated: true)
//        vc.title = "\(nav?.childViewControllers.count)";
//    }

}

