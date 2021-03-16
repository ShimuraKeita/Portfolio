//
//  CustomTextField.swift
//  Finish
//
//  Created by 志村　啓太 on 2021/03/16.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String, isSecureField: Bool? = false) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(width: 12, height: 50)
        leftView = spacer
        leftViewMode = .always
        
        keyboardAppearance = .dark
        borderStyle = .none
        textColor = .white
        backgroundColor = UIColor(white: 1, alpha: 0.2)
        setHeight(height: 50)
        layer.cornerRadius = 5
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        isSecureTextEntry = isSecureField!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
