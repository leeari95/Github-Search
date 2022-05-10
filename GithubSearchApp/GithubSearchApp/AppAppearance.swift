//
//  AppAppearance.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/08.
//

import UIKit

final class AppAppearance {
    static func setUpAppearance() {
        UITabBar.appearance().tintColor = .label
        UIBarButtonItem.appearance().tintColor = .label
        UINavigationBar.appearance().prefersLargeTitles = true
    }
}
