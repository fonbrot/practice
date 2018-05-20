//
//  ViewController.swift
//  urlsession
//
//  Created by 1 on 16/05/2018.
//  Copyright © 2018 av. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class ViewController: UITableViewController {
    
    let trackCell = "trackCell"
    
    let queryService = QueryService()
    let downloadService = DownloadService()
    
    var tracks = [Track]()
    
    var searchController: UISearchController!
    
    var player: AVAudioPlayer?
    
    private lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadService.downloadSession = downloadSession
        
        configureSearchController()
        
        let nib = UINib(nibName: "TrackViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: trackCell)
        
        queryService.getTracks(text: "madonna") { results in
            self.tracks = results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: trackCell, for: indexPath) as! TrackViewCell
        let track = tracks[indexPath.row]
        
        cell.delegate = self
        cell.configure(track: track, download: downloadService.downloads[track.previewUrl])
        return cell
    }
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
    }
    
    private func playTrack(_ track: Track) {
        if let localURL = trackLocalURL(track.previewUrl) {
            do {
                player = try AVAudioPlayer(contentsOf: localURL)
                player?.play()
            } catch {
                print(error)
            }
        }
    }
    
    private func trackLocalURL(_ trackURL: URL) -> URL? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentsURL.appendingPathComponent(trackURL.lastPathComponent)
    }
    
    private func reloadRow(index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
        queryService.getTracks(text: text) { results in
            self.tracks = results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.resignFirstResponder()
    }
}

extension ViewController: TrackViewCellDelegate {
    func downloadTapped(_ cell: TrackViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let track = tracks[indexPath.row]
        downloadService.startDownload(track: track)
        reloadRow(index: indexPath.row)
    }
    
    func playTapped(_ cell: TrackViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let track = tracks[indexPath.row]
        playTrack(track)
    }
    
    func pauseTapped(_ cell: TrackViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let track = tracks[indexPath.row]
        guard let download = downloadService.downloads[track.previewUrl] else { return }
        if download.isDownloading {
        downloadService.pauseDownload(track: track)
        } else {
            downloadService.resumeDownload(track: track)
        }
        reloadRow(index: indexPath.row)
    }
    
    func cancelTapped(_ cell: TrackViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let track = tracks[indexPath.row]
        downloadService.cancelDownload(track: track)
        reloadRow(index: indexPath.row)
    }
}

extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let taskURL = downloadTask.originalRequest?.url, let download = downloadService.downloads[taskURL], let savedURL = trackLocalURL(taskURL) else { return }
        
        downloadService.downloads[taskURL] = nil
        print(savedURL)
        do {
            try FileManager.default.removeItem(at: savedURL)
            try FileManager.default.copyItem(at: location, to: savedURL)
            download.track.saved = true
        } catch {
            print(error)
        }
        if let index = tracks.index(of: download.track) {
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        
        if let taskURL = downloadTask.originalRequest?.url, let download = downloadService.downloads[taskURL], let index = tracks.index(of: download.track) {
            download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
            DispatchQueue.main.async {
                if let trackCell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TrackViewCell {
                    
                    trackCell.updateProgress(progress: download.progress, totalSize: totalSize)
                }
            }
        }
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                completionHandler()
                }
        }
    }
}
