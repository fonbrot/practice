//
//  DownloadService.swift
//  urlsession
//
//  Created by 1 on 17/05/2018.
//  Copyright © 2018 av. All rights reserved.
//

import Foundation

class DownloadService {
    var downloadSession: URLSession!
    
    var downloads = [URL: Download]()
    
    func startDownload(track: Track) {
        let download = Download(track: track)
        download.task = downloadSession.downloadTask(with: track.previewUrl)
        download.task!.resume()
        download.isDownloading = true
        downloads[track.previewUrl] = download
    }
    
    func pauseDownload(track: Track) {
        if let download = downloads[track.previewUrl] {
            download.task?.cancel(byProducingResumeData: { data in
                download.resumeData = data
            })
            download.isDownloading = false
        }
    }
    
    func resumeDownload(track: Track) {
        guard let download = downloads[track.previewUrl] else { return }
        if let resumeData = download.resumeData {
            download.task = downloadSession.downloadTask(withResumeData: resumeData)
        } else {
            download.task = downloadSession.downloadTask(with: track.previewUrl)
        }
        download.task?.resume()
        download.isDownloading = true
    }
    
    func cancelDownload(track: Track) {
        if let download = downloads[track.previewUrl], download.isDownloading {
            download.task?.cancel()
            downloads[track.previewUrl] = nil
        }
    }
}
