//
//  MapView.swift
//  BAB Club Search
//
//  Created by Phil Stollery on 16/07/2020.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetails: Bool
    @Binding var annotations: [MKPointAnnotation]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.isRotateEnabled = false
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if view.annotations.count < 2 {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        } else if centerCoordinate != view.centerCoordinate {
            let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: 25000, longitudinalMeters: 25000)
            view.setRegion(region, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // this is our unique identifier for view reuse
            let identifier = "ClubDetails"

            // attempt to find a cell we can recycle
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            if annotationView == nil {
                // we didn't find one; make a new one
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                // we have a view to reuse, so give it the new annotation
                annotationView?.annotation = annotation
            }
            
            // Colour all the dojos green, but leave the uses location as a red marker
            // The title will ebe Approximate Location or My Location, so jyst check the end of the string
            let title = (annotationView?.annotation?.title)!! as String
            if title.suffix(8) != "Location" {
                annotationView?.markerTintColor = UIColor.systemGreen
            }
            
            // allow this to show pop up information
            annotationView?.canShowCallout = true

            // attach an information button to the view
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            // whether it's a new view or a recycled one, send it back
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let placemark = view.annotation as? MKPointAnnotation else { return }

            parent.selectedPlace = placemark
            parent.showingPlaceDetails = true
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    static public func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
