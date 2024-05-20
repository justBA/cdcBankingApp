//
//  SkeletonView.swift
//  cdcBankingApp
//
//  Created by An Nguyen on 20/5/24.
//

import UIKit

class SkeletonView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        startShimmering()
    }
    
    func startShimmering() {
        let light = UIColor.white.withAlphaComponent(0.7).cgColor
        let dark = UIColor(white: 0.85, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [dark, light, dark]
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.cornerRadius = layer.cornerRadius
        layer.addSublayer(gradientLayer)
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.0, 0.25]
        animation.toValue = [0.75, 1.0, 1.0]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }
    
    func stopShimmering() {
        layer.sublayers?.forEach {
            if $0 is CAGradientLayer {
                $0.removeAllAnimations()
                $0.removeFromSuperlayer()
            }
        }
    }
}
