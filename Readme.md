## Icons

Icon8: menu, share

handlebars templates/*.hbs -f tmp/gen/handlebars.js -k each -k if -k unless


## building

    rake p
    webpack


## Running

    rake p
    rake s

## Dependencies

    gem install snapshot deliver
    cordova prepare

## Making Snapshots

* $ snapshot init
* create a UITests target in the Xcode project
* copy SnapshotHelper.swift from lib into the UITests target
* copy DailyPoemUITests.swift from lib into the UITests target
* customize Snapfile
* $ snapshot
