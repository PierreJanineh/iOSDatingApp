//
//  GeoPoint.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 01/03/2021.
//

import Foundation
class GeoPoint {
    
    /*
        GeoPoint class in Server contains:
                      1. lat        float
                      2. lng        float
     */
    
    static public let LAT: String = "lat"
    static public let LNG: String = "lng"
    static public let GEO_POINT: String = "geoPoint"
    
    public var lat, lng: Float?
    
    init(lat: Float, lng: Float){
        self.lat = lat
        self.lng = lng
    }
    
    init(dictionary: Dictionary<String, Any>){
        if let _ = dictionary[GeoPoint.GEO_POINT] as? [String: Any] {
            if let lat = dictionary[GeoPoint.LAT] as? Float {
                self.lat = lat
            }
            if let lng = dictionary[GeoPoint.LNG] as? Float {
                self.lng = lng
            }
            
        }
    }
}
