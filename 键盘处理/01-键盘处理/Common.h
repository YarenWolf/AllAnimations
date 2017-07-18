// 英文字母、数字、_
#define kInitH(name) \
- (id)initWithDict:(NSDictionary *)dict; \
+ (id)name##WithDict:(NSDictionary *)dict;

#define kInitM(name) \
+ (id)name##WithDict:(NSDictionary *)dict \
{ \
    return [[self alloc] initWithDict:dict]; \
}