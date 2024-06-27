//
//  UIView+Extensions.swift
//  ArastirmaMobilApp
//
//  Created by Oktay Kuzu on 15.06.2024.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return cornerRadius }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}

