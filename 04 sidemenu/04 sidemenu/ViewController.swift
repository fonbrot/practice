//
//  ViewController.swift
//  04 sidemenu
//

import UIKit

class ViewController: UIViewController {
    
    var centerViewController: CenterViewController!
    var sideViewController: SideViewController?
    var slideOffset:CGFloat = 60
    
    var showSidePanel = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CenterViewController") as! CenterViewController
        
        view.addSubview(centerViewController.view)
        addChildViewController(centerViewController)
        centerViewController.didMove(toParentViewController: self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGestureRecognizer.delegate = self
        centerViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func animateSidePanel(expand: Bool) {
        if expand {
            self.showSidePanel = true
            animateSidePositionX(targetPosition: centerViewController.view.frame.width - slideOffset)
        } else {
            animateSidePositionX(targetPosition: 0) { _ in
                self.showSidePanel = false
                self.sideViewController?.view.removeFromSuperview()
                self.sideViewController = nil
            }
        }
    }
    
    func addSidePanel() {
        guard sideViewController == nil else {return}
        let sideVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SideViewController") as! SideViewController
        view.insertSubview(sideVC.view, at: 0)
        addChildViewController(sideVC)
        sideVC.didMove(toParentViewController: self)
        sideViewController = sideVC
    }
    
    func animateSidePositionX(targetPosition: CGFloat, completion: ((Bool)->())? = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.centerViewController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    @objc func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        
        let panFromLeftToRight = recognizer.velocity(in: view).x > 0
        
        switch recognizer.state {
        case .began:
            if !showSidePanel && panFromLeftToRight { addSidePanel()}
        case .changed:
            if let recView = recognizer.view {
                var position = recView.center.x + recognizer.translation(in: view).x
                if position < view.center.x { position = view.center.x }
                recView.center.x = position
                recognizer.setTranslation(CGPoint.zero, in: view)
            }
        case .ended:
            if let recView = recognizer.view {
                let positionGreaterCenter = recView.center.x > view.bounds.size.width
                animateSidePanel(expand: positionGreaterCenter)
            }
        default: break
        }
    }
}

