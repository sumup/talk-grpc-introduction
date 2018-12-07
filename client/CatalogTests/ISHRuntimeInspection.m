//
//  ISHRuntimeInspection.m
//  CatalogTests
//
//  Created by Stanislav Zahariev on 6.12.18.
//  Copyright © 2018 SumUp. All rights reserved.
//

#import "ISHRuntimeInspection.h"
#import <objc/runtime.h>

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}

NSMutableDictionary<NSString *, NSString *> *ISHPropertiesForClass(Class aClass) {
    NSCParameterAssert(aClass != NULL);

    NSMutableDictionary *results = [NSMutableDictionary new];

    if (aClass == NULL) {
        return results;
    }

    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(aClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(!propName) {
            continue;
        }
        const char *propType = getPropertyType(property);
        if (!propType) {
            continue;
        }
        NSString *propertyName = [NSString stringWithUTF8String:propName];
        NSString *propertyType = [NSString stringWithUTF8String:propType];
        [results setObject:propertyType forKey:propertyName];
    }
    free(properties);

    return results;
}
