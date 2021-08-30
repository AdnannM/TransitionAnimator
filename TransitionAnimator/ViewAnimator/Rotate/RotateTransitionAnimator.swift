//
//  RotateTransitionAnimator.swift
//  TransitionAnimator
//
//  Created by Adnann Muratovic on 30.08.21.
//

import Foundation
import UIKit


class RotateTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    let duration = 0.5
    var isPresenting = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        
        let container = transitionContext.containerView
        
        // Set the transform for rotation
        // The ange is in radian. To convert from degree to radian
        // radian = ange * pi / 180
        
        let rotate = CGAffineTransform(rotationAngle: -90 * CGFloat.pi / 180)
        
        // Change the anchor point
        toView.layer.anchorPoint = CGPoint(x: 0, y: 0)
        fromView.layer.anchorPoint = CGPoint(x: 0, y: 0)
        toView.layer.position = CGPoint(x: 0, y: 0)
        fromView.layer.position = CGPoint(x: 0, y: 0)
        
        toView.transform = rotate
        
        container.addSubview(toView)
        container.addSubview(fromView)
        
        // Perform Animation
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: []) {
            if self.isPresenting {
                fromView.transform = rotate
                fromView.alpha = 0
                toView.transform = CGAffineTransform.identity
                toView.alpha = 1.0
            } else {
                fromView.alpha = 0
                fromView.transform = rotate
                toView.alpha = 1.0
                toView.transform = CGAffineTransform.identity
            }
        } completion: { finish in
            transitionContext.completeTransition(true)
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}
