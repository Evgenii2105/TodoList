//
//  NetworkImpl.swift
//  TodoList
//
//  Created by Евгений Фомичев on 20.05.2025.
//

import UIKit

protocol Network {
    func request<T: Decodable>(endPoint: NetworkImpl.EndPoint,
                               completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class NetworkImpl {
    
    enum BaseUrl {
        static let BaseURL = "dummyjson.com"
    }
    
    enum APIMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }
    
    enum EndPoint {
        case todos
        
        var scheme: String {
            return "https"
        }
        
        var path: String {
            switch self {
            case .todos:
                return "/todos"
            }
        }
        
        var method: APIMethod {
            switch self {
            case .todos:
                return .get
            }
        }
    }
    
    func request<T: Decodable>(endPoint: EndPoint,
                               completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let urlRequest = createRequest(endPoint: endPoint) else { return completion(.failure(.invalidURL)) }
        
        request(urlRequest: urlRequest, completion: completion)
    }
}

private extension NetworkImpl {
    
    func request<T: Decodable>(urlRequest: URLRequest,
                                       completion: @escaping (Result<T, NetworkError>) -> ()) {
        let task = URLSession.shared.dataTask(with: urlRequest) {
            data, _, error  in
            guard let data = data else { return completion(.failure(.noData)) }
            
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.dicodingFailed(error)))
            }
        }
        task.resume()
    }
    
    func createRequest(endPoint: EndPoint) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host = BaseUrl.BaseURL
        urlComponents.path = endPoint.path

        guard let url = urlComponents.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.method.rawValue
        urlRequest.setValue("de1db718-950e-449d-88a1-39a41062cee6", forHTTPHeaderField: "X-API-KEY")
        return urlRequest
    }
}
