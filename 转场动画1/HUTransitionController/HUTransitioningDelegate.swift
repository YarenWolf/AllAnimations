//
//  HUViewControllerTransitioningDelegate.swift
//  HUTransitionControllerDemo
//
//  Created by 胡校明 on 2016/11/1.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

protocol UIViewControllerProtocol: NSObjectProtocol {
    var interactiveDismmisGestureRecognizer: UIPanGestureRecognizer? { get }
    var presentTransitionDelegate: HUViewControllerTransitioningDelegate? { set get }
}

private let presentTransitionDelegateKey = UnsafeRawPointer("presentTransitionDelegate")

extension UIViewControllerProtocol {
    
    /// dismmis 的手势
    var interactiveDismmisGestureRecognizer: UIPanGestureRecognizer? {
        return self.presentTransitionDelegate?.slideDismmisGesture
    }
    
    var presentTransitionDelegate : HUViewControllerTransitioningDelegate? {
        set {
            objc_setAssociatedObject(self, presentTransitionDelegateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, presentTransitionDelegateKey) as? HUViewControllerTransitioningDelegate
        }
    }
    
}

extension UIViewController: UIViewControllerProtocol { }


class HUViewControllerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    private var allowDismmisBySliding = false
    
    private weak var targetViewController: UIViewController?
    
    internal let slideDismmisGesture = UIPanGestureRecognizer()
    
    private let interactiveTransition = UIPercentDrivenInteractiveTransition()
    
    var animationType = HUTransitionAnimation.presentation(duration: 0.3, interactiveEnable: true)
    
    init(targetViewController: UIViewController, animationType: HUTransitionAnimation?) {
        super.init()
        self.targetViewController = targetViewController
        targetViewController.transitioningDelegate = self
        targetViewController.modalPresentationStyle = .custom
        slideDismmisGesture.addTarget(self, action: #selector(self.dismmisBySlide))
        self.targetViewController?.view.addGestureRecognizer(slideDismmisGesture)
        if let type = animationType { self.animationType = type }
        slideDismmisGesture.isEnabled = self.animationType.interactiveEnable
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HUAnimationController(transitionType: .ModalTransiation(.present(animationType)))
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HUAnimationController(transitionType: .ModalTransiation(.dismmis(animationType)))
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return allowDismmisBySliding ? interactiveTransition : nil
    }
    
    @objc private func dismmisBySlide() {
        guard let targetVC = targetViewController else { return }
        var percent = slideDismmisGesture.translation(in: targetVC.view).y/targetVC.view.bounds.height
        percent = min(percent, 1.0)
        switch slideDismmisGesture.state {
        case .began:
            allowDismmisBySliding = true
            targetVC.dismiss(animated: true, completion: nil)
        case .changed:
            interactiveTransition.update(percent)
        case .cancelled, .ended:
            if percent > 0.3 {
                interactiveTransition.finish()
            } else {
                interactiveTransition.cancel()
            }
            interactiveTransition.completionSpeed = 1
            allowDismmisBySliding = false
        default: break
        }
    }
    
}
