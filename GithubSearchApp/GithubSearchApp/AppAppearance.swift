//
//  AppAppearance.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/08.
//

import UIKit

final class AppAppearance {
    static func setUpAppearance() {
        if #available(iOS 13.0, *) {
            UITabBar.appearance().tintColor = .label
        } else {
            UITabBar.appearance().tintColor = .white
        }
        if #available(iOS 13.0, *) {
            UIBarButtonItem.appearance().tintColor = .label
        } else {
            UIBarButtonItem.appearance().tintColor = .white
        }
        UINavigationBar.appearance().prefersLargeTitles = true
    }
}
