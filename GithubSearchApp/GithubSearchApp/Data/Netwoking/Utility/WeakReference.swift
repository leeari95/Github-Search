//
//  WeakReference.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/09.
//

import Foundation

class WeakReference<T: AnyObject> {
    
    weak var value: T?

    init(value: T) {
        self.value = value
    }
    
    func release() {
        value = nil
    }
}
