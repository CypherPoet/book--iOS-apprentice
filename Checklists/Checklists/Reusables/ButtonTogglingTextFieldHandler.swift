//
//  BarItemTogglingTextFieldHandler.swift
//  Checklists
//
//  Created by Brian Sipple on 6/10/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

final class BarItemTogglingTextFieldHandler: NSObject {
    var barItem: UIBarItem
    
    init(barItem: UIBarItem) {
        self.barItem = barItem
    }
}


// MARK: - UITextFieldDelegate

extension BarItemTogglingTextFieldHandler: UITextFieldDelegate {
    
    /**
     Invoked every time the user changes the text, whether by tapping on the keyboard or via cut/paste.
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text ?? ""
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        barItem.isEnabled = !newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        return true
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        barItem.isEnabled = false
        return true
    }
}
