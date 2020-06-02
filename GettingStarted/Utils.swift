//
//  Utils.swift
//  GettingStarted
//
//  Created by Paul Ardeleanu on 20/11/2019.
//  Copyright © 2019 Nexmo. All rights reserved.
//

import Foundation
import NexmoClient


extension NXMConnectionStatus {
    func description() -> String {
        switch self {
        case .connected:
            return "Connected"
        case .connecting:
            return "Connecting"
        case .disconnected:
            return "Disconnected"
        @unknown default:
            return "Unknown"
        }
    }
}

extension NXMConnectionStatusReason {
    func description() -> String {
        switch self {
        case .unknown:
            return "Unknown"
        case .login:
            return "Login"
        case .logout:
            return "Logout"
        case .tokenRefreshed:
            return "Token refreshed"
        case .tokenInvalid:
            return "Token invalid"
        case .tokenExpired:
            return "Token expired"
        case .terminated:
            return "Terminated"
        case .userNotFound:
            return "User not found"
        @unknown default:
            return "Unknown"
        }
    }
}

extension NXMEventType {
    func description() -> String {
        switch self {
        case .general:
            return "General"
        case .custom:
            return "Custom"
        case .text:
            return "Text"
        case .image:
            return "Image"
        case .messageStatus:
            return "Message Status"
        case .textTyping:
            return "textTyping"
        case .media:
            return "Media"
        case .mediaAction:
            return "Media action"
        case .member:
            return "Member"
        case .sip:
            return "SIP"
        case .DTMF:
            return "DTMF"
        case .legStatus:
            return "Leg Status"
        @unknown default:
            return "Unknown"
        }
    }
}
