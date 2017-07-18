//
//  HUTabBarControllerDelegate.swift
//  HUTransitionControllerDemo
//
//  Created by 胡校明 on 2016/11/1.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

public enum HUDirectionn: CGFloat {
    case none = 0
    case left = -1
    case right = 1
}

class HUTabBarControllerDelegate: NSObject, UITabBarControllerDelegate {

    private var slidingDirection: HUDirectionn = .none
    
    private var allowTransitonBySliding = false
    
    private weak var targetViewController: UITabBarController?
    
    internal let slideGesture = UIPanGestureRecognizer()
    
    private let interactiveTransition = UIPercentDrivenInteractiveTransition()
    
    internal var animationType = HUTransitionAnimation.translation(duration: 0.3, interactiveEnable: true)
    
    init(targetViewController: UITabBarController, animationType: HUTransitionAnimation?) {
        super.init()
        self.targetViewController = targetViewController
        targetViewController.delegate = self
        slideGesture.addTarget(self, action: #selector(self.transitionBySlide))
        self.targetViewController?.view.addGestureRecognizer(slideGesture)
        if let type = animationType { self.animationType = type }
        slideGesture.isEnabled = self.animationType.interactiveEnable
    }
    
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return allowTransitonBySliding ? interactiveTransition : nil
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let fromIndex = tabBarController.childViewControllers.index(of: fromVC),
            let toIndex = tabBarController.childViewControllers.index(of: toVC) else { return nil }
        let operation = fromIndex < toIndex ? HUTabBarControllerOperation.left(animationType) : HUTabBarControllerOperation.right(animationType)
        return HUAnimationController(transitionType: .TabTransition(operation))
    }
    
    @objc private func transitionBySlide() {
        guard let targetVC = targetViewController else { return }
        var percent = slidingDirection.rawValue*slideGesture.translation(in: targetVC.view).x/targetVC.view.bounds.width
        percent = min(1.0, max(0.0, percent))
        switch slideGesture.state {
        case .began:
            allowTransitonBySliding = true
            if slideGesture.velocity(in: targetVC.view).x > 0 {
                if targetVC.selectedIndex > 0 {
                    targetVC.selectedIndex -= 1
                    slidingDirection = .right
                }
            } else {
                if targetVC.selectedIndex < targetVC.childViewControllers.count - 1 {
                    targetVC.selectedIndex += 1
                    slidingDirection = .left
                }
            }
        case .changed:
            interactiveTransition.update(percent)
        case .cancelled, .ended:
            if percent > 0.3 {
                interactiveTransition.finish()
            } else {
                interactiveTransition.cancel()
            }
            interactiveTransition.completionSpeed = 1
            allowTransitonBySliding = false
            slidingDirection = .none
        default: break
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        slideGesture.isEnabled = animationType.interactiveEnable
    }

}
