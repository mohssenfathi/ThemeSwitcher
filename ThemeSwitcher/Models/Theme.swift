//
//  ThemeManager.swift
//  ThemeSwitcher
//
//  Created by Mohssen Fathi on 7/8/18.
//  Copyright © 2018 mohssenfathi. All rights reserved.
//

import Foundation
import Cocoa

struct ThemeManager {
    
    static var currentTheme: Theme = .light
    
    init() {
        ThemeManager.getCurrentTheme {
            NotificationCenter.default.post(name: ThemeChangedNotification, object: $0)
        }
        
        NotificationCenter.default.addObserver(forName: ThemeChangedNotification, object: nil, queue: nil) { notification in
            guard let new = notification.object as? Theme else {
                return
            }
            ThemeManager.currentTheme = new
        }
    }
    
    private static func getCurrentTheme(_ completion: @escaping ((Theme) -> ()))  {
        Theme.light.call(parameters: [Theme.light.scriptPath, "current"]) { str in
            guard let str = str?.trimmingCharacters(in: .newlines) else {
                completion(.light)
                return
            }
            completion(str == "true" ? .dark : .light)
        }
    }
    
    static let shared = ThemeManager()
}

enum Theme: String, CaseIterable {
    case light
    case dark
    
    var title: String {
        return rawValue.capitalized
    }
    
    var image: NSImage? {
        switch self {
        case .light:
            return NSImage(named: NSImage.Name(stringLiteral: "sun"))
        case .dark:
            return NSImage(named: NSImage.Name(stringLiteral: "moon"))
        }
    }
    
    static func toggle() {
        Theme.light.call(parameters: [Theme.light.scriptPath, "toggle"])
    }
    
    func set() {
        call(parameters: [self.scriptPath, self.rawValue], completion: { _ in
            NotificationCenter.default.post(name: ThemeChangedNotification, object: self)
        })
    }
    
    fileprivate func call(parameters: [String], completion: ((String?) -> ())? = nil) {
        DispatchQueue.global(qos: .background).async {
        
            let process = Process()
            process.launchPath = "/usr/bin/osascript"
            process.arguments = parameters

            let pipe = Pipe()

            process.standardOutput = pipe
            process.launch()
            process.waitUntilExit()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()

            DispatchQueue.main.async {
                completion?(String(data: data, encoding: .utf8))
            }
            
        }
    }
    
    fileprivate var scriptPath: String {
        return Bundle.main.path(forResource: "Theme", ofType: "scpt")!
    }
    
}


let ThemeChangedNotification = Notification.Name("ThemeChanged")
