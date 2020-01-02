//
//  Resource.swift
//  CNNLite
//
//  Created by Hemanth Prasad on 1/1/20.
//  Copyright © 2020 David Liman. All rights reserved.
//

import TinyNetworking
import Combine
import Dispatch
import Foundation
import SwiftUI

final class Resource<A>: ObservableObject {
    let endpoint: Endpoint<A>
    @Published var result: Result<A, Error>?
    
    init(endpoint: Endpoint<A>) {
        self.endpoint = endpoint
        reload()
    }
    
    func reload() {
        URLSession.shared.load(endpoint) { result in
            DispatchQueue.main.async {
                self.result = result
            }
        }
    }
    
    #if DEBUG
        init(endpoint: Endpoint<A>, value: A) {
            self.endpoint = endpoint
            self.result = .success(value)
        }
    #endif
}

protocol LoadingView: View {
    init()
}

protocol ErrorView: View {
    init(error: Error)
}

protocol ContentView: View {
    associatedtype A
    init(content: A)
}

struct ResourceView<A, C, L, E>: View where C: ContentView, L: LoadingView, E: ErrorView, C.A == A {
    @ObservedObject var resource: Resource<A>

    init(endpoint: Endpoint<A>, view: C.Type) {
        self.resource = Resource(endpoint: endpoint)
    }
    
    var body: some View {
        return getBody(result: resource.result)
    }
    
    func getBody(result: Result<A, Error>?) -> some View {
        guard let result = result else {
            return AnyView(L())
        }
        
        switch result {
        case let .success(value):
            return AnyView(C(content: value))
        case let .failure(error):
            return AnyView(E(error: error))
        }
    }
}

extension ResourceView where E == AnyErrorView, L == AnyLoadingView {
    init(_ endpoint: Endpoint<A>, view: C.Type) {
        self.resource = Resource(endpoint: endpoint)
    }
    
    static func makeView(_ endpoint: Endpoint<A>, view: C.Type) -> some View {
        return AnyView(ResourceView(endpoint: endpoint, view: view))
    }
}

struct AnyErrorView: ErrorView {
    let error: Error
    
    init(error: Error) {
        self.error = error
    }
    
    var body: some View {
        Text("Failed to connect to server:\n\(error.localizedDescription)")
    }
}


struct AnyLoadingView: LoadingView {
    var body: some View {
        Text("Loading...")
    }
}
