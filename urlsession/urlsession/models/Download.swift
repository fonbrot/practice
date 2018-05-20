//
//  Download.swift
//  urlsession
//
//  Created by 1 on 18/05/2018.
//  Copyright © 2018 av. All rights reserved.
//

import Foundation

class Download {
    var track: Track
    
    
    init(track: Track) {
        self.track = track
    }
    
    var task: URLSessionDownloadTask?
    var isDownloading = false
    var resumeData: Data?
    
    var progress: Float = 0
}
