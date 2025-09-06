//
//  Client.swift
//  PhotosGallery
//
//  Created by Shahriar Islam Sazid on 9/6/25.
//

import Foundation
import Combine

final class Client: CombineAPI {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        configuration.connectionProxyDictionary = [:]
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func photoData(_ feedKind: ApiFeed, queryParameters: [String: String]?) -> AnyPublisher<[PhotosModel], Error>{
        execute(feedKind.request, decodingType: [PhotosModel].self, retries: 2, queryParameters: queryParameters)
    }

}
protocol CombineAPI {
    var session: URLSession { get }
    func execute<T>(_ request: URLRequest,
                    decodingType: T.Type,
                    queue: DispatchQueue,
                    retries: Int,
                    queryParameters: [String: String]?,
                    headers: [String: String]?,
                    body: Data?) -> AnyPublisher<T, Error> where T: Decodable
}

extension CombineAPI {
    
    func execute<T>(_ request: URLRequest,
                    decodingType: T.Type,
                    queue: DispatchQueue = .main,
                    retries: Int = 0,
                    queryParameters: [String: String]? = nil,
                    headers: [String: String]? = nil,
                    body: Data? = nil) -> AnyPublisher<T, Error> where T: Decodable {
        
        var urlRequest = request
        
        // Append query parameters to the URL if provided
        if let queryParameters = queryParameters {
            var urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)!
            urlComponents.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            urlRequest.url = urlComponents.url
        }
        // Add body if provided
        if let body = body {
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = body
        }
        // Add headers if provided
        headers?.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        // Log the request details
        print("Request URL: \(urlRequest.url?.absoluteString ?? "")")
        print("Request Method: \(urlRequest.httpMethod ?? "")")
        if let body = body, let bodyString = String(data: body, encoding: .utf8) {
            print("Request Body: \(bodyString)")
        }
        let curlCommand = logCurlCommand(for: urlRequest)
        print(curlCommand)
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Errors => \(response)")
                    throw APIError.responseUnsuccessful
                }
                // Log the response details
                if let dataString = String(data: data, encoding: .utf8) {
                   // print("Response Data: \(dataString)")
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: queue)
            .retry(retries)
            .mapError { error in
                // Log the encountered error
                print("Error: \(error.localizedDescription)")
                print("Error:> \(urlRequest)\(error)")
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func logCurlCommand(for request: URLRequest) -> String {
        var curlCommand = "curl"
        
        // Add URL
        if let url = request.url {
            curlCommand += " '\(url.absoluteString)'"
        }
        
        // Add HTTP method
        if let httpMethod = request.httpMethod {
            curlCommand += " -X \(httpMethod)"
        }
        
        // Add headers
        if let headers = request.allHTTPHeaderFields {
            for (key, value) in headers {
                curlCommand += " -H '\(key): \(value)'"
            }
        }
        
        // Add request body if present
        if let bodyData = request.httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
            curlCommand += " -d '\(bodyString)'"
        }
        
        return curlCommand
    }


}
