//
//  ViewController.swift
//  ThemeSwitcher
//
//  Created by Mohssen Fathi on 7/7/18.
//  Copyright © 2018 mohssenfathi. All rights reserved.
//

import Cocoa

class ThemeListViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    
    private func updateCells() {
        for row in 0 ..< Theme.allCases.count {
            if let cell = tableView.view(atColumn: 0, row: row, makeIfNecessary: false) as? ThemeCell {
                let image = (row == tableView.selectedRow) ? NSImage(imageLiteralResourceName: "check") : nil
                cell.annotationImageView.image = image
            }
        }
    }

}

extension ThemeListViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return Theme.allCases.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("ThemeCell"), owner: nil) as? ThemeCell else {
            return nil
        }
     
        let theme = Theme.allCases[row]
        cell.label?.stringValue = theme.title
        cell.iconImageView?.image = theme.image
        cell.annotationImageView.image = nil

        let checkmark = NSImage(imageLiteralResourceName: "check")
        cell.annotationImageView.image = (ThemeManager.currentTheme == theme) ? checkmark : nil
        
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return tableView.bounds.height/CGFloat(Theme.allCases.count)
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let theme = Theme.allCases[tableView.selectedRow]
        theme.set()
        updateCells()
    }
}

extension ThemeListViewController {
    
    
}
