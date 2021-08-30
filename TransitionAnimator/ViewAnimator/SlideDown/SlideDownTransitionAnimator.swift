//
//  SlideDownTransitionAnimator.swift
//  TransitionAnimator
//
//  Created by Adnann Muratovic on 30.08.21.
//

import Foundation
import UIKit

// MARK: - Create Slide down Animator
class SlideDownTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    let duration = 0.5
    var isPresenting = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Get the reference to our from View, to View and teh container
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        
        // Set the transform we'll use in the animation
        let container = transitionContext.containerView
        
        let offScreenUp = CGAffineTransform(translationX: 0, y: -container.frame.height)
        let offScrenDown = CGAffineTransform(translationX: 0, y: container.frame.height)
        
        // Make the toView off screen
        if isPresenting {
            toView.transform = offScreenUp
        }
        
        // Add both view to the containerView
        container.addSubview(fromView)
        container.addSubview(toView)
        
        // Perform Animation
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: []) {
            if self.isPresenting {
                fromView.transform = offScrenDown
                fromView.alpha = 0.5
                toView.transform = CGAffineTransform.identity
                toView.alpha = 1.0
            } else {
                fromView.transform = offScreenUp
                fromView.alpha = 1.0
                toView.transform = CGAffineTransform.identity
                toView.alpha = 1.0
            }
        } completion: { finished in
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
