//
//  BackgroundVideoView.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 19/07/22.
//

import SwiftUI
import AVKit

class LoopingPlayerView: UIView {
    
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    
    init(videoName: String, player: AVQueuePlayer, videoGravity: AVLayerVideoGravity = .resizeAspectFill) {
        super.init(frame: .zero)
        
        guard let file = Bundle.main.url(forResource: videoName, withExtension: "mov") else { return }
        let asset = AVAsset(url: file)
        let item = AVPlayerItem(asset: asset)
        
        player.isMuted = true // just in case
        playerLayer.player = player
        playerLayer.videoGravity = videoGravity
        layer.addSublayer(playerLayer)
        
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}

struct VideoPlayerView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    let videoName: String
    let player: AVQueuePlayer
    
    func makeUIView(context: Context) -> UIView {
        return LoopingPlayerView(videoName: videoName, player: player)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Do nothing
    }
}

struct BackgroundVideoView: View {
    
    @State private var player = AVQueuePlayer()
    @ObservedObject var musicViewModel = MusicViewModel()
    
    var body: some View {
        GeometryReader { geo in
            VideoPlayerView(videoName: musicViewModel.selectedMusic?.videoName ?? "", player: player)
                .aspectRatio(contentMode: .fill)
                .frame(width: geo.size.width, height: geo.size.height)
                .onAppear {
                    player.play()
                }
                .onDisappear {
                    player.pause()
                }
                .onChange(of: musicViewModel.selectedMusic) { newValue in
                    guard let url = Bundle.main.url(forResource: newValue?.videoName ?? "", withExtension: "mov") else { return }
                    player.replaceCurrentItem(with: AVPlayerItem(url: url))
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    player.pause()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    player.play()
                }
        }
        .ignoresSafeArea()
    }
}
