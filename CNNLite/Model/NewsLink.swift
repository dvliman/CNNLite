//
//  NewsLink.swift
//  CNNLite
//
//  Created by Hemanth Prasad on 1/1/20.
//  Copyright © 2020 David Liman. All rights reserved.
//

import TinyNetworking
import SwiftSoup
import Foundation

struct NewsLink: Decodable, Identifiable {
    let id: String    //=> /en/article/h_68985f0b7dd65edeb62e617d70ddbd68
    let title: String //=> Daughter-in-law of LSU coach among the 5 killed in a small plane crash ...
    
    static var endpoint: Endpoint<[NewsLink]> = Endpoint<String>(.get,
                                                                 url: URL(string: "https://lite.cnn.io")!,
                                                                 accept: .xml,
                                                                 parse: Endpoint.parseString)
                                                .compactMap(parse)
}
