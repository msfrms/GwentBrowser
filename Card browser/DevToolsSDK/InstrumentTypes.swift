//
//  InstrumentTypes.swift
//  Card browser
//
//  Created by Radaev Mikhail on 30/11/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import Foundation

// see: https://github.com/zalmoxisus/redux-devtools-instrument/blob/master/src/instrument.js
// see js implementation: https://github.com/zalmoxisus/mobx-remotedev/blob/master/src/monitorActions.js
internal enum InstrumentTypes: String {
    case perform = "PERFORM_ACTION"
    case reset = "RESET"
    case rollback = "ROLLBACK"
    case commit = "COMMIT"
    case sweep = "SWEEP"
    case toggle = "TOGGLE_ACTION"
    case jumpToState = "JUMP_TO_STATE"
    case jumpToAction = "JUMP_TO_ACTION"
    case export = "EXPORT"
}
