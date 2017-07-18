//
//  HUAnimationProtocol.swift
//  HUTransitionControllerDemo
//
//  Created by 胡校明 on 2016/11/1.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit

/// 框架自带动画类型
///
/// - none: 无, PS: 不能使用
/// - custom->:     自定义转场方式, 自己发挥, PS: 当你在custom中, 使用系统提供的转场动画时,必须关闭手势响应(原因: 系统转场不管成功失败默认移除 fromView, 如果手势控制转场失败 toView 也会被移除, containerView上的 view 将被清空, 无法继续执行转场)
/// - translation:      平移动画, tabBarController默认动画, PS: 建议只用于tabBarController转场
/// - defaultPush:      平移动画, navigationController默认动画, PS: 建议只用于navigationController转场
/// - presentation:     底部推出, Modal默认动画, PS: 建议只用于Modal转场
/// - crossDissolve:    逐渐消融
/// - flipOver:         页面翻转(PS: 在Modal转场中, 手势交互存在异常)
/// - blindsHorizontal: 水平百叶窗
/// - blindsVertical:   垂直百叶窗
/// - brokenScreen:     碎屏动画
public enum HUTransitionAnimation {
    /// 尔等切记此属性, 只可远观, 而不可亵玩焉!!!
    case none
    
    case custom(duration: TimeInterval, interactiveEnable: Bool, animation: (HUTransitionParts) -> ())
    case translation(duration: TimeInterval, interactiveEnable: Bool)
    case defaultPush(duration: TimeInterval, interactiveEnable: Bool)
    
    case presentation(duration: TimeInterval, interactiveEnable: Bool)
    case crossDissolve(duration: TimeInterval, interactiveEnable: Bool)
    case flipOver(duration: TimeInterval, interactiveEnable: Bool)
    case blindsHorizontal(duration: TimeInterval, interactiveEnable: Bool)
    case blindsVertical(duration: TimeInterval, interactiveEnable: Bool)
    case brokenScreen(duration: TimeInterval, interactiveEnable: Bool)
    
    var duration: TimeInterval {
        switch self {
        case .none:                                 return 0
        case .custom(let duration, _, _):           return duration
        case .translation(let duration, _):         return duration
        case .defaultPush(let duration, _):         return duration
        case .presentation(let duration, _):        return duration
        case .crossDissolve(let duration, _):       return duration
        case .flipOver(let duration, _):            return duration
        case .blindsHorizontal(let duration, _):    return duration
        case .blindsVertical(let duration, _):      return duration
        case .brokenScreen(let duration, _):        return duration
        }
    }
    
    var interactiveEnable: Bool {
        switch self {
        case .none:                                         return false
        case .custom(_, let interactiveEnable, _):          return interactiveEnable
        case .translation(_, let interactiveEnable):        return interactiveEnable
        case .defaultPush(_, let interactiveEnable):        return interactiveEnable
        case .presentation(_, let interactiveEnable):       return interactiveEnable
        case .crossDissolve(_, let interactiveEnable):      return interactiveEnable
        case .flipOver(_, let interactiveEnable):           return interactiveEnable
        case .blindsHorizontal(_, let interactiveEnable):   return interactiveEnable
        case .blindsVertical(_, let interactiveEnable):     return interactiveEnable
        case .brokenScreen(_, let interactiveEnable):       return interactiveEnable
        }
    }
    
}

internal protocol HUAnimationProtocol {
    
    // 三种方式的默认动画类型
    func transitionByTransilation(using transitionParts: HUTransitionParts)
    func transitionByDefaultPush(using transitionParts: HUTransitionParts)
    func transitionByPresentation(using transitionParts: HUTransitionParts)
    
    // 其他动画类型
    func transitionByCrossDissolve(using transitionParts: HUTransitionParts)
    func transitionByFlipOver(using transitionParts: HUTransitionParts)
    func transitionByBlindsHorizontal(using transitionParts: HUTransitionParts)
    func transitionByBlindsVertical(using transitionParts: HUTransitionParts)
    func transitionByBrokenScreen(using transitionParts: HUTransitionParts)
}

extension HUAnimationProtocol {
    
