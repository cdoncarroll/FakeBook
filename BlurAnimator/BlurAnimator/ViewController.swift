//
//  ViewController.swift
//  BlurAnimator
//
//  Created by Chase Carroll on 8/14/23.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    let slider = UISlider(frame: .zero)
    let imageView = UIImageView(image: UIImage(named: "origami-logo"))
    let blurView = UIVisualEffectView(effect: nil)
    let blurAnimator = UIViewPropertyAnimator(duration: 42.0, curve: .linear) // While 42 is the answer to life, the universe, and everything, the duration is not important to how I'll use this animation.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.sizeToFit()
        
        blurView.layer.masksToBounds = true
        
        slider.sizeToFit()
        slider.addTarget(self, action: #selector(sliderChanged(slider:)), for: .valueChanged)
        
        view.addSubview(imageView)
        view.addSubview(blurView)
        view.addSubview(slider)
        
        blurAnimator.addAnimations {
            self.blurView.effect = UIBlurEffect(style: .systemThinMaterial)
        }
        blurAnimator.pauseAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.center = CGPoint(
            x: view.bounds.midX,
            y: view.bounds.midY
        )
        
        blurView.frame = imageView.frame.insetBy(dx: -32.0, dy: -32.0)
        blurView.layer.cornerRadius = blurView.bounds.height / 2.0
        
        slider.frame = CGRect(
            origin: CGPoint(
                x: imageView.frame.minX,
                y: blurView.frame.maxY + 16.0
            ),
            size: CGSize(
                width: imageView.bounds.width,
                height: slider.bounds.height
            )
        )
    }

    @objc func sliderChanged(slider: UISlider) {
        blurAnimator.fractionComplete = CGFloat(slider.value)
    }

}

