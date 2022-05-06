//
//  LoginManager.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/04.
//

import UIKit


struct LoginManager {
    private let apiRequest: DefaultAPIProvider
    static var isLogin: Bool = KeychainStorage.shard.load("Token") == nil ? false : true
    
    init(apiRequest: DefaultAPIProvider = DefaultAPIProvider()) {
        self.apiRequest = apiRequest
    }
    
    func authorize() {
        guard let url = APIAddress.code(clientID: Secrets.clinetID, scope: "repo,user").url else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    func requestToken(code: String) {
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
                    print($0)
                    if KeychainStorage.shard.save(key: "Token", value: $0) {
                        print("사용자의 토큰을 키체인에 저장하는데 성공했습니다!")
                    } else {
                        print("토큰을 가져오지 못했습니다.")
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func logout() {
        KeychainStorage.shard.delete(key: "Token")
    }
}
