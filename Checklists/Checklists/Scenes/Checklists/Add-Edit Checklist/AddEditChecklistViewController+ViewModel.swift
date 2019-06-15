//
//  AddEditChecklistViewController+ViewModel.swift
//  Checklists
//
//  Created by Brian Sipple on 6/15/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//


import UIKit


extension AddEditChecklistViewController {
    
    struct ViewModel {
        var checklistTitle: String
        var checklistCategory: Checklist.Category?
    }
}


// MARK: - Computeds

extension AddEditChecklistViewController.ViewModel {
    
    var checklistTitleText: String {
        return checklistTitle
    }
    
    var checklistCategoryText: String {
        return checklistCategory?.title ?? "Select a Category"
    }
    
    var checklistIconImage: UIImage? {
        return checklistCategory?.iconImage
    }
    
}
