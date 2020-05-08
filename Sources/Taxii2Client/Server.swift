//
//  Server.swift
//  Taxii2Client
//
//  Created by Ringo Wathelet on 2020/03/21.
//  Copyright © 2020 Ringo Wathelet. All rights reserved.
//

import Foundation
import PromiseKit

/*
 * This Endpoint provides general information about a Taxii-2.0 Server, including the advertised API Roots.
 *
 * @param path    the path to the TAXII server discovery endpoint, default "/taxii/"
 * @param conn    the connection to the Taxii-2.x server
 */
class Server {
    
    let path: String
    let conn: TaxiiConnection
    
    init(conn: TaxiiConnection) {
        if conn.taxiiVersion.trim() == "2.1" {
            self.path = TaxiiConnection.withLastSlash("/taxii2/")
            self.conn = conn
        } else {
            self.path = TaxiiConnection.withLastSlash("/taxii/")
            self.conn = conn
        }
    }
    
    func discovery() -> Promise<TaxiiDiscovery?> {
        return conn.fetchThis(path: conn.baseURL() + path, taxiiType: TaxiiDiscovery.self)
    }
    
    // returns the discovered api-root strings
    func getApirootStrings() -> Promise<[String]> {
        return firstly {
            self.discovery()
        }.compactMap {
            return $0?.api_roots
        }
    }
    
    // returns the discovered api-roots
    func getApiroots() -> Promise<[TaxiiApiRoot]> {
        return firstly {
            self.discovery()
        }.then { disc -> Promise<[TaxiiApiRoot]> in   // <-- important
            if let roots = disc?.api_roots {
                return self.getALlRoots(from: roots)
            } else {
                return Promise<[TaxiiApiRoot]> { seal in
                    seal.resolve(.fulfilled([TaxiiApiRoot]()))
                }
            }
        }
    }
    
    private func getALlRoots(from disc: [String]) -> Promise<[TaxiiApiRoot]> {
        when(resolved: disc.map { ApiRoot(api_root: $0, conn: self.conn).get().compactMap{$0} }).map { results in
            var arr = [TaxiiApiRoot]()
            results.forEach { result in
                switch result {
                    case .fulfilled(let res): arr.append(res)
                    case .rejected(let error): print("=====> Action partially failed: \(error)")
                }
            }
            return arr
        }
    }
    
}

extension Server {
    
    // returns the discovered api-roots as a dictionary api_root_url -> TaxiiApiRoot
    func getApirootsDict() -> Promise<[String : TaxiiApiRoot]> {
        return firstly {
            self.discovery()
        }.then { disc -> Promise<[String : TaxiiApiRoot]> in   // <-- important
            if let roots = disc?.api_roots {
                return self.getRootsDict(from: roots)
            } else {
                return Promise<[String : TaxiiApiRoot]> { seal in
                    seal.resolve(.fulfilled([:]))
                }
            }
        }
    }
    
    private func getRootsDict(from disc: [String]) -> Promise<[String : TaxiiApiRoot]> {
        when(resolved: disc.map { ApiRoot(api_root: $0, conn: self.conn).get().compactMap{$0} }).map { results in
            var dict = [String : TaxiiApiRoot]()
            var k = 0
            results.forEach { result in
                switch result {
                case .fulfilled(let res):
                    dict[disc[k]] = res
                case .rejected(let error):
                    print("=====> Action partially failed: \(error)")
                }
                k += 1
            }
            return dict
        }
    }
    
}
