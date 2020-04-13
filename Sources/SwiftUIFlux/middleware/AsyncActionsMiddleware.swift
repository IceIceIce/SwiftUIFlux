//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 27/06/2019.
//

import Foundation

public let asyncActionsMiddleware: Middleware<FluxState> = { action, state, dispatch in
    if let action = action as? AsyncAction {
        action.execute(state: state(), dispatch: dispatch)
    }
}
