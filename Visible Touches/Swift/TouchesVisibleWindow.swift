//
//  UIWindow+VisibleTouches.swift
//
//  Created by Chase Carroll on 10/1/22.
//

import UIKit


final class TouchView: UIView {
    
    private lazy var _blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        return UIVisualEffectView(effect: blurEffect)
    }()
    
    override var frame: CGRect {
        didSet {
            layer.cornerRadius = frame.height / 2.0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        layer.masksToBounds = true
        layer.cornerCurve = .circular
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2.0
        
        addSubview(_blurView)
    }
    
    @available(iOS, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _blurView.frame = bounds
    }
    
}


class TouchesVisibleWindow: UIWindow {
    
    var touchesVisible = false {
        didSet {
            if touchesVisible == false {
                _cleanUpAllTouches()
            }
        }
    }
    
    private var _touchViews: [UITouch : TouchView] = [:]
    
    private func _newTouchView() -> TouchView {
        let touchSize = 44.0
        return TouchView(frame: CGRect(
            origin: .zero,
            size: CGSize(
                width: touchSize,
                height: touchSize
            )
        ))
    }
    
    private func _cleanupTouch(_ touch: UITouch) {
        guard let touchView = _touchViews[touch] else {
            return
        }
        
        touchView.removeFromSuperview()
        _touchViews.removeValue(forKey: touch)
    }
    
    private func _cleanUpAllTouches() {
        for (_, touchView) in _touchViews {
            touchView.removeFromSuperview()
        }
        
        _touchViews.removeAll()
    }
    
    override func sendEvent(_ event: UIEvent) {
        /// If touches aren't supposed to be visible, then let's just forward the event along and bail.
        guard touchesVisible else {
            super.sendEvent(event)
            return
        }
        
        let touches = event.allTouches
        
        /// If there aren't any more touches active on the display, then let's clean up any touch views
        /// that are still hanging around.
        guard
            let touches = touches,
            touches.count > 0
        else {
            _cleanUpAllTouches()
            super.sendEvent(event)
            return
        }
        
        for touch in touches {
            let touchLocation = touch.location(in: self)
            switch touch.phase {
            case .began:
                let touchView = _newTouchView()
                touchView.center = touchLocation
                addSubview(touchView)
                _touchViews[touch] = touchView
                
            case .moved:
                guard let touchView = _touchViews[touch] else {
                    return
                }
                touchView.center = touchLocation
                
            case .ended, .cancelled:
                _cleanupTouch(touch)
            default:
                print("Nothing to do")
            }
        }
        
        super.sendEvent(event)
    }
    
}
