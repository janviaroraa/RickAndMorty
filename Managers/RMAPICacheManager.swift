//
//  RMAPICacheManager.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 22/07/24.
//

import Foundation

/// Manages in-memory session scoped API caches
class RMAPICacheManager {

    private var cacheDictionary: [RMEndPoint: NSCache<NSString, NSData>] = [:]

    init() {
        setupCache()
    }

    // Setting up a separate cache for each section, i.e. different for character, episode, etc...
    private func setupCache() {
        RMEndPoint.allCases.forEach({ endPoint in
            cacheDictionary[endPoint] = NSCache<NSString, NSData>()
        })
    }

    func cachedResponse(for endPoint: RMEndPoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endPoint],
              let url else { return nil }

        return targetCache.object(forKey: url.absoluteString as NSString) as? Data
    }

    func setCacheResponse(for endPoint: RMEndPoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endPoint],
              let url else { return }

        targetCache.setObject(data as NSData, forKey: url.absoluteString as NSString)
    }

}
