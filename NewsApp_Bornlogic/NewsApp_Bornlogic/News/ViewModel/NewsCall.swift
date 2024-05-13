//
//  NewsCall.swift
//  NewsApp_Bornlogic
//
//  Created by Henrique Assis on 11/05/24.
//

import Foundation

class NewsCall {
    //MARK: PUBLIC FUNCS
    /**Faz a chamada da API e retorna o resultado numa completion**/
    public func getNews(completion: @escaping (News) -> Void) {
        let apiKey = getApiKeyPlist().object(forKey: "SERVICE_API_KEY") as? String ?? ""
        guard let apiURL = URL(string: "https://newsapi.org/v2/everything?q=keyword&apiKey=\(apiKey)") else {return}

        callNewsApi(url: apiURL) { news in
            completion(news)
        }
    }
    
    //MARK: PRIVATE FUNCS
    /**Com a url da api, faz o decode em JSON e retorna a model dentro de uma completion**/
    private func callNewsApi(url: URL, completion: @escaping (News) -> Void) {
        // chamada da api
        URLSession.shared.dataTask(with: url) { data, response, error in
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
