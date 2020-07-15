//
//  About.swift
//  BAB Club Search
//
//  Created by Phil Stollery on 14/07/2020.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack{
            ZStack {
                Circle()
                    .foregroundColor(.accentColor)
                    .frame(width: 150, height: 150)
                Image("Gi")
            }
            Text("Thank you for using the app.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding([.top, .leading, .trailing], 20.0)
            Text("If you can't find your Dojo in the app please make sure your details are up-to-date on the BAB website. The Dojo needs to have a location associated with it.")
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding([.top, .leading, .trailing], 20.0)
            HStack(alignment: VerticalAlignment.center) {
                Image(systemName: "link.circle.fill")
                    .foregroundColor(.accentColor)
                Link(destination: URL(string: "http://bab.org.uk")!) {
                    Text("BAB.org.uk")
                }
            }
            .padding([.top, .leading, .trailing], 20.0)
            .font(.system(size: 22))
            Text("I made this for the love of Aikido and the hope that we can all get back into the Dojo soon. It was developed during the 2020 lockdown.")
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding([.top, .leading, .trailing], 20.0)
            Text("If you have any feedback or can help maintain the app, email me.")
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding([.top, .leading, .trailing], 20.0)
            HStack(alignment: VerticalAlignment.center) {
                Image(systemName: "envelope.fill")
                    .foregroundColor(.accentColor)
                Link(destination: URL(string: "mailto:sensei@bristol-ki-aikido.uk?subject=FEEDBACK:BAB%20Club%20Search%20iOS")!) {
                    Text("sensei@bristol-ki-aikido.uk")
                }
            }
            .padding([.top, .leading, .trailing], 20.0)
            .font(.system(size: 22))
            Spacer()
        }
        .navigationBarTitle(Text("About"), displayMode: .large)
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                AboutView()
            }
            NavigationView {
                AboutView()
            }.preferredColorScheme(.dark)
        }
    }
}
