//
//  SearchObserver.swift
//  MyApp
//
//  Created by Dmitry on 25.01.2022.
//

import Foundation

protocol SubcribeSearch: AnyObject {
  func delete(at index: Int)
}

class SearchObserver {
  
  var observers = [SubcribeSearch]()
  
  func receiveType (index: Int) {
    notifyObserver(index: index)
  }
  
  func register(observer: SubcribeSearch){
    observers.append(observer)
  }
  
  func notifyObserver(index: Int){
    for observer in observers {
      observer.delete(at: index)
    }
  }
  
  func deregister() {
    observers.removeAll()
  }
}

//struct WeakSubscriber {
//  weak var value: SubcribeSettings?
//}
