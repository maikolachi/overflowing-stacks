//
//  ContentView.swift
//  Overflowing Stacks SUI
//
//  Created by Faisal Bhombal on 1/18/20.
//  Copyright © 2020 Faisal Bhombal. All rights reserved.
//

import SwiftUI

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

struct ContentView: View {
    
    @ObservedObject private var viewModel: MasterViewViewModel = MasterViewViewModel()
    
    @Environment(\.managedObjectContext)
    var viewContext   
 
    var body: some View {
        NavigationView {
            MasterView(viewModel: self.viewModel)
                .navigationBarTitle(Text("Recent Questions"))
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(
                        action: {
                            withAnimation {
                                self.viewModel.fetchRecentQuestions(self.viewContext)
                                
                            }
                        }
                    ) {
                        Image(systemName: "arrow.counterclockwise.icloud")
                    }
                )
            Text("Detail view content goes here")
                .navigationBarTitle(Text("Detail"))
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    
    @ObservedObject var viewModel: MasterViewViewModel
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Event.timestamp, ascending: true)],
        animation: .default)
    var events: FetchedResults<Event>

//    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "key", ascending: true)],
//                  predicate: NSPredicate(format: "key == %@", RegistryKey.duration.rawValue),
//                  animation: .default)
//    var duration: FetchedResults<Registry>
    
    @Environment(\.managedObjectContext)
    var viewContext

    var body: some View {
        List {
            ForEach( viewModel.questions ) { (question) in
                NavigationLink(
                    destination: DetailView(question: question)
                ) {
                    Text(question.title)
//                    Text("\(event.timestamp!, formatter: dateFormatter)")
                }
            }.onDelete { indices in
                self.events.delete(at: indices, from: self.viewContext)
            }
        }
    }
}

struct DetailView: View {
    let question: SOVFQuestionDataModel
//    @ObservedObject var event: Event

    var body: some View {
        Text(question.title)
            .navigationBarTitle(Text("\(question.title)"))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
