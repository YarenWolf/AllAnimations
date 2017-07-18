//
//  HUTableViewController.swift
//  HUTransitionControllerDemo
//
//  Created by 胡校明 on 2016/11/2.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class HUTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.contents = #imageLiteral(resourceName: "fj").cgImage
        navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "backGround"), for: .default)
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.navigationItem.title == "PUSH测试" {
            pushTest(indexPath: indexPath)
        }
        
        if self.navigationItem.title == "tabBar转场测试" {
            tabBarTransitionTest(indexPath: indexPath)
        }
        
        if self.navigationItem.title == "Modal测试" {
            modalTest(indexPath: indexPath)
        }
    }
    
    func pushTest(indexPath: IndexPath) {
        let vc = ViewController()
        let nav = navigationController as? HUNavigationController
        if indexPath.row == 0 {
            nav?.pushAnimationType = HUTransitionAnimation.defaultPush(duration: 0.3, interactiveEnable: true)
        } else if indexPath.row == 1 {
            nav?.pushAnimationType = HUTransitionAnimation.crossDissolve(duration: 0.3, interactiveEnable: true)
        } else if indexPath.row == 2 {
            nav?.pushAnimationType = HUTransitionAnimation.flipOver(duration: 0.5, interactiveEnable: true)
        } else if indexPath.row == 3 {
            nav?.pushAnimationType = HUTransitionAnimation.blindsHorizontal(duration: 1, interactiveEnable: true)
        } else if indexPath.row == 4 {
            nav?.pushAnimationType = HUTransitionAnimation.brokenScreen(duration: 1, interactiveEnable: true)
        }
        vc.hidesBottomBarWhenPushed = true
        nav?.pushViewController(vc, animated: true)
    }
    
    func tabBarTransitionTest(indexPath: IndexPath) {
        let tabVC = tabBarController as? HUTabBarController
        if indexPath.row == 0 {
            tabVC?.tansitionAnimationType = HUTransitionAnimation.translation(duration: 0.3, interactiveEnable: false)
        } else if indexPath.row == 1 {
            tabVC?.tansitionAnimationType = HUTransitionAnimation.crossDissolve(duration: 0.3, interactiveEnable: true)
        } else if indexPath.row == 2 {
            tabVC?.tansitionAnimationType = HUTransitionAnimation.flipOver(duration: 0.5, interactiveEnable: true)
        } else if indexPath.row == 3 {
            tabVC?.tansitionAnimationType = HUTransitionAnimation.blindsHorizontal(duration: 1, interactiveEnable: true)
        } else if indexPath.row == 4 {
            tabVC?.tansitionAnimationType = HUTransitionAnimation.brokenScreen(duration: 1, interactiveEnable: true)
        }
    }
    
    func modalTest(indexPath: IndexPath) {
        let vc = ViewController()
        if indexPath.row == 0 {
            vc.presentTransitionDelegate = HUViewControllerTransitioningDelegate(targetViewController: vc, animationType: HUTransitionAnimation.presentation(duration: 0.3, interactiveEnable: true))
        } else if indexPath.row == 1 {
            vc.presentTransitionDelegate = HUViewControllerTransitioningDelegate(targetViewController: vc, animationType: HUTransitionAnimation.crossDissolve(duration: 0.3, interactiveEnable: true))
        } else if indexPath.row == 2 {
            vc.presentTransitionDelegate = HUViewControllerTransitioningDelegate(targetViewController: vc, animationType: HUTransitionAnimation.flipOver(duration: 0.5, interactiveEnable: true))
        } else if indexPath.row == 3 {
            vc.presentTransitionDelegate = HUViewControllerTransitioningDelegate(targetViewController: vc, animationType: HUTransitionAnimation.blindsHorizontal(duration: 1, interactiveEnable: true))
        } else if indexPath.row == 4 {
            vc.presentTransitionDelegate = HUViewControllerTransitioningDelegate(targetViewController: vc, animationType: HUTransitionAnimation.blindsVertical(duration: 1, interactiveEnable: true))
        } else if indexPath.row == 5 {
            vc.presentTransitionDelegate = HUViewControllerTransitioningDelegate(targetViewController: vc, animationType: HUTransitionAnimation.brokenScreen(duration: 1, interactiveEnable: true))
        }
        vc.interactiveDismmisGestureRecognizer?.isEnabled = true
        present(vc, animated: true, completion: nil)
    }
    

}
