//
//  TaxiiConnection.swift
//  Taxii2Client
//
//  Created by Ringo Wathelet on 2020/03/21.
//  Copyright © 2020 Ringo Wathelet. All rights reserved.
//

import Foundation
import PromiseKit
import PMKFoundation


/*
 * a network connection to a Taxii-2.x server
 */
class TaxiiConnection: TaxiiConnect {

    /*
     * fetch data from the server. A GET to the chosen path is sent to the Taxii-2.x server.
     * The TAXII server response is parsed then converted to a Taxii-2.x protocol resource.
     *
     * @param path the full path to the server resource
     * @param headerType with value = 0 (default) for request media type for stix resources,
     *                        value=1 for request media type for taxii resources
     * @return Promise
     */
    func fetchThis<T: Decodable>(path: String, headerType: Int = 0, taxiiType: T.Type) -> Promise<T?> {
     //   print("----> fetchThis path: \(path)")
        let mediaType = headerType == 1 ? mediaStix : mediaTaxii
        let url = URL(string: path)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(taxiiVersion, forHTTPHeaderField: "version")
        request.addValue("Basic \(hash())", forHTTPHeaderField: "Authorization")
        request.addValue(mediaType, forHTTPHeaderField: "Accept")
        request.addValue(mediaType, forHTTPHeaderField: "Content-Type")
        
        return firstly {
            sessionManager.dataTask(.promise, with: request)
        }.compactMap {
            return try JSONDecoder().decode(T.self, from: $0.data)
        }
    }
    
    /*
     * fetch data from the server. A GET to the chosen path with the defined parameters is sent to the Taxii-2.x server.
     * The TAXII server response is parsed then converted to a Taxii-2.x protocol resource.
     *
     * @param path the full path to the server resource
     * @param filters the filters to apply the the query
     * @param headerType with value = 0 (default) for request media type for stix resources,
     *                        value=1 for request media type for taxii resources
     * @return Promise
     */
    func fetchThisWithFilters<T: Decodable>(path: String, filters: TaxiiFilters, headerType: Int = 0, taxiiType: T.Type) -> Promise<T?> {
        let params: [String:String] = filters.asParameters()
     //   print("----> fetchThisWithFilters path: \(path)  params: \(params)")
        let mediaType = headerType == 1 ? mediaStix : mediaTaxii

        var components = URLComponents(string: path)!
        components.queryItems = params.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.addValue(taxiiVersion, forHTTPHeaderField: "version")
        request.addValue("Basic \(hash())", forHTTPHeaderField: "Authorization")
        request.addValue(mediaType, forHTTPHeaderField: "Accept")
        request.addValue(mediaType, forHTTPHeaderField: "Content-Type")
        
        return firstly {
            sessionManager.dataTask(.promise, with: request)
        }.compactMap {
            return try JSONDecoder().decode(T.self, from: $0.data)
        }
    }
    
    /*  
     * post data to the server. A POST to the chosen path is sent to the Taxii-2.x server.
     * The TAXII server response is parsed then converted to a Taxii-2.x protocol resource.
     *
     * @param path the full path to the server resource
     * @param json the JSON data
     * @return Promise
     */
    func postThis<T: Decodable>(path: String, jsonData: Data, taxiiType: T.Type) -> Promise<T?> {
        let url = URL(string: path)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(taxiiVersion, forHTTPHeaderField: "version")
        request.addValue("Basic \(hash())", forHTTPHeaderField: "Authorization")
        request.addValue(mediaTaxii, forHTTPHeaderField: "Accept")
        request.addValue(mediaStix, forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        return firstly {
            sessionManager.dataTask(.promise, with: request)
        }.compactMap {
            return try JSONDecoder().decode(T.self, from: $0.data)
        }
    }
    
    /*
     * fetch data from the server. A GET to the chosen path is sent to the Taxii-2.x server.
     * The TAXII server response is returned as raw Data.
     *
     * @param path the full path to the server resource
     * @param headerType with value = 0 (default) for request media type for stix resources,
     *                        value=1 for request media type for taxii resources
     * @return Promise
     */
    func fetchRaw(path: String, headerType: Int = 0) -> Promise<Data> {
    //    print("----> fetchRaw path: \(path)")
        let mediaType = headerType == 1 ? mediaStix : mediaTaxii
        let url = URL(string: path)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(taxiiVersion, forHTTPHeaderField: "version")
        request.addValue("Basic \(hash())", forHTTPHeaderField: "Authorization")
        request.addValue(mediaType, forHTTPHeaderField: "Accept")      
        request.addValue(mediaType, forHTTPHeaderField: "Content-Type")
        
        return firstly {
            sessionManager.dataTask(.promise, with: request)
        }.compactMap {
            return $0.data
        }
    }

}
