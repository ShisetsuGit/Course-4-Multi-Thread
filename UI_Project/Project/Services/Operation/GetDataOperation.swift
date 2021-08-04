//
//  GetDataOperation.swift
//  UI_Project
//
//  Created by Shisetsu on 04.08.2021.
//

import Foundation
import Alamofire

class GetDataOperation: AsyncOperation {

    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    private var request: DataRequest
    var data: Data?
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
            print("Request Finished")
        }
    }
    
    init(request: DataRequest) {
        self.request = request
    }
    
}
