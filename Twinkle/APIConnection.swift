import UIKit
import Foundation


class API {
    // Gets the posts json data and returns it converted as a dictionary
    func getPosts(url: String, completion: @escaping ([String:Any]) -> Void) {
        // Network request snippet
        
        let url = URL(string: url)!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                return completion(dataDictionary)
            }
        }
        task.resume()
    }

    func sendPost(urlString url: String, _ parameters: GENERAL_PLANET_PARAM) {
        let username = "606112"
        let password = "d20281c03812a38046bb326a4c1a6558"
        
        
        // Session config
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        
        let loginString = "\(username):\(password)"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        do {
            let jsonData = try JSONEncoder().encode(parameters)
            request.httpBody = jsonData
        } catch {
            print("try JSONEncoder().encode(postData) error -> \(error.localizedDescription)")
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("error -> \(error.localizedDescription)")
            }
            
            guard let data = data else {
                print("no response data")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("response error")
                return
            }
            print("httpResponse -> \(httpResponse)")
            
            guard let response_str = String(data: data, encoding: .utf8) else {return}
            print("response_str -> \(response_str)")
            
            do {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                for i in dataDictionary ?? []{
                    print(i["name"], i["sign"])
                }
                } catch {
                print(data)
                print("error -> \(error.localizedDescription)")
            }
        }.resume()
    }
}


var test = API()
test.getPosts(url: "http://ohmanda.com/api/horoscope/virgo") { data in
    print(data)
}

test.getPosts(url: "http://ohmanda.com/api/horoscope/leo") { data in
    print(data)
}

let data = GENERAL_PLANET_PARAM(day: 10, month: 12, year: 1993, hour: 1, min: 25, lat: 25, lon: 82, tzone: 5.5)

test.sendPost(urlString: "https://json.astrologyapi.com/v1/planets", data)
