//
//  CustomAnnotation.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/13/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import MapKit


/// This protocol doesn't extend `MKAnnotation` in any way, but it
/// will allow us to distinguish our own location annotations
/// from MapKit's own.
protocol CustomAnnotation: MKAnnotation {}
