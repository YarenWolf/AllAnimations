//
//  HUAnimationController.swift
//  HUTransitionControllerDemo
//
//  Created by 胡校明 on 2016/11/1.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

public enum HUViewControllerTransitionType {
    case NavTransition(HUNavigationControllerOperation)
    case TabTransition(HUTabBarControllerOperation)
    case ModalTransiation(HUModalTrasitionOperation)
    func operation<T>(initialResult result: T) -> T {
        switch self {
        case .NavTransition(let op): return converType(result: result, operation: op)
        case .TabTransition(let op): return converType(result: result, operation: op)
        case .ModalTransiation(let op): return converType(result: result, operation: op)
        }
    }
    private func converType<T,O>( result: T, operation: O) -> T {
        var tempResult = result
        tempResult = operation as! T
        return tempResult
    }
}

public enum HUNavigationControllerOperation {
    case none(HUTransitionAnimation)
    case push(HUTransitionAnimation)
    case pop(HUTransitionAnimation)
    init() { self = .none(.none) }
    func animation() -> HUTransitionAnimation {
        switch self {
        case .push(let animation): return animation
        case .pop(let animation): return animation
        case .none(let animation): return animation
        }
    }
}

public  enum HUTabBarControllerOperation {
    case none(HUTransitionAnimation)
    case left(HUTransitionAnimation)
    case right(HUTransitionAnimation)
    init() { self = .none(.none) }
    func animation() -> HUTransitionAnimation {
        switch self {
        case .left(let animation): return animation
        case .right(let animation): return animation
        case .none(let animation): return animation
        }
    }
}

public enum HUModalTrasitionOperation {
    case none(HUTransitionAnimation)
    case present(HUTransitionAnimation)
    case dismmis(HUTransitionAnimation)
    init() { self = .none(.none) }
    func animation() -> HUTransitionAnimation {
        switch self {
        case .present(let animation): return animation
        case .dismmis(let animation): return animation
        case .none(let animation): return animation
        }
    }
}

/// 转场方向
///
/// - forward:  前进
/// - backward: 回退
public enum HUTransitionOperation {
    case forward
    case backward
}

/// 执行动画的组件
public struct HUTransitionParts{
    let duration: TimeInterval
    let fromView: UIView
    let toView: UIView
    let containerView: UIView
    let operation: HUTransitionOperation
    
    /// 动画执行结束后的回调, PS: 必须执行
    /// - reset: 回调参数, 用于 tabBarController 转场, PS: 动画结束后必须恢复 fromView 的属性, 否则会出现异常
    let completed: (_ reset: (() -> ())?) -> ()
}

class HUAnimationController: NSObject, UIViewControllerAnimatedTransitioning, HUAnimationProtocol {

    let transitionType: HUViewControllerTransitionType
    
    var tabBarPanGesture: UIPanGestureRecognizer?
    
    var duration: TimeInterval {
        get {
            switch transitionType {
            case .NavTransition:
                return transitionType.operation(initialResult: HUNavigationControllerOperation()).animation().duration
            case .TabTransition:
                return transitionType.operation(initialResult: HUTabBarControllerOperation()).animation().duration
            case .ModalTransiation:
                return transitionType.operation(initialResult: HUModalTrasitionOperation()).animation().duration
            }
        }
    }
    
    init(transitionType: HUViewControllerTransitionType) {
        self.transitionType = transitionType
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionType {
        case .NavTransition:
            prepareForTransition(useing: transitionContext, operation: transitionType.operation(initialResult: HUNavigationControllerOperation()))
        case .TabTransition:
            prepareForTransition(useing: transitionContext, operation: transitionType.operation(initialResult: HUTabBarControllerOperation()))
        case .ModalTransiation:
            prepareForTransition(useing: transitionContext, operation: transitionType.operation(initialResult: HUModalTrasitionOperation()))
        }
    }
    
    private func prepareForTransition(useing transitionContext: UIViewControllerContextTransitioning, operation: HUNavigationControllerOperation) {
        switch operation {
        case .push(let animationType):
            beginTransition(useing: animationType, transitionContext: transitionContext, transitionOperation: .forward ,isDismmis: false)
        case .pop(let animationType):
            beginTransition(useing: animationType, transitionContext: transitionContext, transitionOperation: .backward ,isDismmis: false)
        default:break
        }
    }
    
    private func prepareForTransition(useing transitionContext: UIViewControllerContextTransitioning, operation: HUTabBarControllerOperation) {
        switch operation {
        case .left(let animationType):
            beginTransition(useing: animationType, transitionContext: transitionContext, transitionOperation: .forward ,isDismmis: false)
        case .right(let animationType):
            beginTransition(useing: animationType, transitionContext: transitionContext, transitionOperation: .backward ,isDismmis: false)
        default:break
        }
    }
    
    private func prepareForTransition(useing transitionContext: UIViewControllerContextTransitioning, operation: HUModalTrasitionOperation) {
        switch operation {
        case .present(let animationType):
            beginTransition(useing: animationType, transitionContext: transitionContext, transitionOperation: .forward, isDismmis: false)
        case .dismmis(let animationType):
            beginTransition(useing: animationType, transitionContext: transitionContext, transitionOperation: .backward, isDismmis: true)
        default:break
        }
    }
    
    private func beginTransition(useing animationType: HUTransitionAnimation, transitionContext: UIViewControllerContextTransitioning, transitionOperation: HUTransitionOperation, isDismmis: Bool) {
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else { return }
        guard  let fromView = fromVC.view, let toView = toVC.view else { return }
        if !isDismmis {
            addSubView(useing: toView, to: transitionContext.containerView, withTransitionOperation: transitionOperation)
        }
        let transitionParts = HUTransitionParts(duration: duration, fromView: fromView, toView: toView, containerView: transitionContext.containerView, operation: transitionOperation) {
            if let rest = $0 { rest() }
            guard let containerNav = fromVC.navigationController as? HUNavigationController, let containerTab = fromVC.tabBarController as? HUTabBarController else {
                if let containerNav = toVC.navigationController as? HUNavigationController, let containerTab = toVC.tabBarController as? HUTabBarController {
                    containerTab.interactiveTransitionGestureRecognizer?.isEnabled = containerNav.childViewControllers.count <= 1 && !transitionContext.transitionWasCancelled
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
            }
            containerTab.interactiveTransitionGestureRecognizer?.isEnabled = containerNav.childViewControllers.count <= 1 && !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        matchingAnimation(useing: animationType, transitionParts: transitionParts)
    }
    
    private func addSubView(useing subView: UIView, to superView: UIView, withTransitionOperation operation: HUTransitionOperation) {
        superView.addSubview(subView)
        switch operation {
        case .forward: superView.bringSubview(toFront: subView)
        case .backward: superView.sendSubview(toBack: subView)
        }
    }
    
    private func matchingAnimation(useing animationType: HUTransitionAnimation, transitionParts: HUTransitionParts) {
        switch animationType {
        case .custom(_, _,let customAnimation): customAnimation(transitionParts)
        case .translation:      transitionByTransilation(using: transitionParts)
        case .defaultPush:      transitionByDefaultPush(using: transitionParts)
        case .presentation:     transitionByPresentation(using: transitionParts)
        case .crossDissolve:    transitionByCrossDissolve(using: transitionParts)
        case .flipOver:         transitionByFlipOver(using: transitionParts)
        case .blindsHorizontal: transitionByBlindsHorizontal(using: transitionParts)
        case .blindsVertical:   transitionByBlindsVertical(using: transitionParts)
        case .brokenScreen:     transitionByBrokenScreen(using: transitionParts)
        default:break
        }
    }
    
}
