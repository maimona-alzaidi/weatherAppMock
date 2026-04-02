//
//  UIView+Pin.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 21/09/1447 AH.
//
import UIKit

extension UIView {
    func pinToEdges(of superview: UIView, inset: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: inset.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: inset.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -inset.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset.bottom)
        ])
    }
    
}
