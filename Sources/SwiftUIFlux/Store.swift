//
//  AppState.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final public class Store<StoreState: FluxState>: ObservableObject {
    @Published public var state: StoreState

    private var dispatchFunction: DispatchFunction!
    private let reducer: Reducer<StoreState>
    
    public init(reducer: @escaping Reducer<StoreState>,
                middleware: [Middleware<StoreState>] = [],
                state: StoreState) {
        self.reducer = reducer
        self.state = state
        
        var middleware = middleware
        middleware.append(asyncActionsMiddleware)
        self.dispatchFunction = { [weak self] action in
            let dispatch: (Action) -> Void = { [weak self] in self?.dispatchFunction($0) }
            middleware.forEach { $0(action, self?.state, dispatch) }
            self?._dispatch(action: action)
        }
    }

    public func dispatch(action: Action) {
        DispatchQueue.main.async {
            self.dispatchFunction(action)
        }
    }
    
    private func _dispatch(action: Action) {
        state = reducer(state, action)
    }
}
