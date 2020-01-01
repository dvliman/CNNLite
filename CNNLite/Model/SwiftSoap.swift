//
//  SwiftSoap.swift
//  CNNLite
//
//  Created by Hemanth Prasad on 1/1/20.
//  Copyright © 2020 David Liman. All rights reserved.
//

import Foundation
import SwiftSoup

extension NewsLink {
    static func parseLinks(_ html: String) -> [NewsLink] {
        // TODO: figure out syntax for
        // SwiftSoup.parse.map(::select("li)).reduce(xs, { child(0).attr("href"), text() }) => [NewsLink]
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let links: Elements = try doc.select("li")
           
            return try links.array().map({ link in
                let href = try link.child(0).attr("href")
                let text = try link.text()
                return NewsLink(id: href, title: text)
            })
     

        } catch Exception.Error(let type, let message) {
            print(type)
            print(message)
            return []
            
        } catch {
            print("error")
            return []
        }
    }
}