    func transitionByTransilation(using transitionParts: HUTransitionParts) {
        let width = transitionParts.containerView.bounds.width
        var fromViewTransform = CGAffineTransform.identity
        if transitionParts.operation == .forward {
            transitionParts.toView.transform = CGAffineTransform(translationX: width, y: 0)
            fromViewTransform = CGAffineTransform(translationX: -width, y: 0)
        } else {
            transitionParts.toView.transform = CGAffineTransform(translationX: -width, y: 0)
            fromViewTransform = CGAffineTransform(translationX: width, y: 0)
        }
        UIView.animate(withDuration: transitionParts.duration,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        transitionParts.toView.transform = CGAffineTransform.identity
                        transitionParts.fromView.transform = fromViewTransform
        }) { (_) in
            transitionParts.completed({
                transitionParts.fromView.transform = CGAffineTransform.identity
                transitionParts.toView.transform = CGAffineTransform.identity
            })
        }
    }
    
    func transitionByDefaultPush(using transitionParts: HUTransitionParts) {
        let width = transitionParts.containerView.bounds.width
        var fromViewTransform = CGAffineTransform.identity
        if transitionParts.operation == .forward {
            transitionParts.toView.layer.shadowColor = UIColor.black.cgColor
            transitionParts.toView.layer.shadowOpacity = 0.6
            transitionParts.toView.layer.shadowRadius = 5;
            transitionParts.toView.layer.shadowOffset = CGSize(width: -5, height: 0)
            transitionParts.toView.transform = CGAffineTransform(translationX: width, y: 0)
            fromViewTransform = CGAffineTransform(translationX: -width/2, y: 0)
        } else {
            transitionParts.fromView.layer.shadowColor = UIColor.black.cgColor
            transitionParts.fromView.layer.shadowOpacity = 0.6
            transitionParts.fromView.layer.shadowRadius = 5;
            transitionParts.fromView.layer.shadowOffset = CGSize(width: -5, height: 0)
            transitionParts.toView.transform = CGAffineTransform(translationX: -width/2, y: 0)
            fromViewTransform = CGAffineTransform(translationX: width, y: 0)
        }
        UIView.animate(withDuration: transitionParts.duration,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        transitionParts.toView.transform = CGAffineTransform.identity
                        transitionParts.fromView.transform = fromViewTransform
        }) { (_) in
            transitionParts.completed(nil)
        }
    }
    
    func transitionByPresentation(using transitionParts: HUTransitionParts) {
        let height = transitionParts.containerView.bounds.height
        var fromViewTransform = CGAffineTransform.identity
        if transitionParts.operation == .forward {
            transitionParts.toView.transform = CGAffineTransform(translationX: 0, y: height)
        } else {
            fromViewTransform = CGAffineTransform(translationX: 0, y: height)
        }
        UIView.animate(withDuration: transitionParts.duration,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        transitionParts.toView.transform = CGAffineTransform.identity
                        transitionParts.fromView.transform = fromViewTransform
        }) { (_) in
            transitionParts.completed(nil)
        }
    }
    
    func transitionByCrossDissolve(using transitionParts: HUTransitionParts) {
        transitionParts.toView.alpha = 0
        UIView.animate(withDuration: transitionParts.duration,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        transitionParts.toView.alpha = 1
                        transitionParts.fromView.alpha = 0
        }) { (_) in
            transitionParts.completed({
                transitionParts.fromView.alpha = 1
                transitionParts.toView.alpha = 1
            })
        }
    }
    
    func transitionByFlipOver(using transitionParts: HUTransitionParts) {
        transitionParts.containerView.sendSubview(toBack: transitionParts.toView)
        transitionParts.fromView.layer.isDoubleSided = false
        transitionParts.toView.layer.isDoubleSided = false
        var fromViewTransform = CATransform3DIdentity
        if transitionParts.operation == .forward {
            fromViewTransform = CATransform3DMakeRotation(CGFloat(M_PI), 0, 1, 0)
            fromViewTransform.m34 = -1.0/500.0
            transitionParts.toView.layer.transform = CATransform3DMakeRotation(CGFloat(-M_PI), 0, 1, 0)
            transitionParts.toView.layer.transform.m34 = -1.0/500.0
        } else {
            fromViewTransform = CATransform3DMakeRotation(CGFloat(-M_PI), 0, 1, 0)
            fromViewTransform.m34 = 1.0/500.0
            transitionParts.toView.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI), 0, 1, 0)
            transitionParts.toView.layer.transform.m34 = 1.0/500.0
        }
        UIView.animate(withDuration: transitionParts.duration,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        transitionParts.fromView.layer.transform = fromViewTransform
                        transitionParts.toView.layer.transform = CATransform3DIdentity
        }) { (_) in
            transitionParts.completed(nil)
        }
    }
    
    func transitionByBlindsHorizontal(using transitionParts: HUTransitionParts) {
        transitionParts.containerView.sendSubview(toBack: transitionParts.toView)
        let matrix = HUMatrix(line: 1, culom: UInt(UIScreen.main.bounds.width/25))
        var fromViewContentInset = UIEdgeInsets.zero
        var toViewContentInset = UIEdgeInsets.zero
        if let scrollView = transitionParts.fromView as? UIScrollView {
            fromViewContentInset = scrollView.contentInset
        }
        if let scrollView = transitionParts.toView as? UIScrollView {
            toViewContentInset = scrollView.contentInset
        }
        let toViews = transitionParts.toView.shearThrough(based: matrix,
                                                          afterScreenUpdates: true,
                                                          withCapInsets: toViewContentInset) {
            $0.layer.isDoubleSided = false
            transitionParts.containerView.addSubview($0)
            if transitionParts.operation == .forward {
                $0.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI), 0, 1, 0)
                $0.layer.transform.m34 = -1.0/500.0
            } else {
                $0.layer.transform = CATransform3DMakeRotation(CGFloat(-M_PI), 0, 1, 0)
                $0.layer.transform.m34 = 1.0/500.0
            }
        }
        let fromViews = transitionParts.fromView.shearThrough(based: matrix,
                                                              afterScreenUpdates: false,
                                                              withCapInsets: fromViewContentInset) {
            $0.layer.isDoubleSided = false
            transitionParts.containerView.addSubview($0)
        }
        var fromViewTransform = CATransform3DIdentity
        if transitionParts.operation == .forward {
            fromViewTransform = CATransform3DMakeRotation(CGFloat(M_PI), 0, 1, 0)
            fromViewTransform.m34 = -1.0/500.0
        } else {
            fromViewTransform = CATransform3DMakeRotation(CGFloat(-M_PI), 0, 1, 0)
            fromViewTransform.m34 = 1.0/500.0
        }
        let width = transitionParts.containerView.bounds.width
        transitionParts.fromView.transform = CGAffineTransform(translationX: width, y: 0)
        transitionParts.toView.transform = CGAffineTransform(translationX: width, y: 0)
        UIView.animate(withDuration: transitionParts.duration,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        for toView in toViews {
                            toView.layer.transform = CATransform3DIdentity
                        }
                        for fromView in fromViews {
                            fromView.layer.transform = fromViewTransform
                        }
        }) { (_) in
            transitionParts.fromView.transform = .identity
            transitionParts.toView.transform = .identity
            for view in fromViews+toViews {
                view.removeFromSuperview()
            }
            transitionParts.completed(nil)
        }
    }
    
    func transitionByBlindsVertical(using transitionParts: HUTransitionParts) {
        transitionParts.containerView.sendSubview(toBack: transitionParts.toView)
        let matrix = HUMatrix(line: UInt(UIScreen.main.bounds.height/25), culom: 1)
        var fromViewContentInset = UIEdgeInsets.zero
        var toViewContentInset = UIEdgeInsets.zero
        if let scrollView = transitionParts.fromView as? UIScrollView {
            fromViewContentInset = scrollView.contentInset
        }
        if let scrollView = transitionParts.toView as? UIScrollView {
            toViewContentInset = scrollView.contentInset
        }
        let toViews = transitionParts.toView.shearThrough(based: matrix,
                                                          afterScreenUpdates: true,
                                                          withCapInsets: toViewContentInset) {
                                                            $0.layer.isDoubleSided = false
                                                            transitionParts.containerView.addSubview($0)
                                                            if transitionParts.operation == .forward {
                                                                $0.layer.transform = CATransform3DMakeRotation(CGFloat(-M_PI), 1, 0, 0)
                                                                $0.layer.transform.m34 = 1.0/500.0
                                                            } else {
                                                                $0.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI), 1, 0, 0)
                                                                $0.layer.transform.m34 = -1.0/500.0
                                                            }
        }
        let fromViews = transitionParts.fromView.shearThrough(based: matrix,
                                                              afterScreenUpdates: false,
                                                              withCapInsets: fromViewContentInset) {
                                                                $0.layer.isDoubleSided = false
                                                                transitionParts.containerView.addSubview($0)
        }
        var fromViewTransform = CATransform3DIdentity
        if transitionParts.operation == .forward {
            fromViewTransform = CATransform3DMakeRotation(CGFloat(-M_PI), 1, 0, 0)
            fromViewTransform.m34 = 1.0/500.0
        } else {
            fromViewTransform = CATransform3DMakeRotation(CGFloat(M_PI), 1, 0, 0)
            fromViewTransform.m34 = -1.0/500.0
        }
        let width = transitionParts.containerView.bounds.width
        transitionParts.fromView.transform = CGAffineTransform(translationX: width, y: 0)
        transitionParts.toView.transform = CGAffineTransform(translationX: width, y: 0)
        UIView.animate(withDuration: transitionParts.duration,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        for toView in toViews {
                            toView.layer.transform = CATransform3DIdentity
                        }
                        for fromView in fromViews {
                            fromView.layer.transform = fromViewTransform
                        }
        }) { (_) in
            transitionParts.fromView.transform = .identity
            transitionParts.toView.transform = .identity
            for view in fromViews+toViews {
                view.removeFromSuperview()
            }
            transitionParts.completed(nil)
        }
    }
    
    func transitionByBrokenScreen(using transitionParts: HUTransitionParts) {
        transitionParts.containerView.sendSubview(toBack: transitionParts.toView)
        let proportion = transitionParts.containerView.bounds.width / transitionParts.containerView.bounds.height
        let matrix = HUMatrix(line: UInt(UIScreen.main.bounds.height/20*proportion),
                              culom: UInt(UIScreen.main.bounds.width/20))
        var fromViewContentInset = UIEdgeInsets.zero
        if let scrollView = transitionParts.fromView as? UIScrollView {
            fromViewContentInset = scrollView.contentInset
        }
        let fromViews = transitionParts.fromView.shearThrough(based: matrix, afterScreenUpdates: false, withCapInsets: fromViewContentInset) {
            transitionParts.containerView.addSubview($0)
        }
        func randomFloatBetween(_ smallNumber: CGFloat, and bigNumber: CGFloat) -> CGFloat {
            let diff = bigNumber - smallNumber
            return (CGFloat(arc4random())/100.0).truncatingRemainder(dividingBy: diff) + smallNumber
        }
        transitionParts.fromView.transform = CGAffineTransform(translationX: transitionParts.containerView.bounds.width, y: 0)
        let height = transitionParts.containerView.bounds.height
        UIView.animate(withDuration: transitionParts.duration,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        for fromView in fromViews {
                            let xOffset = randomFloatBetween(-200 , and: 200)
                            let yOffset = randomFloatBetween(height, and: height * 1.3)
                            fromView.layer.transform = CATransform3DMakeTranslation(xOffset, yOffset, 0)
                            fromView.alpha = 0;
                        }
        }) { (_) in
            for view in fromViews {
                view.removeFromSuperview()
            }
            transitionParts.completed({ 
                transitionParts.fromView.transform = .identity
            })
        }
    }
    
}


