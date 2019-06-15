//
//  EmptyTextFieldHandler.swift
//  Checklists
//
//  Created by Brian Sipple on 6/10/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

final class EmptyTextFieldChecker: NSObject {
    typealias ChangeHandler = (Bool) -> Void
    
    var changeHandler: ChangeHandler
    
    var isEmpty = false {
        didSet { changeHandler(isEmpty) }
    }

    init(isEmpty: Bool = false, changeHandler: @escaping ChangeHandler) {
        self.isEmpty = isEmpty
        self.changeHandler = changeHandler
    }
}


// MARK: - UITextFieldDelegate

extension EmptyTextFieldChecker: UITextFieldDelegate {
    
    /**
     Invoked every time the user changes the text, whether by tapping on the keyboard or via cut/paste.
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text ?? ""
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        isEmpty = newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        return true
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        isEmpty = true
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isEmpty = !textField.hasText
    }
    
}
