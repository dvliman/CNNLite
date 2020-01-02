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
    
    static func parse(_ html: String) -> Result<[NewsLink], Error> {
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let links: Elements = try doc.select("li")
           
            return .success(try links.array().reduce(into: []) {
                let href = try $1.child(0).attr("href")
                let text = try $1.text()
                return $0.append(NewsLink(id: href, title: text))
            })
        } catch {
            return .failure(error)
        }
    }
}

extension NewsDetail {
    static func parse(_ html: String) -> Result<NewsDetail, Error> {
        do {
            let doc = try SwiftSoup.parse(html)
            let title: String = try doc.select("h2").text()
            let content: String = try doc.select("#mount > div > div.afe4286c > div:nth-child(3)")
                .first()!
                .children()
                .reduce("") { $0 + (try $1.text()) + "\n\n" }
            let updated: String = try doc.select("#mount > div > div.afe4286c > div:nth-child(2)").text()
            return .success(NewsDetail(title: title, updated: updated, content: content))
        } catch {
            return .failure(error)
        }
    }
}
