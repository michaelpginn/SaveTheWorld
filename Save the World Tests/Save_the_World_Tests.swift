//
//  Save_the_World_Tests.swift
//  Save the World Tests
//
//  Created by Michael Ginn on 9/7/19.
//  Copyright © 2019 Michael Ginn. All rights reserved.
//

import XCTest
@testable import Save_the_World


class Save_the_World_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSignup(){
        let api = ApiService()
        
        let res = api.signUp(username: "shouldFail", completion:{ (success) in
            XCTAssert(!success)
        })
        
        
    }

}
