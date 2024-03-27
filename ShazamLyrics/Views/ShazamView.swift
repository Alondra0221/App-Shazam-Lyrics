//
//  ShazamView.swift
//  ShazamLyrics
//
//  Created by Alondra García Morales on 26/03/24.
//

import SwiftUI

struct ShazamView: View {
    
    @StateObject private var shazam = ShazamViewModel()
    var body: some View {
        ZStack{
            
            NavigationView{
                VStack(){
                   
                    Spacer()
                    if shazam.recording{
                        ProgressView()
                    }
                    AsyncImage(url: shazam.shazamModel.album){ image in
                        image
                            .resizable()
                            .scaledToFit()
                            .ignoresSafeArea(.all)
                    }placeholder: {
                        EmptyView()
                    }
                    
                    Text(shazam.shazamModel.title ?? "Sin titulo").font(.title).bold().foregroundStyle(.white)
                    Text(shazam.shazamModel.artist ?? "Sin artista").font(.title2).bold().padding(.bottom,40).foregroundStyle(.white)
                    Spacer()
                    VStack(alignment: .center, spacing: 70){
                        Button(action:{
                            shazam.startListening()
                        }, label:{
                            Image("ShazamIcon")
                        }).shadow(radius: 5)
                        
                        NavigationLink(destination: LyricsView(artist: shazam.shazamModel.artist ?? "Sin artista", title: shazam.shazamModel.title ?? "Sin titulo")){
                            Label("Ver Letra", systemImage: "music.note")
                            //Image(systemName: "music.note").font(.title2)
                            //Text("Ver Letra")
                                
                        }.controlSize(.large)
                                .shadow(radius: 3)
                                .tint(.white)
                                .bold()
                                //.padding(.leading, 320)
                                //.padding(.top, -50)
                    }.padding(.bottom, 150)
                    
                   
                    
                    Spacer()

                }.padding(.top, 40)
                    .navigationTitle("Shazam Lyrics")
                    
            }
        }.background(.black)
    }
}

#Preview {
    ShazamView()
}
