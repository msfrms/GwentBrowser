//
//  MonitorTypes.swift
//  Card browser
//
//  Created by Radaev Mikhail on 30/11/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import Foundation
//https://github.com/zalmoxisus/mobx-remotedev/blob/master/src/monitorActions.js
internal enum MonitorTypes: String, Codable {
    case action = "ACTION"
    case dispatch = "DISPATCH"
    case `import` = "IMPORT"
    case `init` = "INIT"
    case start = "START"
    case stop = "STOP"    
    case undefined = "undefined"
}
