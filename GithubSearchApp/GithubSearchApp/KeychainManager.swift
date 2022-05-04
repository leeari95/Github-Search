//
//  KeychainManager.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/04.
//

import Foundation

final class KeychainManager {
    static let shard = KeychainManager()
    
    private init() {}
    
    @discardableResult
    func save(key: String, value: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: value.data(using: .utf8)!
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func load(_ key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess {
            return nil
        }
        guard let existingItem = item as? [String: Any] else { return nil }
        guard let data = existingItem[kSecValueData as String] as? Data else { return nil }
        guard let Token = String(data: data, encoding: .utf8) else { return nil }
        
        return Token
    }
    
    @discardableResult
    func delete(key: String) -> Bool {
        let deleteQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        
        let status = SecItemDelete(deleteQuery)
        
        return status == errSecSuccess
    }
}
