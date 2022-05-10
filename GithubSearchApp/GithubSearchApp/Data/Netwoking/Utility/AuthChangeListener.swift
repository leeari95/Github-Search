//
//  AuthChangeListener.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/09.
//

import Foundation

@objc protocol AuthChangeListener: AnyObject {
    func instanceName() -> String
    func authStateDidChange(isLogged: Bool)
}
