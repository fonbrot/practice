//
//  QueryService.swift
//  urlsession
//
//  Created by 1 on 16/05/2018.
//  Copyright © 2018 av. All rights reserved.
//

import Foundation
import SwiftyJSON

class QueryService {
    let session = URLSession(configuration: .default)
    var task: URLSessionDataTask?
    var tracks = [Track]()
    
    func getTracks(text: String, completion: @escaping ([Track]) -> Void ) {
        guard var urlComponents = URLComponents(string: "https://itunes.apple.com/search") else { return }
        urlComponents.query = "media=music&entity=song&term=\(text)"
        
        guard let url = urlComponents.url else { return }

        task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return completion([])
                
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { print("error response")
                return completion([])
            }
            
            if let data = data {
                self.parseTracks(data: data)
                
                completion(self.tracks)
            }
        }
        task?.resume()
    }
    
    func getImage(imageURL: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: imageURL) else { return }
        task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200  else { return }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
        task?.resume()
    }
    
    private func parseTracks(data: Data) {
        tracks.removeAll()
        if let json = try? JSON(data: data) {
            let results = json["results"].arrayValue
            
            for result in results {
                if let track = Track(json: result) {
                    tracks.append(track)
                }
            }
        } else {
            print("error parse")
        }
    }
}
