//
//  URLSchemes.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/11/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import TwitterKit
import GoogleSignIn
import MSAL

struct FacebookURLScheme: URLScheme {
    
    func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        guard let scheme = url.scheme,
            scheme.hasPrefix("fb"),
            url.host == "authorize" else {
            return false
        }
        
        let (source, annotation) = sourceAndAnnotation(from: options)
        
        return FBSDKApplicationDelegate.sharedInstance()
            .application(application, open: url, sourceApplication: source, annotation: annotation)
    }
}

struct TwitterURLScheme: URLScheme {
    
    func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        guard let scheme = url.scheme, scheme.hasPrefix("twitterkit") else {
            return false
        }
        return Twitter.sharedInstance().application(application, open: url, options: options)
    }
}

struct GoogleURLScheme: URLScheme {
    
    func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        let (source, annotation) = sourceAndAnnotation(from: options)
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: source, annotation: annotation)
    }
}

struct MicrosoftURLScheme: URLScheme {
    
    func application(_ application: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        guard let scheme = url.scheme, scheme.hasPrefix("msal") else {
            return false
        }
        return MSALPublicClientApplication.handleMSALResponse(url)
    }
}

private func sourceAndAnnotation(from options: [AnyHashable: Any]) -> (String?, Any?) {
    var source: String?
    var annotation: Any?
    
    if #available(iOS 9.0, *) {
        source = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        annotation = options[UIApplicationOpenURLOptionsKey.annotation]
    } else {
        source = options["UIApplicationOpenURLOptionsSourceApplicationKey"] as? String
        annotation = options["UIApplicationOpenURLOptionsAnnotationKey"]
    }
    
    return (source, annotation)
}
