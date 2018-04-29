//
//  ViewController.swift
//  08 imagescroller
//
//  Created by 1 on 07/04/2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageBottomConstarint: NSLayoutConstraint!
    @IBOutlet weak var imageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageLeadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "moon.jpg", ofType: nil) {
            imageView.image = UIImage(contentsOfFile: path)
            imageView.sizeToFit()
            scrollView.contentSize = imageView.bounds.size
        }
        
        setupGestureRecognizer()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        updateMinZoomScale(view.bounds.size)
    }
    
    private func updateMinZoomScale(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    private func setupGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            UIView.animate(withDuration: 0.3) { [unowned self] in
                self.scrollView.zoomScale = self.scrollView.minimumZoomScale
            }
        } else {
            UIView.animate(withDuration: 0.3) { [unowned self] in
                self.scrollView.zoomScale = self.scrollView.maximumZoomScale
            }
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForZoom(view.bounds.size)
    }
    
    private func updateConstraintsForZoom(_ size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.width) / 2)
        imageTopConstraint.constant = yOffset
        imageBottomConstarint.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageLeadingConstraint.constant = xOffset
        imageTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
}

