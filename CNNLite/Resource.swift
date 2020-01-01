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

final class Resource<A>: ObservableObject {
    let didChange = PassthroughSubject<A?, Never>()
    let endpoint: Endpoint<A>
    var value: A? {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self.value)
            }
        }
    }
    
    init(endpoint: Endpoint<A>) {
        self.endpoint = endpoint
        reload()
    }
    
    func reload() {
        URLSession.shared.load(endpoint) { result in
            self.value = try? result.get()
        }
    }
}
