//
//  HUNavigationControllerDelegate.swift
//  HUTransitionControllerDemo
//
//  Created by 胡校明 on 2016/11/1.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

class HUNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {

    private var allowPopBySliding = false
    
    private weak var targetViewController: UINavigationController?
    
    internal let slidePopGesture = UIScreenEdgePanGestureRecognizer()
    
    private let interactiveTransition = UIPercentDrivenInteractiveTransition()
    
    private var animationTypes = [HUTransitionAnimation]()
    
    var pushAnimationType: HUTransitionAnimation {
        set {
            let aCount = animationTypes.count
            guard let cCount = targetViewController?.childViewControllers.count else { return }
            if aCount == cCount {
                animationTypes[aCount-1] = newValue
            } else {
                for i in 1...cCount - aCount {
                    animationTypes.append(i == cCount - aCount ? newValue : animationTypes.last!)
                }
            }
        }
        get {
            return animationTypes.last!
        }
    }
    
    private func popAnimationType(toViewControllerIndex index: Int) -> HUTransitionAnimation {
        return animationTypes[animationTypes.count-2 == index ? index : animationTypes.count-1]
    }
    
    init(targetViewController: UINavigationController, animationType: HUTransitionAnimation?) {
        super.init()
        self.targetViewController = targetViewController
        targetViewController.delegate = self
        slidePopGesture.edges = .left
        slidePopGesture.addTarget(self, action: #selector(self.popBySlide))
        self.targetViewController?.view.addGestureRecognizer(slidePopGesture)
        pushAnimationType = animationType ?? .translation(duration: 0.3, interactiveEnable: true)
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return allowPopBySliding ? interactiveTransition : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HUAnimationController(transitionType: .NavTransition(operation == .push ? .push(pushAnimationType) : .pop(popAnimationType(toViewControllerIndex: navigationController.childViewControllers.index(of: toVC)!))))
    }
    
    @objc private func popBySlide() {
        guard let targetVC = targetViewController else { return }
        var percent = slidePopGesture.translation(in: targetVC.view).x/targetVC.view.bounds.width
        percent = min(1.0, max(0.0, percent))
        switch slidePopGesture.state {
        case .began:
            allowPopBySliding = true
            targetVC.popViewController(animated: true)
        case .changed:
            interactiveTransition.update(percent)
        case .cancelled, .ended:
            if percent > 0.3 {
                interactiveTransition.finish()
            } else {
                interactiveTransition.cancel()
            }
            allowPopBySliding = false
        default: break
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if animationTypes.count >= navigationController.childViewControllers.count {
            animationTypes.removeLast(animationTypes.count-navigationController.childViewControllers.count)
            let index = animationTypes.count-2
            slidePopGesture.isEnabled = animationTypes[index>0 ? index : 0].interactiveEnable
        } else {
            slidePopGesture.isEnabled = animationTypes.last!.interactiveEnable
        }
    }
    
}
