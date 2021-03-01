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
    
    static public var LAT: String = "lat"
    static public var LNG: String = "lng"
    static public var GEO_POINT: String = "geoPoint"
    
    public var lat, lng: Float
    
    init(lat: Float, lng: Float){
        self.lat = lat
        self.lng = lng
    }
}
