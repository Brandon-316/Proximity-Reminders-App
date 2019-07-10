//
//  ReminderCell.swift
//  Proximity Reminders App
//
//  Created by Brandon Mahoney on 6/30/19.
//  Copyright © 2019 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit


class ReminderCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    func configure(with reminder: Reminder) {
        self.tintColor = .white
        self.titleLabel.text = reminder.title
        self.locationLabel.text = "\(reminder.address)"
    }
}

