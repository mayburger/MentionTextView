//
//  UIView+GestureRecognizer.swift
//  ONE
//
//  Created by dennis farandy on 11/6/15.
//  Copyright © 2015 Happy5. All rights reserved.
//


//this taken from
//https://github.com/marcbaldwin/GestureRecognizerClosures/tree/master/GestureRecognizerClosures

import Foundation
import UIKit

extension UIView {
    
    func onTap(_ handler: @escaping (UITapGestureRecognizer) -> Void) {
        onTapWithTapCount(1, run: handler)
    }
    
    func onDoubleTap(_ handler: @escaping (UITapGestureRecognizer) -> Void) {
        onTapWithTapCount(2, run: handler)
    }
    
    func onLongPress(_ handler: @escaping (UILongPressGestureRecognizer) -> Void) {
        addGestureRecognizer(UILongPressGestureRecognizer { gesture in
            handler(gesture as! UILongPressGestureRecognizer)
            })
    }
    
    func onSwipeLeft(_ handler: @escaping (UISwipeGestureRecognizer) -> Void) {
        onSwipeWithDirection(.left, run: handler)
    }
    
    func onSwipeRight(_ handler: @escaping (UISwipeGestureRecognizer) -> Void) {
        onSwipeWithDirection(.right, run: handler)
    }
    
    func onSwipeUp(_ handler: @escaping (UISwipeGestureRecognizer) -> Void) {
        onSwipeWithDirection(.up, run: handler)
    }
    
    func onSwipeDown(_ handler: @escaping (UISwipeGestureRecognizer) -> Void) {
        onSwipeWithDirection(.down, run: handler)
    }
    
    func onPan(_ handler: @escaping (UIPanGestureRecognizer) -> Void) {
        addGestureRecognizer(UIPanGestureRecognizer { gesture in
            handler(gesture as! UIPanGestureRecognizer)
            })
    }
    
    func onPinch(_ handler: @escaping (UIPinchGestureRecognizer) -> Void) {
        addGestureRecognizer(UIPinchGestureRecognizer { gesture in
            handler(gesture as! UIPinchGestureRecognizer)
            })
    }
    
    func onRotate(_ handler: @escaping (UIRotationGestureRecognizer) -> Void) {
        addGestureRecognizer(UIRotationGestureRecognizer { gesture in
            handler(gesture as! UIRotationGestureRecognizer)
            })
    }
    
    class func nibName() -> String {
        return "\(self)".components(separatedBy: ".").last ?? ""
    }
    
    class func viewFromXib() -> Self {
        return typeSafeFromXib()
    }
    fileprivate class func typeSafeFromXib<T:UIView>() -> T {
        if let view: AnyObject = Bundle.main.loadNibNamed(self.nibName(), owner: nil, options: nil)?.first as AnyObject? {
            if let viewT = view as? T {
                return viewT
            } else {
                return T()
            }
        } else {
            return T()
        }
    }
    
    class func nib() -> UINib {
        let nib = UINib(nibName:self.nibName(), bundle: Bundle.main)
        return nib
    }
    
    class func identifier() -> String {
        return "\(self)"
    }
}

private extension UIView {
    
    func onTapWithTapCount(_ numberOfTaps: Int, run handler: @escaping (UITapGestureRecognizer) -> Void) {
        let tapGesture = UITapGestureRecognizer { gesture in
            handler(gesture as! UITapGestureRecognizer)
        }
        tapGesture.numberOfTapsRequired = numberOfTaps
        addGestureRecognizer(tapGesture)
    }
    
    func onSwipeWithDirection(_ direction: UISwipeGestureRecognizer.Direction, run handler: @escaping (UISwipeGestureRecognizer) -> Void) {
        let swipeGesture = UISwipeGestureRecognizer { gesture in
            handler(gesture as! UISwipeGestureRecognizer)
        }
        swipeGesture.direction = direction
        addGestureRecognizer(swipeGesture)
    }
}
