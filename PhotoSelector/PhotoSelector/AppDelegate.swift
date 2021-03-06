//  AppDelegate.swift
//  PhotoSelector

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        window?.backgroundColor =  UIColor.whiteColor()
        window?.rootViewController = TSZPhotoSeletor()
        
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

