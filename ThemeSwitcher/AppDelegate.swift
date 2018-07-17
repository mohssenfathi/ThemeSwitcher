//
//  AppDelegate.swift
//  ThemeSwitcher
//
//  Created by Mohssen Fathi on 7/7/18.
//  Copyright © 2018 mohssenfathi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var appCoordinator: AppCoordinator!
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        appCoordinator = AppCoordinator(popover: popover)
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            guard let strongSelf = self, strongSelf.popover.isShown else {
                return
            }
            strongSelf.closePopover(sender: event)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}


extension AppDelegate {
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        guard let button = sender as? NSStatusBarButton else {
            return
        }
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        eventMonitor?.start()
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
}
