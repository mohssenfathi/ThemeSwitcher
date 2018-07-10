//
//  ThemeCell.swift
//  ThemeSwitcher
//
//  Created by Mohssen Fathi on 7/8/18.
//  Copyright © 2018 mohssenfathi. All rights reserved.
//

import Foundation
import Cocoa

class ThemeCell: NSTableCellView {
    @IBOutlet weak var iconImageView: NSImageView!
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var annotationImageView: NSImageView!
    @IBOutlet weak var divider: NSView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        divider.wantsLayer = true
        divider.layer?.backgroundColor = NSColor.lightGray.cgColor
    }
}
