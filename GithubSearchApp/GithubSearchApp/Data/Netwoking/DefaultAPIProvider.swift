//
//  DefaultAPIProvider.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/04.
//

import Foundation


struct DefaultAPIProvider: APIProvider {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func execute(request: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(APIError.responseCasting))
                return
            }
            guard (200...299).contains(response.statusCode) else {
                completion(.failure(APIError.statusCode(
                    code: response.statusCode,
                    message: String(data: data ?? Data(), encoding: .utf8) ?? ""
                )))
                return
            }
            completion(.success(data))
        }.resume()
    }

    func request<T: APIRequest>(_ request: T, completion: @escaping (Result<T.Response, Error>) -> Void) {
        guard let urlRequest = request.urlReqeust else {
            return
        }

        execute(request: urlRequest) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return completion(.failure(APIError.invalidData))
                }
                let decoder = JSONDecoder()
                guard let decoded = try? decoder.decode(T.Response.self, from: data) else {
                    return completion(.failure(APIError.parsingError))
                }
                return completion(.success(decoded))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func requestList<T: APIRequest>(_ request: T, completion: @escaping (Result<[T.Response], Error>) -> Void) {
        guard let urlRequest = request.urlReqeust else {
            return
        }

        execute(request: urlRequest) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return completion(.failure(APIError.invalidData))
                }
                let decoder = JSONDecoder()
                guard let decoded = try? decoder.decode([T.Response].self, from: data) else {
                    return completion(.failure(APIError.parsingError))
                }
                return completion(.success(decoded))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum APIError: LocalizedError {
    case responseCasting
    case statusCode(code: Int, message: String)
    case notFoundURL
    case invalidData
    case parsingError
    
    var errorDescription: String? {
        switch self {
        case .responseCasting:
            return "???????????? ?????????????????????."
        case .statusCode(let code, let message):
            return "?????? ?????? ?????? : \(code)\n ?????? ????????? : \(message)"
        case .notFoundURL:
            return "URL??? ?????? ??? ????????????."
        case .invalidData:
            return "???????????? ???????????? ????????????."
        case .parsingError:
            return "JSON?????? ???????????? ?????? ??? ??? ?????? ????????? ??????????????????."
        }
    }
}
