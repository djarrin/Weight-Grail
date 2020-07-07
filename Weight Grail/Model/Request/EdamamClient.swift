//
//  EdamamClient.swift
//  Weight Grail
//
//  Created by David Jarrin on 6/26/20.
//  Copyright © 2020 David Jarrin. All rights reserved.
//

import Foundation

class EdamamClient {
    
    static let app_id = "e367ce27"
    static let app_key = "62c61008a01b7f91e12521832037d865"
    
    enum Endpoints {
        static let base = "https://api.edamam.com/api/food-database/v2/parser?app_id=\(app_id)&app_key=\(app_key)"
        
        case searchByWord(String)
        case searchByBarcode(String)
    
    
        var stringValue: String {
            switch self {
            case .searchByWord(let word): return Endpoints.base + "&ingr=\(word)"
            case .searchByBarcode(let code): return Endpoints.base + "&upc=\(code)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func foodSearchByWord(word: String, completion: @escaping (EdamamParsedResponse?, Error?) -> Void) {
        _get(url: Endpoints.searchByWord(word.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "").url, response: EdamamParsedResponse.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func foodSearchByBarcode(barcode: String, completion: @escaping (EdamamParsedResponse?, Error?) -> Void) {
        _get(url: Endpoints.searchByBarcode(barcode).url, response: EdamamParsedResponse.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    
}

extension EdamamClient {
    @discardableResult class func _get<ResponseType: Decodable>(url: URL, response: ResponseType.Type, stripResonse: Bool = false, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()

            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(error)
                do {
                    let errorResponse = try decoder.decode(EdamamResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
}
