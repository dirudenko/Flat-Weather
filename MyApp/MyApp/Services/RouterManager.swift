//
//  RouterManager.swift
//  MyApp
//
//  Created by Dmitry on 20.12.2021.
//

import Foundation

//protocol RouterProtocol {
//   associatedtype RoutingDestination: RoutingDestinationProtocol
//   func route(to destination: RoutingDestination)
//}
//
//enum ChatRoutingDestination: RoutingDestinationProtocol {
//   case viewChat(userId: String)
//   case startNewChat
//   // etc.
//}
//
//class ChatRouter: RouterProtocol {
//   associatedType RoutingDestination = ChatRoutingDestination
//   static let shared = ChatRouter()
//   func route(to destination: RoutingDestination) {
//      switch destination {
//         case .viewChat(let userId):
//            // navigate to the "view chat" screen for this user
//         case .startNewChat
//            // navigate to the "start new chat" screen
//      }
//   }
//}
