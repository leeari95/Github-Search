//
//  LoginManager.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/04.
//

import UIKit


final class LoginManager {
    static let shared = LoginManager()
    private init() {}
    
    private let apiRequest: APIProvider = DefaultAPIProvider()
    var isLogged: Bool {
        KeychainStorage.shard.load("Token") == nil ? false : true
    }
    private var listeners: [WeakReference<AuthChangeListener>] = []
    
    func addListener(_ listener: AuthChangeListener) {
        if listeners.compactMap({ $0.value?.instanceName() }).contains(listener.instanceName()) {
            return
        }
        listeners.append(WeakReference(value: listener))
    }
    
    func authorize() {
        guard let url = APIAddress.code(clientID: Secrets.clinetID, scope: "repo,user").url else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    func requestToken(code: String, completion: ((Result<Bool, Error>) -> Void)?) {
        guard let url = APIAddress.token(clientID: Secrets.clinetID, clientSecret: Secrets.clinetSecret, code: code).url else {
            return
        }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        apiRequest.execute(request: request) { result in
            switch result {
            case .success(let data):
                data.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: String] }
                .flatMap { $0["access_token"] }
                .flatMap {
                    if KeychainStorage.shard.save(key: "Token", value: $0) {
                        print("사용자의 토큰을 키체인에 저장하는데 성공했습니다!")
                        self.listeners.first?.value?.authStateDidChange(isLogged: true)
                        completion?(.success(true))
                    } else {
                        print("토큰을 가져오지 못했습니다.")
                        completion?(.success(false))
                    }
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func logout() {
        KeychainStorage.shard.delete(key: "Token")
        listeners.forEach {
            $0.value?.authStateDidChange(isLogged: false)
        }
    }
    
    func executeNextWork(_ order: String, isLogged: Bool = LoginManager.shared.isLogged) {
        guard let index = listeners.compactMap({ $0.value?.instanceName() }).firstIndex(of: order) else {
            return
        }
        listeners[index].value?.authStateDidChange(isLogged: isLogged)
    }
}
