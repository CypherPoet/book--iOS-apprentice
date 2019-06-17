//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Brian Sipple on 6/7/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation
import UserNotifications

extension Checklist {
    
    final class Item: NSObject {
        enum ReminderState: String, Codable {
            case disabled
            case didSchedule
            case needsScheduling
            case needsRescheduling
            case needsCanceling
        }
        
        var title: String
        
        var isChecked: Bool {
            didSet {
                if reminderState == .didSchedule {
                    cancelReminder()
                } else if !isChecked && wantsReminder && !isPastDue && reminderState == .disabled {
                    scheduleReminder()
                }
            }
        }

        var wantsReminder: Bool {
            didSet {
                if !wantsReminder && reminderState == .didSchedule {
                    reminderState = .needsCanceling
                } else if wantsReminder && !isPastDue && reminderState != .didSchedule {
                    reminderState = .needsScheduling
                }
            }
        }
        
        var dueDate: Date? {
            didSet {
                let didChange = dueDate != oldValue
                
                if didChange && !isPastDue && wantsReminder && reminderState == .didSchedule {
                    reminderState = .needsRescheduling
                }
            }
        }
        
        private(set) var notificationID: String
        private(set) var reminderState: ReminderState = .disabled
        
        
        init(
            title: String,
            isChecked: Bool = false,
            dueDate: Date? = nil,
            wantsReminder: Bool = false
        ) {
            self.title = title
            self.isChecked = isChecked
            self.dueDate = dueDate
            self.wantsReminder = wantsReminder
            self.notificationID = "ChecklistItem::\(title)::\(UUID().uuidString)"
            
            super.init()
            
            if dueDate != nil && !isPastDue && wantsReminder {
                self.reminderState = .needsScheduling
            }
        }
        
        
        deinit {
            cancelReminder()
        }
    }
}

extension Checklist.Item: Codable {}


// MARK: - Computeds

extension Checklist.Item {
    
    var isPastDue: Bool {
        return dueDate != nil && (Date() > dueDate!)
    }
    
    private var notificationCenter: UNUserNotificationCenter {
        return .current()
    }
}


// MARK: - Schedule Notifications

extension Checklist.Item {
    
    func scheduleReminder() {
        guard let dueDate = dueDate else { preconditionFailure("No due date was set") }
        guard !isPastDue else { preconditionFailure("Item is already past due") }
        guard wantsReminder else { preconditionFailure("Reminders are not enabled for this item") }
        
        cancelReminder()
        
        notificationCenter.getNotificationSettings { [weak self] (settings) in
            guard let self = self else { return }
            
            if settings.authorizationStatus == .authorized {
                let notificationRequest = CustomNotification.checklistItemReminder(
                    for: self,
                    dueAt: dueDate
                ).request
        
                print("Adding notification request")
                print(notificationRequest)
                
                self.notificationCenter.add(notificationRequest)
                self.reminderState = .didSchedule
                
            } else {
                print("⚠️ Notifications aren't authorized.")
            }
        }
    }
    
    
    func cancelReminder() {
        print("Canceling reminders")
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationID])
        reminderState = .disabled
    }
}
