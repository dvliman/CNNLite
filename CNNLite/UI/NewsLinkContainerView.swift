import SwiftUI
import Foundation
import SwiftSoup
import TinyNetworking
import Request

var BASE_URL = "https://lite.cnn.io"


func fetchLinks() -> Request {
    return Request { Url(BASE_URL) }
}

func fetchNewsDetail(id: String) -> Request {
    return Request { Url(BASE_URL + id) }
}


// TODO: figure out way to compose optional, try? all the way from callers
func maybeParseLinks(_ data: Data?) -> [NewsLink] {
    if let _ = data {
        return parseLinks(data!)
    } else {
        return []
    }
}

func parseLinks(_ data: Data) -> [NewsLink] {
    let html: String = String.init(bytes: data, encoding: .utf8)!
    
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

func parseContent(_ acc: String, _ element: Element) throws-> String {
    let body = try! element.text()
    return acc + body + "\n\n"
}

func parseNewsDetail(id: String, data: Data) -> some View {
    let html: String = String.init(bytes: data, encoding: .utf8)!
    let doc: Document = try! SwiftSoup.parse(html)
    
    let title: String = try! doc.select("h2").text()
    let content: String = try! doc.select("#mount > div > div.afe4286c > div:nth-child(3)")
        .first()!
        .children()
        .reduce("", parseContent(_:_:))
    let updated: String = try! doc.select("#mount > div > div.afe4286c > div:nth-child(2)").text()

    return NewsDetailView(news: News(id: id, title: title, updated: updated, content: content))
}

struct NewsLinkContainerView: View {
    var placeholder: some View {
        Text("Couldn't talk to server")
    }
    
    var body: some View {
        RequestView(fetchLinks()) { data in
            self.buildNewsList(data)
            self.placeholder // spinning
        }
    }
    
    func buildNewsList(_ data: Data?) -> some View {
        NavigationView {
            List(maybeParseLinks(data)) { link in
                NavigationLink(destination: NewsDetailContainerView(link: link)) {
                    NewsLinkView(link: link)
                }
                .navigationBarTitle(Text("CNN News"), displayMode: .inline)
            }
        }
    }
}

struct NewsDetailContainerView: View {
    let link: NewsLink

    var placeholder: some View {
          Text("http-err-case")
    }

    var body: some View {
        RequestView(fetchNewsDetail(id: self.link.id)) { data in
            if data != nil {
                parseNewsDetail(id: self.link.id, data: data!)
            }
            self.placeholder
        }
    }
}

struct NewsDetailView: View {
    let news: News
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(news.title)
                    .font(.headline)
                    .bold()
                
                Text(news.updated)
                    .font(.subheadline)
                
                Divider()
                
                Text(news.content)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .padding(15)
   
        }
    }
}

struct NewsLinkContainerView_Previews: PreviewProvider {
    static var previews: some View {
        NewsDetailView(news: News.example)
    }
}