struct HUMatrix {
    let line: UInt
    let culom: UInt
}

extension UIView {
    
    /// 基于矩阵类型切割视图
    ///
    /// - Parameters:
    ///   - matrix:     基于切割的矩阵类型
    ///   - isUpdate:   是否强制视图渲染完毕后才切割
    ///   - inset:      基于切割的内边距
    ///   - expression: 对切割好的 view 进行相应的处理
    /// - Returns:      切🈹好的 views
    func shearThrough(based matrix: HUMatrix,
                      afterScreenUpdates isUpdate: Bool,
                      withCapInsets inset: UIEdgeInsets,
                      dealWith expression: (UIView) -> ()) -> [UIView] {
        var views = [UIView]()
        guard matrix.line != 0 && matrix.culom != 0 else { return views }
        let width = frame.width/CGFloat(matrix.culom)
        let height = frame.height/CGFloat(matrix.line)
        print(Date(timeIntervalSinceNow: 0))
        for i in 0..<matrix.line {
            let y = CGFloat(i)*height
            for j in 0..<matrix.culom {
                let x = CGFloat(j)*width
                var frame = CGRect(x: x, y: y, width: width, height: height)
                guard let view = resizableSnapshotView(from: frame, afterScreenUpdates: isUpdate, withCapInsets: .zero) else { return views }
                frame.origin.y += inset.top
                view.frame = frame
                expression(view)
                views.append(view)
            }
        }
        print(Date(timeIntervalSinceNow: 0), views.count)
        return views
    }
    
}


