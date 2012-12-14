# Unigunkan

Unigunkan is a command line xcode project file modifier tool. Designed for Unity based projects.

It helps you automate building process of Unity project.

## Installation

    $ gem install unigunkan

## Usage

### Basic

    $ unigunkan /path/to/your/xcode/project/Unity-iPhone.xcodeproj
    
Please read the messages shown by this command.

### Options

To disable Retina 4 inch devices support,

    $ unigunkan /path/to/project/Unity-iPhone.xcodeproj --disable-retina-4inch-support

Add folder references,

    $ unigunkan /path/to/project/Unity-iPhone.xcodeproj --folder-refs=../../assetbundles
    
#### TestFlight SDK Integration

1. Download the latest TestFlightSDK.
2. Get the application token
3. Add --integrate-testflight-sdk option.

````
    $ unigunkan /path/to/project/Unity-iPhone.xcodeproj --integrate-testflight-sdk\
        --testflight-sdk ~/Downloads/testflight --testflight-application-token 12345-abc-123
````
    
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
