//
//  TinyNetworking.swift
//  CNNLite
//
//  Created by Hemanth Prasad on 1/1/20.
//  Copyright © 2020 David Liman. All rights reserved.
//

import Foundation
import TinyNetworking

extension Endpoint where A == String {
    public static func parseString(data: Data?, response: URLResponse?) -> Result<String, Error> {
        guard let data = data else { return .failure(NSError()) }
        return .success(String(data: data, encoding: .utf8)!)
    }
}
