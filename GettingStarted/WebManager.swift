//
//  WebManager.swift
//  GettingStarted
//
//  Created by Thomas Richardson on 28/05/2020.
//  Copyright © 2020 Nexmo. All rights reserved.
//

import Foundation
import Alamofire
struct WebManager {
    
    
    static func fetchConversations() {
        
        let jwt = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1OTA1OTYyMzcsImp0aSI6Ijg4YjExOTQwLWEwMzUtMTFlYS1iNjM1LWY5Y2NlZTk0ZDhlZCIsImV4cCI6MTU5MDY4MjYzNywiYWNsIjp7InBhdGhzIjp7Ii8qL3VzZXJzLyoqIjp7fSwiLyovY29udmVyc2F0aW9ucy8qKiI6e30sIi8qL3Nlc3Npb25zLyoqIjp7fSwiLyovZGV2aWNlcy8qKiI6e30sIi8qL2ltYWdlLyoqIjp7fSwiLyovbWVkaWEvKioiOnt9LCIvKi9hcHBsaWNhdGlvbnMvKioiOnt9LCIvKi9wdXNoLyoqIjp7fSwiLyova25vY2tpbmcvKioiOnt9fX0sImFwcGxpY2F0aW9uX2lkIjoiNzI5NWZhODYtNDYxMS00NzM2LWE2NmYtOTExN2I1ODUwYmRhIiwic3ViIjoiVG9tIn0.tN7mLM7rJrCaK1Q5VE_JgDNt9StAK0RX8cHsEHfWNhm7TCdWwMPHffs_D3I5wzwAFX3LxYNENEg1XsM0Pk2YcRW2o0qUfORBj5D4vU_zDNvARVNtZvG5uT41EvnvZmByYMsuFdlF_WjtXDo7XPj5_UwkI3twjQ-PmvokHWUxPo04w60-8EksoR-69BjVtNMIdqEqzqsqkrcGUIeZkd_2QLoti__t35MVfDQeeS6Cb601rXjUrznoXewR39mJspyJnDrHRG-bzCTi0sx5jFl21_u201OqKEIummgcvp-7gOz7uBTmdR4nFE6MKQEnAt0LmCXXsnnYBbxIqYzcjypGew"
        
        let uuid = "USR-8e89e1e8-e9ab-44f3-bf22-6bfe1f0b9e79"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + jwt,
            "Content-Type": "application/json"
        ]
        
        let endpoint = "https://api.nexmo.com/beta/users/\(uuid)/conversations"
        
        AF.request(endpoint, headers: headers).responseJSON { response in
            debugPrint(response)
        }
    }
    
}
