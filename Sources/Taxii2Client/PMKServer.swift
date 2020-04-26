//
//  PMKServer.swift
//  Taxii2Swift
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
class PMKServer {
    
    let path: String
    let conn: PMKNetConnection
    
    // "/taxii2/" for taxii-2.1
    init(path: String = "/taxii/", conn: PMKNetConnection) {
        self.path = PMKNetConnection.withLastSlash(path)
        self.conn = conn
    }
    
    func discovery() -> Promise<TaxiiDiscovery?> {
        return conn.fetchThis(path: conn.baseURL() + path, taxiiType: TaxiiDiscovery.self)
    }
    
    // returns the discovered api-root strings 
    func getApiroots() -> Promise<[String]> {
        return firstly {
            self.discovery()
        }.compactMap {
            return $0?.api_roots
        }
    }
    
}
