//
//  HNClient-iOSTests.m
//  HNClient-iOSTests
//
//  Created by yuchan on 03/04/2015.
//  Copyright (c) 2014 yuchan. All rights reserved.
//

SpecBegin(InitialSpecs)

describe(@"these will pass", ^{
    
    it(@"can do maths", ^{
        expect(1).beLessThan(23);
    });
    
    it(@"can read", ^{
        expect(@"team").toNot.contain(@"I");
    });
});

SpecEnd
