//
//  NetworkNews.swift
//  NewsApp_Bornlogic
//
//  Created by Henrique Assis on 13/05/24.
//

import Foundation

class NetworkNews {
    static let shared = NetworkNews()
    
    //MARK: PUBLIC FUNCS
    /**Com a url da api, faz o decode em JSON e retorna a model dentro de uma completion**/
    public func fetchData(completion: @escaping (News) -> Void) {
        // pegando a chave
        let apiKey = getApiKeyPlist().object(forKey: "SERVICE_API_KEY") as? String ?? ""
        guard let apiURL = URL(string: "https://newsapi.org/v2/everything?q=keyword&apiKey=\(apiKey)") else {return}
        
        // chamada da api
        URLSession.shared.dataTask(with: apiURL) { data, response, error in
            guard let data = data, error == nil else {return}
            
            // conversao para json
            do {
                let decodedNews = try JSONDecoder().decode(News.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedNews)
                }
            }
            catch {
                print(error)
            }
        }.resume()
    }
    
    //MARK: PRIVATE FUNCS
    /**Pega a chave da api dentro do info.plist dela**/
    private func getApiKeyPlist() -> NSDictionary {
        let infoName = "API-Key"
        
        guard let filePath = Bundle.main.path(forResource: infoName, ofType: "plist") else {
            fatalError("Não foi possível achar o arquivo '\(infoName)' plist")
        }
        
        do {
            let plist = try NSDictionary(contentsOf: URL(filePath: filePath), error: ())
            return plist
        }
        catch {
            fatalError("Não foi possível achar o arquivo '\(infoName)' plist")
        }
    }
}
