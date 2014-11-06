#import "HomeModel.h"
#import "User.h"

@interface HomeModel()
{
    NSMutableData *_downloadedData;
}
@end


@implementation HomeModel

- (void)downloadItems
{
    // Download json file
    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://demo.lundgrendesign.se/settleapp/db.php"];
    // Create the event
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    // Create the NSURLConnection
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

#pragma mark NSURLConnectionDataProtocol Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Initialize the data object
    _downloadedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the newly downloaded data
    [_downloadedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Create an array to store the users
    NSMutableArray *_users = [[NSMutableArray alloc] init];
    
    // Parse the JSON that came in
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    // Loop through Json objects, create question objects and add them to our questions array
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];
        
        // Create a new location object and set its props to JsonElement properties
        User *newUser = [[User alloc] init];
     //   newUser.id = jsonElement[@"Id"];
        newUser.username = jsonElement[@"Username"];
        newUser.name = jsonElement[@"Name"];
        newUser.surname = jsonElement[@"Surname"];
        newUser.email = jsonElement[@"Email"];
        newUser.Password = jsonElement[@"Password"];
        
        // Add this question to the users array
        [_users addObject:newUser];
    }
    
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate)
    {
        [self.delegate itemsDownloaded:_users];
    }
}
@end
