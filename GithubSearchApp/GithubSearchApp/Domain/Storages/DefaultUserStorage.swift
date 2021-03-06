//
//  DefaultUserStorage.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/06.
//

import Foundation

final class DefaultUserStorage: UserStorage {
    private let apiProvider: APIProvider
    private var userInfo: UserResponseDTO? {
        didSet {
            guard KeychainStorage.shard.load("Token") != nil else {
                return
            }
            LoginManager.shared.executeNextWork(String(describing: DefaultUserRepository.self))
        }
    }
    
    var info: UserResponseDTO? {
        return userInfo
    }
    
    init(apiProvider: APIProvider = DefaultAPIProvider()) {
        self.apiProvider = apiProvider
        LoginManager.shared.addListener(self)
    }
    
    func getInfoResponse(
        for requestDTO: UserInfoRequest,
        completion: @escaping (Result<UserResponseDTO, Error>) -> Void
    ) {
        apiProvider.request(requestDTO) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getRepositories(
        for requestDTO: UserRepoListRequest,
        completion: @escaping (Result<[ItemResponseDTO], Error>) -> Void
    ) {
        apiProvider.requestList(requestDTO) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func putStarred(path: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let request = MarkStarredRequest(path: path, method: .put).urlReqeust else {
            return
        }
        apiProvider.execute(request: request) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return completion(.failure(UserStorageError.unknown))
                }
                completion(.success(String(data: data, encoding: .utf8) == nil ? false : true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteStarred(path: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let request = MarkStarredRequest(path: path, method: .delete).urlReqeust else {
            return
        }
        apiProvider.execute(request: request) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return completion(.failure(UserStorageError.unknown))
                }
                completion(.success(String(data: data, encoding: .utf8) == nil ? false : true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum UserStorageError: LocalizedError {
    case invalidRequest
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "????????? ???????????? ????????????."
        case .unknown:
            return "??? ??? ?????? ????????? ??????????????????."
        }
    }
}

// MARK: - Login event handler
extension DefaultUserStorage: AuthChangeListener {
    func instanceName() -> String {
        String(describing: DefaultUserStorage.self)
    }
    
    func authStateDidChange(isLogged: Bool) {
        if isLogged {
            fetchUserInfo()
        } else {
            self.userInfo = nil
        }
    }
    
    private func fetchUserInfo() {
        let request = UserInfoRequest()
        getInfoResponse(for: request) { result in
            switch result {
            case .success(let info):
                self.userInfo = info
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
