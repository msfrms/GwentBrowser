//
//  ChannelTypes.swift
//  Card browser
//
//  Created by Radaev Mikhail on 30/11/2019.
//  Copyright © 2019 Alexey Demedeckiy. All rights reserved.
//

import Foundation

// see: https://github.com/zalmoxisus/remotedev-server/blob/master/lib/worker.js
internal enum ChannelTypes: String {
    case log = "log"
    case respond = "respond"
    case report = "report" // for InstrumentTypes.export

    static func dispatch(id: String) -> String {
        "sc-\(id)"
    }
}
