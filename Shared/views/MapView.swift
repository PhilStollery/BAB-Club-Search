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
    
    var locationManager = CLLocationManager()
    func setupManager() {
      locationManager.desiredAccuracy = kCLLocationAccuracyReduced
      locationManager.requestWhenInUseAuthorization()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        setupManager()
        mapView.isRotateEnabled = false
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MKUserTrackingMode.none
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if view.annotations.count < 2 {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
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
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let latDelta:CLLocationDegrees = 0.5
            let lonDelta:CLLocationDegrees = 0.5
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
            mapView.setRegion(region, animated: false)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // this is our unique identifier for view reuse
            let identifier = "ClubDetails"

            // attempt to find a cell we can recycle
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            if annotationView == nil {
                // we didn't find one; make a new one
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                // allow this to show pop up information
                annotationView?.canShowCallout = true
                annotationView?.markerTintColor = UIColor.systemGreen

                // attach an information button to the view
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                // we have a view to reuse, so give it the new annotation
                annotationView?.annotation = annotation
            }
            
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

extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
}


