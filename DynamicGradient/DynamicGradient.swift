//
//  DynamicGradient.swift
//  DynamicGradient
//
//  Created by Matt McEachern on 12/22/15.
//  Copyright © 2015 Matt McEachern. All rights reserved.
//

import UIKit

// sea-green colors, one light and one dark
private let COLOR_1 = UIColor(hexValue: 0x6baca4)
private let COLOR_2 = UIColor(hexValue: 0x125444)

// number of individual instances in the replication layer
private let INSTANCE_COUNT = 100 // increase for smoother wave

// sine wave parameters
private let NUMBER_OF_POINTS = 50 // increase for smoother wave
private let NUMBER_OF_CYCLES = 2 // increase for more rapid wave
private let AMPLITUDE: Float = 150.0 // increase for taller waves
private let ANIMATION_DURATION = 10.0 // increase for less srapid wave

// time it takes for animation to get set up
private let SET_UP_DURATION = 1.0 // increase for slower, narrower waves

class DynamicGradient: UIView {
    
    private let colors = [COLOR_1.CGColor, COLOR_2.CGColor]
    private var replicationLayer: CAReplicatorLayer!
    private var instanceLayer: CAGradientLayer!
    private var animation: CAKeyframeAnimation!
    
    init() {
        super.init(frame: CGRectZero)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        
        /*--------- Replication Layer ---------*/
        
        let replicationLayer = CAReplicatorLayer()
        // small x-offset so that instances fill the visible screen
        replicationLayer.frame.origin = CGPoint(x: self.bounds.width / CGFloat(INSTANCE_COUNT) / 2.0, y: self.center.y)
        replicationLayer.backgroundColor = UIColor.clearColor().CGColor
        
        replicationLayer.instanceCount = INSTANCE_COUNT
        replicationLayer.instanceDelay = SET_UP_DURATION / Double(INSTANCE_COUNT)
        replicationLayer.instanceTransform = CATransform3DMakeTranslation(self.bounds.width / CGFloat(INSTANCE_COUNT), 0.0, 0.0)
        self.replicationLayer = replicationLayer
        self.layer.addSublayer(replicationLayer)
        
        /*------------Instance Layer------------*/
        
        // a tall, narrow gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width / CGFloat(INSTANCE_COUNT), height: self.bounds.height + CGFloat(2 * AMPLITUDE))
        gradientLayer.colors = colors
        gradientLayer.locations = [0.15, 0.85]
        replicationLayer.addSublayer(gradientLayer)
        self.instanceLayer = gradientLayer
        
        /*--------------Animations--------------*/
        
        // creating an animation path with discrete sinusoidal points
        let sinePath = UIBezierPath()
        sinePath.moveToPoint(CGPoint(x: 0, y: 0))
        for x in 1...NUMBER_OF_POINTS {
            
            // calculating the next point in the path, according to f(t) = Amp * sin(t)
            let t = Float(x) * Float(2.0) * Float(M_PI) * Float(NUMBER_OF_CYCLES) / Float(NUMBER_OF_POINTS)
            let f = CGFloat(AMPLITUDE * sinf(t))
            
            // sinusoidal motion along y axis only
            sinePath.addLineToPoint(CGPoint(x: CGFloat(0.0), y: f))
        }
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.duration = ANIMATION_DURATION
        animation.path = sinePath.CGPath
        animation.calculationMode = kCAAnimationLinear
        animation.repeatCount = Float(Int.max)
        animation.fillMode = kCAFillModeForwards
        self.animation = animation
        
    }
    
    // displays a gray loading screen while the animation is being setup
    private func setUpLoadingScreen() {
        let loadingLayer = CALayer()
        loadingLayer.frame = self.bounds
        loadingLayer.backgroundColor = UIColor.grayColor().CGColor
        self.layer.addSublayer(loadingLayer)
        
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.center = self.center
        loadingIndicator.startAnimating()
        self.addSubview(loadingIndicator)
        
        // remove loading layer and indicator after setup is complete
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            NSThread.sleepForTimeInterval(SET_UP_DURATION)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                loadingLayer.removeFromSuperlayer()
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
            })
        }
    }
    
    // MARK: Public Methods
    
    func startAnimtating() {
        instanceLayer.addAnimation(animation, forKey: nil)
        setUpLoadingScreen()
    }
    
    func stopAnimating() {
        instanceLayer.removeAllAnimations()
        instanceLayer.removeFromSuperlayer()
    }

}
