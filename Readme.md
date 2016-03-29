## Icons

Icon8: menu, share

handlebars templates/*.hbs -f tmp/gen/handlebars.js -k each -k if -k unless


## building

    rake p
    webpack


## Running

    rake p
    rake s

## Making Snapshots

* $ gem install snapshot
* $ snapshot init
* create a UITests target in the Xcode project
* copy SnapshotHelper.swift from lib into the UITests target
* copy DailyPoemUITests.swift from lib into the UITests target
* customize Snapfile
* $ snapshot
