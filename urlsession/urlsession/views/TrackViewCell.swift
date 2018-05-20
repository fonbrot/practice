//
//  TrackViewCell.swift
//  urlsession
//
//  Created by 1 on 17/05/2018.
//  Copyright © 2018 av. All rights reserved.
//

import UIKit

protocol TrackViewCellDelegate {
    func downloadTapped(_ cell: TrackViewCell)
    func playTapped(_ cell: TrackViewCell)
    func pauseTapped(_ cell: TrackViewCell)
    func cancelTapped(_ cell: TrackViewCell)
}

class TrackViewCell: UITableViewCell {
    
    var delegate: TrackViewCellDelegate?
    let queryService = QueryService()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBAction func downloadTapped(_ sender: UIButton) {
        delegate?.downloadTapped(self)
    }
    
    @IBAction func playTapped(_ sender: UIButton) {
        delegate?.playTapped(self)
    }
    
    @IBAction func pauseTapped(_ sender: UIButton) {
        delegate?.pauseTapped(self)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        delegate?.cancelTapped(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(track: Track, download: Download?) {
        var hideDownloadUI = true
        
        nameLabel.text = track.trackName
        artistLabel.text = track.artistName
        queryService.getImage(imageURL: track.artworkUrl30) { image in
            self.trackImage.image = image
        }
        downloadButton.isHidden = track.saved
        playButton.isHidden = !track.saved
        
        if let download = download {
            downloadButton.isHidden = true
            hideDownloadUI = false
            let title = download.isDownloading ? "Pause" : "Resume"
            pauseButton.setTitle(title, for: .normal)
            progressLabel.text = download.isDownloading ? "Downloading" : "Paused"
        }
        
        pauseButton.isHidden = hideDownloadUI
        cancelButton.isHidden = hideDownloadUI
        progressLabel.isHidden = hideDownloadUI
        progressView.isHidden = hideDownloadUI
    }
    
    func updateProgress(progress: Float, totalSize: String) {
        progressView.progress = progress
        progressLabel.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
    }
}
