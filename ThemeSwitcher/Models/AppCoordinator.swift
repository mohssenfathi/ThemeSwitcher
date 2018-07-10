//
//  AppCoordinator.swift
//  ThemeSwitcher
//
//  Created by Mohssen Fathi on 7/9/18.
//  Copyright © 2018 mohssenfathi. All rights reserved.
//

import Foundation
import Cocoa

class AppCoordinator {
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    init(popover: NSPopover) {
        _ = ThemeManager.shared
        
        statusItem.button?.action = #selector(AppDelegate.togglePopover(_:))
        
        popover.behavior = .transient
        popover.contentViewController = switchViewController
        
        NotificationCenter.default.addObserver(forName: ThemeChangedNotification, object: nil, queue: nil) { notification in
            
            if let theme = notification.object as? Theme,
                let button = self.statusItem.button {
                button.image = theme.image
            }
        }
        
    }
}

extension AppCoordinator {
    
    var appDelegate: AppDelegate {
        return NSApplication.shared.delegate as! AppDelegate
    }
    
    var switchViewController: ThemeListViewController {
        return NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(stringLiteral: "ThemeListViewController")) as! ThemeListViewController
    }
}
